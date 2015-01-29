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


	Node* subnode = createNode("ROOM");
		appendChild(subnode, createNode("CAMERA"));
		appendChild(subnode, createNode("LIGHT"));

	appendChild(body, subnode);

	//printf("%s\n", body->prev->tagName);


	callLib(L"test");
	//callLib("testElse");

	//trackFile("/home/andrey/projects/new/testfile");

	return 0;
}
