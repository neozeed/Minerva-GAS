/* ROM section ca_eval */
.balign 2,0
/* QL: * Unravel NT from current position to initial position */
/* QL: M89_unrloop */
M89_unrloop:
/* QL:         jsr     ca_undo(pc) */
    jsr ca_undo(pc)
/* QL: M89_unravel */
M89_unravel:
/* QL:         cmp.l   d2,a5           finished yet? */
    cmp.l d2,a5
/* QL:         bne.s   M89_unrloop */
    bne.s M89_unrloop
/* QL:         subq.l  #2,sp */
    subq.l #2,sp
/* QL:         bra.s   M89_setntp */
    bra.s M89_setntp
/* QL: * Evaluate expression to push result of required type on RI stack */
/* QL: * d0 -i o- required type (ca_eval only) / -ve error, 0=null or 8=val, ccr set */
/* QL: * a0 -i o- pointer to expression to be evaluated */
/* QL: * a1 -  o- pointer to arithmetic stack */
/* QL: * a5 -  o- pointer to name table */
/* QL: * d1-d3/a3-a4 destroyed */
/* QL: ca_evali */
ca_evali:
/* QL:         moveq   #M89_t.int,d0       evaluate an integer */
    moveq #M89_t.int,d0
/* QL:         bra.s   ca_eval */
    bra.s ca_eval
/* QL: ca_evalc */
ca_evalc:
/* QL:         moveq   #M89_t.log,d0       evaluate a t/f condition (integer) */
    moveq #M89_t.log,d0
/* QL: ca_eval */
ca_eval:
/* QL:         move.b  d0,-(sp) */
    move.b d0,-(sp)
/* QL:         bsr.s   ca_expr         evaluate expression */
    bsr.s ca_expr
/* QL:         ble.s   M89_ev_exit         error or null */
    ble.s M89_ev_exit
/* QL:         jsr     ca_etos(pc)     now evaluate top of stack */
    jsr ca_etos(pc)
/* QL:         bne.s   M89_ev_exit         error or null */
    bne.s M89_ev_exit
/* QL:         move.b  (sp),d0         good */
    move.b (sp),d0
/* QL:         bne.s   M89_convert */
    bne.s M89_convert
/* QL:         moveq   #M89_t.str,d0 */
    moveq #M89_t.str,d0
/* QL: M89_convert */
M89_convert:
/* QL:         jsr     ca_cnvrt(pc)    M89_convert to type required if necessary */
    jsr ca_cnvrt(pc)
/* QL:         subq.l  #8,a5           remove type etc. from name table */
    subq.l #8,a5
/* QL: M89_setntp */
M89_setntp:
/* QL:         move.l  a5,M89_bv_ntp(a6) */
    move.l a5,M89_bv_ntp(a6)
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         bne.s   M89_ev_exit */
    bne.s M89_ev_exit
/* QL:         addq.l  #8,d0 */
    addq.l #8,d0
/* QL: M89_ev_exit */
M89_ev_exit:
/* QL:         addq.l  #2,sp */
    addq.l #2,sp
/* QL:         rts */
    rts 
/* QL: * Evaluates an expression pushing result as top of name table. */
/* QL: * d0 -  o- error code, 0 no expression (null) or 8 result pushed (ccr set) */
/* QL: * a0 -i o- pointer to expression to be evaluated */
/* QL: * a1 -  o- pointer to RI stack */
/* QL: * a5 -  o- pointer to name table */
/* QL: * d1-d3/a3-a4 destroyed */
/* QL: * Locally: */
/* QL: * d4 token value */
/* QL: * d5.b operator precedence and, for open parenthesis, 0=subscript or -1=expr */
/* QL: * a1 maintained as RI pointer, to avoid keep changing it about. */
/* QL: ca_expr */
ca_expr:
/* QL:         move.l  M89_bv_ntp(a6),a5 */
    move.l M89_bv_ntp(a6),a5
