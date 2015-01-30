CCFLAGS=-Wall -Wconversion -D UNICODE 

ENGINE_NAME = engine
PLAYER_NAME = player
EDITOR_NAME = editor

LIB_PATH = lib/$(for)
INCLUDE_PATH = include


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
		CC = cc.exe
		AR = ar.exe
		EXPORT = --export-all-symbols
	endif
endif
ifeq ($(SYSTEM),linux)
	ifeq ($(for),windows)
		CC = i586-mingw32msvc-cc
		AR = i586-mingw32msvc-ar
		LD = i586-mingw32msvc-ld
		EXPORT = --export-all-symbols
	endif
	ifeq ($(for),linux)
		CC = cc
		AR = ar
		LD = ld
		EXPORT = -E
	endif
endif

ifeq ($(for),windows)
	PLAYER_NAME := $(PLAYER_NAME).exe
	EDITOR_NAME := $(EDITOR_NAME).exe
endif
ifeq ($(for),linux)
endif

CCFLAGS += -D $(call uc,$(for))

vpath %.a $(LIB_PATH)

.PHONY: all engine build player

all: info build
	
info:
	@echo Detect platform $(SYSTEM)
	@echo Build for $(for)
	@echo Use \"$(CC)\" compiler

build: engine	

bin/$(for):
	$(call mkdir,bin/$(for))

$(LIB_PATH):
	$(call mkdir,$(LIB_PATH))

# ------ EDITOR ------
EDITOR_SRC = $(wildcard src/player/*.c)
EDITOR_OBJ = $(EDITOR_SRC:.c=.$(for).o)
editor: bin/$(for) engine $(EDITOR_OBJ)
	$(CC) $(filter %.o,$^) \
		-o bin/$(for)/$(EDITOR_NAME) \
		$(addprefix -L,$(LIB_PATH)) \
		-lengine $(addprefix -l,$(ENGINE_LINK))

# ------ PLAYER ------
PLAYER_SRC = $(wildcard src/player/*.c)
PLAYER_OBJ = $(PLAYER_SRC:.c=.$(for).o)
player: bin/$(for) engine $(PLAYER_OBJ)
	$(CC) $(filter %.o,$^) \
		-o bin/$(for)/$(PLAYER_NAME) \
		$(addprefix -L,$(LIB_PATH)) \
		$(addprefix -l,$(ENGINE_LINK)) -Wl,$(EXPORT)


# ------ ENGINE ------
INCLUDE_PATH += src/engine
ENGINE_SRC = $(wildcard src/engine/*.c) $(wildcard src/engine/$(for)/*.c)
ENGINE_OBJ = $(ENGINE_SRC:.c=.$(for).o)

ENGINE_LINK = engine
ifeq ($(for),windows)
	ENGINE_LINK += opengl32 glu32 kernel32
endif
ifeq ($(for),linux)
	ENGINE_LINK += X11 GL GLU dl
endif

engine: -l$(ENGINE_NAME)

-l$(ENGINE_NAME): $(LIB_PATH) $(ENGINE_OBJ)
	$(AR) rcs $(LIB_PATH)/lib$(ENGINE_NAME).a $(filter %.o,$?)

run:
	cd bin/$(for) && ./$(PLAYER_NAME)

%.$(for).o: %.c
	$(CC) -c $^ -o $@ $(addprefix -I,$(INCLUDE_PATH)) $(CCFLAGS)

clean:
	rm -rf bin
	rm -f src/*/*.o
	rm -f src/*/*/*.o


# MODULES
MODULES_PATH = src/engine/modules
MODULES_LIB = $(LIB_PATH)/modules

CCFLAGS += -D MODULES_LIB=\"$(MODULES_LIB)\"

MODULES_DEF += -D $(call uc,$(for))

MODULES_ARGS += for=$(for)
MODULES_ARGS += CC=$(CC)
MODULES_ARGS += LD=$(LD)
MODULES_ARGS += MODULES_LIB=$(abspath $(MODULES_LIB))
MODULES_ARGS += INCLUDE_PATH=$(abspath src/engine)
MODULES_ARGS += MODULES_DEF='$(MODULES_DEF)'

$(MODULES_LIB):
	$(call mkdir,$(MODULES_LIB))

module_%: $(MODULES_LIB)
	$(MAKE) -C $(patsubst module_%,$(MODULES_PATH)/%,$@) $(MODULES_ARGS) 

all_modules: $(patsubst $(MODULES_PATH)/%/,module_%,$(dir $(wildcard $(MODULES_PATH)/*/)))


# FUNCTIONS
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))
uc = $(subst a,A,$(subst b,B,$(subst c,C,$(subst d,D,$(subst e,E,$(subst f,F,$(subst g,G,$(subst h,H,$(subst i,I,$(subst j,J,$(subst k,K,$(subst l,L,$(subst m,M,$(subst n,N,$(subst o,O,$(subst p,P,$(subst q,Q,$(subst r,R,$(subst s,S,$(subst t,T,$(subst u,U,$(subst v,V,$(subst w,W,$(subst x,X,$(subst y,Y,$(subst z,Z,$1))))))))))))))))))))))))))

ifeq ($(SYSTEM),windows)
	mkdir = mkdir $(subst /,\\,$1)
endif
ifeq ($(SYSTEM),linux)
	mkdir = mkdir -p $1
endif
