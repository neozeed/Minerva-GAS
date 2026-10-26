/* ROM section ca_fun */
.balign 2,0
/* QL: * d0 -i o- input .b 0 = basic or $ff m/c / output err code */
/* QL: * d2 -  o- same as d0 */
/* QL: * d4 -i  - name row of function */
/* QL: * a0 -i o- pointer to expression */
/* QL: * a1 -  o- M91_bv_rip(a6) */
/* QL: * a3 -i  - function entry on name table */
/* QL: * a5 -i o- above arg */
/* QL: * d1/a2 destroyed (at least?) */
/* QL: ca_fun */
ca_fun:
/* QL:         tst.b   d0 */
    tst.b d0
/* QL:         bne.s   M91_mcf */
    bne.s M91_mcf
/* QL: * Deal with a basic function */
/* QL:         move.l  a3,a2 */
    move.l a3,a2
/* QL:         move.b  1(a6,a2.l),-7(a6,a5.l) type of return value */
    move.b 1(a6,a2.l),(-7)(a6,a5.l)
/* QL:         moveq   #3,d5 */
    moveq #3,d5
/* QL:         bsr.s   M91_gtobr */
    bsr.s M91_gtobr
/* QL:         bne.s   M91_no_args */
    bne.s M91_no_args
/* QL:         addq.l  #2,a0           step over the bracket */
    addq.l #2,a0
/* QL:         moveq   #2,d5 */
    moveq #2,d5
/* QL: M91_no_args */
M91_no_args:
/* QL:         move.l  a0,a4           call works on a4 */
    move.l a0,a4
/* QL:         sub.l   M91_bv_bfp+4(a6),a0 wrt just above buffer */
    sub.l (M91_bv_bfp+4)(a6),a0
/* QL:         move.l  a0,-(sp)        theory is that this is waiting when we ret */
    move.l a0,-(sp)
/* QL:                 ;               having been updated to point to endargs */
/* QL:         pea     sb_read(pc)     place to return after erroring in bf */
    pea sb_read(pc)
/* QL:         pea     ib_st2(pc)      place to return after doing... */
    pea ib_st2(pc)
/* QL:         jmp     ib_call(pc)     ...this */
    jmp ib_call(pc)
/* QL: M91_gtobr */
M91_gtobr:
/* QL:         cmp.b   #M91_b.spc,0(a6,a0.l) is current token a space? */
    cmp.b #(M91_b.spc&255),0(a6,a0.l)
/* QL:         bne.s   M91_chk_obr */
    bne.s M91_chk_obr
/* QL:         addq.l  #2,a0 */
    addq.l #2,a0
/* QL: M91_chk_obr */
M91_chk_obr:
/* QL:         cmp.w   #M91_w.opar,0(a6,a0.l) is it a ( ? */
    cmp.w #M91_w.opar,0(a6,a0.l)
/* QL:         rts */
    rts 
/* QL: * All machine code functions return the result on the RI stack and the type */
/* QL: * of the result in d4 */
/* QL: M91_err_xp */
M91_err_xp:
/* QL:         moveq   #M91_err.xp,d0 */
    moveq #M91_err.xp,d0
/* QL: M91_carg */
M91_carg:
/* QL:         add.l   M91_bv_ntbas(a6),a3 */
    add.l M91_bv_ntbas(a6),a3
/* QL:         jmp     ca_carg(pc)     (this moves a5 down to a3 for us) */
    jmp ca_carg(pc)
/* QL: M91_mcf */
M91_mcf:
/* QL:         move.l  4(a6,a3.l),a2   set the function address */
    move.l 4(a6,a3.l),a2
/* QL:         move.l  a5,a3 */
    move.l a5,a3
/* QL:         sub.l   M91_bv_ntbas(a6),a3 base of name table */
    sub.l M91_bv_ntbas(a6),a3
/* QL:         bsr.s   M91_gtobr           get the open bracket */
    bsr.s M91_gtobr
