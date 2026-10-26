/* ROM section ut_link */
.balign 2,0
/* QL: * a0 cr  pointer to item to be added or removed */
/* QL: * a1 cr  pointer to start of linked list / pointer to previous item */
/* QL: ut_link */
ut_link:
/* QL:         move.l  (a1),(a0)       put pointer to next in this item */
    move.l (a1),(a0)
/* QL:         move.l  a0,(a1)         and link it in */
    move.l a0,(a1)
/* QL:         rts */
    rts 
/* QL: M69_nxt_link */
M69_nxt_link:
/* QL:         move.l  (a1),a1         get next link */
    move.l (a1),a1
/* QL: ut_unlnk */
ut_unlnk:
/* QL:         tst.l   (a1) */
    tst.l (a1)
/* QL:         beq.s   M69_end_unlk        give up at end of list */
    beq.s M69_end_unlk
/* QL:         cmp.l   (a1),a0 */
    cmp.l (a1),a0
/* QL:         bne.s   M69_nxt_link        loop until we find pointer to item */
    bne.s M69_nxt_link
/* QL:         move.l  (a0),(a1)       move link pointer back in list */
    move.l (a0),(a1)
/* QL: M69_end_unlk */
M69_end_unlk:
/* QL:         rts */
    rts 
/* QL:         end */
