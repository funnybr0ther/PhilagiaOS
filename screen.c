#include "types.h"

#define RAMSCREEN 0xB8000 // debut de la memoire video
#define SIZESCREEN 0xFA0 // 4000, nombres d'ocets d'une page texte
#define SCREENLIM 0xB8FA0

// position courante du curseur
char kX = 0;
char kY = 17;
// attributs video des caracteres a afficher
char kattr = 0x0E;

// scroll l'ecran vers le haut de n lignes (de 0 a 25)
void scrollup(unsigned int n) {
    unsigned char *video, *tmp;
    for (video = (unsigned char *) RAMSCREEN;
            video < (unsigned char *) SCREENLIM;
            video += 2) {
        if (tmp < (unsigned char *) SCREENLIM) {
            *video = *tmp;
            *(video + 1) = *(tmp + 1);
        } else {
            *video = 0;
            *(video + 1) = 0x07;
        }
    }
    kY -= n;
    if (kY < 0)
        kY = 0;
}
void putchar(uchar c) {
    unsigned char *video;
    int i;
    if (c == 10) { // CR-LN
        kX = 0;
        kY++;
    } else if (c == 9) { // TAB
        kY = kX + 8 - (kX % 8);
    } else if (c == 13) { // CR
        kX = 0;
    } else { // autres caracteres
        video = (unsigned char *) (RAMSCREEN + 2 * kX + 160 * kY);
        *video = c;
        *(video + 1) = kattr;

        kX++;
        if (kX > 79) {
            kX = 0;
            kY++;
        }
    }
    if (kY > 24)
        scrollup(kY -24);
}
void print(char *string) {
    // tant que le caractere est different de 0x0
    while (*string != 0) {
        putchar(*string);
        string++;
    }
}
