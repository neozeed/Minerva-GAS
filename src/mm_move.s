/* ROM section mm_move */
.balign 2,0
/* QL: * d0 -  o- 0 (sets ccr) */
/* QL: * d1 -ip - number of bytes to move */
/* QL: * a0 -ip - destination address */
/* QL: * a1 -ip - source address (ignored by clear and M62_clrr) */
/* QL: * a6 -ip - base address (ignored by move and clear) */
/* QL: mm_clrr */
mm_clrr:
/* QL:         moveq   #M62_clrr-M62_mrtor,d0 */
    moveq #(M62_clrr-M62_mrtor),d0
/* QL:         bra.s   M62_mvrel */
    bra.s M62_mvrel
/* QL: mm_mrtoa */
mm_mrtoa:
/* QL:         moveq   #M62_mrtoa-M62_mrtor,d0 */
    moveq #(M62_mrtoa-M62_mrtor),d0
/* QL:         bra.s   M62_mvrel */
    bra.s M62_mvrel
/* QL: M62_mm_mator */
M62_mm_mator:
/* QL:         moveq   #M62_mator-M62_mrtor,d0 */
    moveq #(M62_mator-M62_mrtor),d0
/* QL:         bra.s   M62_mvrel */
    bra.s M62_mvrel
/* QL: mm_mrtor */
mm_mrtor:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M62_mvrel */
M62_mvrel:
/* QL:         move.l  a2,-(sp) */
    move.l a2,-(sp)
/* QL:         lea     M62_mrtor(pc,d0.w),a2 */
    lea M62_mrtor(pc,d0.w),a2
/* QL:         moveq   #M62_mt.extop,d0 */
    moveq #M62_mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  (sp)+,a2 */
    move.l (sp)+,a2
/* QL: M62_okrts */
M62_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * d0 -  o- 0 (sets ccr) */
/* QL: * d1 -ip - number of bytes to clear (<=0 = none) */
/* QL: * a0 -ip - address of area to clear */
/* QL: * a6 -ip - base address (M62_clrr only) */
/* QL: M62_clrr */
M62_clrr:
/* QL:         add.l   a6,a0           make address absolute */
    add.l a6,a0
/* QL:         pea     M62_matorex         return via common code */
    pea M62_matorex(pc)
/* QL: mm_clear */
mm_clear:
/* QL:         moveq   #32,d0          this needs tuning, though it's about right */
    moveq #32,d0
/* QL:         cmp.l   d1,d0 */
    cmp.l d1,d0
/* QL:         ble.s   M62_clr32           only do the hoopy clear if a fair bit needed */
    ble.s M62_clr32
/* QL:         move.l  d1,d0 */
    move.l d1,d0
/* QL:         ble.s   M62_okrts           finished if <= 0 bytes to do here */
    ble.s M62_okrts
/* QL: M62_clr1 */
M62_clr1:
/* QL:         sf      (a0)+           clear small areas a byte at a time */
    sf (a0)+
/* QL:         subq.b  #1,d0 */
    subq.b #1,d0
/* QL: M62_clrq */
M62_clrq:
/* QL:         bne.s   M62_clr1 */
    bne.s M62_clr1
/* QL:         sub.l   d1,a0           restore pointer */
    sub.l d1,a0
/* QL:         rts */
    rts 
/* QL: M62_clr32 */
M62_clr32:
/* QL:         move.l  d1,-(sp)        save original length */
    move.l d1,-(sp)
/* QL:         move.w  a0,d0           check start address */
    move.w a0,d0
/* QL:         lsr.b   #1,d0 */
    lsr.b #1,d0
/* QL:         bcc.s   M62_clreven */
    bcc.s M62_clreven
/* QL:         sf      (a0)+           if odd, clear the initial byte */
    sf (a0)+
/* QL:         subq.l  #1,d1 */
    subq.l #1,d1
/* QL: M62_clreven */
M62_clreven:
/* QL:         moveq   #0,d0           move.l is quicker than clr.l! */
    moveq #0,d0
/* QL:         move.b  d1,-(sp)        save any odd bytes needed at end */
    move.b d1,-(sp)
/* QL:         lsr.l   #5,d1           do rest in blocks of 32 */
    lsr.l #5,d1
/* QL:         bra.s   M62_clre            enter loop */
    bra.s M62_clre
/* QL: M62_clrh */
M62_clrh:
/* QL:         swap    d1 */
    swap d1
/* QL: M62_clrw */
M62_clrw:
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL:         move.l  d0,(a0)+ */
    move.l d0,(a0)+
/* QL: M62_clre */
M62_clre:
/* QL:         dbra    d1,M62_clrw */
    dbra d1,M62_clrw
/* QL:         swap    d1 */
    swap d1
/* QL:         dbra    d1,M62_clrh */
    dbra d1,M62_clrh
/* QL:         moveq   #31,d0 */
    moveq #31,d0
