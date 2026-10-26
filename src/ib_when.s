/* ROM section ib_when */
.balign 2,0
/* QL: * Process WHEN keyword. */
/* QL: * "WHEN ERRor" sets up error trapping. */
/* QL: * "WHEN name{(<range>)...}=<expr>" sets up entry for name. */
/* QL: * "WHEN name" clears all entries for name. */
/* QL: * "WHEN anything" as an immediate command clears all when processing. */
/* QL: * Find and unset all whens on this var */
/* QL: M146_uns_one */
M146_uns_one:
/* QL:         st      M146_wv.row(a6,a2.l) found one, unset it */
    st M146_wv.row(a6,a2.l)
/* QL:         subq.w  #1,M146_bv_wvnum(a6) and decrement count */
    subq.w #1,M146_bv_wvnum(a6)
/* QL: M146_find_uns */
M146_find_uns:
/* QL:         moveq   #1,d3 */
    moveq #1,d3
/* QL:         jsr     ib_wscan(pc) */
    jsr ib_wscan(pc)
/* QL:         beq.s   M146_uns_one */
    beq.s M146_uns_one
/* QL:         bra.s   M146_okrts           none left */
    bra.s M146_okrts
/* QL: ib_when */
ib_when:
/* QL:         tst.w   M146_bv_linum(a6)    is this an immediate command? */
    tst.w M146_bv_linum(a6)
/* QL:         bne.s   M146_inprog          no, so do complex activities */
    bne.s M146_inprog
/* QL:         tst.b   M146_bv_wvbas(a6)    is there a when vv area? */
    tst.b M146_bv_wvbas(a6)
/* QL:         bmi.s   M146_whkill          no, so don't try to release it */
    bmi.s M146_whkill
/* QL:         move.l  M146_bv_wvbas(a6),a0 addr. of when area rel. to vvbas */
    move.l M146_bv_wvbas(a6),a0
/* QL:         add.l   M146_bv_vvbas(a6),a0 made a6 rel. */
    add.l M146_bv_vvbas(a6),a0
/* QL:         move.l  0(a6,a0.l),d1   size of when area */
    move.l 0(a6,a0.l),d1
/* QL:         jsr     bv_frvv(pc)     free area */
    jsr bv_frvv(pc)
/* QL: ib_whzap */
ib_whzap:
/* QL:         st      M146_bv_wvbas(a6)    mark as gone */
    st M146_bv_wvbas(a6)
/* QL: M146_whkill */
M146_whkill:
/* QL:         clr.w   M146_bv_wrlno(a6)    immediate, so switch when error off */
    clr.w M146_bv_wrlno(a6)
/* QL:         clr.w   M146_bv_wvnum(a6)    and switch off when variable */
    clr.w M146_bv_wvnum(a6)
/* QL:         bra.s   M146_okrts */
    bra.s M146_okrts
/* QL: M146_inprog */
M146_inprog:
/* QL:         jsr     ib_nxnon(pc)    what sort of when is this? */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   #M146_w.err,d1       when error? */
    cmp.w #M146_w.err,d1
/* QL:         bne.s   M146_becomes */
    bne.s M146_becomes
/* QL:         move.w  M146_bv_linum(a6),M146_bv_wrlno(a6) save line number */
    move.w M146_bv_linum(a6),M146_bv_wrlno(a6)
/* QL:         move.b  M146_bv_stmnt(a6),M146_bv_wrstm(a6) and statement */
    move.b M146_bv_stmnt(a6),M146_bv_wrstm(a6)
/* QL:         jsr     ib_chinl(pc)    is this inline? */
    jsr ib_chinl(pc)
/* QL:         seq     M146_bv_wrinl(a6)    if so, set flag */
    seq M146_bv_wrinl(a6)
/* QL:         beq.s   M146_nxst */
    beq.s M146_nxst
/* QL: M146_findend */
M146_findend:
/* QL:         moveq   #M146_b.when,d2      look for an "end when" */
    moveq #M146_b.when,d2
/* QL:         jmp     ib_def1(pc) */
    jmp ib_def1(pc)
/* QL: M146_colon */
M146_colon:
/* QL:         addq.l  #2,a4 */
    addq.l #2,a4
/* QL: M146_nxst */
M146_nxst:
/* QL:         jsr     ib_eos(pc)      get end of this statement */
    jsr ib_eos(pc)
/* QL:         bge.s   M146_colon           M146_colon, keep going */
    bge.s M146_colon
/* QL: M146_okrts */
M146_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M146_becomes */
M146_becomes:
/* QL:         move.w  2(a6,a4.l),d4   get row number */
    move.w 2(a6,a4.l),d4
/* QL:         jsr     ib_s4non(pc)    advance pf and get next */
    jsr ib_s4non(pc)
