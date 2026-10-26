/* ROM section ib_end */
.balign 2,0
/* QL: * d4 -  o- name row */
/* QL: * a4 -i o- program file */
/* QL: * a2 -  o- loop description pointer */
/* QL: * d0 -  o- worked (0) or failed */
/* QL: ib_end */
ib_end:
/* QL:         jsr     ib_nxnon(pc)    get next non-space */
    jsr ib_nxnon(pc)
/* QL:         sub.w   #M152_w.rep,d1       REPeat? */
    sub.w #M152_w.rep,d1
/* QL:         beq.s   M152_repfor          yes, go REP it (extend clear) */
    beq.s M152_repfor
/* QL:         addq.w  #M152_w.rep-M152_w.for,d1 FOR? */
.word 20545|((((M152_w.rep-M152_w.for))&7)<<9)
/* QL:         beq.s   M152_repfor          yes, go FOR it (extend set) */
    beq.s M152_repfor
/* QL:         subq.w  #M152_w.when-M152_w.for,d1 WHEN? */
.word 20801|((((M152_w.when-M152_w.for))&7)<<9)
/* QL:         beq.s   M152_when            yes, go M152_when it */
    beq.s M152_when
/* QL:         subq.w  #M152_w.def-M152_w.when,d1 DEFine? */
.word 20801|((((M152_w.def-M152_w.when))&7)<<9)
/* QL:         beq.l   ib_ret          yes, treat as a return */
    beq.w ib_ret
/* QL: * Anything else (SEL, IF) we just ignore */
/* QL: M152_okrts */
M152_okrts:
/* QL:         moveq   #0,d0           don't have to do anything special */
    moveq #0,d0
/* QL: M152_rts0 */
M152_rts0:
/* QL:         rts */
    rts 
/* QL: M152_repfor */
M152_repfor:
/* QL:         moveq   #M152_t.rep>>1,d5 */
    moveq #(M152_t.rep>>1),d5
/* QL:         addx.b  d5,d5 */
    addx.b d5,d5
/* QL:         addq.l  #2,a4           skip keyword */
    addq.l #2,a4
/* QL:         jsr     ib_gtlpl(pc) */
    jsr ib_gtlpl(pc)
/* QL:         bne.s   M152_rts0 */
    bne.s M152_rts0
/* QL:         moveq   #M152_err.nf,d0 */
    moveq #M152_err.nf,d0
/* QL:         cmp.b   d5,d1           check the loop type is what we expected */
    cmp.b d5,d1
/* QL:         bne.s   M152_rts0 */
    bne.s M152_rts0
/* QL:         move.w  M152_bv_linum(a6),M152_lp.el(a6,a2.l) fill in endloop pointer */
    move.w M152_bv_linum(a6),M152_lp.el(a6,a2.l)
/* QL:         move.b  M152_bv_stmnt(a6),M152_lp.es(a6,a2.l) and which statement on line it is */
    move.b M152_bv_stmnt(a6),M152_lp.es(a6,a2.l)
/* QL:         jmp     ib_loop(pc)     repeat or continue (see next) */
    jmp ib_loop(pc)
/* QL: M152_when */
M152_when:
/* QL:         tst.b   M152_bv_wherr(a6)    are we doing a M152_when? */
    tst.b M152_bv_wherr(a6)
/* QL:         bne.l   bp_conti        yes, do a continue */
    bne.w bp_conti
/* QL: ib_endw */
ib_endw:
/* QL:         move.w  M152_bv_linum(a6),d4 current lno */
    move.w M152_bv_linum(a6),d4
/* QL:         moveq   #-1,d3          look for it */
    moveq #(-1),d3
/* QL:         jsr     ib_wscan(pc) */
    jsr ib_wscan(pc)
/* QL:         bne.s   M152_okrts */
    bne.s M152_okrts
/* QL:         jmp     ib_ewret(pc) */
    jmp ib_ewret(pc)
/* QL:         end */
