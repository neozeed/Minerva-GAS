/* ROM section ib_dim */
.balign 2,0
/* QL: * d0 -  o- error code */
/* QL: * a4 -i o- program file */
/* QL: * d1-d6/a0-a3/a5 destroyed */
/* QL: ib_dim */
ib_dim:
/* QL:         subq.l  #2,a4 */
    subq.l #2,a4
/* QL: M164_nx_array */
M164_nx_array:
/* QL:         jsr     ib_s2non(pc)    skip DIM or comma and get name of array */
    jsr ib_s2non(pc)
/* QL:         moveq   #8,d4 */
    moveq #8,d4
/* QL:         mulu    2(a6,a4.l),d4 */
    mulu 2(a6,a4.l),d4
/* QL:         move.l  M164_bv_ntbas(a6),a2 */
    move.l M164_bv_ntbas(a6),a2
/* QL:         add.l   d4,a2 */
    add.l d4,a2
/* QL:         jsr     ca_frvar(pc)    free it straight off - stops fragmentation */
    jsr ca_frvar(pc)
/* QL:         jsr     ib_s4non(pc)    skip the name and get to the open parenthesis */
    jsr ib_s4non(pc)
/* QL:         bsr.s   ib_mkdim        make the dimensions */
    bsr.s ib_mkdim
/* QL:         bne.s   M164_rts0 */
    bne.s M164_rts0
/* QL:         jsr     ib_nxnon(pc)    get next non-space */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   #M164_w.symcom,d1    is it a comma? */
    cmp.w #M164_w.symcom,d1
/* QL:         beq.s   M164_nx_array        yes, there's another array to come */
    beq.s M164_nx_array
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M164_rts0 */
M164_rts0:
/* QL:         rts */
    rts 
/* QL: * The dimensions used to be stored at M164_bv_bfbas while they were scanned. This */
/* QL: * horrendous practice has been replaced by just leaving them to build up on */
/* QL: * the ri stack, which is perfectly safe. lwr. */
/* QL: M164_dim_xp */
M164_dim_xp:
/* QL:         moveq   #M164_err.xp,d0 */
    moveq #M164_err.xp,d0
/* QL: M164_dim_stop */
M164_dim_stop:
/* QL:         add.l   d5,M164_bv_rip(a6)   discard stacked dimensions */
    add.l d5,M164_bv_rip(a6)
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: * d0 -  o- worked (0) or failed */
/* QL: * a2 -i  - vv ptr to name being dimensioned (global cleared or local new entry) */
/* QL: * a4 -i o- program file pointer. start at open, end past close parentheses. */
/* QL: * d1-d6/a0-a3/a5 destroyed */
/* QL: ib_mkdim */
ib_mkdim:
/* QL:         move.l  M164_bv_ntbas(a6),d4 */
    move.l M164_bv_ntbas(a6),d4
/* QL:         sub.l   a2,d4           save nt offset (negated) */
    sub.l a2,d4
/* QL:         moveq   #0,d5           start no of dim at zero (will count in 2's) */
    moveq #0,d5
/* QL: M164_getdim */
M164_getdim:
/* QL:         addq.l  #2,a4           skip over the open parenthesis or comma */
    addq.l #2,a4
/* QL:         move.l  a4,a0           for evaluation */
    move.l a4,a0
/* QL:         jsr     ca_evali(pc)    dimensions must be integer */
    jsr ca_evali(pc)
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         bmi.s   M164_dim_stop */
    bmi.s M164_dim_stop
/* QL:         addq.l  #2,d5           no of dimensions has just gone up */
    addq.l #2,d5
/* QL:         move.w  0(a6,a4.l),d0   get expr stop token */
    move.w 0(a6,a4.l),d0
/* QL:         sub.w   #M164_w.symcom,d0 */
    sub.w #M164_w.symcom,d0
/* QL:         beq.s   M164_getdim          if a comma, more dimensions */
    beq.s M164_getdim
/* QL:         addq.l  #2,a4           skip it */
    addq.l #2,a4
/* QL:         subq.w  #M164_w.cpar-M164_w.symcom,d0  */
.word 20800|((((M164_w.cpar-M164_w.symcom))&7)<<9)
/* QL:         bne.s   M164_dim_xp          end of dims must be a close parenthesis */
    bne.s M164_dim_xp
/* QL: * That's the interpreting side over with, now allocate the new descriptor */
/* QL:         move.l  d5,d1 */
    move.l d5,d1
/* QL:         add.l   d1,d1 */
    add.l d1,d1
/* QL:         addq.l  #6,d1 */
    addq.l #6,d1
