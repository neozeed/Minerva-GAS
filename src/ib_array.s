/* ROM section ib_array */
.balign 2,0
/* QL: * d0 -  o- error code (with ccr set) */
/* QL: * d4 -i  - name number */
/* QL: * a2 -i  - name table entry */
/* QL: * a4 -i o- tokenised buffer (token after name on input) */
/* QL: * d1-d3/a0-a1/a3 destroyed */
/* QL: M154_err_bn */
M154_err_bn:
/* QL:         moveq   #M154_err.bn,d0 */
    moveq #M154_err.bn,d0
/* QL:         rts */
    rts 
/* QL: ib_array */
ib_array:
/* QL:         and.b   #15,1(a6,a2.l)  mask any separator */
    and.b #(15&255),1(a6,a2.l)
/* QL:         tst.b   4(a6,a2.l)      check that array has been dimensioned */
    tst.b 4(a6,a2.l)
/* QL:         bmi.s   M154_err_bn */
    bmi.s M154_err_bn
/* QL:         jsr     bv_chnt(pc)     need a new nt entry */
    jsr bv_chnt(pc)
/* QL:         move.l  M154_bv_ntp(a6),a3   keep copy in a3 */
    move.l M154_bv_ntp(a6),a3
/* QL:         addq.l  #8,M154_bv_ntp(a6) */
    addq.l #8,M154_bv_ntp(a6)
/* QL:         move.w  0(a6,a2.l),0(a6,a3.l) copy nt,vt */
    move.w 0(a6,a2.l),0(a6,a3.l)
/* QL:         move.w  d4,2(a6,a3.l)   point at original nt entry */
    move.w d4,2(a6,a3.l)
/* QL:         move.l  4(a6,a2.l),a2   offset of array descriptor */
    move.l 4(a6,a2.l),a2
/* QL:         add.l   M154_bv_vvbas(a6),a2 point to it */
    add.l M154_bv_vvbas(a6),a2
/* QL:         moveq   #(4+2+2)>>2,d1  we know that alloc will round to mult of 8 */
    moveq #(((4+2)+2)>>2),d1
/* QL:         add.w   4(a6,a2.l),d1   add number of dimensions */
    add.w 4(a6,a2.l),d1
/* QL:         lsl.l   #2,d1           x 4 bytes each */
    lsl.l #2,d1
/* QL:         jsr     bp_alvv(pc)     allocate space for a copy and fill pntr in */
    jsr bp_alvv(pc)
/* QL: M154_copy_des */
M154_copy_des:
/* QL:         move.l  0(a6,a2.l),0(a6,a0.l) copy descriptor by longwords */
    move.l 0(a6,a2.l),0(a6,a0.l)
/* QL:         addq.l  #4,a2 */
    addq.l #4,a2
/* QL:         addq.l  #4,a0 */
    addq.l #4,a0
/* QL:         subq.w  #4,d1 */
    subq.w #4,d1
/* QL:         bgt.s   M154_copy_des */
    bgt.s M154_copy_des
/* QL: M154_new_ind */
M154_new_ind:
/* QL:         jsr     ib_nxnon(pc)    get next symbol */
    jsr ib_nxnon(pc)
/* QL:         sub.w   #M154_w.equal,d1     is it an equals sign? */
    sub.w #M154_w.equal,d1
/* QL:         beq.s   M154_chk_ind         yes, make sure it's valid */
    beq.s M154_chk_ind
/* QL:         moveq   #M154_err.xp,d0 */
    moveq #M154_err.xp,d0
/* QL:         subq.w  #M154_w.opar-M154_w.equal,d1 is it an opening parenthesis? */
.word 20801|((((M154_w.opar-M154_w.equal))&7)<<9)
/* QL:         bne.s   M154_clr_copy        no, nothing else allowed */
    bne.s M154_clr_copy
/* QL:         addq.l  #2,a4           skip bracket */
    addq.l #2,a4
/* QL:         move.l  a4,a0           for ca_indx */
    move.l a4,a0