/* QL:         move.l  a5,a1 */
    move.l a5,a1
/* QL:         sub.l   M89_bv_ntbas(a6),a1 in case of movement */
    sub.l M89_bv_ntbas(a6),a1
/* QL:         movem.l d4-d6/a1,-(sp)  save working registers and NT offset */
    movem.l d4-d6/a1,-(sp)
/* QL:         jsr     bv_chss(pc) */
    jsr bv_chss(pc)
/* QL:         move.l  M89_bv_rip(a6),a1   pick up current RI pointer, maintained in a1 */
    move.l M89_bv_rip(a6),a1
/* QL:         st      d5              mark top of stack */
    st d5
/* QL:         bra.s   M89_put_op1 */
    bra.s M89_put_op1
/* QL: M89_indexer */
M89_indexer:
/* QL:         pea     M89_ind_tkq */
    pea M89_ind_tkq(pc)
/* QL:         cmp.b   #M89_t.arr,-8(a6,a5.l) it's an index, what sort ? */
    cmp.b #(M89_t.arr&255),(-8)(a6,a5.l)
/* QL:         beq.l   ca_indx         array index */
    beq.w ca_indx
/* QL:         jmp     ca_stind(pc)    string index */
    jmp ca_stind(pc)
/* QL: M89_oparen */
M89_oparen:
/* QL:         tst.b   d5              what are we expecting? */
    tst.b d5
/* QL:         bne.s   M89_indexer         not a normal expression */
    bne.s M89_indexer
/* QL:         bsr.s   ca_expr         evaluate expression */
    bsr.s ca_expr
/* QL:         ble.s   M89_err_qq0 */
    ble.s M89_err_qq0
/* QL:         jsr     ca_etos(pc)     now evaluate top of stack */
    jsr ca_etos(pc)
/* QL: M89_errne */
M89_errne:
/* QL:         bne.s   M89_err_qq0 */
    bne.s M89_err_qq0
/* QL:         addq.l  #2,a0 */
    addq.l #2,a0
/* QL:         cmp.w   #M89_w.cpar,-2(a6,a0.l) should have been close parenthesis */
    cmp.w #M89_w.cpar,(-2)(a6,a0.l)
/* QL:         beq.l   M89_ind_tok         if next token wasn't a ) then it's an error */
    beq.w M89_ind_tok
/* QL: M89_err_qq0 */
M89_err_qq0:
/* QL:         bra.l   M89_err_qq */
    bra.w M89_err_qq
/* QL: * Precedence */
/* QL: M89_pr_tab */
M89_pr_tab:
/* QL:         dc.b    5,5             + -     plus/minus, dyadic */
M89_dc_anchor_1216:
.byte (5)&255
.byte (5)&255
/* QL:         dc.b    6,6             * /     multiply/divide */
M89_dc_anchor_1220:
.byte (6)&255
.byte (6)&255
/* QL:         dc.b    4,4,4,4,4,4,4   >= > == = <> <= <  relational operators */
M89_dc_anchor_1224:
.byte (4)&255
.byte (4)&255
.byte (4)&255
.byte (4)&255
.byte (4)&255
.byte (4)&255
.byte (4)&255
/* QL:         dc.b    1,2,1           || && ^^ bitwise or/and/xor */
M89_dc_anchor_1233:
.byte (1)&255
.byte (2)&255
.byte (1)&255
/* QL:         dc.b    7               ^       raise to the power of */
M89_dc_anchor_1238:
.byte (7)&255
/* QL:         dc.b    9               &       concatenate */
M89_dc_anchor_1241:
.byte (9)&255
/* QL:         dc.b    1,2,1           or and xor logical */
M89_dc_anchor_1244:
.byte (1)&255
.byte (2)&255
.byte (1)&255
/* QL:         dc.b    6,6             mod div interger modulus/divide */
M89_dc_anchor_1249:
.byte (6)&255
.byte (6)&255
/* QL:         dc.b    8               instr   posn of one string inside another */
M89_dc_anchor_1253:
.byte (8)&255
/* QL:         dc.b    11,11           - +     minus/plus monadic */
M89_dc_anchor_1256:
.byte (11)&255
.byte (11)&255
/* QL:         dc.b    3,3             ~~ not  bitwise not logical not */
M89_dc_anchor_1260:
.byte (3)&255
.byte (3)&255
/* QL:         ds.w    0 */
.balign 2,0
/* QL: * Evaluation loop, executing stacked operations */
/* QL: M89_ev_loop */
M89_ev_loop:
/* QL:         move.w  (sp)+,d4        fetch operation */
    move.w (sp)+,d4
