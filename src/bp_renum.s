/* ROM section bp_renum */
.balign 2,0
/* QL: bp_auto */
bp_auto:
/* QL:         moveq   #10,d7          default increment is 10 for auto */
    moveq #10,d7
/* QL: bp_edit         ;               default increment zero for edit */
bp_edit:
/* QL:         moveq   #-1,d6          flag edit/auto by having all 1's in last line */
    moveq #(-1),d6
/* QL:         bra.s   M50_st_arg */
    bra.s M50_st_arg
/* QL: bp_renum */
bp_renum:
/* QL:         moveq   #10,d7          default steps of 10 for renumber */
    moveq #10,d7
/* QL:         moveq   #-2,d6          flag M50_renum by having a zero lsb. */
    moveq #(-2),d6
/* QL: M50_st_arg */
M50_st_arg:
/* QL:         jsr     bp_chunr(pc)    make sure we're allowed to */
    jsr bp_chunr(pc)
/* QL: * First get the arguments. d7 = renumber/edit step, d6 = -1, or -2 for RENUM */
/* QL:         move.l  a5,-(sp)        if all else fails, renumber from top */
    move.l a5,-(sp)
/* QL:         move.l  d7,-(sp)        save default step at 2(sp) */
    move.l d7,-(sp)
/* QL:         moveq   #100,d7         default starting renumber/edit from 100 */
    moveq #100,d7
/* QL:         ror.w   #1,d6           form 32767 (max line number) for M50_renum */
    ror.w #1,d6
/* QL:         bmi.s   M50_ch_num          auto/edit - just go for " {start} {,step} " */
    bmi.s M50_ch_num
/* QL: * RENUM has optional range first: "{ {first} to {last} }" or "{first/last} ;" */
/* QL:         moveq   #1,d4           first line */
    moveq #1,d4
/* QL:         bsr.s   M50_get_arg         get arg and its separator */
    bsr.s M50_get_arg
/* QL:         cmp.b   #M50_b.septo,d5     " {first} to ... " ? */
    cmp.b #(M50_b.septo&255),d5
/* QL:         bne.s   M50_s_semi */
    bne.s M50_s_semi
/* QL:         tst.b   d0              " first to ... " ? */
    tst.b d0
/* QL:         bne.s   M50_ch_last */
    bne.s M50_ch_last
/* QL:         move.w  d1,d4           yes, set first line */
    move.w d1,d4
/* QL: M50_ch_last */
M50_ch_last:
/* QL:         bsr.s   M50_get_arg         get another arg, is it " ... to last ... " ? */
    bsr.s M50_get_arg
/* QL:         bne.s   M50_to_set */
    bne.s M50_to_set
/* QL:         move.w  d1,d6           yes, set last line */
    move.w d1,d6
/* QL: M50_to_set */
M50_to_set:
/* QL:         cmp.b   #M50_b.semi,d5      " {first} to {last} ; ... " ? */
    cmp.b #(M50_b.semi&255),d5
/* QL:         beq.s   M50_ch_num          yes, go get start line */
    beq.s M50_ch_num
/* QL:         bra.s   M50_ch_sep          no, go see if final " , {step} " is present */
    bra.s M50_ch_sep
/* QL: M50_get_arg */
M50_get_arg:
/* QL:         moveq   #0,d5 */
    moveq #0,d5
/* QL:         cmp.l   8(sp),a3        any args left? */
    cmp.l 8(sp),a3
/* QL:         beq.s   M50_null_arg */
    beq.s M50_null_arg
/* QL:         jsr     bp_gsep(pc)     get separator & see if there's an arg */
    jsr bp_gsep(pc)
/* QL:         beq.s   M50_null_arg */
    beq.s M50_null_arg
/* QL:         jsr     bp_gint(pc)     get an integer arg > 0 */
    jsr bp_gint(pc)
/* QL:         beq.s   M50_rts0 */
    beq.s M50_rts0
/* QL:         addq.l  #4,sp           skip this return */
    addq.l #4,sp
/* QL:         bra.s   M50_pop8            and complain */
    bra.s M50_pop8
/* QL: M50_null_arg */
M50_null_arg:
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL: M50_rts0 */
M50_rts0:
/* QL:         rts */
    rts 
/* QL: M50_s_semi */
M50_s_semi:
/* QL:         cmp.b   #M50_b.semi,d5      " {first/last=only} ; " ? */
    cmp.b #(M50_b.semi&255),d5