/* QL:         cmp.w   #M146_w.opar,d1      is next an open parenthesis? */
    cmp.w #M146_w.opar,d1
/* QL:         beq.s   M146_find_set        yes, we now allow subscripted arrays */
    beq.s M146_find_set
/* QL:         cmp.b   #M146_b.ops,d0       is next thing on line an operator? */
    cmp.b #(M146_b.ops&255),d0
/* QL:         bne.s   M146_find_uns        no, that's all we expected, so go scrap this */
    bne.s M146_find_uns
/* QL: M146_find_set */
M146_find_set:
/* QL:         moveq   #1,d3           have we been here before? */
    moveq #1,d3
/* QL:         jsr     ib_wscan(pc) */
    jsr ib_wscan(pc)
/* QL: M146_tst_lno */
M146_tst_lno:
/* QL:         bne.s   M146_empty_s         no, have to make an entry */
    bne.s M146_empty_s
/* QL:         move.w  M146_bv_linum(a6),d0 */
    move.w M146_bv_linum(a6),d0
/* QL:         cmp.w   M146_wv.wlno(a6,a2.l),d0 got match on variable, lnos match too? */
    cmp.w M146_wv.wlno(a6,a2.l),d0
/* QL:         beq.s   M146_set_up          yes, replace this entry */
    beq.s M146_set_up
/* QL:         jsr     ib_wscnx(pc)    no, is there another one? */
    jsr ib_wscnx(pc)
/* QL:         bra.s   M146_tst_lno */
    bra.s M146_tst_lno
/* QL: M146_empty_s */
M146_empty_s:
/* QL:         moveq   #0,d3           find an empty slot */
    moveq #0,d3
/* QL:         jsr     ib_wscan(pc) */
    jsr ib_wscan(pc)
/* QL:         addq.w  #1,M146_bv_wvnum(a6) and fill it */
    addq.w #1,M146_bv_wvnum(a6)
/* QL: M146_set_up */
M146_set_up:
/* QL:         move.w  d4,M146_wv.row(a6,a2.l) set row number */
    move.w d4,M146_wv.row(a6,a2.l)
/* QL:         move.w  M146_bv_linum(a6),M146_wv.wlno(a6,a2.l) line number */
    move.w M146_bv_linum(a6),M146_wv.wlno(a6,a2.l)
/* QL:         move.b  M146_bv_stmnt(a6),M146_wv.wstm(a6,a2.l) statement on line */
    move.b M146_bv_stmnt(a6),M146_wv.wstm(a6,a2.l)
/* QL:         moveq   #127,d0         default endstatement */
    moveq #127,d0
/* QL:         bsr.s   M146_setew           fill in default ew entries */
    bsr.s M146_setew
/* QL:         assert  M146_wv.rtstm,M146_wv.rtinl-1,M146_wv.rtind-2 */
/* original assertion: M146_wv.rtstm,M146_wv.rtinl-1,M146_wv.rtind-2 */
/* QL:         move.l  d0,M146_wv.rtstm(a6,a2.l) clear return status */
    move.l d0,M146_wv.rtstm(a6,a2.l)
/* QL:         st      M146_wv.rtlno(a6,a2.l) mark as not in use */
    st M146_wv.rtlno(a6,a2.l)
/* QL:         jsr     ib_chinl(pc)    is this an inline? */
    jsr ib_chinl(pc)
/* QL:         seq     M146_wv.inlin(a6,a2.l) set if so */
    seq M146_wv.inlin(a6,a2.l)
/* QL:         beq.s   M146_nxst            and find end of line to continue from */
    beq.s M146_nxst
/* QL:         bsr.s   M146_findend         otherwise, scull on to "end when" */
    bsr.s M146_findend
/* QL:         move.b  M146_bv_stmnt(a6),d0 */
    move.b M146_bv_stmnt(a6),d0
/* QL: M146_setew */
M146_setew:
/* QL:         move.b  d0,M146_wv.ewstm(a6,a2.l) */
    move.b d0,M146_wv.ewstm(a6,a2.l)
/* QL:         move.w  M146_bv_linum(a6),M146_wv.ewlno(a6,a2.l) fill in the position */
    move.w M146_bv_linum(a6),M146_wv.ewlno(a6,a2.l)
/* QL:         bra.s   M146_okrts */
    bra.s M146_okrts