/* QL:         jsr     ca_opexe(pc)    go execute the operation */
    jsr ca_opexe(pc)
/* QL:         move.l  a1,M89_bv_rip(a6)   a1 is correct, even on error report */
    move.l a1,M89_bv_rip(a6)
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: M89_ev_tst */
M89_ev_tst:
/* QL:         bne.s   M89_errne */
    bne.s M89_errne
/* QL:         cmp.b   (sp),d5         check priority on stack */
    cmp.b (sp),d5
/* QL:         ble.s   M89_ev_loop         if current priority less or equal, do it */
    ble.s M89_ev_loop
/* QL: M89_put_op */
M89_put_op:
/* QL:         swap    d4              restore d4 lower half */
    swap d4
/* QL: M89_put_op1 */
M89_put_op1:
/* QL:         move.w  d4,-(sp)        put operator on stack */
    move.w d4,-(sp)
/* QL:         move.b  d5,(sp)         put priority onto stack */
    move.b d5,(sp)
/* QL:         sf      d5              opening parenthesis = sub-expression, no dyadic */
    sf d5
/* QL:         bne.l   M89_read_tok        carry on if it wasn't zero (end) */
    bne.w M89_read_tok
/* QL:         addq.l  #2,sp           lose the end flag off the stack */
    addq.l #2,sp
/* QL: M89_end_1 */
M89_end_1:
/* QL:         addq.l  #2,sp           remove marker from stack */
    addq.l #2,sp
/* QL:         bsr.s   M89_popwrk          restore working registers */
    bsr.s M89_popwrk
/* QL:         move.l  a5,d0 */
    move.l a5,d0
/* QL:         sub.l   d2,d0           was anything of any interest read? */
    sub.l d2,d0
/* QL:         rts */
    rts 
/* QL: M89_op_equ */
M89_op_equ:
/* QL:         addq.b  #M89_b.eq,d4        replace symbol = by operator = */
    addq.b #M89_b.eq,d4
/* QL:         bra.s   M89_op_now */
    bra.s M89_op_now
/* QL: M89_tok_sym */
M89_tok_sym:
/* QL: M89_tok_proc equ    M89_tok_sym-M89_b.equal at least we can have d4 nice for one token */
.equ M89_tok_proc,(M89_tok_sym-M89_b.equal)
/* QL:         sub.b   -1(a6,a0.l),d4  check for = as in print (1)=1 */
    sub.b (-1)(a6,a0.l),d4
/* QL:         beq.s   M89_op_equ          yes, replace it by the operator */
    beq.s M89_op_equ
/* QL:         addq.b  #M89_b.opar-M89_b.equal,d4 check for open parenthesis */
.word 20484|((((M89_b.opar-M89_b.equal))&7)<<9)
/* QL:         beq.s   M89_oparen          yes, go sort that out */
    beq.s M89_oparen
/* QL: M89_tok_key */
M89_tok_key:
/* QL: M89_tok_sep */
M89_tok_sep:
/* QL:         subq.l  #2,a0           we're not going past this token */
    subq.l #2,a0
/* QL:         sf      d5              evaluate back to start of expression */
    sf d5
