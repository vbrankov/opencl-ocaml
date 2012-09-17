open Bigarray

let program_source = "
/* Matrix multiplication: C = A * B.
 * Device code.
 */

#define BLOCK_SIZE 16
#define AS(i, j) As[j + i * BLOCK_SIZE]
#define BS(i, j) Bs[j + i * BLOCK_SIZE]

///////////////////////////////////////////////////////////////////////////////
//! Matrix multiplication on the device: C = A * B
//! uiWA is A's width and uiWB is B's width
////////////////////////////////////////////////////////////////////////////////
__kernel void
matrixMul( __global float* C, __global float* A, __global float* B, 
	__local float* As, __local float* Bs, int uiWA, int uiWB, int trueLocalSize1)
{
  // Block index
  int bx = get_group_id(0);
  int by = get_group_id(1);

  // Thread index
  int tx = get_local_id(0);
  int ty = get_local_id(1);

  // Index of the first sub-matrix of A processed by the block
  int aBegin = uiWA * BLOCK_SIZE * by;

  // Index of the last sub-matrix of A processed by the block
  int aEnd   = aBegin + uiWA - 1;

  // Step size used to iterate through the sub-matrices of A
  int aStep  = BLOCK_SIZE;

  // Index of the first sub-matrix of B processed by the block
  int bBegin = BLOCK_SIZE * bx;

  // Step size used to iterate through the sub-matrices of B
  int bStep  = BLOCK_SIZE * uiWB;

  // Csub is used to store the element of the block sub-matrix
  // that is computed by the thread
  float Csub = 0.0f;

  // Loop over all the sub-matrices of A and B
  // required to compute the block sub-matrix
  for (int a = aBegin, b = bBegin;
           a <= aEnd;
           a += aStep, b += bStep) {

    // Load the matrices from device memory
    // to shared memory; each thread loads
    // one element of each matrix
    AS(ty, tx) = A[a + uiWA * ty + tx];
    BS(ty, tx) = B[b + uiWB * ty + tx];

    // Synchronize to make sure the matrices are loaded
    barrier(CLK_LOCAL_MEM_FENCE);

    // Multiply the two matrices together;
    // each thread computes one element
    // of the block sub-matrix        
    #pragma unroll
    for (int k = 0; k < BLOCK_SIZE; ++k)
        Csub += AS(ty, k) * BS(k, tx);

    // Synchronize to make sure that the preceding
    // computation is done before loading two new
    // sub-matrices of A and B in the next iteration
    barrier(CLK_LOCAL_MEM_FENCE);
  }

  if (get_global_id(1) < trueLocalSize1)
  // Write the block sub-matrix to device memory;
  // each thread writes one element
  C[get_global_id(1) * get_global_size(0) + get_global_id(0)] = Csub;

}"

let () =
  try
    let block_size = 16 in
    let wA = 16 in
    let hA = wA in
    let wB = wA in
    let hB = wA in
    let a = Array2.create float32 c_layout hA wA in
    let b = Array2.create float32 c_layout hB wB in
    let c = Array2.create float32 c_layout hA wB in
    for i = 0 to hA - 1 do
      for j = 0 to wA - 1 do
        a.{i, j} <- float_of_int (i + 1) /. float_of_int (j + 1)
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
    let kernel = Cl.create_kernel program "matrixMul" in
    Cl.set_kernel_arg kernel 0 (Cl.Arg_value.MEM buffer_c);
    Cl.set_kernel_arg kernel 1 (Cl.Arg_value.MEM buffer_a);
    Cl.set_kernel_arg kernel 2 (Cl.Arg_value.MEM buffer_b);
    Cl.set_kernel_arg kernel 3
      (Cl.Arg_value.LOCAL (float32, block_size * block_size));
    Cl.set_kernel_arg kernel 4
      (Cl.Arg_value.LOCAL (float32, block_size * block_size));
    Cl.set_kernel_arg kernel 5 (Cl.Arg_value.SCALAR (int32, Int32.of_int wA));
    Cl.set_kernel_arg kernel 6 (Cl.Arg_value.SCALAR (int32, Int32.of_int wB));
    Cl.set_kernel_arg kernel 7 (Cl.Arg_value.SCALAR (int32, Int32.of_int hA));
    
    let _ =
      Cl.enqueue_nd_range_kernel cmd_queue kernel None [wA; hB]
        (Some [block_size; block_size]) []
    in
    let _ =
      Cl.enqueue_read_buffer cmd_queue buffer_c true (genarray_of_array2 c) []
    in
    
    for i = 0 to hB - 1 do
      for j = 0 to wB - 1 do
        Printf.printf "%.2f " c.{i, j}
      done;
      Printf.printf "\n"
    done
    
  with Cl.Cl_error cl_error ->
    Printf.printf "error %s.\n" (Cl.Cl_error.to_string cl_error)