/* QL: * Checks and adjustments for changes in line numbers in when area. */
/* QL: * Three instances crop up: */
/* QL: * 1) A line range has been deleted. We cannot keep any when entry which is */
/* QL: *       currently referencing these line, so they get discarded. */
/* QL: * 2) A line has been editted. As we can no longer trust it to be valid, we must */
/* QL: *       get rid of references as if the line had been deleted. */
/* QL: * 3) A renumber has occurred. All references just need to be adjusted. Their */
/* QL: *       contents have not altered, so entries are kept.  */
/* QL: * (This all used to be done with some horrible flags, etc. Turning the renum */
/* QL: * process around so that this calls the code back there made life much easier!) */
/* QL: * Zap when entries for a line range (cases 1 & 2 above) */
/* QL: * d2 -ip - first line number in delete range, or editted line number */
/* QL: * d6 -ip - last line in delete range, or repeat of editted line number */
/* QL: * d0/a2 destroyed */
/* QL: ib_whdel */
ib_whdel:
/* QL:         movem.l d1/d4/d6/a1/a5,-(sp) */
    movem.l d1/d4/d6/a1/a5,-(sp)
/* QL:         lea     M146_eddel,a2 */
    lea M146_eddel(pc),a2
/* QL:         sub.w   d2,d6 */
    sub.w d2,d6
/* QL:         bsr.s   ib_whrnm */
    bsr.s ib_whrnm
/* QL:         movem.l (sp)+,d1/d4/d6/a1/a5 */
    movem.l (sp)+,d1/d4/d6/a1/a5
/* QL:         rts */
    rts 
/* QL: M146_eddel */
M146_eddel:
/* QL:         move.w  0(a6,a1.l),d0 */
    move.w 0(a6,a1.l),d0
/* QL:         sub.w   d2,d0 */
    sub.w d2,d0
/* QL:         cmp.w   d6,d0 */
    cmp.w d6,d0
/* QL:         bhi.s   M146_rts1 */
    bhi.s M146_rts1
/* QL:         addq.l  #4,sp           discard return */
    addq.l #4,sp
/* QL: M146_delpos */
M146_delpos:
/* QL:         st      M146_wv.row+4(a6,a5.l) switch off when entry */
    st (M146_wv.row+4)(a6,a5.l)
/* QL:         subq.w  #1,M146_bv_wvnum(a6) and decrement no. of when vars. */
    subq.w #1,M146_bv_wvnum(a6)
/* QL:         bra.s   M146_nextpos */
    bra.s M146_nextpos
/* QL: * Scan when entries, executing code on each line number reference. */
/* QL: * See renum for details on register usage here */
/* QL: ib_whrnm */
ib_whrnm:
/* QL:         lea     M146_bv_wrlno,a1 */
    lea M146_bv_wrlno,a1
/* QL:         jsr     (a2)            renumber when error */
    jsr (a2)
/* QL: M146_whvar */
M146_whvar:
/* QL:         tst.w   M146_bv_wvnum(a6)    are there any when var. conds. set? */
    tst.w M146_bv_wvnum(a6)
/* QL:         beq.s   M146_rts1            no, so give up quickly */
    beq.s M146_rts1
/* QL: M146_whmods */
M146_whmods:
/* QL:         move.l  M146_bv_wvbas(a6),a5 */
    move.l M146_bv_wvbas(a6),a5
/* QL:         add.l   M146_bv_vvbas(a6),a5 a6 rel. addr. of when var. area */
    add.l M146_bv_vvbas(a6),a5
/* QL:         move.l  0(a6,a5.l),d4   length of when space in bytes */
    move.l 0(a6,a5.l),d4
/* QL:         lsr.l   #4,d4           hence no. of entries +1 */
    lsr.l #4,d4
/* QL:         subq.w  #2,d4           handy loop count */
    subq.w #2,d4
/* QL: M146_del_lop */
M146_del_lop:
/* QL:         tst.w   M146_wv.row+4(a6,a5.l) is this entry being used? */
    tst.w (M146_wv.row+4)(a6,a5.l)
/* QL:         bmi.s   M146_nextpos         no, so look at next one */
    bmi.s M146_nextpos
/* QL:         lea     M146_wv.wlno+4(a5),a1 set pointer for check operation */
    lea (M146_wv.wlno+4)(a5),a1
/* QL:         jsr     (a2)            perform operation on when lno (edit/renum) */
    jsr (a2)
/* QL:         addq.l  #M146_wv.ewlno-M146_wv.wlno,a1 */
.word 20617|((((M146_wv.ewlno-M146_wv.wlno))&7)<<9)
/* QL:         jsr     (a2)            perform operation on end when lno (edit/renum) */
    jsr (a2)
/* QL:         addq.l  #M146_wv.rtlno-M146_wv.ewlno,a1 */
.word 20617|((((M146_wv.rtlno-M146_wv.ewlno))&7)<<9)
/* QL:         jsr     (a2)            perform operation on return lno (edit/renum) */
    jsr (a2)
/* QL: M146_nextpos */
M146_nextpos:
/* QL:         add.w   #M146_wv.len,a5      move to next when table entry */
    add.w #M146_wv.len,a5
/* QL:         dbra    d4,M146_del_lop */
    dbra d4,M146_del_lop
/* QL: M146_rts1 */
M146_rts1:
/* QL:         rts */
    rts 
/* QL:         end */
