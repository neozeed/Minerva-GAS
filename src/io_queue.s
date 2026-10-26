/* ROM section io_queue */
.balign 2,0
/* QL: * As a general idea, the code here tries to work efficiently when data is being */
/* QL: * accessed in a queue that is partially full. I.e. it should cope with high */
/* QL: * volume traffic of qin/qout calls as its forte. */
/* QL: * Set up a queue */
/* QL: * d1 -ip - length of queue (max. bytes in queue + 1, d1.w = 1..32767, we hope!) */
/* QL: * a2 -ip - pointer to queue */
/* QL: * a3 destroyed */
/* QL: io_qset */
io_qset:
/* QL:         move.l  d1,-(sp) */
    move.l d1,-(sp)
/* QL:         ext.l   d1 */
    ext.l d1
/* QL:         bsr.s   io_qsetl */
    bsr.s io_qsetl
/* QL:         move.l  (sp)+,d1 */
    move.l (sp)+,d1
/* QL:         rts */
    rts 
/* QL: * As above, but d1.l is used to set long queues! */
/* QL: io_qsetl */
io_qsetl:
/* QL:         lea     M15_q_queue(a2,d1.l),a3 set pointer to end of queue */
    lea M15_q_queue(a2,d1.l),a3
/* QL:         clr.l   (a2)+           clear eoff and nextq */
    clr.l (a2)+
/* QL:         move.l  a3,(a2)+        set end */
    move.l a3,(a2)+
/* QL:         sub.l   d1,a3           start the queue in an arbitrary place = bottom */
    sub.l d1,a3
/* QL:         move.l  a3,(a2)         set nextin */
    move.l a3,(a2)
/* QL:         move.l  a3,-(a3)        and nxtout */
    move.l a3,-(a3)
/* QL:         subq.w  #M15_q_nextin,a2    restore queue pointer */
    subq.w #M15_q_nextin,a2
/* QL:         rts */
    rts 
/* QL: * Test status of a queue */
/* QL: * d0 -  o- error flag - 0, queue empty (nc) or eof */
/* QL: * d1 -  o- next byte in queue (all but d1.b preserved) */
/* QL: * d2 -  o- spare space in queue (bits 31..15 always zero) */
/* QL: * a2 -ip - pointer to queue */
/* QL: * a3 destroyed */
/* QL: io_qtest */
io_qtest:
/* QL:         movem.l M15_q_nextin(a2),d2/a3 get pointer to next bytes in/out */
    movem.l M15_q_nextin(a2),d2/a3
/* QL:         move.b  (a3),d1         show caller next byte */
    move.b (a3),d1
/* QL:         sub.l   a3,d2           set difference between in and out */
    sub.l a3,d2
/* QL:         blt.s   M15_set_spar        negative: wrapped, so just complement this */
    blt.s M15_set_spar
/* QL:         bgt.s   M15_set_wrap        positive: must take off the wrap length */
    bgt.s M15_set_wrap
/* QL:         bsr.s   M15_set_wrap        zero: queue empty, but we must still set space */
    bsr.s M15_set_wrap
/* QL: M15_say_why */
M15_say_why:
/* QL:         moveq   #M15_err.ef,d0      end of file */
    moveq #M15_err.ef,d0
/* QL:         tst.b   (a2)            is it eof? */
    tst.b (a2)
/* QL:         bmi.s   M15_rts0            yep - ccr is ok for that */
    bmi.s M15_rts0
/* QL: M15_err_nc */
M15_err_nc:
/* QL:         moveq   #M15_err.nc,d0      not complete */
    moveq #M15_err.nc,d0
/* QL: M15_rts0 */
M15_rts0:
/* QL:         rts */
    rts 
/* QL: M15_set_wrap */
M15_set_wrap:
/* QL:         moveq   #-M15_q_queue,d0 */
    moveq #(-M15_q_queue),d0
/* QL:         sub.l   a2,d0 */
    sub.l a2,d0
/* QL:         add.l   M15_q_end(a2),d0    this is the overall queue area */
    add.l M15_q_end(a2),d0
