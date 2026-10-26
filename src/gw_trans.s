/* ROM section gw_trans */
.balign 2,0
/* QL: * d0 -ip - start point x coordinate (lsw) */
/* QL: * d1 -ip - start point y coordinate (lsw) */
/* QL: * d2 -i o- alpha / pixel word mask */
/* QL: * d3 -i o- beta / colour masks */
/* QL: * d4 -i  - gamma */
/* QL: * d6 -i o- u / a0 */
/* QL: * d7 -i o- v / b0 */
/* QL: * a0 -i o- channel definition / d0 */
/* QL: * a1 -  o- k1 */
/* QL: * a2 -  o- k2 */
/* QL: * a3 -  o- k3 */
/* QL: * a5 -  o- pixel word address */
/* QL: * a6 -ip - stack frame */
/* QL: * d5 destroyed */
/* QL: gw_trans */
gw_trans:
/* QL: * Clean up which way we're being told to curve. If it's not anticlockwise, */
/* QL: * we effectively mirror across the y-axis. */
/* QL:         clr.w   -(sp)           set square y increment in lsw to zero */
    clr.w -(sp)
/* QL:         move.w  M175_xinc(a6),-(sp)  get basic x increment into msw */
    move.w M175_xinc(a6),-(sp)
/* QL:         move.l  d2,d5 */
    move.l d2,d5
/* QL:         or.l    d3,d5           are alpha and beta non-negative? */
    or.l d3,d5
/* QL:         bpl.s   M175_clock           yes - going anticlockwise already */
    bpl.s M175_clock
/* QL:         neg.l   d2              negate alpha */
    neg.l d2
/* QL:         neg.l   d3              negate beta */
    neg.l d3
/* QL:         neg.l   d6              negate u */
    neg.l d6
/* QL:         neg.w   (sp)            negate dx */
    neg.w (sp)
/* QL: M175_clock */
M175_clock:
/* QL: * Next we can simplify our initial octant decisions by a 180 degree rotation */
/* QL:         moveq   #1,d5           diagonal y-increment */
    moveq #1,d5
/* QL:         tst.l   d6 */
    tst.l d6
/* QL:         bpl.s   M175_rotok           if u > 0, leave it alone */
    bpl.s M175_rotok
/* QL:         bne.s   M175_rotgo           if u < 0, rotate */
    bne.s M175_rotgo
/* QL:         tst.l   d7 */
    tst.l d7
/* QL:         ble.s   M175_rotok           if u = 0 and u <= 0, leave it alone */
    ble.s M175_rotok
/* QL: M175_rotgo */
M175_rotgo:
/* QL:         neg.l   d6              negate u */
    neg.l d6
/* QL:         neg.l   d7              negate v */
    neg.l d7
/* QL:         neg.w   d5              change y increment to minus one */
    neg.w d5
/* QL:         neg.w   (sp)            negate dx */
    neg.w (sp)
/* QL: M175_rotok */
M175_rotok:
/* QL:         move.w  (sp),M175_ddx(a6)    store octant zero diagonal move dx */
    move.w (sp),M175_ddx(a6)
/* QL:         move.w  d5,M175_ddy(a6)      store octant zero diagonal move dy */
    move.w d5,M175_ddy(a6)
/* QL:         assert  M175_sdx,M175_sdy-2 */
/* original assertion: M175_sdx,M175_sdy-2 */
/* QL:         move.l  (sp)+,M175_sdx(a6)   store octant zero square move dx,dy */
    move.l (sp)+,M175_sdx(a6)
/* QL: * Now set up for how many octant changes remain to be done. */
/* QL: * We will only need to do at most one clockwise or one or two anti-clockwise. */
/* QL: * The reason this has had to be very finicky is because we must ensure that */
/* QL: * the octant we start in always curls clockwise properly. */
/* QL:         move.l  d7,-(sp) */
    move.l d7,-(sp)
/* QL:         smi     M175_octch(a6)       if v >= 0, clockwise is diagonal first */
    smi M175_octch(a6)
/* QL:         bmi.s   M175_oct67           if v < 0, we need at least one anticlockwise */
    bmi.s M175_oct67
/* QL:         not.l   (sp)            if v >= 0, we may need one clockwise */
    not.l (sp)
/* QL: M175_oct67 */
M175_oct67:
/* QL:         add.l   d6,(sp)         if 0 <= u < -v or 0 < u <= v ... see later */
    add.l d6,(sp)
/* QL: * Now set up all the algorithm's registers */
/* QL:         move.l  d3,a1           k1 = beta */
    move.l d3,a1
/* QL:         sub.l   d4,d3 */
    sub.l d4,d3
/* QL:         move.l  d3,a2           k2 = beta - gamma */
    move.l d3,a2
/* QL:         move.l  d2,a3 */
    move.l d2,a3
/* QL:         sub.l   d4,a3 */
    sub.l d4,a3
/* QL:         add.l   a2,a3           k3 = alpha - 2*gamma + beta */
    add.l a2,a3
/* QL:         asr.l   #1,d3 */
    asr.l #1,d3
/* QL:         add.l   d3,d7           b0 = v + k2/2 */
    add.l d3,d7
/* QL:         asr.l   #1,d2 */
    asr.l #1,d2
/* QL:         sub.l   d6,d2 */
    sub.l d6,d2
/* QL:         asr.l   #1,d2 */
    asr.l #1,d2
/* QL:         add.l   d7,d2           d0 = b0 - u/2 + alpha/4 */
    add.l d7,d2
/* QL:         sub.l   d7,d6           a0 = u - b0 */
    sub.l d7,d6
/* QL:         move.l  d2,-(sp)        save d0 */
    move.l d2,-(sp)
/* QL:         jsr     gw_pixad(pc)    find pixel address and masks */
    jsr gw_pixad(pc)
/* QL:         move.l  (sp)+,a0        put d0 where it belongs */
    move.l (sp)+,a0
/* QL: * Finally, we set which octant we are starting in */
/* QL:         move.b  M175_octch(a6),3(sp) did we select anticlockwise? (and save it) */
    move.b M175_octch(a6),3(sp)
/* QL:         bsr.s   M175_choct           always one octant change if going anticlockwise */
    bsr.s M175_choct
/* QL:         tst.b   (sp)+           did we want one clockwise or two anticlockwise? */
    tst.b (sp)+
/* QL:         bsr.s   M175_choct           one more possible octant change */
    bsr.s M175_choct
/* QL:         move.w  (sp)+,d5        get back which way we were spinning */
    move.w (sp)+,d5
/* QL:         eor.b   d5,M175_octch(a6)    from here on in on we go clockwise */
    eor.b d5,M175_octch(a6)
/* QL: M175_rts0 */
M175_rts0:
/* QL:         rts */
    rts 
/* QL: M175_choct */
M175_choct:
/* QL:         bpl.s   M175_rts0 */
    bpl.s M175_rts0
/* QL:         jmp     gw_choct(pc)    we only do this if -ve flag was set */
    jmp gw_choct(pc)
/* QL:         end */
