__asm__(".symver foo_1_0, foo@@FOO_1.0");
int
foo_1_0 (void)
{
        return 7;
}
