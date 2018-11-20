#include <stdio.h>

int main(int argc, char **argv) {
    printf("Hello world, I received %d arguments\n", argc);
    int i;
    for (i=0; i<argc; i++) {
        printf("  argument number %d: %s\n", i, argv[i]);
    }
    return 0;
}

