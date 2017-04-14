::comiles boot_mbr.asm and charity.asm
::creates a <bootdisk.img> from .bin files
::you have to run the dbd.exe yourself 
::because idk where it is located in your files
::then run the .img like lab9
nasm -fbin -oboot_mbr.bin boot_mbr.asm
nasm -fbin -ocharity.bin charity.asm
mkfloppy bootdisk.img boot_mbr.bin charity.bin

