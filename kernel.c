extern void scrollup(unsigned int);
extern void print(char *);

extern kY;
extern kattr;

void _start(void) {
    kY = 18;
    kattr = 0x5e;
    print("%s\n","un message");

    kattr = 0x4e;
    print("%s\n","un autre message");

    scrollup(2);

    while(1);
}
