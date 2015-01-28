#ifndef _ENGINE_H_
#define _ENGINE_H_

#include <stdio.h>
#include <locale.h>
#include <wchar.h>
#include <sys/stat.h>
#include <unistd.h>
#include <malloc.h>
#include <stdint.h>
#include <stdbool.h>

int createWindow(int /*Window width*/, int /*Window height*/);

void callLib(const char* name);

/**
 * 
 */
typedef struct Node{
	struct Node* next;
	struct Node* prev;
	struct Node* parent;
	struct Node** children;
	size_t length;
	const char* tagName;
} Node;

Node* createNode(const char* tagName);
void appendChild(Node* parent, Node* child);


#endif
