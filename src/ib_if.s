/* ROM section ib_if */
.balign 2,0
/* QL: * d0 -  o- error code */
/* QL: * a4 -i o- pointer to program file */
/* QL: * d1/d3 destroyed, plus d2/a0-a1/a3/a5 for ib_if */
/* QL: ib_if */
ib_if:
/* QL:         move.l  a4,a0 */
    move.l a4,a0
/* QL:         jsr     ca_evalc(pc)    is expression true or false? */
    jsr ca_evalc(pc)
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         ble.s   M168_rts0 */
    ble.s M168_rts0
/* QL:         tst.b   M168_bv_inlin(a6)    is this already embedded in-line? */
    tst.b M168_bv_inlin(a6)
/* QL:         bne.s   M168_torf            yes, leave it as is */
    bne.s M168_torf
/* QL:         jsr     ib_chinl(pc)    is it now an in-line IF? */
    jsr ib_chinl(pc)
/* QL:         bne.s   M168_torf            no, get on with it */
    bne.s M168_torf
/* QL:         st      M168_bv_inlin(a6)    set in-line, if it needs it */
    st M168_bv_inlin(a6)
/* QL: M168_torf */
M168_torf:
/* QL:         addq.l  #2,M168_bv_rip(a6) */
    addq.l #2,M168_bv_rip(a6)
/* QL:         move.w  0(a6,a1.l),d3   was condition non-zero? */
    move.w 0(a6,a1.l),d3
/* QL:         bne.s   M168_okrts           yes, true, so we're ready to roll */
    bne.s M168_okrts
/* QL: M168_go_eos */
M168_go_eos:
/* QL:         jsr     ib_eos(pc)      get end of statement */
    jsr ib_eos(pc)
/* QL:         blt.s   M168_do_eol */
    blt.s M168_do_eol
/* QL:         addq.l  #2,a4           skip colon/THEN/ELSE */
    addq.l #2,a4
/* QL: M168_countit */
M168_countit:
/* QL:         addq.b  #1,M168_bv_stmnt(a6) increment statement on line */
    addq.b #1,M168_bv_stmnt(a6)
/* QL: M168_chk1st */
M168_chk1st:
/* QL:         jsr     ib_nxnon(pc)    get next non-space */
    jsr ib_nxnon(pc)
/* QL:         cmp.b   #M168_b.key,d0       is it a keyword? */
    cmp.b #(M168_b.key&255),d0
/* QL:         bne.s   M168_go_eos          no, not interested then */
    bne.s M168_go_eos
/* QL:         addq.l  #2,a4 */
    addq.l #2,a4
/* QL:         subq.b  #M168_b.if,d1        check for IF */
    subq.b #M168_b.if,d1
/* QL:         beq.s   M168_do_if */
    beq.s M168_do_if
/* QL:         addq.b  #M168_b.if-M168_b.end,d1  check for END */
.word 20481|((((M168_b.if-M168_b.end))&7)<<9)
/* QL:         beq.s   M168_do_end */
    beq.s M168_do_end
/* QL:         cmp.b   #M168_b.else-M168_b.end,d1 check for ELSE */
    cmp.b #((M168_b.else-M168_b.end)&255),d1
/* QL:         bne.s   M168_go_eos */
    bne.s M168_go_eos
/* QL:         tst.w   d3              is this else any levels deep? */
    tst.w d3
/* QL:         bne.s   M168_countit         yes, count it as a statement */
    bne.s M168_countit
/* QL:         subq.l  #2,a4           ELSE needs to be seen/counted as statement end */
    subq.l #2,a4
/* QL:         bra.s   M168_okrts           end of nest, so finish */
    bra.s M168_okrts
/* QL: ib_else */
ib_else:
/* QL:         clr.w   d3              set nest level and find ELSE or END IF */
    clr.w d3
/* QL:         bra.s   M168_countit         go count it */
    bra.s M168_countit
/* QL: M168_do_end */
M168_do_end:
/* QL:         jsr     ib_nxnon(pc)    what's after the END? */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   #M168_w.if,d1        check for END IF */
    cmp.w #M168_w.if,d1
/* QL:         bne.s   M168_go_eos */
    bne.s M168_go_eos
/* QL:         dbra    d3,M168_go_eos       up a level, and continue if still in nest */
    dbra d3,M168_go_eos
/* QL: M168_okrts */
M168_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M168_rts0 */
M168_rts0:
/* QL:         rts */
    rts 
/* QL: M168_do_if */
M168_do_if:
/* QL:         tst.b   M168_bv_inlin(a6)    are we already doing an in-line? */
    tst.b M168_bv_inlin(a6)
/* QL:         bne.s   M168_add1            yes, add 1 to the count */
    bne.s M168_add1
/* QL:         jsr     ib_chinl(pc)    is this in-line? */
    jsr ib_chinl(pc)
/* QL:         beq.s   M168_iglin           yes, start to ignore whole line */
    beq.s M168_iglin
/* QL: M168_add1 */
M168_add1:
/* QL:         addq.w  #1,d3           add 1 to the nest level */
    addq.w #1,d3
/* QL:         bra.s   M168_go_eos */
    bra.s M168_go_eos
/* QL: M168_igskp */
M168_igskp:
/* QL:         addq.l  #2,a4           skip colon, then or else */
    addq.l #2,a4
/* QL: M168_iglin */
M168_iglin:
/* QL:         jsr     ib_eos(pc)      ignore this whole line */
    jsr ib_eos(pc)
/* QL:         bge.s   M168_igskp */
    bge.s M168_igskp
/* QL: M168_do_eol */
M168_do_eol:
/* QL:         tst.b   M168_bv_inlin(a6)    line feed, is this a single line IF? */
    tst.b M168_bv_inlin(a6)
/* QL:         bne.s   M168_okrts           yes, then we've finished */
    bne.s M168_okrts
/* QL:         jsr     ib_nxst(pc)     move to beginning of next statement */
    jsr ib_nxst(pc)
/* QL:         bne.s   M168_okrts           run out of file */
    bne.s M168_okrts
/* QL:         bra.s   M168_chk1st */
    bra.s M168_chk1st
/* QL:         end */
