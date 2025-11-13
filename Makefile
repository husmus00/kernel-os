FILES := ./build/kernel.asm.o ./build/kernel.o ./build/idt/idt.asm.o ./build/terminal/terminal.o ./build/idt/idt.o ./build/memory/memory.o ./build/io/io.asm.o ./build/memory/heap/heap.o ./build/memory/heap/kernelheap.o ./build/memory/paging/paging.o ./build/memory/paging/paging.asm.o ./build/disk/disk.o ./build/fs/pparser.o ./build/string/string.o ./build/disk/streamer.o ./build/fs/file.o ./build/fs/fat/fat16.o ./build/gdt/gdt.asm.o ./build/gdt/gdt.o ./build/task/tss.asm.o ./build/task/tss.o ./build/task/task.o ./build/task/process.o ./build/task/task.asm.o ./build/isr80h/isr80h.o ./build/isr80h/misc.o ./build/isr80h/heap.o ./build/isr80h/process.o ./build/keyboard/keyboard.o ./build/keyboard/classic.o ./build/loader/formats/elf.o ./build/loader/formats/elfloader.o
INCLUDES = -I./src
FLAGS = -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

.PHONY: all user_programs user_programs_clean clean directories

all: ./bin/boot.bin ./bin/kernel.bin user_programs
	rm -rf ./bin/os.bin
	dd if=./bin/boot.bin >> ./bin/os.bin
	dd if=./bin/kernel.bin >> ./bin/os.bin
	dd if=/dev/zero bs=1048576 count=16 >> ./bin/os.bin
    # Copy a file over
	sudo mount -t vfat ./bin/os.bin /mnt/d
	sudo cp ./extra/hello.txt /mnt/d
	sudo cp ./programs/blank/blank.elf /mnt/d
	sudo cp ./programs/shell/shell.elf /mnt/d
	sudo umount /mnt/d

directories:
	mkdir -p ./bin
	mkdir -p ./build/idt
	mkdir -p ./build/terminal
	mkdir -p ./build/memory/heap
	mkdir -p ./build/memory/paging
	mkdir -p ./build/io
	mkdir -p ./build/disk
	mkdir -p ./build/fs/fat
	mkdir -p ./build/string
	mkdir -p ./build/gdt
	mkdir -p ./build/task
	mkdir -p ./build/isr80h
	mkdir -p ./build/keyboard
	mkdir -p ./build/loader/formats

./bin/kernel.bin: $(FILES)
	i686-elf-ld -g -relocatable $(FILES) -o ./build/kernelfull.o
	i686-elf-gcc $(FLAGS) -T ./src/linker.ld -o ./bin/kernel.bin -ffreestanding -O0 -nostdlib ./build/kernelfull.o

./bin/boot.bin: ./src/boot/boot.asm | directories
	nasm -f bin ./src/boot/boot.asm -o ./bin/boot.bin

./build/kernel.asm.o: ./src/kernel.asm | directories
	nasm -f elf -g ./src/kernel.asm -o ./build/kernel.asm.o

./build/kernel.o: ./src/kernel.c | directories
	i686-elf-gcc $(INCLUDES) $(FLAGS) -std=gnu99 -c ./src/kernel.c -o ./build/kernel.o

./build/terminal/terminal.o: ./src/terminal/terminal.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/terminal $(FLAGS) -std=gnu99 -c ./src/terminal/terminal.c -o ./build/terminal/terminal.o

./build/memory/memory.o: ./src/memory/memory.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/memory $(FLAGS) -std=gnu99 -c ./src/memory/memory.c -o ./build/memory/memory.o

./build/idt/idt.o: ./src/idt/idt.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/idt $(FLAGS) -std=gnu99 -c ./src/idt/idt.c -o ./build/idt/idt.o

./build/idt/idt.asm.o: ./src/idt/idt.asm | directories
	nasm -f elf -g ./src/idt/idt.asm -o ./build/idt/idt.asm.o

./build/io/io.asm.o: ./src/io/io.asm | directories
	nasm -f elf -g ./src/io/io.asm -o ./build/io/io.asm.o

./build/memory/heap/heap.o: ./src/memory/heap/heap.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/memory/heap $(FLAGS) -std=gnu99 -c ./src/memory/heap/heap.c -o ./build/memory/heap/heap.o

./build/memory/heap/kernelheap.o: ./src/memory/heap/kernelheap.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/memory/heap $(FLAGS) -std=gnu99 -c ./src/memory/heap/kernelheap.c -o ./build/memory/heap/kernelheap.o

./build/memory/paging/paging.asm.o: ./src/memory/paging/paging.asm | directories
	nasm -f elf -g ./src/memory/paging/paging.asm -o ./build/memory/paging/paging.asm.o

