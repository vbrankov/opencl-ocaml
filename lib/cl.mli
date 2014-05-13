module Cl_error : sig
  type t =
  | SUCCESS
  | DEVICE_NOT_FOUND
  | DEVICE_NOT_AVAILABLE
  | COMPILER_NOT_AVAILABLE
  | MEM_OBJECT_ALLOCATION_FAILURE
  | OUT_OF_RESOURCES
  | OUT_OF_HOST_MEMORY
  | PROFILING_INFO_NOT_AVAILABLE
  | MEM_COPY_OVERLAP
  | IMAGE_FORMAT_MISMATCH
  | IMAGE_FORMAT_NOT_SUPPORTED
  | BUILD_PROGRAM_FAILURE
  | MAP_FAILURE
  | MISALIGNED_SUB_BUFFER_OFFSET
  | EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST
  | COMPILE_PROGRAM_FAILURE
  | LINKER_NOT_AVAILABLE
  | LINK_PROGRAM_FAILURE
  | DEVICE_PARTITION_FAILED
  | KERNEL_ARG_INFO_NOT_AVAILABLE
  | INVALID_VALUE
  | INVALID_DEVICE_TYPE
  | INVALID_PLATFORM
  | INVALID_DEVICE
  | INVALID_CONTEXT
  | INVALID_QUEUE_PROPERTIES
  | INVALID_COMMAND_QUEUE
  | INVALID_HOST_PTR
  | INVALID_MEM_OBJECT
  | INVALID_IMAGE_FORMAT_DESCRIPTOR
  | INVALID_IMAGE_SIZE
  | INVALID_SAMPLER
  | INVALID_BINARY
  | INVALID_BUILD_OPTIONS
  | INVALID_PROGRAM
  | INVALID_PROGRAM_EXECUTABLE
  | INVALID_KERNEL_NAME
  | INVALID_KERNEL_DEFINITION
  | INVALID_KERNEL
  | INVALID_ARG_INDEX
  | INVALID_ARG_VALUE
  | INVALID_ARG_SIZE
  | INVALID_KERNEL_ARGS
  | INVALID_WORK_DIMENSION
  | INVALID_WORK_GROUP_SIZE
  | INVALID_WORK_ITEM_SIZE
  | INVALID_GLOBAL_OFFSET
  | INVALID_EVENT_WAIT_LIST
  | INVALID_EVENT
  | INVALID_OPERATION
  | INVALID_GL_OBJECT
  | INVALID_BUFFER_SIZE
  | INVALID_MIP_LEVEL
  | INVALID_GLOBAL_WORK_SIZE
  | INVALID_PROPERTY
  | INVALID_IMAGE_DESCRIPTOR
  | INVALID_COMPILER_OPTIONS
  | INVALID_LINKER_OPTIONS
  | INVALID_DEVICE_PARTITION_COUNT
  
  val to_string : t -> string
end

module Platform_id : sig
  type t
end

module Device_id : sig
  type t
end

module Context : sig
  type t
end

module Command_queue : sig
  type t
end

module Program : sig
  type t
end

module Kernel : sig
  type t
end

module Mem : sig
  type ('a, 'b) t
end

module Event : sig
  type t
end

module Platform_info : sig
  type t =
  | PROFILE
  | VERSION
  | NAME
  | VENDOR
  | EXTENSIONS
end

module Device_type : sig
  type t =
  | DEFAULT
  | CPU
  | GPU
  | ACCELERATOR
  | CUSTOM
  | ALL
end

