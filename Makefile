OPENCL_INCLUDE_DIR=/cygdrive/c/Program Files (x86)/AMD APP/include
OPENCL_LIB_DIR=/cygdrive/c/Program Files (x86)/AMD APP/lib/x86
SOURCES = cl.ml test.ml

all: cl.cmxa

test.exe: cl.cmxa
	@ocamlopt -o test.exe bigarray.cmxa cl.cmxa test.ml

cl.cmxa: cl_impl.o $(SOURCES)
	@ocamlopt -a -o cl.cmxa -ccopt "-L\"$(OPENCL_LIB_DIR)\"" -cclib -lOpenCL \
		cl_impl.o $(SOURCES)

cl_impl.o: cl_impl.c
	@ocamlopt -ccopt "-I\"$(OPENCL_INCLUDE_DIR)\"" -c cl_impl.c

clean:
	@rm -f test.exe *.{a,cmi,cmo,cmx,cmxa,o}
