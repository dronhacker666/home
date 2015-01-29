#include <engine.h>

#include <dlfcn.h>
#include <X11/X.h>
#include <X11/Xlib.h>

int createWindow(int width, int height)
{
	wprintf(L"Screen size русский текст: %ix%i\n", width, height);
	return 0;
}


void callLib(const wchar_t* name)
{
	char path[256];
	wchar_t tpath[256] = L"../../"MODULES_LIB"/";
	wcscat(tpath, name);

	wcstombs(path, tpath, sizeof(path));

	void* lib = dlopen(path, RTLD_LAZY);
	if(!lib){
		printf("DL error %s\n", dlerror());
		exit(-1);
	}
	void(*fn)(void) = dlsym(lib, "render");
	if(!fn){
		printf("DL error %s\n", dlerror());
		exit(-1);
	}
	fn();
	dlclose(lib);
}
