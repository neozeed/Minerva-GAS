/* ROM section ib_error */
.balign 2,0
/* QL: * Set up continue line number, etc., for present line. */
/* QL: ib_pserr */
ib_pserr:
/* QL:         tst.b   M145_bv_sing(a6) */
    tst.b M145_bv_sing(a6)
/* QL:         sne     d1 */
    sne d1
/* QL:         ext.w   d1              if single line command, no restart */
    ext.w d1
/* QL:         or.w    M145_bv_linum(a6),d1 otherwise, possible restart from here */
    or.w M145_bv_linum(a6),d1
/* QL:         move.w  d1,M145_bv_cnlno(a6) */
    move.w d1,M145_bv_cnlno(a6)
/* QL:         move.b  M145_bv_stmnt(a6),M145_bv_cnstm(a6) */
    move.b M145_bv_stmnt(a6),M145_bv_cnstm(a6)
/* QL:         move.b  M145_bv_inlin(a6),M145_bv_cninl(a6) */
    move.b M145_bv_inlin(a6),M145_bv_cninl(a6)
/* QL:         move.w  M145_bv_index(a6),M145_bv_cnind(a6) */
    move.w M145_bv_index(a6),M145_bv_cnind(a6)
/* QL:         move.l  M145_bv_rtp(a6),d1   check whether there's anything on the */
    move.l M145_bv_rtp(a6),d1
/* QL:         sub.l   M145_bv_rtbas(a6),d1 return stack, and if so */
    sub.l M145_bv_rtbas(a6),d1
/* QL:         sne     M145_bv_unrvl(a6)    then tell world we want to unravel it */
    sne M145_bv_unrvl(a6)
/* QL:         rts */
    rts 
/* QL: * Report errors during parsing */
/* QL: ib_ernol */
ib_ernol:
/* QL:         st      M145_bv_sing(a6)     pretend single line */
    st M145_bv_sing(a6)
/* QL:         moveq   #M145_err.bl,d1      trap parsing error */
    moveq #M145_err.bl,d1
/* QL:         cmp.l   d1,d0 */
    cmp.l d1,d0
/* QL:         beq.s   M145_not_when */
    beq.s M145_not_when
/* QL: * Deal with general errors - reports them using ut_err if appropriate, and also */
/* QL: * implements when error trapping. */
/* QL: ib_error */
ib_error:
/* QL:         moveq   #M145_err.nc,d1      trap break */
    moveq #M145_err.nc,d1
/* QL:         cmp.l   d1,d0 */
    cmp.l d1,d0
/* QL:         beq.s   M145_not_when */
    beq.s M145_not_when
/* QL:         bsr.s   M145_q_save          if already doing a when, doesn't come back */
    bsr.s M145_q_save
/* QL:         move.w  M145_bv_linum(a6),M145_bv_erlin(a6) save line number */
    move.w M145_bv_linum(a6),M145_bv_erlin(a6)
/* QL:         move.b  M145_bv_stmnt(a6),M145_bv_erstm(a6) save statement (new - lwr) */
    move.b M145_bv_stmnt(a6),M145_bv_erstm(a6)
/* QL:         move.l  d0,M145_bv_error(a6) and error number */
    move.l d0,M145_bv_error(a6)
/* QL:         bge.s   M145_m1_rts */
    bge.s M145_m1_rts
/* QL:         move.w  M145_bv_wrlno(a6),d4 is there a when to do? */
    move.w M145_bv_wrlno(a6),d4
/* QL:         beq.s   M145_errep           nope */
    beq.s M145_errep
/* QL:         st      M145_bv_wherr(a6)    set when_error flag on */
    st M145_bv_wherr(a6)
/* QL:         jsr     ib_stbas(pc)    to set a4 */
    jsr ib_stbas(pc)
/* QL:         jsr     ib_golin(pc)    set when line */
    jsr ib_golin(pc)
/* QL:         jsr     ib_stnxl(pc) */
    jsr ib_stnxl(pc)
/* QL:         beq.s   M145_is_when         still a line there, go set if it's got when */
    beq.s M145_is_when
