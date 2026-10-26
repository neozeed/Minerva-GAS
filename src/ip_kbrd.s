/* ROM section ip_kbrd */
.balign 2,0
/* QL: * Main keyboard read routine. Can be called by replacement keyboard code. */
/* QL: * d1 -i  - keyrow data in 6 lsb */
/* QL: * d2 -i  - ctrl/shift/alt in 3 lsb */
/* QL: * a2 -ip - current keyboard queue address */
/* QL: * d0/d6/a0-a1/a3-a4 destroyed */
/* QL: ip_kbrd */
ip_kbrd:
/* QL:         clr.w   M22_sv_arbuf(a6)    get rid of previous auto repeat */
    clr.w M22_sv_arbuf(a6)
/* QL:         move.l  M22_sv_chtop(a6),a4 get sysvar extension */
    move.l M22_sv_chtop(a6),a4
/* QL:         move.l  M22_sx_kbenc(a4),a3 get encoder address */
    move.l M22_sx_kbenc(a4),a3
/* QL:         jsr     (a3)            call encoder via vector table */
    jsr (a3)
/* QL:         bra.s   M22_special         M22_special processing return */
    bra.s M22_special
/* QL:         bra.s   M22_kb_inch         put it into the queue */
    bra.s M22_kb_inch
/* QL:         rts                     ignore char return */
    rts 
/* QL: * Routine to finish off keyboard read and handle auto-repeat. */
/* QL: * d3 -ip - number of polls missed */
/* QL: * d5 -i  - bit 4 set if last key is held down */
/* QL: * a2 -ip - current keyboard queue */
/* QL: * d0-d2/a3 destroyed */
/* QL: ip_kbend */
ip_kbend:
/* QL:         asr.b   #4,d5           see if the key is still held down */
    asr.b #4,d5
/* QL:         bcc.s   M22_autorld         if not, reload the counter and get out */
    bcc.s M22_autorld
/* QL:         sub.w   d3,M22_sv_arcnt(a6) step counter by the number of polls */
    sub.w d3,M22_sv_arcnt(a6)
/* QL:         bgt.s   M22_rts0            if it hasn't timed out yet */
    bgt.s M22_rts0
/* QL:         jsr     io_qtest(pc)    is the queue empty? */
    jsr io_qtest(pc)
/* QL:         beq.s   M22_shortd          no, so don't allow autorepeat */
    beq.s M22_shortd
/* QL:         move.w  M22_sv_arbuf(a6),d1 retrieve char to be repeated */
    move.w M22_sv_arbuf(a6),d1
/* QL:         beq.s   M22_shortd          nothing */
    beq.s M22_shortd
/* QL:         bsr.s   M22_kb_inch         put it into the queue */
    bsr.s M22_kb_inch
/* QL: M22_shortd */
M22_shortd:
/* QL:         move.w  M22_sv_arfrq(a6),M22_sv_arcnt(a6) reload with the shorter delay */
    move.w M22_sv_arfrq(a6),M22_sv_arcnt(a6)
/* QL:         rts */
    rts 
