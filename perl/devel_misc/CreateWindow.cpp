#include <windows.h> 
 
// Global variable 
 
HINSTANCE hinst; 
 
// Function prototypes. 
 
LRESULT CALLBACK MainWndProc(HWND, UINT, WPARAM, LPARAM); 
 
BOOL RegisterWindowClass(HINSTANCE hinstance, const LPCTSTR lpszClassName) 
{ 
    WNDCLASSEX wcx; 
 
    // Fill in the window class structure with parameters 
    // that describe the main window. 
 
    wcx.cbSize = sizeof(wcx);          // size of structure 
    wcx.style = CS_HREDRAW | 
        CS_VREDRAW;                    // redraw if size changes 
    wcx.lpfnWndProc = MainWndProc;     // points to window procedure 
    wcx.cbClsExtra = 0;                // no extra class memory 
    wcx.cbWndExtra = 0;                // no extra window memory 
    wcx.hInstance = hinstance;         // handle to instance 
    wcx.hIcon = LoadIcon(NULL, 
        IDI_APPLICATION);              // predefined app. icon 
    wcx.hCursor = LoadCursor(NULL, 
        IDC_ARROW);                    // predefined arrow 
    wcx.hbrBackground = GetStockObject( 
        WHITE_BRUSH);                  // white background brush 
    wcx.lpszMenuName =  "MainMenu";    // name of menu resource 
    wcx.lpszClassName = lpszClassName;  // name of window class 
    wcx.hIconSm = LoadImage(hinstance, // small class icon 
        MAKEINTRESOURCE(5),
        IMAGE_ICON, 
        GetSystemMetrics(SM_CXSMICON), 
        GetSystemMetrics(SM_CYSMICON), 
        LR_DEFAULTCOLOR); 
 
    // Register the window class. 
 
    return RegisterClassEx(&wcx);
} 
 
BOOL CreateDefaultWindow(HINSTANCE hinstance, const LPCTSTR lpszClassName) 
{ 
    HWND hwnd; 
  
    // Create the main window. 
 
    hwnd = CreateWindow( 
        lpszClassName,       // name of window class 
        "title-bar string",  // title-bar string 
        WS_OVERLAPPEDWINDOW, // top-level window 
        CW_USEDEFAULT,       // default horizontal position 
        CW_USEDEFAULT,       // default vertical position 
        CW_USEDEFAULT,       // default width 
        CW_USEDEFAULT,       // default height 
        (HWND) NULL,         // no owner window 
        (HMENU) NULL,        // use class menu 
        hinstance,           // handle to application instance 
        (LPVOID) NULL);      // no window-creation data 
 
    if (!hwnd) 
        return FALSE; 
 
    return TRUE; 
 
}

