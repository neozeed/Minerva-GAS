/* ROM section bv_chstk */
.balign 2,0
/* QL: * d0 -  o- 0 */
/* QL: * d1 -i  - space required (bv_ch??x only, others entries set standard values) */
/* QL: * d1-d2 destroyed. */
/* QL: * N.B. d3 is now preserved! */
/* QL: * (A pity, but d2 could be preserved except for silly callers, as above) */
/* QL: bv_chri */
bv_chri:
/* QL:         moveq   #10*6,d1        RI trig stuff needs a fair bit... (lwr) */
    moveq #(10*6),d1
/* QL: bv_chrix */
bv_chrix:
/* QL:         moveq   #M74_bv_rip,d2      arithmetic pointer */
    moveq #M74_bv_rip,d2
/* QL:         bra.s   M74_bv_down */
    bra.s M74_bv_down
/* QL: bv_chbt */
bv_chbt:
/* QL:         moveq   #3*4,d1         3 long words */
    moveq #(3*4),d1
/* QL: *bv_chbtx */
/* QL:         moveq   #M74_bv_btp,d2      backtrack pointer */
    moveq #M74_bv_btp,d2
/* QL:         bra.s   M74_bv_down */
    bra.s M74_bv_down
/* QL: *bv_chtg */
/* QL:         moveq   #4,d1           1 long word */
    moveq #4,d1
/* QL: *bv_chtgx */
/* QL:         moveq   #M74_bv_tgp,d2      temporary graph pointer */
    moveq #M74_bv_tgp,d2
/* QL:         bra.s   M74_bv_down */
    bra.s M74_bv_down
/* QL: bv_chnt */
bv_chnt:
/* QL:         moveq   #1+1+2+4,d1     two byte, a word and a longword */
    moveq #(((1+1)+2)+4),d1
/* QL: *bv_chntx */
/* QL:         moveq   #M74_bv_ntp,d2      name table */
    moveq #M74_bv_ntp,d2
/* QL:         bra.s   M74_bv_up */
    bra.s M74_bv_up
/* QL: bv_chrt */
bv_chrt:
/* QL:         moveq   #M74_rt.lentl,d1 */
    moveq #M74_rt.lentl,d1
/* QL:         moveq   #M74_bv_rtp,d2      M74_return stack */
    moveq #M74_bv_rtp,d2
/* QL:         bra.s   M74_bv_up */
    bra.s M74_bv_up
/* QL: bv_chbfx */
bv_chbfx:
/* QL:         moveq   #M74_bv_bfp,d2      basic buffer pointer */
    moveq #M74_bv_bfp,d2
/* QL:         bra.s   M74_bv_up */
    bra.s M74_bv_up
/* QL: bv_chtkx */
bv_chtkx:
/* QL:         moveq   #M74_bv_tkp,d2      token pointer */
    moveq #M74_bv_tkp,d2
/* QL:         bra.s   M74_bv_up */
    bra.s M74_bv_up
/* QL: bv_chnlx */
bv_chnlx:
/* QL:         moveq   #M74_bv_nlp,d2      name list pointer */
    moveq #M74_bv_nlp,d2
/* QL:         bra.s   M74_bv_up */
    bra.s M74_bv_up
/* QL: bv_chvvx */
bv_chvvx:
/* QL:         moveq   #M74_bv_vvp,d2      variable value pointer */
    moveq #M74_bv_vvp,d2
/* QL:         bra.s   M74_bv_up */
    bra.s M74_bv_up
/* QL: bv_chchx */
bv_chchx:
/* QL:         moveq   #M74_bv_chp,d2      channel table */
    moveq #M74_bv_chp,d2
/* QL:         bra.s   M74_bv_up */
    bra.s M74_bv_up
/* QL: bv_chlnx */
bv_chlnx:
/* QL:         moveq   #M74_bv_lnp,d2      line number table (identical code to bv_chbtp!) */
    moveq #M74_bv_lnp,d2
/* QL:         bra.s   M74_bv_up */
    bra.s M74_bv_up
/* QL: bv_chpfx */
bv_chpfx:
/* QL:         moveq   #M74_bv_pfp,d2      program file */
    moveq #M74_bv_pfp,d2
/* QL: M74_bv_up */
M74_bv_up:
/* QL:         addq.w  #4,d2           from now on, keep sensible value in d2 */
    addq.w #4,d2
/* QL: * Not a good idea to change the entry values for d2, as there are probably */
/* QL: * nasty people out there who jump in at bv_chrix+2, etc, with their own value! */
/* QL: M74_bv_down */
M74_bv_down:
/* QL:         add.l   -4(a6,d2.w),d1  add in previous pointer */
    add.l (-4)(a6,d2.w),d1
