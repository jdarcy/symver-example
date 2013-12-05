#include <stdio.h>

extern int foo (int n);

int
main (int argc, char **argv)
{
        printf("use_foo_2: foo(13) = %d\n",foo(13));
        return 0;
}
