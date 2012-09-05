CC=cc
OPENCLDIR="/cygdrive/c/Program Files (x86)/AMD APP"
SOURCES = cl.ml test.ml

all: test.exe

test.exe: cl_impl.o $(SOURCES)
#	@ocamlc -o test.exe -custom -ccopt '-L$(OPENCLDIR)/lib/x86' -cclib -lOpenCL \
#		cl_impl.o $(SOURCES)
	@ocamlopt -o test.exe -ccopt '-L$(OPENCLDIR)/lib/x86' -cclib -lOpenCL \
		cl_impl.o $(SOURCES)

cl_impl.o: cl_impl.c
	@$(CC) -I$(OPENCLDIR)/include -c cl_impl.c

clean:
	@rm -f test.exe *.{cmi,cmo,cmx,o}