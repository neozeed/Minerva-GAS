/* ROM section ut_err */
.balign 2,0
/* QL: * Print an error message to channel id 0. */
/* QL: * d0 -ip - error key (ccr is not set) */
/* QL: ut_err0 */
ut_err0:
/* QL:         move.l  a0,-(sp)        save a0 */
    move.l a0,-(sp)
/* QL:         sub.l   a0,a0           channel 0 */
    sub.l a0,a0
/* QL:         bsr.s   ut_err          M68_write message */
    bsr.s ut_err
/* QL:         move.l  (sp)+,a0        restore a0 */
    move.l (sp)+,a0
/* QL:         rts */
    rts 
/* QL: * Print an error message to supplied channel. */
/* QL: * d0 -ip - error key (ccr is not set) */
/* QL: * a0 -ip - channel id */
/* QL: ut_err */
ut_err:
/* QL:         movem.l d0-d3/a1,-(sp)  save volatile registers */
    movem.l d0-d3/a1,-(sp)
/* QL:         move.l  d0,a1           d0 might be pointer to message + $80000000 */
    move.l d0,a1
/* QL:         add.l   d0,d0 */
    add.l d0,d0
/* QL:         bcc.s   M68_tidy            positive is not an error message */
    bcc.s M68_tidy
/* QL:         bpl.s   M68_write           ... it is pointer to message */
    bpl.s M68_write
/* QL:         neg.w   d0 */
    neg.w d0
/* QL:         move.w  d0,a1 */
    move.w d0,a1
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         move.l  a0,-(sp) */
    move.l a0,-(sp)
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  M68_sv_mgtab(a0),a0 get base of error table */
    move.l M68_sv_mgtab(a0),a0
/* QL:         move.w  0(a0,a1.w),a1   pick offset to reqd. message */
    move.w 0(a0,a1.w),a1
/* QL:         add.l   a0,a1           make the actual address */
    add.l a0,a1
/* QL:         move.l  (sp)+,a0  */
    move.l (sp)+,a0
/* QL:         tst.b   (a1)            silly message length? ( > 255 chars ) */
    tst.b (a1)
/* QL:         bne.s   M68_tidy            yes, so give up */
    bne.s M68_tidy
/* QL: M68_write */
M68_write:
/* QL:         jsr     ut_mtext(pc)    M68_write message */
    jsr ut_mtext(pc)
/* QL: M68_tidy */
M68_tidy:
/* QL:         movem.l (sp)+,d0-d3/a1  restore volatile registers */
    movem.l (sp)+,d0-d3/a1
/* QL:         rts */
    rts 
/* QL:         end */