/* QL:         sub.l   0(a6,d2.w),d1   will the areas overlap? */
    sub.l 0(a6,d2.w),d1
/* QL:         bgt.s   M74_meeting         yes - we'll have to move it */
    bgt.s M74_meeting
/* QL: M74_retzero */
M74_retzero:
/* QL:         moveq   #0,d0           this was silly, but Qlib expected it! */
    moveq #0,d0
/* QL: M74_return */
M74_return:
/* QL:         rts */
    rts 
/* QL: * Sanitary, though odd looking, check on stack. No longer zaps a1. */
/* QL: bv_chss */
bv_chss:
/* QL:         moveq   #(M74_sssize-4-2-2)>>1,d1 leave out M74_return address and two words! */
    moveq #((((M74_sssize-4)-2)-2)>>1),d1
/* QL:         add.w   d1,d1           ( ... to be friendly to sb startup.) */
    add.w d1,d1
/* QL: * New entry point! needed when unvr tries to stack a command line! */
/* QL: bv_chssx */
bv_chssx:
/* QL:         add.l   M74_bv_ssp-4(a6),d1 intended offset to low address of stack */
    add.l (M74_bv_ssp-4)(a6),d1
/* QL:         add.l   d1,a6 */
    add.l d1,a6
/* QL:         cmp.l   a7,a6           enough room between sp and previous area? */
    cmp.l a7,a6
/* QL:         sub.l   d1,a6 */
    sub.l d1,a6
/* QL:         ble.s   M74_retzero         yes, so room is available */
    ble.s M74_retzero
/* QL:         subq.l  #8,sp           no enough space, 68020 compatible... */
    subq.l #8,sp
/* QL:         movem.l a6-a7,(sp)      ...take a snapshot of a6 and a7 */
    movem.l a6-a7,(sp)
/* QL:         moveq   #-6*4,d0        we may need to stack 7 regs and a M74_return */
    moveq #((-6)*4),d0
/* QL:         sub.l   (sp)+,d0 */
    sub.l (sp)+,d0
/* QL:         add.l   (sp)+,d0        offset to required base of stack */
    add.l (sp)+,d0
/* QL:         move.l  d0,M74_bv_ssp(a6)    */
    move.l d0,M74_bv_ssp(a6)
/* QL:         sub.l   d0,d1           this is the extra space we're after */
    sub.l d0,d1
/* QL: * Note: if d1 has become negative, it means the stack has overflowed! */
/* QL: * We don't need to take special notice of it here though, as the M74_albas call */
/* QL: * will fail, since it treats requests as unsigned. */
/* QL:         moveq   #M74_bv_ssp,d2      stack pointer offset */
    moveq #M74_bv_ssp,d2
/* QL: * OK. So we have to do some shuffling, but we'll give the requestor a bit extra */
/* QL: * space so they don't come back pestering us too often! */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -i  - extra space required */
/* QL: * d2 -i  - space is to be made between pointers at -4(a6,d2.w) and 0(a6,d2.w) */
/* QL: M74_meeting */
M74_meeting:
/* QL:         lsr.l   #M74_rbits,d1       discard odd bits */
    lsr.l #M74_rbits,d1
/* QL:         addq.l  #M74_headrm>>M74_rbits,d1 give headroom+1-1<<M74_rbits to headroom extra */
    addq.l #(M74_headrm>>M74_rbits),d1
/* QL:         lsl.l   #M74_rbits,d1       and round needed space */
    lsl.l #M74_rbits,d1
/* QL: * If we're gonna move things about, make sure we get value for money! */
/* QL:         movem.l d1-d3/a0-a3,-(sp) save local registers */
    movem.l d1-d3/a0-a3,-(sp)
/* QL:         lea     M74_getrela6,a2 */
    lea M74_getrela6(pc),a2
/* QL:         moveq   #M74_mt.extop,d0 */
    moveq #M74_mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         assert  6,M74_bv..int */
/* original assertion: 6,M74_bv..int */
/* QL:         add.b   d0,d0 */
    add.b d0,d0
/* QL:         bpl.s   bv_om           not an interpreter, so we die! */
    bpl.s bv_om
/* QL: * See if we can satisfy the request from the middle of the basic area */
/* QL: M74_chkfree */
M74_chkfree:
/* QL:         move.l  (sp),d1         get extra space requested */
    move.l (sp),d1
/* QL:         add.l   M74_bv_chang-4(a6),d1 add bottom of free space area */
    add.l (M74_bv_chang-4)(a6),d1
