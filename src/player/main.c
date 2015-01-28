#include <engine.h>

Node* html;

Node* getRootNode(void)
{
	return html;
}


int main(void)
{
	setlocale(LC_ALL, "ru_RU.utf8");

	html = createNode("HTML");
	Node* head = createNode("HEAD");
	Node* body = createNode("BODY");

	appendChild(html, head);
	appendChild(html, body);


	//printf("%s\n", body->prev->tagName);


	callLib("test");
	//callLib("testElse");

	//trackFile("/home/andrey/projects/new/testfile");

	return 0;
}
