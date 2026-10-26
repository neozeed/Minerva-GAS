/* ROM section gw_pixel */
.balign 2,0
/* QL: * d0 -ip - x coordinate (lsw) */
/* QL: * d1 -ip - y coordinate (lsw) */
/* QL: * d2 -ip - mask within word fro pixel (lsw) */
/* QL: * d3 -ip - colour masks (msw/lsw) */
/* QL: * a5 -ip - screen word address for pixel */
/* QL: * a6 -ip - stack frame */
/* QL: * d4 destroyed */
/* QL: reglist reg     d0-d3/a0-a1 */
/* QL: gw_pixel */
gw_pixel:
/* QL:         assert  M171_xsize,M171_ysize-2 */
/* original assertion: M171_xsize,M171_ysize-2 */
/* QL:         move.l  M171_xsize(a6),d4 */
    move.l M171_xsize(a6),d4
/* QL:         cmp.w   d4,d1           if y outside window then do nothing */
    cmp.w d4,d1
/* QL:         bcc.s   M171_rts0 */
    bcc.s M171_rts0
/* QL:         swap    d4 */
    swap d4
/* QL:         tst.b   M171_fmod(a6) */
    tst.b M171_fmod(a6)
/* QL:         bne.s   M171_do_fill         if fill mode is on then go to it */
    bne.s M171_do_fill
/* QL: M171_dodot */
M171_dodot:
/* QL:         cmp.w   d4,d0           if x outside window then do nothing */
    cmp.w d4,d0
/* QL:         bcc.s   M171_rts0 */
    bcc.s M171_rts0
/* QL:         move.w  d3,d4           set up colour mask */
    move.w d3,d4
/* QL:         and.w   d2,d4 */
    and.w d2,d4
/* QL:         tst.b   M171_over(a6) */
    tst.b M171_over(a6)
/* QL:         beq.s   M171_setit */
    beq.s M171_setit
/* QL:         eor.w   d4,(a5)         xor it in */
    eor.w d4,(a5)
/* QL: M171_rts0 */
M171_rts0:
/* QL:         rts */
    rts 
/* QL: M171_setit */
M171_setit:
/* QL:         move.w  d2,d5           write colour on top */
    move.w d2,d5
/* QL:         or.w    (a5),d5         fetch old stuff, but set our bit all ones */
    or.w (a5),d5
/* QL:         sub.w   d2,d5           then knock them out */
    sub.w d2,d5
/* QL:         add.w   d4,d5           and put in what we want */
    add.w d4,d5
/* QL:         move.w  d5,(a5) */
    move.w d5,(a5)
/* QL:         rts */
    rts 
/* QL: M171_first */
M171_first:
/* QL:         move.w  d2,-(a1) */
    move.w d2,-(a1)
/* QL:         move.w  d0,-(a1)        store M171_single pixel range */
    move.w d0,-(a1)
/* QL: M171_single */
M171_single:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d0-d3/a0-a1
/* QL:         bge.s   M171_dodot           now go back to put in this dot */
    bge.s M171_dodot
/* QL:         rts */
    rts 
/* QL: M171_do_fill */
M171_do_fill:
/* QL:         movem.l reglist,-(sp)   ... save a few registers ! */
    movem.l d0-d3/a0-a1,-(sp)
/* QL:         move.l  M171_chnp(a6),a0     retrieve the channel defn ptr */
    move.l M171_chnp(a6),a0
/* QL:         move.w  d1,a1 */
    move.w d1,a1
/* QL:         add.l   a1,a1 */
    add.l a1,a1
/* QL:         lea     M171_hp_end(a1,a1.l),a1 */
    lea M171_hp_end(a1,a1.l),a1
/* QL:         add.l   M171_sd_fbuf(a0),a1  256 word pairs, one pair for each line */
    add.l M171_sd_fbuf(a0),a1
/* QL:         move.w  M171_xinc(a6),d2     calculate M171_right edge of pixel */
    move.w M171_xinc(a6),d2
/* QL:         add.w   d0,d2 */
    add.w d0,d2
/* QL:         bvc.s   M171_nothuge */
    bvc.s M171_nothuge
/* QL:         move.w  d0,d2 */
    move.w d0,d2
/* QL: M171_nothuge */
M171_nothuge:
/* QL:         tst.l   (a1)+ */
    tst.l (a1)+
/* QL:         beq.s   M171_first */
    beq.s M171_first
/* QL:         cmp.w   -(a1),d0 */
    cmp.w -(a1),d0
/* QL:         bge.s   M171_right */
    bge.s M171_right
/* QL:         cmp.w   -(a1),d0 */
    cmp.w -(a1),d0
/* QL:         bge.s   M171_inside */
    bge.s M171_inside
/* QL:         move.w  (a1),d2         get left edge of existing area */
    move.w (a1),d2
/* QL:         move.w  d0,(a1)         replace with this pixel to extend it left */
    move.w d0,(a1)
/* QL: M171_check */
M171_check:
/* QL:         bge.s   M171_lowok           if low is negative we must bring it up to zero */
    bge.s M171_lowok
/* QL:         clr.w   d0 */
    clr.w d0
/* QL: M171_lowok */
M171_lowok:
/* QL:         cmp.w   d2,d4           if M171_right edge escapes window, trim it down */
    cmp.w d2,d4
/* QL:         bge.s   M171_highok */
    bge.s M171_highok
/* QL:         move.w  d4,d2 */
    move.w d4,d2
/* QL: M171_highok */
M171_highok:
/* QL:         sub.w   d0,d2           now establish exactly how much we're doing */
    sub.w d0,d2
/* QL:         cmp.w   M171_xinc(a6),d2 */
    cmp.w M171_xinc(a6),d2
/* QL:         ble.s   M171_single          if M171_single then do it quick */
    ble.s M171_single
/* QL:         swap    d3 */
    swap d3
/* QL:         move.w  d3,-(sp)        msw */
    move.w d3,-(sp)
/* QL:         move.l  d3,-(sp)        lsw,msw,msw */
    move.l d3,-(sp)
/* QL:         move.w  (sp),-(sp)      lsw,lsw,msw,msw */
    move.w (sp),-(sp)
/* QL:         move.l  sp,a1 */
    move.l sp,a1
/* QL:         add.w   M171_xmin(a6),d0     add x origin */
    add.w M171_xmin(a6),d0
/* QL:         add.w   M171_ymin(a6),d1     add y origin */
    add.w M171_ymin(a6),d1
/* QL:         moveq   #1,d3           just the one row high */
    moveq #1,d3
/* QL:         tst.b   M171_over(a6) */
    tst.b M171_over(a6)
/* QL:         beq.s   M171_fill_it */
    beq.s M171_fill_it
/* QL:         jsr     cs_over(pc) */
    jsr cs_over(pc)
/* QL: M171_done */
M171_done:
/* QL:         addq.l  #8,sp */
    addq.l #8,sp
/* QL: M171_inside */
M171_inside:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d0-d3/a0-a1
/* QL:         rts */
    rts 
/* QL: M171_right */
M171_right:
/* QL:         move.w  (a1),d0         get old M171_right edge as start of fill area */
    move.w (a1),d0
/* QL:         move.w  d2,(a1)         extent M171_right to new edge */
    move.w d2,(a1)
/* QL:         tst.w   d0 */
    tst.w d0
/* QL:         bra.s   M171_check */
    bra.s M171_check
/* QL: M171_fill_it */
M171_fill_it:
/* QL:         jsr     cs_fill(pc) */
    jsr cs_fill(pc)
/* QL:         bra.s   M171_done */
    bra.s M171_done
/* QL:         end */
