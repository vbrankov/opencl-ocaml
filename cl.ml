module Cl_error = struct
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
	
	let to_string = function
	| SUCCESS                                   -> "SUCCESS"
	| DEVICE_NOT_FOUND                          -> "DEVICE_NOT_FOUND"
	| DEVICE_NOT_AVAILABLE                      -> "DEVICE_NOT_AVAILABLE"
	| COMPILER_NOT_AVAILABLE                    -> "COMPILER_NOT_AVAILABLE"
	| MEM_OBJECT_ALLOCATION_FAILURE             -> "MEM_OBJECT_ALLOCATION_FAILURE"
	| OUT_OF_RESOURCES                          -> "OUT_OF_RESOURCES"
	| OUT_OF_HOST_MEMORY                        -> "OUT_OF_HOST_MEMORY"
	| PROFILING_INFO_NOT_AVAILABLE              -> "PROFILING_INFO_NOT_AVAILABLE"
	| MEM_COPY_OVERLAP                          -> "MEM_COPY_OVERLAP"
	| IMAGE_FORMAT_MISMATCH                     -> "IMAGE_FORMAT_MISMATCH"
	| IMAGE_FORMAT_NOT_SUPPORTED                -> "IMAGE_FORMAT_NOT_SUPPORTED"
	| BUILD_PROGRAM_FAILURE                     -> "BUILD_PROGRAM_FAILURE"
	| MAP_FAILURE                               -> "MAP_FAILURE"
	| MISALIGNED_SUB_BUFFER_OFFSET              -> "MISALIGNED_SUB_BUFFER_OFFSET"
	| EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST -> "EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST"
	| COMPILE_PROGRAM_FAILURE                   -> "COMPILE_PROGRAM_FAILURE"
	| LINKER_NOT_AVAILABLE                      -> "LINKER_NOT_AVAILABLE"
	| LINK_PROGRAM_FAILURE                      -> "LINK_PROGRAM_FAILURE"
	| DEVICE_PARTITION_FAILED                   -> "DEVICE_PARTITION_FAILED"
	| KERNEL_ARG_INFO_NOT_AVAILABLE             -> "KERNEL_ARG_INFO_NOT_AVAILABLE"
	| INVALID_VALUE                             -> "INVALID_VALUE"
	| INVALID_DEVICE_TYPE                       -> "INVALID_DEVICE_TYPE"
	| INVALID_PLATFORM                          -> "INVALID_PLATFORM"
	| INVALID_DEVICE                            -> "INVALID_DEVICE"
	| INVALID_CONTEXT                           -> "INVALID_CONTEXT"
	| INVALID_QUEUE_PROPERTIES                  -> "INVALID_QUEUE_PROPERTIES"
	| INVALID_COMMAND_QUEUE                     -> "INVALID_COMMAND_QUEUE"
	| INVALID_HOST_PTR                          -> "INVALID_HOST_PTR"
	| INVALID_MEM_OBJECT                        -> "INVALID_MEM_OBJECT"
	| INVALID_IMAGE_FORMAT_DESCRIPTOR           -> "INVALID_IMAGE_FORMAT_DESCRIPTOR"
	| INVALID_IMAGE_SIZE                        -> "INVALID_IMAGE_SIZE"
	| INVALID_SAMPLER                           -> "INVALID_SAMPLER"
	| INVALID_BINARY                            -> "INVALID_BINARY"
	| INVALID_BUILD_OPTIONS                     -> "INVALID_BUILD_OPTIONS"
	| INVALID_PROGRAM                           -> "INVALID_PROGRAM"
	| INVALID_PROGRAM_EXECUTABLE                -> "INVALID_PROGRAM_EXECUTABLE"
	| INVALID_KERNEL_NAME                       -> "INVALID_KERNEL_NAME"
	| INVALID_KERNEL_DEFINITION                 -> "INVALID_KERNEL_DEFINITION"
	| INVALID_KERNEL                            -> "INVALID_KERNEL"
	| INVALID_ARG_INDEX                         -> "INVALID_ARG_INDEX"
	| INVALID_ARG_VALUE                         -> "INVALID_ARG_VALUE"
	| INVALID_ARG_SIZE                          -> "INVALID_ARG_SIZE"
	| INVALID_KERNEL_ARGS                       -> "INVALID_KERNEL_ARGS"
	| INVALID_WORK_DIMENSION                    -> "INVALID_WORK_DIMENSION"
	| INVALID_WORK_GROUP_SIZE                   -> "INVALID_WORK_GROUP_SIZE"
	| INVALID_WORK_ITEM_SIZE                    -> "INVALID_WORK_ITEM_SIZE"
	| INVALID_GLOBAL_OFFSET                     -> "INVALID_GLOBAL_OFFSET"
	| INVALID_EVENT_WAIT_LIST                   -> "INVALID_EVENT_WAIT_LIST"
	| INVALID_EVENT                             -> "INVALID_EVENT"
	| INVALID_OPERATION                         -> "INVALID_OPERATION"
	| INVALID_GL_OBJECT                         -> "INVALID_GL_OBJECT"
	| INVALID_BUFFER_SIZE                       -> "INVALID_BUFFER_SIZE"
	| INVALID_MIP_LEVEL                         -> "INVALID_MIP_LEVEL"
	| INVALID_GLOBAL_WORK_SIZE                  -> "INVALID_GLOBAL_WORK_SIZE"
	| INVALID_PROPERTY                          -> "INVALID_PROPERTY"
	| INVALID_IMAGE_DESCRIPTOR                  -> "INVALID_IMAGE_DESCRIPTOR"
	| INVALID_COMPILER_OPTIONS                  -> "INVALID_COMPILER_OPTIONS"
	| INVALID_LINKER_OPTIONS                    -> "INVALID_LINKER_OPTIONS"
	| INVALID_DEVICE_PARTITION_COUNT            -> "INVALID_DEVICE_PARTITION_COUNT"
