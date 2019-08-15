mkdir bin 2>/dev/null

nasm -f bin -o bin/thugbootloader.bin src/thugbootloader.asm
nasm -f bin -o bin/thugkernel.bin src/thugkernel.asm

cat bin/thugbootloader.bin bin/thugkernel.bin > bin/thugboot.bin
rm bin/thugbootloader.bin bin/thugkernel.bin
