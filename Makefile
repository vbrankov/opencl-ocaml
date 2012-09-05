OPENCL_INCLUDE_DIR=/cygdrive/c/Program Files (x86)/AMD APP/include
OPENCL_LIB_DIR=/cygdrive/c/Program Files (x86)/AMD APP/lib/x86
SOURCES = cl.ml test.ml

all: test.exe

test.exe: cl_impl.o $(SOURCES)
#	@ocamlc -o test.exe -custom -ccopt '-L$(OPENCL_LIB_DIR)' -cclib -lOpenCL \
#		cl_impl.o $(SOURCES)
	@ocamlopt -o test.exe -ccopt "-L\"$(OPENCL_LIB_DIR)\"" -cclib -lOpenCL \
		cl_impl.o $(SOURCES)

cl_impl.o: cl_impl.c
	@ocamlopt -ccopt "-I\"$(OPENCL_INCLUDE_DIR)\"" -c cl_impl.c

clean:
	@rm -f test.exe *.{cmi,cmo,cmx,o}