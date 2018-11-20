#include <unistd.h>
#include <strings.h>
#include <stdio.h>
#include <stdlib.h>

extern int errno;

int main() {
    char *ac[4];
    ac[0] = "eins";
    ac[1] = "zwei";
    ac[2] = " ";
    ac[3] = (char*) 1;
    execvp("./hello", ac);
    printf("execvp failed: %s\n", strerror(errno));
    return 0;
}