/* QL:         jsr     bv_alvv(pc)     allocate new descriptor & set a1=M164_bv_rip(a6) */
    jsr bv_alvv(pc)
/* QL:         bsr.s   M164_dim_stop        discard stack entries */
    bsr.s M164_dim_stop
/* QL:         move.l  a0,a5 */
    move.l a0,a5
/* QL:         add.l   d5,a5 */
    add.l d5,a5
/* QL:         add.l   d5,a5           point to top of descriptor, less 6 bytes */
    add.l d5,a5
/* QL:         lsr.l   #1,d5           make this the proper dimension count */
    lsr.l #1,d5
/* QL:         move.w  d5,4(a6,a0.l)   store it now, in case we get problems */
    move.w d5,4(a6,a0.l)
/* QL: * New descriptor ready. Construct its details. */
/* QL:         move.l  M164_bv_ntbas(a6),a3 base of name table */
    move.l M164_bv_ntbas(a6),a3
/* QL:         sub.l   d4,a3           point at entry */
    sub.l d4,a3
/* QL:         moveq   #M164_err.bn,d0 */
    moveq #M164_err.bn,d0
/* QL:         cmp.b   #M164_t.arr,0(a6,a3.l) i suppose this is an array...? */
    cmp.b #(M164_t.arr&255),0(a6,a3.l)
/* QL:         bne.s   M164_frdes           ho hum.. we've been wasting our time */
    bne.s M164_frdes
/* QL:         moveq   #M164_err.or,d0      this will be the error report in this bit */
    moveq #M164_err.or,d0
/* QL:         move.w  0(a6,a1.l),d3   pick up final dimension */
    move.w 0(a6,a1.l),d3
/* QL:         move.b  1(a6,a3.l),d6 */
    move.b 1(a6,a3.l),d6
/* QL:         clr.w   d4              no extra addend */
    clr.w d4
/* QL:         moveq   #1,d2           initial multiplier */
    moveq #1,d2
/* QL:         assert  1,M164_t.str */
/* original assertion: 1,M164_t.str */
/* QL:         cmp.b   d2,d6           string array? */
    cmp.b d2,d6
/* QL:         bgt.s   M164_descent */
    bgt.s M164_descent
/* QL:         addq.w  #1,d3 */
    addq.w #1,d3
/* QL:         bclr    d4,d3           rounds up the final string dimension to even */
    bclr d4,d3
/* QL:         addq.w  #1,d4           extra addend for word string length */
    addq.w #1,d4
/* QL:         bra.s   M164_descent */
    bra.s M164_descent
/* QL: * d0=M164_err.or, d2=1, d3=lastdim, d4.w=addend, d5=dims, d6=type */
/* QL: * N.B. There is a complete fluke involved here! a string array of just the */
/* QL: * single dimension (e.g. dim a$(5)) will always have had it's final (only) */
/* QL: * dimension rounded up to even. The multiplier will be one, so the calculation */
/* QL: * finishes up with the odd value, 1 * (dimn(1)+1), which will kindly be */
/* QL: * rounded up by the allocation/release routines! lwr. */
/* QL: * d1 -  o- size of array data area */
/* QL: * d6 -ip - type of data (0/1 string, 2 fp or 3 integer) */
/* QL: * a2 -ip - address of descriptor */
/* QL: * a0 destroyed */
/* QL: M164_calcsz */
M164_calcsz:
/* QL:         moveq   #1,d1 */
    moveq #1,d1
/* QL:         add.w   6(a6,a2.l),d1   dimn(1) plus 1 */
    add.w 6(a6,a2.l),d1
/* QL:         mulu    8(a6,a2.l),d1   x (mult dim 1) = no of elements in array */
    mulu 8(a6,a2.l),d1
/* QL:         cmp.b   #M164_t.fp,d6        type of array */
    cmp.b #(M164_t.fp&255),d6
/* QL:         blt.s   M164_rts9            string array size already set */
    blt.s M164_rts9
/* QL:         bne.s   M164_csz_int */
    bne.s M164_csz_int
/* QL:         move.l  d1,a0 */
    move.l d1,a0
/* QL:         add.l   d1,d1 */
    add.l d1,d1
/* QL:         add.l   a0,d1           x 6 bytes for a floating point array */
    add.l a0,d1
/* QL: M164_csz_int */
M164_csz_int:
/* QL:         add.l   d1,d1           x 2 bytes for an integer array */
    add.l d1,d1
/* QL: M164_rts9 */
M164_rts9:
/* QL:         rts */
    rts 
