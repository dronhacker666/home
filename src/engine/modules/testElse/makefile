MODULE_NAME = testElse

SRC = $(wildcard *.c)
OBJ = $(SRC:.c=.$(for).o)

all: $(MODULES_LIB)/$(MODULE_NAME)
	
$(MODULES_LIB)/$(MODULE_NAME): $(OBJ)
	$(LD) $(filter %.o,$^) -shared -o $(MODULES_LIB)/$(MODULE_NAME)

%.$(for).o: %.c
	$(CC) -c $^ -o $@ -fpic $(addprefix -I,$(INCLUDE_PATH))
