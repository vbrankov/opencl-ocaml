open Bigarray
open Opencl

let () =
  try
    let platforms = Cl.get_platform_ids () in
    let platform = List.hd platforms in
    List.iter (fun platform_info ->
      Printf.printf "%s\n%!" (Cl.get_platform_info platform platform_info))
      [Cl.Platform_info.PROFILE;
       Cl.Platform_info.VERSION;
       Cl.Platform_info.NAME;
       Cl.Platform_info.VENDOR;
       Cl.Platform_info.EXTENSIONS];
    let devices = Cl.get_device_ids platform [Cl.Device_type.ALL] in
    let device = List.hd devices in
    Printf.printf "global max compute units = %d\n%!"
      (Cl.get_device_info device Cl.Device_info.max_compute_units);
    Printf.printf "global max work item dimensions = %d\n%!"
      (Cl.get_device_info device Cl.Device_info.max_work_item_dimensions);
    Printf.printf "global max work group size = %d\n%!"
      (Cl.get_device_info device Cl.Device_info.max_work_group_size);
    Printf.printf "global mem cacheline size = %d\n%!"
      (Cl.get_device_info device Cl.Device_info.global_mem_cacheline_size);
    Printf.printf "global mem cache size = %d\n%!"
      (Cl.get_device_info device Cl.Device_info.global_mem_cache_size);
    Printf.printf "global mem size = %d\n%!"
      (Cl.get_device_info device Cl.Device_info.global_mem_size);
    Printf.printf "local mem size = %d\n%!"
      (Cl.get_device_info device Cl.Device_info.local_mem_size);
    Printf.printf "name = %s\n%!"
      (Cl.get_device_info device Cl.Device_info.name);
    Printf.printf "OpenCL C version = %s\n%!"
      (Cl.get_device_info device Cl.Device_info.opencl_c_version);
    let pfn_notify errinfo _ _ =
      Printf.printf "create_context pfn_notify %s\n%!" errinfo
    in
    let context = Cl.create_context [] [device] pfn_notify in
    let queue = Cl.create_command_queue context device [] in
    let program = Cl.create_program_with_source context ["
      __kernel void vector_add_gpu (
        __global const float* src_a,
        __global const int* src_b,
        __global float* res,
        const int num)
      {
        const int idx = get_global_id(0);

        if (idx < num)
          res[idx] = src_a[idx] + src_b[idx];
      }"]
    in
    let pfn_notify _ = Printf.printf "build_program pfn_notify\n%!" in
    Cl.build_program program [device] "" pfn_notify;
    Printf.printf "built\n%!";
    let build_log = Cl.get_program_build_info program device
      Cl.Program_build_info.build_log
    in
    let build_status = Cl.get_program_build_info program device
      Cl.Program_build_info.build_status
    in
    Printf.printf "%s %s\n%!" build_log
      (Cl.Build_status.to_string build_status);
    let vector_add_k = Cl.create_kernel program "vector_add_gpu" in
    let size = 16 * 16 in
    let src_a_h = Array1.create float32 c_layout size in
    let src_b_h = Array1.create int32 c_layout size in
    let res_h   = Array1.create float32 c_layout size in
    for i = 0 to size - 1 do
      src_a_h.{i} <- float_of_int i;
      src_b_h.{i} <- Int32.of_int i
    done;
    let src_a_d = Cl.create_buffer context
      Cl.Mem_flags.([READ_ONLY])
      (Cl.Buffer_contents.SIZE (Bigarray.float32, size))
    in
    let src_b_d = Cl.create_buffer context
      Cl.Mem_flags.([READ_ONLY; COPY_HOST_PTR])
      (Cl.Buffer_contents.HOST_MEM (genarray_of_array1 src_b_h))
    in
    let res_d = Cl.create_buffer context Cl.Mem_flags.([WRITE_ONLY])
      (Cl.Buffer_contents.SIZE (Bigarray.float32, size))
    in
    Cl.set_kernel_arg vector_add_k 0 (Cl.Arg_value.MEM src_a_d);
    Cl.set_kernel_arg vector_add_k 1 (Cl.Arg_value.MEM src_b_d);
    Cl.set_kernel_arg vector_add_k 2 (Cl.Arg_value.MEM res_d);
    Cl.set_kernel_arg vector_add_k 3
      (Cl.Arg_value.SCALAR (int32, Int32.of_int size));
    let event =
      Cl.enqueue_write_buffer queue src_a_d true (genarray_of_array1 src_a_h) []
    in
    Cl.release_event event;
    let event =
      Cl.enqueue_nd_range_kernel queue vector_add_k None [size] (Some [16]) []
    in
    Cl.release_event event;
    let event =
      Cl.enqueue_read_buffer queue res_d true (genarray_of_array1 res_h) []
    in
    Cl.release_event event;
    for i = 0 to size - 1 do
      Printf.printf "%.2f " res_h.{i}
    done;
    Cl.release_kernel vector_add_k;
    Cl.release_program program;
    Cl.release_command_queue queue;
    Cl.release_context context;
    Cl.release_mem_object(src_a_d);
    Cl.release_mem_object(src_b_d);
    Cl.release_mem_object(res_d)
  with Cl.Cl_error cl_error ->
    Printf.printf "error %s.\n" (Cl.Cl_error.to_string cl_error)