/* QL: * d0 -ip - possible error code, returned with ccr set */
/* QL: * d4 -i  - vv offset of descriptor to be discarded, along with its data */
/* QL: * d6 -ip - type of array */
/* QL: * d1/a0/a2 destroyed */
/* QL: ib_frdim */
ib_frdim:
/* QL:         move.l  M164_bv_vvbas(a6),a2 */
    move.l M164_bv_vvbas(a6),a2
/* QL:         add.l   d4,a2           point at descriptor */
    add.l d4,a2
/* QL:         move.l  0(a6,a2.l),d4   offset to values */
    move.l 0(a6,a2.l),d4
/* QL:         bmi.s   ib_frdes        if they're not set, don't free 'em! */
    bmi.s ib_frdes
/* QL:         bsr.s   M164_calcsz */
    bsr.s M164_calcsz
/* QL:         move.l  d4,a0 */
    move.l d4,a0
/* QL:         add.l   M164_bv_vvbas(a6),a0 base of vv */
    add.l M164_bv_vvbas(a6),a0
/* QL:         bsr.s   M164_frvv            free the space and the descriptor */
    bsr.s M164_frvv
/* QL: * d0 -ip - possible error code, returned with ccr set */
/* QL: * a2 -i  - descriptor to be discarded */
/* QL: * d1/a0 destroyed */
/* QL: ib_frdes */
ib_frdes:
/* QL:         move.l  a2,a0 */
    move.l a2,a0
/* QL: M164_frdes */
M164_frdes:
/* QL:         moveq   #(4+2+2)>>2,d1  we know vv is always multiple of eight */
    moveq #(((4+2)+2)>>2),d1
/* QL:         add.w   4(a6,a0.l),d1   no of dimensions (less than 8188) */
    add.w 4(a6,a0.l),d1
/* QL:         asl.l   #2,d1           x 4 = no of bytes */
    asl.l #2,d1
/* QL: M164_frvv */
M164_frvv:
/* QL:         jmp     bv_frvv(pc)     free the array descriptor */
    jmp bv_frvv(pc)
/* QL: M164_desclp */
M164_desclp:
/* QL:         add.w   d4,d3           extra addend, one for last dim of string */
    add.w d4,d3
/* QL:         addq.w  #1,d3           dimension plus element zero */
    addq.w #1,d3
/* QL:         mulu    d3,d2           get multiplier for previous dimension */
    mulu d3,d2
/* QL:         swap    d2 */
    swap d2
/* QL:         move.w  d2,d4           clears extra addend, if all is ok */
    move.w d2,d4
/* QL:         bne.s   M164_frdes           multiplier has gone out of range */
    bne.s M164_frdes
/* QL:         swap    d2 */
    swap d2
/* QL:         addq.l  #2,a1           get previous dimension on stack */
    addq.l #2,a1
/* QL:         move.w  0(a6,a1.l),d3 */
    move.w 0(a6,a1.l),d3
/* QL: M164_descent */
M164_descent:
/* QL:         move.w  d2,6-2(a6,a5.l) fill in the multiplier */
    move.w d2,(6-2)(a6,a5.l)
/* QL:         move.w  d3,6-4(a6,a5.l) fill in the dimension */
    move.w d3,(6-4)(a6,a5.l)
/* QL:         bmi.s   M164_frdes           dimension is out of range */
    bmi.s M164_frdes
/* QL:         subq.l  #4,a5           get previous dimension in descriptor */
    subq.l #4,a5
/* QL:         subq.w  #1,d5           finished yet? */
    subq.w #1,d5
/* QL:         bne.s   M164_desclp          no - carry on */
    bne.s M164_desclp
/* QL: * We now have a perfectly good new descriptor. */
/* QL:         move.l  a5,a2 */
    move.l a5,a2
/* QL:         bsr.s   M164_calcsz */
    bsr.s M164_calcsz
/* QL:         sub.l   M164_bv_vvbas(a6),a2 */
    sub.l M164_bv_vvbas(a6),a2
/* QL:         move.l  a2,4(a6,a3.l)   fill in offset of new descriptor */
    move.l a2,4(a6,a3.l)
/* QL:         jsr     bv_alvvz(pc)    allocate the data space, zeroed out */
    jsr bv_alvvz(pc)
/* QL:         sub.l   M164_bv_vvbas(a6),a0 */
    sub.l M164_bv_vvbas(a6),a0
/* QL:         move.l  a0,0(a6,a5.l)   fill in offset to array values */
    move.l a0,0(a6,a5.l)
/* QL:         moveq   #0,d0           already zero, but get ccr right */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL:         end */
