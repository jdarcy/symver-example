CFLAGS	= -g -O0 -fPIC
LDFLAGS	= $(CFLAGS) -shared -Wl,--version-script

all: use_foo_1 use_foo_2

use_foo_1: use_foo_1.o lib1.so
	ln lib1.so libfoo.so
	$(CC) use_foo_1.o -L. -lfoo -o $@
	rm libfoo.so

lib1.so: lib1.o
	$(CC) -shared lib1.o -o $@

use_foo_2: use_foo_2.o lib2.so
	ln lib2.so libfoo.so
	$(CC) use_foo_2.o -L. -lfoo -o $@
	rm libfoo.so

lib2.so: lib2.o lib2.map
	$(CC) $(LDFLAGS) lib2.map lib2.o -o $@

broken.so: lib2.o broken.map
	$(CC) $(LDFLAGS) broken.map lib2.o -o $@

clean:
	rm -f *.o

clobber: clean
	rm -f *.so use_foo_1 use_foo_2

test: use_foo_1 use_foo_2 lib2.so broken.so
	@echo "*** Correct answers:"
	@echo "***   use_foo_1 = 7"
	@echo "***   use_foo_2 = 20"
	ln -s lib2.so libfoo.so
	LD_LIBRARY_PATH=. ./use_foo_1
	LD_LIBRARY_PATH=. ./use_foo_2
	rm libfoo.so
	@echo "*** Same code + incorrect map = segfault"
	ln -s broken.so libfoo.so
	LD_LIBRARY_PATH=. ./use_foo_1
	rm libfoo.so
	