/* QL:         sub.l   M74_bv_chang(a6),d1 compare to top of free space */
    sub.l M74_bv_chang(a6),d1
/* QL:         ble.s   M74_midok           enough space there - go get it */
    ble.s M74_midok
/* QL: * Not enough space in middle. have to add a block to the top and move up */
/* QL: M74_albas */
M74_albas:
/* QL:         moveq   #M74_mt.albas,d0 */
    moveq #M74_mt.albas,d0
/* QL:         trap    #1              get the extra and move basic */
    trap #1
/* QL:         tst.l   d0              did we get our memory OK? */
    tst.l d0
/* QL:         bne.s   M74_outmem          no - report out of memory */
    bne.s M74_outmem
/* QL:         moveq   #M74_bv_chang,d2    it may be going to the middle */
    moveq #M74_bv_chang,d2
/* QL:         move.l  4(sp),d3        get the requested pointer */
    move.l 4(sp),d3
/* QL:         cmp.w   d2,d3           are we trying to add between top areas? */
    cmp.w d2,d3
/* QL:         ble.s   M74_uptop           no - that's straightforward now */
    ble.s M74_uptop
/* QL: * We've found new space from the system and need to put between upper areas */
/* QL:         move.l  d3,d2           transfer space to below requested upper area */
    move.l d3,d2
/* QL:         sub.l   d1,(sp)         remainder to be transferred from middle */
    sub.l d1,(sp)
/* QL: * ( This is likely to be negative, i.e. give some of the new space to middle ) */
/* QL: * ( There is also the (unlikely?) event that it might be zero! ) */
/* QL: M74_uptop */
M74_uptop:
/* QL:         moveq   #M74_bv_endpt+4,d3  space coming from top of basic area */
    moveq #(M74_bv_endpt+4),d3
/* QL:         bsr.s   M74_moveset         move up the stack, at least */
    bsr.s M74_moveset
/* QL: M74_midok */
M74_midok:
/* QL:         move.l  (sp)+,d1        get extra space required */
    move.l (sp)+,d1
/* QL:         move.l  (sp)+,d2        restore requested pointer */
    move.l (sp)+,d2
/* QL:         moveq   #M74_bv_chang,d3    middle pointer offset */
    moveq #M74_bv_chang,d3
/* QL:         bsr.s   M74_moveset */
    bsr.s M74_moveset
/* QL:         movem.l (sp)+,d3/a0-a3  restore all local registers */
    movem.l (sp)+,d3/a0-a3
/* QL: M74_retz2 */
M74_retz2:
/* QL:         bra.s   M74_retzero */
    bra.s M74_retzero
/* QL: * Hmmm.... someone has asked for space beyond the available, but they're not */
/* QL: * an interpreter! Only thing to do is kill them off. */
/* QL: bv_om */
bv_om:
/* QL:         moveq   #M74_err.om,d0      we were out of memory */
    moveq #M74_err.om,d0
/* QL:         jsr     ut_err0(pc)     try to write error message to chans 0/1 */
    jsr ut_err0(pc)
/* QL: bv_die */
bv_die:
/* QL:         move.l  d0,d3           tell any waiting jobs */
    move.l d0,d3
/* QL:         moveq   #-1,d1          commit suicide */
    moveq #(-1),d1
/* QL:         moveq   #M74_mt.frjob,d0 */
    moveq #M74_mt.frjob,d0
/* QL:         trap    #1 */
    trap #1
/* QL: * We ask the system for more memory, and it said "No!" ... boo hoo. */
/* QL: M74_outmem */
M74_outmem:
/* QL:         move.w  #M74_s.outm,M74_bv_stopn(a6) set the stop number */
    move.w #M74_s.outm,M74_bv_stopn(a6)
/* QL:         clr.b   M74_bv_cont(a6)     tell it to stop, and set zero ccr */
    clr.b M74_bv_cont(a6)
/* QL:         move.l  M74_bv_ssbas(a6),a0 top of basic wrt base of basic */
    move.l M74_bv_ssbas(a6),a0
/* QL:         sub.l   M74_bv_sssav(a6),a0 get to the saved position in start */
    sub.l M74_bv_sssav(a6),a0
/* QL:         lea     -4(a6,a0.l),sp  here is the M74_return, we hope */
    lea (-4)(a6,a0.l),sp
/* QL:         rts */
    rts 
