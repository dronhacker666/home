#include <engine.h>

#include <dlfcn.h>

Node* html;

Node* getRootNode(void)
{
	return html;
}

void callLib(const char* name)
{
	char path[256] = "../../"MODULES_LIB"/";
	strcat(path, name);

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

int main(void)
{
	setlocale(LC_ALL, "ru_RU.utf8");

	html = createNode("HTML");
	Node* head = createNode("HEAD");
	Node* body = createNode("BODY");

	appendChild(html, head);
	appendChild(html, body);


	printf("%s\n", body->prev->tagName);


	callLib("test");
	callLib("testElse");

	//trackFile("/home/andrey/projects/new/testfile");

	return 0;
}
