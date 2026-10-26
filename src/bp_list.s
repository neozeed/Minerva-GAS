/* ROM section bp_list */
.balign 2,0
/* QL: * Gets separator type from name table. */
/* QL: bp_gsep */
bp_gsep:
/* QL:         addq.l  #8,a3           advance over argument */
    addq.l #8,a3
/* QL:         move.b  -7(a6,a3.l),d5  get vt and st */
    move.b (-7)(a6,a3.l),d5
/* QL:         lsr.b   #4,d5           separator only */
    lsr.b #4,d5
/* QL:         and.b   #15,-7(a6,a3.l) wipe it out of argument and set z if no arg */
    and.b #(15&255),(-7)(a6,a3.l)
/* QL: M51_rts0 */
M51_rts0:
/* QL:         rts */
    rts 
/* QL: * Basic DLINE. Uses a lot of routines shared with LIST. */
/* QL: * a3 -i  - base of args */
/* QL: * a5 -i  - M51_top of args */
/* QL: * d0-d7/a0-a1/a3-a4 destroyed */
/* QL: * d4 lower line to write */
/* QL: * d5 separator type */
/* QL: * d6 upper line to write */
/* QL: * a0 where to write to */
/* QL: * a2 keyword table */
/* QL: * a4 program file */
/* QL: bp_dline */
bp_dline:
/* QL:         cmp.l   a5,a3 */
    cmp.l a5,a3
/* QL:         beq.s   M51_rts0            refuse to consider no args as delete all! */
    beq.s M51_rts0
/* QL:         st      d7              tell rest of prog we're deleting */
    st d7
/* QL: * Implements basic keyword LIST */
/* QL: * a0 - l - where to write to */
/* QL: * a2 - l - keyword table */
/* QL: * a3 -i  - base of args */
/* QL: * a4 - l - program file */
/* QL: * a5 -i o- M51_top of args */
/* QL: * d4 - l - lower line to write */
/* QL: * d5 - l - separator type */
/* QL: * d6 - l - upper line to write */
/* QL: bp_list */
bp_list:
/* QL:         moveq   #M51_c.defls,d1     if no # given, use 2 */
    moveq #M51_c.defls,d1
/* QL:         jsr     bp_chand(pc) */
    jsr bp_chand(pc)
/* QL:         bne.s   M51_rts0 */
    bne.s M51_rts0
/* QL: * Lists a program like bp_list except that it does not set or M51_check the output */
/* QL: * channel - it is used to list to devices. E.g. in SAVE. */
/* QL: * a0 - l - where to write to */
/* QL: * a2 - l - keyword table */
/* QL: * a3 -i  - base of args */
/* QL: * a4 - l - program file */
/* QL: * a5 -i  - M51_top of args */
/* QL: * d4 - l - lower line to write */
/* QL: * d5 - l - separator type */
/* QL: * d6 - l - upper line to write */
/* QL: bp_listd */
bp_listd:
/* QL:         tst.b   d7 */
    tst.b d7
/* QL:         beq.s   M51_notdel */
    beq.s M51_notdel
/* QL:         jsr     bp_chunr(pc)    never get caught by delete via list entry point */
    jsr bp_chunr(pc)
/* QL: M51_notdel */
M51_notdel:
/* QL:         moveq   #0,d4           default from start of program */
    moveq #0,d4
/* QL:         move.w  d4,M51_bv_lsfil(a6) turn fill screen flag off */
    move.w d4,M51_bv_lsfil(a6)
/* QL:         st      M51_bv_print(a6)    turn print flag on for list, save */
    st M51_bv_print(a6)
/* QL:         sub.l   a3,a5 */
    sub.l a3,a5
/* QL:         move.l  a5,-(sp)        keep number of bytes of args on M51_top of stack */
    move.l a5,-(sp)
/* QL:         ble.s   M51_set_hi          no args at all - this will list all */
    ble.s M51_set_hi
/* QL: M51_get_rng */
M51_get_rng:
/* QL:         moveq   #0,d1           default start from zero */
    moveq #0,d1
/* QL:         subq.l  #8,(sp)         one less arg remaining */
    subq.l #8,(sp)
/* QL:         bsr.s   bp_gsep         gets separator and checks for an argument */
    bsr.s bp_gsep
/* QL:         beq.s   M51_set_fst         no arg, d1 is ready */
    beq.s M51_set_fst
/* QL:         bsr.s   bp_gint */
    bsr.s bp_gint
/* QL:         bne.s   M51_popret */
    bne.s M51_popret
/* QL: M51_set_fst */
M51_set_fst:
/* QL:         move.w  d1,d4           first line, and also default last */
    move.w d1,d4
/* QL:         cmp.b   #M51_b.septo,d5     is this a range? */
    cmp.b #(M51_b.septo&255),d5
/* QL:         bne.s   M51_set_lst         no - go M51_check end of range */
    bne.s M51_set_lst
/* QL:         tst.l   (sp)            any args left? */
    tst.l (sp)
/* QL:         ble.s   M51_set_hi          no - default to end of program */
    ble.s M51_set_hi
/* QL:         subq.l  #8,(sp)         one less arg remaining */
    subq.l #8,(sp)
/* QL:         bsr.s   bp_gsep         get new sep and M51_check for arg */
    bsr.s bp_gsep
/* QL:         beq.s   M51_set_hi          if none, go set highest */
    beq.s M51_set_hi
/* QL:         bsr.s   bp_gint         get last line number to list */
    bsr.s bp_gint
/* QL:         bne.s   M51_popret */
    bne.s M51_popret
/* QL: M51_set_lst */
M51_set_lst:
/* QL:         move.w  d1,d6           M51_check last */
    move.w d1,d6
/* QL:         bne.s   M51_lstrdy          ok if it's not zero */
    bne.s M51_lstrdy
/* QL:         tst.b   d7              do not want to delete the whole file */
    tst.b d7
/* QL:         bne.s   M51_skip_it         unless they tell us properly */
    bne.s M51_skip_it
/* QL: M51_set_hi */
M51_set_hi:
/* QL:         move.w  #32767,d6       highest possible line number */
    move.w #32767,d6
/* QL: M51_lstrdy */
M51_lstrdy:
/* QL:         cmp.w   d4,d6           M51_check first line not greater than last */
    cmp.w d4,d6
/* QL:         blo.s   M51_skip_it         ignore reversed ranges (used to show as error) */
    blo.s M51_skip_it
/* QL:         tst.b   d7 */
    tst.b d7
/* QL:         beq.s   M51_goliste         if list, go do it straight away */
    beq.s M51_goliste
/* QL:         cmp.w   M51_bv_lsbef(a6),d6 */
    cmp.w M51_bv_lsbef(a6),d6
/* QL:         bls.s   M51_goliste         range wholely before screen */
    bls.s M51_goliste