/* QL:         tst.b   (sp)            check if any pending operators */
    tst.b (sp)
/* QL:         bpl.s   M89_eval_tsb        yes - have to action them */
    bpl.s M89_eval_tsb
/* QL:         bra.s   M89_end_1 */
    bra.s M89_end_1
/* QL: M89_tok_mon */
M89_tok_mon:
/* QL:         moveq   #M89_mon.off,d4     add offset to mono-operator */
    moveq #M89_mon.off,d4
/* QL:         add.b   -1(a6,a0.l),d4 */
    add.b (-1)(a6,a0.l),d4
/* QL:         move.b  M89_pr_tab-1(pc,d4.w),d5 set up priority */
    move.b (M89_pr_tab-1)(pc,d4.w),d5
/* QL:         bra.s   M89_put_op1 */
    bra.s M89_put_op1
/* QL: M89_tok_ops */
M89_tok_ops:
/* QL:         move.b  -1(a6,a0.l),d4  fetch operator type */
    move.b (-1)(a6,a0.l),d4
/* QL: M89_op_now */
M89_op_now:
/* QL:         tst.b   d5              check if expecting an operator */
    tst.b d5
/* QL:         beq.s   M89_err_xp */
    beq.s M89_err_xp
/* QL:         move.b  M89_pr_tab-1(pc,d4.w),d5 set up priority */
    move.b (M89_pr_tab-1)(pc,d4.w),d5
/* QL:         swap    d4              save d4 lower half */
    swap d4
/* QL: M89_eval_tsb */
M89_eval_tsb:
/* QL:         pea     M89_ev_tst */
    pea M89_ev_tst(pc)
/* QL: M89_etos */
M89_etos:
/* QL:         jmp     ca_etos(pc)     evaluate top of stack */
    jmp ca_etos(pc)
/* QL: M89_err_qq */
M89_err_qq:
/* QL:         bmi.s   M89_errlp */
    bmi.s M89_errlp
/* QL: M89_tok_bip */
M89_tok_bip:
/* QL: M89_tok_bif */
M89_tok_bif:
/* QL: M89_tok_syv */
M89_tok_syv:
/* QL: M89_tok_txt */
M89_tok_txt:
/* QL: M89_tok_lno */
M89_tok_lno:
/* QL: M89_tok_bad */
M89_tok_bad:
/* QL: M89_err_xp */
M89_err_xp:
/* QL:         moveq   #M89_err.xp,d0 */
    moveq #M89_err.xp,d0
/* QL: M89_errlp */
M89_errlp:
/* QL:         tst.b   (sp)+           try to find top of stack */
    tst.b (sp)+
/* QL:         bpl.s   M89_errlp */
    bpl.s M89_errlp
/* QL:         pea     M89_unravel         after restoring working (d2 is saved ntp) */
    pea M89_unravel(pc)
/* QL: M89_popwrk */
M89_popwrk:
/* QL:         movem.l (sp)+,d2/d4-d6/a3 return / working registers / saved ntp offset */
    movem.l (sp)+,d2/d4-d6/a3
/* QL:         add.l   M89_bv_ntbas(a6),a3 in case of movement */
    add.l M89_bv_ntbas(a6),a3
/* QL:         exg     d2,a3 */
    exg d2,a3
/* QL:         jmp     (a3) */
    jmp (a3)
/* QL: M89_tok_shi */
M89_tok_shi:
/* QL:         move.b  -1(a6,a0.l),d4 */
    move.b (-1)(a6,a0.l),d4
/* QL:         ext.w   d4 */
    ext.w d4
/* QL: M89_shlgi */
M89_shlgi:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         bsr.l   M89_moreri */
    bsr.w M89_moreri
/* QL:         move.w  d4,0(a6,a1.l) */
    move.w d4,0(a6,a1.l)
/* QL:         move.w  #M89_t.intern<<8+M89_t.int,d4 */
    move.w #((M89_t.intern<<8)+M89_t.int),d4
