/* ROM section mm_rechp */
.balign 2,0
/* QL: * Changed to preserve registers, intead of all callers doing them */
/* QL: * d0 -  o- 0 (always succeed) */
/* QL: * a0 -i  - base address to be freed */
/* QL: reglist reg     d1-d3/a1-a2 */
/* QL: mm_rechp */
mm_rechp:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d3/a1-a2,-(sp)
/* QL:         move.l  M59_hp_len(a0),d1   get length of space */
    move.l M59_hp_len(a0),d1
/* QL:         lea     M59_sv_chpfr(a6),a1 pointer to first link */
    lea M59_sv_chpfr(a6),a1
/* QL:         jsr     mm_lnkf0(pc)    link in */
    jsr mm_lnkf0(pc)
/* QL: * Check if space is at end */
/* QL:         add.l   d1,a1           add length of last space to address */
    add.l d1,a1
/* QL:         cmp.l   M59_sv_free(a6),a1  is it the same as bottom of free */
    cmp.l M59_sv_free(a6),a1
/* QL:         bne.s   M59_exit */
    bne.s M59_exit
/* QL: * Release space to slave blocks */
/* QL:         tst.l   d2              was this actually the final block? */
    tst.l d2
/* QL:         beq.s   M59_goreb */
    beq.s M59_goreb
/* QL:         add.l   a0,d2           no! add prior offset */
    add.l a0,d2
/* QL: M59_goreb */
M59_goreb:
/* QL:         move.l  d2,M59_hp_next(a2)  take this block out of the free list */
    move.l d2,M59_hp_next(a2)
/* QL:         move.l  d1,d2           remember what length it was */
    move.l d1,d2
/* QL:         jsr     mm_rebot(pc)    return space to free area */
    jsr mm_rebot(pc)
/* QL: * Check for leftovers */
/* QL:         sub.l   d1,d2           was there any left over? */
    sub.l d1,d2
/* QL:         beq.s   M59_exit            no - ok, it's all gone */
    beq.s M59_exit
/* QL:         sub.l   d2,a0           back to the one we were releasing */
    sub.l d2,a0
/* QL:         move.l  d2,(a0)         put the odd bit as length (offset still ok) */
    move.l d2,(a0)
/* QL:         sub.l   a2,a0 */
    sub.l a2,a0
/* QL:         move.l  a0,M59_hp_next(a2)  relink into free chain */
    move.l a0,M59_hp_next(a2)
/* QL: M59_exit */
M59_exit:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d3/a1-a2
/* QL:         rts */
    rts 
/* QL:         end */
