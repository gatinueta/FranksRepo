#include <windows.h>
#include <Security.h>
#include <stdio.h>

int main() {
  char userName[1000];
  DWORD len = sizeof(userName);

  if (GetUserNameEx(NameSamCompatible, userName, &len)) {
    printf("you are %s\n", userName);
  }

  return 0;
}

