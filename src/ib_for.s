/* ROM section ib_for */
.balign 2,0
/* QL: * a4 -i o- program file, positioned on input at token after REP/FOR */
/* QL: ib_rep */
ib_rep:
/* QL:         moveq   #M166_t.rep,d5 */
    moveq #M166_t.rep,d5
/* QL:         bra.s   M166_repfor */
    bra.s M166_repfor
/* QL: M166_err_bn */
M166_err_bn:
/* QL:         moveq   #M166_err.bn,d0      bad name (array or proc or something) */
    moveq #M166_err.bn,d0
/* QL:         rts */
    rts 
/* QL: ib_for */
ib_for:
/* QL:         moveq   #M166_t.for,d5 */
    moveq #M166_t.for,d5
/* QL:         move.l  a4,a5           save the position */
    move.l a4,a5
/* QL: M166_repfor */
M166_repfor:
/* QL:         jsr     ib_nxnon(pc)    get next non-space */
    jsr ib_nxnon(pc)
/* QL: *       cmp.b   #b.nam,d0       is it a name? (i don't see why? lwr) */
/* QL: *       bne.s   M166_err_bn          no, can't do it yet then */
/* QL:         move.w  2(a6,a4.l),d4   read row of name in name table */
    move.w 2(a6,a4.l),d4
/* QL:         addq.l  #4,a4 */
    addq.l #4,a4
/* QL:         jsr     ib_chinl(pc)    is this REP/FOR inline? */
    jsr ib_chinl(pc)
/* QL:         blt.s   M166_chtype          no */
    blt.s M166_chtype
/* QL:         move.b  #1,M166_bv_inlin(a6) yes, set flag */
    move.b #(1&255),M166_bv_inlin(a6)
/* QL:         move.w  d4,M166_bv_index(a6) (ought to check for absence of ef first) */
    move.w d4,M166_bv_index(a6)
/* QL: M166_chtype */
M166_chtype:
/* QL:         jsr     ib_fname(pc)    move to beginning of name */
    jsr ib_fname(pc)
/* QL:         clr.w   d2              clear first two bytes */
    clr.w d2
/* QL:         moveq   #0,d3           clear last four bytes */
    moveq #0,d3
/* QL:         move.b  0(a6,a2.l),d2   read type of name (1st byte of type word) */
    move.b 0(a6,a2.l),d2
/* QL:         beq.s   M166_alloc           unset variable, just zoom in there */
    beq.s M166_alloc
/* QL:         cmp.b   d2,d5           is it what we want already? */
    cmp.b d2,d5
/* QL:         beq.s   M166_sametype        yes, just right */
    beq.s M166_sametype
/* QL:         moveq   #M166_lp.lnfor,d1 */
    moveq #M166_lp.lnfor,d1
/* QL:         subq.b  #M166_t.for,d2       is it a FOR? */
    subq.b #M166_t.for,d2
/* QL:         beq.s   M166_freevar         yes, chuck it */
    beq.s M166_freevar
/* QL:         moveq   #M166_lp.lnrep,d1 */
    moveq #M166_lp.lnrep,d1
/* QL:         addq.b  #M166_t.for-M166_t.rep,d2 is it a REP? */
.word 20482|((((M166_t.for-M166_t.rep))&7)<<9)
/* QL:         beq.s   M166_freevar         yes, chuck it */
    beq.s M166_freevar
/* QL:         addq.b  #M166_t.rep-M166_t.var,d2 is it a simple variable? */
.word 20482|((((M166_t.rep-M166_t.var))&7)<<9)
/* QL:         bne.s   M166_err_bn          no, we don't like it! */
    bne.s M166_err_bn
/* QL:         moveq   #M166_lp.lnvar,d1    almost the right length */
    moveq #M166_lp.lnvar,d1
/* QL: M166_freevar */
M166_freevar:
/* QL:         move.l  4(a6,a2.l),d0   offset on VV area of index */
    move.l 4(a6,a2.l),d0
/* QL:         blt.s   M166_alloc           space not yet allocated */
    blt.s M166_alloc
/* QL:         move.l  M166_bv_vvbas(a6),a0 free current space, point at it */
    move.l M166_bv_vvbas(a6),a0
/* QL:         add.l   d0,a0 */
    add.l d0,a0
/* QL:         move.w  0(a6,a0.l),d2 */
    move.w 0(a6,a0.l),d2
/* QL:         move.l  2(a6,a0.l),d3 */
    move.l 2(a6,a0.l),d3
/* QL:         cmp.w   #M166_t.var<<8!M166_t.fp,0(a6,a2.l) is it a simple string? */
    cmp.w #((M166_t.var<<8)|M166_t.fp),0(a6,a2.l)
/* QL:         bcc.s   M166_freenow         no, go free it as is */
    bcc.s M166_freenow
/* QL:         move.w  d2,d1           get current length */
    move.w d2,d1
/* QL:         subq.l  #4,d1           is it a bit on the long side? */
    subq.l #4,d1
/* QL:         ble.s   M166_lenok           no - leave it */
    ble.s M166_lenok
/* QL:         sub.w   d1,d2           yes - truncate the save length to four */
    sub.w d1,d2
