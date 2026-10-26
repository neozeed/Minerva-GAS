/* ROM section sd_pos */
.balign 2,0
/* QL: sd_pcol ; move to previous column */
sd_pcol:
/* QL:         move.w  M115_sd_xpos(a0),d1  decrement x cursor */
    move.w M115_sd_xpos(a0),d1
/* QL:         sub.w   M115_sd_xinc(a0),d1 */
    sub.w M115_sd_xinc(a0),d1
/* QL:         bra.s   M115_same_row */
    bra.s M115_same_row
/* QL: sd_ncol ; move to next column */
sd_ncol:
/* QL:         move.w  M115_sd_xinc(a0),d1  increment x cursor */
    move.w M115_sd_xinc(a0),d1
/* QL:         add.w   M115_sd_xpos(a0),d1 */
    add.w M115_sd_xpos(a0),d1
/* QL: M115_same_row */
M115_same_row:
/* QL:         clr.w   d2              same y cursor */
    clr.w d2
/* QL:         bra.s   M115_addypos */
    bra.s M115_addypos
/* QL: sd_prow ; move to previous row */
sd_prow:
/* QL:         move.w  M115_sd_yinc(a0),d2  decrement y cursor */
    move.w M115_sd_yinc(a0),d2
/* QL:         neg.w   d2 */
    neg.w d2
/* QL:         move.w  M115_sd_xpos(a0),d1  same x cursor */
    move.w M115_sd_xpos(a0),d1
/* QL:         bra.s   M115_addypos */
    bra.s M115_addypos
/* QL: sd_nrow ; move to next row */
sd_nrow:
/* QL:         move.w  M115_sd_xpos(a0),d1  same x cursor */
    move.w M115_sd_xpos(a0),d1
/* QL: M115_incrow */
M115_incrow:
/* QL:         move.w  M115_sd_yinc(a0),d2  increment y cursor */
    move.w M115_sd_yinc(a0),d2
/* QL: M115_addypos */
M115_addypos:
/* QL:         add.w   M115_sd_ypos(a0),d2 */
    add.w M115_sd_ypos(a0),d2
/* QL:         bra.s   sd_pixp */
    bra.s sd_pixp
/* QL: sd_home ; home */
sd_home:
/* QL:         clr.l   M115_sd_xpos(a0)     home cursor (n.b. this doesn't M115_check space!) */
    clr.l M115_sd_xpos(a0)
/* QL:         bra.s   M115_exit */
    bra.s M115_exit
/* QL: sd_tab ; absolute column */
sd_tab:
/* QL:         move.w  M115_sd_ypos(a0),d2  old y cursor */
    move.w M115_sd_ypos(a0),d2
/* QL:         bra.s   M115_pos_x */
    bra.s M115_pos_x
/* QL: sd_pos ; absolute position */
sd_pos:
/* QL:         mulu    M115_sd_yinc(a0),d2  new y cursor */
    mulu M115_sd_yinc(a0),d2
/* QL:         move.l  d2,d0 */
    move.l d2,d0
/* QL:         swap    d0 */
    swap d0
/* QL:         tst.w   d0 */
    tst.w d0
/* QL:         bne.s   M115_err_or */
    bne.s M115_err_or
/* QL: M115_pos_x */
M115_pos_x:
/* QL:         mulu    M115_sd_xinc(a0),d1  new x cursor */
    mulu M115_sd_xinc(a0),d1
/* QL:         move.l  d1,d0 */
    move.l d1,d0
/* QL:         swap    d0 */
    swap d0
/* QL:         tst.w   d0 */
    tst.w d0
/* QL:         bne.s   M115_err_or */
    bne.s M115_err_or
/* QL: sd_pixp ; absolute pixel position */
sd_pixp:
/* QL:         move.w  d1,d0 */
    move.w d1,d0
/* QL:         bmi.s   M115_err_or */
    bmi.s M115_err_or
/* QL:         swap    d0 */
    swap d0
/* QL:         move.w  d2,d0 */
    move.w d2,d0
/* QL:         bsr.s   M115_check           M115_check cursor + increment against size */
    bsr.s M115_check
/* QL:         bmi.s   M115_err_or */
    bmi.s M115_err_or
/* QL: sd_setc ; set cursor position with no checks */
sd_setc:
/* QL:         btst    #M115_mc..m256,M115_sv_mcsta(a6) is it low res? */
    btst #M115_mc..m256,M115_sv_mcsta(a6)
