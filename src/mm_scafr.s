/* ROM section mm_scafr */
.balign 2,0
/* QL: * N.B. Changed to do unsigned comparisons of lengths, so as not to be caught */
/* QL: * out by people asking for negative space! */
/* QL: * The outputs are confusing when presented all together, so here they are in */
/* QL: * the differing request/result states: */
/* QL: * If there was no adequate space, ccr is zero and: */
/* QL: *       a0 and a1 are each the pointer to the last free space. */
/* QL: *       a2, d2 and d3 are all zero. */
/* QL: * If d0.w is non-zero and an adequate space is found, ccr is tst.w d0 and: */
/* QL: *       a1 and a2 are each the pointer the pointer to the space. */
/* QL: *       a0 is its base address. */
/* QL: *       d2 and d3 are each its size. */
/* QL: * If d0.w is zero and any adequate spaces have been found, ccr is zero and: */
/* QL: *       a0 and a1 are each the pointer to the last free space. */
/* QL: *       d3 is zero. */
/* QL: *       d2 records the size of largest adequate space that was found. */
/* QL: *       a2 is the pointer to the pointer to the last adequate space. */
/* QL: * d0 -ip - word non-zero exits at first adequate free space, zero scans all */
/* QL: * d1 -i o- free space required / rounded up to allocation multiple */
/* QL: * d2 -i    allocation multiple less one (7..32767, must be 2^n-1) */
/* QL: *       o- length of longest adequate free space, or zero if none */
/* QL: * d3 -  o- if d0=0 and space found, length of free space, otherwise zero */
/* QL: * a0 -i    pointer to pointer to free space */
/* QL: *       o- if d0=0 and found last free space, otherwise same as a1 */
/* QL: * a1 -  o- free space preceeding last free space scanned */
/* QL: * a2 -  o- free space preceeding last adequate free space found, zero if none */
/* QL: * CCR-  o- non-zero (tst.w d0) only when a good space is found */
/* QL: mm_scafr */
mm_scafr:
/* QL:         add.l   d2,d1 */
    add.l d2,d1
/* QL:         not.w   d2 */
    not.w d2
/* QL:         and.w   d2,d1           round length up to nearest allocation multiple */
    and.w d2,d1
/* QL:         moveq   #0,d2           initialise longest space */
    moveq #0,d2
/* QL:         sub.l   a2,a2           initialise pointer to last adequate free space */
    sub.l a2,a2
/* QL:         subq.l  #M54_hp_next,a0     fiddle the call pointer */
    subq.l #M54_hp_next,a0
/* QL: M54_fr_loop */
M54_fr_loop:
/* QL:         move.l  a0,a1           save pointer to prior free block */
    move.l a0,a1
/* QL:         move.l  M54_hp_next(a0),d3  get link */
    move.l M54_hp_next(a0),d3
/* QL:         beq.s   M54_rts0            zero - we've reached the end of the free chain */
    beq.s M54_rts0
/* QL:         add.l   d3,a0           point to next free block */
    add.l d3,a0
/* QL:         move.l  M54_hp_len(a0),d3   get length of this block */
    move.l M54_hp_len(a0),d3
/* QL:         cmp.l   d1,d3           is this adquate? */
    cmp.l d1,d3
/* QL:         bcs.s   M54_fr_loop         no - go look at next block */
    bcs.s M54_fr_loop
/* QL:         move.l  a1,a2           save pointer to prior free block */
    move.l a1,a2
/* QL:         cmp.l   d3,d2           is this block bigger than the largest so far? */
    cmp.l d3,d2
/* QL:         bcc.s   M54_maxok */
    bcc.s M54_maxok
/* QL:         move.l  d3,d2           yes - save new maximum length */
    move.l d3,d2
/* QL: M54_maxok */
M54_maxok:
/* QL:         tst.w   d0              were we asked scan the whole chain? */
    tst.w d0
/* QL:         beq.s   M54_fr_loop         yes - carry on scanning */
    beq.s M54_fr_loop
/* QL: M54_rts0 */
M54_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
