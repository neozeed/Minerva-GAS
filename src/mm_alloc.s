/* ROM section mm_alloc */
.balign 2,0
/* QL: * Space is taken from the first adequate available space and if it is not an */
/* QL: * exact fit, the early part is used and the later is left as free. */
/* QL: * If all is well, the first longword of the allocated area will be set to its */
/* QL: * overall length, and the second longword will be set to zero. */
/* QL: * d0 -  o- error code (ccr set) */
/* QL: * d1 -i o- space required, rounded up to allocation multiple */
/* QL: * a0 -i o- pointer to pointer to free space / pointer to space allocated */
/* QL: * d2-d3/a1-a2 destroyed */
/* QL: mm_alloc */
mm_alloc:
/* QL:         moveq   #8-1,d2         allocation multiple */
    moveq #(8-1),d2
/* QL:         moveq   #8-1,d0         exit at first adequate space, scraps >= 8 */
    moveq #(8-1),d0
/* QL: * d0 -i    minimum size for left over bits of memory */
/* QL: *       o- error code (ccr set) */
/* QL: * d1 -i o- space required, rounded up to allocation multiple */
/* QL: * d2 -i  - allocation multiple less one. */
/* QL: * a0 -i o- pointer to pointer to free space / pointer to space allocated */
/* QL: * d3/a1-a2 destroyed */
/* QL: mm_alloi */
mm_alloi:
/* QL:         jsr     mm_scafr(pc)    scan for free space */
    jsr mm_scafr(pc)
/* QL:         beq.s   M57_err_om          didn't find an adequate space */
    beq.s M57_err_om
/* QL:         sub.l   d1,d3           find what's going spare */
    sub.l d1,d3
/* QL:         beq.s   M57_re_link         exact fit is perfect */
    beq.s M57_re_link
/* QL:         cmp.l   d0,d3           is what's left over big enough for us? */
    cmp.l d0,d3
/* QL:         bgt.s   M57_split           yes, so we M57_split it up */
    bgt.s M57_split
/* QL:         add.l   d3,d1           not enough left over to make sense, so extend */
    add.l d3,d1
/* QL:         bra.s   M57_re_link         go eat the whole thing */
    bra.s M57_re_link
/* QL: M57_split */
M57_split:
/* QL:         add.l   d1,M57_hp_next(a1)  move link */
    add.l d1,M57_hp_next(a1)
/* QL:         move.l  a0,a1 */
    move.l a0,a1
/* QL:         add.l   d1,a1           find address of new free space */
    add.l d1,a1
/* QL:         move.l  d3,M57_hp_len(a1)   record its new length */
    move.l d3,M57_hp_len(a1)
/* QL: M57_re_link */
M57_re_link:
/* QL:         move.l  M57_hp_next(a0),d2  find address of next free space */
    move.l M57_hp_next(a0),d2
/* QL:         beq.s   M57_set_next        is it last link? */
    beq.s M57_set_next
/* QL:         add.l   a0,d2 */
    add.l a0,d2
/* QL:         sub.l   a1,d2           no - make it relative */
    sub.l a1,d2
/* QL: M57_set_next */
M57_set_next:
/* QL:         move.l  d2,M57_hp_next(a1)  reform free chain to skip allocated block */
    move.l d2,M57_hp_next(a1)
/* QL:         clr.l   M57_hp_next(a0)     being friendly, clear second word now */
    clr.l M57_hp_next(a0)
/* QL:         move.l  d1,M57_hp_len(a0)   put length allocated */
    move.l d1,M57_hp_len(a0)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M57_err_om */
M57_err_om:
/* QL:         moveq   #M57_err.om,d0      not enough space found */
    moveq #M57_err.om,d0
/* QL:         rts */
    rts 
/* QL:         end */
