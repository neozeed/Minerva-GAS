/* ROM section ca_etos */
.balign 2,0
/* QL: * Evaluate current top of stack, guaranteeing a result on the RI stack. */
/* QL: * There is a problem to resolve here... is a1 guaranteed to match M90_bv_rip on */
/* QL: * entry? This rather assumes so in some cases, but not in others! */
/* QL: * A similar problem crops up with a5, and usage of ca_undo... */
/* QL: * d0 -  o- error return code */
/* QL: * a1 -i o- pointer to arithmetic stack */
/* QL: * a5 -i o- pointer to name table */
/* QL: * d1-d2/a4 destroyed */
/* QL: ca_etos */
ca_etos:
/* QL:         and.b   #15,-7(a6,a5.l) mask any seps which may have crept in */
    and.b #(15&255),(-7)(a6,a5.l)
/* QL:         assert  2,2&M90_t.var&M90_t.arr&M90_t.rep&M90_t.for */
/* original assertion: 2,2&M90_t.var&M90_t.arr&M90_t.rep&M90_t.for */
/* QL:         assert  0,2&(M90_t.unset!M90_t.intern!M90_t.bpr!M90_t.bfn!M90_t.mcp!M90_t.mcf) */
/* original assertion: 0,2&(M90_t.unset!M90_t.intern!M90_t.bpr!M90_t.bfn!M90_t.mcp!M90_t.mcf) */
/* QL:         assert  64,M90_t.intern<<6,256-M90_t.arr<<6 */
/* original assertion: 64,M90_t.intern<<6,256-M90_t.arr<<6 */
/* QL:         moveq   #64,d0          for sorting out intern/arry */
    moveq #64,d0
/* QL:         move.b  -8(a6,a5.l),d1  look at msb of variable type */
    move.b (-8)(a6,a5.l),d1
/* QL:         ror.b   #2,d1 */
    ror.b #2,d1
/* QL:         bcc.s   M90_qintern         divide into two sets */
    bcc.s M90_qintern
/* QL:         add.b   d1,d0 */
    add.b d1,d0
/* QL:         beq.s   M90_put_arry        array */
    beq.s M90_put_arry
/* QL: M90_put_item */
M90_put_item:
/* QL:         move.l  -4(a6,a5.l),d1  get vv offset */
    move.l (-4)(a6,a5.l),d1
/* QL:         blt.s   M90_ets_err         no value, that's an error */
    blt.s M90_ets_err
/* QL:         move.l  d1,a4 */
    move.l d1,a4
/* QL:         add.l   M90_bv_vvbas(a6),a4 make into rel a6 */
    add.l M90_bv_vvbas(a6),a4
/* QL:         cmp.b   #M90_t.fp,-7(a6,a5.l) check type */
    cmp.b #(M90_t.fp&255),(-7)(a6,a5.l)
/* QL:         bne.s   M90_put_qs          not floating point */
    bne.s M90_put_qs
/* QL: M90_put_fp */
M90_put_fp:
/* QL:         moveq   #6,d1           put a floating point (6 bytes) */
    moveq #6,d1
/* QL:         bsr.s   M90_chk_ri          make room */
    bsr.s M90_chk_ri
/* QL:         move.l  2(a6,a4.l),2(a6,a1.l) move mantissa */
    move.l 2(a6,a4.l),2(a6,a1.l)
/* QL:         bra.s   M90_ets_wrd */
    bra.s M90_ets_wrd
/* QL: M90_qintern */
M90_qintern:
/* QL:         sub.b   d1,d0 */
    sub.b d1,d0
/* QL:         beq.s   M90_ets_exit        if internal it's already on RI stack */
    beq.s M90_ets_exit
/* QL: M90_ets_err */
M90_ets_err:
/* QL:         moveq   #1,d2           undo anything */
    moveq #1,d2
/* QL:         bsr.l   ca_undo         remove the offending entry */
    bsr.w ca_undo
/* QL:         move.l  a5,M90_bv_ntp(a6)   and reset the NT pointer */
    move.l a5,M90_bv_ntp(a6)
/* QL:         moveq   #M90_err.xp,d0 */
    moveq #M90_err.xp,d0
/* QL:         rts */
    rts 
/* QL: M90_moreri */
M90_moreri:
/* QL:         move.l  d1,a1 */
    move.l d1,a1
/* QL:         jsr     bv_chrix(pc)    make room */
    jsr bv_chrix(pc)
/* QL:         move.l  a1,d1 */
    move.l a1,d1
/* QL: M90_chk_ri */
M90_chk_ri:
/* QL:         move.l  M90_bv_rip(a6),a1   set arithmetic stack pointer */
    move.l M90_bv_rip(a6),a1
/* QL:         sub.l   d1,a1 */
    sub.l d1,a1
/* QL:         cmp.l   M90_bv_rip-4(a6),a1 */
    cmp.l (M90_bv_rip-4)(a6),a1
/* QL:         blt.s   M90_moreri */
    blt.s M90_moreri
/* QL:         rts */
    rts 
/* QL: M90_put_qs */
M90_put_qs:
/* QL:         blt.s   M90_putst           go if item is a string */
    blt.s M90_putst