/* QL:         bne.s   M50_s_com */
    bne.s M50_s_com
/* QL:         tst.b   d0 */
    tst.b d0
/* QL:         bne.s   M50_ch_num */
    bne.s M50_ch_num
/* QL:         move.w  d1,d4           set 1st line */
    move.w d1,d4
/* QL:         move.w  d1,d6           set last line */
    move.w d1,d6
/* QL: * All can have now is " ... {start} { , {step} } " */
/* QL: M50_ch_num */
M50_ch_num:
/* QL:         bsr.s   M50_get_arg */
    bsr.s M50_get_arg
/* QL: M50_s_com */
M50_s_com:
/* QL:         tst.b   d0 */
    tst.b d0
/* QL:         bne.s   M50_ch_sep */
    bne.s M50_ch_sep
/* QL:         move.w  d1,d7           set new start line */
    move.w d1,d7
/* QL: M50_ch_sep */
M50_ch_sep:
/* QL:         cmp.b   #M50_b.sepcom,d5 */
    cmp.b #(M50_b.sepcom&255),d5
/* QL:         bne.s   M50_no_sep */
    bne.s M50_no_sep
/* QL:         bsr.s   M50_get_arg */
    bsr.s M50_get_arg
/* QL:         bne.s   M50_no_sep */
    bne.s M50_no_sep
/* QL:         move.l  d1,(sp)         overwrite step size at 2(sp) */
    move.l d1,(sp)
/* QL: M50_no_sep */
M50_no_sep:
/* QL:         moveq   #M50_err.bp,d0      in case they try to sneak sommat funny past us! */
    moveq #M50_err.bp,d0
/* QL:         subq.l  #1,d5 */
    subq.l #1,d5
/* QL:         bcc.s   M50_pop8            ok if no separator left, and set d5.l=-1 */
    bcc.s M50_pop8
/* QL: * d7.l = start line to edit or renumber to */
/* QL: * 2(sp).w = step for edit or renumber range */
/* QL:         move.w  d7,(sp)         form start/step on stack at (sp) and 2(sp) */
    move.w d7,(sp)
/* QL:         ext.l   d6              what are we doing? (clear msw if M50_renum) */
    ext.l d6
/* QL:         bpl.s   M50_renum */
    bpl.s M50_renum
/* QL:         assert  M50_bv_edlin,M50_bv_edinc-2 */
/* original assertion: M50_bv_edlin,M50_bv_edinc-2 */
/* QL:         move.l  (sp),M50_bv_edlin(a6) start line and increment for subsequent lines */
    move.l (sp),M50_bv_edlin(a6)
/* QL:         st      M50_bv_auto(a6)     set auto/edit flag for unvrs */
    st M50_bv_auto(a6)
/* QL: M50_exit */
M50_exit:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M50_pop8 */
M50_pop8:
/* QL:         addq.l  #8,sp */
    addq.l #8,sp
/* QL:         rts */
    rts 
/* QL: * Now check that all is OK for renumbering */
/* QL: * d4.l = first line in old range to be renumbered */
/* QL: * d5.l = -1 */
/* QL: * d6.l = last line in old range to be renumbered */
/* QL: * d7.l = first line in new renumbered range */
/* QL: * (sp).w = also first line in renumbered range */
/* QL: * 2(sp).w = step for renumbered range */
/* QL: M50_renum */
M50_renum:
/* QL:         jsr     ib_glin0(pc)    goto the start line */
    jsr ib_glin0(pc)
/* QL:         ble.s   M50_exit            not in program - that requires no work! */
    ble.s M50_exit
/* QL:         move.l  a4,a3           duplicate pointer */
    move.l a4,a3
/* QL:         cmp.l   d0,a4 */
    cmp.l d0,a4
/* QL:         ble.s   M50_preok           no check if at start, and d5=-1 is ok */
    ble.s M50_preok
/* QL:         sub.w   d1,a4 */
    sub.w d1,a4
/* QL:         cmp.w   4(a6,a4.l),d7   check that new start > previous lno */
    cmp.w 4(a6,a4.l),d7
/* QL:         ble.s   M50_pop_or          we could allow renumber of no lines through... */
    ble.s M50_pop_or
/* QL:         sub.w   4(a6,a4.l),d5   we need pre-start lno plus one - this negated */
    sub.w 4(a6,a4.l),d5
/* QL:         add.w   d1,a4 */
    add.w d1,a4
