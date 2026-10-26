/* ROM section ca_gtarg */
.balign 2,0
/* QL: * Generally, register useage is as follows */
/* QL: * d0 -  o- error code, ccr set */
/* QL: * d3 -  o- number of arguments (zero returned by ca_xxx1) */
/* QL: * a1 -  o- pointer on arithmetic stack to arguments (even if none now! lwr) */
/* QL: * a3 -i o- start of args */
/* QL: * a5 -i o- end of args */
/* QL: * d1-d2 destroyed (could save d2) (wow! used to zap d4/d6/a0/a2! no more - lwr) */
/* QL: * Exceptions are noted below */
/* QL: * d1 -  o- long integer found */
/* QL: * d3 -  o- 0 */
/* QL: ca_gtli1 */
ca_gtli1:
/* QL:         bsr.s   ca_gtlin        M93_get long integer argument */
    bsr.s ca_gtlin
/* QL:         move.l  0(a6,a1.l),d1   often useful */
    move.l 0(a6,a1.l),d1
/* QL:         bra.s   M93_tchk_1          and check all alone */
    bra.s M93_tchk_1
/* QL: * d3 -  o- 0 */
/* QL: ca_gtfp1 */
ca_gtfp1:
/* QL:         bsr.s   ca_gtfp         M93_get floating point argument */
    bsr.s ca_gtfp
/* QL:         bra.s   M93_chk_1           and check one and only one */
    bra.s M93_chk_1
/* QL: * d1 -  o- string length, extended to long */
/* QL: * d3 -  o- 0 */
/* QL: ca_gtst1 */
ca_gtst1:
/* QL:         bsr.s   ca_gtstr        M93_get string argument */
    bsr.s ca_gtstr
/* QL:         bra.s   M93_gchk_1          and check just one */
    bra.s M93_gchk_1
/* QL: * d1 -  o- integer found, extended to long */
/* QL: * d3 -  o- 0 */
/* QL: ca_gtin1 */
ca_gtin1:
/* QL:         bsr.s   ca_gtint        M93_get integer argument */
    bsr.s ca_gtint
/* QL: M93_gchk_1 */
M93_gchk_1:
/* QL:         move.w  0(a6,a1.l),d1   d1 often useful */
    move.w 0(a6,a1.l),d1
/* QL:         ext.l   d1              extended to long is convenient */
    ext.l d1
/* QL: M93_tchk_1 */
M93_tchk_1:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: M93_chk_1 */
M93_chk_1:
/* QL:         bne.s   M93_rts0            was it ok? */
    bne.s M93_rts0
/* QL:         subq.w  #1,d3           how many args? */
    subq.w #1,d3
/* QL:         beq.s   M93_rts0            good, just the one */
    beq.s M93_rts0
/* QL:         moveq   #M93_err.bp,d0      oh dear! we dinna M93_get the single arg! */
    moveq #M93_err.bp,d0
/* QL: M93_rts0 */
M93_rts0:
/* QL:         rts */
    rts 
/* QL: ca_gtstr */
ca_gtstr:
/* QL:         moveq   #M93_t.str,d0       M93_get strings */
    moveq #M93_t.str,d0
/* QL:         bra.s   M93_get */
    bra.s M93_get
/* QL: ca_gtint */
ca_gtint:
/* QL:         moveq   #M93_t.int,d0       M93_get integers */
    moveq #M93_t.int,d0
/* QL:         bra.s   M93_get */
    bra.s M93_get
/* QL: ca_gtfp */
ca_gtfp:
/* QL:         moveq   #M93_t.fp,d0        M93_get floating points */
    moveq #M93_t.fp,d0
/* QL:         bra.s   M93_get */
    bra.s M93_get
/* QL: ca_gtlin */
ca_gtlin:
/* QL:         moveq   #M93_t.fp-128,d0    M93_get floating points and make them long integers */
    moveq #(M93_t.fp-128),d0
/* QL: regon   reg     d0/d4/a4-a5 */
/* QL: regoff  reg     d1/d4/a4-a5 */
/* QL: M93_get */
M93_get:
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         move.l  M93_bv_rip(a6),a1   just in case we have no arguments */
    move.l M93_bv_rip(a6),a1
/* QL:         movem.l regon,-(sp) */
    movem.l d0/d4/a4-a5,-(sp)
/* QL:         bra.s   M93_nxtarg */
    bra.s M93_nxtarg
/* QL: M93_arg_loop */
M93_arg_loop:
/* QL:         moveq   #15,d4          mask out separator */
    moveq #15,d4
/* QL:         and.b   -7(a6,a5.l),d4 */
    and.b (-7)(a6,a5.l),d4
/* QL:         jsr     ca_etos(pc)     evaluate to top of stack */
    jsr ca_etos(pc)
/* QL:         bne.s   M93_retd0 */
    bne.s M93_retd0
/* QL:         move.l  (sp),d0 */
    move.l (sp),d0
/* QL:         jsr     ca_cnvrt(pc)    do the conversion */
    jsr ca_cnvrt(pc)
/* QL:         move.b  d4,-7(a6,a5.l)  and put original type back (why? unsafe? lwr) */
    move.b d4,(-7)(a6,a5.l)
/* QL:         tst.l   d0              check error return */
    tst.l d0
/* QL:         bne.s   M93_retd0 */
    bne.s M93_retd0
/* QL:         tst.b   (sp)            were we after long integers? */
    tst.b (sp)
/* QL:         bpl.s   M93_inc_arg */
    bpl.s M93_inc_arg
/* QL:         jsr     ri_lint(pc)     yes, convert them then */
    jsr ri_lint(pc)
/* QL:         bne.s   M93_retd0 */
    bne.s M93_retd0
/* QL:         move.l  a1,M93_bv_rip(a6) */
    move.l a1,M93_bv_rip(a6)
/* QL: M93_inc_arg */
M93_inc_arg:
/* QL:         addq.l  #1,d3 */
    addq.l #1,d3
/* QL:         subq.l  #8,a5 */
    subq.l #8,a5
/* QL: M93_nxtarg */
M93_nxtarg:
/* QL:         cmp.l   a3,a5           finished yet? */
    cmp.l a3,a5
/* QL:         bgt.s   M93_arg_loop */
    bgt.s M93_arg_loop
/* QL:         moveq   #0,d0           good return */
    moveq #0,d0
/* QL: M93_retd0 */
M93_retd0:
/* QL:         movem.l (sp)+,regoff    restore regs, discard top by putting in d1 */
    movem.l (sp)+,d1/d4/a4-a5
/* QL:         rts */
    rts 
/* QL:         end */
