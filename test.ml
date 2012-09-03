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
		let pfn_notify errinfo _ _ = Printf.printf "pfn_notify %s\n%!" errinfo in
		let context = Cl.create_context [] [device] pfn_notify in
		let _command_queue = Cl.create_command_queue context device [] in
		let _program = Cl.create_program_with_source context ["
			__kernel void vector_add_gpu (
				__global const float* src_a,
        __global const float* src_b,
        __global float* res,
		    const int num)
			{
				const int idx = get_global_id(0);

				if (idx < num)
					res[idx] = src_a[idx] + src_b[idx];
			}"]
		in
		()
	with Cl.Cl_error cl_error ->
		Printf.printf "error %s.\n" (Cl.Cl_error.to_string cl_error)