/* QL: M50_preok */
M50_preok:
/* QL: * Establish how many lines in range, and get a final, out-of-range line number */
/* QL:         move.w  d1,d4           duplicate length+2 */
    move.w d1,d4
/* QL:         moveq   #-1,d3 */
    moveq #(-1),d3
/* QL: M50_countup */
M50_countup:
/* QL:         move.w  4(a6,a3.l),d0   get line number */
    move.w 4(a6,a3.l),d0
/* QL:         cmp.w   d0,d6           have we gone past end of range? */
    cmp.w d0,d6
/* QL:         blt.s   M50_counted         yes - we're M50_ready */
    blt.s M50_counted
/* QL:         addq.l  #1,d3           counting lines after 1st line in range */
    addq.l #1,d3
/* QL:         add.w   0(a6,a3.l),d1   adjust length */
    add.w 0(a6,a3.l),d1
/* QL:         add.w   d1,a3           and move to the end */
    add.w d1,a3
/* QL:         cmp.l   d2,a3 */
    cmp.l d2,a3
/* QL:         blt.s   M50_countup */
    blt.s M50_countup
/* QL: * Note: we have one problem that we must avoid. If there is not yet a line */
/* QL: * number 32767, we cannot allow renumbering to produce one, in case there exist */
/* QL: * references to beyond the last line actually present! */
/* QL:         addq.w  #1,d0           check if genuine line 32767 was present */
    addq.w #1,d0
/* QL:         bmi.s   M50_counted         yes! leave with 32768 as pseudo end line */
    bmi.s M50_counted
/* QL:         move.w  #32767,d0       pretend post-range lno is max possible lno */
    move.w #32767,d0
/* QL: M50_counted */
M50_counted:
/* QL:         move.w  d0,d6           now we have the first line above range M50_ready */
    move.w d0,d6
/* QL:         move.l  (sp),d2         step in lsw */
    move.l (sp),d2
/* QL:         muls    d3,d2           * ( lines - 1 ) */
    muls d3,d2
/* QL:         bmi.s   M50_exit            if there were no lines in range, M50_exit ok! */
    bmi.s M50_exit
/* QL:         add.l   d7,d2           + start line = new number for last line */
    add.l d7,d2
/* QL:         cmp.l   d6,d2           check renumbered end < post range line number */
    cmp.l d6,d2
/* QL:         blt.s   M50_ready           good stuff, now we can get on! */
    blt.s M50_ready
/* QL: M50_pop_or */
M50_pop_or:
/* QL:         moveq   #M50_err.or,d0 */
    moveq #M50_err.or,d0
/* QL:         bra.s   M50_pop8            go report out-of-range */
    bra.s M50_pop8
/* QL: M50_ready */
M50_ready:
/* QL:         move.l  (sp),d7         more convenient later to keep start/step in d7 */
    move.l (sp),d7
/* QL: * We are now fully prepared to start actioning the M50_renum */
/* QL: * Some (rambling) implementation notes: */
/* QL: * We can keep d5-d7 and a-regs except a1 preserved while we actually do the */
/* QL: * program renumbering (plus a4 is program pointer). */
/* QL: * It does not matter if we include the post lno in the renumber, but all is */
/* QL: * much nicer if we don't include it! */
/* QL: * The range of the renumber contains just pre+1 to post-1 inclusive. */
/* QL: * We want a fast compare by "move (),ds:sub.w dy,ds:add.w dx,ds:bcc.s done". */
/* QL: * So we must get a value 0..post-(pre+1)-1 in ds after the comparison. */
/* QL: * So we want post-(pre+1) and post for dx/dy. We'll use d5=dx and d6=dy. */
/* QL: * We need post and lastreal-(pre+1) so we can renumber final set. */
/* QL: * We only need table entries for the comparisons we need to make. */
/* QL: * Table entry "-1" is a pseudo zero, so they must have (pre+1) knocked off. */
/* QL: * Last table entry will be lastreal-(pre+1), used only for final set. */
/* QL: * Total table comparison words needed is number of real lines. */
/* QL: * Need table base and top, for which we'll use a0/a3. */
/* QL: * Need start, step for renumbering all but last set in range (in d7 now). */
/* QL: * d3.l lines in range less one (i.e. 0 if single line) */
/* QL: * d4.w length of line at a4, plus 2 for effeciency */
/* QL: * d5.l (-ve) pre-range line number plus one (i.e. first line ref to be altered) */
/* QL: * d6.l post range line number (may be real line or pseudo 32767/8) */
/* QL: * d7.msw start line for renumbered range */
/* QL: * d7.lsw step for renumber line */
/* QL: * Allocate table, then fill it in as we renumber lines in the range. */
/* QL: * Minimal table (for single line renumber) will contain just 1 word (plus w/s). */
/* QL: * We're using a VV area, so called routines shouldn't be too restricted. */
/* QL: * Also, using space there is probably not causing the VV area to expand */
/* QL: * unneccessarily, as the space used will be proportionate to the size of the */
/* QL: * program, and, assume that does do some work, it'll probably need variables! */
/* QL: * Finally, at least CLEAR will wipe the VV area if it's called later on. */
/* QL: M50_ren.ws  equ     6*2             workspace used as RI type stack at top of table */
.equ M50_ren.ws,(6*2)
/* QL:         moveq   #1+M50_ren.ws/2,d1  we need one line, plus the workspace. */
    moveq #(1+(M50_ren.ws/2)),d1
