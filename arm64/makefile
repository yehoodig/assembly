all: hello

hello: hello.o
	gcc -o $@ $+

hello.o : hello.asm
	as -g -mfpu=vfpv2 -o $@ $<

clean:
	rm -vf hello *.o

