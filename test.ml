let () =
	try
		let platforms = Cl.get_platform_ids () in
		let platform = platforms.(0) in
		List.iter (fun platform_info ->
			Printf.printf "%s\n%!" (Cl.get_platform_info platform platform_info))
			[Cl.Platform_info.PROFILE;
			 Cl.Platform_info.VERSION;
			 Cl.Platform_info.NAME;
			 Cl.Platform_info.VENDOR;
			 Cl.Platform_info.EXTENSIONS];
		let devices = Cl.get_device_ids platform [Cl.Device_type.ALL] in
		let device = devices.(0) in
		let name = Cl.get_device_info device Cl.Device_info.name in
		Printf.printf "%s\n%!" name;
		let pfn_notify errinfo _ _ =
			Printf.printf "create_context pfn_notify %s\n%!" errinfo
		in
		let context = Cl.create_context [] [device] pfn_notify in
		let _command_queue = Cl.create_command_queue context device [] in
		let program = Cl.create_program_with_source context ["
			__kernel void vector_add_gpu (
				__global const double* src_a,
        __global const double* src_b,
        __global double* res,
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
		let _kernel = Cl.create_kernel program "vector_add_gpu" in
		let size = 123 in
		let src_a_h = Array.init size float_of_int in
		let src_b_h = Array.init size float_of_int in
		let _src_a_d = Cl.create_buffer context
			[Cl.Mem_flags.READ_ONLY; Cl.Mem_flags.COPY_HOST_PTR]
			(Cl.Host.DOUBLE_INIT src_a_h)
		in
		let _src_b_d = Cl.create_buffer context
			[Cl.Mem_flags.READ_ONLY; Cl.Mem_flags.COPY_HOST_PTR]
			(Cl.Host.DOUBLE_INIT src_b_h)
		in
		let _res_d = Cl.create_buffer context [Cl.Mem_flags.WRITE_ONLY]
			(Cl.Host.DOUBLE size)
		in
		()
	with Cl.Cl_error cl_error ->
		Printf.printf "error %s.\n" (Cl.Cl_error.to_string cl_error)