/* QL:         add.l   d3,d1 */
    add.l d3,d1
/* QL:         add.l   d1,d1           * 2 = no bytes needed in table */
    add.l d1,d1
/* QL:         jsr     bv_alvv(pc)     allocate the space */
    jsr bv_alvv(pc)
/* QL:         move.l  a0,a3           copy table base */
    move.l a0,a3
/* QL: M50_nx_lno */
M50_nx_lno:
/* QL:         move.w  4(a6,a4.l),d2   get old lno */
    move.w 4(a6,a4.l),d2
/* QL:         add.w   d5,d2           adjust to what we want in table */
    add.w d5,d2
/* QL:         move.w  d2,0(a6,a3.l)   store old line number less (pre+1) */
    move.w d2,0(a6,a3.l)
/* QL:         move.w  (sp),4(a6,a4.l) edit program to new line number */
    move.w (sp),4(a6,a4.l)
/* QL:         add.w   d7,(sp)         update new line number */
    add.w d7,(sp)
/* QL:         add.w   0(a6,a4.l),d4   adjust length */
    add.w 0(a6,a4.l),d4
/* QL:         add.w   d4,a4           and move to the end */
    add.w d4,a4
/* QL:         addq.l  #2,a3           next table entry */
    addq.l #2,a3
/* QL:         dbra    d3,M50_nx_lno       we now know exactly how many lines we're doing */
    dbra d3,M50_nx_lno
/* QL:         add.l   d6,d5           now we have post-(pre+1), as we wish for */
    add.l d6,d5
/* QL:         lea     M50_get_new,a2      address of renumber routine */
    lea M50_get_new(pc),a2
/* QL: * Notes: */
/* QL: * d5-d7/a0/a2-a3 must be preserved for the renumber routine. */
/* QL: * a2 is the address of the renumber routine. */
/* QL: * The when and uproc routines may use d4 and a5 as they wish. */
/* QL: * On calling the routine at a2, they must supply d5-d7/a0/a3 as given to them. */
/* QL: * They must set a1 as the rel-a6 pointer to the word containing the line number */
/* QL: * to be adjusted. a1 is preserved. */
/* QL: * If the line is renumbered, its new value is returned in d0.l (1-32767). */
/* QL: * If the line is not renumbered, d0.l returns with zero. */
/* QL: * The condition code on return is the result of testing d0.l, in effect. */
/* QL: * d1-d3 will be destroyed. */
/* QL: * N.B. d0-d4/a1 variously zapped in the following */
/* QL:         tst.b   M50_bv_uproc(a6)    is there a user trace procedure? */
    tst.b M50_bv_uproc(a6)
/* QL:         bpl.s   M50_noup */
    bpl.s M50_noup
/* QL:         jsr     bv_uprnm(pc)    yes - go see to it */
    jsr bv_uprnm(pc)
/* QL: M50_noup */
M50_noup:
/* QL:         jsr     ib_whrnm(pc)    go let when do it's checks */
    jsr ib_whrnm(pc)
/* QL:         jsr     ib_stbas(pc) */
    jsr ib_stbas(pc)
/* QL:         bra.s   M50_on_line         go start a new line */
    bra.s M50_on_line
/* QL: M50_st_1 */
M50_st_1:
/* QL:         tst.b   d0 */
    tst.b d0
/* QL:         beq.s   M50_on_stmt */
    beq.s M50_on_stmt
/* QL: M50_on_line */
M50_on_line:
/* QL:         move.l  a4,(sp)         save marker for start of line, in case shi->lgi */
    move.l a4,(sp)
