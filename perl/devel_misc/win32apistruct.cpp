#include <windows.h>
#include <stdio.h>

extern "C" __declspec(dllexport) int f(int x) {
    return x+1;
}

extern "C" __declspec(dllexport) int f2(SHORT x1, SHORT x2, BOOL add) {
    if (add) {
        return x1+x2;
    } else {
        return x1-x2;
    }
}

typedef struct {
    short x1;
    short x2;
    char s[20];
} MyStruct;

extern "C" __declspec(dllexport) void mod_struct(MyStruct *mystruct) {
    mystruct->x1++;
    mystruct->x2--;
    strcat(mystruct->s, ".");
}

extern "C" __declspec(dllexport) BOOL mod_int(int *ip) {
    if (ip == NULL) {
        printf("got a NULL pointer\n");
        return FALSE;
    } else {
        printf("got an int * of 0x%x, value is %d\n", ip, *ip);
        (*ip)++;
        return TRUE;
    }
}

extern "C" __declspec(dllexport) void print_void(void *vp, int kind) {
    printf("got the address 0x%x\n", vp);
    if (kind==0) {
        char *string = (char*)vp;
        printf("string: %s\n", string);
    } else if (kind==1) {
        int *ip = (int*)vp;
        printf("int: 0x%x\n", *ip);
    }
}

BOOL WINAPI DllMain(
  __in  HINSTANCE hinstDLL,
  __in  DWORD fdwReason,
  __in  LPVOID lpvReserved
) {
    return TRUE;
}

// cl /LD win32apistruct.cpp