/* QL:         bne.s   M91_get_fadd        no open bracket - no arguments */
    bne.s M91_get_fadd
/* QL:         addq.l  #2,a0           move over the opening bracket */
    addq.l #2,a0
/* QL:         jsr     ca_garg(pc)     get all the function arguments */
    jsr ca_garg(pc)
/* QL:         bne.s   M91_carg            summat up */
    bne.s M91_carg
/* QL:         cmp.w   #M91_w.cpar,d1      finish with a close bracket ? */
    cmp.w #M91_w.cpar,d1
/* QL:         bne.s   M91_err_xp */
    bne.s M91_err_xp
/* QL:         addq.l  #2,a0           yes, skip it */
    addq.l #2,a0
/* QL: M91_get_fadd */
M91_get_fadd:
/* QL:         move.l  M91_bv_ntbas(a6),a4 base of name table */
    move.l M91_bv_ntbas(a6),a4
/* QL:         sub.l   a4,a5           offset of top of args on NT */
    sub.l a4,a5
/* QL:         sub.l   M91_bv_bfp+4(a6),a0 */
    sub.l (M91_bv_bfp+4)(a6),a0
/* QL:         move.l  M91_bv_rip(a6),a1 */
    move.l M91_bv_rip(a6),a1
/* QL:         sub.l   M91_bv_ribas(a6),a1 save where ri stack is */
    sub.l M91_bv_ribas(a6),a1
/* QL:         movem.l d5-d7/a0-a1/a3/a5,-(sp) save stuff */
    movem.l d5-d7/a0-a1/a3/a5,-(sp)
/* QL:         moveq   #0,d7           absolute guarantee of d7.l zero */
    moveq #0,d7
/* QL:         add.l   a4,a3 */
    add.l a4,a3
/* QL:         add.l   a4,a5 */
    add.l a4,a5
/* QL:         tst.b   M91_bv_uproc(a6)    is there a user trace procedure? */
    tst.b M91_bv_uproc(a6)
/* QL:         bpl.s   M91_noup */
    bpl.s M91_noup
/* QL:         jsr     bv_upmcf(pc)    yes - go do it */
    jsr bv_upmcf(pc)
/* QL: M91_noup */
M91_noup:
/* QL:         jsr     (a2)            do the function */
    jsr (a2)
/* QL:         movem.l (sp)+,d5-d7/a0-a1/a3/a5 */
    movem.l (sp)+,d5-d7/a0-a1/a3/a5
/* QL:         add.l   M91_bv_bfp+4(a6),a0 */
    add.l (M91_bv_bfp+4)(a6),a0
/* QL:         add.l   M91_bv_ntbas(a6),a5 */
    add.l M91_bv_ntbas(a6),a5
/* QL:         bsr.s   M91_carg            clear the args */
    bsr.s M91_carg
/* QL:         bne.s   M91_error */
    bne.s M91_error
/* QL:         move.b  d4,-7(a6,a5.l)  set the type of the result */
    move.b d4,(-7)(a6,a5.l)
/* QL:         addq.b  #M91_t.intern,-8(a6,a5.l) set to internal (was zero) */
    addq.b #M91_t.intern,(-8)(a6,a5.l)
/* QL:         move.l  M91_bv_rip(a6),a1   relax requirement for functions to get a1 right */
    move.l M91_bv_rip(a6),a1
/* QL: M91_tstd0 */
M91_tstd0:
/* QL:         move.l  d0,d2 */
    move.l d0,d2
/* QL:         rts */
    rts 
/* QL: M91_error */
M91_error:
/* QL:         add.l   M91_bv_ribas(a6),a1 */
    add.l M91_bv_ribas(a6),a1
/* QL:         move.l  a1,M91_bv_rip(a6)   restore RI stack pointer if rubbish around */
    move.l a1,M91_bv_rip(a6)
/* QL:         bra.s   M91_tstd0 */
    bra.s M91_tstd0
/* QL:         end */