/* QL:         cmp.w   M51_bv_lsaft(a6),d4 */
    cmp.w M51_bv_lsaft(a6),d4
/* QL:         bhs.s   M51_goliste         range wholely after screen */
    bhs.s M51_goliste
/* QL:         ext.w   d7              remember we've affected the screen, if a delete */
    ext.w d7
/* QL: M51_goliste */
M51_goliste:
/* QL:         sub.l   M51_bv_ntp(a6),a3   gotta protect this against basic buffer shifts! */
    sub.l M51_bv_ntp(a6),a3
/* QL:         bsr.l   bp_liste        actually do the listing/deleting! */
    bsr.w bp_liste
/* QL:         add.l   M51_bv_ntp(a6),a3 */
    add.l M51_bv_ntp(a6),a3
/* QL: M51_skip_it */
M51_skip_it:
/* QL:         move.l  (sp),d2         have we run out of arguments? */
    move.l (sp),d2
/* QL:         ble.s   M51_end_rng         yes, we're all done */
    ble.s M51_end_rng
/* QL:         subq.b  #M51_b.sepcom,d5    was sep a comma? */
    subq.b #M51_b.sepcom,d5
/* QL:         beq.s   M51_get_rng         yes, go do next range, otherwise it's an error */
    beq.s M51_get_rng
/* QL: M51_badret */
M51_badret:
/* QL:         moveq   #M51_err.bp,d0 */
    moveq #M51_err.bp,d0
/* QL:         bra.s   M51_popret */
    bra.s M51_popret
/* QL: M51_end_rng */
M51_end_rng:
/* QL:         move.w  d7,d3           if this dline affected the screen we M51_relist */
    move.w d7,d3
/* QL:         bpl.s   M51_okpop */
    bpl.s M51_okpop
/* QL:         bsr.l   bp_chkls        ah! but is this really the list channel? */
    bsr.w bp_chkls
/* QL:         bne.s   M51_okpop           no - so forget it! (e.g. DLINE#0 for no M51_relist) */
    bne.s M51_okpop
/* QL:         bsr.s   M51_relist          list from M51_top (d2.w=0), deleted range (d3.b<0) */
    bsr.s M51_relist
/* QL: M51_okpop */
M51_okpop:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M51_popret */
M51_popret:
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: * Gets a positive integer on the ri stack from the argument pointed */
/* QL: * to by a3 and a5, converting from f.p. if necessary. */
/* QL: * d0 -  o- error return */
/* QL: * d1 -  o- (.w) 1..32767 result, if all ok */
/* QL: * a1 -  o- ri stack M51_top where d1 was, M51_bv_rip updated past it */
/* QL: * a3 -ip - nt M51_top */
/* QL: * a5 -  o- copy of a3 */
/* QL: * d2/a4 destroyed */
/* QL: bp_gint */
bp_gint:
/* QL:         move.l  a3,a5 */
    move.l a3,a5
/* QL:         jsr     ca_etos(pc)     get it on M51_top of stack */
    jsr ca_etos(pc)
/* QL:         bne.s   M51_rts2 */
    bne.s M51_rts2
/* QL:         moveq   #M51_t.int,d0 */
    moveq #M51_t.int,d0
/* QL:         jsr     ca_cnvrt(pc)    turn it into an integer */
    jsr ca_cnvrt(pc)
/* QL:         bne.s   M51_rts2 */
    bne.s M51_rts2
/* QL:         addq.l  #2,M51_bv_rip(a6) */
    addq.l #2,M51_bv_rip(a6)
/* QL:         move.w  0(a6,a1.l),d1   have the idiots put in a zero or negative no? */
    move.w 0(a6,a1.l),d1
/* QL:         bgt.s   M51_tstrts */
    bgt.s M51_tstrts
/* QL:         moveq   #M51_err.bp,d0 */
    moveq #M51_err.bp,d0
/* QL: M51_tstrts */
M51_tstrts:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: M51_rts2 */
M51_rts2:
/* QL:         rts */
    rts 
/* QL: * Note: there does not seem to be any great attempt to leave registers */
/* QL: * in any predictable state on return. May be able to do optimisation... */
/* QL: * Relist the current screen for a renum */
/* QL: bp_listr */
bp_listr:
/* QL:         moveq   #0,d2           make line number the special, list all */
    moveq #0,d2
/* QL:         moveq   #0,d3           look as if a replaced line has happened */
    moveq #0,d3
/* QL: * Relist on list channel if d2/d3 implies screen should change */
/* QL: bp_list2 */
bp_list2:
/* QL:         bsr.s   M51_pickls          get the list channel */
    bsr.s M51_pickls
/* QL:         bmi.s   M51_rts2 */
    bmi.s M51_rts2
/* QL:         move.l  d0,a0 */
    move.l d0,a0
/* QL: * d2 -i  - line number in question, 0 for from M51_top to fill */
/* QL: * d3 -ip - +ve for inserted line */
/* QL: *          0   for replaced line */
/* QL: *          -ve for deleted line */
/* QL: * a0 -ip - list channel id */
/* QL: * d0-d1/d4/d6/a1-a2/a4 destroyed */
/* QL: M51_relist */
M51_relist:
/* QL:         move.l  M51_bv_lnbas(a6),a1 line number table */
    move.l M51_bv_lnbas(a6),a1
/* QL:         cmp.l   M51_bv_lnp(a6),a1   is there anything on the screen yet? */
    cmp.l M51_bv_lnp(a6),a1
/* QL:         beq.s   M51_just_d2         no - go list just d2 */
    beq.s M51_just_d2
/* QL: * There was an attempt at clearing d0 above, but there's no reason to? */
/* QL:         move.w  0(a6,a1.l),d4   M51_top line number on screen */
    move.w 0(a6,a1.l),d4
/* QL:         tst.w   d2              is current line set? */
    tst.w d2
/* QL:         bne.s   M51_cur_set */
    bne.s M51_cur_set
/* QL:         move.w  d4,d2           no - current line set to M51_top */
    move.w d4,d2
/* QL: M51_cur_set */
M51_cur_set:
/* QL:         assert  M51_bv_lsbef,M51_bv_lsbas-2,M51_bv_lsaft-4,M51_bv_maxln-8,M51_bv_totln-10 */
/* original assertion: M51_bv_lsbef,M51_bv_lsbas-2,M51_bv_lsaft-4,M51_bv_maxln-8,M51_bv_totln-10 */
/* QL:         movem.w M51_bv_lsbef(a6),d0-d1/d6/a1-a2/a4 */
    movem.w M51_bv_lsbef(a6),d0-d1/d6/a1-a2/a4
/* QL:         cmp.w   d0,d2           lsbef: is lno before invisible M51_top line? */
    cmp.w d0,d2
/* QL:         bcs.s   M51_rts1            yes, do nothing */
    bcs.s M51_rts1
