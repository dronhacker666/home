CCFLAGS=-Wall -D UNICODE

ENGINE_NAME = engine
PLAYER_NAME = player
EDITOR_NAME = editor

LIB_PATH = lib/$(for)
INCLUDE_PATH = 

#http://stackoverflow.com/questions/714100/os-detecting-makefile
ifeq ($(OS),Windows_NT)
	SYSTEM = windows
else
	UNAME := $(shell uname -s)
	ifeq ($(UNAME),Linux)
		SYSTEM = linux
	endif
endif

# use argument "for" for set build platform
# example: make for=windows
for = $(SYSTEM)
ifeq ($(SYSTEM),windows)
	ifeq ($(for),windows)
		CC = mingw32-cc.exe
		AR = mingw32-ar.exe
	endif
endif
ifeq ($(SYSTEM),linux)
	ifeq ($(for),windows)
		CC = i586-mingw32msvc-gcc
		AR = i586-mingw32msvc-ar
	endif
	ifeq ($(for),linux)
		CC = cc
		AR = ar
	endif
endif

ifeq ($(for),windows)
	PLAYER_NAME := $(PLAYER_NAME).exe
	EDITOR_NAME := $(EDITOR_NAME).exe
	CCFLAGS += -D WINDOWS
endif
ifeq ($(for),linux)
	CCFLAGS += -D LINUX
endif



define prepare_obj
	$(eval _OBJ := $(filter %.o,$1)) \
	$(join $(dir $(_OBJ)), $(addprefix $(for)_,$(notdir $(_OBJ))))
endef


.PHONY: all engine build player

all: info build
	
info:
	@echo Detect platform $(SYSTEM)
	@echo Build for $(for)
	@echo Use \"$(CC)\" compiler

build: engine	

# ------ EDITOR ------
EDITOR_SRC = $(wildcard src/player/*.c)
EDITOR_OBJ = $(EDITOR_SRC:.c=.o)
editor: engine $(EDITOR_OBJ)
	mkdir -p bin/$(for)
	$(CC) $(call prepare_obj,$^) \
		-o bin/$(for)/$(EDITOR_NAME) \
		$(addprefix -L,$(LIB_PATH)) \
		-lengine $(addprefix -l,$(ENGINE_LINK))

# ------ PLAYER ------
PLAYER_SRC = $(wildcard src/player/*.c)
PLAYER_OBJ = $(PLAYER_SRC:.c=.o)
player: engine $(PLAYER_OBJ)
	mkdir -p bin/$(for)
	$(CC) $(call prepare_obj,$^) \
		-o bin/$(for)/$(PLAYER_NAME) \
		$(addprefix -L,$(LIB_PATH)) \
		-lengine $(addprefix -l,$(ENGINE_LINK))


# ------ ENGINE ------
INCLUDE_PATH += src/engine
ENGINE_SRC = $(wildcard src/engine/*.c) $(wildcard src/engine/$(for)/*.c)
ENGINE_OBJ = $(ENGINE_SRC:.c=.o)

ifeq ($(for),windows)
	ENGINE_LINK += opengl32 glu32
endif
ifeq ($(for),linux)
	ENGINE_LINK += X11 GL GLU
endif

engine: $(ENGINE_OBJ)
	mkdir -p lib/$(for)
	$(AR) rcs lib/$(for)/lib$(ENGINE_NAME).a $(call prepare_obj,$^)



run:
	./bin/$(for)/$(PLAYER_NAME)

.c.o:
	$(CC) -c $< -o $(dir $@)$(for)_$(notdir $@) $(addprefix -I,$(INCLUDE_PATH)) $(CCFLAGS)

clean:
	rm -f *.o