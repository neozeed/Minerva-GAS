/* ROM section tb_itrn */
.balign 2,0
/* QL: * sx_itrn: input translation routine: */
/* QL: * d1 -i o- byte after parity action / byte to be cr/lf/cz processed */
/* QL: * a0 -ip - base of serial channel definition */
/* QL: * a2 -i  - base of serial input queue */
/* QL: * d0/d2-d3/a1/a3 destroyed. */
/* QL: * d1 should be used to supply bytes to the caller. */
/* QL: * Skipping the return address and setting d0 to M188_err.nc will cause the input */
/* QL: * byte to be discarded. (d1 may be destroyed). */
/* QL: * Only one-to-none and one-to-one conversions are convenient. */
/* QL: tb_itrn */
tb_itrn:
/* QL:         move.l  M188_sv_trtab(a6),a1 get translation table */
    move.l M188_sv_trtab(a6),a1
/* QL:         move.w  2(a1),d2 */
    move.w 2(a1),d2
/* QL:         beq.s   M188_rts0            no table, so get out */
    beq.s M188_rts0
/* QL:         add.w   d2,a1 */
    add.w d2,a1
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.b  d1,d2           ensure offset is a byte */
    move.b d1,d2
/* QL:         tst.b   0(a1,d2.w)      look at table entry */
    tst.b 0(a1,d2.w)
/* QL:         bne.s   M188_lent            if not zero, enter M188_loop */
    bne.s M188_lent
/* QL: M188_rts0 */
M188_rts0:
/* QL:         rts */
    rts 
/* QL: M188_loop */
M188_loop:
/* QL:         addq.b  #1,d2           push on */
    addq.b #1,d2
/* QL:         cmp.b   d2,d1           back at start? */
    cmp.b d2,d1
/* QL:         beq.s   M188_rts0            yes, so get out */
    beq.s M188_rts0
/* QL: M188_lent */
M188_lent:
/* QL:         cmp.b   0(a1,d2.w),d1   check table entry */
    cmp.b 0(a1,d2.w),d1
/* QL:         bne.s   M188_loop            not equal, so carry on */
    bne.s M188_loop
/* QL:         move.b  d2,d1           found it, pointer is actual value */
    move.b d2,d1
/* QL:         rts */
    rts 
/* QL:         end */