/* QL:         cmp.w   d4,d2           is it between bef and M51_top? */
    cmp.w d4,d2
/* QL:         bcs.s   M51_top             yes, only print if not deleted */
    bcs.s M51_top
/* QL:         cmp.w   d6,d2           lsaft: if after invisible base line, get out */
    cmp.w d6,d2
/* QL:         bhi.s   M51_rts1 */
    bhi.s M51_rts1
/* QL:         cmp.w   d6,d2           is it between bas and aft? */
    cmp.w d6,d2
/* QL:         bhi.s   M51_basdel          yes, only print if not deleted */
    bhi.s M51_basdel
/* QL:         tst.b   d3 */
    tst.b d3
/* QL:         bpl.s   M51_print1          lsbas: insert/mofify, print M51_top to bas */
    bpl.s M51_print1
/* QL:         bra.s   M51_print6          lsaft: deleted, print M51_top to aft */
    bra.s M51_print6
/* QL: M51_just_d2 */
M51_just_d2:
/* QL:         move.w  d2,d4           set current line as the first in the range */
    move.w d2,d4
/* QL:         bne.s   M51_prtod2          fill to the bottom of the window */
    bne.s M51_prtod2
/* QL: M51_rts1 */
M51_rts1:
/* QL:         rts */
    rts 
/* QL: M51_basdel */
M51_basdel:
/* QL:         tst.b   d3              print M51_top (which will disappear) to lno */
    tst.b d3
/* QL:         bmi.s   M51_rts1            not interested if a deleted line */
    bmi.s M51_rts1
/* QL: M51_prtod2 */
M51_prtod2:
/* QL:         move.w  d2,d6 */
    move.w d2,d6
/* QL:         bra.s   M51_print6 */
    bra.s M51_print6
/* QL: M51_top */
M51_top:
/* QL:         tst.b   d3              not interested if not new or updated */
    tst.b d3
/* QL:         bmi.s   M51_rts1 */
    bmi.s M51_rts1
/* QL:         move.w  d2,d4 */
    move.w d2,d4
/* QL:         cmp.w   a2,a4           maxln/totln */
    cmp.w a2,a4
/* QL:         blt.s   M51_print1          if not yet full, print all the way to bas */
    blt.s M51_print1
/* QL:         subq.w  #1,d1           print lno to one before bas (should work) */
    subq.w #1,d1
/* QL: M51_print1 */
M51_print1:
/* QL:         move.w  d1,d6 */
    move.w d1,d6
/* QL: M51_print6 */
M51_print6:
/* QL:         move.w  d2,M51_bv_lsfil(a6) fill the screen at least to this line */
    move.w d2,M51_bv_lsfil(a6)
/* QL:         moveq   #M51_sd.pos,d0      put the cursor */
    moveq #M51_sd.pos,d0
/* QL:         moveq   #0,d2           at the M51_top */
    moveq #0,d2
/* QL:         moveq   #0,d1           left hand corner */
    moveq #0,d1
/* QL:         bsr.s   M51_trap_3 */
    bsr.s M51_trap_3
/* QL:         st      M51_bv_print(a6)    turn print on */
    st M51_bv_print(a6)
/* QL:         bsr.l   M51_listp           list from d4 to d6 inclusive */
    bsr.w M51_listp
/* QL:         moveq   #M51_sd.clrrt,d0    clear to right of cursor */
    moveq #M51_sd.clrrt,d0
/* QL:         bsr.s   M51_trap_3 */
    bsr.s M51_trap_3
/* QL: ; Already done the above, assuming anything was listed at all! */
/* QL: ; It is needed if we are called to list a deleted range, and nothing is left */
/* QL:         moveq   #M51_sd.clrbt,d0    clear bottom of screen */
    moveq #M51_sd.clrbt,d0
/* QL: M51_trap_3 */
M51_trap_3:
/* QL:         bra.l   M51_trap3 */
    bra.w M51_trap3
/* QL: * Pick up list channel into d0, return -ve if not present or closed */
/* QL: M51_pickls */
M51_pickls:
/* QL:         moveq   #-(M51_c.defls+1)*M51_ch.lench,d0 */
    moveq #((-(M51_c.defls+1))*M51_ch.lench),d0
/* QL:         add.l   M51_bv_chp(a6),d0 */
    add.l M51_bv_chp(a6),d0
/* QL:         sub.l   M51_bv_chbas(a6),d0 actually M51_check if list channel exists! */
    sub.l M51_bv_chbas(a6),d0
/* QL:         bmi.s   M51_nolstch         if not, d0 should be negative */
    bmi.s M51_nolstch
/* QL:         move.l  M51_bv_chbas(a6),d0 */
    move.l M51_bv_chbas(a6),d0
/* QL:         move.l  M51_ch.lench*M51_c.defls(a6,d0.l),d0 get listing channel id */
    move.l (M51_ch.lench*M51_c.defls)(a6,d0.l),d0
/* QL: M51_nolstch */
M51_nolstch:
/* QL:         rts */
    rts 
/* QL: * Lists or deletes program lines in range indicated by d4 and d6 */
/* QL: * d4 -i  - lower line to write */
/* QL: * d6 -i  - upper line to write */
/* QL: * d7 -ip - if zero, list, else delete lines in range */
/* QL: * a0 -ip - where to write to */
/* QL: * d0-d3/a1-a2/a4 destroyed */
/* QL: * This entry point preserved for vector entry. */
/* QL: bp_liste */
bp_liste:
/* QL:         tst.b   d7              listing or deleting? */
    tst.b d7
/* QL:         beq.s   M51_listp           if list, go there */
    beq.s M51_listp
/* QL:         jsr     ib_glin0(pc)    go to the line number required */
    jsr ib_glin0(pc)
/* QL:         ble.s   M51_okrts           we won't take the slightest notice if off M51_top */
    ble.s M51_okrts
/* QL:         move.w  4(a6,a4.l),d2   get current lno */
    move.w 4(a6,a4.l),d2
/* QL:         cmp.w   d2,d6           are we deleting a null range? */
    cmp.w d2,d6
/* QL:         blo.s   M51_okrts           amazing, the things people think up */
    blo.s M51_okrts
/* QL:         cmp.w   M51_bv_linum(a6),d2 are we deleting before, or including ourself? */
    cmp.w M51_bv_linum(a6),d2
/* QL:         bhi.s   M51_delok */
    bhi.s M51_delok
/* QL:         jsr     ib_steof(pc)    yes - make sure we don't continue! */
    jsr ib_steof(pc)
/* QL: M51_delok */
M51_delok:
/* QL:         jsr     ib_whdel(pc)    tell when processing which lines are going */
    jsr ib_whdel(pc)
/* QL: * whdel gets d2/d6 and can zap d0/a2, at least, plus a4 is easy to restore */
/* QL:         move.w  d6,d4           set M51_top line to search for */
    move.w d6,d4
