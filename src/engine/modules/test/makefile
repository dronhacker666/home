MODULE_NAME = test

SRC = $(wildcard *.c)
OBJ = $(SRC:.c=.$(for).o)

ifeq ($(for),windows)
	LINK = 
endif
ifeq ($(for),linux)
	LINK =
endif

all: $(MODULES_LIB)/$(MODULE_NAME)
	
$(MODULES_LIB)/$(MODULE_NAME): $(OBJ)
	$(CC) $(filter %.o,$^) -shared -o $(MODULES_LIB)/$(MODULE_NAME) $(addprefix -l,$(LINK))

%.$(for).o: %.c
	$(CC) -c $^ -o $@ -fpic $(addprefix -I,$(INCLUDE_PATH)) $(MODULES_DEF)
