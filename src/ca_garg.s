/* ROM section ca_garg */
.balign 2,0
/* QL: * Gets space in VV area and puts its VV offset into a name table entry. */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -ip - amount of room needed in VV heap */
/* QL: * d2 -  o- VV offset */
/* QL: * a1 -  o- RI stack */
/* QL: * a2 -  o- where to put value relative to a6 */
/* QL: * a5 -ip - pointer above name table entry to be set  */
/* QL: ca_chkvv */
ca_chkvv:
/* QL:         exg     a0,a2 */
    exg a2,a0
/* QL:         jsr     bv_alvv(pc)     also restores ri stack pointer */
    jsr bv_alvv(pc)
/* QL:         exg     a0,a2 */
    exg a2,a0
/* QL:         move.l  a2,d2 */
    move.l a2,d2
/* QL:         sub.l   M92_bv_vvbas(a6),d2 */
    sub.l M92_bv_vvbas(a6),d2
/* QL:         move.l  d2,-4(a6,a5.l)  store VV offset in name table */
    move.l d2,(-4)(a6,a5.l)
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code */
/* QL: * d1 -  o- next token type and number */
/* QL: * a0 -i o- pointer to first of list of parameters to evaluate */
/* QL: * a1 -  o- arithmetic stack pointer */
/* QL: * a5 -  o- top of name table */
/* QL: reglist reg     d2-d4/a2-a4 */
/* QL: M92_big.n   equ     361     break even string length to go for fast copy */
.equ M92_big.n,361
/* QL: * The break even point at which to go over to the fast copy routine was */
/* QL: * established by extensive testing... it may change if the fast copy is */
/* QL: * enhanced at all. It's a strangely elusive value to come by! */
/* QL: M92_arg_str */
M92_arg_str:
/* QL:         add.w   0(a6,a1.l),d1   get string length + 2 (msw is zero) */
    add.w 0(a6,a1.l),d1
/* QL:         bsr.s   ca_chkvv        get space to use */
    bsr.s ca_chkvv
/* QL:         addq.w  #1,d1           add one to round */
    addq.w #1,d1
/* QL:         bclr    d0,d1           round to even value */
    bclr d0,d1
/* QL:         cmp.w   #M92_big.n+3,d1     is this a rather long string? */
    cmp.w #(M92_big.n+3),d1
/* QL:         bls.s   M92_arg_move        no - go do a local move */
    bls.s M92_arg_move
/* QL:         exg     a2,a0           want destination in a0 */
    exg a0,a2
/* QL:         jsr     mm_mrtor(pc)    do a fast copy */
    jsr mm_mrtor(pc)
/* QL:         move.l  a2,a0 */
    move.l a2,a0
/* QL:         bra.s   M92_arg_add */
    bra.s M92_arg_add
/* QL: M92_arg_move */
M92_arg_move:
/* QL:         move.l  0(a6,a1.l),0(a6,a2.l) */
    move.l 0(a6,a1.l),0(a6,a2.l)
/* QL:         move.l  4(a6,a1.l),4(a6,a2.l) copy 8 bytes off RI stack into VV slot */
    move.l 4(a6,a1.l),4(a6,a2.l)
/* QL:         addq.l  #8,a1 */
    addq.l #8,a1
/* QL:         addq.l  #8,a2 */
    addq.l #8,a2
/* QL:         subq.l  #8,d1           is that the lot? */
    subq.l #8,d1
/* QL:         bgt.s   M92_arg_move        no - keep trucking */
    bgt.s M92_arg_move
/* QL:         bra.s   M92_arg_add */
    bra.s M92_arg_add
/* QL: ca_garg */
ca_garg:
/* QL:         movem.l reglist,-(sp) */
    movem.l d2-d4/a2-a4,-(sp)
/* QL:         sf      d4              initialise # flag to non-hash */
    sf d4
/* QL:         bra.s   M92_get_arg */
    bra.s M92_get_arg
/* QL: M92_arg_chk */
M92_arg_chk:
/* QL:         and.b   #15,-7(a6,a5.l) don't want any seps yet */
    and.b #(15&255),(-7)(a6,a5.l)
/* QL:         cmp.b   #M92_t.intern,-8(a6,a5.l) check msb of variable type */
    cmp.b #(M92_t.intern&255),(-8)(a6,a5.l)
/* QL:         bne.s   M92_arg_ok          not internal, so already set up */
    bne.s M92_arg_ok
