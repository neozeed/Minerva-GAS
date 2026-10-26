/* ROM section tb_otrn */
.balign 2,0
/* QL: * sx_otrn: output translation routine: */
/* QL: * d1 -i o- byte after cr/lf/cz action / byte to be parity processed */
/* QL: * a0 -ip - base of serial channel definition */
/* QL: * a2 -i  - base of serial output queue */
/* QL: * d0/d2-d3/a1/a3 destroyed. */
/* QL: * If the value in d1 is not to be sent, an appropriate value should be set in */
/* QL: * d0 (M189_err.nc normally) and the return address skipped. */
/* QL: * A one-to-many translation must verify that the queue has space, by calling */
/* QL: * io_qtest through the vector at $de, and if there is insufficient space, */
/* QL: * set M189_err.nc in d0 and skip the return address. */
/* QL: * If the space is ok, the return address should be "jsr"ed to for all but the */
/* QL: * last byte, leaving that to go as normal. */
/* QL: * Only one-to-none, one-to-one and one-to-many conversions are convenient. */
/* QL: * If the return address mentioned above is used, it requires the following: */
/* QL: * d0 -  o- 0 (or error - queue full (M189_err.nc) - should never happen!) */
/* QL: * d1 -i o- byte to put in queue (output with parity actioned) */
/* QL: * a2 -ip - pointer to queue */
/* QL: * d2/a3 destroyed */
/* QL: tb_otrn */
tb_otrn:
/* QL:         move.l  M189_sv_trtab(a6),a1 get translation table */
    move.l M189_sv_trtab(a6),a1
/* QL:         move.w  2(a1),d2 */
    move.w 2(a1),d2
/* QL:         beq.s   M189_rts0            no table, so get out */
    beq.s M189_rts0
/* QL:         add.w   d2,a1 */
    add.w d2,a1
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         move.b  d1,d3           save d1, and ensure offset is a byte */
    move.b d1,d3
/* QL:         beq.s   M189_rts0            send nul directly */
    beq.s M189_rts0
/* QL:         move.b  0(a1,d3.w),d1   get the table entry */
    move.b 0(a1,d3.w),d1
/* QL:         bne.s   M189_rts0            if trans_tab(char) <> 0, send it */
    bne.s M189_rts0
/* QL:         move.l  M189_sv_trtab(a6),a1 get sequence table */
    move.l M189_sv_trtab(a6),a1
/* QL:         move.w  4(a1),d2 */
    move.w 4(a1),d2
/* QL:         beq.s   M189_ok_fin          no sequence table, so M189_drop it */
    beq.s M189_ok_fin
/* QL:         add.w   d2,a1 */
    add.w d2,a1
/* QL:         move.w  M189_io.qtest,a3 */
    move.w M189_io.qtest,a3
/* QL:         jsr     (a3)            check space in queue */
    jsr (a3)
/* QL:         moveq   #M189_err.nc,d0      ready to tell caller we can't do this yet */
    moveq #M189_err.nc,d0
/* QL:         subq.w  #3,d2           is there room in queue */
    subq.w #3,d2
/* QL:         bcs.s   M189_drop            no, go back with error */
    bcs.s M189_drop
/* QL:         move.b  (a1)+,d0        get count (no of sequences) */
    move.b (a1)+,d0
/* QL:         bra.s   M189_lent */
    bra.s M189_lent
/* QL: M189_loop */
M189_loop:
/* QL:         addq.l  #3,a1           push on pointer */
    addq.l #3,a1
/* QL:         subq.b  #1,d0           decrement count */
    subq.b #1,d0
/* QL: M189_lent */
M189_lent:
/* QL:         beq.s   M189_ok_fin          while count # 0 */
    beq.s M189_ok_fin
/* QL:         cmp.b   (a1)+,d3        if char <> table entry */
    cmp.b (a1)+,d3
/* QL:         bne.s   M189_loop            then continue M189_loop */
    bne.s M189_loop
/* QL:         moveq   #3-1,d3 */
    moveq #(3-1),d3
/* QL: M189_send_3 */
M189_send_3:
/* QL:         move.b  (a1)+,d1        get a byte */
    move.b (a1)+,d1
/* QL:         move.l  (sp),a3 */
    move.l (sp),a3
/* QL:         jsr     (a3)            call return address */
    jsr (a3)
/* QL:         dbra    d3,M189_send_3 */
    dbra d3,M189_send_3
/* QL: M189_ok_fin */
M189_ok_fin:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M189_drop */
M189_drop:
/* QL:         addq.l  #4,sp           discard return address */
    addq.l #4,sp
/* QL: M189_rts0 */
M189_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