/* QL:         and.b   (sp)+,d0        get back any odd bytes that need doing */
    and.b (sp)+,d0
/* QL:         move.l  (sp)+,d1        reload full length */
    move.l (sp)+,d1
/* QL:         tst.b   d0 */
    tst.b d0
/* QL:         bra.s   M62_clrq            go do last bit */
    bra.s M62_clrq
/* QL: M62_mrtoa */
M62_mrtoa:
/* QL:         add.l   a6,a1 */
    add.l a6,a1
/* QL:         bsr.s   mm_move */
    bsr.s mm_move
/* QL:         sub.l   a6,a1 */
    sub.l a6,a1
/* QL:         rte */
    rte 
/* QL: M62_mrtor */
M62_mrtor:
/* QL:         add.l   a6,a1 */
    add.l a6,a1
/* QL:         bsr.s   M62_movtor */
    bsr.s M62_movtor
/* QL:         sub.l   a6,a1 */
    sub.l a6,a1
/* QL: M62_matorex */
M62_matorex:
/* QL:         sub.l   a6,a0 */
    sub.l a6,a0
/* QL:         rte */
    rte 
/* QL: mvreg   reg     d5-d6/a0-a1 */
/* QL: * Using "movep" instructions is a little faster than eight single byte moves on */
/* QL: * standard memory. Even quicker on faster memory. */
/* QL: mvpreg  reg     d2-d5   we need some more work registers */
/* QL: M62_mvph */
M62_mvph:
/* QL:         swap    d0 */
    swap d0
/* QL: M62_mvpw */
M62_mvpw:
/* QL:         movep.l 0(a1),d2 */
    movep.l 0(a1),d2
/* QL:         movep.l 1(a1),d3 */
    movep.l 1(a1),d3
/* QL:         movep.l 8(a1),d4 */
    movep.l 8(a1),d4
/* QL:         movep.l 9(a1),d5 */
    movep.l 9(a1),d5
/* QL:         movep.l d2,0(a0) */
    movep.l d2,0(a0)
/* QL:         movep.l d3,1(a0) */
    movep.l d3,1(a0)
/* QL:         movep.l d4,8(a0) */
    movep.l d4,8(a0)
/* QL:         movep.l d5,9(a0) */
    movep.l d5,9(a0)
/* QL: M62_mvpu */
M62_mvpu:
/* QL:         add.l   d6,a1 */
    add.l d6,a1
/* QL:         add.l   d6,a0 */
    add.l d6,a0
/* QL: M62_mvpd */
M62_mvpd:
/* QL:         dbra    d0,M62_mvpw */
    dbra d0,M62_mvpw
/* QL:         swap    d0 */
    swap d0
/* QL:         dbra    d0,M62_mvph */
    dbra d0,M62_mvph
/* QL:         movem.l (sp)+,mvpreg */
    movem.l (sp)+,d2-d5
/* QL:         tst.b   d6 */
    tst.b d6
/* QL:         bpl.s   M62_mvdbe */
    bpl.s M62_mvdbe
/* QL:         sub.l   d6,a1 */
    sub.l d6,a1
/* QL:         sub.l   d6,a0 */
    sub.l d6,a0
/* QL:         bra.s   M62_mvube */
    bra.s M62_mvube
/* QL: M62_mvp */
M62_mvp:
/* QL:         moveq   #15,d5 */
    moveq #15,d5
/* QL:         and.b   d0,d5 */
    and.b d0,d5
/* QL:         asr.l   #4,d0 */
    asr.l #4,d0
/* QL:         movem.l mvpreg,-(sp) */
    movem.l d2-d5,-(sp)
/* QL:         tst.b   d6 */
    tst.b d6
/* QL:         bpl.s   M62_mvpd */
    bpl.s M62_mvpd
/* QL:         bra.s   M62_mvpu */
    bra.s M62_mvpu
/* QL: M62_mator */
M62_mator:
/* QL:         pea     M62_matorex */
    pea M62_matorex(pc)
/* QL: M62_movtor */
M62_movtor:
/* QL:         add.l   a6,a0 */
    add.l a6,a0
/* QL: mm_move */
mm_move:
/* QL:         move.l  d1,d0 */
    move.l d1,d0
/* QL:         ble.s   M62_mvok            don't bother if zero (or negative!) amount */
    ble.s M62_mvok
/* QL:         movem.l mvreg,-(sp) */
    movem.l d5-d6/a0-a1,-(sp)
/* QL:         moveq   #16,d6          flag for move down and maybe "movep" step */
    moveq #16,d6
/* QL:         move.l  a0,d5 */
    move.l a0,d5
/* QL:         sub.l   a1,d5           going up or going down? */
    sub.l a1,d5
/* QL:         bcs.s   M62_mvset           down - start doing it */
    bcs.s M62_mvset
