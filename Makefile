OPENCL_INCLUDE_DIR=/cygdrive/c/Program Files (x86)/AMD APP/include
OPENCL_LIB_DIR=/cygdrive/c/Program Files (x86)/AMD APP/lib/x86
SOURCES = cl.ml

all: cl.cmxa

test.exe: cl.cmxa test.ml
	@ocamlopt -o test.exe bigarray.cmxa cl.cmxa test.ml

cl.cmxa: cl_stubs.o $(SOURCES)
	@ocamlopt -a -o cl.cmxa -ccopt "-L\"$(OPENCL_LIB_DIR)\"" -cclib -lOpenCL \
		cl_stubs.o $(SOURCES)

cl_stubs.o: cl_stubs.c
	@ocamlopt -ccopt "-I\"$(OPENCL_INCLUDE_DIR)\"" -c cl_stubs.c

clean:
	@rm -f test.exe *.{a,cmi,cmo,cmx,cmxa,o}
