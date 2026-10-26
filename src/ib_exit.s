/* ROM section ib_exit */
.balign 2,0
/* QL: ib_exit */
ib_exit:
/* QL:         jsr     ib_gtlpl(pc)    get loop line */
    jsr ib_gtlpl(pc)
/* QL:         bne.s   M165_rts0            there isn't one */
    bne.s M165_rts0
/* QL:         move.w  M165_lp.el(a6,a2.l),d4 get end line number */
    move.w M165_lp.el(a6,a2.l),d4
/* QL:         beq.s   M165_nolin           there isn't one */
    beq.s M165_nolin
/* QL:         jsr     ib_golin(pc)    go to it */
    jsr ib_golin(pc)
/* QL:         bne.s   M165_okrts           (quicker but not strictly necessary) */
    bne.s M165_okrts
/* QL:         jsr     ib_stnxl(pc) */
    jsr ib_stnxl(pc)
/* QL:         bne.s   M165_okrts */
    bne.s M165_okrts
/* QL:         move.b  M165_lp.es(a6,a2.l),d4 get statement on end line */
    move.b M165_lp.es(a6,a2.l),d4
/* QL:         jsr     ib_gost(pc)     go to it */
    jsr ib_gost(pc)
/* QL: M165_okrts */
M165_okrts:
/* QL:         moveq   #0,d0           good */
    moveq #0,d0
/* QL: M165_rts0 */
M165_rts0:
/* QL:         rts */
    rts 
/* QL: M165_nolin */
M165_nolin:
/* QL:         move.w  -2(a6,a4.l),d4  read the loop name, need to check it */
    move.w (-2)(a6,a4.l),d4
/* QL:         moveq   #M165_t.for,d5 */
    moveq #M165_t.for,d5
/* QL:         sub.b   d1,d5           d5 will now be 0 for FOR, 1 for REP */
    sub.b d1,d5
/* QL: ib_fend */
ib_fend:
/* QL: M165_nxstat */
M165_nxstat:
/* QL:         jsr     ib_eos(pc)      find end of current statement */
    jsr ib_eos(pc)
/* QL:         blt.s   M165_lf              found a line feed */
    blt.s M165_lf
/* QL:         addq.l  #2,a4           M165_skip colon */
    addq.l #2,a4
/* QL:         addq.b  #1,M165_bv_stmnt(a6) increment statement count */
    addq.b #1,M165_bv_stmnt(a6)
/* QL:         bra.s   M165_checkend_ */
    bra.s M165_checkend_
/* QL: M165_lf */
M165_lf:
/* QL:         tst.b   M165_bv_inlin(a6)    M165_lf, is this the end? */
    tst.b M165_bv_inlin(a6)
/* QL:         beq.s   M165_skip */
    beq.s M165_skip
/* QL:         sf      M165_bv_inlin(a6)    yes, so turn inline flag off */
    sf M165_bv_inlin(a6)
/* QL:         move.w  M165_bv_linum(a6),d0 is this inline the loop I'm trying to exit */
    move.w M165_bv_linum(a6),d0
/* QL:         cmp.w   M165_lp.sl(a6,a2.l),d0 */
    cmp.w M165_lp.sl(a6,a2.l),d0
/* QL:         beq.s   M165_okrts           yes, we've got to end */
    beq.s M165_okrts
/* QL: M165_skip */
M165_skip:
/* QL:         tst.b   M165_bv_sing(a6)     single line command? */
    tst.b M165_bv_sing(a6)
/* QL:         bne.s   M165_okrts           silly user */
    bne.s M165_okrts
/* QL:         addq.l  #2,a4           M165_skip */
    addq.l #2,a4
/* QL:         jsr     ib_stnxl(pc)    start the next line off */
    jsr ib_stnxl(pc)
/* QL:         bne.s   M165_okrts */
    bne.s M165_okrts
/* QL: M165_checkend_ */
M165_checkend_:
/* QL:         jsr     ib_nxnon(pc)    get 1st non-space */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   #M165_w.end,d1       END? */
    cmp.w #M165_w.end,d1
/* QL:         bne.s   M165_nxstat */
    bne.s M165_nxstat
/* QL:         jsr     ib_s2non(pc)    yes, M165_skip it */
    jsr ib_s2non(pc)
/* QL:         assert  (M165_t.for-M165_t.rep)*2,M165_w.rep-M165_w.for */
/* original assertion: (M165_t.for-M165_t.rep)*2,M165_w.rep-M165_w.for */
/* QL:         sub.b   d5,d1           what sort of loop're we looking for? */
    sub.b d5,d1
/* QL:         sub.b   d5,d1           1..REP, 0..FOR, for.b = rep.b - 2 */
    sub.b d5,d1
/* QL:         cmp.w   #M165_w.for,d1       want FOR (REP converted) */
    cmp.w #M165_w.for,d1
/* QL:         bne.s   M165_nxstat */
    bne.s M165_nxstat
/* QL:         jsr     ib_s2non(pc)    M165_skip key and get next non-space */
    jsr ib_s2non(pc)
/* QL:         cmp.w   2(a6,a4.l),d4   is it the right name? */
    cmp.w 2(a6,a4.l),d4
/* QL:         bne.s   M165_nxstat */
    bne.s M165_nxstat
/* QL:         move.w  M165_bv_linum(a6),M165_lp.el(a6,a2.l) yes! quick,fill in the endline and */
    move.w M165_bv_linum(a6),M165_lp.el(a6,a2.l)
/* QL:         move.b  M165_bv_stmnt(a6),M165_lp.es(a6,a2.l) st in case we use this loop again */
    move.b M165_bv_stmnt(a6),M165_lp.es(a6,a2.l)
/* QL:         bra.s   M165_okrts */
    bra.s M165_okrts
/* QL:         end */