./build/memory/paging/paging.o: ./src/memory/paging/paging.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/memory/paging $(FLAGS) -std=gnu99 -c ./src/memory/paging/paging.c -o ./build/memory/paging/paging.o

./build/disk/disk.o: ./src/disk/disk.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/disk $(FLAGS) -std=gnu99 -c ./src/disk/disk.c -o ./build/disk/disk.o

./build/fs/pparser.o: ./src/fs/pparser.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/fs $(FLAGS) -std=gnu99 -c ./src/fs/pparser.c -o ./build/fs/pparser.o

./build/string/string.o: ./src/string/string.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/string $(FLAGS) -std=gnu99 -c ./src/string/string.c -o ./build/string/string.o

./build/disk/streamer.o: ./src/disk/streamer.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/disk $(FLAGS) -std=gnu99 -c ./src/disk/streamer.c -o ./build/disk/streamer.o

./build/fs/file.o: ./src/fs/file.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/fs $(FLAGS) -std=gnu99 -c ./src/fs/file.c -o ./build/fs/file.o

./build/fs/fat/fat16.o: ./src/fs/fat/fat16.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/fs -I./src/fs/fat $(FLAGS) -std=gnu99 -c ./src/fs/fat/fat16.c -o ./build/fs/fat/fat16.o

./build/gdt/gdt.asm.o: ./src/gdt/gdt.asm | directories
	nasm -f elf -g ./src/gdt/gdt.asm -o ./build/gdt/gdt.asm.o

./build/gdt/gdt.o: ./src/gdt/gdt.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/gdt $(FLAGS) -std=gnu99 -c ./src/gdt/gdt.c -o ./build/gdt/gdt.o

./build/task/tss.asm.o: ./src/task/tss.asm | directories
	nasm -f elf -g ./src/task/tss.asm -o ./build/task/tss.asm.o

./build/task/tss.o: ./src/task/tss.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/task $(FLAGS) -std=gnu99 -c ./src/task/tss.c -o ./build/task/tss.o

./build/task/task.o: ./src/task/task.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/task $(FLAGS) -std=gnu99 -c ./src/task/task.c -o ./build/task/task.o

./build/task/process.o: ./src/task/process.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/task $(FLAGS) -std=gnu99 -c ./src/task/process.c -o ./build/task/process.o

./build/task/task.asm.o: ./src/task/task.asm | directories
	nasm -f elf -g ./src/task/task.asm -o ./build/task/task.asm.o

./build/isr80h/isr80h.o: ./src/isr80h/isr80h.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/isr80h $(FLAGS) -std=gnu99 -c ./src/isr80h/isr80h.c -o ./build/isr80h/isr80h.o

./build/isr80h/misc.o: ./src/isr80h/misc.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/isr80h $(FLAGS) -std=gnu99 -c ./src/isr80h/misc.c -o ./build/isr80h/misc.o

./build/isr80h/heap.o: ./src/isr80h/heap.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/isr80h $(FLAGS) -std=gnu99 -c ./src/isr80h/heap.c -o ./build/isr80h/heap.o

./build/isr80h/process.o: ./src/isr80h/process.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/isr80h $(FLAGS) -std=gnu99 -c ./src/isr80h/process.c -o ./build/isr80h/process.o

./build/keyboard/keyboard.o: ./src/keyboard/keyboard.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/keyboard $(FLAGS) -std=gnu99 -c ./src/keyboard/keyboard.c -o ./build/keyboard/keyboard.o

./build/keyboard/classic.o: ./src/keyboard/classic.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/keyboard $(FLAGS) -std=gnu99 -c ./src/keyboard/classic.c -o ./build/keyboard/classic.o

./build/loader/formats/elf.o: ./src/loader/formats/elf.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/loader/formats/ $(FLAGS) -std=gnu99 -c ./src/loader/formats/elf.c -o ./build/loader/formats/elf.o

./build/loader/formats/elfloader.o: ./src/loader/formats/elfloader.c | directories
	i686-elf-gcc $(INCLUDES) -I./src/loader/formats/ $(FLAGS) -std=gnu99 -c ./src/loader/formats/elfloader.c -o ./build/loader/formats/elfloader.o

user_programs:
	cd ./programs/stdlib && $(MAKE) all
	cd ./programs/blank && $(MAKE) all
	cd ./programs/shell && $(MAKE) all

user_programs_clean:
	cd ./programs/stdlib && $(MAKE) clean
	cd ./programs/blank && $(MAKE) clean
	cd ./programs/shell && $(MAKE) clean

clean: user_programs_clean
	rm -rf ./bin/boot.bin
	rm -rf ./bin/kernel.bin
	rm -rf ./bin/os.bin
	rm -rf $(FILES)
	rm -rf ./build/kernelfull.o