/* QL: M145_un_when */
M145_un_when:
/* QL:         clr.w   M145_bv_wrlno(a6)    turn when processing completely off */
    clr.w M145_bv_wrlno(a6)
/* QL:         sf      M145_bv_wherr(a6) */
    sf M145_bv_wherr(a6)
/* QL:         move.l  M145_bv_error(a6),d0 get back error number */
    move.l M145_bv_error(a6),d0
/* QL:         bra.s   M145_errep */
    bra.s M145_errep
/* QL: * A common test, so make it clever */
/* QL: M145_q_save */
M145_q_save:
/* QL:         tst.b   M145_bv_wherr(a6)    are we doing a when already ? */
    tst.b M145_bv_wherr(a6)
/* QL:         beq.s   ib_pserr        no - save status and return */
    beq.s ib_pserr
/* QL:         addq.l  #4,sp           discard return */
    addq.l #4,sp
/* QL:         bsr.s   M145_errep           report the error */
    bsr.s M145_errep
/* QL:         clr.b   M145_bv_wherr(a6)    clear when processing flag */
    clr.b M145_bv_wherr(a6)
/* QL:         moveq   #M145_err.wh,d0      complain we were doing when at the time! */
    moveq #M145_err.wh,d0
/* QL: M145_err_mess */
M145_err_mess:
/* QL:         jsr     ut_err(pc)      print the error message */
    jsr ut_err(pc)
/* QL: M145_m1_rts */
M145_m1_rts:
/* QL:         moveq   #-1,d0 */
    moveq #(-1),d0
/* QL:         rts */
    rts 
/* QL: * The order of checking here used to disallow constructs like: */
/* QL: *               IF traperrors:WHEN ERRor: ... */
/* QL: * I.e. it didn't like inline when clauses that didn't start at the start of */
/* QL: * the line. It now permits them. lwr */
/* QL: M145_is_when */
M145_is_when:
/* QL:         move.b  M145_bv_wrstm(a6),d4 */
    move.b M145_bv_wrstm(a6),d4
/* QL:         jsr     ib_gost(pc)     and statement */
    jsr ib_gost(pc)
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   #M145_w.when,d1      finally check this is still a when line */
    cmp.w #M145_w.when,d1
/* QL:         bne.s   M145_un_when         it isn't. (How on earth did that happen!) */
    bne.s M145_un_when
/* QL:         move.b  M145_bv_wrinl(a6),M145_bv_inlin(a6) */
    move.b M145_bv_wrinl(a6),M145_bv_inlin(a6)
/* QL:         jmp     ib_st1(pc)      and carry on from there */
    jmp ib_st1(pc)
/* QL: * Entrypoint for dealing with break reporting - puts M145_err.nc in d0, */
/* QL: * then reports error as ib_error, except ignoring WHEN ERRor status. */
/* QL: ib_errnc */
ib_errnc:
/* QL:         moveq   #M145_err.nc,d0      not complete */
    moveq #M145_err.nc,d0
/* QL: M145_not_when */
M145_not_when:
/* QL:         bsr.s   M145_q_save          if already doing a WHEN, doesn't come back */
    bsr.s M145_q_save
/* QL: M145_errep */
M145_errep:
/* QL:         move.l  M145_bv_chbas(a6),a0 pos of command channel block */
    move.l M145_bv_chbas(a6),a0
/* QL:         move.l  0(a6,a0.l),a0   channel id #0 */
    move.l 0(a6,a0.l),a0
/* QL:         move.w  #-1,M145_bv_nxlin(a6) don't run when we go back */
    move.w #(-1),M145_bv_nxlin(a6)
/* QL:         tst.b   M145_bv_sing(a6)     is there a line number? */
    tst.b M145_bv_sing(a6)
/* QL:         bne.s   M145_err_mess        no */
    bne.s M145_err_mess
/* QL: * Note: ib_errep used to include the above 3 lines... wrongly, I believe (lwr) */
/* QL: * By taking them out, we now can find out not only the last error that */
/* QL: * occured, but also where it was, by just asking for report. */
/* QL:         move.l  M145_bv_linum(a6),d3 get line number to msw */
    move.l M145_bv_linum(a6),d3
