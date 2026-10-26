/* ROM section sb_unvr */
.balign 2,0
/* QL: * Code for initial entry only. BV area has been generally zeroed out. */
/* QL: sb_unvr */
sb_unvr:
/* QL:         move.l  a6,sp           move stack right to top of area ... */
    move.l a6,sp
/* QL:         add.l   M140_bv_ssbas(a6),sp ... by adding offset to top of superbasic */
    add.l M140_bv_ssbas(a6),sp
/* QL:         tst.l   M140_bv_comch(a6) */
    tst.l M140_bv_comch(a6)
/* QL:         bne.s   M140_nxlset */
    bne.s M140_nxlset
/* QL:         subq.w  #1,M140_bv_nxlin(a6) if no command channel, set nxlin -1 */
    subq.w #1,M140_bv_nxlin(a6)
/* QL: M140_nxlset */
M140_nxlset:
/* QL:         bsr.s   M140_universe        entry, putting out-of-memory return on stack */
    bsr.s M140_universe
/* QL: M140_errom */
M140_errom:
/* QL:         jsr     ib_stop(pc)     come here when life gets hard */
    jsr ib_stop(pc)
/* QL:         bsr.s   sb_read         reinstate return for out-of-memory */
    bsr.s sb_read
/* QL:         bra.s   M140_errom */
    bra.s M140_errom
/* QL: M140_eof */
M140_eof:
/* QL:         tst.l   M140_bv_comch(a6)    were were already reading #0? */
    tst.l M140_bv_comch(a6)
/* QL:         beq.l   bv_die          yes - can't handle that! */
    beq.w bv_die
/* QL:         pea     M140_rr_chk */
    pea M140_rr_chk(pc)
/* QL: M140_com_zap */
M140_com_zap:
/* QL:         sub.l   a0,a0           flag for #0 */
    sub.l a0,a0
/* QL:         jmp     bp_comch(pc)    set as the new command channel */
    jmp bp_comch(pc)
/* QL: M140_bad_rdb */
M140_bad_rdb:
/* QL:         move.l  d0,d1           bad read, see why */
    move.l d0,d1
/* QL:         addq.l  #-M140_err.no,d1     not open ... */
.word 20609|((((-M140_err.no))&7)<<9)
/* QL:         beq.s   M140_eof             ... treat as end of file */
    beq.s M140_eof
/* QL:         addq.l  #M140_err.no-M140_err.ef,d1 really end of file? */
.word 20609|((((M140_err.no-M140_err.ef))&7)<<9)
/* QL:         beq.s   M140_eof             yes - probably just end of a load, etc */
    beq.s M140_eof
/* QL:         jsr     ib_ernol(pc)    different error, tell user */
    jsr ib_ernol(pc)
/* QL: M140_off_auto */
M140_off_auto:
/* QL:         sf      M140_bv_auto(a6)     turn off the auto/M140_edit flag */
    sf M140_bv_auto(a6)
/* QL: sb_read */
sb_read:
/* QL:         bsr.s   M140_com_zap         turn off any command file / set initial one */
    bsr.s M140_com_zap
/* QL:         tst.b   (sp)            was there a command line to restore? */
    tst.b (sp)
/* QL:         bpl.s   M140_universe        no, just read a new line then */
    bpl.s M140_universe
/* QL:         addq.l  #2+4,sp         drop misc saved stuff */
    addq.l #(2+4),sp
/* QL:         add.w   (sp)+,sp        drop length and contents of command line */
    add.w (sp)+,sp
/* QL: M140_universe */
M140_universe:
/* QL:         clr.l   M140_bv_sssav(a6)    set save pointer to top of ss stack */
    clr.l M140_bv_sssav(a6)
/* QL:         move.l  M140_bv_bfbas(a6),M140_bv_bfp(a6) reset buffer */
    move.l M140_bv_bfbas(a6),M140_bv_bfp(a6)
/* QL:         moveq   #0,d3           show raw new line */
    moveq #0,d3
/* QL:         tst.b   M140_bv_auto(a6)     is this an auto/M140_edit or fetch? */
    tst.b M140_bv_auto(a6)
/* QL:         beq.s   M140_edit            ..fetch */
    beq.s M140_edit
