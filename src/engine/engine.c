#include <engine.h>

/**
 * [createNode description]
 * @param  tagName [description]
 * @return         [description]
 */
Node* createNode(const char* tagName)
{
	Node* node = calloc(1, sizeof(Node));
	node->tagName = tagName;
	return node;
}

/**
 * [appendChild description]
 * @param parent [description]
 * @param child  [description]
 */
void appendChild(Node* parent, Node* child)
{
	parent->length++;
	parent->children = realloc(parent->children, sizeof(Node*)*parent->length);
	parent->children[parent->length-1] = child;

	if(parent->length>1){
		parent->children[parent->length-2]->next = child;
		child->prev = parent->children[parent->length-2];
	}

	child->parent = parent;
}

// bool trackFile(const char* filename, void(*callback)(void))
// {
// 	struct stat buf;
// 	int timer;
// 	while(1){
// 		if(stat(filename, &buf)!=0){
// 			return false;
// 		}
// 		if(timer != buf.st_mtime){
// 			callback();
// 		}
// 		timer = buf.st_mtime;
// 		//sleep(1);
// 	}
// }