/* QL:         moveq   #2,d1           put an integer (2 bytes) */
    moveq #2,d1
/* QL:         bsr.s   M90_chk_ri */
    bsr.s M90_chk_ri
/* QL: M90_ets_wrd */
M90_ets_wrd:
/* QL:         move.w  0(a6,a4.l),d1 */
    move.w 0(a6,a4.l),d1
/* QL:         move.b  #M90_t.intern,-8(a6,a5.l) internal now */
    move.b #(M90_t.intern&255),(-8)(a6,a5.l)
/* QL: M90_ets_put */
M90_ets_put:
/* QL:         move.w  d1,0(a6,a1.l)  put integer (fp exponent) on RI stack */
    move.w d1,0(a6,a1.l)
/* QL: M90_ets_exit */
M90_ets_exit:
/* QL:         move.l  a1,M90_bv_rip(a6)   save arithmetic stack pointer */
    move.l a1,M90_bv_rip(a6)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M90_put_arry */
M90_put_arry:
/* QL:         move.l  -4(a6,a5.l),d1  fetch address of array descriptor */
    move.l (-4)(a6,a5.l),d1
/* QL:         add.l   M90_bv_vvbas(a6),d1 absolute */
    add.l M90_bv_vvbas(a6),d1
/* QL:         move.l  0(a6,d1.l),a4   find base address of array */
    move.l 0(a6,d1.l),a4
/* QL:         add.l   M90_bv_vvbas(a6),a4 absolute */
    add.l M90_bv_vvbas(a6),a4
/* QL:         movem.w 4(a6,d1.l),d0/d2 get dimensions and possible substring length */
    movem.w 4(a6,d1.l),d0/d2
/* QL:         subq.w  #1,d0           array must be one dimensional */
    subq.w #1,d0
/* QL:         bgt.s   M90_ets_err */
    bgt.s M90_ets_err
/* QL:         move.b  -7(a6,a5.l),d0  it must be a (sub)string */
    move.b (-7)(a6,a5.l),d0
/* QL:         subq.b  #M90_t.str,d0       check this */
    subq.b #M90_t.str,d0
/* QL:         bgt.s   M90_ets_err */
    bgt.s M90_ets_err
/* QL:         bsr.s   M90_fr_des          discard descriptor */
    bsr.s M90_fr_des
/* QL:         exg     d2,d1           put possible substring length in right reg */
    exg d2,d1
/* QL:         bne.s   M90_putss           it is a substring */
    bne.s M90_putss
/* QL: M90_putst */
M90_putst:
/* QL:         move.w  0(a6,a4.l),d1   find length of string (assumed non-negative) */
    move.w 0(a6,a4.l),d1
/* QL:         addq.l  #2,a4 */
    addq.l #2,a4
/* QL: M90_putss */
M90_putss:
/* QL:         move.w  #M90_t.intern<<8!M90_t.str,-8(a6,a5.l) becoming internal string now */
    move.w #((M90_t.intern<<8)|M90_t.str),(-8)(a6,a5.l)
/* QL: * Puts a sub-string on the RI stack. */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -i o- string length in lsw (if negative, made 0. msw destroyed) */
/* QL: * a1 -  o- RI stack */
/* QL: * a4 -i  - pointer to string characters (may be odd). */
/* QL: * d2 destroyed */
/* QL: ca_putss */
ca_putss:
/* QL:         ext.l   d1              want it long */
    ext.l d1
/* QL: * We don't really expect to be called with a negative length... */
/* QL: *       bpl.s   put_lok */
/* QL: *       moveq   #0,d1           just to be realy safe (lwr) */
/* QL: *put_lok */
/* QL:         addq.l  #2,d1           extra to store length and rely on even pointers */
    addq.l #2,d1
/* QL:         bsr.s   M90_chk_ri */
    bsr.s M90_chk_ri
/* QL:         subq.l  #2,d1           restore string length */
    subq.l #2,d1
/* QL:         beq.s   M90_ets_put         nothing to copy */
    beq.s M90_ets_put
/* QL:         moveq   #1,d2 */
    moveq #1,d2
/* QL:         and.b   d1,d2 */
    and.b d1,d2
/* QL:         sub.l   d2,a1           this is where it's going */
    sub.l d2,a1
/* QL:         add.l   d1,d2           length rounded up to even */
    add.l d1,d2
/* QL:         subq.l  #2,d2           check for 1/2 bytes only */
    subq.l #2,d2
/* QL:         bne.s   M90_put_sg2         not just an odd one or two bytes */
    bne.s M90_put_sg2
/* QL:         move.b  0(a6,a4.l),d2   get first byte */
    move.b 0(a6,a4.l),d2
/* QL:         rol.w   #8,d2           put it in msw */
    rol.w #8,d2
/* QL:         move.b  1(a6,a4.l),d2   get second byte, or junk */
    move.b 1(a6,a4.l),d2
/* QL:         move.w  d2,2(a6,a1.l)   put byte pair (we've allowed for 'ab'(2)) */
    move.w d2,2(a6,a1.l)
