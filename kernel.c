extern void scrollup(unsigned int);
extern void print(char *);

extern kY;
extern kattr;

void _start(void) {
    kY = 18;
    kattr = 0x5e;
    print("un message\n");

    kattr = 0x4e;
    print("un autre message\n");

    scrollup(2);

    while(1);
}
