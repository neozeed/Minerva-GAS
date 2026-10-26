/* ROM section cs_color */
.balign 2,0
/* QL: * d1 c p colour number */
/* QL: * d2   p scratch */
/* QL: * a1 c p pointer to two word colour pattern */
/* QL: * a6 i p system variables */
/* QL: reglist reg     d1-d2 */
/* QL: cs_color */
cs_color:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d2,-(sp)
/* QL:         bsr.s   cs_plain        convert d1 3 bits to colour */
    bsr.s cs_plain
/* QL:         move.w  d2,(a1)         save the plain colour (even) */
    move.w d2,(a1)
/* QL:         move.w  d2,2(a1)        save the plain colour (odd) */
    move.w d2,2(a1)
/* QL: * Now for the stipple */
/* QL:         lsr.b   #3,d1           shift down the rest of the byte */
    lsr.b #3,d1
/* QL:         beq.s   M181_exit            are there any bits set ? */
    beq.s M181_exit
/* QL:         bsr.s   cs_plain */
    bsr.s cs_plain
/* QL:         lsr.b   #4,d1           stipple flags: ms in d1, ls in carry */
    lsr.b #4,d1
/* QL:         bcc.s   M181_vertical        check for horizontal component */
    bcc.s M181_vertical
/* QL:         beq.s   M181_eorexit         purely horizontal, go eor odd (01 done) */
    beq.s M181_eorexit
/* QL:         eor.w   d2,2(a1)        create horizontal part for 11 stipple */
    eor.w d2,2(a1)
/* QL: M181_vertical */
M181_vertical:
/* QL:         btst    #3,M181_sv_mcsta(a6) check screen mode */
    btst #3,M181_sv_mcsta(a6)
/* QL:         bne.s   M181_m256_msk */
    bne.s M181_m256_msk
/* QL:         and.w   #$5555,d2       mask out alternate pixels in 512 */
    and.w #0x5555,d2
/* QL: M181_eor_vert */
M181_eor_vert:
/* QL:         eor.w   d2,(a1)         in even lines */
    eor.w d2,(a1)
/* QL:         ;       we have 00 10 and 11 left... just need to test msb */
/* QL:         tst.b   d1              is it single dot stipple ? */
    tst.b d1
/* QL:         beq.s   M181_exit */
    beq.s M181_exit
/* QL: M181_eorexit */
M181_eorexit:
/* QL:         eor.w   d2,2(a1)        and modify odd lines */
    eor.w d2,2(a1)
/* QL: M181_exit */
M181_exit:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d2
/* QL:         rts */
    rts 
/* QL: M181_m256_msk */
M181_m256_msk:
/* QL:         and.w   #$3333,d2       mask out alternate pixels in 256 */
    and.w #0x3333,d2
/* QL:         bra.s   M181_eor_vert */
    bra.s M181_eor_vert
/* QL: * d1 c p colour number in 3 lsb's */
/* QL: * d2   o color mask (.w) for mode and 3 lsb's of d1 */
/* QL: * a6 i p system variables */
/* QL: cs_plain */
cs_plain:
/* QL:         btst    #3,M181_sv_mcsta(a6) check mode */
    btst #3,M181_sv_mcsta(a6)
/* QL:         bne.s   M181_m256_col */
    bne.s M181_m256_col
/* QL:         moveq   #6,d2           ignoring lsb (blue) */
    moveq #6,d2
/* QL:         and.b   d1,d2 */
    and.b d1,d2
/* QL:         move.w  M181_col512(pc,d2.w),d2 */
    move.w M181_col512(pc,d2.w),d2
/* QL:         rts */
    rts 
/* QL: M181_col512 */
M181_col512:
/* QL:         dc.w    $0000,$00ff,$ff00,$ffff */
.balign 2,0
M181_dc_anchor_281:
.word 0x0000
.word 0x00ff
.word 0xff00
.word 0xffff
/* QL: M181_m256_col */
M181_m256_col:
/* QL:         moveq   #7,d2 */
    moveq #7,d2
/* QL:         and.b   d1,d2 */
    and.b d1,d2
/* QL:         add.b   d2,d2 */
    add.b d2,d2
/* QL:         move.w  M181_col256(pc,d2.w),d2 */
    move.w M181_col256(pc,d2.w),d2
/* QL:         rts */
    rts 
/* QL: M181_col256 */
M181_col256:
/* QL:         dc.w    $0000,$0055,$00aa,$00ff,$aa00,$aa55,$aaaa,$aaff */
.balign 2,0
M181_dc_anchor_302:
.word 0x0000
.word 0x0055
.word 0x00aa
.word 0x00ff
.word 0xaa00
.word 0xaa55
.word 0xaaaa
.word 0xaaff
/* QL:         end */