/* QL: M50_on_stmt */
M50_on_stmt:
/* QL:         bsr.s   M50_nxnon           get 1st token in statement */
    bsr.s M50_nxnon
/* QL:         sub.w   #M50_w.go,d1 */
    sub.w #M50_w.go,d1
/* QL:         beq.s   M50_skip_go         if go, skip it */
    beq.s M50_skip_go
/* QL:         subq.w  #M50_w.rstr-M50_w.go,d1 */
.word 20801|((((M50_w.rstr-M50_w.go))&7)<<9)
/* QL:         beq.s   M50_ch_fp           go skip restore and look for fp */
    beq.s M50_ch_fp
/* QL:         subq.w  #M50_w.on-M50_w.rstr,d1 */
.word 20801|((((M50_w.on-M50_w.rstr))&7)<<9)
/* QL:         bne.s   M50_nx_stmnt        if not on, try again */
    bne.s M50_nx_stmnt
/* QL: M50_nx_token */
M50_nx_token:
/* QL:         jsr     ib_nxtk(pc)     get next token */
    jsr ib_nxtk(pc)
/* QL:         bsr.s   M50_noncheos        skip spaces & check for end-statement */
    bsr.s M50_noncheos
/* QL:         beq.s   M50_nx_stmnt */
    beq.s M50_nx_stmnt
/* QL:         cmp.w   #M50_w.go,d1 */
    cmp.w #M50_w.go,d1
/* QL:         bne.s   M50_nx_token        if not go, go get next token */
    bne.s M50_nx_token
/* QL: M50_skip_go */
M50_skip_go:
/* QL:         bsr.s   M50_skpnonc         skip go, get to/sub */
    bsr.s M50_skpnonc
/* QL: M50_ch_fp */
M50_ch_fp:
/* QL:         bsr.s   M50_skpnonc         get 1st token of expression, checking for eos */
    bsr.s M50_skpnonc
/* QL:         beq.s   M50_nx_stmnt */
    beq.s M50_nx_stmnt
/* QL:         sub.b   #M50_b.lgi,d0       long integers are lovely, and most frequent */
    sub.b #(M50_b.lgi&255),d0
/* QL:         bne.s   M50_others */
    bne.s M50_others
/* QL:         lea     2(a4),a1 */
    lea 2(a4),a1
/* QL:         jsr     (a2) */
    jsr (a2)
/* QL: M50_nx_exp */
M50_nx_exp:
/* QL:         jsr     ib_nxcom(pc)    get a comma not inside ()'s */
    jsr ib_nxcom(pc)
/* QL:         bne.s   M50_ch_fp           ok, check the first token */
    bne.s M50_ch_fp
/* QL: M50_nx_stmnt */
M50_nx_stmnt:
/* QL:         jsr     ib_nxst(pc)     get start of next statement */
    jsr ib_nxst(pc)
/* QL:         beq.s   M50_st_1 */
    beq.s M50_st_1
/* QL:         bra.s   M50_tidy_up */
    bra.s M50_tidy_up
/* QL: M50_skpnonc */
M50_skpnonc:
/* QL:         addq.l  #2,a4           skip over word token */
    addq.l #2,a4
/* QL: M50_noncheos */
M50_noncheos:
/* QL:         pea     ib_cheos(pc)    check end-of-statement after M50_nxnon */
    pea ib_cheos(pc)
/* QL: M50_nxnon */
M50_nxnon:
/* QL:         jmp     ib_nxnon(pc) */
    jmp ib_nxnon(pc)
/* QL: M50_others */
M50_others:
/* QL:         lea     6(a3),a1        use RI-type workspace at top of table */
    lea 6(a3),a1
/* QL:         addq.b  #M50_b.lgi-M50_b.shi,d0 short integers are a pain! they may not fit! */
.word 20480|((((M50_b.lgi-M50_b.shi))&7)<<9)
/* QL:         beq.s   M50_doshi           changing lgi/shi both ways needs PF reshuffle! */
    beq.s M50_doshi
/* QL:         sub.w   #$f000,d1       float needs some fiddling */
    sub.w #0xf000,d1
/* QL:         bcs.s   M50_nx_exp          anything else, we'll skip, cos we're dumb */
    bcs.s M50_nx_exp
/* QL:         move.w  d1,0(a6,a1.l)   put on exponent */
    move.w d1,0(a6,a1.l)