/* QL:         move.w  M140_bv_edlin(a6),d4 set line to M140_edit */
    move.w M140_bv_edlin(a6),d4
/* QL:         ble.s   M140_off_auto        if the line has become silly ... */
    ble.s M140_off_auto
/* QL:         jsr     bp_detok(pc)    M140_go and put the line in the buffer(no lf) */
    jsr bp_detok(pc)
/* QL:         move.w  M140_bv_edinc(a6),d0 read the increment */
    move.w M140_bv_edinc(a6),d0
/* QL:         sne     M140_bv_auto(a6)     if it's zero then turn M140_edit off again */
    sne M140_bv_auto(a6)
/* QL:         add.w   d0,M140_bv_edlin(a6) otherwise get line to M140_edit next time */
    add.w d0,M140_bv_edlin(a6)
/* QL:         move.l  M140_bv_bfp(a6),d3 */
    move.l M140_bv_bfp(a6),d3
/* QL:         sub.l   M140_bv_bfbas(a6),d3 put cursor at end of line */
    sub.l M140_bv_bfbas(a6),d3
/* QL: M140_edit */
M140_edit:
/* QL:         bsr.s   M140_comch           only allow M140_edit if reading from console */
    bsr.s M140_comch
/* QL:         jsr     bp_rdbuf(pc)    read line into the buffer */
    jsr bp_rdbuf(pc)
/* QL:         bne.s   M140_bad_rdb         problem... M140_go sort it out */
    bne.s M140_bad_rdb
/* QL:         tas     M140_bv_brk(a6)      clear break */
    tas M140_bv_brk(a6)
/* QL:         moveq   #' ',d7         for space trim and infinite pa_graph buffer */
    moveq #32,d7
/* QL:         moveq   #27,d0 */
    moveq #27,d0
/* QL:         sub.b   -1(a6,a1.l),d0  what was the delimiter? */
    sub.b (-1)(a6,a1.l),d0
/* QL:         scs     M140_bv_arrow(a6)    0 if lf/esc, ff if up/down */
    scs M140_bv_arrow(a6)
/* QL:         beq.s   M140_off_auto        esc, turn off auto and get a new line */
    beq.s M140_off_auto
/* QL:         add.b   #$d8-27,d0      was it down arrow?  */
    add.b #((0xd8-27)&255),d0
/* QL:         bne.s   M140_trimit          no - all is ok */
    bne.s M140_trimit
/* QL:         addq.b  #2,M140_bv_arrow(a6) yes - change ff to 01 */
    addq.b #2,M140_bv_arrow(a6)
/* QL: M140_trimit */
M140_trimit:
/* QL:         subq.l  #1,a1 */
    subq.l #1,a1
/* QL:         cmp.l   M140_bv_bfbas(a6),a1 */
    cmp.l M140_bv_bfbas(a6),a1
/* QL:         beq.s   M140_universe        ignore totally blank line */
    beq.s M140_universe
/* QL:         cmp.b   -1(a6,a1.l),d7  M140_strip off trailing blanks */
    cmp.b (-1)(a6,a1.l),d7
/* QL:         beq.s   M140_trimit */
    beq.s M140_trimit
/* QL:         addq.l  #1,a1 */
    addq.l #1,a1
/* QL:         move.b  #10,-1(a6,a1.l) put in a straight line feed */
    move.b #(10&255),(-1)(a6,a1.l)
/* QL:         move.l  a1,M140_bv_bfp(a6)   now update the buffer running pointer */
    move.l a1,M140_bv_bfp(a6)
/* QL:         bra.s   M140_parse           M140_go M140_parse the line */
    bra.s M140_parse
/* QL: M140_comch */
M140_comch:
/* QL:         move.l  M140_bv_comch(a6),a0 get command channel */
    move.l M140_bv_comch(a6),a0
/* QL:         move.l  a0,d0           ..is there one? */
    move.l a0,d0
/* QL:         bne.s   M140_rts0            yes, fine */
    bne.s M140_rts0
/* QL:         moveq   #M140_c.defcn,d1     get default channel */
    moveq #M140_c.defcn,d1
/* QL:         move.w  #-1,a0          if channel not found, file not open will end us */
    move.w #(-1),a0