/* QL:         addq.w  #1,d4           n.b. 32767->32768, but glin1 uses unsigned cmps */
    addq.w #1,d4
/* QL:         move.w  d1,d6           save prior line length */
    move.w d1,d6
/* QL:         move.l  a0,-(sp)        save channel ID */
    move.l a0,-(sp)
/* QL:         move.l  a4,a0           where to shift code down to */
    move.l a4,a0
/* QL:         jsr     ib_glin1(pc)    position past M51_top line of range */
    jsr ib_glin1(pc)
/* QL:         ble.s   M51_put_pfp         at M51_top of program, so nowt to copy */
    ble.s M51_put_pfp
/* QL:         sub.w   d6,d1 */
    sub.w d6,d1
/* QL:         add.w   d1,0(a6,a4.l)   correct the line length change word */
    add.w d1,0(a6,a4.l)
/* QL:         move.l  a4,a1           source from remaining program lines */
    move.l a4,a1
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL:         sub.l   a1,d1           length */
    sub.l a1,d1
/* QL:         jsr     mm_mrtor(pc)    fast copy */
    jsr mm_mrtor(pc)
/* QL:         add.l   d1,a0           new M51_top */
    add.l d1,a0
/* QL: M51_put_pfp */
M51_put_pfp:
/* QL:         st      M51_bv_edit(a6)     this wasn't being done before! */
    st M51_bv_edit(a6)
/* QL:         move.l  a0,M51_bv_pfp(a6)   store new M51_top of program */
    move.l a0,M51_bv_pfp(a6)
/* QL:         move.l  (sp)+,a0        restore channel ID */
    move.l (sp)+,a0
