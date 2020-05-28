#!/bin/bash

arm-none-eabi-as div.s -o div.o ;
arm-none-eabi-ld div.o -o div.elf ;
arm-none-eabi-objdump -d div.elf > div.elf.list ;

rm *.o *.elf ;
cat div.elf.list ;