/* QL:         jmp     bp_chnid(pc) */
    jmp bp_chnid(pc)
/* QL: M140_rts0 */
M140_rts0:
/* QL:         rts */
    rts 
/* QL: M140_dumrt */
M140_dumrt:
/* QL:         moveq   #4,d1           select stack depth */
    moveq #4,d1
/* QL:         jsr     ib_unret(pc)    error message and unravel all */
    jsr ib_unret(pc)
/* QL: M140_parse */
M140_parse:
/* QL:         lea     pa_table(pc),a2 set start of table */
    lea pa_table(pc),a2
/* QL:         jsr     pa_graph(pc)    M140_go into graph parsing routine */
    jsr pa_graph(pc)
/* QL:         beq.s   M140_strip           all ok, M140_go use the line */
    beq.s M140_strip
/* QL:         bgt.s   M140_dumrt           lno (or new name?) input, unravel needed */
    bgt.s M140_dumrt
/* QL:         bsr.s   M140_comch           M140_parse failed, is this a file or a user? */
    bsr.s M140_comch
/* QL:         bne.s   M140_mist            it's a file, write mistake into prog */
    bne.s M140_mist
/* QL:         subq.l  #1,M140_bv_bfp(a6)   lose the terminator */
    subq.l #1,M140_bv_bfp(a6)
/* QL:         sub.l   M140_bv_bfbas(a6),a4 we will show where the problems started */
    sub.l M140_bv_bfbas(a6),a4
/* QL:         move.w  a4,-(sp) */
    move.w a4,-(sp)
/* QL:         moveq   #M140_err.bl,d0 */
    moveq #M140_err.bl,d0
/* QL:         jsr     ib_ernol(pc)    call error with no line number */
    jsr ib_ernol(pc)
/* QL:         move.w  (sp)+,d3 */
    move.w (sp)+,d3
/* QL:         bra.s   M140_edit            continue M140_edit */
    bra.s M140_edit
/* QL: M140_mist */
M140_mist:
/* QL:         jsr     pa_mist(pc) */
    jsr pa_mist(pc)
/* QL: M140_strip */
M140_strip:
/* QL:         jsr     pa_strip(pc)    M140_strip out superfluous spaces */
    jsr pa_strip(pc)
/* QL:         jsr     pf_nwlin(pc)    save the program line */
    jsr pf_nwlin(pc)
/* QL:         bra.s   M140_doline          +0 - no line number, execute at once */
    bra.s M140_doline
/* QL: *       sf      M140_bv_sing(a6)     +2 - line inserted into program file */
/* QL: * Above line seems redundant - see if it falls over without it */
/* QL:         move.l  d0,d3           state of line for relisting */
    move.l d0,d3
/* QL:         bsr.s   M140_qcomch          if lines from file, M140_go to top */
    bsr.s M140_qcomch
/* QL:         tst.l   d5              new pf_nwlin flag, zero if program is unchanged */
    tst.l d5
/* QL:         beq.s   M140_sb_rd2          no change to program, so don't relist */
    beq.s M140_sb_rd2
/* QL:         jsr     bp_list2(pc)    relist if d2/d3 imply extant screen change */
    jsr bp_list2(pc)
/* QL: M140_sb_rd2 */
M140_sb_rd2:
/* QL:         bra.l   sb_read         M140_go and read the next line */
    bra.w sb_read
/* QL: M140_qcomch */
M140_qcomch:
/* QL:         bsr.s   M140_comch           are we reading from a file? */
    bsr.s M140_comch
/* QL:         beq.s   M140_rts0            no - carry on */
    beq.s M140_rts0
/* QL:         addq.l  #4,sp           discard return */
    addq.l #4,sp
/* QL:         bra.l   M140_universe        back up to the top */
    bra.w M140_universe
/* QL: M140_doline */
M140_doline:
/* QL:         move.l  M140_bv_tkbas(a6),a4 tell start where to start */
    move.l M140_bv_tkbas(a6),a4
/* QL:         move.b  #1,M140_bv_stmnt(a6) */
    move.b #(1&255),M140_bv_stmnt(a6)
/* QL:         sf      M140_bv_inlin(a6) */
    sf M140_bv_inlin(a6)
