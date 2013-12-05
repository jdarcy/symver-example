__asm__(".symver foo_2_0, foo@@FOO_2.0");
int
foo_2_0 (int (*callback) (void))
{
        return callback() + 7;
}

__asm__(".symver foo_1_0, foo@FOO_1.0");
int
foo_1_0 (void)
{
        int default_cb (void) { return 0; }
        return foo_2_0(default_cb);
}
