/* ROM section pa_chnlt */
.balign 2,0
/* QL: * a0 -i o- buffer pointer (unchanged if ret+0 or moved past valid name ret+2) */
/* QL: * d1-d2 destroyed */
/* QL: pa_chnlt */
pa_chnlt:
/* QL:         bsr.s   pa_alfnm */
    bsr.s pa_alfnm
/* QL:         bcc.s   M135_cdunrec         first char must be a letter */
    bcc.s M135_cdunrec
/* QL: M135_nxchr */
M135_nxchr:
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         bsr.s   pa_alfnm        is next alphanumeric? */
    bsr.s pa_alfnm
/* QL:         bls.s   M135_nxchr           yes - keep going */
    bls.s M135_nxchr
/* QL:         sub.b   #'$',d1 */
    sub.b #(36&255),d1
/* QL:         lsr.b   #1,d1           note: '$'+1='%' */
    lsr.b #1,d1
/* QL:         bne.s   M135_end_nam */
    bne.s M135_end_nam
/* QL:         addq.l  #1,a0           move past a final '$' or '%' */
    addq.l #1,a0
/* QL: M135_end_nam */
M135_end_nam:
/* QL:         addq.l  #2,(sp) */
    addq.l #2,(sp)
/* QL: M135_cdunrec */
M135_cdunrec:
/* QL:         rts */
    rts 
/* QL: * Fetch a character and establish its alphanumeric type. */
/* QL: * d1 -  o- character fetched */
/* QL: * d2 -  o- lsw char type, 0=numeric 1=uppercase 2=other 3=lowercase. msw junk */
/* QL: * a0 -ip - pointer, relative to a6, for character under test */
/* QL: * Flags: */
/* QL: *       z       0     beq for numeric */
/* QL: *       c       1/3   bcs for alpha */
/* QL: *       zvc     0/1/3 bls for alphanumeric */
/* QL: pa_alfnm */
pa_alfnm:
/* QL:         moveq   #0,d1           default is zero */
    moveq #0,d1
/* QL:         move.b  0(a6,a0.l),d1   look at initial char */
    move.b 0(a6,a0.l),d1
/* QL:         move.l  d1,d2 */
    move.l d1,d2
/* QL:         ror.l   #2,d2           d2.w has char/4 - top has bottom bits */
    ror.l #2,d2
/* QL:         move.b  M135_chtypes(pc,d2.w),d2 gives bits for 4 chars */
    move.b M135_chtypes(pc,d2.w),d2
/* QL:         swap    d2              byte from type-table in d2 top word */
    swap d2
/* QL:         rol.w   #3,d2           get 2 bottom bits into d2.w bits 1,2 */
    rol.w #3,d2
/* QL:         lsr.l   d2,d2           shift (upper word) right 2n bits */
    lsr.l d2,d2
/* QL:         clr.w   d2              clear lsw */
    clr.w d2
/* QL:         ror.l   #2,d2           bits 15-14 get char value */
    ror.l #2,d2
/* QL:         rol.w   #2,d2           bits 1-0 of d2 have char type */
    rol.w #2,d2
/* QL:         rts */
    rts 
/* QL: * the table of char types yields the folowing: */
/* QL: *       00 - digits '0' to '9' */
/* QL: *       01 - uppercase 'A' to 'Z', '_' and chars 160-171. */
/* QL: *       11 - lowercase 'a' to 'z' and chars 128-156. */
/* QL: *       10 - non-alphanumeric, i.e. all other characters */
/* QL: * The lowest character code is in the least significant bits of each byte */
/* QL: M135_nnnn equ %00000000 */
.equ M135_nnnn,0b00000000
/* QL: M135_uuuu equ %01010101 */
.equ M135_uuuu,0b01010101
/* QL: M135_xuuu equ %01010110 */
.equ M135_xuuu,0b01010110
/* QL: M135_xxxu equ %01101010 */
.equ M135_xxxu,0b01101010
/* QL: M135_uuux equ %10010101 */
.equ M135_uuux,0b10010101
/* QL: M135_nnxx equ %10100000 */
.equ M135_nnxx,0b10100000
/* QL: M135_xxxx equ %10101010 */
.equ M135_xxxx,0b10101010
/* QL: M135_lxxx equ %10101011 */
.equ M135_lxxx,0b10101011
/* QL: M135_lllx equ %10111111 */
.equ M135_lllx,0b10111111
/* QL: M135_xlll equ %11111110 */
.equ M135_xlll,0b11111110
/* QL: M135_llll equ %11111111 */
.equ M135_llll,0b11111111
/* QL: M135_chtypes */
M135_chtypes:
/* QL:  dc.b M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx 0-31 */
M135_dc_anchor_102:
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
/* QL:  dc.b M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_nnnn,M135_nnnn,M135_nnxx,M135_xxxx space to '?' */
M135_dc_anchor_112:
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_nnnn)&255
.byte (M135_nnnn)&255
.byte (M135_nnxx)&255
.byte (M135_xxxx)&255
/* QL:  dc.b M135_xuuu,M135_uuuu,M135_uuuu,M135_uuuu,M135_uuuu,M135_uuuu,M135_uuux,M135_xxxu '@' to '_' */
M135_dc_anchor_122:
.byte (M135_xuuu)&255
.byte (M135_uuuu)&255
.byte (M135_uuuu)&255
.byte (M135_uuuu)&255
.byte (M135_uuuu)&255
.byte (M135_uuuu)&255
.byte (M135_uuux)&255
.byte (M135_xxxu)&255
/* QL:  dc.b M135_xlll,M135_llll,M135_llll,M135_llll,M135_llll,M135_llll,M135_lllx,M135_xxxx '`' to del */
M135_dc_anchor_132:
.byte (M135_xlll)&255
.byte (M135_llll)&255
.byte (M135_llll)&255
.byte (M135_llll)&255
.byte (M135_llll)&255
.byte (M135_llll)&255
.byte (M135_lllx)&255
.byte (M135_xxxx)&255
/* QL:  dc.b M135_llll,M135_llll,M135_llll,M135_llll,M135_llll,M135_llll,M135_llll,M135_lxxx 128-159 */
M135_dc_anchor_142:
.byte (M135_llll)&255
.byte (M135_llll)&255
.byte (M135_llll)&255
.byte (M135_llll)&255
.byte (M135_llll)&255
.byte (M135_llll)&255
.byte (M135_llll)&255
.byte (M135_lxxx)&255
/* QL:  dc.b M135_uuuu,M135_uuuu,M135_uuuu,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx 160-191 */
M135_dc_anchor_152:
.byte (M135_uuuu)&255
.byte (M135_uuuu)&255
.byte (M135_uuuu)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
/* QL:  dc.b M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx 192-223 */
M135_dc_anchor_162:
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
/* QL:  dc.b M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx,M135_xxxx 224-255 */
M135_dc_anchor_172:
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
.byte (M135_xxxx)&255
/* QL:         end */