/* QL: M89_setri */
M89_setri:
/* QL:         move.l  a1,M89_bv_rip(a6)   store new arithmetic stack pointer */
    move.l a1,M89_bv_rip(a6)
/* QL:         bsr.l   ca_newnt */
    bsr.w ca_newnt
/* QL:         move.w  d4,-8(a6,a5.l)  put in type */
    move.w d4,(-8)(a6,a5.l)
/* QL: M89_ind_tok */
M89_ind_tok:
/* QL:         st      d5              operator ok and open parenthesis means index */
    st d5
/* QL: M89_tok_spc */
M89_tok_spc:
/* QL: M89_read_tok */
M89_read_tok:
/* QL:         moveq   #31,d4          note d4 msb's zero */
    moveq #31,d4
/* QL:         and.b   0(a6,a0.l),d4   ignore 3 msbit's while fetching token type */
    and.b 0(a6,a0.l),d4
/* QL:         addq.l  #2,a0           we often move past the token... */
    addq.l #2,a0
/* QL:         move.b  M89_tok_tab(pc,d4.w),d4 */
    move.b M89_tok_tab(pc,d4.w),d4
/* QL:         jmp     M89_tok_proc(pc,d4.w) go to code for token */
.word 0x4efb
.word 16384|((M89_tok_proc-.)&255)
/* QL: M89_tok_lgi */
M89_tok_lgi:
/* QL:         addq.l  #2,a0           long integer takes four bytes */
    addq.l #2,a0
/* QL:         move.w  -2(a6,a0.l),d4 */
    move.w (-2)(a6,a0.l),d4
/* QL:         bra.s   M89_shlgi */
    bra.s M89_shlgi
/* QL: M89_tok_str */
M89_tok_str:
/* QL:         move.w  0(a6,a0.l),d1   get length */
    move.w 0(a6,a0.l),d1
/* QL:         addq.l  #2,a0           step over length */
    addq.l #2,a0
/* QL:         move.l  a0,a4           set source pointer */
    move.l a0,a4
/* QL:         add.w   d1,a0           step past chars */
    add.w d1,a0
/* QL:         moveq   #1,d2 */
    moveq #1,d2
/* QL:         and.w   d1,d2 */
    and.w d1,d2
/* QL:         add.w   d2,a0           round up odd byte */
    add.w d2,a0
/* QL:         jsr     ca_putss(pc)    put sub-string on stack */
    jsr ca_putss(pc)
/* QL:         bsr.l   ca_newnt */
    bsr.w ca_newnt
/* QL:         move.w  #M89_t.intern<<8+M89_t.str,-8(a6,a5.l) put in type */
    move.w #((M89_t.intern<<8)+M89_t.str),(-8)(a6,a5.l)
/* QL:         bra.s   M89_ind_tok         we've just read a string, so we allow index */
    bra.s M89_ind_tok
/* QL: M89_tok_fp */
M89_tok_fp:
/* QL:         addq.l  #4,a0           step past rest of fp */
    addq.l #4,a0
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         bsr.s   M89_moreri */
    bsr.s M89_moreri
/* QL:         movem.w -6(a6,a0.l),d0-d2 */
    movem.w (-6)(a6,a0.l),d0-d2
/* QL:         and.w   #$0fff,d0       remove token flag */
    and.w #0x0fff,d0
/* QL:         movem.w d0-d2,0(a6,a1.l) */
    movem.w d0-d2,0(a6,a1.l)
/* QL:         move.w  #M89_t.intern<<8+M89_t.fp,d4 */
    move.w #((M89_t.intern<<8)+M89_t.fp),d4
/* QL:         bra.s   M89_setri */
    bra.s M89_setri
/* QL: M89_tok_nam */
M89_tok_nam:
/* QL:         addq.l  #2,a0           step past name bit */
    addq.l #2,a0