/* QL:         st      M140_bv_cont(a6)     turn continue flag on (ie stop off) */
    st M140_bv_cont(a6)
/* QL: M140_do_1 */
M140_do_1:
/* QL:         st      M140_bv_sing(a6) */
    st M140_bv_sing(a6)
/* QL:         assert  M140_bv_linum,M140_bv_lengt-2 */
/* original assertion: M140_bv_linum,M140_bv_lengt-2 */
/* QL:         clr.l   M140_bv_linum(a6)    initialise line number and length */
    clr.l M140_bv_linum(a6)
/* QL:         jsr     ib_npass(pc) */
    jsr ib_npass(pc)
/* QL: *       sf      M140_bv_comln(a6)    first unset the flag - not needed? */
/* QL:         jsr     ib_stsng(pc)    start the single line */
    jsr ib_stsng(pc)
/* QL:         bne.s   M140_sb_rd2          had an error, close input, read a new line */
    bne.s M140_sb_rd2
/* QL:         tst.b   M140_bv_comln(a6)    must we save the command line */
    tst.b M140_bv_comln(a6)
/* QL:         beq.s   M140_resrun          no */
    beq.s M140_resrun
/* QL:         subq.w  #4,M140_bv_stopn(a6) */
    subq.w #4,M140_bv_stopn(a6)
/* QL:         blt.s   M140_do_1            if clear, carry on */
    blt.s M140_do_1
/* QL:         beq.s   M140_sb_rd2          if stop, get a new line */
    beq.s M140_sb_rd2
/* QL:         assert  M140_bv_tkbas,M140_bv_tkp-4 */
/* original assertion: M140_bv_tkbas,M140_bv_tkp-4 */
/* QL:         movem.l M140_bv_tkbas(a6),a0-a1 */
    movem.l M140_bv_tkbas(a6),a0-a1
/* QL:         moveq   #(256+2+4+2+3)>>2,d1 */
    moveq #(((((256+2)+4)+2)+3)>>2),d1
/* QL:         lsl.l   #2,d1 */
    lsl.l #2,d1
/* QL:         add.l   a1,d1 */
    add.l a1,d1
/* QL:         sub.l   a0,d1 */
    sub.l a0,d1
/* QL:         jsr     bv_chssx(pc)    ensure space on the stack (added by lwr) */
    jsr bv_chssx(pc)
/* QL:         move.l  a1,a2 */
    move.l a1,a2
/* QL: M140_push_com */
M140_push_com:
/* QL:         subq.l  #2,a2 */
    subq.l #2,a2
/* QL:         move.w  0(a6,a2.l),-(sp) */
    move.w 0(a6,a2.l),-(sp)
/* QL:         cmp.l   a2,a0           finished yet? */
    cmp.l a2,a0
/* QL:         bne.s   M140_push_com */
    bne.s M140_push_com
/* QL: * N.B. The following assumes that the token list is never longer than 32766, */
/* QL: * but I guess that's fairly reasonable... lwr */
/* QL:         sub.l   a0,a1           length of token list saved */
    sub.l a0,a1
/* QL:         move.w  a1,-(sp) */
    move.w a1,-(sp)
/* QL:         assert  M140_bv_inlin,M140_bv_sing-1,M140_bv_index-2 */
/* original assertion: M140_bv_inlin,M140_bv_sing-1,M140_bv_index-2 */
/* QL:         move.l  M140_bv_inlin(a6),-(sp) */
    move.l M140_bv_inlin(a6),-(sp)
/* QL:         move.b  M140_bv_stmnt(a6),1(sp) the statement number */
    move.b M140_bv_stmnt(a6),1(sp)
/* QL:         sub.l   a4,a0           negative offset of where we got to */
    sub.l a4,a0
/* QL:         move.w  a0,-(sp) */
    move.w a0,-(sp)
/* QL: M140_resrun */
M140_resrun:
/* QL:         bsr.s   M140_qcomch          if lines from file, M140_go to top */
    bsr.s M140_qcomch
/* QL: M140_rr_chk */
M140_rr_chk:
/* QL:         tst.w   M140_bv_nxlin(a6)    should we restore or M140_run? */
    tst.w M140_bv_nxlin(a6)
