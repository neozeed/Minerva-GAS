/* ROM section ib_let */
.balign 2,0
/* QL: * d0 -  o- return code */
/* QL: * d1 -i  - first word of next token */
/* QL: * d4 -i  - name table index */
/* QL: * a2 -i  - name table entry */
/* QL: * a4 -i o- pf pointer (start at token after name) */
/* QL: * d2-d3/d5-d6/a0-a1/a3 destroyed */
/* QL: ib_let */
ib_let:
/* QL:         move.l  a2,a3 */
    move.l a2,a3
/* QL:         and.b   #15,1(a6,a3.l)  mask out any separator which may have crept in */
    and.b #(15&255),1(a6,a3.l)
/* QL:         jsr     bp_rdchk(pc)    can we assign to this ? */
    jsr bp_rdchk(pc)
/* QL:         bne.s   M153_rts0            ..no */
    bne.s M153_rts0
/* QL:         clr.w   d5              set flag for M153_normal variable type */
    clr.w d5
/* QL:         move.b  1(a6,a3.l),d0   get type */
    move.b 1(a6,a3.l),d0
/* QL:         cmp.w   #M153_w.opar,d1      got an ( ? */
    cmp.w #M153_w.opar,d1
/* QL:         bne.s   M153_eval            ..no */
    bne.s M153_eval
/* QL:         subq.b  #M153_t.str,d0       must be a string */
    subq.b #M153_t.str,d0
/* QL:         bne.s   M153_err_bn */
    bne.s M153_err_bn
/* QL:         tst.b   4(a6,a3.l)      must already have a value */
    tst.b 4(a6,a3.l)
/* QL:         bmi.s   M153_err_bn */
    bmi.s M153_err_bn
/* QL:         lea     2(a4),a0 */
    lea 2(a4),a0
/* QL:         jsr     ca_ssind(pc)    read the substring indices */
    jsr ca_ssind(pc)
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         bne.s   M153_rts0 */
    bne.s M153_rts0
/* QL:         tst.w   d5 */
    tst.w d5
/* QL:         ble.s   M153_err_or          can't assign to string length word */
    ble.s M153_err_or
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL:         moveq   #M153_t.str,d0       set type string required */
    moveq #M153_t.str,d0
/* QL: M153_eval */
M153_eval:
/* QL:         cmp.w   #M153_w.equal,d1     followed by equals */
    cmp.w #M153_w.equal,d1
/* QL:         bne.s   M153_err_bn */
    bne.s M153_err_bn
/* QL:         lea     2(a4),a0        start of expression to evaluate */
    lea 2(a4),a0
/* QL:         jsr     ca_eval(pc) */
    jsr ca_eval(pc)
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         ble.s   M153_err_ev */
    ble.s M153_err_ev
/* QL:         jsr     ib_fname(pc)    make nt pointer again from d4 index */
    jsr ib_fname(pc)
/* QL:         move.l  a2,a3 */
    move.l a2,a3
/* QL:         subq.w  #1,d5           did we get substring indices? */
    subq.w #1,d5
/* QL:         bcs.s   M153_normal          nope - that's a go */
    bcs.s M153_normal
/* QL:         move.l  4(a6,a3.l),a2   get offset */
    move.l 4(a6,a3.l),a2
/* QL:         add.l   M153_bv_vvbas(a6),a2 base of string */
    add.l M153_bv_vvbas(a6),a2
/* QL:         move.w  0(a6,a2.l),d0   get its length */
    move.w 0(a6,a2.l),d0
/* QL:         cmp.w   d0,d6           are we falling off the end? */
    cmp.w d0,d6
/* QL:         ble.s   M153_notrunc         nope, that's fine */
    ble.s M153_notrunc
/* QL:         move.w  d0,d6           yes, trim it down */
    move.w d0,d6
/* QL: M153_notrunc */
M153_notrunc:
/* QL:         cmp.w   d5,d6           where are we starting? */
    cmp.w d5,d6
/* QL:         blt.s   M153_err_or          no good if beyond last char+1 */
    blt.s M153_err_or
/* QL:         addq.w  #1,d5           put d5 back as standard start index */
    addq.w #1,d5
/* QL:         sf      1(a6,a3.l)      set substring type for bp_let to sort out */
    sf 1(a6,a3.l)
/* QL: M153_normal */
M153_normal:
/* QL:         jsr     bp_let(pc)      do the assignment */
    jsr bp_let(pc)
/* QL:         bne.s   M153_rts0            did it work? */
    bne.s M153_rts0
/* QL:         tst.w   M153_bv_wvnum(a6)    any when variables? */
    tst.w M153_bv_wvnum(a6)
/* QL:         beq.s   M153_rts0            no - return now */
    beq.s M153_rts0
/* QL:         jmp     ib_wtest(pc)    yes - go check it out */
    jmp ib_wtest(pc)
/* QL: M153_err_bn */
M153_err_bn:
/* QL:         moveq   #M153_err.bn,d0      must be mistyped */
    moveq #M153_err.bn,d0
/* QL: M153_rts0 */
M153_rts0:
/* QL:         rts */
    rts 
/* QL: M153_err_or */
M153_err_or:
/* QL:         moveq   #M153_err.or,d0 */
    moveq #M153_err.or,d0
/* QL:         rts */
    rts 
/* QL: M153_err_ev */
M153_err_ev:
/* QL:         blt.s   M153_rts0 */
    blt.s M153_rts0
/* QL:         moveq   #M153_err.xp,d0      null */
    moveq #M153_err.xp,d0
/* QL:         rts */
    rts 
/* QL:         end */