/* QL:         bsr.s   ca_newnt        create new name table entry */
    bsr.s ca_newnt
/* QL:         move.w  -2(a6,a0.l),d4  get name number, ie pos. in name table */
    move.w (-2)(a6,a0.l),d4
/* QL:         move.l  d4,d0 */
    move.l d4,d0
/* QL:         lsl.l   #3,d0 */
    lsl.l #3,d0
/* QL:         move.l  d0,a3 */
    move.l d0,a3
/* QL:         add.l   M89_bv_ntbas(a6),a3 name table entry */
    add.l M89_bv_ntbas(a6),a3
/* QL:         move.b  0(a6,a3.l),d0   get name type */
    move.b 0(a6,a3.l),d0
/* QL:         subq.b  #M89_t.bpr,d0       is name type fairly simple? */
    subq.b #M89_t.bpr,d0
/* QL:         bmi.s   M89_dosimp1         yes - go do simple stuff */
    bmi.s M89_dosimp1
/* QL:         asl.b   #6,d0           this checks for rep/for loop index ... */
    asl.b #6,d0
/* QL: M89_dosimp1 */
M89_dosimp1:
/* QL:         bmi.s   M89_dosimp          ... this'll do (d4.b = $80 or $c0 now) */
    bmi.s M89_dosimp
/* QL:         beq.s   M89_err_qq1         ... even gets M89_t.bpr/t.mcpr sorted */
    beq.s M89_err_qq1
/* QL:         scs     d0              d0.b = 0 for basic or $ff for m/c */
    scs d0
/* QL:         jsr     ca_fun(pc)      go call the function */
    jsr ca_fun(pc)
/* QL: * I trust that this leave a1/M89_bv_rip(a6) correct. (M/c definate, deffn?) */
/* QL: M89_ind_tkq */
M89_ind_tkq:
/* QL:         beq.s   M89_ind_tok         if ok, get the next token */
    beq.s M89_ind_tok
/* QL: M89_err_qq1 */
M89_err_qq1:
/* QL:         bra.l   M89_err_qq          failed */
    bra.w M89_err_qq
