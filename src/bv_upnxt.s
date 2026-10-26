/* ROM section bv_upnxt */
.balign 2,0
/* QL: M76_comm */
M76_comm:
/* QL:         move.l  d0,-(sp)        save a data register */
    move.l d0,-(sp)
/* QL:         pea     bv_upnxt+2      base of return addresses */
    pea (bv_upnxt+2)(pc)
/* QL:         move.l  (sp)+,d0        into a data register */
    move.l (sp)+,d0
/* QL:         sub.l   d0,4(sp)        longword parameter for user code */
    sub.l d0,4(sp)
/* QL:         move.l  (sp),d0         reload register */
    move.l (sp),d0
/* QL:         move.l  M76_bv_uproc(a6),(sp) should be user's trace procedure */
    move.l M76_bv_uproc(a6),(sp)
/* QL:         bmi.s   M76_ok              check that the vector is (still) M76_ok */
    bmi.s M76_ok
/* QL:         addq.l  #8,sp           if not, scrap the whole business */
    addq.l #8,sp
/* QL: M76_ok */
M76_ok:
/* QL:         rts                     call user code or go back home */
    rts 
/* QL: bv_upnxt */
bv_upnxt:
/* QL:         bsr.s   M76_comm            0: trace start of statement */
    bsr.s M76_comm
/* QL: bv_uplet */
bv_uplet:
/* QL:         bsr.s   M76_comm            2: trace assignments */
    bsr.s M76_comm
/* QL: bv_upmcf */
bv_upmcf:
/* QL:         bsr.s   M76_comm            4: trace machine code function calls */
    bsr.s M76_comm
/* QL: bv_upswp */
bv_upswp:
/* QL:         bsr.s   M76_comm            6: trace proc/fn arg swaps */
    bsr.s M76_comm
/* QL: bv_uprnm */
bv_uprnm:
/* QL:         bsr.s   M76_comm            8: trace renumbering of program */
    bsr.s M76_comm
/* QL:         end */
