/* ROM section ca_carg */
.balign 2,0
/* QL: * Frees the VV space allocated to a simple, repeat or for variable */
/* QL: * local arrays must be freed here too. */
/* QL: * Non-local arrays also come here when redimensioning */
/* QL: * Anything else is an error. */
/* QL: * d0 -  o- error return (ccr set) */
/* QL: * a2 -ip - NT entry of variable to free */
/* QL: * d1/a0 destroyed */
/* QL: M85_f_misc */
M85_f_misc:
/* QL:         assert  2<<(M85_t.rep-M85_t.arr),(M85_lp.lnrep+7)&$fff8 */
/* original assertion: 2<<(M85_t.rep-M85_t.arr),(M85_lp.lnrep+7)&$fff8 */
/* QL:         assert  2<<(M85_t.for-M85_t.arr),(M85_lp.lnfor+7)&$fff8 */
/* original assertion: 2<<(M85_t.for-M85_t.arr),(M85_lp.lnfor+7)&$fff8 */
/* QL:         ror.b   d0,d1 */
    ror.b d0,d1
/* QL:         assert  0,(M85_t.arr-M85_t.rep)&2,(M85_t.arr-M85_t.for)&2 */
/* original assertion: 0,(M85_t.arr-M85_t.rep)&2,(M85_t.arr-M85_t.for)&2 */
/* QL:         lsr.b   #2,d0 */
    lsr.b #2,d0
/* QL:         bcc.s   M85_f_this */
    bcc.s M85_f_this
/* QL:         moveq   #M85_err.bn,d0 */
    moveq #M85_err.bn,d0
/* QL:         bra.s   M85_f_error */
    bra.s M85_f_error
/* QL: reglist reg     d2/d4/d6/a1-a3 */
/* QL: ca_frvar */
ca_frvar:
/* QL:         movem.l reglist,-(sp) */
    movem.l d2/d4/d6/a1-a3,-(sp)
/* QL:         move.l  4(a6,a2.l),d4 */
    move.l 4(a6,a2.l),d4
/* QL:         blt.s   M85_f_end           ..nothing to free */
    blt.s M85_f_end
/* QL:         move.b  1(a6,a2.l),d6   for simple/freedim */
    move.b 1(a6,a2.l),d6
/* QL:         moveq   #2,d1           int/fp, note bv_frvv rounds up to mult of 8 */
    moveq #2,d1
/* QL:         moveq   #M85_t.arr,d0 */
    moveq #M85_t.arr,d0
/* QL:         sub.b   0(a6,a2.l),d0   what sort of name is this? */
    sub.b 0(a6,a2.l),d0
/* QL:         lea     ib_frdim(pc),a3 */
    lea ib_frdim(pc),a3
/* QL:         beq.s   M85_f_this */
    beq.s M85_f_this
/* QL:         lea     bv_frvv(pc),a3 */
    lea bv_frvv(pc),a3
/* QL:         move.l  M85_bv_vvbas(a6),a0 */
    move.l M85_bv_vvbas(a6),a0
/* QL:         add.l   d4,a0           position of var to free */
    add.l d4,a0
/* QL:         blt.s   M85_f_misc */
    blt.s M85_f_misc
/* QL:         subq.b  #M85_t.fp,d6 */
    subq.b #M85_t.fp,d6
/* QL:         bge.s   M85_f_this          free a floating point or integer */
    bge.s M85_f_this
/* QL:         add.w   0(a6,a0.l),d1   add string length (bv_frvv rounds up odd len) */
    add.w 0(a6,a0.l),d1
/* QL: M85_f_this */
M85_f_this:
/* QL:         moveq   #-1,d0 */
    moveq #(-1),d0
/* QL:         move.l  d0,4(a6,a2.l)   as we're freeing it, cancel pointer */
    move.l d0,4(a6,a2.l)
/* QL:         jsr     (a3)            do appropriate free */
    jsr (a3)
/* QL: M85_f_end */
M85_f_end:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M85_f_error */
M85_f_error:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d2/d4/d6/a1-a3
/* QL:         rts */
    rts 
/* QL: * Clear all proc/fn args */
/* QL: * d0 -ip - error code (ccr set) */
/* QL: * d2 -  o- copy of d0 */
/* QL: * a3 -ip - base of args to be cleared from NT */
/* QL: * a5 -i o- top of args to be cleared on NT, returned = a3.l */
/* QL: * d1/a2 destroyed */
/* QL: ca_carg */
ca_carg:
/* QL:         move.l  a0,-(sp)        save a0 */
    move.l a0,-(sp)
