/* ROM section ib_start */
.balign 2,0
/* QL: M150_st0 */
M150_st0:
/* QL:         move.l  M150_bv_pfbas(a6),a4 start right at stop */
    move.l M150_bv_pfbas(a6),a4
/* QL: ib_start */
ib_start:
/* QL:         sf      M150_bv_inlin(a6)    set in-line flag off (mainly for singles) */
    sf M150_bv_inlin(a6)
/* QL:         tst.b   M150_bv_sing(a6)     are we executing a single line? */
    tst.b M150_bv_sing(a6)
/* QL:         bne.s   ib_stsng        yes */
    bne.s ib_stsng
/* QL: M150_nxlin */
M150_nxlin:
/* QL:         bsr.l   ib_stnxl        set variables for the next line */
    bsr.w ib_stnxl
/* QL:         bne.s   M150_stopit          reached the end of the program */
    bne.s M150_stopit
/* QL: * Starting a single line */
/* QL: ib_stsng */
ib_stsng:
/* QL:         jsr     bv_chss(pc) */
    jsr bv_chss(pc)
/* QL: ; this is intended to allow clever error handling, but it's not complete... */
/* QL: ;       movem.l a6-a7,-(sp)     snapshot base and stack pointer */
/* QL: ;       move.l  M150_bv_ssbas(a6),d1 get relative top of basic */
/* QL: ;       add.l   (sp)+,d1 */
/* QL: ;       sub.l   (sp)+,d1        depth of stack where we are now */
/* QL: ;       move.l  d1,M150_bv_sssav(a6) save it */
/* QL: ib_stimm */
ib_stimm:
/* QL:         jsr     ib_nxnon(pc)    locate next token and put it in d0 */
    jsr ib_nxnon(pc)
/* QL:         tst.b   M150_bv_uproc(a6)    is there a user trace procedure? */
    tst.b M150_bv_uproc(a6)
/* QL:         bpl.s   M150_noup */
    bpl.s M150_noup
/* QL:         jsr     bv_upnxt(pc)    yes - call it */
    jsr bv_upnxt(pc)
/* QL: M150_noup */
M150_noup:
/* QL:         pea     ib_st2 */
    pea ib_st2(pc)
/* QL:         sub.b   #M150_b.key,d0 */
    sub.b #(M150_b.key&255),d0
/* QL:         beq.l   ib_kywrd */
    beq.w ib_kywrd
/* QL:         subq.b  #M150_b.nam-M150_b.key,d0 */
.word 20736|((((M150_b.nam-M150_b.key))&7)<<9)
/* QL:         beq.l   ib_name1 */
    beq.w ib_name1
/* QL:         addq.b  #M150_b.nam-M150_b.sym,d0 */
.word 20480|((((M150_b.nam-M150_b.sym))&7)<<9)
/* QL:         beq.l   ib_symbl */
    beq.w ib_symbl
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL:         moveq   #M150_err.ni,d0      can't do system variables yet */
    moveq #M150_err.ni,d0
/* QL: * I hope this is where functions come to */
/* QL: ib_st2 */
ib_st2:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         bne.l   ib_error        check for execution error in last stmnt */
    bne.w ib_error
/* QL:         tas     M150_bv_brk(a6)      no, was there a break */
    tas M150_bv_brk(a6)
/* QL:         bpl.l   ib_errnc        treat as a not complete error */
    bpl.w ib_errnc
/* QL: M150_stopit */
M150_stopit:
/* QL:         tas     M150_bv_cont(a6)     no, phew! was that a stop? */
    tas M150_bv_cont(a6)
/* QL:         beq.l   ib_stop         go and deal with it */
    beq.w ib_stop
/* QL:         tst.b   M150_bv_sing(a6) */
    tst.b M150_bv_sing(a6)
/* QL:         bne.s   ib_st1 */
    bne.s ib_st1
/* QL:         cmp.l   M150_bv_pfbas(a6),a4 has user gone to beg of file? */
    cmp.l M150_bv_pfbas(a6),a4
/* QL:         ble.s   M150_st0             you guessed */
    ble.s M150_st0
/* QL: ib_st1 */
ib_st1:
/* QL:         jsr     ib_eos(pc)      find end of current statement */
    jsr ib_eos(pc)
/* QL:         bge.s   M150_colon           found a M150_colon */
    bge.s M150_colon
/* QL:         tst.b   M150_bv_inlin(a6)    found line feed, in-line loop? */
    tst.b M150_bv_inlin(a6)
/* QL:         beq.s   M150_nx3             no */
    beq.s M150_nx3
/* QL:         blt.s   M150_nx2             no, but it might be a when */
    blt.s M150_nx2
/* QL:         jsr     ib_psend(pc)    ..yes, do a pseudo end */
    jsr ib_psend(pc)
/* QL:         tst.b   M150_bv_inlin(a6)    is it still inline? */
    tst.b M150_bv_inlin(a6)