/* QL: * Special processing routines */
/* QL: spent   macro   t */
/* QL: M22_sptab */
M22_sptab:
/* QL: *                       ctrl/space              event 4 = break job 0 */
/* QL: *                       ctrl/alt/space          event 5 = break multi */
/* QL: *                       shift/ctrl/space        event 6 = M22_user event 0 */
/* QL: *                       shift/ctrl/alt/space    event 7 = M22_user event 1 */
/* QL:         spent   M22_ctlt    ctrl/tab                alternate screen */
/* QL: [.lab]  dc.b    (([t])-M22_spend)&$7fffffff */
M22_dc_anchor_922:
.byte (((M22_ctlt-M22_spend)&0x7fffffff))&255
/* QL:         spent   M22_frez    ctrl/alt/tab            toggle display freeze */
/* QL: [.lab]  dc.b    (([t])-M22_spend)&$7fffffff */
M22_dc_anchor_926:
.byte (((M22_frez-M22_spend)&0x7fffffff))&255
/* QL:         spent   M22_rts0    shift/ctrl/tab          reserve... easy to key! */
/* QL: [.lab]  dc.b    (([t])-M22_spend)&$7fffffff */
M22_dc_anchor_930:
.byte (((M22_rts0-M22_spend)&0x7fffffff))&255
/* QL:         spent   M22_soft    shift/ctrl/alt/tab      M22_soft reset */
/* QL: [.lab]  dc.b    (([t])-M22_spend)&$7fffffff */
M22_dc_anchor_934:
.byte (((M22_soft-M22_spend)&0x7fffffff))&255
/* QL:         spent   M22_comp    ctrl/enter              compose */
/* QL: [.lab]  dc.b    (([t])-M22_spend)&$7fffffff */
M22_dc_anchor_938:
.byte (((M22_comp-M22_spend)&0x7fffffff))&255
/* QL:         spent   M22_ctlc    ctrl/alt/enter          cursor to next queue */
/* QL: [.lab]  dc.b    (([t])-M22_spend)&$7fffffff */
M22_dc_anchor_942:
.byte (((M22_ctlc-M22_spend)&0x7fffffff))&255
/* QL:         spent   M22_caps    shift/ctrl/enter        M22_caps lock */
/* QL: [.lab]  dc.b    (([t])-M22_spend)&$7fffffff */
M22_dc_anchor_946:
.byte (((M22_caps-M22_spend)&0x7fffffff))&255
/* QL:         spent   M22_user    shift/ctrl/alt/enter    call M22_user subroutine */
/* QL: [.lab]  dc.b    (([t])-M22_spend)&$7fffffff */
M22_dc_anchor_950:
.byte (((M22_user-M22_spend)&0x7fffffff))&255
/* QL: M22_special */
M22_special:
/* QL:         subq.b  #4,d1 */
    subq.b #4,d1
/* QL:         bpl.s   M22_usetab */
    bpl.s M22_usetab
/* QL:         bchg    d1,M22_sx_event(a4) */
    bchg d1,M22_sx_event(a4)
/* QL:         rts */
    rts 
/* QL: M22_usetab */
M22_usetab:
/* QL:         move.b  M22_sptab(pc,d1.w),d1 */
    move.b M22_sptab(pc,d1.w),d1
/* QL:         jmp     M22_spend(pc,d1.w) */
.word 0x4efb
.word 4096|((M22_spend-.)&255)
/* QL: * Put a char in the queue */
/* QL: M22_kb_inch */
M22_kb_inch:
/* QL:         cmp.w   M22_sv_cqch(a6),d1 */
    cmp.w M22_sv_cqch(a6),d1
/* QL:         beq.s   M22_ctlc */
    beq.s M22_ctlc
/* QL:         sf      M22_sv_scrst(a6)    unfreeze screen */
    sf M22_sv_scrst(a6)
/* QL:         move.w  d1,M22_sv_arbuf(a6) store char in the autorepeat buffer */
    move.w d1,M22_sv_arbuf(a6)
/* QL:         cmp.b   #255,d1         is it a two-byte code? */
    cmp.b #(255&255),d1
/* QL:         bne.s   M22_in1 */
    bne.s M22_in1
/* QL:         jsr     io_qtest(pc)    how many bytes are left? (nb only d1.b zapped) */
    jsr io_qtest(pc)
/* QL:         subq.w  #2,d2           are they enough? */
    subq.w #2,d2
/* QL:         blt.s   M22_autorld         no, don't put the character in */
    blt.s M22_autorld
/* QL:         st      d1              reset the alt code */
    st d1
/* QL:         bsr.s   M22_in1             put the escape in the queue */
    bsr.s M22_in1
/* QL:         lsr.w   #8,d1           get the second code */
    lsr.w #8,d1
/* QL: M22_in1 */
M22_in1:
/* QL:         jsr     io_qin(pc)      put it in the queue and return */
    jsr io_qin(pc)
/* QL: M22_autorld */
M22_autorld:
/* QL:         move.w  M22_sv_ardel(a6),M22_sv_arcnt(a6) reload the auto-rept counter */
    move.w M22_sv_ardel(a6),M22_sv_arcnt(a6)
/* QL:         rts */
    rts 
