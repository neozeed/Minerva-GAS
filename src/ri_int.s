/* ROM section ri_int */
.balign 2,0
/* QL: * N.B. On returning err.ov, this routine now also makes the returned value in */
/* QL: * d1 equal to a maximum value of the correct sign. This helps keep things happy */
/* QL: * if one omits to M101_check the error return. */
/* QL: * d0 -  o- error code (ccr set) */
/* QL: * d1 -  o- result (w/l) */
/* QL: * a1 -i o- arithmetic stack (+4/2 for w/l) */
/* QL: * d2 destroyed by n(l)M101_int */
/* QL: M101_nint */
M101_nint:
/* QL:         jsr     ri_one(pc) */
    jsr ri_one(pc)
/* QL:         sf      1(a6,a1.l)      put .5 on stack */
    sf 1(a6,a1.l)
/* QL:         jsr     ri_add(pc)      round */
    jsr ri_add(pc)
/* QL: M101_int */
M101_int:
/* QL:         move.w  #$800,d0        base */
    move.w #0x800,d0
/* QL:         sub.w   0(a6,a1.l),d0   take away exponent */
    sub.w 0(a6,a1.l),d0
/* QL:         ble.s   M101_check           is value tiny? */
    ble.s M101_check
/* QL:         moveq   #0,d0           set to zero exponent */
    moveq #0,d0
/* QL: M101_check */
M101_check:
/* QL:         add.w   #$1f,d0         shift mantissa right */
    add.w #0x1f,d0
/* QL:         move.l  2(a6,a1.l),d1   get mantissa */
    move.l 2(a6,a1.l),d1
/* QL:         asr.l   d0,d1 */
    asr.l d0,d1
/* QL: M101_store */
M101_store:
/* QL:         move.l  d1,2(a6,a1.l)   M101_store result */
    move.l d1,2(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: ri_nint */
ri_nint:
/* QL:         bsr.s   M101_nint */
    bsr.s M101_nint
/* QL:         bra.s   M101_wcheck */
    bra.s M101_wcheck
/* QL: ri_int */
ri_int:
/* QL:         bsr.s   M101_int             get word */
    bsr.s M101_int
/* QL: M101_wcheck */
M101_wcheck:
/* QL:         asr.w   #4,d0           was exponent in range ? */
    asr.w #4,d0
/* QL:         ble.s   M101_err_ret */
    ble.s M101_err_ret
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL: M101_ok_ret */
M101_ok_ret:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M101_linret */
M101_linret:
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL:         rts */
    rts 
/* QL: ri_nlint */
ri_nlint:
/* QL:         bsr.s   M101_nint */
    bsr.s M101_nint
/* QL:         bra.s   M101_lcheck */
    bra.s M101_lcheck
/* QL: ri_lint */
ri_lint:
/* QL:         bsr.s   M101_int             get long word */
    bsr.s M101_int
/* QL: M101_lcheck */
M101_lcheck:
/* QL:         neg.w   d0              exponent in range ? */
    neg.w d0
/* QL:         ble.s   M101_ok_ret */
    ble.s M101_ok_ret
/* QL: M101_err_ret */
M101_err_ret:
/* QL:         move.w  d0,-(sp)        save which one we were doing */
    move.w d0,-(sp)
/* QL:         jsr     ri_errov(pc)    go make the max value */
    jsr ri_errov(pc)
/* QL:         neg.w   (sp)+           ok, so which was it? */
    neg.w (sp)+
/* QL:         bmi.s   M101_linret          finished if it was lint (condition code ok) */
    bmi.s M101_linret
/* QL:         asr.l   #8,d1 */
    asr.l #8,d1
/* QL:         asr.l   #8,d1 */
    asr.l #8,d1
/* QL:         bsr.s   M101_store           go M101_store appropriate max num */
    bsr.s M101_store
/* QL:         addq.l  #4,a1 */
    addq.l #4,a1
/* QL:         tst.l   d0              make sure condition codes are set */
    tst.l d0
/* QL:         rts */
    rts 
/* QL:         end */