/* QL: * Clear low areas for new, etc. Move the areas individually, for speed. */
/* QL: * The BF has been reset to minimal, and TK + PF are empty and at bfp. */
/* QL: * Upper stacks have been removed. */
/* QL: * d0 -  o- 0 */
/* QL: * d1-d3/a0-a2 destroyed */
/* QL: bv_new */
bv_new:
/* QL:         moveq   #M74_bv_ntbas,d3    move name table onwards down onto program file */
    moveq #M74_bv_ntbas,d3
/* QL:         bra.s   M74_clrlp */
    bra.s M74_clrlp
/* QL: * Clear and M74_return room for a clear, etc. VV onward are squashed down here. */
/* QL: * Upper stacks have been removed. */
/* QL: * d0 -  o- 0 */
/* QL: * d1-d3/a0-a2 destroyed */
/* QL: bv_clear */
bv_clear:
/* QL:         moveq   #M74_bv_vvbas,d3    move VV onwards down to butt into each other */
    moveq #M74_bv_vvbas,d3
/* QL: M74_clrlp */
M74_clrlp:
/* QL:         move.l  d3,-(sp) */
    move.l d3,-(sp)
/* QL:         bsr.s   M74_clrm */
    bsr.s M74_clrm
/* QL:         move.l  (sp)+,d3 */
    move.l (sp)+,d3
/* QL:         addq.l  #8,d3 */
    addq.l #8,d3
/* QL:         cmp.w   #M74_bv_chang,d3 */
    cmp.w #M74_bv_chang,d3
/* QL:         bne.s   M74_clrlp */
    bne.s M74_clrlp
/* QL: * There has to be some way of building the above into the main routine, but it */
/* QL: * all seems too complicated to me at the moment! */
/* QL: * Move top section of basic down and then try to release space to system */
/* QL:         moveq   #M74_bv_endpt+4,d2  current top of basic area */
    moveq #(M74_bv_endpt+4),d2
/* QL:         move.l  0(a6,d3.w),d1   get base of next area */
    move.l 0(a6,d3.w),d1
/* QL:         sub.l   -4(a6,d3.w),d1  less top of area gives its current free amount */
    sub.l (-4)(a6,d3.w),d1
/* QL:         and.w   #-512,d1        round space to a multiple of 512 (2^9) */
    and.w #(-512),d1
/* QL:         bsr.s   M74_moveset         move spare room in middle to top of basic */
    bsr.s M74_moveset
/* QL:         moveq   #M74_mt.rebas,d0    release space at top of basic area and move */
    moveq #M74_mt.rebas,d0
/* QL:         trap    #1              the whole shebang up. sp changed too. */
    trap #1
/* QL:         bra.s   M74_retz2           just to be nice, say d0=0 */
    bra.s M74_retz2
/* QL: * Clear top of rt stack, so ln can come down */
/* QL: * d1-d3/a0-a2 destroyed */
/* QL: bv_clrt */
bv_clrt:
/* QL:         moveq   #M74_bv_lnbas,d3 */
    moveq #M74_bv_lnbas,d3
/* QL: M74_clrm */
M74_clrm:
/* QL:         move.l  d3,d2 */
    move.l d3,d2
/* QL:         addq.l  #8,d2 */
    addq.l #8,d2
/* QL:         move.l  0(a6,d3.w),d1   get base of area being moved */
    move.l 0(a6,d3.w),d1
/* QL:         sub.l   -4(a6,d3.w),d1  less top of prior area gives free space */
    sub.l (-4)(a6,d3.w),d1
/* QL:         and.w   #-2,d1          make it even */
    and.w #(-2),d1
/* QL: * A routine to manage basic areas. */
/* QL: * The call sequence is kept as simple as possible to avoid having lots of */
/* QL: * complex code in the calling routines. */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -ip - even amount of space to transfer (positive or negative) */
/* QL: * d2 -i  - offset to between pointer pairs where d1 is to be added to the space */
/* QL: * d3 -i  - ditto, but where d1 is to be subtracted from the space */
/* QL: * a6 -ip - base of basic area */
/* QL: * a7 -i o- basic stack pointer (updated if need be) */
/* QL: * a0-a2 destroyed */
/* QL: movsav  reg     d1/d6-d7 */
/* QL: M74_moveset */
M74_moveset:
/* QL:         movem.l movsav,-(sp) */
    movem.l d1/d6-d7,-(sp)
/* QL:         lea     M74_moveop,a2       code to call */
    lea M74_moveop(pc),a2
/* QL:         moveq   #M74_mt.extop,d0    do it in supervisor mode */
    moveq #M74_mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         movem.l (sp)+,movsav */
    movem.l (sp)+,d1/d6-d7
/* QL:         rts */
    rts 
/* QL: M74_moveop */
M74_moveop:
/* QL:         cmp.w   d2,d3 */
    cmp.w d2,d3