/* QL: M51_okrts */
M51_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Verify if the current channel id is that of the listing channel (#2) */
/* QL: * d0 -  o- the listing window id, ccr z set if d0=a0, made -ve if no list chan */
/* QL: * a0 -ip - channel id */
/* QL: bp_chkls */
bp_chkls:
/* QL:         bsr.s   M51_pickls */
    bsr.s M51_pickls
/* QL:         bmi.s   M51_notlst */
    bmi.s M51_notlst
/* QL:         cmp.l   a0,d0           returns eq if this is the listing window */
    cmp.l a0,d0
/* QL: M51_notlst */
M51_notlst:
/* QL:         rts */
    rts 
/* QL: * Check if a0 is list channel, and if so wipe out current list info */
/* QL: * d0 -  o- 0 iff ccr=Z */
/* QL: * a0 -ip - channel id in question */
/* QL: bp_lsqzp */
bp_lsqzp:
/* QL:         bsr.s   bp_chkls */
    bsr.s bp_chkls
/* QL:         bne.s   M51_notlst */
    bne.s M51_notlst
/* QL: * Zap list info */
/* QL: * d0 -  o- 0 */
/* QL: bp_lszap */
bp_lszap:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M51_initls */
M51_initls:
/* QL:         move.l  M51_bv_lnbas(a6),M51_bv_lnp(a6) empty table */
    move.l M51_bv_lnbas(a6),M51_bv_lnp(a6)
/* QL:         move.w  d0,M51_bv_lsbef(a6) */
    move.w d0,M51_bv_lsbef(a6)
/* QL:         assert  M51_bv_lsbef,M51_bv_lsbas-2 */
/* original assertion: M51_bv_lsbef,M51_bv_lsbas-2 */
/* QL:         move.l  d0,M51_bv_lsbas(a6) */
    move.l d0,M51_bv_lsbas(a6)
/* QL:         rts */
    rts 
/* QL: * Detokenise a line */
/* QL: * d4 -i o- line number to detokenise / keyword table pointer */
/* QL: * d6 -  o- as d4 input */
/* QL: * a4 -  o- pre-word of last line examined */
/* QL: * d0-d3/a1-a2 destroyed */
/* QL: bp_detok */
bp_detok:
/* QL:         move.w  d4,d6           (also M51_top line) */
    move.w d4,d6
/* QL:         sf      M51_bv_print(a6)    turn print off */
    sf M51_bv_print(a6)
/* QL: M51_listp */
M51_listp:
/* QL:         jsr     ib_glin0(pc)    go to the line number required */
    jsr ib_glin0(pc)
/* QL:         sub.l   a2,a2           make invisible M51_top line be zero */
    sub.l a2,a2
/* QL:         cmp.l   a4,d0           M51_check if at first line of program */
    cmp.l a4,d0
/* QL:         beq.s   bp_listf        if so, M51_top line zero is ready if we need it */
    beq.s bp_listf
/* QL:         move.l  a4,a2 */
    move.l a4,a2
/* QL:         sub.w   d1,a2 */
    sub.w d1,a2
/* QL:         move.w  4(a6,a2.l),a2   fetch a genuine invisible M51_top line */
    move.w 4(a6,a2.l),a2
/* QL: * d0 -i  - pfbas */
/* QL: * d4 -  o- keyword table pointer */
/* QL: * d6 -ip - line number to stop printing at */
/* QL: * a0 -ip - channel id to print to */
/* QL: * a2 -i  - invisible M51_top line (one before a4) */
/* QL: * a4 -i o- pre-word of first line to print / pre-word of last line examined */
/* QL: * d1-d3/a1 destroyed */
/* QL: bp_listf */
bp_listf:
/* QL:         move.l  a0,-(sp)        save channel id */
    move.l a0,-(sp)
/* QL:         move.b  M51_bv_print(a6),M51_bv_lsany(a6) see if we are printing at all */
    move.b M51_bv_print(a6),M51_bv_lsany(a6)
/* QL:         beq.s   M51_lnskip          nope, so don't even think about it */
    beq.s M51_lnskip
/* QL:         bsr.s   bp_chkls        is this the list window? */
    bsr.s bp_chkls
/* QL:         bne.s   M51_setany          no - go stop table */
    bne.s M51_setany
/* QL:         moveq   #M51_sd.chenq,d0    get size of listing window */
    moveq #M51_sd.chenq,d0
/* QL:         assert  M51_bv_lenln,M51_bv_maxln-2 */
/* original assertion: M51_bv_lenln,M51_bv_maxln-2 */
/* QL:         move.w  #M51_bv_lenln,a1    length of a line.w, no of lines.w, hit 2 more */
    move.w #M51_bv_lenln,a1
/* QL:         bsr.s   M51_trap43 */
    bsr.s M51_trap43
/* QL: M51_setany */
M51_setany:
/* QL:         seq     M51_bv_lsany(a6)    if all ok, we'll do line number table */
    seq M51_bv_lsany(a6)
/* QL:         bne.s   M51_lnskip */
    bne.s M51_lnskip
/* QL:         move.w  d0,M51_bv_totln(a6) set no of lines to zero */
    move.w d0,M51_bv_totln(a6)
/* QL:         move.w  a2,d0           for lsbef and lsaft, lsbas set zero for a mo */
    move.w a2,d0
/* QL:         bsr.s   M51_initls */
    bsr.s M51_initls
/* QL: M51_lnskip */
M51_lnskip:
/* QL:         pea     M51_nxtline */
    pea M51_nxtline(pc)
/* QL:         jmp     bv_chri(pc)     make certain we have some ri space for ftod */
    jmp bv_chri(pc)
/* QL: * End of line code. M51_bv_bfp points at lf, a0 points at lf + 1 */
/* QL: M51_preol */
M51_preol:
/* QL:         addq.l  #2,a4           space over nl token to pre-word of next line */
    addq.l #2,a4
/* QL:         tst.b   M51_bv_brk(a6)      M51_check for a break input (don't reset it here!) */
    tst.b M51_bv_brk(a6)
/* QL: M51_end_ok1 */
M51_end_ok1:
/* QL:         bpl.l   M51_end_ok0         yes, don't do next line */
    bpl.w M51_end_ok0
/* QL:         tst.b   M51_bv_print(a6)    am I to print this ? */
    tst.b M51_bv_print(a6)
/* QL:         beq.s   M51_end_ok1         no - leave it in the buffer */
    beq.s M51_end_ok1
/* QL:         sub.l   M51_bv_bfbas(a6),a0 line length including lf */
    sub.l M51_bv_bfbas(a6),a0
/* QL:         tst.b   M51_bv_lsany(a6)    M51_check if we have an active line number table */
    tst.b M51_bv_lsany(a6)
/* QL:         beq.s   M51_bufprt          no, so now just print it */
    beq.s M51_bufprt
/* QL:         moveq   #4,d1 */
    moveq #4,d1
/* QL:         jsr     bv_chlnx(pc)    ensure space for one line number table entry */
    jsr bv_chlnx(pc)
/* QL:         assert  M51_bv_lnbas,M51_bv_lnp-4 */
/* original assertion: M51_bv_lnbas,M51_bv_lnp-4 */
/* QL:         movem.l M51_bv_lnbas(a6),a1-a2 base and running pointer of lno table */
    movem.l M51_bv_lnbas(a6),a1-a2
/* QL:         assert  M51_bv_lsaft,M51_bv_lenln-2,M51_bv_maxln-4,M51_bv_totln-6 */
/* original assertion: M51_bv_lsaft,M51_bv_lenln-2,M51_bv_maxln-4,M51_bv_totln-6 */
/* QL:         movem.w M51_bv_lsaft(a6),d0-d3 */
    movem.w M51_bv_lsaft(a6),d0-d3
/* QL:         moveq   #-1-1,d4        forget the lf and we will round up */
    moveq #((-1)-1),d4
/* QL:         add.l   a0,d4 */
    add.l a0,d4
/* QL:         divu    d1,d4 */
    divu d1,d4
/* QL:         addq.w  #1,d4           no of lines this will occupy */
    addq.w #1,d4
/* QL:         cmp.w   d4,d2           is this line bigger than whole screen? */
    cmp.w d4,d2
/* QL:         bge.s   M51_notover         no, so we're not into finicky bits */
    bge.s M51_notover
/* QL:         move.w  d2,d4           pretend it's just whole screen */
    move.w d2,d4
/* QL: M51_notover */
M51_notover:
/* QL:         add.w   d4,d3           add to running total */
    add.w d4,d3
/* QL:         bra.s   M51_check           now we are guaranteed to leave it in table */
    bra.s M51_check
/* QL: M51_trap43 */
M51_trap43:
/* QL:         trap    #4 */
    trap #4
/* QL: M51_trap3 */
M51_trap3:
/* QL:         moveq   #-1,d3 */
    moveq #(-1),d3
/* QL:         trap    #3 */
    trap #3
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: M51_roll_tab */
M51_roll_tab:
/* QL:         sub.w   2(a6,a1.l),d3   take off lines encompassed in M51_top ln */
    sub.w 2(a6,a1.l),d3
/* QL:         move.w  0(a6,a1.l),M51_bv_lsbef(a6) update invisible M51_top line */
    move.w 0(a6,a1.l),M51_bv_lsbef(a6)
/* QL:         addq.l  #4,a1           roll the table forward */
    addq.l #4,a1
/* QL: M51_check */
M51_check:
/* QL:         cmp.w   d2,d3           will we scroll out of window */
    cmp.w d2,d3
/* QL:         ble.s   M51_putlntab        no, just wind it in */
    ble.s M51_putlntab
/* QL:         tst.w   M51_bv_lsfil(a6)    are we supposed to just fill window? */
    tst.w M51_bv_lsfil(a6)
/* QL:         beq.s   M51_roll_tab        no, so keep going */
    beq.s M51_roll_tab
/* QL:         cmp.w   M51_bv_lsfil(a6),d0 have we done the "fill to" line yet? */
    cmp.w M51_bv_lsfil(a6),d0
/* QL:         bls.s   M51_roll_tab        no, so also keep going */
    bls.s M51_roll_tab
/* QL: * We've done the fill to line, we can't fit this, but we must have space left, */
/* QL: * or we wouldn't have come back to do this line at all. (See below) */
/* QL:         sub.w   d2,d3           overflow in window */
    sub.w d2,d3
/* QL:         sub.w   d3,d4           reduce the space we recorded for this line */
    sub.w d3,d4
/* QL:         move.w  d2,d3           show screen as filled to the brim */
    move.w d2,d3
/* QL:         mulu    d4,d1           do a partial display of extra line at bottom */
    mulu d4,d1
/* QL:         move.l  d1,a0           override length */
    move.l d1,a0
/* QL: M51_putlntab */
M51_putlntab:
/* QL:         move.w  d3,M51_bv_totln(a6) update the no of lines in the window */
    move.w d3,M51_bv_totln(a6)
/* QL:         move.l  a1,M51_bv_lnbas(a6) save base of lno table */
    move.l a1,M51_bv_lnbas(a6)
/* QL:         movem.w d0/d4,0(a6,a2.l) put in the lno/lines to be printed (lsaft) */
    movem.w d0/d4,0(a6,a2.l)
/* QL:         addq.l  #4,M51_bv_lnp(a6)   update the running lno table pointer */
    addq.l #4,M51_bv_lnp(a6)
/* QL: M51_bufprt */
M51_bufprt:
/* QL:         move.w  a0,d2           length including lf (or trimmed final line) */
    move.w a0,d2
/* QL:         move.l  M51_bv_bfbas(a6),a1 */
    move.l M51_bv_bfbas(a6),a1
/* QL:         moveq   #M51_io.sstrg,d0    send a string of bytes */
    moveq #M51_io.sstrg,d0
/* QL:         move.l  (sp),a0         write it to here */
    move.l (sp),a0
/* QL:         bsr.s   M51_trap43 */
    bsr.s M51_trap43
/* QL:         bne.s   M51_end_err */
    bne.s M51_end_err
/* QL:         moveq   #M51_sd.clrrt,d0    clear to end of line */
    moveq #M51_sd.clrrt,d0
/* QL:         trap    #3 */
    trap #3
/* QL: M51_nxtline */
M51_nxtline:
/* QL:         move.w  #32768,d4       dummy next line number */
    move.w #32768,d4
/* QL:         cmp.l   M51_bv_pfp(a6),a4   reached end of program file yet? */
    cmp.l M51_bv_pfp(a6),a4
/* QL:         bge.s   M51_nextset         yes - use dummy lno */
    bge.s M51_nextset
/* QL:         addq.l  #2,a4           skip pre-word */
    addq.l #2,a4
/* QL:         move.w  2(a6,a4.l),d4   get the proper line number */
    move.w 2(a6,a4.l),d4
/* QL: M51_nextset */
M51_nextset:
/* QL:         tst.b   M51_bv_lsany(a6)    M51_check if we have an active line number table */
    tst.b M51_bv_lsany(a6)
/* QL:         beq.s   M51_skipaft */
    beq.s M51_skipaft
/* QL:         jsr     bv_clrt(pc)     shift the lno tab down to butt into rtstk */
    jsr bv_clrt(pc)
/* QL:         ; d0=0, d1-d3/a0-a2 destroyed */
/* QL:         move.w  M51_bv_lsaft(a6),M51_bv_lsbas(a6) promote invisible line after to base */
    move.w M51_bv_lsaft(a6),M51_bv_lsbas(a6)
/* QL:         move.w  d4,M51_bv_lsaft(a6) store invisible line number after screen */
    move.w d4,M51_bv_lsaft(a6)
/* QL: M51_skipaft */
M51_skipaft:
/* QL:         move.w  d4,d1 */
    move.w d4,d1
/* QL:         move.l  pa_table(pc),d4 get keyword table address */
    move.l pa_table(pc),d4
/* QL: * We want to decide what to do with this line. */
/* QL: * If listing, we go operate range checks. */
/* QL: * If tokenising, we've either found the required line, or need to put a dummy. */
/* QL: * When on earth can we get here with print=0 and auto=0? */
/* QL:         tst.b   M51_bv_print(a6)    listing? */
    tst.b M51_bv_print(a6)
/* QL:         bne.s   M51_tst_rnge        yes, go M51_check range */
    bne.s M51_tst_rnge
/* QL:         tst.b   M51_bv_auto(a6)     detokenising for an auto/edit line? */
    tst.b M51_bv_auto(a6)
/* QL:         beq.s   M51_tst_rnge        no, go M51_check range (happens for TK2?) */
    beq.s M51_tst_rnge
/* QL:         cmp.w   M51_bv_edlin(a6),d1 and is it the one they asked for? */
    cmp.w M51_bv_edlin(a6),d1
/* QL:         beq.s   M51_tst_rnge        yes, go continue (irrelevent) M51_check on range */
    beq.s M51_tst_rnge
/* QL:         move.w  M51_bv_edlin(a6),d1 we are tokenising an absent auto/edit lno */
    move.w M51_bv_edlin(a6),d1
/* QL:         bsr.s   M51_prlno           put line number in buffer */
    bsr.s M51_prlno
/* QL:         move.l  a0,M51_bv_bfp(a6)   include the space */
    move.l a0,M51_bv_bfp(a6)
/* QL: M51_end_ok0 */
M51_end_ok0:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M51_end_err */
M51_end_err:
/* QL:         move.l  (sp)+,a0        restore channel id */
    move.l (sp)+,a0
/* QL:         rts */
    rts 
/* QL: * Now... we want to do one of two things: */
/* QL: * If lsfil is set, we absolutely must do that one, but we can then fill the */
/* QL: * screen to our heart's content. */
/* QL: * If lsfil is not set, we want to stop as soon as d6 has been done. */
/* QL: M51_tst_rnge */
M51_tst_rnge:
/* QL:         cmp.w   d6,d1           is it ok to print? */
    cmp.w d6,d1
/* QL:         bls.s   M51_chk_top         yes, go do it */
    bls.s M51_chk_top
/* QL:         tst.b   M51_bv_lsany(a6)    listing to list channel? */
    tst.b M51_bv_lsany(a6)
/* QL:         beq.s   M51_end_ok0         no, finished printing */
    beq.s M51_end_ok0
/* QL:         move.w  M51_bv_lsfil(a6),d0 are we filling the window? */
    move.w M51_bv_lsfil(a6),d0
/* QL:         beq.s   M51_end_ok0         nope, so stop */
    beq.s M51_end_ok0
/* QL:         cmp.w   d0,d1           have we done the required line yet? */
    cmp.w d0,d1
/* QL:         bls.s   M51_chk_top         not, keep on printing */
    bls.s M51_chk_top
/* QL:         move.w  M51_bv_maxln(a6),d0 */
    move.w M51_bv_maxln(a6),d0
/* QL:         cmp.w   M51_bv_totln(a6),d0 do we have any space left on the screen? */
    cmp.w M51_bv_totln(a6),d0
/* QL:         ble.s   M51_end_ok0         no, stop now */
    ble.s M51_end_ok0
/* QL: M51_chk_top */
M51_chk_top:
/* QL:         tst.w   d1              are we at the end of the program */
    tst.w d1
/* QL:         ble.s   M51_end_ok0         yes, so this must be the end! */
    ble.s M51_end_ok0
/* QL:         bsr.s   M51_prlno */
    bsr.s M51_prlno
/* QL:         pea     M51_preol           return at M51_w.eol up to print line */
    pea M51_preol(pc)
/* QL: * Convert program file line to text in basic buffer */
/* QL: * d0 -  o- 10 */
/* QL: * d1 -  o- M51_w.lno */
/* QL: * d3 -  o- 16  */
/* QL: * d4 -ip - keyword table address */
/* QL: * a0 -i o- base of basic buffer / after newline (M51_bv_bfp left with a0-1) */
/* QL: * a1 -  o- pa_tbsym */
/* QL: * a4 -i o- lno token at start of line / newline token at end of line */
/* QL: * d2 destroyed */
/* QL: M51_makeline */
M51_makeline:
/* QL:         moveq   #16,d3          enough for known tokens + msb clear */
    moveq #16,d3
/* QL:         bsr.s   M51_chbf */
    bsr.s M51_chbf
/* QL:         jsr     ib_nxtk(pc)     1st byte in d0.l, full word in d1.l (msbs=0) */
    jsr ib_nxtk(pc)
/* QL:         pea     M51_makeline */
    pea M51_makeline(pc)
/* QL:         sub.b   d3,d0           this should sort valid tokens and fp ... */
    sub.b d3,d0
/* QL:         bvs.s   M51_istok           tokens $80-$8f will go to $70-$7f with v set */
    bvs.s M51_istok
/* QL:         rol.w   #8,d3           make it $1000 */
    rol.w #8,d3
/* QL:         add.w   d1,d3           this should get the exponent ok */
    add.w d1,d3
/* QL:         bcc.s   M51_pr_prbad        it wasn't $fxxx, so it isn't really fp! */
    bcc.s M51_pr_prbad
/* QL:         move.l  M51_bv_rip(a6),a1 */
    move.l M51_bv_rip(a6),a1
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.w  d3,0(a6,a1.l)   put corrected exponent */
    move.w d3,0(a6,a1.l)
/* QL:         move.l  2(a6,a4.l),2(a6,a1.l) and mantissa onto arithmetic stack */
    move.l 2(a6,a4.l),2(a6,a1.l)
/* QL:         jmp     cn_ftod(pc)     do the conversion */
    jmp cn_ftod(pc)
/* QL: M51_istok */
M51_istok:
/* QL:         move.b  M51_pr_tab-$70(pc,d0.w),d0 get offset of relevent print routine */
    move.b (M51_pr_tab-0x70)(pc,d0.w),d0
/* QL:         jmp     M51_pr_jmp(pc,d0.w) jump to it (a line feed drops return addr) */
.word 0x4efb
.word 0|((M51_pr_jmp-.)&255)
/* QL: M51_prlno */
M51_prlno:
/* QL:         move.l  M51_bv_bfbas(a6),a0 reset buffer */
    move.l M51_bv_bfbas(a6),a0
/* QL:         bsr.s   M51_itodd1          do conversion */
    bsr.s M51_itodd1
/* QL:         bra.s   M51_prtsp           tack on a space */
    bra.s M51_prtsp
/* QL: M51_pr_tab */
M51_pr_tab:
/* QL: M51_pr_tab macro */
/* QL:  M51_pr_tab spc key bip bif sym ops mon syv nam shi lgi str txt lno sep bad */
/* QL:         assert 16,[.nparms] */
/* original assertion: 16,16 */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+1-1,M51_b.spc&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2205:
.byte (((M51_pr_prspc-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+2-1,M51_b.key&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2215:
.byte (((M51_pr_prkey-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+3-1,M51_b.bip&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2225:
.byte (((M51_pr_prbip-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+4-1,M51_b.bif&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2235:
.byte (((M51_pr_prbif-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+5-1,M51_b.sym&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2245:
.byte (((M51_pr_prsym-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+6-1,M51_b.ops&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2255:
.byte (((M51_pr_props-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+7-1,M51_b.mon&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2265:
.byte (((M51_pr_prmon-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+8-1,M51_b.syv&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2275:
.byte (((M51_pr_prsyv-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+9-1,M51_b.nam&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2285:
.byte (((M51_pr_prnam-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+10-1,M51_b.shi&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2295:
.byte (((M51_pr_prshi-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+11-1,M51_b.lgi&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2305:
.byte (((M51_pr_prlgi-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+12-1,M51_b.str&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2315:
.byte (((M51_pr_prstr-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+13-1,M51_b.txt&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2325:
.byte (((M51_pr_prtxt-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+14-1,M51_b.lno&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2335:
.byte (((M51_pr_prlno-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL:         assert  $80+[i]-1,b.[.parm([i])]&$FF */
/* original assertion: $80+15-1,M51_b.sep&$FF */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2345:
.byte (((M51_pr_prsep-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifstr [.parm([i])] = bad goto n */
/* QL: n maclab */
/* QL:         dc.b    (pr_pr[.parm([i])]-M51_pr_jmp)&$FFFF */
M51_dc_anchor_2353:
.byte (((M51_pr_prbad-M51_pr_jmp)&0xffff))&255
/* QL:  ifnum [i] < 16 goto l */
/* QL:         ds.w    0 */
.balign 2,0
/* QL: M51_chbf */
M51_chbf:
/* QL:         move.l  a0,M51_bv_bfp(a6) set buffer ptr */
    move.l a0,M51_bv_bfp(a6)
/* QL:         add.l   d3,a0 */
    add.l d3,a0
/* QL:         cmp.l   M51_bv_bfp+4(a6),a0 */
    cmp.l (M51_bv_bfp+4)(a6),a0
/* QL:         sub.l   d3,a0 */
    sub.l d3,a0
/* QL:         blt.s   M51_rts6            allow one extra */
    blt.s M51_rts6
/* QL:         move.l  d3,d1 */
    move.l d3,d1
/* QL:         addq.l  #1,d1           just to cope with quoted string */
    addq.l #1,d1
/* QL:         sub.l   M51_bv_pfbas(a6),a4 relative pos of program file pointer */
    sub.l M51_bv_pfbas(a6),a4
/* QL:         jsr     bv_chbfx(pc) */
    jsr bv_chbfx(pc)
/* QL:         add.l   M51_bv_pfbas(a6),a4 restore */
    add.l M51_bv_pfbas(a6),a4
/* QL: M51_rts6 */
M51_rts6:
/* QL:         rts */
    rts 
/* QL: M51_pr_jmp ; jump table vectors come here */
M51_pr_jmp:
/* QL: M51_pr_prshi */
M51_pr_prshi:
/* QL:         ext.w   d1 */
    ext.w d1
/* QL: M51_itodd1 */
M51_itodd1:
/* QL:         move.w  d1,d0 */
    move.w d1,d0
/* QL: M51_itodd0 */
M51_itodd0:
/* QL:         jmp     cn_0tod(pc) */
    jmp cn_0tod(pc)
/* QL: M51_pr_prlgi */
M51_pr_prlgi:
/* QL:         move.w  2(a6,a4.l),d0 */
    move.w 2(a6,a4.l),d0
/* QL:         bra.s   M51_itodd0 */
    bra.s M51_itodd0
/* QL: M51_pr_prnam */
M51_pr_prnam:
/* QL:         move.w  2(a6,a4.l),d0   get name number */
    move.w 2(a6,a4.l),d0
/* QL:         lsl.l   #3,d0           get byte offset */
    lsl.l #3,d0
/* QL:         move.l  M51_bv_ntbas(a6),a1 base of name table */
    move.l M51_bv_ntbas(a6),a1
/* QL:         add.l   d0,a1           pointer to name */
    add.l d0,a1
/* QL:         move.w  2(a6,a1.l),d2   get name list offset */
    move.w 2(a6,a1.l),d2
/* QL:         bpl.s   M51_prnam           must have positive offset */
    bpl.s M51_prnam
/* QL: M51_pr_prlno ; shouldn't get these anywhere but at start of line! */
M51_pr_prlno:
/* QL: M51_pr_prbip */
M51_pr_prbip:
/* QL: M51_pr_prbif */
M51_pr_prbif:
/* QL: M51_pr_prsyv */
M51_pr_prsyv:
/* QL: M51_pr_prbad */
M51_pr_prbad:
/* QL:         moveq   #4,d3 */
    moveq #4,d3
/* QL:         moveq   #'?',d2 */
    moveq #63,d2
/* QL:         bra.s   M51_prmult */
    bra.s M51_prmult
/* QL: M51_pr_prkey */
M51_pr_prkey:
/* QL:         move.l  d4,a1           get the pointer to the keyword table            */
    move.l d4,a1
/* QL:         move.b  d1,d3           get which keyword */
    move.b d1,d3
/* QL:         move.b  0(a1,d3.w),d3   get offset from start of keywords */
    move.b 0(a1,d3.w),d3
/* QL:         add.w   d3,a1           start of key */
    add.w d3,a1
/* QL:         move.b  (a1)+,d3        read pre-byte */
    move.b (a1)+,d3
/* QL:         lsr.b   #4,d3           get length */
    lsr.b #4,d3
/* QL:         bsr.s   M51_prabs           print the keyword */
    bsr.s M51_prabs
/* QL:         cmp.w   #M51_w.eol,2(a6,a4.l) is this keyword at the eond of the line */
    cmp.w #M51_w.eol,2(a6,a4.l)
/* QL:         beq.s   M51_rts8            yes, so leave it at that */
    beq.s M51_rts8
/* QL: M51_prtsp */
M51_prtsp:
/* QL:         moveq   #' ',d2 */
    moveq #32,d2
/* QL: M51_prchr */
M51_prchr:
/* QL:         move.b  d2,0(a6,a0.l) */
    move.b d2,0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL: M51_rts8 */
M51_rts8:
/* QL:         rts */
    rts 
/* QL: M51_pr_prspc */
M51_pr_prspc:
/* QL:         move.b  d1,d3 */
    move.b d1,d3
/* QL:         bsr.s   M51_chbf            gotta M51_check it'll fit */
    bsr.s M51_chbf
/* QL:         moveq   #' ',d2         set space */
    moveq #32,d2
/* QL: M51_prmult */
M51_prmult:
/* QL:         bsr.s   M51_prchr           do the print */
    bsr.s M51_prchr
/* QL:         subq.b  #1,d3           finished yet? */
    subq.b #1,d3
/* QL:         bne.s   M51_prmult          ..no */
    bne.s M51_prmult
/* QL:         rts */
    rts 
/* QL: M51_pr_prsym */
M51_pr_prsym:
/* QL:         move.b  d1,d0           which symbol */
    move.b d1,d0
/* QL:         lea     pa_tbsym(pc),a1 */
    lea pa_tbsym(pc),a1
/* QL:         move.b  -1(a1,d0.w),d2 */
    move.b (-1)(a1,d0.w),d2
/* QL: * Sneaky trick based on the fact that the value of a line feed is = to its num */
/* QL:         cmp.b   d1,d2 */
    cmp.b d1,d2
/* QL:         bne.s   M51_prchr           if not a line feed, just add it to buffer */
    bne.s M51_prchr
/* QL:         addq.l  #4,sp           scrap normal return */
    addq.l #4,sp
/* QL:         bra.s   M51_prchr           go tack on the newline then return */
    bra.s M51_prchr
/* QL: M51_pr_prstr */
M51_pr_prstr:
/* QL:         bsr.s   M51_quote           print opening string M51_quote */
    bsr.s M51_quote
/* QL:         bsr.s   M51_pr_prtxt        print the string */
    bsr.s M51_pr_prtxt
/* QL: M51_quote */
M51_quote:
/* QL:         move.b  1(a6,a4.l),d2   string delimiter single/double quotes */
    move.b 1(a6,a4.l),d2
/* QL:         bra.s   M51_prchr */
    bra.s M51_prchr
/* QL: M51_pr_prmon */
M51_pr_prmon:
/* QL:         lea     pa_tbmon(pc),a1 */
    lea pa_tbmon(pc),a1
/* QL: M51_prky1 */
M51_prky1:
/* QL:         move.b  d1,d3           get which thing */
    move.b d1,d3
/* QL:         move.b  0(a1,d3.w),d3   get offset from start of things */
    move.b 0(a1,d3.w),d3
/* QL:         add.w   d3,a1           start of thing */
    add.w d3,a1
/* QL:         moveq   #15,d3 */
    moveq #15,d3
/* QL:         and.b   (a1)+,d3        read pre-byte */
    and.b (a1)+,d3
/* QL: M51_prabs */
M51_prabs:
/* QL:         move.b  (a1)+,0(a6,a0.l) */
    move.b (a1)+,0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bgt.s   M51_prabs */
    bgt.s M51_prabs
/* QL:         rts */
    rts 
/* QL: M51_prnam */
M51_prnam:
/* QL:         move.l  M51_bv_nlbas(a6),a1 base of name list */
    move.l M51_bv_nlbas(a6),a1
/* QL:         lea     -3(a1,d2.w),a1  start of name, as if it were a text token */
    lea (-3)(a1,d2.w),a1
/* QL:         move.b  3(a6,a1.l),d3   name length */
    move.b 3(a6,a1.l),d3
/* QL:         sub.l   a4,a1           relative pos of text/name pointer */
    sub.l a4,a1
/* QL: M51_rel_chk */
M51_rel_chk:
/* QL:         beq.s   M51_rts9            ignore zero length */
    beq.s M51_rts9
/* QL:         bsr.l   M51_chbf */
    bsr.w M51_chbf
/* QL:         add.l   a4,a1           restore */
    add.l a4,a1
/* QL: M51_prrel */
M51_prrel:
/* QL:         move.b  4(a6,a1.l),0(a6,a0.l) */
    move.b 4(a6,a1.l),0(a6,a0.l)
/* QL:         addq.l  #1,a1 */
    addq.l #1,a1
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bgt.s   M51_prrel */
    bgt.s M51_prrel
/* QL: M51_rts9 */
M51_rts9:
/* QL:         rts */
    rts 
/* QL: M51_pr_prtxt */
M51_pr_prtxt:
/* QL:         sub.l   a1,a1           set where text token starts */
    sub.l a1,a1
/* QL:         move.w  2(a6,a4.l),d3   get length of text */
    move.w 2(a6,a4.l),d3
/* QL:         bra.s   M51_rel_chk         print text */
    bra.s M51_rel_chk
/* QL: M51_pr_prsep */
M51_pr_prsep:
/* QL:         lea     pa_tbsep(pc),a1 */
    lea pa_tbsep(pc),a1
/* QL:         bra.s   M51_prky1 */
    bra.s M51_prky1
/* QL: M51_pr_props */
M51_pr_props:
/* QL:         lea     pa_tbops(pc),a1 */
    lea pa_tbops(pc),a1
/* QL:         bra.s   M51_prky1 */
    bra.s M51_prky1
/* QL:         end */