/* QL:         beq.s   M62_mvend           neither - leave memory just where it is! */
    beq.s M62_mvend
/* QL:         cmp.l   d0,d5           do areas overlap? */
    cmp.l d0,d5
/* QL:         bcc.s   M62_mvset           no - we can move down, it's quicker! */
    bcc.s M62_mvset
/* QL:         add.l   d0,a1           top of source */
    add.l d0,a1
/* QL:         add.l   d0,a0           top of destination */
    add.l d0,a0
/* QL:         moveq   #-16,d6         "movep" step and direction flag */
    moveq #(-16),d6
/* QL: M62_mvset */
M62_mvset:
/* QL:         asr.b   #1,d5           is move travelling an odd distance? */
    asr.b #1,d5
/* QL:         bcs.s   M62_mvp             yes - use "movep" instructions */
    bcs.s M62_mvp
/* QL:         move.w  a1,d5 */
    move.w a1,d5
/* QL:         asr.b   #1,d5           are addresses currently odd? */
    asr.b #1,d5
/* QL:         bcc.s   M62_mvword */
    bcc.s M62_mvword
/* QL:         subq.l  #1,d0           yes - count one off the total */
    subq.l #1,d0
/* QL:         tst.b   d6 */
    tst.b d6
/* QL:         bmi.s   M62_mv1up */
    bmi.s M62_mv1up
/* QL:         move.b  (a1)+,(a0)+     move odd byte to get both on word bdrys */
    move.b (a1)+,(a0)+
/* QL:         bra.s   M62_mvword */
    bra.s M62_mvword
/* QL: M62_mvub */
M62_mvub:
/* QL:         move.b  -(a1),-(a0) */
    move.b -(a1),-(a0)
/* QL: M62_mvube */
M62_mvube:
/* QL:         dbra    d5,M62_mvub */
    dbra d5,M62_mvub
/* QL:         bra.s   M62_mvend */
    bra.s M62_mvend
/* QL: M62_mvdb */
M62_mvdb:
/* QL:         move.b  (a1)+,(a0)+ */
    move.b (a1)+,(a0)+
/* QL: M62_mvdbe */
M62_mvdbe:
/* QL:         dbra    d5,M62_mvdb */
    dbra d5,M62_mvdb
/* QL: M62_mvend */
M62_mvend:
/* QL:         movem.l (sp)+,mvreg */
    movem.l (sp)+,d5-d6/a0-a1
/* QL: M62_mvok */
M62_mvok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M62_mvulh */
M62_mvulh:
/* QL:         swap    d0 */
    swap d0
/* QL: M62_mvulw */
M62_mvulw:
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL:         move.l -(a1),-(a0) */
    move.l -(a1),-(a0)
/* QL: M62_mvule */
M62_mvule:
/* QL:         dbra    d0,M62_mvulw */
    dbra d0,M62_mvulw
/* QL:         swap    d0 */
    swap d0
/* QL:         dbra    d0,M62_mvulh */
    dbra d0,M62_mvulh
/* QL:         bra.s   M62_mvube */
    bra.s M62_mvube
/* QL: M62_mvdlh */
M62_mvdlh:
/* QL:         swap    d0 */
    swap d0
/* QL: M62_mvdlw */
M62_mvdlw:
/* QL: * We've taken so long getting here, make it worth our while! */
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL:         move.l (a1)+,(a0)+ */
    move.l (a1)+,(a0)+
/* QL: M62_mvdle */
M62_mvdle:
/* QL:         dbra    d0,M62_mvdlw */
    dbra d0,M62_mvdlw
/* QL:         swap    d0 */
    swap d0
/* QL:         dbra    d0,M62_mvdlh */
    dbra d0,M62_mvdlh
/* QL:         bra.s   M62_mvdbe */
    bra.s M62_mvdbe
/* QL: M62_mv1up */
M62_mv1up:
/* QL:         move.b  -(a1),-(a0) */
    move.b -(a1),-(a0)
/* QL: M62_mvword */
M62_mvword:
/* QL:         moveq   #31,d5          addresses even, move 32 bytes at a go */
    moveq #31,d5
/* QL:         and.l   d0,d5 */
    and.l d0,d5
/* QL:         lsr.l   #5,d0 */
    lsr.l #5,d0
/* QL:         tst.w   d6 */
    tst.w d6
/* QL:         bpl.s   M62_mvdle */
    bpl.s M62_mvdle
/* QL:         bra.s   M62_mvule */
    bra.s M62_mvule
/* QL:         vect4000 mm_clear,mm_clrr,M62_mm_mator,mm_move,mm_mrtoa,mm_mrtor */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ mm$clear,(mm_clear-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ mm$clrr,(mm_clrr-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ mm$mator,(M62_mm_mator-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ mm$move,(mm_move-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ mm$mrtoa,(mm_mrtoa-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ mm$mrtor,(mm_mrtor-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