/* QL:         move.l  d0,d2           save possible error code */
    move.l d0,d2
/* QL:         cmp.l   M85_bv_ntp(a6),a5   are args at very top of name table? */
    cmp.l M85_bv_ntp(a6),a5
/* QL:         bne.s   M85_tst_arg */
    bne.s M85_tst_arg
/* QL:         move.l  a3,M85_bv_ntp(a6)   yes, reset name table running pointer */
    move.l a3,M85_bv_ntp(a6)
/* QL:         bra.s   M85_tst_arg */
    bra.s M85_tst_arg
/* QL: M85_done */
M85_done:
/* QL:         move.l  (sp)+,a0        restore a0 */
    move.l (sp)+,a0
/* QL:         move.l  d2,d0           duplicate any input error, and set ccr */
    move.l d2,d0
/* QL:         rts */
    rts 
/* QL: M85_tmp_arg */
M85_tmp_arg:
/* QL:         move.l  a5,a2 */
    move.l a5,a2
/* QL:         bsr.s   ca_frvar        free temp arg value */
    bsr.s ca_frvar
/* QL: M85_clr_arg */
M85_clr_arg:
/* QL:         clr.w   0(a6,a5.l)      wipe out usage/type entry */
    clr.w 0(a6,a5.l)
/* QL: M85_tst_arg */
M85_tst_arg:
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         ble.s   M85_done */
    ble.s M85_done
/* QL:         subq.l  #8,a5 */
    subq.l #8,a5
/* QL:         and.w   #$ff0f,0(a6,a5.l) strip off the separator nibble */
    and.w #0xff0f,0(a6,a5.l)
/* QL:         beq.s   M85_tst_arg         forget it if the usage/type is now zero (null) */
    beq.s M85_tst_arg
/* QL:         move.w  2(a6,a5.l),d1   is this arg temporary? */
    move.w 2(a6,a5.l),d1
/* QL:         bmi.s   M85_tmp_arg         yes, go free the value */
    bmi.s M85_tmp_arg
/* QL:         move.l  4(a6,a5.l),a2   pick up any VV ptr */
    move.l 4(a6,a5.l),a2
/* QL:         moveq   #-1,d0 */
    moveq #(-1),d0
/* QL:         move.l  d0,4(a6,a5.l)   wipe out the VV ptr */
    move.l d0,4(a6,a5.l)
/* QL:         move.w  d0,2(a6,a5.l)   wipe out the "other entry" pointer */
    move.w d0,2(a6,a5.l)
/* QL:         move.b  0(a6,a5.l),d0   what have we come back with? */
    move.b 0(a6,a5.l),d0
/* QL:         cmp.b   #M85_t.intern,d0    what have we come back with? */
    cmp.b #(M85_t.intern&255),d0
/* QL:         ble.s   M85_clr_arg         unset or internal, clear entry */
    ble.s M85_clr_arg
/* QL:         ext.l   d1 */
    ext.l d1
/* QL:         lsl.l   #3,d1 */
    lsl.l #3,d1
/* QL:         add.l   M85_bv_ntbas(a6),d1 copy of another entry, find the other one */
    add.l M85_bv_ntbas(a6),d1
/* QL:         cmp.b   #M85_t.arr,0(a6,d1.l) is the original arg an array? */
    cmp.b #(M85_t.arr&255),0(a6,d1.l)
/* QL:         beq.s   M85_old_arr */
    beq.s M85_old_arr
/* QL:         move.b  d0,0(a6,d1.l)   copy usage (only nec for set but doesn't harm) */
    move.b d0,0(a6,d1.l)
/* QL:         move.l  a2,4(a6,d1.l)   copy where new VV is */
    move.l a2,4(a6,d1.l)
/* QL:         bra.s   M85_clr_arg */
    bra.s M85_clr_arg
/* QL: M85_old_arr */
M85_old_arr:
/* QL:         subq.b  #M85_t.arr,d0       is the return arg still an array? */
    subq.b #M85_t.arr,d0
/* QL:         bne.s   M85_clr_arg         variable, just clear it */
    bne.s M85_clr_arg
/* QL:         add.l   M85_bv_vvbas(a6),a2 point at the redundant array descriptor */
    add.l M85_bv_vvbas(a6),a2
/* QL:         jsr     ib_frdes(pc)    free the copy descriptor */
    jsr ib_frdes(pc)
/* QL:         bra.s   M85_clr_arg         and clear the argument */
    bra.s M85_clr_arg
/* QL:         end */
