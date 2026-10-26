/* ROM section mt_free */
.balign 2,0
/* QL: * This doesn't actually include the fact that a small spare slot at the front */
/* QL: * of the transient area could also be acquired when job 0 moves. */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- maximum of d2 and a0 below */
/* QL: * d2 -  o- maximum free slot already in transient area */
/* QL: * a0 -  o- free space between common heap and job 0 */
/* QL: * d3/a1-a2 destroyed */
/* QL: mt_free */
mt_free:
/* QL:         moveq   #0,d0           scan all free space */
    moveq #0,d0
/* QL:         moveq   #0,d1           for any space >= 0 */
    moveq #0,d1
/* QL:         lea     M27_sv_trnfr(a6),a0 in transient area */
    lea M27_sv_trnfr(a6),a0
/* QL:         jsr     mm_scafr(pc)    get d2 = largest free space in transient area */
    jsr mm_scafr(pc)
/* QL:         move.l  M27_sv_basic(a6),a0 get top of free area */
    move.l M27_sv_basic(a6),a0
/* QL:         sub.w   #2*512,a0       take away enough space for two buffers (lwr) */
    sub.w #(2*512),a0
/* QL:         sub.l   M27_sv_free(a6),a0  this is the amount we could move job 0 by */
    sub.l M27_sv_free(a6),a0
/* QL:         move.l  a0,d1 */
    move.l a0,d1
/* QL:         cmp.l   d1,d2 */
    cmp.l d1,d2
/* QL:         ble.s   M27_exit */
    ble.s M27_exit
/* QL:         move.l  d2,d1           produce maximum of the two values */
    move.l d2,d1
/* QL: M27_exit */
M27_exit:
/* QL:         jmp     ss_noer(pc) */
    jmp ss_noer(pc)
/* QL:         end */