/* QL:         move.b  M145_bv_stmnt(a6),d3 get statement to lsb */
    move.b M145_bv_stmnt(a6),d3
/* QL: * Reports an error, using ut_err, showing line number if appropriate. */
/* QL: * Also prints the statement number now! lwr */
/* QL: * Also now takes line and statement as parameters, to avoid fiddling about. */
/* QL: * Finally, usage of the BF area is avoided by employing the stack instead. */
/* QL: * Note: the longest string we construct is "-32768;255 ", i.e 11 chars. */
/* QL: * a0 -i  - channel to write to (set in bp_report) */
/* QL: * d0 -i  - error number */
/* QL: * d3 -i  - msw error line, lsb error statement (actually stmt stays) */
/* QL: * d1-d2 destroyed (a1/a5 no longer smashed. lwr) */
/* QL: ib_errep */
ib_errep:
/* QL:         movem.l d0-d3/a1,-(sp)  save error number, 8 junk, line/statement & a1 */
    movem.l d0-d3/a1,-(sp)
/* QL:         moveq   #M145_err.at,d0      say "at line " */
    moveq #M145_err.at,d0
/* QL:         bsr.s   M145_err_mess */
    bsr.s M145_err_mess
/* QL:         subq.l  #8,sp           68020 compatible... */
    subq.l #8,sp
/* QL:         movem.l a6-a7,(sp)      ... snapshot of a6/a7 */
    movem.l a6-a7,(sp)
/* QL:         moveq   #12,d2 */
    moveq #12,d2
/* QL:         sub.l   (sp)+,d2 */
    sub.l (sp)+,d2
/* QL:         add.l   (sp),d2         construct offset to buffer on stack */
    add.l (sp),d2
/* QL:         move.l  a0,(sp)         leave channel id for later */
    move.l a0,(sp)
/* QL:         move.l  d2,a0           where to put the string */
    move.l d2,a0
/* QL:         lea     8(a0),a1        where we have the line/statement */
    lea 8(a0),a1
/* QL:         sf      2(a6,a1.l)      zero out top byte of statement */
    sf 2(a6,a1.l)
/* QL:         moveq   #';',d3         delimit with a semicolon */
    moveq #59,d3
/* QL:         bsr.s   M145_numlin          put line number and semicolon in buffer */
    bsr.s M145_numlin
/* QL:         bsr.s   M145_numstm          put statement and whatever in buffer */
    bsr.s M145_numstm
/* QL:         move.l  d2,a1           where to print from */
    move.l d2,a1
/* QL:         move.w  a0,d2 */
    move.w a0,d2
/* QL:         sub.w   a1,d2           length of text */
    sub.w a1,d2
/* QL:         move.l  (sp)+,a0 */
    move.l (sp)+,a0
/* QL:         moveq   #M145_io.sstrg,d0    send it */
    moveq #M145_io.sstrg,d0
/* QL:         moveq   #-1,d3 */
    moveq #(-1),d3
/* QL:         trap    #4 */
    trap #4
/* QL:         trap    #3 */
    trap #3
/* QL:         movem.l (sp)+,d0-d3/a1  restore err number and a1, rest is junk */
    movem.l (sp)+,d0-d3/a1
/* QL:         bra.s   M145_err_mess        go say it */
    bra.s M145_err_mess
/* QL: M145_numstm */
M145_numstm:
/* QL:         moveq   #' ',d3         trailing space */
    moveq #32,d3
/* QL:         tst.b   (sp)            are we actually going to say anything? */
    tst.b (sp)
/* QL:         bmi.s   M145_numlin */
    bmi.s M145_numlin
/* QL:         moveq   #10,d3          no - make it finish there! */
    moveq #10,d3
/* QL: M145_numlin */
M145_numlin:
/* QL:         jsr     cn_itod(pc)     put number in the buffer */
    jsr cn_itod(pc)
/* QL:         move.b  d3,0(a6,a0.l)   put trailing character */
    move.b d3,0(a6,a0.l)
/* QL:         addq.l  #1,a0           move past extra character */
    addq.l #1,a0
/* QL:         rts */
    rts 
/* QL:         end */