/* QL: M22_frez */
M22_frez:
/* QL:         not.b   M22_sv_scrst(a6)    toggle freeze flag */
    not.b M22_sv_scrst(a6)
/* QL: M22_rts0 */
M22_rts0:
/* QL:         rts */
    rts 
/* QL: M22_caps */
M22_caps:
/* QL:         not.b   M22_sv_caps(a6)     toggle M22_caps lock flag byte */
    not.b M22_sv_caps(a6)
/* QL:         lea     M22_sv_csub(a6),a4  get capslock M22_user routine address */
    lea M22_sv_csub(a6),a4
/* QL: M22_isprog */
M22_isprog:
/* QL:         tst.l   (a4)            is there some code there? */
    tst.l (a4)
/* QL:         beq.s   M22_rts0            no - not a good idea to call it... */
    beq.s M22_rts0
/* QL:         jmp     (a4)            yes, call it and get out */
    jmp (a4)
/* QL: * N.B. changed above to use a4 instead of a5, which wasn't saved! */
/* QL: M22_comp */
M22_comp:
/* QL:         addq.b  #1,M22_sv_ichar(a6) set compose start */
    addq.b #1,M22_sv_ichar(a6)
/* QL:         rts */
    rts 
/* QL: M22_user */
M22_user:
/* QL: M22_spend   equ     M22_user-31 */
.equ M22_spend,(M22_user-31)
/* QL:         assert  0,M22_sx_case */
/* original assertion: 0,M22_sx_case */
/* QL:         move.l  (a4),d0         get M22_user code routine address */
    move.l (a4),d0
/* QL:         bpl.s   M22_rts0            no flag (bit 31), so no call */
    bpl.s M22_rts0
/* QL:         bclr    d1,d0           don't let msb propagate into pc */
    bclr d1,d0
/* QL:         move.l  d0,a4           if it was set up the way we want (negative) ... */
    move.l d0,a4
/* QL:         bra.s   M22_isprog          ... check there's some code before calling it */
    bra.s M22_isprog
/* QL: M22_ctlt */
M22_ctlt:
/* QL:         bsr.s   ip_dspm         ensure M22_sx_dspm is up to date */
    bsr.s ip_dspm
/* QL:         bchg    #7,M22_sx_dspm(a4)  toggle displayed screen */
    bchg #7,M22_sx_dspm(a4)
/* QL:         move.b  M22_sx_dspm(a4),d0  pick up new value */
    move.b M22_sx_dspm(a4),d0
/* QL:         bmi.s   M22_ctlt1           top bit set, use screen 1 */
    bmi.s M22_ctlt1
/* QL:         add.b   d0,d0           shift for screen 0 */
    add.b d0,d0
/* QL: M22_ctlt1 */
M22_ctlt1:
/* QL:         and.b   #1<<M22_mc..blnk+1<<M22_mc..m256+1<<M22_mc..scrn,d0 */
    and.b #((((1<<M22_mc..blnk)+(1<<M22_mc..m256))+(1<<M22_mc..scrn))&255),d0
/* QL:         move.b  d0,M22_mc_stat      set hardware only */
    move.b d0,M22_mc_stat
/* QL:         rts */
    rts 
/* QL: M22_soft */
M22_soft:
/* QL:         moveq   #9,d1 */
    moveq #9,d1
/* QL:         jmp     390             M22_soft reset, quick */
    jmp 390
/* QL: M22_ctlc */
M22_ctlc:
/* QL:         move.l  a0,-(sp)        save a0 */
    move.l a0,-(sp)
/* QL:         lea     -M22_sd_end(a2),a0  find start of io definition block */
    lea (-M22_sd_end)(a2),a0
/* QL:         tst.b   M22_sd_curf(a0)     should cursor in old wdw be visible? */
    tst.b M22_sd_curf(a0)
/* QL:         bge.s   M22_switch_q */
    bge.s M22_switch_q
/* QL:         jsr     sd_cure(pc)     ensure cursor in old window is visible */
    jsr sd_cure(pc)
/* QL:         lea     M22_sd_end(a0),a2   restore a2 */
    lea M22_sd_end(a0),a2