module Device_info : sig
  type 'a t
  
  val device_type                       : unit t
  val vendor_id                         : unit t
  val max_compute_units                 : int t
  val max_work_item_dimensions          : int t
  val max_work_group_size               : int t
  val max_work_item_sizes               : unit t
  val preferred_vector_width_char       : unit t
  val preferred_vector_width_short      : unit t
  val preferred_vector_width_int        : unit t
  val preferred_vector_width_long       : unit t
  val preferred_vector_width_float      : unit t
  val preferred_vector_width_double     : unit t
  val max_clock_frequency               : unit t
  val address_bits                      : unit t
  val max_read_image_args               : unit t
  val max_write_image_args              : unit t
  val max_mem_alloc_size                : unit t
  val image2d_max_width                 : unit t
  val image2d_max_height                : unit t
  val image3d_max_width                 : unit t
  val image3d_max_height                : unit t
  val image3d_max_depth                 : unit t
  val image_support                     : unit t
  val max_parameter_size                : unit t
  val max_samplers                      : unit t
  val mem_base_addr_align               : unit t
  val min_data_type_align_size          : unit t
  val single_fp_config                  : unit t
  val global_mem_cache_type             : unit t
  val global_mem_cacheline_size         : int t
  val global_mem_cache_size             : int t
  val global_mem_size                   : int t
  val max_constant_buffer_size          : unit t
  val max_constant_args                 : unit t
  val local_mem_type                    : unit t
  val local_mem_size                    : int t
  val error_correction_support          : unit t
  val profiling_timer_resolution        : unit t
  val endian_little                     : unit t
  val available                         : unit t
  val compiler_available                : unit t
  val execution_capabilities            : unit t
  val queue_properties                  : unit t
  val name                              : string t
  val vendor                            : unit t
  val version                           : unit t
  val profile                           : unit t
  val version                           : unit t
  val extensions                        : unit t
  val platform                          : unit t
  val double_fp_config                  : unit t
  val preferred_vector_width_half       : unit t
  val host_unified_memory               : unit t
  val native_vector_width_char          : unit t
  val native_vector_width_short         : unit t
  val native_vector_width_int           : unit t
  val native_vector_width_long          : unit t
  val native_vector_width_float         : unit t
  val native_vector_width_double        : unit t
  val native_vector_width_half          : unit t
  val opencl_c_version                  : string t
  val linker_available                  : unit t
  val built_in_kernels                  : unit t
  val image_max_buffer_size             : unit t
  val image_max_array_size              : unit t
  val parent_device                     : unit t
  val partition_max_sub_devices         : unit t
  val partition_properties              : unit t
  val partition_affinity_domain         : unit t
  val partition_type                    : unit t
  val reference_count                   : unit t
  val preferred_interop_user_sync       : unit t
  val printf_buffer_size                : unit t
end

module Context_properties : sig
  (* XXX Not all the contexts are done *)
  type t =
  | CONTEXT_PLATFORM of Platform_id.t
  | CONTEXT_INTEROP_USER_SYNC of bool
end

module Command_queue_properties : sig
  type t =
  | CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE
  | CL_QUEUE_PROFILING_ENABLE
end

module Mem_flags : sig
  type t =
  | READ_WRITE
  | WRITE_ONLY
  | READ_ONLY
  | USE_HOST_PTR
  | ALLOC_HOST_PTR
  | COPY_HOST_PTR
  | HOST_WRITE_ONLY
  | HOST_READ_ONLY
  | HOST_NO_ACCESS
end

module Build_status : sig
  type t =
  | SUCCESS
  | NONE
  | ERROR
  | IN_PROGRESS
  
  val to_string : t -> string
end

module Program_binary_type : sig
  type t =
  | NONE
  | COMPILED_OBJECT
  | LIBRARY
  | EXECUTABLE
end