/* QL:         beq.s   M115_set_it */
    beq.s M115_set_it
/* QL:         bclr    #0,d1           x coordinate on 2 pixel boundry */
    bclr #0,d1
/* QL: M115_set_it */
M115_set_it:
/* QL:         movem.w d1-d2,M115_sd_xpos(a0); save new cursor position */
    movem.w d1-d2,M115_sd_xpos(a0)
/* QL: M115_exit */
M115_exit:
/* QL:         bsr.s   M115_clr_nl          M115_clear newline pending flag */
    bsr.s M115_clr_nl
/* QL: M115_ok */
M115_ok:
/* QL:         moveq   #0,d0           M115_clear error flag */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: sd_nl ; newline, if no scroll needed */
sd_nl:
/* QL:         moveq   #0,d1           set x cursor to lhs */
    moveq #0,d1
/* QL:         bra.s   M115_incrow */
    bra.s M115_incrow
/* QL: sd_chchk ; M115_check room for a character at current position */
sd_chchk:
/* QL:         move.l  M115_sd_xpos(a0),d0  get position */
    move.l M115_sd_xpos(a0),d0
/* QL:         bmi.s   M115_err_or          x is off lhs */
    bmi.s M115_err_or
/* QL:         tst.w   d0 */
    tst.w d0
/* QL: M115_check */
M115_check:
/* QL:         bmi.s   M115_err_or          y is off top */
    bmi.s M115_err_or
/* QL:         add.l   M115_sd_xinc(a0),d0  add increment */
    add.l M115_sd_xinc(a0),d0
/* QL:         cmp.w   M115_sd_ysize(a0),d0 y coordinates in lsw */
    cmp.w M115_sd_ysize(a0),d0
/* QL:         bhi.s   M115_err_or */
    bhi.s M115_err_or
/* QL:         swap    d0 */
    swap d0
/* QL:         cmp.w   M115_sd_xsize(a0),d0 x coordinates in lsw */
    cmp.w M115_sd_xsize(a0),d0
/* QL:         bls.s   M115_ok */
    bls.s M115_ok
/* QL: M115_err_or */
M115_err_or:
/* QL:         moveq   #M115_err.or,d0 */
    moveq #M115_err.or,d0
/* QL:         rts */
    rts 
/* QL: reglist reg     d0-d2/a1 */
/* QL: sd_donl ; do any pending newline */
sd_donl:
/* QL:         tst.b   M115_sd_nlsta(a0)    M115_exit if no newline pending */
    tst.b M115_sd_nlsta(a0)
/* QL:         beq.s   M115_rts0 */
    beq.s M115_rts0
/* QL: sd_newl ; send a newline, scrolling if need be */
sd_newl:
/* QL:         movem.l reglist,-(sp)   save crashable registers */
    movem.l d0-d2/a1,-(sp)
/* QL:         bsr.s   sd_nl           send newline */
    bsr.s sd_nl
/* QL:         beq.s   M115_clear */
    beq.s M115_clear
/* QL:         moveq   #M115_sd.scrol,d0    scroll up */
    moveq #M115_sd.scrol,d0
/* QL:         move.w  M115_sd_yinc(a0),d1 */
    move.w M115_sd_yinc(a0),d1
/* QL:         neg.w   d1 */
    neg.w d1
/* QL:         jsr     sd_scrol(pc) */
    jsr sd_scrol(pc)
/* QL:         clr.w   M115_sd_xpos(a0)     cursor left */
    clr.w M115_sd_xpos(a0)
/* QL: M115_clear */
M115_clear:
/* QL: ;$$        moveq   #0001100b,d0    M115_check for both xor and over */
/* QL: ;$$        and.b   M115_sd_cattr(a0),d0 */
/* QL: ;$$        bne.s   end_newl */
/* QL: ;$$        moveq   #M115_sd.clrln,d0    erase line */
/* QL: ;$$        jsr     sd_clrxx(pc) */
/* QL: ;$$ */
/* QL: ;$$end_newl */
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d0-d2/a1
/* QL: M115_clr_nl */
M115_clr_nl:
/* QL:         sf      M115_sd_nlsta(a0)    M115_clear newline pending flag */
    sf M115_sd_nlsta(a0)
/* QL: M115_rts0 */
M115_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
