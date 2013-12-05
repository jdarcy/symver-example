__asm__(".symver foo_2_0, foo@@FOO_2.0");
int
foo_2_0 (int n)
{
        return n + 7;
}

__asm__(".symver foo_1_0, foo@FOO_1.0");
int
foo_1_0 (void)
{
        return foo_2_0(0);
}
