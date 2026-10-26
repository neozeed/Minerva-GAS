/* ROM section sd_fill */
.balign 2,0
/* QL: * To get round some hassles, and slightly improve the functionality of this */
/* QL: * call, we will no longer treat anything as out of range! What we will do is to */
/* QL: * fill in that part of the block specification which overlaps the window. */
/* QL: * All the sizes and offsets will be treated as signed numbers. */
/* QL: * d1 c   colour to fill / overwrite */
/* QL: * a1 c   pointer to block definitions */
/* QL: sd_fill */
sd_fill:
/* QL:         btst    #M117_sd..xor,M117_sd_cattr(a0) is xor bit set? */
    btst #M117_sd..xor,M117_sd_cattr(a0)
/* QL:         lea     cs_fill(pc),a3  no - assume fill */
    lea cs_fill(pc),a3
/* QL:         beq.s   M117_csset */
    beq.s M117_csset
/* QL:         lea     cs_over(pc),a3  yes - it's over required */
    lea cs_over(pc),a3
/* QL: M117_csset */
M117_csset:
/* QL:         move.l  a1,a2 */
    move.l a1,a2
/* QL:         subq.l  #4,sp */
    subq.l #4,sp
/* QL:         move.l  sp,a1 */
    move.l sp,a1
/* QL:         jsr     cs_color(pc) */
    jsr cs_color(pc)
/* QL:         movem.l (a2),d2-d3      fetch block size and position */
    movem.l (a2),d2-d3
/* QL:         btst    #M117_mc..m256,M117_sv_mcsta(a6) is it low res */
    btst #M117_mc..m256,M117_sv_mcsta(a6)
/* QL:         beq.s   M117_resdone */
    beq.s M117_resdone
/* QL:         moveq   #16,d0          bit number of lsb of x */
    moveq #16,d0
/* QL:         bclr    d0,d3           clear xbase lsb */
    bclr d0,d3
/* QL:         bclr    d0,d2           clear xsize lsb */
    bclr d0,d2
/* QL: M117_resdone */
M117_resdone:
/* QL:         assert  M117_sd_xmin,M117_sd_ymin-2,M117_sd_xsize-4,M117_sd_ysize-6 */
/* original assertion: M117_sd_xmin,M117_sd_ymin-2,M117_sd_xsize-4,M117_sd_ysize-6 */
/* QL:         movem.l M117_sd_xmin(a0),d0-d1 get min and size of window */
    movem.l M117_sd_xmin(a0),d0-d1
/* QL:         bsr.s   M117_check */
    bsr.s M117_check
/* QL:         ble.s   M117_finis           w at x does not overlap window */
    ble.s M117_finis
/* QL:         bsr.s   M117_check */
    bsr.s M117_check
/* QL:         ble.s   M117_finis           h at y does not overlap window */
    ble.s M117_finis
/* QL:         add.l   d3,d0           add x/y to min */
    add.l d3,d0
/* QL:         move.w  d0,d1           put y start */
    move.w d0,d1
/* QL:         swap    d0              get down x start */
    swap d0
/* QL:         move.w  d2,d3           put h */
    move.w d2,d3
/* QL:         swap    d2              get down w */
    swap d2
/* QL:         jsr     (a3)            do the operation */
    jsr (a3)
/* QL: M117_finis */
M117_finis:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         addq.l  #4,sp           restore stack */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: M117_check */
M117_check:
/* QL:         swap    d1 */
    swap d1
/* QL:         swap    d2 */
    swap d2
/* QL:         swap    d3 */
    swap d3
/* QL:         tst.w   d2 */
    tst.w d2
/* QL:         ble.s   M117_rts0            size already not positive */
    ble.s M117_rts0
/* QL:         tst.w   d3 */
    tst.w d3
/* QL:         bpl.s   M117_baseok */
    bpl.s M117_baseok
/* QL:         add.w   d3,d2 */
    add.w d3,d2
/* QL:         ble.s   M117_rts0            base + size doesn't get into window */
    ble.s M117_rts0
/* QL:         clr.w   d3 */
    clr.w d3
/* QL: M117_baseok */
M117_baseok:
/* QL:         sub.w   d3,d1           see how much space after base */
    sub.w d3,d1
/* QL:         ble.s   M117_rts0            base beyond window, so forget it */
    ble.s M117_rts0
/* QL:         sub.w   d2,d1           can we fit whole width in? */
    sub.w d2,d1
/* QL:         bgt.s   M117_rts0            yes, so do so */
    bgt.s M117_rts0
/* QL:         add.w   d1,d2           chop down size to what we can fit in */
    add.w d1,d2
/* QL: M117_rts0 */
M117_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