end

module Platform_id = struct
	type t
end

module Device_id = struct
	type t
end

module Context = struct
	type t
end

module Command_queue = struct
	type t
end

module Program = struct
	type t
end

module Kernel = struct
	type t
end

module Mem = struct
	type t
end

module Platform_info = struct
	type t =
	| PROFILE
	| VERSION
	| NAME
	| VENDOR
	| EXTENSIONS
end

module Device_type = struct
	type t =
	| DEFAULT
	| CPU
	| GPU
	| ACCELERATOR
	| CUSTOM
	| ALL
end

module Device_info = struct
	type 'a t = int
	
	(* XXX All values where ['a] is [unit] are unfinished *)
	let device_type                       : unit t = 0x1000
	let vendor_id                         : unit t = 0x1001
  let max_compute_units                 : unit t = 0x1002
  let max_work_item_dimensions          : unit t = 0x1003
  let max_work_group_size               : unit t = 0x1004
  let max_work_item_sizes               : unit t = 0x1005
  let preferred_vector_width_char       : unit t = 0x1006
  let preferred_vector_width_short      : unit t = 0x1007
  let preferred_vector_width_int        : unit t = 0x1008
  let preferred_vector_width_long       : unit t = 0x1009
  let preferred_vector_width_float      : unit t = 0x100a
  let preferred_vector_width_double     : unit t = 0x100b
  let max_clock_frequency               : unit t = 0x100c
  let address_bits                      : unit t = 0x100d
  let max_read_image_args               : unit t = 0x100e
  let max_write_image_args              : unit t = 0x100f
  let max_mem_alloc_size                : unit t = 0x1010
  let image2d_max_width                 : unit t = 0x1011
  let image2d_max_height                : unit t = 0x1012
  let image3d_max_width                 : unit t = 0x1013
  let image3d_max_height                : unit t = 0x1014
  let image3d_max_depth                 : unit t = 0x1015
  let image_support                     : unit t = 0x1016
  let max_parameter_size                : unit t = 0x1017
  let max_samplers                      : unit t = 0x1018
  let mem_base_addr_align               : unit t = 0x1019
  let min_data_type_align_size          : unit t = 0x101a
  let single_fp_config                  : unit t = 0x101b
  let global_mem_cache_type             : unit t = 0x101c
  let global_mem_cacheline_size         : unit t = 0x101d
  let global_mem_cache_size             : unit t = 0x101e
  let global_mem_size                   : unit t = 0x101f
  let max_constant_buffer_size          : unit t = 0x1020
  let max_constant_args                 : unit t = 0x1021
  let local_mem_type                    : unit t = 0x1022
  let local_mem_size                    : unit t = 0x1023
  let error_correction_support          : unit t = 0x1024
  let profiling_timer_resolution        : unit t = 0x1025
  let endian_little                     : unit t = 0x1026
  let available                         : unit t = 0x1027
  let compiler_available                : unit t = 0x1028
  let execution_capabilities            : unit t = 0x1029
  let queue_properties                  : unit t = 0x102a
  let name                              : string t = 0x102b
  let vendor                            : unit t = 0x102c
  let version                           : unit t = 0x102d
  let profile                           : unit t = 0x102e
  let version                           : unit t = 0x102f
  let extensions                        : unit t = 0x1030
  let platform                          : unit t = 0x1031
  let double_fp_config                  : unit t = 0x1032
  let preferred_vector_width_half       : unit t = 0x1034
  let host_unified_memory               : unit t = 0x1035
  let native_vector_width_char          : unit t = 0x1036
  let native_vector_width_short         : unit t = 0x1037
  let native_vector_width_int           : unit t = 0x1038
  let native_vector_width_long          : unit t = 0x1039
  let native_vector_width_float         : unit t = 0x103a
  let native_vector_width_double        : unit t = 0x103b
  let native_vector_width_half          : unit t = 0x103c
  let opencl_c_version                  : unit t = 0x103d
  let linker_available                  : unit t = 0x103e
  let built_in_kernels                  : unit t = 0x103f
  let image_max_buffer_size             : unit t = 0x1040
  let image_max_array_size              : unit t = 0x1041
  let parent_device                     : unit t = 0x1042
  let partition_max_sub_devices         : unit t = 0x1043
  let partition_properties              : unit t = 0x1044
  let partition_affinity_domain         : unit t = 0x1045
  let partition_type                    : unit t = 0x1046
  let reference_count                   : unit t = 0x1047
  let preferred_interop_user_sync       : unit t = 0x1048
  let printf_buffer_size                : unit t = 0x1049
end

module Context_properties = struct
	(* XXX Not all the contexts are done *)
	type t =
	| CONTEXT_PLATFORM of Platform_id.t
	| CONTEXT_INTEROP_USER_SYNC of bool
end

module Command_queue_properties = struct
	type t =
	| CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE
	| CL_QUEUE_PROFILING_ENABLE
end

module Mem_flags = struct
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

module Build_status = struct
	type t =
	| SUCCESS
	| NONE
	| ERROR
	| IN_PROGRESS
	
	let to_string = function
	| SUCCESS     -> "SUCCESS"
	| NONE        -> "NONE"
	| ERROR       -> "ERROR"
	| IN_PROGRESS -> "IN_PROGRESS"
end

module Program_binary_type = struct
	type t =
  | NONE
  | COMPILED_OBJECT
  | LIBRARY
  | EXECUTABLE
end

module Program_build_info = struct
	type 'a t = int
	
	(* XXX All values where ['a] is [unit] are unfinished *)
  let build_status                      : Build_status.t t = 0x1181
  let build_options                     : string t = 0x1182
  let build_log                         : string t = 0x1183
  let binary_type                       : Program_binary_type.t t = 0x1184
end

module Host = struct
	(* XXX Not all possible hosts are implemented *)
	type t =
	| DOUBLE of int (* size *)
	| DOUBLE_INIT of float array
end

module Arg_value = struct
	(* XXX Not all possible arguments are implemented *)
	type t =
	| INT of int
	(* XXX We should probaby have Mem.t parametrized for type safety *)
	| ARRAY_DOUBLE of Mem.t
end

exception Cl_error of Cl_error.t
let _ = Callback.register_exception "Cl_error" (Cl_error Cl_error.SUCCESS)

external get_platform_ids : unit -> Platform_id.t array
	= "caml_get_platform_ids"
external get_platform_info : Platform_id.t -> Platform_info.t -> string
	= "caml_get_platform_info"
external get_device_ids : Platform_id.t -> Device_type.t list
	-> Device_id.t array = "caml_get_device_ids"
external get_device_info : Device_id.t -> 'a Device_info.t -> 'a
	= "caml_get_device_info"
external create_context : Context_properties.t list -> Device_id.t list
	-> (string -> int64 -> int64 -> unit) -> Context.t = "caml_create_context"
external create_command_queue : Context.t -> Device_id.t
	-> Command_queue_properties.t list -> Command_queue.t
	= "caml_create_command_queue"
external create_program_with_source : Context.t -> string list -> Program.t
	= "caml_create_program_with_source"
external build_program : Program.t -> Device_id.t list -> string
	-> (Program.t -> unit) -> unit = "caml_build_program"
external get_program_build_info : Program.t -> Device_id.t
	-> 'a Program_build_info.t -> 'a = "caml_get_program_build_info"
external create_kernel : Program.t -> string -> Kernel.t = "caml_create_kernel"
external create_buffer : Context.t -> Mem_flags.t list -> Host.t -> Mem.t
	= "caml_create_buffer"
external set_kernel_arg : Kernel.t -> int -> Arg_value.t -> unit
	= "caml_set_kernel_arg"
