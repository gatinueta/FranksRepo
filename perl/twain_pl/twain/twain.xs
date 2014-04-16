#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"


MODULE = twain		PACKAGE = twain		

void
hello()
CODE:
    printf("Hello, world!\n");

void 
printme(int x)
CODE:
    printf("you gave me %d\n", x);