/* QL: * An internal value is removed from the top of the arithmetic stack, copied */
/* QL: * into the variable values area and made to be a simple variable with no name. */
/* QL:         moveq   #M92_t.fp,d1        (n.b. also set d1=2 for 2-byte integer) */
    moveq #M92_t.fp,d1
/* QL:         cmp.b   -7(a6,a5.l),d1  string, fp or integer? */
    cmp.b (-7)(a6,a5.l),d1
/* QL:         blt.s   M92_arg_copy        ready for integer */
    blt.s M92_arg_copy
/* QL:         bne.s   M92_arg_str         go do a string */
    bne.s M92_arg_str
/* QL:         moveq   #6,d1           d1=6 for 6-byte fp */
    moveq #6,d1
/* QL: M92_arg_copy */
M92_arg_copy:
/* QL:         bsr.s   ca_chkvv        get space to use (always multiple of eight) */
    bsr.s ca_chkvv
/* QL:         move.l  2(a6,a1.l),2(a6,a2.l) copy mantissa (irrelevant if int) */
    move.l 2(a6,a1.l),2(a6,a2.l)
/* QL:         move.w  0(a6,a1.l),0(a6,a2.l) copy exponnent or integer */
    move.w 0(a6,a1.l),0(a6,a2.l)
/* QL: M92_arg_add */
M92_arg_add:
/* QL:         add.l   d1,a1           adjust RI stack pointer */
    add.l d1,a1
/* QL:         move.l  a1,M92_bv_rip(a6)   save it */
    move.l a1,M92_bv_rip(a6)
/* QL:         addq.b  #M92_t.var-M92_t.intern,-8(a6,a5.l) turn into a simple variable */
    addq.b #(M92_t.var-M92_t.intern),(-8)(a6,a5.l)
/* QL:         move.w  #-1,-6(a6,a5.l) make certain it has no name */
    move.w #(-1),(-6)(a6,a5.l)
/* QL: M92_arg_ok */
M92_arg_ok:
/* QL:         or.b    d4,-7(a6,a5.l)  put any hash flag into the variable type byte */
    or.b d4,(-7)(a6,a5.l)
/* QL:         sf      d4              clear the hash flag */
    sf d4
/* QL:         move.w  0(a6,a0.l),d1   put token type plus which token in d1 */
    move.w 0(a6,a0.l),d1
/* QL:         cmp.b   #M92_b.sep,0(a6,a0.l) separator next? */
    cmp.b #(M92_b.sep&255),0(a6,a0.l)
/* QL:         bne.s   M92_end_arg         no */
    bne.s M92_end_arg
/* QL:         lsl.b   #4,d1           move it up to top half of byte */
    lsl.b #4,d1
/* QL:         or.b    d1,-7(a6,a5.l)  put it into the variable type byte */
    or.b d1,(-7)(a6,a5.l)
/* QL: M92_nxt_arg */
M92_nxt_arg:
/* QL:         addq.l  #2,a0           step past hash or separator */
    addq.l #2,a0
/* QL: M92_get_arg */
M92_get_arg:
/* QL:         jsr     ca_expr(pc)     evaluate expression */
    jsr ca_expr(pc)
/* QL:         bgt.s   M92_arg_chk         genuine argument */
    bgt.s M92_arg_chk
/* QL:         bmi.s   M92_exit            wrong */
    bmi.s M92_exit
/* QL:         cmp.b   #M92_b.sep,0(a6,a0.l) is next token a separator? */
    cmp.b #(M92_b.sep&255),0(a6,a0.l)
/* QL:         bne.s   M92_try_hash        no - go see if it's a hash sign */
    bne.s M92_try_hash
/* QL:         jsr     ca_newnt(pc)    yes - build a new (null) name table entry */
    jsr ca_newnt(pc)
/* QL:         bra.s   M92_arg_ok */
    bra.s M92_arg_ok
/* QL: M92_try_hash */
M92_try_hash:
/* QL:         tas     d4              if hash, can't do anything yet, set flag */
    tas d4
/* QL:         move.w  0(a6,a0.l),d1   put token type plus which token in d1 */
    move.w 0(a6,a0.l),d1
/* QL:         cmp.w   #M92_w.hash,d1      well, is it a hash sign then? */
    cmp.w #M92_w.hash,d1
/* QL:         beq.s   M92_nxt_arg         yes, go get the argument itself */
    beq.s M92_nxt_arg
/* QL: M92_end_arg */
M92_end_arg:
/* QL:         moveq   #0,d0           (actually already zero, but must get ccr right) */
    moveq #0,d0
/* QL: M92_exit */
M92_exit:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d2-d4/a2-a4
/* QL:         rts */
    rts 
/* QL:         end */
