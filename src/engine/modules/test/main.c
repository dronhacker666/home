#include <engine.h>

void render(void)
{
	Node* root = getRootNode();
	printf("%s\n", "I'am test module!!!");
	printf("%s\n", root->tagName);
}

void _init(void)
{
	printf("%s\n", "call _init");
}

void _fini(void)
{
	printf("%s\n", "call _fini");
}