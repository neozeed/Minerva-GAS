/* ROM section mm_lnkfr */
.balign 2,0
/* QL: * d1 -i o- length of new free space / length of final free space */
/* QL: * d2 -  o- offset stored in final free space, zero if end of free chain */
/* QL: * a0 -i o- address of new free space / offset a1-a2 at end */
/* QL: * a1 -i o- pointer to link / pointer to resultant free space */
/* QL: * a2 -  o- pointer to preceeding free space */
/* QL: mm_lnkf0 */
mm_lnkf0:
/* QL:         clr.l   M56_hp_owner(a0)    for system heaps mark the owner 0 */
    clr.l M56_hp_owner(a0)
/* QL: * Should we do something with the rflag as well? */
/* QL: * E.g. setting the top bit of rflag and using the rest for something nice! */
/* QL: mm_lnkfr */
mm_lnkfr:
/* QL:         subq.l  #M56_hp_next,a1     fiddle the call pointer */
    subq.l #M56_hp_next,a1
/* QL: * Loop through free space link pointers and link in new block */
/* QL: * a2 points to previous block, a1 to current block */
/* QL:         move.l  d3,-(sp)        we will preserve d3 here, to be friendly */
    move.l d3,-(sp)
/* QL:         sub.l   a2,a2           no previous pointer */
    sub.l a2,a2
/* QL: M56_fr_loop */
M56_fr_loop:
/* QL:         move.l  a2,d3           remember previous pointer */
    move.l a2,d3
/* QL:         move.l  a1,a2           get next link pointer */
    move.l a1,a2
/* QL:         move.l  M56_hp_next(a1),d2 */
    move.l M56_hp_next(a1),d2
/* QL:         beq.s   M56_prelink         is it last link? */
    beq.s M56_prelink
/* QL:         add.l   d2,a1           no - set address of next */
    add.l d2,a1
/* QL:         cmp.l   a0,a1           check if pointer past new space */
    cmp.l a0,a1
/* QL:         ble.s   M56_fr_loop */
    ble.s M56_fr_loop
/* QL: * < 2nd prior > ... < prior free > ... < new freed > ... < next free > ... */
/* QL: * d3:??/??          a2:??/d2           a0:??/??          a1:??/?? */
/* QL:         move.l  a1,d2 */
    move.l a1,d2
/* QL:         sub.l   a0,d2           make intended forward relative link to next */
    sub.l a0,d2
/* QL:         cmp.l   d1,d2           does next coalesce with the new block? */
    cmp.l d1,d2
/* QL:         bne.s   M56_prelink */
    bne.s M56_prelink
/* QL:         assert  0,M56_hp_len,M56_hp_next-4 */
/* original assertion: 0,M56_hp_len,M56_hp_next-4 */
/* QL:         add.l   (a1)+,d1        yes - extend length of freed block */
    add.l (a1)+,d1
/* QL:         add.l   (a1),d2         add relative offset to what we have so far */
    add.l (a1),d2
/* QL: * < 2nd prior > ... < prior free > ... < new freed > ... */
/* QL: * d3:??/??          a2:??/??           a0:??/??, d1=length, d2=offset to next */
/* QL: M56_prelink */
M56_prelink:
/* QL:         tst.l   d3              is there in fact a 2nd prior? */
    tst.l d3
/* QL:         beq.s   M56_linkit          no - we were right at the start, so skip this */
    beq.s M56_linkit
/* QL:         move.l  a0,a1 */
    move.l a0,a1
/* QL:         sub.l   a2,a1 */
    sub.l a2,a1
/* QL:         cmp.l   (a2),a1         does prior join up with free block? */
    cmp.l (a2),a1
/* QL:         bne.s   M56_linkit */
    bne.s M56_linkit
/* QL:         move.l  a2,a0           yes - let's shuffle ourselves down there */
    move.l a2,a0
/* QL:         move.l  d3,a2           move up 2nd prior to prior now */
    move.l d3,a2
/* QL:         add.l   a1,d1           increase length */
    add.l a1,d1
/* QL:         add.l   a1,d2           increase relative offset */
    add.l a1,d2
/* QL: * < prior free > ... < new freed > ... */
/* QL: * a2:??/??           a0:??/??, d1=length, d2=offset to next */
/* QL: M56_linkit */
M56_linkit:
/* QL:         move.l  (sp)+,d3        finished with d3 now */
    move.l (sp)+,d3
/* QL:         cmp.l   d1,d2           in all the machinations, is this the last free? */
    cmp.l d1,d2
/* QL:         bgt.s   M56_setlnk          no, as the offset is beyond this block */
    bgt.s M56_setlnk
/* QL: * Note: we don't need to check anything more complex than this. The value of d2 */
/* QL: * we get here with may indeed be an offset to a free block that we have */
/* QL: * coalesced, but that'll be fine. */
/* QL:         moveq   #0,d2           yes! make the offset a proper zero */
    moveq #0,d2
/* QL: M56_setlnk */
M56_setlnk:
/* QL:         movem.l d1-d2,(a0)      set new area's length and relative link */
    movem.l d1-d2,(a0)
/* QL:         move.l  a0,a1           want to return it in a1, for some reason... */
    move.l a0,a1
/* QL:         sub.l   a2,a0 */
    sub.l a2,a0
/* QL:         move.l  a0,M56_hp_next(a2)  set prior free's link to the new free area */
    move.l a0,M56_hp_next(a2)
/* QL: * Note: setting that one last ensures that the free chain has never been */
/* QL: * in a corrupt state during any of the proceedings. Also, the "movem" ensures */
/* QL: * similarly valid handling when we have coalesced with a preceeding space. In */
/* QL: * this particular case, the final move of a0 is actually redundant! */
/* QL: * < prior free > ... < new freed > ... */
/* QL: * a2:??/a0           a1:d1/d2 */
/* QL:         rts */
    rts 
/* QL:         end */