/* QL:         move.l  2(a6,a4.l),2(a6,a1.l) put on mantissa */
    move.l 2(a6,a4.l),2(a6,a1.l)
/* QL:         jsr     ri_nint(pc)     convert it to an integer line number */
    jsr ri_nint(pc)
/* QL:         bne.s   M50_nx_exp          didn't convert, so ignore it */
    bne.s M50_nx_exp
/* QL:         jsr     (a2)            give the current number and get new one */
    jsr (a2)
/* QL:         beq.s   M50_nx_exp          not renumbered, so leave original unchanged */
    beq.s M50_nx_exp
/* QL:         jsr     ri_float(pc) */
    jsr ri_float(pc)
/* QL:         movem.w 0(a6,a1.l),d0-d2 get new fp */
    movem.w 0(a6,a1.l),d0-d2
/* QL:         or.w    #$f000,d0       insert token into exponent */
    or.w #0xf000,d0
/* QL:         movem.w d0-d2,0(a6,a4.l) replace fp */
    movem.w d0-d2,0(a6,a4.l)
/* QL: M50_nx_exp2 */
M50_nx_exp2:
/* QL:         bra.s   M50_nx_exp */
    bra.s M50_nx_exp
/* QL: M50_tidy_up */
M50_tidy_up:
/* QL:         addq.l  #8,sp           we're finished with the stacked values */
    addq.l #8,sp
/* QL:         st      M50_bv_cont(a6)     because nxst will have set stop */
    st M50_bv_cont(a6)
/* QL:         st      M50_bv_edit(a6)     say the program has changed */
    st M50_bv_edit(a6)
/* QL: * Finally, tidy up all line numbers in bv area, and relist */
/* QL:         movem.l M50_bv_lnbas(a6),a1/a5 get line number table pointers */
    movem.l M50_bv_lnbas(a6),a1/a5
/* QL:         bra.s   M50_lnent           enter loop at end */
    bra.s M50_lnent
/* QL: * This is the naff one... renumbering a short integer */
/* QL: M50_doshi */
M50_doshi:
/* QL:         ext.w   d1 */
    ext.w d1
/* QL:         move.w  d1,0(a6,a1.l)   put on word value */
    move.w d1,0(a6,a1.l)
/* QL:         jsr     (a2)            give the current number and get new one */
    jsr (a2)
/* QL:         beq.s   M50_nx_exp          not renumbered, so leave original unchanged */
    beq.s M50_nx_exp
/* QL:         move.b  d0,1(a6,a4.l)   replace value, we hope */
    move.b d0,1(a6,a4.l)
/* QL:         cmp.w   #128,d0         does it still fit? */
    cmp.w #128,d0
/* QL:         bcs.s   M50_nx_exp          yes - great */
    bcs.s M50_nx_exp
/* QL: * Disaster time... we can't fit the new line number in. We have to move the */
/* QL: * program. We don't like this, but we have had complaints. This is pretty much */
/* QL: * guaranteed to work, assuming that we have managed to save the right amount of */
/* QL: * info. I don't think it's going to be a major disaster, provided someone is */
/* QL: * not lunatic enough to have a RENUM inside their program code! */
/* QL: * If we get an out of memory error, it's a total disaster. */
/* QL:         sub.l   a0,a3 */
    sub.l a0,a3
/* QL:         sub.l   M50_bv_vvbas(a6),a0 protect our table pointers */
    sub.l M50_bv_vvbas(a6),a0
/* QL:         moveq   #2,d1           one extra word needed */
    moveq #2,d1
/* QL:         jsr     bv_chpfx(pc)    we hope this does nothing... */
    jsr bv_chpfx(pc)
/* QL:         add.l   M50_bv_vvbas(a6),a0 restore our table pointers */
    add.l M50_bv_vvbas(a6),a0
/* QL:         add.l   a0,a3 */
    add.l a0,a3
/* QL:         move.l  (sp),a1         get marker for start of line */
    move.l (sp),a1
/* QL:         addq.w  #2,M50_bv_lengt(a6) this line will get longer */
    addq.w #2,M50_bv_lengt(a6)
/* QL:         addq.w  #2,-6(a6,a1.l)  its pre-word goes up */
    addq.w #2,(-6)(a6,a1.l)
/* QL:         add.w   M50_bv_lengt(a6),a1 step to end of line (includes pre-word) */
    add.w M50_bv_lengt(a6),a1