/* QL:         bra.s   M90_ets_put         finished */
    bra.s M90_ets_put
/* QL: * The above can be extended to cope with 1..4 bytes, should it seem too slow. */
/* QL: M90_put_sg2 */
M90_put_sg2:
/* QL:         exg     a0,a1           want destination in a0 */
    exg a1,a0
/* QL:         exg     a4,a1           want source in a1 */
    exg a1,a4
/* QL:         addq.l  #2,a0 */
    addq.l #2,a0
/* QL:         jsr     mm_mrtor(pc)    use the fast move */
    jsr mm_mrtor(pc)
/* QL:         subq.l  #2,a0 */
    subq.l #2,a0
/* QL:         exg     a4,a1 */
    exg a1,a4
/* QL:         exg     a0,a1 */
    exg a1,a0
/* QL:         bra.s   M90_ets_put */
    bra.s M90_ets_put
/* QL: * Free a string descriptor */
/* QL: * ccr-  o- result of "tst.l d0" */
/* QL: * d1 -i  - pointer to decriptor */
/* QL: M90_fr_des */
M90_fr_des:
/* QL:         move.l  a0,-(sp) */
    move.l a0,-(sp)
/* QL:         move.l  d1,a0           free from here */
    move.l d1,a0
/* QL:         moveq   #4+2+2+2,d1     this much space */
    moveq #(((4+2)+2)+2),d1
/* QL:         jsr     bv_frvv(pc) */
    jsr bv_frvv(pc)
/* QL:         move.l  (sp)+,a0 */
    move.l (sp)+,a0
/* QL:         rts */
    rts 
/* QL: * Undoes an entry on the name table and RI stack. */
/* QL: * z  -  o- if d2.l is zero, z is set iff a M90_t.intern gets undone */
/* QL: * d2 -ip - longword flag zero, only undo M90_t.intern, or non-zero, undo anything */
/* QL: * a5 -i o- NT stack */
/* QL: * d1 destroyed */
/* QL: ca_undo */
ca_undo:
/* QL:         moveq   #M90_t.intern,d1 */
    moveq #M90_t.intern,d1
/* QL:         sub.b   -8(a6,a5.l),d1 */
    sub.b (-8)(a6,a5.l),d1
/* QL:         beq.s   M90_undo_int */
    beq.s M90_undo_int
/* QL:         tst.l   d2              do non-int or stop at them? */
    tst.l d2
/* QL:         beq.s   M90_ret_undo        stop */
    beq.s M90_ret_undo
/* QL:         addq.b  #M90_t.arr-M90_t.intern,d1 do them */
.word 20481|((((M90_t.arr-M90_t.intern))&7)<<9)
/* QL:         bne.s   M90_nxt_un          if not an array, kill it off */
    bne.s M90_nxt_un
/* QL:         move.l  -4(a6,a5.l),d1  where is the copy descriptor? */
    move.l (-4)(a6,a5.l),d1
/* QL:         bmi.s   M90_nxt_un          isn't one */
    bmi.s M90_nxt_un
/* QL:         add.l   M90_bv_vvbas(a6),d1 */
    add.l M90_bv_vvbas(a6),d1
/* QL:         bsr.s   M90_fr_des          go and free the descriptor */
    bsr.s M90_fr_des
/* QL:         bra.s   M90_nxt_un */
    bra.s M90_nxt_un
/* QL: M90_undo_int */
M90_undo_int:
/* QL:         moveq   #15,d1 */
    moveq #15,d1
/* QL:         and.b   -7(a6,a5.l),d1 */
    and.b (-7)(a6,a5.l),d1
/* QL:         add.b   d1,d1           this is neatly ready for (M90_t.int-M90_t.fp)*2 = 2 */
    add.b d1,d1
/* QL:         subq.b  #M90_t.fp*2,d1      what is the variable type? */
    subq.b #(M90_t.fp*2),d1
/* QL:         bgt.s   M90_int_int         integer */
    bgt.s M90_int_int
/* QL:         beq.s   M90_int_fp          floating point */
    beq.s M90_int_fp
/* QL:         move.l  M90_bv_rip(a6),d1 */
    move.l M90_bv_rip(a6),d1
/* QL:         move.w  0(a6,d1.l),d1 */
    move.w 0(a6,d1.l),d1
/* QL:         ext.l   d1 */
    ext.l d1
/* QL:         subq.l  #6-3,d1 */
.word 20865|((((6-3))&7)<<9)
/* QL:         bclr    #0,d1           length of string + 2 for len and evened */
    bclr #0,d1
/* QL: M90_int_fp */
M90_int_fp:
/* QL:         addq.l  #6,d1           + 6 for fp */
    addq.l #6,d1
/* QL: M90_int_int */
M90_int_int:
/* QL:         add.l   d1,M90_bv_rip(a6)   also, guarantee non-z on return */
    add.l d1,M90_bv_rip(a6)
/* QL: M90_nxt_un */
M90_nxt_un:
/* QL:         subq.l  #8,a5 */
    subq.l #8,a5
/* QL: M90_ret_undo */
M90_ret_undo:
/* QL:         rts */
    rts 
/* QL:         end */