/* QL:         lea     8(a3),a5        ditto */
    lea 8(a3),a5
/* QL:         jsr     ca_indx(pc)     compress the array descriptor */
    jsr ca_indx(pc)
/* QL:         lea     -8(a5),a3 */
    lea (-8)(a5),a3
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         beq.s   M154_new_ind         what's next ? */
    beq.s M154_new_ind
/* QL:         bra.s   M154_clr_copy */
    bra.s M154_clr_copy
/* QL: M154_chk_ind */
M154_chk_ind:
/* QL:         addq.l  #2,a4           skip the equals sign */
    addq.l #2,a4
/* QL:         cmp.b   #M154_t.var,0(a6,a3.l) has array compressed to a single value? */
    cmp.b #(M154_t.var&255),0(a6,a3.l)
/* QL:         beq.s   M154_let             yes, good */
    beq.s M154_let
/* QL:         moveq   #M154_err.ni,d0 */
    moveq #M154_err.ni,d0
/* QL:         cmp.b   #M154_t.str,1(a6,a3.l) no, is it a (sub)string then? */
    cmp.b #(M154_t.str&255),1(a6,a3.l)
/* QL:         bgt.s   M154_clr_copy        no, can't do it yet */
    bgt.s M154_clr_copy
/* QL:         move.l  4(a6,a3.l),a2 */
    move.l 4(a6,a3.l),a2
/* QL:         add.l   M154_bv_vvbas(a6),a2 */
    add.l M154_bv_vvbas(a6),a2
/* QL:         cmp.w   #1,4(a6,a2.l)   only the one dimension i trust? */
    cmp.w #1,4(a6,a2.l)
/* QL:         bgt.s   M154_clr_copy        sigh */
    bgt.s M154_clr_copy
/* QL: M154_let */
M154_let:
/* QL:         move.b  1(a6,a3.l),d0   type we want it to be */
    move.b 1(a6,a3.l),d0
/* QL:         sub.l   M154_bv_ntbas(a6),a3 */
    sub.l M154_bv_ntbas(a6),a3
/* QL:         move.l  a3,-(sp) */
    move.l a3,-(sp)
/* QL:         move.l  a4,a0           start of expression to evaluate */
    move.l a4,a0
/* QL:         jsr     ca_eval(pc) */
    jsr ca_eval(pc)
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         move.l  (sp)+,a3 */
    move.l (sp)+,a3
/* QL:         add.l   M154_bv_ntbas(a6),a3 */
    add.l M154_bv_ntbas(a6),a3
/* QL:         ble.s   M154_clr_copy */
    ble.s M154_clr_copy
/* QL:         jsr     bp_let(pc) */
    jsr bp_let(pc)
/* QL: M154_clr_copy */
M154_clr_copy:
/* QL:         cmp.b   #M154_t.arr,0(a6,a3.l) is this still an array? */
    cmp.b #(M154_t.arr&255),0(a6,a3.l)
/* QL:         bne.s   M154_clr_nt          no, no descriptor then */
    bne.s M154_clr_nt
/* QL:         move.l  4(a6,a3.l),a2   free the descriptor */
    move.l 4(a6,a3.l),a2
/* QL:         add.l   M154_bv_vvbas(a6),a2 */
    add.l M154_bv_vvbas(a6),a2
/* QL:         jsr     ib_frdes(pc)    preserves d0 these days! */
    jsr ib_frdes(pc)
/* QL: M154_clr_nt */
M154_clr_nt:
/* QL:         clr.l   0(a6,a3.l)      clear the nt copy */
    clr.l 0(a6,a3.l)
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL:         cmp.l   M154_bv_ntp(a6),a3   is this copy on top of the name table? */
    cmp.l M154_bv_ntp(a6),a3
/* QL:         bne.s   M154_tst_d0 */
    bne.s M154_tst_d0
/* QL:         subq.l  #8,M154_bv_ntp(a6)   yes, move down */
    subq.l #8,M154_bv_ntp(a6)
/* QL: M154_tst_d0 */
M154_tst_d0:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL:         end */
