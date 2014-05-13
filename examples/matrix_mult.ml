open Bigarray

let program_source = "
__kernel void simple_multiply(
  __global float *c,
  int wA,
  int hA,
  int wB,
  int hB,
  __global float *a,
  __global float *b)
{
  int row = get_global_id(0);
  int col = get_global_id(1);
  
  float sum = 0.0f;
  for (int i = 0; i < wA; i++)
    sum += a[row * wA + i] * b[i * wB + col];
  c[row * wB + col] = sum;
}
"

let () =
  try
    let wA = 16 in
    let hA = wA in
    let wB = wA in
    let hB = wA in
    let a = Array2.create float32 c_layout hA wA in
    let b = Array2.create float32 c_layout hB wB in
    let c = Array2.create float32 c_layout hA wB in
    for i = 0 to hA - 1 do
      for j = 0 to wA - 1 do
        a.{i, j} <- float_of_int i /. float_of_int (j + 1)
      done
    done;
    for i = 0 to hB - 1 do
      for j = 0 to wB - 1 do
        b.{i, j} <- 1. /. float_of_int (i + j + 1)
      done
    done;
    
    let platforms = Cl.get_platform_ids () in
    let devices = Cl.get_device_ids (List.hd platforms) [Cl.Device_type.ALL] in
    let context = Cl.create_context [] devices (fun _ _ _ -> ()) in
    let cmd_queue = Cl.create_command_queue context (List.hd devices) [] in
    let buffer_a = Cl.create_buffer context
      Cl.Mem_flags.([READ_ONLY; USE_HOST_PTR])
      (Cl.Buffer_contents.HOST_MEM (genarray_of_array2 a))
    in
    let buffer_b = Cl.create_buffer context
      Cl.Mem_flags.([READ_ONLY; USE_HOST_PTR])
      (Cl.Buffer_contents.HOST_MEM (genarray_of_array2 b))
    in
    let buffer_c = Cl.create_buffer context
      Cl.Mem_flags.([WRITE_ONLY; USE_HOST_PTR])
      (Cl.Buffer_contents.HOST_MEM (genarray_of_array2 c))
    in
    let program = Cl.create_program_with_source context [program_source] in
    Cl.build_program program devices "" (fun _ -> ());
    let kernel = Cl.create_kernel program "simple_multiply" in
    Cl.set_kernel_arg kernel 0 (Cl.Arg_value.MEM buffer_c);
    Cl.set_kernel_arg kernel 1 (Cl.Arg_value.SCALAR (int32, Int32.of_int wA));
    Cl.set_kernel_arg kernel 2 (Cl.Arg_value.SCALAR (int32, Int32.of_int hA));
    Cl.set_kernel_arg kernel 3 (Cl.Arg_value.SCALAR (int32, Int32.of_int wB));
    Cl.set_kernel_arg kernel 4 (Cl.Arg_value.SCALAR (int32, Int32.of_int hB));
    Cl.set_kernel_arg kernel 5 (Cl.Arg_value.MEM buffer_a);
    Cl.set_kernel_arg kernel 6 (Cl.Arg_value.MEM buffer_b);
    
    let event = Cl.enqueue_nd_range_kernel cmd_queue kernel None [16; 16] None [] in
    Cl.release_event event;
    let event =
      Cl.enqueue_read_buffer cmd_queue buffer_c true (genarray_of_array2 c) []
    in
    Cl.release_event event;
    
    for i = 0 to hB - 1 do
      for j = 0 to wB - 1 do
        Printf.printf "%.2f " c.{i, j}
      done;
      Printf.printf "\n"
    done
    
  with Cl.Cl_error cl_error ->
    Printf.printf "error %s.\n" (Cl.Cl_error.to_string cl_error)
