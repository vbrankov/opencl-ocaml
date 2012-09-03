#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <CL/opencl.h>

value val_cl_error(cl_int error)
{
	return Val_int(-error - (error < 30 ? 0 : 10));
}

value val_cl_platform_info(cl_platform_info platform_info)
{
	switch (platform_info)
	{
		case 0x0900: return Atom(0);
		case 0x0901: return Atom(1);
		case 0x0902: return Atom(2);
		case 0x0903: return Atom(3);
		case 0x0904: return Atom(4);
		default: caml_failwith("unrecognized platform info");
	}
}

cl_platform_info cl_platform_info_val(value platform_info)
{
	switch (Int_val(platform_info))
	{
		case 0: return 0x0900;
		case 1: return 0x0901;
		case 2: return 0x0902;
		case 3: return 0x0903;
		case 4: return 0x0904;
		default: caml_failwith("unrecognized platform info");
	}
}

cl_device_type cl_device_type_val(value v)
{
	CAMLlocal1(h);
	cl_device_type device_type = 0;

	while (Is_block(v))
	{
		assert(Tag_val(v) == 0);
		h = Field(v, 0);
		v = Field(v, 1);
		assert(Is_long(h));
		switch (Long_val(h))
		{
			case 0: device_type |= 1 << 0; break;
			case 1: device_type |= 1 << 1; break;
			case 2: device_type |= 1 << 2; break;
			case 3: device_type |= 1 << 3; break;
			case 4: device_type |= 1 << 4; break;
			case 5: device_type |= -1; break;
			default: caml_failwith("unrecognized device type");
		}
	}
	assert(Int_val(v) == 0);
	return device_type;
}

cl_command_queue_properties cl_command_queue_properties_val(value v)
{
	CAMLlocal1(h);
	cl_command_queue_properties command_queue_properties = 0;

	while (Is_block(v))
	{
		assert(Tag_val(v) == 0);
		h = Field(v, 0);
		v = Field(v, 1);
		assert(Is_long(h));
		switch (Long_val(h))
		{
			case 0: command_queue_properties |= 1 << 0; break;
			case 1: command_queue_properties |= 1 << 1; break;
			default: caml_failwith("unrecognized Command_queueu_properties");
		}
	}
	assert(Int_val(v) == 0);
	return command_queue_properties;
}

void raise_cl_error(cl_int error)
{
	value* exception;
	if (error == CL_SUCCESS)
		return;
	exception = caml_named_value("Cl_error");
	if (exception == NULL)
		caml_failwith("Cl_error not registered");
	value caml_error = val_cl_error(error);
	caml_raise_with_arg(*exception, val_cl_error(error));
}

value caml_get_platform_ids(value unit)
{
	CAMLparam1(unit);
	
	CAMLlocal1(caml_platforms);
	cl_uint num_platforms;
	cl_platform_id* platforms;
	int i;
	
	raise_cl_error(clGetPlatformIDs(0, NULL, &num_platforms));
	platforms = calloc(num_platforms, sizeof(cl_platform_id));
	if (platforms == NULL)
		caml_failwith("calloc error");
	raise_cl_error(clGetPlatformIDs(num_platforms, platforms, NULL));
	caml_platforms = caml_alloc_tuple(num_platforms);
	for (i = 0; i < num_platforms; i++)
	{
		Store_field(caml_platforms, i, caml_copy_nativeint(platforms[i]));
	}
	free(platforms);
	
	CAMLreturn(caml_platforms);
}

value caml_get_platform_info(value caml_platform, value caml_param_name)
{
	CAMLparam2(caml_platform, caml_param_name);
	
	CAMLlocal1(caml_param_value);
	cl_platform_id platform;
	cl_platform_info param_name;
	size_t param_value_size;
	char* param_value;
	
	platform = (cl_platform_id) Nativeint_val(caml_platform);
	param_name = cl_platform_info_val(caml_param_name);
	raise_cl_error(
		clGetPlatformInfo(platform, param_name, 0, NULL, &param_value_size));
	param_value = calloc(param_value_size, sizeof(char));
	if (param_value == NULL)
		caml_failwith("calloc error");
	raise_cl_error(
		clGetPlatformInfo(platform, param_name, param_value_size, param_value, NULL)
	);
	caml_param_value = caml_copy_string(param_value);
	free(param_value);
	
	CAMLreturn(caml_param_value);
}

value caml_get_device_ids(value caml_platform, value caml_device_type)
{
	CAMLparam2(caml_platform, caml_device_type);
	
	CAMLlocal1(caml_devices);
	cl_platform_id platform;
	cl_device_type device_type;
	cl_uint num_devices;
	cl_device_id* devices;
	int i;

	platform = (cl_platform_id) Nativeint_val(caml_platform);
	device_type = cl_device_type_val(caml_device_type);
	raise_cl_error(clGetDeviceIDs(platform, device_type, 0, NULL, &num_devices));
	devices = calloc(num_devices, sizeof(cl_device_id));
	if (devices == NULL)
		caml_failwith("calloc error");
	raise_cl_error(
		clGetDeviceIDs(platform, device_type, num_devices, devices, NULL));
	caml_devices = caml_alloc_tuple(num_devices);
	for (i = 0; i < num_devices; i++)
	{
		Store_field(caml_devices, i, caml_copy_nativeint(devices[i]));
	}
	free(devices);
	
	CAMLreturn(caml_devices);
}

