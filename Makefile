# Minerva 1.98 -- plain GNU Make + GNU m68k binutils.
# No Python or source generator is used by this build.
#
#   make                         build the ROM and maps
#   make verify                  compare every byte with the original ROM
#   make disassembly             also produce a disassembly
#   make clean                   remove generated output only
#   make CROSS=m68k-linux-gnu-    use a different GNU tool prefix
#
# Edit src/*.s directly. minerva.s lists their ROM order.

CROSS    ?= m68k-elf-
AS       = $(CROSS)as
LD       = $(CROSS)ld
OBJCOPY  = $(CROSS)objcopy
NM       = $(CROSS)nm
OBJDUMP  = $(CROSS)objdump

ASFLAGS  = -m68000 --register-prefix-optional --bitwise-or -I .
SOURCES  = minerva.s $(wildcard src/*.s src/*.inc)
OUT      = build

.PHONY: all verify disassembly clean
.DELETE_ON_ERROR:

all: $(OUT)/minerva.rom $(OUT)/minerva.symbols

$(OUT):
	mkdir -p $(OUT)

# GAS reads each .include from minerva.s; all names are visible in one assembly.
$(OUT)/minerva.o: $(SOURCES) | $(OUT)
	$(AS) $(ASFLAGS) -o $@ minerva.s

# Link at ROM address zero; the reset vector points to address 0x410.
# The linker also writes minerva.map alongside the ELF file.
$(OUT)/minerva.elf: $(OUT)/minerva.o
	$(LD) -Ttext=0 -e 0x410 -Map $(OUT)/minerva.map -o $@ $<

$(OUT)/minerva.rom: $(OUT)/minerva.elf
	$(OBJCOPY) -O binary $< $@

$(OUT)/minerva.symbols: $(OUT)/minerva.elf
	$(NM) -n $< > $@

# cmp is supplied by Linux, macOS and MSYS2. It returns failure on any difference.
verify: all
	cmp reference/min198.rom $(OUT)/minerva.rom
	@echo "PASS: all 48822 bytes match the original Minerva 1.98 ROM."

disassembly: $(OUT)/minerva.disassembly.txt

$(OUT)/minerva.disassembly.txt: $(OUT)/minerva.elf
	$(OBJDUMP) -d $< > $@

clean:
	rm -rf $(OUT)