/* QL:         subq.w  #2,-6(a6,a1.l)  next pre-word (or word past pfp) goes down */
    subq.w #2,(-6)(a6,a1.l)
/* QL:         move.l  a4,a1           source (include token, to save a word) */
    move.l a4,a1
/* QL:         move.l  a0,-(sp)        save table base */
    move.l a0,-(sp)
/* QL:         lea     2(a1),a0        destination */
    lea 2(a1),a0
/* QL:         move.l  M50_bv_pfp(a6),d1   top of program */
    move.l M50_bv_pfp(a6),d1
/* QL:         addq.l  #2,M50_bv_pfp(a6)   it's growing */
    addq.l #2,M50_bv_pfp(a6)
/* QL:         sub.l   a1,d1           total length */
    sub.l a1,d1
/* QL:         jsr     mm_mrtor(pc)    shuffle the whole damn thing up         */
    jsr mm_mrtor(pc)
/* QL:         move.l  (sp)+,a0 */
    move.l (sp)+,a0
/* QL:         addq.b  #M50_b.lgi-M50_b.shi,0(a6,a4.l) change token to long integer */
    addq.b #(M50_b.lgi-M50_b.shi),0(a6,a4.l)
/* QL:         ; N.B. we've left the lsb with junk, instead of the "official" zero. */
/* QL:         ; This shouldn't be a problem, and a SAVE/LOAD is a good idea anyway. */
/* QL:         move.w  6(a6,a3.l),2(a6,a4.l) put new line number */
    move.w 6(a6,a3.l),2(a6,a4.l)
/* QL:         bra.s   M50_nx_exp2 */
    bra.s M50_nx_exp2
/* QL: * Finishing off bits */
/* QL: M50_lnloop */
M50_lnloop:
/* QL:         jsr     (a2) */
    jsr (a2)
/* QL:         addq.l  #4,a1 */
    addq.l #4,a1
/* QL: M50_lnent */
M50_lnent:
/* QL:         cmp.l   a1,a5 */
    cmp.l a1,a5
/* QL:         bgt.s   M50_lnloop */
    bgt.s M50_lnloop
/* QL:         lea     M50_bvtab,a5        miscellaneous variables */
    lea M50_bvtab(pc),a5
/* QL:         moveq   #M50_bv_linum,d0    start with this one */
    moveq #M50_bv_linum,d0
/* QL: M50_newlp */
M50_newlp:
/* QL:         move.w  d0,a1 */
    move.w d0,a1
/* QL:         jsr     (a2)            renumber it */
    jsr (a2)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         move.b  (a5)+,d0 */
    move.b (a5)+,d0
/* QL:         bne.s   M50_newlp */
    bne.s M50_newlp
/* QL:         moveq   #M50_ren.ws,d1 */
    moveq #M50_ren.ws,d1
/* QL:         add.l   a3,d1 */
    add.l a3,d1
/* QL:         sub.l   a0,d1           amount to free */
    sub.l a0,d1
/* QL:         jsr     bv_frvv(pc) */
    jsr bv_frvv(pc)
/* QL:         jsr     bp_listr(pc)    relist the current window */
    jsr bp_listr(pc)
/* QL: M50_okrts */
M50_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Renumbering subroutine */
/* QL: * d0 -  o- new line number value at 0(a6,a1.l), or zero if not changed. */
/* QL: * d5 -ip - post lno - (pre+1) */
/* QL: * d6 -ip - post lno */
/* QL: * d7 -ip - start/step for renumbered line numbers */
/* QL: * a0 -ip - base of table */
/* QL: * a1 -i o- rel a6 pointer to line number to examine */
/* QL: * a3 -ip - top of table */
/* QL: * ccr-  o- zero if line not renumbered or positive if it was */
/* QL: * d1-d3 destroyed */
/* QL: * 0(a6,a0.l) first, or only, real lno of renumber range, less (pre+1) */
/* QL: * -2(a6,a3.l) last, or only, real lno of renumber range, less (pre+1) */
/* QL: M50_get_new */
M50_get_new:
/* QL:         move.w  0(a6,a1.l),d3   get line number there */
    move.w 0(a6,a1.l),d3
/* QL:         sub.w   d6,d3           subtract post-lno, which is out of the range */
    sub.w d6,d3
/* QL:         add.w   d5,d3           add line range: post-lno less pre-lno less one */
    add.w d5,d3
/* QL:         bcc.s   M50_okrts           not in range, go say we didn't change this one */
    bcc.s M50_okrts