module Program_build_info : sig
  type 'a t
  
  (* XXX All values where ['a] is [unit] are unfinished *)
  val build_status  : Build_status.t t
  val build_options : string t
  val build_log     : string t
  val binary_type   : Program_binary_type.t t
end

module Command_execution_status : sig
  type t =
  | CL_COMPLETE
  | CL_RUNNING
  | CL_SUBMITTED
  | CL_QUEUED
end

module Arg_value : sig
  (* XXX Not all possible arguments are implemented *)
  type ('a, 'b) t =
  | SCALAR of ('a, 'b) Bigarray.kind * 'a
  | MEM of ('a, 'b) Mem.t
  | LOCAL of ('a, 'b) Bigarray.kind * int
end

module Buffer_contents : sig
  type ('a, 'b) t =
  | SIZE of ('a, 'b) Bigarray.kind * int
  | HOST_MEM of ('a, 'b, Bigarray.c_layout) Bigarray.Genarray.t
end

exception Cl_error of Cl_error.t

(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clGetPlatformIDs.html } Kronos Doc} *)
val get_platform_ids : unit -> Platform_id.t list
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clGetPlatformInfo.html } Kronos Doc} *)
val get_platform_info : Platform_id.t -> Platform_info.t -> string
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clGetDeviceIDs.html } Kronos Doc} *)
val get_device_ids : Platform_id.t -> Device_type.t list -> Device_id.t list
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clGetDeviceInfo.html } Kronos Doc} *)
val get_device_info : Device_id.t -> 'a Device_info.t -> 'a
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clCreateContext.html } Kronos Doc} *)
val create_context : Context_properties.t list -> Device_id.t list
  -> (string -> int64 -> int64 -> unit) -> Context.t
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clCreateCommandQueue.html } Kronos Doc} *)
val create_command_queue : Context.t -> Device_id.t
  -> Command_queue_properties.t list -> Command_queue.t
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clCreateProgramWithSource.html } Kronos Doc} *)
val create_program_with_source : Context.t -> string list -> Program.t
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clBuildProgram.html } Kronos Doc} *)
val build_program : Program.t -> Device_id.t list -> string
  -> (Program.t -> unit) -> unit
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clGetProgramBuildInfo.html } Kronos Doc} *)
val get_program_build_info : Program.t -> Device_id.t -> 'a Program_build_info.t
  -> 'a
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clCreateKernel.html } Kronos Doc} *)
val create_kernel : Program.t -> string -> Kernel.t
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clCreateBuffer.html } Kronos Doc} *)
val create_buffer : Context.t -> Mem_flags.t list
  -> ('a, 'b) Buffer_contents.t -> ('a, 'b) Mem.t
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clSetKernelArg.html } Kronos Doc} *)
val set_kernel_arg : Kernel.t -> int -> (_, _) Arg_value.t -> unit
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clEnqueueNDRangeKernel.html } Kronos Doc} *)
val enqueue_nd_range_kernel : Command_queue.t -> Kernel.t -> int list option
  -> int list -> int list option -> Event.t list -> Event.t
(* XXX Try to support offset. *)
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clEnqueueReadBuffer.html } Kronos Doc} *)
val enqueue_read_buffer : Command_queue.t -> ('a, 'b) Mem.t -> bool
  -> ?offset:int -> ('a, 'b, _) Bigarray.Genarray.t -> Event.t list -> Event.t
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clEnqueueWriteBuffer.html } Kronos Doc} *)
val enqueue_write_buffer : Command_queue.t -> ('a, 'b) Mem.t -> bool
  -> ?offset:int -> ('a, 'b, _) Bigarray.Genarray.t -> Event.t list -> Event.t
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clReleaseKernel.html } Kronos Doc} *)
val release_kernel : Kernel.t -> unit
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clReleaseCommandQueue.html } Kronos Doc} *)
val release_command_queue : Command_queue.t -> unit
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clReleaseContext.html } Kronos Doc} *)
val release_context : Context.t -> unit
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clReleaseMemObject.html } Kronos Doc} *)
val release_mem_object : (_, _) Mem.t -> unit
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clReleaseProgram.html } Kronos Doc} *)
val release_program : Program.t -> unit
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clReleaseEvent.html } Kronos Doc} *)
val release_event : Event.t -> unit
(** {{: http://www.khronos.org/registry/cl/sdk/1.2/docs/man/xhtml/clWaitForEvents.html } Kronos Doc} *)
val wait_for_events : Event.t list -> unit
