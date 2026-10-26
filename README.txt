MINERVA 1.98 -- PLAIN MAKEFILE EDITION
===================================

This is a self-contained source build. No Python, converter, or earlier archive
is required. It rebuilds the original 48,822-byte ROM exactly.

You need GNU Make, GNU m68k ELF binutils, and a normal Unix/MSYS2 shell.

    make
    make verify

The default tools are m68k-elf-as, m68k-elf-ld, m68k-elf-objcopy and m68k-elf-nm.
If your installed cross-tools use another prefix:

    make CROSS=m68k-linux-gnu-
    make verify CROSS=m68k-linux-gnu-

The build was tested here with GNU binutils 2.42, m68k-linux-gnu ELF tools.

Other useful commands:

    make disassembly
    make clean

WHAT TO EDIT
------------

Edit the files in src/ directly. For example:

    src/ss_base.s       exception vectors and low-ROM code
    src/ss_ramt.s       startup RAM test
    src/sb_start.s      SuperBASIC startup
    src/tb_txt.s        message strings

minerva.s contains an explicit list of .include directives in ROM order.
src/constants.inc contains the constants, with local names already made unique.
The Makefile watches all these files and rebuilds when any one changes.
There is no automatic regeneration step that could overwrite your edits.

The 194 original source modules contributed 195 ROM sections: one module can
switch between sections (the message module also supplies tb_txt). This is why
there are 195 source includes rather than exactly 194.

The M<number>_ prefixes distinguish local names from different original modules.
module-order.json gives the zero-based module numbers and their original source
filenames. Public routine names retain their names. Original source lines and
comments are kept in /* QL: ... */ comments alongside the translated instructions.

HOW IT BUILDS
-------------

1. GNU as reads minerva.s and its includes, producing build/minerva.o.
2. GNU ld places that object at address zero, producing build/minerva.elf and
   build/minerva.map. The ELF entry address is the ROM reset entry, 0x410.
3. GNU objcopy extracts the raw ROM into build/minerva.rom.
4. GNU nm writes the complete address list into build/minerva.symbols.

The Makefile runs those tools directly and displays their command lines.
The sources remain separate files on disk; GAS sees them as one assembly unit.
Nothing concatenates them into a generated source file during this build.

WHY NOT A SEPARATE OBJECT FILE FOR EACH PART?
-------------------------------------------

That is possible in principle, but this translated source is not yet arranged
for it. Some tables subtract addresses in other source sections, mask the result
to 16 bits, or use values needed while GAS is choosing/encoding an instruction.
Not every such expression can be represented as a normal m68k ELF relocation.

For example, trying to assemble ss_list alone with the constants supplied gives
GAS errors about subtracting an undefined symbol from a text-section address.
When all sections are in one assembly unit, both addresses become known and the
same expressions resolve correctly.

A true separate-object port would need a deliberate pass over these expressions,
exports and linker layout, followed by the same byte comparison. Merely replacing
the include list with a Make pattern rule for individual objects is not enough.
Freezing addresses from today's symbol map would evade the error, but would make
source edits unsafe; this package does not do that.

For a ROM of only 48 KiB, one assembler invocation is quick, and this build keeps
both the modular files and the proven exact output.

VERIFYING THE RESULT
--------------------

    make verify

uses cmp to compare every byte with reference/min198.rom. Both the reference
and the unmodified build have SHA-256:

    aafbd3b0b2bf60d2cdeb139a355d552908b041ab021a1ff1b0be5547d9bcf2a2

The reference is used only for verification; it supplies no bytes to the build.
If you deliberately edit the ROM, verification should report a difference.
The original R1 package's additional Python assertion checker is not needed by
this edition; normal verification here is the complete binary comparison.

QLBOX
-----

This archive contains the ROM source and build only. Use the Minerva-capable
QLBox from the earlier R1 package to run build/minerva.rom. No padding is needed.
The unchanged ROM has the exact fingerprint that QLBox's R1 profile recognizes.
Layout-changing ROM edits may require updating that emulator profile too.

Existing Minerva source notices remain applicable. This build-system change
does not assign a new license to the original material.
