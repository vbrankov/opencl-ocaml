#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <caml/alloc.h>
#include <caml/bigarray.h>
#include <caml/callback.h>
#include <caml/fail.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <CL/opencl.h>

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

value val_cl_error(cl_int error)
{
  return Val_int(-error - (error > -30 ? 0 : 10));
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

cl_mem_flags cl_mem_flags_val(value v)
{
  CAMLlocal1(h);
  cl_mem_flags mem_flags = 0;

  while (Is_block(v))
  {
    assert(Tag_val(v) == 0);
    h = Field(v, 0);
    v = Field(v, 1);
    assert(Is_long(h));
    switch (Long_val(h))
    {
      case 0: mem_flags |= 1 << 0; break;
      case 1: mem_flags |= 1 << 1; break;
      case 2: mem_flags |= 1 << 2; break;
      case 3: mem_flags |= 1 << 3; break;
      case 4: mem_flags |= 1 << 4; break;
      case 5: mem_flags |= 1 << 5; break;
      case 6: mem_flags |= 1 << 7; break;
      case 7: mem_flags |= 1 << 8; break;
      case 8: mem_flags |= 1 << 9; break;
      default: caml_failwith("unrecognized Mem_flags");
    }
  }
  assert(Int_val(v) == 0);
  return mem_flags;
}

const char** char_array_array_val(value v)
{
  const char **a;
  size_t i, l;
  
  l = list_length(v);
  if (l == 0)
    return NULL;
  a = calloc(l, sizeof(char));
  if (a == NULL)
    caml_failwith("malloc error");
  for (i = 0; Is_block(v); i++)
  {
    assert(Tag_val(v) == 0);
    a[i] = String_val(Field(v, 0));
    v = Field(v, 1);
  }
  return a;
}

void size_t_array_val(value v, size_t **a, size_t *length)
{
  size_t i;
  
  *length = list_length(v);
  if (*length == 0)
  {
    *a = NULL;
    return;
  }
  *a = calloc(*length, sizeof(size_t));
  if (*a == NULL)
    caml_failwith("calloc error");
  for (i = 0; Is_block(v); i++)
  {
    assert(Tag_val(v) == 0);
    (*a)[i] = Int_val(Field(v, 0));
    v = Field(v, 1);
  }
}

void size_t_array_option_val(value v, size_t **a, size_t *length)
{
  if (Is_block(v))
  {
    size_t_array_val(Field(v, 0), a, length);
  }
  else
  {
    *a = NULL;
    *length = 0;
  }
}

cl_device_id* cl_device_id_val(value v)
{
  cl_device_id* a;
  size_t i, l;
  
  l = list_length(v);
  if (l == 0)
    return NULL;
  a = calloc(l, sizeof(cl_device_id));
  if (a == NULL)
    caml_failwith("calloc error");
  for (i = 0; Is_block(v); i++)
  {
    assert(Tag_val(v) == 0);
    a[i] = (cl_device_id) Nativeint_val(Field(v, 0));
    v = Field(v, 1);
  }
  return a;
}

cl_event* cl_event_val(value v)
{
  cl_event* e;
  int i;
  
  e = calloc(list_length(v), sizeof(cl_event));
  if (e == NULL)
    caml_failwith("calloc error");
  for (i = 0; Is_block(v); i++)
  {
    assert(Tag_val(v) == 0);
    e[i] = (cl_event) Nativeint_val(Field(v, 0));
    v = Field(v, 1);
  }
  return e;
}

value val_cl_build_status(cl_build_status s)
{
  switch (s)
  {
    case CL_BUILD_SUCCESS    : return Val_int(0);
    case CL_BUILD_NONE       : return Val_int(1);
    case CL_BUILD_ERROR      : return Val_int(2);
    case CL_BUILD_IN_PROGRESS: return Val_int(3);
    default: caml_failwith("unrecognized Build_status");
  }
}

value val_cl_program_binary_type(cl_program_binary_type t)
{
  switch (t)
  {
    case CL_PROGRAM_BINARY_TYPE_NONE           : return Val_int(0);
    case CL_PROGRAM_BINARY_TYPE_COMPILED_OBJECT: return Val_int(1);
    case CL_PROGRAM_BINARY_TYPE_LIBRARY        : return Val_int(2);
    case CL_PROGRAM_BINARY_TYPE_EXECUTABLE     : return Val_int(3);
    default: caml_failwith("unrecognized Program_binary_type");
  }
}

value val_nativeint_list(long* a, size_t l)
{
  CAMLlocal2(h, new_h);
  size_t i;
  
  h = Val_unit;
  for (i = 0; i < l; i++)
  {
    new_h = caml_alloc_tuple(2);
    Store_field(new_h, 0, caml_copy_nativeint((long) a[i]));
    Store_field(new_h, 1, h);
    h = new_h;
  }
  
  return h;
}

void raise_cl_error(cl_int error)
{
  value* exception;
  if (error == CL_SUCCESS)
    return;
  exception = caml_named_value("Cl_error");
  if (exception == NULL)
    caml_failwith("Cl_error not registered");
  caml_raise_with_arg(*exception, val_cl_error(error));
}

value caml_get_platform_ids(value unit)
{
  CAMLparam1(unit);
  
  CAMLlocal1(caml_platforms);
  cl_uint num_platforms;
  cl_platform_id* platforms;
  cl_int errcode;
  
  raise_cl_error(clGetPlatformIDs(0, NULL, &num_platforms));
  platforms = calloc(num_platforms, sizeof(cl_platform_id));
  if (platforms == NULL)
    caml_failwith("calloc error");
  errcode = clGetPlatformIDs(num_platforms, platforms, NULL);
  if (errcode != CL_SUCCESS)
    free(platforms);
  raise_cl_error(errcode);
  caml_platforms = val_nativeint_list((long*) platforms, num_platforms);
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
  cl_int errcode;
  
  platform = (cl_platform_id) Nativeint_val(caml_platform);
  param_name = cl_platform_info_val(caml_param_name);
  raise_cl_error(
    clGetPlatformInfo(platform, param_name, 0, NULL, &param_value_size));
  param_value = calloc(param_value_size, sizeof(char));
  if (param_value == NULL)
    caml_failwith("calloc error");
  errcode = clGetPlatformInfo(platform, param_name, param_value_size, param_value,
    NULL);
  if (errcode != CL_SUCCESS)
    free(param_value);
  raise_cl_error(errcode);
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
  cl_int errcode;

  platform = (cl_platform_id) Nativeint_val(caml_platform);
  device_type = cl_device_type_val(caml_device_type);
  raise_cl_error(clGetDeviceIDs(platform, device_type, 0, NULL, &num_devices));
  devices = calloc(num_devices, sizeof(cl_device_id));
  if (devices == NULL)
    caml_failwith("calloc error");
  errcode = clGetDeviceIDs(platform, device_type, num_devices, devices, NULL);
  if (errcode != CL_SUCCESS)
    free(devices);
  raise_cl_error(errcode);
  caml_devices = val_nativeint_list((long*) devices, num_devices);
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
  cl_int errcode;
  
  device = (cl_device_id) Nativeint_val(caml_device);
  param_name = Int_val(caml_param_name);
  raise_cl_error(
    clGetDeviceInfo(device, param_name, 0, NULL, &param_value_size));
  param_value = malloc(param_value_size);
  if (param_value == NULL)
    caml_failwith("malloc error");
  errcode =
    clGetDeviceInfo(device, param_name, param_value_size, param_value, NULL);
  if (errcode != CL_SUCCESS)
    free(param_value);
  raise_cl_error(errcode);
  switch (param_name)
  {
    case CL_DEVICE_NAME:
      caml_param_value = caml_copy_string((char*) param_value);
      break;
    default: caml_param_value = Val_unit;
  }
  free(param_value);
  
  CAMLreturn(caml_param_value);
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

static value *caml_pfn_notifies_create_context = NULL;

void CL_CALLBACK pfn_notify_create_context(
  const char *errinfo,
  const void *private_info,
  size_t cb,
  void *user_data)
{
  CAMLlocal4(caml_pfn_notify, caml_errinfo, caml_private_info, caml_cb);
  
  caml_pfn_notify = Field(*caml_pfn_notifies_create_context, (long) user_data);
  caml_errinfo = caml_copy_string(errinfo);
  caml_private_info = caml_copy_nativeint((long) private_info);
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
  {
    caml_remove_generational_global_root(*array);
    free(*array);
  }
  *array = &new_array;
}

value caml_create_context(value caml_properties, value caml_devices,
  value caml_pfn_notify, value caml_user_data)
{
  CAMLparam4(caml_properties, caml_devices, caml_pfn_notify, caml_user_data);
  
  CAMLlocal1(caml_context);
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
  array_add(&caml_pfn_notifies_create_context, &caml_pfn_notify);
  user_data = (void*) Wosize_val(*caml_pfn_notifies_create_context) - 1;
  context = clCreateContext(
    properties, num_devices, devices, &pfn_notify_create_context, user_data,
    &errcode);
  free(properties);
  free(devices);
  raise_cl_error(errcode);
  caml_context = caml_copy_nativeint((long) context);
  
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
  caml_command_queue = caml_copy_nativeint((long) command_queue);
  
  CAMLreturn(caml_command_queue);
}

value caml_create_program_with_source(value caml_context, value caml_strings)
{
  CAMLparam2(caml_context, caml_strings);
  
  CAMLlocal1(caml_program);
  cl_context context;
  cl_uint count;
  const char** strings;
  cl_int errcode;
  cl_program program;
  int i;
  
  context = (cl_context) Nativeint_val(caml_context);
  count = list_length(caml_strings);
  strings = char_array_array_val(caml_strings);
  program = clCreateProgramWithSource(context, count, strings, NULL, &errcode);
  for (i = 0; i < count; i++)
    free(strings + i);
  raise_cl_error(errcode);
  caml_program = caml_copy_nativeint((long) program);
  
  CAMLreturn(caml_program);
}

static value *caml_pfn_notifies_build_program = NULL;

void CL_CALLBACK pfn_notify_build_program(cl_program program, void *user_data)
{
  CAMLlocal2(caml_pfn_notify, caml_program);
  
  caml_pfn_notify = (value) user_data;
  caml_program = caml_copy_nativeint((long) program);
  // XXX If we're sure that the callback won't be called any more, delete it to
  // prevent leaks
  caml_callback(caml_pfn_notify, caml_program);
}

value caml_build_program(value caml_program, value caml_devices,
  value caml_options, value caml_pfn_notify)
{
  CAMLparam3(caml_program, caml_devices, caml_pfn_notify);
  
  cl_program program;
  cl_uint num_devices;
  cl_device_id *device_list;
  const char *options;
  void *user_data;
  cl_int errcode;
  
  program = (cl_program) Nativeint_val(caml_program);
  num_devices = list_length(caml_devices);
  device_list = cl_device_id_val(caml_devices);
  options = String_val(caml_options);
  // Store caml_pfn_notify so that it doesn't get garbage collected
  array_add(&caml_pfn_notifies_build_program, &caml_pfn_notify);
  user_data = (void*) caml_pfn_notify;
  errcode = clBuildProgram(program, num_devices, device_list, options,
    &pfn_notify_build_program, user_data);
  free(device_list);
  raise_cl_error(errcode);
  
  CAMLreturn(Val_unit);
}

value caml_get_program_build_info(value caml_program, value caml_device,
  value caml_param_name)
{
  CAMLparam3(caml_program, caml_device, caml_param_name);
  
  CAMLlocal1(caml_param_value);
  cl_program program;
  cl_device_id device;
  cl_program_build_info param_name;
  size_t param_value_size;
  void *param_value;
  cl_int errcode;
  
  program = (cl_program) Nativeint_val(caml_program);
  device = (cl_device_id) Nativeint_val(caml_device);
  param_name = (cl_program_build_info) Int_val(caml_param_name);
  raise_cl_error(clGetProgramBuildInfo(program, device, param_name, 0, NULL,
    &param_value_size));
  param_value = malloc(param_value_size);
  if (param_value == NULL)
    caml_failwith("malloc error");
  errcode = clGetProgramBuildInfo(program, device, param_name, param_value_size,
    param_value, NULL);
  if (errcode != CL_SUCCESS)
    free(param_value);
  raise_cl_error(errcode);
  switch (param_name)
  {
    case CL_PROGRAM_BUILD_STATUS:
      caml_param_value = val_cl_build_status(*((cl_build_status*) param_value));
      break;
    case CL_PROGRAM_BUILD_OPTIONS:
    case CL_PROGRAM_BUILD_LOG:
      caml_param_value = caml_copy_string((char*) param_value);
      break;
    case CL_PROGRAM_BINARY_TYPE:
      caml_param_value =
        val_cl_program_binary_type(*((cl_program_binary_type*) param_value));
      break;
  }
  free(param_value);
  
  CAMLreturn(caml_param_value);
}

value caml_create_kernel(value caml_program, value caml_kernel_name)
{
  CAMLparam2(caml_program, caml_kernel_name);
  
  CAMLlocal1(caml_kernel);
  cl_program program;
  char *kernel_name;
  cl_int errcode;
  cl_kernel kernel;
  
  program = (cl_program) Nativeint_val(caml_program);
  kernel_name = String_val(caml_kernel_name);
  kernel = clCreateKernel(program, kernel_name, &errcode);
  raise_cl_error(errcode);
  caml_kernel = caml_copy_nativeint((long) kernel);
  
  CAMLreturn(caml_kernel);
}

/* Taken from bigarray_stubs.c from the OCaml compiler source.  I think that
   this should've been exported. */
/* Size in bytes of a bigarray element, indexed by bigarray kind */
static int caml_ba_element_size[] =
{ 4 /*FLOAT32*/, 8 /*FLOAT64*/,
  1 /*SINT8*/, 1 /*UINT8*/,
  2 /*SINT16*/, 2 /*UINT16*/,
  4 /*INT32*/, 8 /*INT64*/,
  sizeof(value) /*CAML_INT*/, sizeof(value) /*NATIVE_INT*/,
  8 /*COMPLEX32*/, 16 /*COMPLEX64*/
};

void array_val(value caml_array, void **ptr, size_t *size)
{
  struct caml_ba_array *array;
  int i;
  
  array = Bigarray_val(caml_array);
  *size = bigarray_element_size[array->flags & BIGARRAY_KIND_MASK];
  for (i = 0; i < array->num_dims; i++)
    *size *= array->dim[1];
  *ptr = array->data;
}

value caml_create_buffer(value caml_context, value caml_flags, value caml_src)
{
  CAMLparam3(caml_context, caml_flags, caml_src);
  
  CAMLlocal1(caml_mem);
  cl_context context;
  cl_mem_flags flags;
  size_t size;
  void *host_ptr;
  cl_int errcode;
  cl_mem mem;
  
  context = (cl_context) Nativeint_val(caml_context);
  flags = cl_mem_flags_val(caml_flags);
  switch (Tag_val(caml_src))
  {
    case 0:
      size = bigarray_element_size[Int_val(Field(caml_src, 0))] *
             Int_val(Field(caml_src, 1));
      host_ptr = NULL;
      break;
    case 1:
      array_val(Field(Field(caml_src, 0), 0), &host_ptr, &size);
      break;
    default:
      assert(0);
  }
  mem = clCreateBuffer(context, flags, size, host_ptr, &errcode);
  raise_cl_error(errcode);
  caml_mem = caml_copy_nativeint((long) mem);
  
  CAMLreturn(caml_mem);
}

void set_bigarray_value(void* ptr, int offset, int kind, value val)
{
  switch (kind) {
  default:
    caml_failwith("Unrecognized bigarray kind");
  case CAML_BA_FLOAT32:
    ((float *) ptr)[offset] = Double_val(val); break;
  case CAML_BA_FLOAT64:
    ((double *) ptr)[offset] = Double_val(val); break;
  case CAML_BA_SINT8:
  case CAML_BA_UINT8:
    ((int8 *) ptr)[offset] = Int_val(val); break;
  case CAML_BA_SINT16:
  case CAML_BA_UINT16:
    ((int16 *) ptr)[offset] = Int_val(val); break;
  case CAML_BA_INT32:
    ((int32 *) ptr)[offset] = Int32_val(val); break;
  case CAML_BA_INT64:
    ((int64 *) ptr)[offset] = Int64_val(val); break;
  case CAML_BA_NATIVE_INT:
    ((intnat *) ptr)[offset] = Nativeint_val(val); break;
  case CAML_BA_CAML_INT:
    ((intnat *) ptr)[offset] = Long_val(val); break;
  case CAML_BA_COMPLEX32:
    { float * p = ((float *) ptr) + offset * 2;
      p[0] = Double_field(val, 0);
      p[1] = Double_field(val, 1);
      break; }
  case CAML_BA_COMPLEX64:
    { double * p = ((double *) ptr) + offset * 2;
      p[0] = Double_field(val, 0);
      p[1] = Double_field(val, 1);
      break; }
  }
}

value caml_set_kernel_arg(value caml_kernel, value caml_arg_index,
  value caml_arg_value)
{
  CAMLparam3(caml_kernel, caml_arg_index, caml_arg_value);
  
  CAMLlocal1(data);
  cl_kernel kernel;
  cl_uint arg_index;
  size_t arg_size;
  long buf[16]; // should be big enough to store the biggest value
  void *arg_value;
  int kind;
  
  kernel = (cl_kernel) Nativeint_val(caml_kernel);
  arg_index = Int_val(caml_arg_index);
  data = Field(caml_arg_value, 0);
  switch (Tag_val(caml_arg_value))
  {
    case 0:
      kind = Int_val(data);
      data = Field(caml_arg_value, 1);
      arg_size = bigarray_element_size[kind];
      set_bigarray_value(buf, 0, kind, data);
      arg_value = buf;
      break;
    case 1:
      arg_size = sizeof(cl_mem);
      ((int*) buf)[0] = Nativeint_val(data);
      arg_value = buf;
      break;
    case 2:
      kind = Int_val(data);
      data = Field(caml_arg_value, 1);
      arg_size = bigarray_element_size[kind] * Int_val(data);
      arg_value = NULL;
      break;
    default:
      caml_failwith("unrecognized Arg_value");
  }
  raise_cl_error(clSetKernelArg(kernel, arg_index, arg_size, arg_value));
  
  CAMLreturn(Val_unit);
}

value caml_enqueue_nd_range_kernel_native(
  value caml_command_queue,
  value caml_kernel,
  value caml_global_work_offset,
  value caml_global_work_size,
  value caml_local_work_size,
  value caml_event_wait_list)
{
  CAMLparam5(caml_command_queue, caml_kernel, caml_global_work_offset,
    caml_global_work_size, caml_local_work_size);
  CAMLxparam1(caml_event_wait_list);
  
  CAMLlocal1(caml_event);
  cl_command_queue command_queue;
  cl_kernel kernel;
  cl_uint work_dim, num_events_in_wait_list;
  size_t *global_work_offset, *global_work_size, *local_work_size, i;
  cl_event *event_wait_list, event;
  cl_int errcode;
  
  command_queue = (cl_command_queue) Nativeint_val(caml_command_queue);
  kernel = (cl_kernel) Nativeint_val(caml_kernel);
  
  size_t_array_val(caml_global_work_size, &global_work_size, &i);
  work_dim = i;
  size_t_array_option_val(caml_global_work_offset, &global_work_offset, &i);
  if (i != 0 && i != work_dim)
    caml_failwith("global_work_offset and global_work_size must be of equal dimensions");
  size_t_array_option_val(caml_local_work_size, &local_work_size, &i);
  if (i != 0 && i != work_dim)
    caml_failwith("local_work_size and global_work_size must be of equal dimensions");
  
  num_events_in_wait_list = list_length(caml_event_wait_list);
  // XXX We have a memory leak if the following call raises exception. This is
  // very unlikely to be a recoverable situation so we shouldn't care.
  event_wait_list =
    num_events_in_wait_list == 0 ? NULL : cl_event_val(caml_event_wait_list);

  errcode = clEnqueueNDRangeKernel(command_queue, kernel, work_dim,
    global_work_offset, global_work_size, local_work_size,
    num_events_in_wait_list, event_wait_list, &event);
  if (errcode != CL_SUCCESS)
  {
    free(global_work_offset);
    free(global_work_size);
    free(local_work_size);
    free(event_wait_list);
  }
  raise_cl_error(errcode);
  caml_event = caml_copy_nativeint((long) event);
  
  CAMLreturn(caml_event);
}

value caml_enqueue_nd_range_kernel_bytecode(value *argv, int argn)
{
  return caml_enqueue_nd_range_kernel_native(
    argv[0], argv[1], argv[2], argv[3], argv[4], argv[5]);
}

value caml_enqueue_read_buffer(value caml_command_queue, value caml_buffer,
  value caml_blocking_read, value caml_host_mem, value caml_event_wait_list)
{
  CAMLparam5(caml_command_queue, caml_buffer, caml_blocking_read, caml_host_mem,
    caml_event_wait_list);
  
  CAMLlocal2(data, caml_event);
  cl_command_queue command_queue;
  cl_mem buffer;
  cl_bool blocking_read;
  size_t offset, size;
  void *ptr;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int errcode;

  command_queue = (cl_command_queue) Nativeint_val(caml_command_queue);
  buffer = (cl_mem) Nativeint_val(caml_buffer);
  blocking_read = Val_int(caml_blocking_read);
  
  offset = 0;
  array_val(Field(caml_host_mem, 0), &ptr, &size);
  num_events_in_wait_list = list_length(caml_event_wait_list);
  event_wait_list =
    num_events_in_wait_list == 0 ? NULL : cl_event_val(caml_event_wait_list);
  errcode = clEnqueueReadBuffer(command_queue, buffer, blocking_read, offset,
    size, ptr, num_events_in_wait_list, event_wait_list, &event);
  if (errcode != CL_SUCCESS)
    free(event_wait_list);
  raise_cl_error(errcode);
  caml_event = caml_copy_nativeint((long) event);
  
  CAMLreturn(caml_event);
}

value caml_enqueue_write_buffer(value caml_command_queue, value caml_buffer,
  value caml_blocking_write, value caml_host_mem, value caml_event_wait_list)
{
  CAMLparam5(caml_command_queue, caml_buffer, caml_blocking_write, caml_host_mem,
    caml_event_wait_list);
  
  CAMLlocal2(data, caml_event);
  cl_command_queue command_queue;
  cl_mem buffer;
  cl_bool blocking_write;
  size_t offset, size;
  void *ptr;
  cl_uint num_events_in_wait_list;
  cl_event *event_wait_list;
  cl_event event;
  cl_int errcode;

  command_queue = (cl_command_queue) Nativeint_val(caml_command_queue);
  buffer = (cl_mem) Nativeint_val(caml_buffer);
  blocking_write = Val_int(caml_blocking_write);
  
  offset = 0;
  array_val(Field(caml_host_mem, 0), &ptr, &size);
  num_events_in_wait_list = list_length(caml_event_wait_list);
  event_wait_list =
    num_events_in_wait_list == 0 ? NULL : cl_event_val(caml_event_wait_list);
  errcode = clEnqueueWriteBuffer(command_queue, buffer, blocking_write, offset,
    size, ptr, num_events_in_wait_list, event_wait_list, &event);
  if (errcode != CL_SUCCESS)
    free(event_wait_list);
  raise_cl_error(errcode);
  caml_event = caml_copy_nativeint((long) event);
  
  CAMLreturn(caml_event);
}

value caml_release_kernel(value caml_kernel)
{
  CAMLparam1(caml_kernel);
  
  cl_kernel kernel;
  
  kernel = (cl_kernel) Nativeint_val(caml_kernel);
  raise_cl_error(clReleaseKernel(kernel));
  
  CAMLreturn(Val_unit);
}

value caml_release_command_queue(value caml_command_queue)
{
  CAMLparam1(caml_command_queue);
  
  cl_command_queue command_queue;
  
  command_queue = (cl_command_queue) Nativeint_val(caml_command_queue);
  raise_cl_error(clReleaseCommandQueue(command_queue));
  
  CAMLreturn(Val_unit);
}

value caml_release_context(value caml_context)
{
  CAMLparam1(caml_context);
  
  cl_context context;
  
  context = (cl_context) Nativeint_val(caml_context);
  raise_cl_error(clReleaseContext(context));
  
  CAMLreturn(Val_unit);
}

value caml_release_mem_object(value caml_memobj)
{
  CAMLparam1(caml_memobj);
  
  cl_mem memobj;
  
  memobj = (cl_mem) Nativeint_val(caml_memobj);
  raise_cl_error(clReleaseMemObject(memobj));
  
  CAMLreturn(Val_unit);
}

value caml_release_program(value caml_program)
{
  CAMLparam1(caml_program);
  
  cl_program program;
  
  program = (cl_program) Nativeint_val(caml_program);
  raise_cl_error(clReleaseProgram(program));
  
  CAMLreturn(Val_unit);
}
