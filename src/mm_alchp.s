/* ROM section mm_alchp */
.balign 2,0
/* QL: * A version of alchp that preserves much more context. */
/* QL: * This saves doing it all the places it gets called from. (lwr) */
/* QL: * d0 -  o- return error (ok or "out of memory", ccr set) */
/* QL: * d1 -i o- space required (may be modified to be slightly increased) */
/* QL: * a0 -  o- pointer to space allocated (if found) */
/* QL: reglist reg     d1-d3/a1-a2     (d1 modded if allocation succeeds) */
/* QL: * Come here when the heap needs more space */
/* QL: M61_new_free */
M61_new_free:
/* QL:         add.l   (a0),a1         add length of last block to address */
    add.l (a0),a1
/* QL:         cmp.l   M61_sv_free(a6),a1  is this equal to top of area */
    cmp.l M61_sv_free(a6),a1
/* QL:         bne.s   M61_lenok */
    bne.s M61_lenok
/* QL:         sub.l   (a0),d1         reduce length required to be allocated */
    sub.l (a0),d1
/* QL: M61_lenok */
M61_lenok:
/* QL:         jsr     mm_albot(pc)    allocate from bottom of free area */
    jsr mm_albot(pc)
/* QL:         bne.s   M61_exit            if out of memory, get out */
    bne.s M61_exit
/* QL:         sub.l   d1,a0           set base of area allocated */
    sub.l d1,a0
/* QL:         lea     M61_sv_chpfr(a6),a1 */
    lea M61_sv_chpfr(a6),a1
/* QL:         jsr     mm_lnkf0(pc)    link in new space */
    jsr mm_lnkf0(pc)
/* QL:         movem.l (sp)+,reglist   restore length, rest so we can drop back in */
    movem.l (sp)+,d1-d3/a1-a2
/* QL: mm_alchp */
mm_alchp:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d3/a1-a2,-(sp)
/* QL:         lea     M61_sv_chpfr(a6),a0 get first link pointer */
    lea M61_sv_chpfr(a6),a0
/* QL:         moveq   #16-1,d2        allocation multiple */
    moveq #(16-1),d2
/* QL:         moveq   #16,d0          don't leave scraps of 16, as they're useless */
    moveq #16,d0
/* QL:         jsr     mm_alloi(pc)    allocate some free space */
    jsr mm_alloi(pc)
/* QL:         bne.s   M61_new_free        check if adequate space found */
    bne.s M61_new_free
/* QL:         lea     M61_sv_chpfr-M61_hp_next(a6),a2 a1 might point to a new free space */
    lea (M61_sv_chpfr-M61_hp_next)(a6),a2
/* QL:         cmp.l   a1,a2           or it might point to the free space pointer */
    cmp.l a1,a2
/* QL:         beq.s   M61_ownok */
    beq.s M61_ownok
/* QL:         clr.l   M61_hp_owner(a1)    it's a free space - owned by 0 */
    clr.l M61_hp_owner(a1)
/* QL: M61_ownok */
M61_ownok:
/* QL:         move.l  d1,(sp)         tell caller what they actually got */
    move.l d1,(sp)
/* QL:         addq.l  #8,a0           skip the length, and 2nd already cleared */
    addq.l #8,a0
/* QL:         subq.l  #8,d1 */
    subq.l #8,d1
/* QL:         jsr     mm_clear(pc)    clear the area */
    jsr mm_clear(pc)
/* QL:         subq.l  #8,a0 */
    subq.l #8,a0
/* QL: M61_exit */
M61_exit:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d3/a1-a2
/* QL:         rts                     (status set) */
    rts 
/* QL:         end */
