/* ROM section io_chanx */
.balign 2,0
/* QL: * Only call from trap level as it does not return if channel does not exist. */
/* QL: * Bad channel, drop return, d0 = error not open, a0 unchanged and reshedule. */
/* QL: * a0 -i o- channel id to be checked / address of definition block */
/* QL: * a5 -  o- channel id */
/* QL: * d7 destroyed */
/* QL: io_chanx */
io_chanx:
/* QL:         move.l  a0,d7           copy channel id */
    move.l a0,d7
/* QL:         cmp.w   M11_sv_chmax(a6),d7 is it off end of table */
    cmp.w M11_sv_chmax(a6),d7
/* QL:         bhi.s   M11_err_no          yes - actually an invalid id */
    bhi.s M11_err_no
/* QL:         lsl.w   #2,d7           address of entry is 4*channel number */
    lsl.w #2,d7
/* QL:         move.l  M11_sv_chbas(a6),a5 + base address */
    move.l M11_sv_chbas(a6),a5
/* QL:         add.w   d7,a5 */
    add.w d7,a5
/* QL:         tst.b   (a5)            is it in table */
    tst.b (a5)
/* QL:         bmi.s   M11_err_no          no - channel closed */
    bmi.s M11_err_no
/* QL:         move.l  (a5),a5         set pointer to definition block */
    move.l (a5),a5
/* QL:         swap    d7              get tag in bottom end */
    swap d7
/* QL:         cmp.w   M11_ch_tag(a5),d7   is this the same tag? */
    cmp.w M11_ch_tag(a5),d7
/* QL:         bne.s   M11_err_no          no - channel re-used */
    bne.s M11_err_no
/* QL:         exg     a5,a0           swap channel address and channel id */
    exg a0,a5
/* QL:         rts                     o.k. return */
    rts 
/* QL: M11_err_no */
M11_err_no:
/* QL:         move.l  M11_sv_jbpnt(a6),a5 get current job slot */
    move.l M11_sv_jbpnt(a6),a5
/* QL:         move.l  (a5),a5         point to header */
    move.l (a5),a5
/* QL:         bclr    #7,M11_jb_rela6(a5) clear msb of relative flag */
    bclr #7,M11_jb_rela6(a5)
/* QL:         addq.l  #4,sp           remove return address from stack */
    addq.l #4,sp
/* QL:         moveq   #M11_err.no,d0 */
    moveq #M11_err.no,d0
/* QL:         jmp     ss_rte(pc)      return direct to trap */
    jmp ss_rte(pc)
/* QL:         end */
