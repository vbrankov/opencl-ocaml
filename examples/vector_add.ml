open Bigarray

let program_source = "
__kernel
void vecadd(__global int *A,
            __global int *B,
            __global int *C)
{
  int idx = get_global_id(0);
  C[idx] = A[idx] + B[idx];
}
"

let () =
  try
    let elements = 2048 in
    let a = Array1.create int c_layout elements in
    let b = Array1.create int c_layout elements in
    let c = Array1.create int c_layout elements in
    for i = 0 to elements - 1 do
      a.{i} <- i;
      b.{i} <- i
    done;
    
    let platforms = Cl.get_platform_ids () in
    let devices = Cl.get_device_ids (List.hd platforms) [Cl.Device_type.ALL] in
    let context = Cl.create_context [] devices (fun _ _ _ -> ()) in
    let cmd_queue = Cl.create_command_queue context (List.hd devices) [] in
    let buffer_a = Cl.create_buffer context [Cl.Mem_flags.READ_ONLY]
      (Cl.Buffer_contents.SIZE (int, elements))
    in
    let buffer_b = Cl.create_buffer context [Cl.Mem_flags.READ_ONLY]
      (Cl.Buffer_contents.SIZE (int, elements))
    in
    let buffer_c = Cl.create_buffer context [Cl.Mem_flags.WRITE_ONLY]
      (Cl.Buffer_contents.SIZE (int, elements))
    in
    let _ =
      Cl.enqueue_write_buffer cmd_queue buffer_a true (Cl.Host_mem.ARRAY1 a) []
    in
    let _ =
      Cl.enqueue_write_buffer cmd_queue buffer_b true (Cl.Host_mem.ARRAY1 b) []
    in
    let program = Cl.create_program_with_source context [program_source] in
    Cl.build_program program devices "" (fun _ -> ());
    let kernel = Cl.create_kernel program "vecadd" in
    Cl.set_kernel_arg kernel 0 (Cl.Arg_value.MEM buffer_a);
    Cl.set_kernel_arg kernel 1 (Cl.Arg_value.MEM buffer_b);
    Cl.set_kernel_arg kernel 2 (Cl.Arg_value.MEM buffer_c);
    
    let _ = Cl.enqueue_nd_range_kernel cmd_queue kernel None [elements] None []
    in
    let _ =
      Cl.enqueue_read_buffer cmd_queue buffer_c true (Cl.Host_mem.ARRAY1 c) []
    in
    
    for i = 0 to elements - 1 do
      if c.{i} <> i + i then
        failwith "Output is incorrect"
    done;
    Printf.printf "Output is correct\n"
    
  with Cl.Cl_error cl_error ->
    Printf.printf "error %s.\n" (Cl.Cl_error.to_string cl_error)