/* QL:         bne.s   ib_st2          and continue as normal */
    bne.s ib_st2
/* QL: M150_nx2 */
M150_nx2:
/* QL:         tst.b   M150_bv_wherr(a6)    inline, are we error processing? */
    tst.b M150_bv_wherr(a6)
/* QL:         beq.s   M150_nx4 */
    beq.s M150_nx4
/* QL:         tst.b   M150_bv_wrinl(a6)    yes, is this an inline when? */
    tst.b M150_bv_wrinl(a6)
/* QL:         beq.s   M150_nx3 */
    beq.s M150_nx3
/* QL:         jsr     bp_conti(pc)    yes, continue from error line then */
    jsr bp_conti(pc)
/* QL:         st      M150_bv_cont(a6)     put continue flag on again */
    st M150_bv_cont(a6)
/* QL:         jmp     ib_stop(pc) */
    jmp ib_stop(pc)
/* QL: M150_nx4 */
M150_nx4:
/* QL:         move.w  M150_bv_linum(a6),d4 */
    move.w M150_bv_linum(a6),d4
/* QL:         moveq   #-1,d3 */
    moveq #(-1),d3
/* QL:         jsr     ib_wscan(pc) */
    jsr ib_wscan(pc)
/* QL:         bne.s   M150_nx3 */
    bne.s M150_nx3
/* QL:         jsr     ib_endw(pc) */
    jsr ib_endw(pc)
/* QL:         bra.s   ib_st1 */
    bra.s ib_st1
/* QL: M150_nx3 */
M150_nx3:
/* QL:         tst.b   M150_bv_sing(a6)     have we just executed a single line? */
    tst.b M150_bv_sing(a6)
/* QL:         addq.l  #2,a4 */
    addq.l #2,a4
/* QL:         beq.l   M150_nxlin           ..no, get on with it */
    beq.w M150_nxlin
/* QL:         bsr.s   M150_steol          tell unvrs we've stopped */
    bsr.s M150_steol
/* QL:         bra.s   M150_okrts */
    bra.s M150_okrts
/* QL: M150_colon */
M150_colon:
/* QL:         addq.l  #2,a4           skip over it */
    addq.l #2,a4
/* QL:         addq.b  #1,M150_bv_stmnt(a6) increment stat count */
    addq.b #1,M150_bv_stmnt(a6)
/* QL:         bra.l   ib_stsng */
    bra.w ib_stsng
/* QL: ib_stbas */
ib_stbas:
/* QL:         move.l  M150_bv_pfbas(a6),a4 start at the top */
    move.l M150_bv_pfbas(a6),a4
/* QL:         sf      M150_bv_sing(a6) */
    sf M150_bv_sing(a6)
/* QL:         clr.w   M150_bv_lengt(a6) */
    clr.w M150_bv_lengt(a6)
/* QL: ib_stnxl */
ib_stnxl:
/* QL:         sf      M150_bv_inlin(a6)    make sure in-line flag is off */
    sf M150_bv_inlin(a6)
/* QL: ib_stnxi */
ib_stnxi:
/* QL:         clr.w   M150_bv_linum(a6) */
    clr.w M150_bv_linum(a6)
/* QL:         tst.b   M150_bv_sing(a6) */
    tst.b M150_bv_sing(a6)
/* QL:         bne.s   M150_stmnt_1 */
    bne.s M150_stmnt_1
/* QL:         cmp.l   M150_bv_pfp(a6),a4   bottom of file yet? */
    cmp.l M150_bv_pfp(a6),a4
/* QL:         bge.s   ib_steof */
    bge.s ib_steof
/* QL:         move.w  0(a6,a4.l),d0 */
    move.w 0(a6,a4.l),d0
/* QL:         add.w   d0,M150_bv_lengt(a6) get length of current line */
    add.w d0,M150_bv_lengt(a6)
/* QL:         move.w  4(a6,a4.l),M150_bv_linum(a6) save line num in 'current' slot */
    move.w 4(a6,a4.l),M150_bv_linum(a6)
/* QL:         addq.l  #6,a4 */
    addq.l #6,a4
/* QL: M150_stmnt_1 */
M150_stmnt_1:
/* QL:         move.b  #1,M150_bv_stmnt(a6) initialise statement on line */
    move.b #(1&255),M150_bv_stmnt(a6)
/* QL: M150_okrts */
M150_okrts:
/* QL:         moveq   #0,d0           good return */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: ib_steof */
ib_steof:
/* QL:         sf      M150_bv_cont(a6)     stop when we get back */
    sf M150_bv_cont(a6)
/* QL: M150_steol */
M150_steol:
/* QL:         move.w  #-1,M150_bv_nxlin(a6) */
    move.w #(-1),M150_bv_nxlin(a6)
/* QL:         move.w  #4,M150_bv_stopn(a6) pretend we stopped from natural causes */
    move.w #4,M150_bv_stopn(a6)
/* QL:         rts */
    rts 
/* QL:         end */
