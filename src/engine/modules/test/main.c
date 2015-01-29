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

void renderTree(Node* node, int depth)
{
	int i; for(i=0;i<depth;i++) printf("|  ");

	if(node->length){
		printf("%s(%i):\n", node->tagName, node->length);
		renderTree(node->children[0], depth+1);
	}else{
		printf("%s\n", node->tagName);
	}

	if(node->next){
		renderTree(node->next, depth);
	}
}


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

	Node* root = getRootNode();
	renderTree(root, 0);
}