/* QL: M22_switch_q */
M22_switch_q:
/* QL:         assert  M22_q_nextq,0 */
/* original assertion: M22_q_nextq,0 */
/* QL:         move.l  (a2),a2         switch to next queue */
    move.l (a2),a2
/* QL:         cmp.l   M22_sv_keyq(a6),a2  is this the original queue? */
    cmp.l M22_sv_keyq(a6),a2
/* QL:         beq.s   M22_end_swit */
    beq.s M22_end_swit
/* QL:         tst.b   M22_sd_curf-M22_sd_end(a2) is this cursor active? */
    tst.b (M22_sd_curf-M22_sd_end)(a2)
/* QL:         beq.s   M22_switch_q        no... */
    beq.s M22_switch_q
/* QL:         move.l  a2,M22_sv_keyq(a6)  set new key queue pointer */
    move.l a2,M22_sv_keyq(a6)
/* QL:         clr.w   M22_sv_fstat(a6)    reset cursor flash cycle */
    clr.w M22_sv_fstat(a6)
/* QL: M22_end_swit */
M22_end_swit:
/* QL:         move.l  M22_sd_scrb-M22_sd_end(a2),d1 have a look at the screen base here */
    move.l (M22_sd_scrb-M22_sd_end)(a2),d1
/* QL:         add.w   d1,d1           does it end with $0000 or $8000? */
    add.w d1,d1
/* QL:         bne.s   M22_offscr          no - forget it */
    bne.s M22_offscr
/* QL:         roxr.b  #1,d1 */
    roxr.b #1,d1
/* QL:         add.b   M22_sv_mcsta(a6),d1 are we already on the indicated screen? */
    add.b M22_sv_mcsta(a6),d1
/* QL:         bpl.s   M22_offscr          yes - forget it */
    bpl.s M22_offscr
/* QL:         swap    d1 */
    swap d1
/* QL:         subq.b  #2,d1           is it $xx020000 or $xx028000? */
    subq.b #2,d1
/* QL:         bne.s   M22_offscr          no - forget it */
    bne.s M22_offscr
/* QL:         bsr.s   M22_ctlt            switch over to that screen */
    bsr.s M22_ctlt
/* QL:         move.b  d0,M22_sv_mcsta(a6) and say that's what we're on */
    move.b d0,M22_sv_mcsta(a6)
/* QL: M22_offscr */
M22_offscr:
/* QL:         move.l  (sp)+,a0        restore a0 */
    move.l (sp)+,a0
/* QL:         rts */
    rts 
/* QL: * A routine to copy M22_sv_mcsta bits into M22_sx_dspm in case someone poked it! */
/* QL: * a4 -  o- sysvar extension base */
/* QL: * d0-d1 destroyed */
/* QL: ip_dspm */
ip_dspm:
/* QL:         moveq   #1<<M22_mc..blnk+1<<M22_mc..m256,d1 */
    moveq #((1<<M22_mc..blnk)+(1<<M22_mc..m256)),d1
/* QL:         move.b  M22_sv_mcsta(a6),d0 */
    move.b M22_sv_mcsta(a6),d0
/* QL:         bmi.s   M22_setscr1 */
    bmi.s M22_setscr1
/* QL:         lsr.b   #1,d0 */
    lsr.b #1,d0
/* QL:         moveq   #(1<<M22_mc..blnk+1<<M22_mc..m256)>>1,d1 */
    moveq #(((1<<M22_mc..blnk)+(1<<M22_mc..m256))>>1),d1
/* QL: M22_setscr1 */
M22_setscr1:
/* QL:         and.b   d1,d0 */
    and.b d1,d0
/* QL:         not.b   d1 */
    not.b d1
/* QL:         move.l  M22_sv_chtop(a6),a4 get sysvar extension */
    move.l M22_sv_chtop(a6),a4
/* QL:         and.b   d1,M22_sx_dspm(a4) */
    and.b d1,M22_sx_dspm(a4)
/* QL:         or.b    d0,M22_sx_dspm(a4) */
    or.b d0,M22_sx_dspm(a4)
/* QL:         rts */
    rts 
/* QL:         vect4000 ip_kbend,ip_kbrd */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ ip$kbend,(ip_kbend-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ ip$kbrd,(ip_kbrd-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