/* QL:         move.w  d6,d0           lines above last renumber to post-lno */
    move.w d6,d0
/* QL:         cmp.w   -2(a6,a3.l),d3  are we matching the last+1 to post-1 range? */
    cmp.w (-2)(a6,a3.l),d3
/* QL:         bhi.s   M50_lkput           yes, we've finished, so go put new number */
    bhi.s M50_lkput
/* QL:         move.l  a0,d1           lower limit (may stop here) */
    move.l a0,d1
/* QL:         move.l  a3,d2           upper limit (never stop here) */
    move.l a3,d2
/* QL: M50_lkup */
M50_lkup:
/* QL:         addq.l  #2,d1           round up this time */
    addq.l #2,d1
/* QL:         move.l  d1,d0           set new low limit */
    move.l d1,d0
/* QL:         cmp.l   d0,d2           is there still more than one entry to check? */
    cmp.l d0,d2
/* QL:         ble.s   M50_lklast          no, so we finish at this, or the earlier one */
    ble.s M50_lklast
/* QL:         add.l   d2,d1 */
    add.l d2,d1
/* QL: M50_lkchop */
M50_lkchop:
/* QL:         lsr.l   #2,d1           lose lsb's */
    lsr.l #2,d1
/* QL:         add.l   d1,d1           middle, rounded */
    add.l d1,d1
/* QL:         cmp.w   -2(a6,d1.l),d3 */
    cmp.w (-2)(a6,d1.l),d3
/* QL:         bhi.s   M50_lkup            search > entry, so we can move low limit */
    bhi.s M50_lkup
/* QL: M50_lkent */
M50_lkent:
/* QL:         subq.l  #2,d1           search <= entry, so never look there again */
    subq.l #2,d1
/* QL:         move.l  d1,d2           save upper limit which may still work */
    move.l d1,d2
/* QL:         add.l   d0,d1 */
    add.l d0,d1
/* QL:         cmp.l   d0,d2           ah! but what is left in the range? */
    cmp.l d0,d2
/* QL:         bgt.s   M50_lkchop          more than one, so keep chopping */
    bgt.s M50_lkchop
/* QL: M50_lklast */
M50_lklast:
/* QL:         bne.s   M50_lkback          if range exhasted, must want earlier one */
    bne.s M50_lkback
/* QL:         cmp.w   -2(a6,d0.l),d3  final, single compare */
    cmp.w (-2)(a6,d0.l),d3
/* QL:         bhi.s   M50_lkok            search > entry, so this is the one */
    bhi.s M50_lkok
/* QL: M50_lkback */
M50_lkback:
/* QL:         subq.l  #2,d0           back up to final one that worked */
    subq.l #2,d0
/* QL: * We have {-2(a6,d0.l)} < d3 <= 0(a6,d0.l), therefore... */
/* QL: M50_lkok */
M50_lkok:
/* QL:         sub.w   a0,d0 */
    sub.w a0,d0
/* QL:         lsr.w   #1,d0 */
    lsr.w #1,d0
/* QL:         mulu    d7,d0 */
    mulu d7,d0
/* QL:         swap    d7 */
    swap d7
/* QL:         add.w   d7,d0           calculate new lno */
    add.w d7,d0
/* QL:         swap    d7 */
    swap d7
/* QL: M50_lkput */
M50_lkput:
/* QL:         move.w  d0,0(a6,a1.l) */
    move.w d0,0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL:                ;M50_bv_linum done at start */
/* QL: M50_bvtab   dc.b    M50_bv_nxlin,M50_bv_cnlno,M50_bv_dalno,M50_bv_lsbef,M50_bv_lsbas,M50_bv_lsaft */
M50_bvtab:
M50_dc_anchor_1727:
.byte (M50_bv_nxlin)&255
.byte (M50_bv_cnlno)&255
.byte (M50_bv_dalno)&255
.byte (M50_bv_lsbef)&255
.byte (M50_bv_lsbas)&255
.byte (M50_bv_lsaft)&255
/* QL:         dc.b    M50_bv_edlin,M50_bv_lsfil,M50_bv_erlin,0 (M50_bv_wrlno already done) */
M50_dc_anchor_1735:
.byte (M50_bv_edlin)&255
.byte (M50_bv_lsfil)&255
.byte (M50_bv_erlin)&255
.byte (0)&255
/* QL: *       Note: only some of these used to be done... some are almost certainly */
/* QL: *       irrelevant... but adding dalno was really needed! */
/* QL:         end */
