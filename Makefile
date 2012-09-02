CC=cc
OPENCLDIR="/cygdrive/c/Program Files (x86)/AMD APP"
SOURCES = cl.ml test.ml

all: test.exe

test.exe: cl.o $(SOURCES)
	@ocamlc -o test.exe -custom -ccopt '-L$(OPENCLDIR)/lib/x86' -cclib -lOpenCL cl.o $(SOURCES)

cl.o: cl.c
	@$(CC) -I$(OPENCLDIR)/include -c cl.c

clean:
	@rm -f test.exe cl.o $(SOURCES:.ml=.cmi) $(SOURCES:.ml=.cmo)