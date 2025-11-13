FILES=./build/blank.o
INCLUDES= -I../stdlib/src
FLAGS= -g # -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

.PHONY: all clean

all: $(FILES)
	i686-elf-gcc -g -T ./linker.ld -o ./blank.elf -ffreestanding -O0 -nostdlib -fpic -g $(FILES) ../stdlib/stdlib.elf

./build/blank.o: ./blank.c | build
	i686-elf-gcc $(INCLUDES) -I./ $(FLAGS) -std=gnu99 -c ./blank.c -o ./build/blank.o

build:
	mkdir -p ./build

clean:
	rm -rf $(FILES)
	rm -f ./blank.elf