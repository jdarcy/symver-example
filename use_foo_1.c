#include <stdio.h>

extern int foo (void);

int
main (int argc, char **argv)
{
        printf("use_foo_1: foo() = %d\n",foo());
        return 0;
}
