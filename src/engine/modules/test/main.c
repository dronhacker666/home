#include <engine.h>

#ifdef WINDOWS
	#include <windows.h>


BOOL WINAPI DllMain(HANDLE hModule, DWORD dwFunction, LPVOID lpNot)
{
	return TRUE;
}

#endif

#ifdef LINUX
	#include <dlfcn.h>
#endif


Node* (*getRootNode)(void) = NULL;

void render(void)
{
	printf("%s\n", "I'am test module!!!");
	
	#ifdef WINDOWS
		HINSTANCE hndl = GetModuleHandle(NULL);
		getRootNode = GetProcAddress(hndl, "getRootNode");
	#endif
	#ifdef LINUX
		void* hndl = dlopen(NULL, RTLD_LAZY);
		Node* (*getRootNode)(void) = dlsym(hndl, "getRootNode");
	#endif

	printf("%i\n", getRootNode);

	//Node* root = getRootNode();
	//printf("%s\n", root->tagName);
}
