/* ROM section gw_choct */
.balign 2,0
/* QL: * d6 -i o- a */
/* QL: * d7 -i o- b */
/* QL: * a0 -i o- d */
/* QL: * a1 -i o- k1 */
/* QL: * a2 -i o- k2 */
/* QL: * a3 -i o- k3 */
/* QL: * a6 -ip - stack frame */
/* QL: * d4-d5 destroyed */
/* QL: gw_choct */
gw_choct:
/* QL:         not.b   M173_octch(a6)       which one are we expecting? */
    not.b M173_octch(a6)
/* QL:         bne.s   M173_diag            if diagonal, go do it */
    bne.s M173_diag
/* QL: * Do a square octant change, to get b positive */
/* QL:         tst.w   M173_sdx(a6) */
    tst.w M173_sdx(a6)
/* QL:         bne.s   M173_ddxok */
    bne.s M173_ddxok
/* QL:         neg.w   M173_ddx(a6) */
    neg.w M173_ddx(a6)
/* QL: M173_ddxok */
M173_ddxok:
/* QL: * if M173_sdy=0:M173_ddy=-M173_ddy */
/* QL:         tst.w   M173_sdy(a6) */
    tst.w M173_sdy(a6)
/* QL:         bne.s   M173_ddyok */
    bne.s M173_ddyok
/* QL:         neg.w   M173_ddy(a6) */
    neg.w M173_ddy(a6)
/* QL: M173_ddyok */
M173_ddyok:
/* QL: * Calculate new variable values for d,b,a,k1,k2,k3 */
/* QL:         move.l  a1,d4 */
    move.l a1,d4
/* QL:         neg.l   d4 */
    neg.l d4
/* QL:         move.l  d4,a1           k1' = -k1 */
    move.l d4,a1
/* QL:         add.l   a2,d4           w = k2 + k1' */
    add.l a2,d4
/* QL:         move.l  d4,a2 */
    move.l d4,a2
/* QL:         add.l   a1,a2           k2' = w + k1' */
    add.l a1,a2
/* QL:         neg.l   d7 */
    neg.l d7
/* QL:         add.l   d4,d7           b' = w - b */
    add.l d4,d7
/* QL:         move.l  d7,d5 */
    move.l d7,d5
/* QL:         sub.l   d6,d5 */
    sub.l d6,d5
/* QL:         sub.l   a0,d5 */
    sub.l a0,d5
/* QL:         move.l  d5,a0           d' = b' - a - d */
    move.l d5,a0
/* QL:         sub.l   d7,d6 */
    sub.l d7,d6
/* QL:         sub.l   d7,d6 */
    sub.l d7,d6
/* QL:         add.l   d4,d6           a' = a - 2*b' + w */
    add.l d4,d6
/* QL:         lsl.l   #2,d4 */
    lsl.l #2,d4
/* QL:         sub.l   a3,d4 */
    sub.l a3,d4
/* QL:         move.l  d4,a3           k3' = 4*w - k3 */
    move.l d4,a3
/* QL:         rts */
    rts 
/* QL: * Change the movement data across a diagonal boundary */
/* QL: M173_diag */
M173_diag:
/* QL:         tst.w   M173_sdy(a6) */
    tst.w M173_sdy(a6)
/* QL:         bne.s   M173_sdyok           if M173_sdy is zero */
    bne.s M173_sdyok
/* QL:         clr.w   M173_sdx(a6)         M173_sdx = 0 */
    clr.w M173_sdx(a6)
/* QL:         move.w  M173_ddy(a6),M173_sdy(a6) M173_sdy = M173_ddy */
    move.w M173_ddy(a6),M173_sdy(a6)
/* QL:         bra.s   M173_sdxok */
    bra.s M173_sdxok
/* QL: M173_sdyok */
M173_sdyok:
/* QL:         tst.w   M173_sdx(a6) */
    tst.w M173_sdx(a6)
/* QL:         bne.s   M173_sdxok           else if M173_sdx is zero */
    bne.s M173_sdxok
/* QL:         clr.w   M173_sdy(a6)         M173_sdy = 0 */
    clr.w M173_sdy(a6)
/* QL:         move.w  M173_ddx(a6),M173_sdx(a6) M173_sdx = M173_ddx */
    move.w M173_ddx(a6),M173_sdx(a6)
/* QL: M173_sdxok */
M173_sdxok:
/* QL: * Calculate new d,b,a,k1,k2 and k3 */
/* QL:         move.l  a3,d4 */
    move.l a3,d4
/* QL:         neg.l   d4 */
    neg.l d4
/* QL:         move.l  d4,a3           k3' = -k3 */
    move.l d4,a3
/* QL:         add.l   a2,d4 */
    add.l a2,d4
/* QL:         add.l   a2,d4           w = 2*k2 + k3' */
    add.l a2,d4
/* QL:         add.l   a3,a2           k2' = k2 + k3' */
    add.l a3,a2
/* QL:         move.l  d4,d5 */
    move.l d4,d5
/* QL:         sub.l   a1,d5 */
    sub.l a1,d5
/* QL:         move.l  d5,a1           k1' = w - k1 */
    move.l d5,a1
/* QL:         move.l  a2,d5 */
    move.l a2,d5
/* QL:         asr.l   #1,d5 */
    asr.l #1,d5
/* QL:         add.l   d6,d5 */
    add.l d6,d5
/* QL:         add.l   d5,d7           b' = b + a + k2'/2 */
    add.l d5,d7
/* QL:         asr.l   #1,d5 */
    asr.l #1,d5
/* QL:         add.l   a0,d5 */
    add.l a0,d5
/* QL:         neg.l   d5 */
    neg.l d5
/* QL:         add.l   d7,d5 */
    add.l d7,d5
/* QL:         move.l  d5,a0           d' = b' - d - a/2 - k2'/4 */
    move.l d5,a0
/* QL:         asr.l   #1,d4 */
    asr.l #1,d4
/* QL:         add.l   d4,d6 */
    add.l d4,d6
/* QL:         neg.l   d6              a' = - w/2 - a */
    neg.l d6
/* QL:         rts */
    rts 
/* QL:         end */