value caml_get_device_info(value caml_device, value caml_param_name)
{
	CAMLparam2(caml_device, caml_param_name);
	
	CAMLlocal1(caml_param_value);
	cl_device_id device;
	cl_device_info param_name;
	size_t param_value_size;
	void* param_value;
	
	device = (cl_device_id) Nativeint_val(caml_device);
	param_name = Int_val(caml_param_name);
	raise_cl_error(
		clGetDeviceInfo(device, param_name, 0, NULL, &param_value_size));
	param_value = malloc(param_value_size);
	if (param_value == NULL)
		caml_failwith("malloc error");
	raise_cl_error(
		clGetDeviceInfo(device, param_name, param_value_size, param_value, NULL));
	switch ((int) param_name)
	{
		case CL_DEVICE_NAME:
			caml_param_value = caml_copy_string((char*) param_value);
			break;
		default: caml_param_value = Val_unit;
	}
	free(param_value);
	
	CAMLreturn(caml_param_value);
}

int list_length(value v)
{
	int l;
	for (l = 0; Is_block(v); l++)
	{
		v = Field(v, 1);
	}
	assert(Is_long(v));
	return l;
}

cl_context_properties* cl_context_properties_val(value v)
{
	CAMLlocal2(h, caml_val);
	cl_context_properties *properties;
	int i, l;
	cl_context_properties p, val;
	
	l = list_length(v);
	properties = calloc(l * 2 + 1, sizeof(intptr_t));
	if (properties == NULL)
		caml_failwith("calloc error");
	for (i = 0; Is_block(v); i++)
	{
		h = Field(v, 0);
		v = Field(v, 1);
		
		assert(Is_block(h));
		caml_val = Field(h, 0);
		switch (Tag_val(h))
		{
			case 0: p = CL_CONTEXT_PLATFORM; val = Nativeint_val(caml_val);
				break;
			case 1: p = CL_CONTEXT_INTEROP_USER_SYNC; val = Bool_val(caml_val); break;
			default: caml_failwith("unrecognized context properties");
		}
		properties[i * 2] = p;
		properties[i * 2 + 1] = val;
	}
	properties[l * 2] = 0;
	return properties;
}

static value *caml_pfn_notifies = NULL;

void CL_CALLBACK pfn_notify(
	const char *errinfo,
	const void *private_info,
	size_t cb,
	void *user_data)
{
	CAMLlocal4(caml_pfn_notify, caml_errinfo, caml_private_info, caml_cb);
	
	caml_pfn_notify = Field(*caml_pfn_notifies, (int) user_data);
	caml_errinfo = caml_copy_string(errinfo);
	caml_private_info = caml_copy_nativeint(private_info);
	caml_cb = caml_copy_nativeint(cb);
	caml_callback3(caml_pfn_notify, caml_errinfo, caml_private_info, caml_cb);
}

void array_add(value **array, value *element)
{
	CAMLlocal1(new_array);
	int i, length;
	
	length = *array != NULL ? Wosize_val(*array) : 0;
	new_array = caml_alloc_tuple(length + 1);
	caml_register_generational_global_root(&new_array);
	for (i = 0; i < length; i++)
		Store_field(new_array, i, Field(**array, i));
	Store_field(new_array, length, *element);
	if (*array != NULL)
		caml_remove_generational_global_root(*array);
	*array = &new_array;
}

value caml_create_context(value caml_properties, value caml_devices,
	value caml_pfn_notify, value caml_user_data)
{
	CAMLparam4(caml_properties, caml_devices, caml_pfn_notify, caml_user_data);
	
	CAMLlocal1(caml_context);
	value *tmp;
	cl_context_properties* properties;
	cl_uint num_devices;
	cl_device_id* devices;
	void* user_data;
	cl_int errcode;
	int i;
	cl_context context;
	
	properties = cl_context_properties_val(caml_properties);
	num_devices = list_length(caml_devices);
	devices = calloc(num_devices, sizeof(cl_device_id));
	for (i = 0; Is_block(caml_devices); i++)
	{
		devices[i] = (cl_device_id) Nativeint_val(Field(caml_devices, 0));
		caml_devices = Field(caml_devices, 1);
	}
	// Store caml_pfn_notify so that it doesn't get garbage collected
	array_add(&caml_pfn_notifies, &caml_pfn_notify);
	user_data = (void*) Wosize_val(*caml_pfn_notifies);
	context = clCreateContext(
		properties, num_devices, devices, &pfn_notify, user_data, &errcode);
	raise_cl_error(errcode);
	caml_context = caml_copy_nativeint(context);
	
	CAMLreturn(caml_context);
}

value caml_create_command_queue(value caml_context, value caml_device,
	value caml_properties)
{
	CAMLparam3(caml_context, caml_device, caml_properties);
	
	CAMLlocal1(caml_command_queue);
	cl_context context;
	cl_device_id device;
	cl_command_queue_properties properties;
	cl_int errcode;
	cl_command_queue command_queue;
	
	context = (cl_context) Nativeint_val(caml_context);
	device = (cl_device_id) Nativeint_val(caml_device);
	properties = cl_command_queue_properties_val(caml_properties);
	command_queue = clCreateCommandQueue(context, device, properties, &errcode);
	raise_cl_error(errcode);
	caml_command_queue = caml_copy_nativeint(command_queue);
	
	CAMLreturn(caml_command_queue);
}