/* QL:         bge.s   M140_run */
    bge.s M140_run
/* QL:         tst.b   (sp)            no, is there a command line to restore */
    tst.b (sp)
/* QL:         bpl.s   M140_sb_rd3          no, just read a new line then */
    bpl.s M140_sb_rd3
/* QL:         move.l  M140_bv_tkbas(a6),a0 start at beginning of toklist */
    move.l M140_bv_tkbas(a6),a0
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         sub.w   (sp)+,a4        a4 now pointing to next bit of sing to do */
    sub.w (sp)+,a4
/* QL:         move.b  1(sp),M140_bv_stmnt(a6) restore the statement */
    move.b 1(sp),M140_bv_stmnt(a6)
/* QL:         move.l  (sp)+,M140_bv_inlin(a6) */
    move.l (sp)+,M140_bv_inlin(a6)
/* QL:         move.w  (sp)+,d0        length of command line */
    move.w (sp)+,d0
/* QL: M140_pop_com */
M140_pop_com:
/* QL:         move.w  (sp)+,0(a6,a0.l) */
    move.w (sp)+,0(a6,a0.l)
/* QL:         addq.l  #2,a0 */
    addq.l #2,a0
/* QL:         subq.w  #2,d0           done yet? */
    subq.w #2,d0
/* QL:         bne.s   M140_pop_com */
    bne.s M140_pop_com
/* QL:         move.l  a0,M140_bv_tkp(a6)   reset the running pointer */
    move.l a0,M140_bv_tkp(a6)
/* QL:         bra.s   M140_do_1 */
    bra.s M140_do_1
/* QL: M140_sb_rd3 */
M140_sb_rd3:
/* QL:         bra.l   sb_read */
    bra.w sb_read
/* QL: M140_run */
M140_run:
/* QL:         jsr     ib_npass(pc) */
    jsr ib_npass(pc)
/* QL:         sf      M140_bv_sing(a6) */
    sf M140_bv_sing(a6)
/* QL:         move.b  #1,M140_bv_stmnt(a6) */
    move.b #(1&255),M140_bv_stmnt(a6)
/* QL:         move.w  M140_bv_nxlin(a6),d4 now then, where are we to start? */
    move.w M140_bv_nxlin(a6),d4
/* QL:         jsr     ib_glin0(pc)    find it */
    jsr ib_glin0(pc)
/* QL:         ble.s   M140_sb_rd3          not in program, so ignore */
    ble.s M140_sb_rd3
/* QL:         subq.w  #2,d1 */
    subq.w #2,d1
/* QL:         move.w  d1,M140_bv_lengt(a6) set prior line length */
    move.w d1,M140_bv_lengt(a6)
/* QL:         tst.w   d4 */
    tst.w d4
/* QL:         beq.s   M140_ib_1            start at the top, ignore nxstm */
    beq.s M140_ib_1
/* QL:         move.b  M140_bv_nxstm(a6),d4 which statement? */
    move.b M140_bv_nxstm(a6),d4
/* QL:         beq.s   M140_ib_1            the first statement */
    beq.s M140_ib_1
/* QL:         jsr     ib_stnxi(pc) */
    jsr ib_stnxi(pc)
/* QL:         jsr     ib_gost(pc) */
    jsr ib_gost(pc)
/* QL: M140_go */
M140_go:
/* QL:         jsr     ib_st1(pc)      start from next statement */
    jsr ib_st1(pc)
/* QL: M140_ib_ret */
M140_ib_ret:
/* QL:         bne.s   M140_sb_rd3          had an error, read a new line (? work ?) */
    bne.s M140_sb_rd3
/* QL:         tst.w   M140_bv_stopn(a6)    why have we come back ? */
    tst.w M140_bv_stopn(a6)
/* QL:         beq.s   M140_go              if clear, carry straight on */
    beq.s M140_go
/* QL:         bra.s   M140_resrun          if not clear, then read, M140_run or restore */
    bra.s M140_resrun
/* QL: M140_ib_1 */
M140_ib_1:
/* QL:         jsr     ib_start(pc)    start from top of a line */
    jsr ib_start(pc)
/* QL:         bra.s   M140_ib_ret */
    bra.s M140_ib_ret
/* QL:         end */
