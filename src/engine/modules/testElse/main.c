#include <engine.h>

void render(void)
{
	printf("%s\n", "I'am test module!!!");
}

void _init(void)
{
	printf("%s\n", "call _init");
}

void _fini(void)
{
	printf("%s\n", "call _fini");
}
