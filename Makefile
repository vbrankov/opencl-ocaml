OPENCL_INCLUDE_DIR=/cygdrive/c/Program Files (x86)/AMD APP/include
OPENCL_LIB_DIR=/cygdrive/c/Program Files (x86)/AMD APP/lib/x86
LIB_SRC = $(wildcard lib/*.mli)
EXAMPLES_SRC = $(wildcard examples/*.ml)

all: lib examples doc

examples: $(EXAMPLES_SRC:%.ml=%.exe)

%.exe: lib/cl.cmxa %.ml
	@ocamlopt -o $@ -I lib bigarray.cmxa $^

lib: lib/cl.cmxa

lib/cl.cmxa: lib/cl_stubs.o lib/*.ml $(LIB_SRC:.mli=.cmi)
	@ocamlopt -a -o $@ -ccopt "-L\"$(OPENCL_LIB_DIR)\"" -cclib -lOpenCL -I lib \
		lib/cl_stubs.o lib/*.ml

lib/%.cmi: lib/%.mli
	@ocamlopt $^
	
%.o: %.c
	@ocamlopt -ccopt "-o $@ -I\"$(OPENCL_INCLUDE_DIR)\"" -c $^

doc:
	@mkdir -p doc
	@ocamldoc -html -d doc lib/*.mli

clean:
	@rm -f */*.{a,cmi,cmo,cmx,cmxa,css,exe,html,o,stackdump,tmp,tmp.dll}

.PHONY : clean doc examples lib
.PRECIOUS : %.cmi
