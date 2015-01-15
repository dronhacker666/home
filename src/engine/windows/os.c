#include <engine.h>

#include <windows.h>


int createWindow(int width, int height)
{
	MSG Msg;
	HWND hwnd = CreateWindowEx(WS_EX_TOPMOST, L"Edit", L"Game", WS_OVERLAPPED, 0, 0, width, height, 0, 0, 0, 0);

	ShowWindow(hwnd, SW_SHOW);

	// int x = (GetSystemMetrics(SM_CXSCREEN));
	// int y = (GetSystemMetrics(SM_CYSCREEN));

	while(GetMessage(&Msg, NULL, 0, 0) > 0)
	{
		TranslateMessage(&Msg);
		DispatchMessage(&Msg);

		if(GetAsyncKeyState(VK_ESCAPE)){
			break;
		}
	}

	wprintf(L"Screen size русский текст: %ix%i\n", width, height);

	return 0;
}
