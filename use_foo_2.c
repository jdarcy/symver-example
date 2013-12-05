#include <stdio.h>

extern int foo (int (*callback) (void));

int
main (int argc, char **argv)
{
        int my_cb (void) { return 13; }
        printf("use_foo_2: foo(my_cb) = %d\n",foo(my_cb));
        return 0;
}
