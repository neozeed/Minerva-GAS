/* ROM section ut_messb */
.balign 2,0
/* QL: * N.B. This should not be called in user mode by an interpreter job, as a6/a7 */
/* QL: * may move! However, it is now fairly safe (see below). */
/* QL: * d0 -  o- error code */
/* QL: * d1 -i o- integer value (ut_mint) / number of characters actually sent */
/* QL: * d2 -  o- number of characters that should have been sent */
/* QL: * d3 -  o- 0 if a0=0, otherwise -1 */
/* QL: * a0 -ip - channel id */
/* QL: * a1 destroyed */
/* QL: ut_mint */
ut_mint:
/* QL:         subq.l  #8,sp           eight byte workspace & 68020 compatible... */
    subq.l #8,sp
/* QL:         movem.l a6-a7,(sp)      ... snapshot of a6/a7 */
    movem.l a6-a7,(sp)
/* QL:         movem.l (sp),d0/d3      get matched copies of a6/a7 */
    movem.l (sp),d0/d3
/* QL:         sub.l   d0,d3           this is a good rel a6 offset */
    sub.l d0,d3
/* QL:         exg.l   a0,d3           save channel while we convert */
    exg a0,d3
/* QL:         move.w  d1,d0           put the number in d0 */
    move.w d1,d0
/* QL:         jsr     cn_0tod(pc)     convert, putting at (a6,a0) */
    jsr cn_0tod(pc)
/* QL:         move.l  d3,a0           get back the channel id */
    move.l d3,a0
/* QL:         move.w  d1,d2           set number of characters */
    move.w d1,d2
/* QL:         move.l  sp,a1           set pointer to characters */
    move.l sp,a1
/* QL: * This is the point where an interpreter can fail... the stack could move. */
/* QL: * It's not too awful, we just get garbage instead of the proper number. */
/* QL:         bsr.s   ut_write */
    bsr.s ut_write
/* QL:         addq.l  #8,sp           discard work area */
    addq.l #8,sp
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code */
/* QL: * d1 -  o- number of characters sent */
/* QL: * d2 -  o- lsw gets string length, msw unchanged */
/* QL: * d3 -  o- 0 if a0=0, otherwise -1 */
/* QL: * a0 -ip - channel id */
/* QL: * a1 -i o- pointer to string prefixed by length word (updated past last sent) */
/* QL: ut_mtext */
ut_mtext:
/* QL:         move.w (a1)+,d2         get character count */
    move.w (a1)+,d2
/* QL: * d0 -  o- error code */
/* QL: * d1 -  o- number of characters sent */
/* QL: * d2 -ip - text length */
/* QL: * d3 -  o- 0 if a0=0, otherwise -1 */
/* QL: * a0 -ip - channel id */
/* QL: * a1 -i o- pointer to text (updated past last sent) */
/* QL: ut_write */
ut_write:
/* QL:         moveq   #-1,d3          return when complete for all but chan 0 */
    moveq #(-1),d3
/* QL:         move.l  a0,d0           is it command channel? */
    move.l a0,d0
/* QL:         bne.s   M70_trap3 */
    bne.s M70_trap3
/* QL:         move.l  d2,-(sp) */
    move.l d2,-(sp)
/* QL:         moveq   #M70_mt.inf,d0 */
    moveq #M70_mt.inf,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         sf      M70_sv_scrst(a0)    command channel so unfreeze screen */
    sf M70_sv_scrst(a0)
/* QL:         move.l  (sp)+,d2 */
    move.l (sp)+,d2
/* QL:         sub.l   a0,a0 */
    sub.l a0,a0
/* QL:         moveq   #0,d3           return immediate for chan 0 (and chan 1 retry) */
    moveq #0,d3
/* QL: M70_trap3 */
M70_trap3:
/* QL:         bsr.s   M70_doit */
    bsr.s M70_doit
/* QL:         bne.s   M70_exit */
    bne.s M70_exit
/* QL:         move.l  #1<<16!1,a0     if not complete it must have been channel 0 */
    move.l #((1<<16)|1),a0
/* QL:         bsr.s   M70_doit            try again on channel 1, but just one try */
    bsr.s M70_doit
/* QL:         sub.l   a0,a0           make it channel zero again */
    sub.l a0,a0
/* QL: M70_exit */
M70_exit:
/* QL:         subq.l  #-M70_err.nc,d0 */
.word 20864|((((-M70_err.nc))&7)<<9)
/* QL:         rts */
    rts 
/* QL: M70_doit */
M70_doit:
/* QL:         moveq   #M70_io.sstrg,d0    write string of characters */
    moveq #M70_io.sstrg,d0
/* QL:         trap    #3 */
    trap #3
/* QL:         addq.l  #-M70_err.nc,d0     was it non complete? */
.word 20608|((((-M70_err.nc))&7)<<9)
/* QL:         rts */
    rts 
/* QL:         end */
