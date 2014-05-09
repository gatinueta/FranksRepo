#include <stdio.h>
#include <stdarg.h>
extern "C" {
__declspec(dllexport) void _cdecl func(int nargs, int normal, ... );
}

__declspec(dllexport) void _cdecl func(int nargs, int normal, ... )
{
 va_list ap;

 va_start(ap, normal);

 for (int i=0; i<nargs; i++) {
  printf("got: %s\n", va_arg(ap, char*));
 }

 va_end(ap);
}