/* QL:         sub.l   d0,d2           so this'll be the free space, when complemented */
    sub.l d0,d2
/* QL: M15_set_spar */
M15_set_spar:
/* QL:         not.l   d2              zero will mean no spare space in queue */
    not.l d2
/* QL:         move.w  #32767,a3       we must return a positive word */
    move.w #32767,a3
/* QL:         cmp.l   a3,d2 */
    cmp.l a3,d2
/* QL:         bls.s   M15_say_ok */
    bls.s M15_say_ok
/* QL:         move.l  a3,d2           if the queue is oversize, return a max value */
    move.l a3,d2
/* QL: M15_say_ok */
M15_say_ok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Put bytes into a queue */
/* QL: * d0 -  o- error flag - queue full */
/* QL: * d1 -ip - byte to put in queue (discarded with no error if eof set) */
/* QL: * a2 -ip - pointer to queue */
/* QL: * a3 destroyed */
/* QL: io_qin */
io_qin:
/* QL:         tst.b   (a2)            is it eof? (eoff) */
    tst.b (a2)
/* QL:         bmi.s   M15_say_ok          ... yes - throw it away (!!!) */
    bmi.s M15_say_ok
/* QL:         move.l  M15_q_nextin(a2),a3 get pointer to end of queue */
    move.l M15_q_nextin(a2),a3
/* QL:         move.b  d1,(a3)+        put byte regardless (there's alway a gap) */
    move.b d1,(a3)+
/* QL:         cmp.l   M15_q_end(a2),a3    is next pointer off end of queue */
    cmp.l M15_q_end(a2),a3
/* QL:         blt.s   M15_chk_next */
    blt.s M15_chk_next
/* QL:         lea     M15_q_queue(a2),a3  next is start of queue */
    lea M15_q_queue(a2),a3
/* QL: M15_chk_next */
M15_chk_next:
/* QL:         cmp.l   M15_q_nxtout(a2),a3 is queue full */
    cmp.l M15_q_nxtout(a2),a3
/* QL:         beq.s   M15_err_nc */
    beq.s M15_err_nc
/* QL:         move.l  a3,M15_q_nextin(a2) save pointer to next in queue */
    move.l a3,M15_q_nextin(a2)
/* QL:         bra.s   M15_say_ok */
    bra.s M15_say_ok
/* QL: * Fetch bytes out of a queue */
/* QL: * d0 -  o- error flag - queue empty, and possibly at eof */
/* QL: * d1 -  o- byte from queue */
/* QL: * a2 -ip - pointer to queue */
/* QL: * a3 destroyed */
/* QL: io_qout */
io_qout:
/* QL:         move.l  M15_q_nxtout(a2),a3 get pointer to next byte */
    move.l M15_q_nxtout(a2),a3
/* QL:         cmp.l   M15_q_nextin(a2),a3 is there anything in queue */
    cmp.l M15_q_nextin(a2),a3
/* QL:         beq.s   M15_say_why         no - go tell caller nc/eof */
    beq.s M15_say_why
/* QL:         move.b  (a3)+,d1        fetch byte */
    move.b (a3)+,d1
/* QL:         cmp.l   M15_q_end(a2),a3    is next pointer off end of queue */
    cmp.l M15_q_end(a2),a3
/* QL:         blt.s   M15_save_out */
    blt.s M15_save_out
/* QL:         lea     M15_q_queue(a2),a3  next is start of queue */
    lea M15_q_queue(a2),a3
/* QL: M15_save_out */
M15_save_out:
/* QL:         move.l  a3,M15_q_nxtout(a2) save pointer to next in queue */
    move.l a3,M15_q_nxtout(a2)
/* QL:         bra.s   M15_say_ok */
    bra.s M15_say_ok
/* QL: * Set end of file on a queue */
/* QL: * a2 -ip - pointer to queue */
/* QL: io_qeof */
io_qeof:
/* QL:         tas     (a2)            flag in msbit (eoff) */
    tas (a2)
/* QL:         rts */
    rts 
/* QL:         vect4000 io_qsetl */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ io$qsetl,(io_qsetl-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