/* QL: * This truncation idea is a right pain! It really should count as an assignment */
/* QL: * to the variable, and cause when processing to happen. However, if you look at */
/* QL: * what's got to be done to implement that, you find it's pretty horrendous. */
/* QL: * Anyway, the only occasion where it crops up as a problem is when it's an */
/* QL: * exhausted FOR or a REP. The user will have to tolerate it, I think. */
/* QL: M166_lenok */
M166_lenok:
/* QL:         addq.l  #4+2,d1         this will round up right to free old string */
    addq.l #(4+2),d1
/* QL: M166_freenow */
M166_freenow:
/* QL:         jsr     bv_frvv(pc)     and free */
    jsr bv_frvv(pc)
/* QL: M166_alloc */
M166_alloc:
/* QL:         move.l  d5,d1 */
    move.l d5,d1
/* QL:         subq.b  #5,d1 */
    subq.b #5,d1
/* QL:         lsl.w   #3+1,d1 */
    lsl.w #(3+1),d1
/* QL:         assert  (M166_t.rep-5)<<1 (M166_lp.lnrep+7)>>3 */
/* original assertion: (M166_t.rep-5)<<1 (M166_lp.lnrep+7)>>3 */
/* QL:         assert  (M166_t.for-5)<<1 (M166_lp.lnfor+7)>>3 */
/* original assertion: (M166_t.for-5)<<1 (M166_lp.lnfor+7)>>3 */
/* QL:         jsr     bv_alvvz(pc)    find a hole to put index description in */
    jsr bv_alvvz(pc)
/* QL:         move.w  d2,0(a6,a0.l)   copy var. value to new position */
    move.w d2,0(a6,a0.l)
/* QL:         move.l  d3,2(a6,a0.l) */
    move.l d3,2(a6,a0.l)
/* QL:         sub.l   M166_bv_vvbas(a6),a0 get the offset */
    sub.l M166_bv_vvbas(a6),a0
/* QL:         move.b  d5,0(a6,a2.l)   set type to what we want */
    move.b d5,0(a6,a2.l)
/* QL:         move.l  a0,4(a6,a2.l)   update the vv offset in loop description */
    move.l a0,4(a6,a2.l)
/* QL: M166_sametype */
M166_sametype:
/* QL:         move.l  4(a6,a2.l),a2   get offset on vv table */
    move.l 4(a6,a2.l),a2
/* QL:         add.l   M166_bv_vvbas(a6),a2 add to base of vv */
    add.l M166_bv_vvbas(a6),a2
/* QL:         move.w  M166_bv_linum(a6),d1 read current line number */
    move.w M166_bv_linum(a6),d1
/* QL:         move.b  M166_bv_stmnt(a6),d0 also check the statement number on line */
    move.b M166_bv_stmnt(a6),d0
/* QL:         cmp.w   M166_lp.sl(a6,a2.l),d1 is it same as prev loop for this index? */
    cmp.w M166_lp.sl(a6,a2.l),d1
/* QL:         bne.s   M166_fill            no */
    bne.s M166_fill
/* QL:         cmp.b   M166_lp.ss(a6,a2.l),d0 */
    cmp.b M166_lp.ss(a6,a2.l),d0
/* QL:         beq.s   M166_nofill          scuse'me, don't change a thing */
    beq.s M166_nofill
/* QL: M166_fill */
M166_fill:
/* QL:         move.w  d1,M166_lp.sl(a6,a2.l) M166_fill in the line number */
    move.w d1,M166_lp.sl(a6,a2.l)
/* QL:         clr.l   M166_lp.el(a6,a2.l) blank the rest of the loop description */
    clr.l M166_lp.el(a6,a2.l)
/* QL:         move.b  d0,M166_lp.ss(a6,a2.l) except for which statement number */
    move.b d0,M166_lp.ss(a6,a2.l)
/* QL: M166_nofill */
M166_nofill:
/* QL:         subq.b  #M166_t.for,d5       are we doing a FOR? */
    subq.b #M166_t.for,d5
/* QL:         bne.s   M166_okrts           no - then that's all folks! */
    bne.s M166_okrts
/* QL:         jsr     ib_nxnon(pc)    get the = */
    jsr ib_nxnon(pc)
/* QL:         move.l  a4,d0           current pos */
    move.l a4,d0
/* QL:         sub.l   a5,d0           minus for pos = no of chars */
    sub.l a5,d0
/* QL:         move.w  d0,M166_lp.chpos(a6,a2.l) M166_fill in char pos at this moment */
    move.w d0,M166_lp.chpos(a6,a2.l)
/* QL:         jsr     ib_frnge(pc)    read the range */
    jsr ib_frnge(pc)
/* QL:         bgt.l   ib_fend         FOR line exhausted already, look for an END FOR */
    bgt.w ib_fend
/* QL:         blt.s   M166_rts1            in case we had a problem */
    blt.s M166_rts1
/* QL:         tst.w   M166_bv_wvnum(a6)    any when vars. that might be altered? */
    tst.w M166_bv_wvnum(a6)
/* QL:         bne.l   ib_wtest        yes - if satisfies when var. cond., act */
    bne.w ib_wtest
/* QL: M166_okrts */
M166_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M166_rts1 */
M166_rts1:
/* QL:         rts */
    rts 
/* QL:         end */