/* QL: M89_tok_tab */
M89_tok_tab:
/* QL:         dc.b    M89_tok_spc-M89_tok_proc */
M89_dc_anchor_1553:
.byte ((M89_tok_spc-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_key-M89_tok_proc */
M89_dc_anchor_1556:
.byte ((M89_tok_key-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_bip-M89_tok_proc */
M89_dc_anchor_1559:
.byte ((M89_tok_bip-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_bif-M89_tok_proc */
M89_dc_anchor_1562:
.byte ((M89_tok_bif-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_sym-M89_tok_proc */
M89_dc_anchor_1565:
.byte ((M89_tok_sym-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_ops-M89_tok_proc */
M89_dc_anchor_1568:
.byte ((M89_tok_ops-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_mon-M89_tok_proc */
M89_dc_anchor_1571:
.byte ((M89_tok_mon-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_syv-M89_tok_proc */
M89_dc_anchor_1574:
.byte ((M89_tok_syv-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_nam-M89_tok_proc */
M89_dc_anchor_1577:
.byte ((M89_tok_nam-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_shi-M89_tok_proc */
M89_dc_anchor_1580:
.byte ((M89_tok_shi-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_lgi-M89_tok_proc */
M89_dc_anchor_1583:
.byte ((M89_tok_lgi-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_str-M89_tok_proc */
M89_dc_anchor_1586:
.byte ((M89_tok_str-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_txt-M89_tok_proc */
M89_dc_anchor_1589:
.byte ((M89_tok_txt-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_lno-M89_tok_proc */
M89_dc_anchor_1592:
.byte ((M89_tok_lno-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_sep-M89_tok_proc */
M89_dc_anchor_1595:
.byte ((M89_tok_sep-M89_tok_proc))&255
/* QL:         dc.b    M89_tok_bad-M89_tok_proc */
M89_dc_anchor_1598:
.byte ((M89_tok_bad-M89_tok_proc))&255
/* QL:         dcb.b   16,M89_tok_fp-M89_tok_proc */
.rept 16
.byte (M89_tok_fp-M89_tok_proc)
.endr
/* QL: * Make space for literal int/fp */
/* QL: M89_moreri */
M89_moreri:
/* QL:         cmp.l   M89_bv_rip-4(a6),a1 is RI pointer ok? */
    cmp.l (M89_bv_rip-4)(a6),a1
/* QL:         bge.s   M89_rts0            yes - great! */
    bge.s M89_rts0
/* QL:         sub.l   M89_bv_rip(a6),a1   keep a1 as -ve space wanted */
    sub.l M89_bv_rip(a6),a1
/* QL:         move.l  a1,d1 */
    move.l a1,d1
/* QL:         neg.l   d1              d1 is now the space we want */
    neg.l d1
/* QL:         jsr     bv_chrix(pc)    get the space */
    jsr bv_chrix(pc)
/* QL:         add.l   M89_bv_rip(a6),a1   put a1 ready at requested point */
    add.l M89_bv_rip(a6),a1
/* QL: M89_rts0 */
M89_rts0:
/* QL:         rts */
    rts 
/* QL: * Re-use a spare name table entry, or create a new one and set it up as null */
/* QL: * This used to be nicer, before a bug came up. It is now not allowed to back */
/* QL: * up across named entries, otherwise the order of the name list entries can */
/* QL: * disagree with the order in the name table, causing a screwup in NEW. There */
/* QL: * are at least two ways round this, being either to make the name entry be */
/* QL: * insertion sorted in the right place, or to make new accept the unmatched */
/* QL: * sequence. The former would require a little code but the latter would be */
/* QL: * marvellous, if it we're darned nigh impossible! We cop out... */
/* QL: * d0 -  o- 0 */
/* QL: * d2 -  o- -1 */
/* QL: * a1 -  o- RI stack pointer */
/* QL: * a5 -  o- top of new name table entry */
/* QL: * d0-d1 destroyed */
/* QL: ca_oldnt */
ca_oldnt:
/* QL:         movem.l M89_bv_ntbas(a6),a1/a5 */
    movem.l M89_bv_ntbas(a6),a1/a5
/* QL: M89_oldnext */
M89_oldnext:
/* QL:         cmp.l   a1,a5 */
    cmp.l a1,a5
/* QL:         beq.s   ca_newnt        no spare entries, so add at top */
    beq.s ca_newnt
/* QL:         move.l  -8(a6,a5.l),d0 */
    move.l (-8)(a6,a5.l),d0
/* QL:         beq.s   M89_set_nt          re-use a spare entry (d0.l=0) */
    beq.s M89_set_nt
/* QL:         subq.l  #8,a5 */
    subq.l #8,a5
/* QL:         tst.w   d0 */
    tst.w d0
/* QL:         bmi.s   M89_oldnext         can't back across named entries (see above) */
    bmi.s M89_oldnext
/* QL: *       bra.s   ca_newnt */
/* QL: * Create a new name table entry and set it up as null */
/* QL: * d0 -  o- 0 (ccr set) */
/* QL: * d2 -  o- -1 */
/* QL: * a1 -  o- RI stack pointer */
/* QL: * a5 -  o- top of new name table entry */
/* QL: * d1 destroyed */
/* QL: ca_newnt */
ca_newnt:
/* QL:         jsr     bv_chnt(pc)     check room for at least one more */
    jsr bv_chnt(pc)
/* QL:         addq.l  #8,M89_bv_ntp(a6)   we can get the space */
    addq.l #8,M89_bv_ntp(a6)
/* QL:         move.l  M89_bv_ntp(a6),a5   get new name table entry address */
    move.l M89_bv_ntp(a6),a5
/* QL: M89_set_nt */
M89_set_nt:
/* QL:         moveq   #-1,d2 */
    moveq #(-1),d2
/* QL:         move.l  d2,-4(a6,a5.l)  no value */
    move.l d2,(-4)(a6,a5.l)
/* QL:         move.w  d2,-6(a6,a5.l)  unnamed */
    move.w d2,(-6)(a6,a5.l)
/* QL:         clr.w   -8(a6,a5.l)     null type */
    clr.w (-8)(a6,a5.l)
/* QL:         move.l  M89_bv_rip(a6),a1   reload RI stack pointer */
    move.l M89_bv_rip(a6),a1
/* QL:         rts */
    rts 
/* QL: * Process simple variables */
/* QL: M89_dosimp */
M89_dosimp:
/* QL:         move.w  0(a6,a3.l),-8(a6,a5.l) copy entry */
    move.w 0(a6,a3.l),(-8)(a6,a5.l)
/* QL:         moveq   #15,d1          separator mask and clear msw */
    moveq #15,d1
/* QL:         and.b   d1,-7(a6,a5.l)  don't including any separator */
    and.b d1,(-7)(a6,a5.l)
/* QL:         move.w  d4,-6(a6,a5.l)  point at original name entry */
    move.w d4,(-6)(a6,a5.l)
/* QL:         move.l  4(a6,a3.l),a3   pick up value pointer */
    move.l 4(a6,a3.l),a3
/* QL:         addq.b  #M89_t.bpr-M89_t.arr,d0 is name type array? */
.word 20480|((((M89_t.bpr-M89_t.arr))&7)<<9)
/* QL:         beq.s   M89_dup_desc        yes - need to duplicate the descriptor */
    beq.s M89_dup_desc
/* QL:         move.l  a3,-4(a6,a5.l)  store duplicate value pointer */
    move.l a3,(-4)(a6,a5.l)
/* QL: M89_ind_tk2 */
M89_ind_tk2:
/* QL:         bra.l   M89_ind_tok         go get next */
    bra.w M89_ind_tok
/* QL: M89_dup_desc */
M89_dup_desc:
/* QL:         move.l  a3,d0           check pointer to descriptor */
    move.l a3,d0
/* QL:         blt.l   M89_err_xp          it hasn't been dimensioned!! */
    blt.w M89_err_xp
/* QL:         add.l   M89_bv_vvbas(a6),a3 actual descriptor pointer */
    add.l M89_bv_vvbas(a6),a3
/* QL:         move.w  4(a6,a3.l),d1   number of dimensions */
    move.w 4(a6,a3.l),d1
/* QL:         lsl.l   #2,d1           two words per dimension */
    lsl.l #2,d1
/* QL:         addq.l  #4+2,d1         plus value offset and dimesion count */
    addq.l #(4+2),d1
/* QL:         move.l  a2,-(sp)        save new descriptor register */
    move.l a2,-(sp)
/* QL:         jsr     ca_chkvv(pc)    find space for a copy (offset done & a1 reset) */
    jsr ca_chkvv(pc)
/* QL: M89_arr_loop */
M89_arr_loop:
/* QL:         move.l  0(a6,a3.l),0(a6,a2.l) copy descriptor, longword at a time */
    move.l 0(a6,a3.l),0(a6,a2.l)
/* QL:         addq.l  #4,a3 */
    addq.l #4,a3
/* QL:         addq.l  #4,a2 */
    addq.l #4,a2
/* QL:         subq.l  #4,d1 */
    subq.l #4,d1
/* QL:         bpl.s   M89_arr_loop */
    bpl.s M89_arr_loop
/* QL:         move.l  (sp)+,a2        no longer need new descriptor pointer */
    move.l (sp)+,a2
/* QL:         bra.s   M89_ind_tk2 */
    bra.s M89_ind_tk2
/* QL:         vect4000 ca_eval */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ ca$eval,(ca_eval-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
