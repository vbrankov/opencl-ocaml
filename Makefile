OPENCL_INCLUDE_DIR=/cygdrive/c/Program Files (x86)/AMD APP/include
OPENCL_LIB_DIR=/cygdrive/c/Program Files (x86)/AMD APP/lib/x86
EXAMPLES_SRC = $(wildcard examples/*.ml)

all: lib

examples: $(EXAMPLES_SRC:%.ml=%.exe)

%.exe: lib/cl.cmxa %.ml
	@ocamlopt -o $@ -I lib bigarray.cmxa $^

lib: lib/cl.cmxa

lib/cl.cmxa: lib/cl_stubs.o lib/*.ml
	@ocamlopt -a -o $@ -ccopt "-L\"$(OPENCL_LIB_DIR)\"" -cclib -lOpenCL $^

%.o: %.c
	@ocamlopt -ccopt "-o $@ -I\"$(OPENCL_INCLUDE_DIR)\"" -c $^

clean:
	@rm -f */*.{a,cmi,cmo,cmx,cmxa,exe,o,stackdump,tmp,tmp.dll}

.PHONY: clean examples lib
