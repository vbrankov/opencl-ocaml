open Bigarray
open Opencl

let device, context, queue =
  let platforms = Cl.get_platform_ids () in
  let platform_idx = try int_of_string (Sys.getenv "CL_PLATFORM_IDX") with _ -> 0 in
  let platform = List.nth platforms platform_idx in
  let devices = Cl.get_device_ids platform [Cl.Device_type.ALL] in
  let device_idx = try int_of_string (Sys.getenv "CL_DEVICE_IDX") with _ -> 0 in
  let device = List.nth devices device_idx in
  let context = Cl.create_context [] [device] in
  let queue = Cl.create_command_queue context device [] in
  device, context, queue

let create_kernel name source =
  let program = Cl.create_program_with_source context [source] in
  let print_build_log () =
    let build_log = Cl.get_program_build_info program device
      Cl.Program_build_info.build_log
    in
    Format.printf "%s@." build_log;
    let build_status = Cl.get_program_build_info program device
      Cl.Program_build_info.build_status
    in
    Format.printf "%s@." (Cl.Build_status.to_string build_status)
  in
  begin try
    Cl.build_program program [device] "";
    print_build_log ()
  with (Cl.Cl_error cl_error) as exn ->
    print_build_log ();
    Format.printf "%s@." (Cl.Cl_error.to_string cl_error);
    raise exn
  end;
  Cl.create_kernel program name

let create_buffer len = Cl.create_buffer context Cl.Mem_flags.([READ_WRITE])
  (Cl.Buffer_contents.SIZE (Bigarray.float64, len))

let go =
  let ng = 2 in
  let nw = 1 in
  let kernel = create_kernel "sync" ("
#define NG " ^ string_of_int ng ^ "
#define NW " ^ string_of_int nw ^ "
void global_barrier(__global int* sync) {
  bool stay = true;
  int syncid = sync[get_global_id(0)];
  sync[get_global_id(0)] = syncid + 1;
  barrier(CLK_GLOBAL_MEM_FENCE);
  while (stay) {
    stay = true;
    for (int g = 0; g < NG; g++) {
      stay = stay || sync[g] <= syncid;
      printf(\"%d\\n\", sync[g]);
    }
    printf(\"stay %d %d %d\\n\", stay, get_global_id(0), syncid);
  }
}
__kernel void sync(
  __global int* a,
  __global int* sync)
{
  const int gid = get_group_id(0);
  const int lid = get_local_id(0);
  int s = 0;
  for (int i = 0; i < 100; i++) {
    a[gid + i * NG] = i;
    global_barrier(sync);
    for (int g = 0; g < NG; g++)
      s += a[i * NG + g];
  }
  printf(\"%d\\n\", s);
} ") in
  let buf_sync = create_buffer ng in
  let sync = Array1.create float64 c_layout ng in
  let buf_a = create_buffer (1000000 * nw) in
  fun () ->
    Array1.fill sync 0.;
    Cl.set_kernel_arg kernel 0 (Cl.Arg_value.MEM buf_a);
    Cl.set_kernel_arg kernel 1 (Cl.Arg_value.MEM buf_sync);
    let evt_sync =
      Cl.enqueue_write_buffer queue buf_sync true (genarray_of_array1 sync) [] in
    let t0 = Unix.gettimeofday () in
    let evt_kernel = Cl.enqueue_nd_range_kernel queue kernel None [ng] (Some [nw])
      [evt_sync] in
    Cl.release_event evt_sync;
    Cl.wait_for_events [evt_kernel];
    Format.printf "%f@." (Unix.gettimeofday () -. t0);
    Cl.release_event evt_kernel

let () =
  go ()
