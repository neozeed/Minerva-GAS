/* ROM section mm_retrn */
.balign 2,0
/* QL: * a0 -i  - base address to be freed */
/* QL: * d0-d3/a1-a3 destroyed */
/* QL: mm_retrn */
mm_retrn:
/* QL:         bsr.s   M58_freeit          go free the space */
    bsr.s M58_freeit
/* QL: * Check if space is at bottom */
/* QL:         cmp.l   M58_sv_trnsp(a6),a1 has freed space come out at bottom of area? */
    cmp.l M58_sv_trnsp(a6),a1
/* QL:         bne.s   M58_rts0            no - forget it */
    bne.s M58_rts0
/* QL: * Remove space from free chain */
/* QL:         tst.l   d2              was this the last in the chain? */
    tst.l d2
/* QL:         beq.s   M58_mklnk */
    beq.s M58_mklnk
/* QL:         add.l   a0,d2           no - add offsets */
    add.l a0,d2
/* QL: M58_mklnk */
M58_mklnk:
/* QL:         move.l  d2,M58_hp_next(a2)  remove area from free list */
    move.l d2,M58_hp_next(a2)
/* QL: * Move basic up */
/* QL:         move.l  d1,d2           remember how long it was */
    move.l d1,d2
/* QL:         jsr     mm_mubas(pc)    release space d1 (d2,a2 should remain) */
    jsr mm_mubas(pc)
/* QL:         add.l   d1,M58_sv_trnsp(a6) update transient program area */
    add.l d1,M58_sv_trnsp(a6)
/* QL: * Check out any leftovers */
/* QL:         sub.l   d1,d2           remove area released */
    sub.l d1,d2
/* QL:         beq.s   M58_rts0            if zero, it's all gone */
    beq.s M58_rts0
/* QL:         move.l  M58_sv_trnsp(a6),a0 get address of odd bit */
    move.l M58_sv_trnsp(a6),a0
/* QL:         move.l  d2,M58_hp_len(a0)   show its length */
    move.l d2,M58_hp_len(a0)
/* QL: M58_freeit */
M58_freeit:
/* QL:         move.l  (a0),d1         get length of space */
    move.l (a0),d1
/* QL:         lea     M58_sv_trnfr(a6),a1 pointer to first link */
    lea M58_sv_trnfr(a6),a1
/* QL:         jmp     mm_lnkf0(pc)    link in */
    jmp mm_lnkf0(pc)
/* QL: M58_rts0 */
M58_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