/* QL:         bgt.s   M74_movdir */
    bgt.s M74_movdir
/* QL:         exg     d2,d3           turn it round, so we have: */
    exg d2,d3
/* QL:         neg.l   d1              amount by which to relocate pointers */
    neg.l d1
/* QL: M74_movdir */
M74_movdir:
/* QL:         moveq   #8,d6           pointer step */
    moveq #8,d6
/* QL:         move.l  d1,d7 */
    move.l d1,d7
/* QL:         beq.s   M74_movstp          if no actual movement, get out now! */
    beq.s M74_movstp
/* QL:         bmi.s   M74_movnxt */
    bmi.s M74_movnxt
/* QL:         exg     d2,d3           if up, we need to move upper areas first */
    exg d2,d3
/* QL:         neg.w   d6 */
    neg.w d6
/* QL:         add.w   d6,d3           remember to stop in the right place */
    add.w d6,d3
/* QL:         bra.s   M74_movadd */
    bra.s M74_movadd
/* QL: M74_movptr */
M74_movptr:
/* QL:         lea     4(a6,d2.w),a1   pointer pair to operate on */
    lea 4(a6,d2.w),a1
/* QL:         add.l   d7,(a1)         relocate high pointer */
    add.l d7,(a1)
/* QL:         move.l  (a1),d1         get its new value */
    move.l (a1),d1
/* QL:         add.l   d7,-(a1)        relocate low pointer */
    add.l d7,-(a1)
/* QL:         move.l  (a1),a0         get its new value */
    move.l (a1),a0
/* QL:         cmp.w   #M74_bv_vvbas,d2    are we moving the VV area ... */
    cmp.w #M74_bv_vvbas,d2
/* QL:         bne.s   M74_isss */
    bne.s M74_isss
/* QL:         tst.l   M74_bv_vvfre(a6)    ... and does it have any free space set? */
    tst.l M74_bv_vvfre(a6)
/* QL:         beq.s   M74_ssok */
    beq.s M74_ssok
/* QL:         add.l   d7,M74_bv_vvfre(a6) yes, add movement to base free space ptr */
    add.l d7,M74_bv_vvfre(a6)
/* QL: M74_isss */
M74_isss:
/* QL:         cmp.w   #M74_bv_ssp,d2      are we moving the SS area? */
    cmp.w #M74_bv_ssp,d2
/* QL:         bne.s   M74_ssok */
    bne.s M74_ssok
/* QL:         move    usp,a0          yes - get the real SS pointer */
    move usp,a0
/* QL:         add.l   d7,a0           relocate it */
    add.l d7,a0
/* QL:         move    a0,usp          and save it */
    move a0,usp
/* QL:         sub.l   a6,a0           make it relative for a moment */
    sub.l a6,a0
/* QL: * There is a query here... should this try to record the new M74_bv_ssp(a6) value? */
/* QL: * All it essentially needs is: */
/* QL: *       move.l  a0,(a1)         set exact ssp value */
/* QL: * However, we get out quick when the movement is zero, and it would miss this. */
/* QL: M74_ssok */
M74_ssok:
/* QL:         sub.l   a0,d1           overall size of area */
    sub.l a0,d1
/* QL:         add.l   a6,a0           make new base absolute */
    add.l a6,a0
/* QL:         move.l  a0,a1 */
    move.l a0,a1
/* QL:         sub.l   d7,a1           form old absolute base */
    sub.l d7,a1
/* QL:         jsr     mm_move(pc) */
    jsr mm_move(pc)
/* QL: M74_movadd */
M74_movadd:
/* QL:         add.w   d6,d2 */
    add.w d6,d2
/* QL: M74_movnxt */
M74_movnxt:
/* QL:         cmp.w   d2,d3 */
    cmp.w d2,d3
/* QL:         bne.s   M74_movptr */
    bne.s M74_movptr
/* QL: M74_movstp */
M74_movstp:
/* QL:         rte */
    rte 
/* QL: * Called in supervisor mode to get M74_jb_rela6 flag byte */
/* QL: M74_getrela6 */
M74_getrela6:
/* QL:         move.l  d0,a2 */
    move.l d0,a2
/* QL:         move.l  M74_sv_jbpnt(a2),a2 */
    move.l M74_sv_jbpnt(a2),a2
/* QL:         move.l  (a2),a2 */
    move.l (a2),a2
/* QL:         move.b  M74_jb_rela6(a2),d0 hang on... what am I? ... */
    move.b M74_jb_rela6(a2),d0
/* QL:         rte */
    rte 
/* QL:         end */
