/* ROM section ri_add */
.balign 2,0
/* QL: * d0 -  o- 0 or M99_err.ov (ccr set) */
/* QL: * a1 -i o- pointer to arithmetic M99_stack, six added */
/* QL: * d1-d2 destroyed */
/* QL: ri_sub  ;...,a1:b(float),a(float),... ==> ...,-b(float),a1:a-b(float),... */
ri_sub:
/* QL:         jsr     ri_neg(pc)      negate b - no error exit */
    jsr ri_neg(pc)
/* QL: ri_add  ;...,a1:b(float),a(float),... ==> ...,b(float),a1:a+b(float),... */
ri_add:
/* QL:         addq.l  #6,a1           only one return arg */
    addq.l #6,a1
/* QL:         move.l  2(a6,a1.l),d1   get a mantissa */
    move.l 2(a6,a1.l),d1
/* QL:         move.l  -4(a6,a1.l),d0  get b mantissa */
    move.l (-4)(a6,a1.l),d0
/* QL:         move.w  0(a6,a1.l),d2   get a exponent */
    move.w 0(a6,a1.l),d2
/* QL:         sub.w   -6(a6,a1.l),d2  subtract b exponent from a exponent (if z, x=0) */
    sub.w (-6)(a6,a1.l),d2
/* QL:         bge.s   M99_expok           if aexp >= bexp, keep it */
    bge.s M99_expok
/* QL:         neg.w   d2              make shift positive */
    neg.w d2
/* QL:         add.w   d2,0(a6,a1.l)   change aexp to be bexp */
    add.w d2,0(a6,a1.l)
/* QL:         exg     d0,d1           swap over mantissae */
    exg d0,d1
/* QL: M99_expok */
M99_expok:
/* QL:         cmp.w   #32,d2          check downshift */
    cmp.w #32,d2
/* QL:         bgt.s   M99_addput          if too large, just (re)store mantissa */
    bgt.s M99_addput
/* QL:         asr.l   d2,d0           shift down (note: if d2=0, x=0 already) */
    asr.l d2,d0
/* QL:         subx.l  d2,d2           remember the rounding we're using */
    subx.l d2,d2
/* QL:         addx.l  d0,d1           add mantissae, and rounding */
    addx.l d0,d1
/* QL:         bvs.s   M99_addvs           if v is set, we modify rounding and downshift */
    bvs.s M99_addvs
/* QL:         move.l  d1,2(a6,a1.l)   store the result, with luck, it's ok now */
    move.l d1,2(a6,a1.l)
/* QL:         add.l   d1,d1           check if number really is already normalised */
    add.l d1,d1
/* QL:         bvs.s   M99_rtsok           if so, we can skip out this instant */
    bvs.s M99_rtsok
/* QL:         move.w  0(a6,a1.l),d0   get current exponent */
    move.w 0(a6,a1.l),d0
/* QL:         beq.s   M99_rtsok           if both a and b were unnormal, all done */
    beq.s M99_rtsok
/* QL:         add.l   d2,d1           put back any rounding we may have used, as lsb */
    add.l d2,d1
/* QL:         bvc.s   M99_addvc           we can have $80000000+$ffffffff */
    bvc.s M99_addvc
/* QL:         addq.l  #1,d1           if so, restore the $80000000, it's better */
    addq.l #1,d1
/* QL: M99_addvc */
M99_addvc:
/* QL:         bne.s   M99_addnlp          if not pure zero, go to normalise it */
    bne.s M99_addnlp
/* QL:         moveq   #1,d0           force drop out of loop */
    moveq #1,d0
/* QL: M99_addnlp */
M99_addnlp:
/* QL:         subq.w  #1,d0 */
    subq.w #1,d0
/* QL:         beq.s   M99_addend          stick at zero exponent, maybe unnormal result */
    beq.s M99_addend
/* QL:         add.l   d1,d1           try for more normalisation */
    add.l d1,d1
/* QL:         bvc.s   M99_addnlp          if there is, keep winding down the exponent */
    bvc.s M99_addnlp
/* QL:         roxr.l  #1,d1           we overshot normalising, so roll back */
    roxr.l #1,d1
/* QL: M99_addend */
M99_addend:
/* QL:         move.w  d0,0(a6,a1.l)   store the exponent */
    move.w d0,0(a6,a1.l)
/* QL: M99_addput */
M99_addput:
/* QL:         move.l  d1,2(a6,a1.l)   store the result */
    move.l d1,2(a6,a1.l)
/* QL: M99_rtsok */
M99_rtsok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M99_addvs */
M99_addvs:
/* QL:         roxr.l  #1,d1           put result back down */
    roxr.l #1,d1
/* QL: * Four possibilities: */
/* QL: * x=0 d2=0  q0.0 fine, we didn't round and lsb was zero anyway */
/* QL: * x=0 d2=-1 q1.1 fine, we have already rounded according to next bit */
/* QL: * x=1 d2=0  q1.0 bad! we still need to round up by one */
/* QL: * x=1 d2=-1 q0.1 fine, no rounding was needed, and we just scrapped it anyway */
/* QL:         bcc.s   M99_chovflw */
    bcc.s M99_chovflw
/* QL:         addx.l  d2,d1 */
    addx.l d2,d1
/* QL: * Note: if d2=-1, it cancels the x=1, and we're OK */
/* QL: * If d2=0, we round up, but the worst case we could have is $7fffffff+$7ffffffe */
/* QL: * -> (x=0)$fffffffd -> $7ffffffe(x=1) -> $7fffffff, so it never overflows. */
/* QL: M99_chovflw */
M99_chovflw:
/* QL:         move.l  d1,2(a6,a1.l)   store result mantissa */
    move.l d1,2(a6,a1.l)
/* QL: * Double floating point value at top of stack. */
/* QL: * d0 -  o- 0 if no problem, M99_err.ov if exponent out of range 0..$FFF, ccr set */
/* QL: * d1 -  o- unchanged if not overflow, else result mantissa */
/* QL: * a1 -ip - pointer to float to be doubled */
/* QL: ri_doubl */
ri_doubl:
/* QL:         addq.w  #1,0(a6,a1.l)   add one to exponent */
    addq.w #1,0(a6,a1.l)
/* QL: * This does a proper check for overflow. */
/* QL: * d0 -  o- 0 if no problem, M99_err.ov if exponent out of range 0..$FFF, ccr set */
/* QL: * d1 -  o- unchanged if not overflow, else result mantissa */
/* QL: * a1 -ip - RI M99_stack pointer, value replaced by large result on overflow */
/* QL: ri_chkov */
ri_chkov:
/* QL:         moveq   #-16,d0         mask $f0 */
    moveq #(-16),d0
/* QL:         and.b   0(a6,a1.l),d0   is exponent now out of range? */
    and.b 0(a6,a1.l),d0
/* QL:         beq.s   M99_rtsok           nope, that's what we hoped */
    beq.s M99_rtsok
/* QL:         ;       we could've allowed min -> max exp like ri_neg, but ... */
/* QL: * This routine replaces the top element of the M99_stack with a maximum value of */
/* QL: * the same sign as was there. It always comes back with err.ov. The usage of */
/* QL: * this, instead of just bombing out on an overflow error, means that callers */
/* QL: * who happen not to check all error returns will likely get away with the odd */
/* QL: * occasion of an overflow error. Also, the top of M99_stack will never get silly. */
/* QL: * d0.l is M99_err.ov, d1.l is the maximum mantissa which has been stored. */
/* QL: ri_errov */
ri_errov:
/* QL:         asl     2(a6,a1.l)      was it positive or negative? */
    asl 2(a6,a1.l)
/* QL:         subx.l  d1,d1           x/d0.l = 0/00000000 or 1/ffffffff */
    subx.l d1,d1
/* QL:         not.l   d1              x/d0.l = 0/ffffffff or 1/00000000 */
    not.l d1
/* QL:         roxr.l  #1,d1           x/d0.l = 1/7fffffff or 0/80000000 */
    roxr.l #1,d1
/* QL:         move.l  d1,2(a6,a1.l)   store the maximum mantissa */
    move.l d1,2(a6,a1.l)
/* QL:         move.w  #$fff,0(a6,a1.l) maximum exponent */
    move.w #0xfff,0(a6,a1.l)
/* QL:         moveq   #M99_err.ov,d0 */
    moveq #M99_err.ov,d0
/* QL:         rts */
    rts 
/* QL: * Float a short integer which is on the M99_stack */
/* QL: * d0 -  o- 0 (ccr set) */
/* QL: * a1 -i o- pointer to arithmetic M99_stack, four subtracted */
/* QL: * d1-d2 destroyed */
/* QL: ri_float;...,?(long),a1:a(short),... ==> ...,a1:a(float),... */
ri_float:
/* QL:         move.l  0(a6,a1.l),d1   fetch integer and junk */
    move.l 0(a6,a1.l),d1
/* QL:         move.w  #$80f,d0        set exponent */
    move.w #0x80f,d0
/* QL: M99_dropjunk */
M99_dropjunk:
/* QL:         clr.w   d1              scrap junk */
    clr.w d1
/* QL: M99_setshft */
M99_setshft:
/* QL:         subq.l  #4,a1           space for result */
    subq.l #4,a1
/* QL:         move.l  d1,d2           duplicate mantissa */
    move.l d1,d2
/* QL:         beq.s   M99_minexp          ah! zero mantissa */
    beq.s M99_minexp
/* QL:         asl.l   #8,d2           try eight bit shift */
    asl.l #8,d2
/* QL:         bvc.s   M99_did8            that worked, so go try 4 using d2 as source */
    bvc.s M99_did8
/* QL:         move.l  d1,d2 */
    move.l d1,d2
/* QL:         asl.l   #4,d2 */
    asl.l #4,d2
/* QL:         bvc.s   M99_did4            go try two bit shift on d2 */
    bvc.s M99_did4
/* QL: M99_try2 */
M99_try2:
/* QL:         move.l  d1,d2 */
    move.l d1,d2
/* QL:         asl.l   #2,d2 */
    asl.l #2,d2
/* QL:         bvc.s   M99_did2            go try single bit shift on d2 */
    bvc.s M99_did2
/* QL: M99_try1 */
M99_try1:
/* QL:         move.l  d1,d2 */
    move.l d1,d2
/* QL:         add.l   d2,d2 */
    add.l d2,d2
/* QL:         bvc.s   M99_did1            go finish off copying d2 into d1 */
    bvc.s M99_did1
/* QL:         bra.s   M99_stack */
    bra.s M99_stack
/* QL: M99_did8 */
M99_did8:
/* QL:         subq.w  #8,d0           successful eight bit shift */
    subq.w #8,d0
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL:         asl.l   #4,d2 */
    asl.l #4,d2
/* QL:         bvs.s   M99_try2 */
    bvs.s M99_try2
/* QL: M99_did4 */
M99_did4:
/* QL:         subq.w  #4,d0           successful four bit shift */
    subq.w #4,d0
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL:         asl.l   #2,d2 */
    asl.l #2,d2
/* QL:         bvs.s   M99_try1 */
    bvs.s M99_try1
/* QL: M99_did2 */
M99_did2:
/* QL:         subq.w  #2,d0           successful two bit shift */
    subq.w #2,d0
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL:         add.l   d2,d2 */
    add.l d2,d2
/* QL:         bvs.s   M99_stack */
    bvs.s M99_stack
/* QL: M99_did1 */
M99_did1:
/* QL:         subq.w  #1,d0           successful one bit shift */
    subq.w #1,d0
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL: M99_stack */
M99_stack:
/* QL:         move.w  d0,0(a6,a1.l)   put exponent on */
    move.w d0,0(a6,a1.l)
/* QL:         move.l  d1,2(a6,a1.l)   put mantissa on */
    move.l d1,2(a6,a1.l)
/* QL:         moveq   #0,d0           good return */
    moveq #0,d0
/* QL: M99_rtsrnrm */
M99_rtsrnrm:
/* QL:         rts */
    rts 
/* QL: * Renormalise a value from registers and put it onto the M99_stack */
/* QL: * d0 -i o- exponent in lsw / 0 or M99_err.ov if result overflows (ccr set) */
/* QL: * d1 -i  - mantissa */
/* QL: * a1 -i o- M99_stack pointer, six subtracted */
/* QL: * d2 destroyed */
/* QL: ri_renrm;...,?(float),a1:,... ==> ...,a1:a(float),... */
ri_renrm:
/* QL:         bsr.s   M99_renrm           nest down to renormalise as ... */
    bsr.s M99_renrm
/* QL:         move.b  0(a6,a1.l),d0   ... only here can we end up with duff exponent */
    move.b 0(a6,a1.l),d0
/* QL:         asr.b   #4,d0 */
    asr.b #4,d0
/* QL:         bgt.s   ri_errov */
    bgt.s ri_errov
/* QL:         beq.s   M99_rtsrnrm */
    beq.s M99_rtsrnrm
/* QL:         move.w  0(a6,a1.l),d0   underflow, so we have to pick up exponent again */
    move.w 0(a6,a1.l),d0
/* QL:         neg.w   d0              what a tiny number */
    neg.w d0
/* QL:         asr.l   d0,d1           move mantissa by underflow amount */
    asr.l d0,d1
/* QL: M99_minexp */
M99_minexp:
/* QL:         moveq   #0,d0           set exponent to zero */
    moveq #0,d0
/* QL:         bra.s   M99_stack */
    bra.s M99_stack
/* QL: * Float a long integer, input and result on the M99_stack */
/* QL: * d0 -i o- 0 (ccr set) */
/* QL: * a1 -i o- M99_stack pointer, two subtracted */
/* QL: * d1/d2 destroyed */
/* QL: ri_flong;...,?(word),a1:a(long),... ==> ...,a1:a(float),... */
ri_flong:
/* QL:         move.l  0(a6,a1.l),d1   fetch long integer */
    move.l 0(a6,a1.l),d1
/* QL:         addq.l  #4,a1           drop it for now */
    addq.l #4,a1
/* QL: * Float a long integer from a register onto the M99_stack */
/* QL: * d0 -i o- 0 (ccr set) */
/* QL: * d1 -i  - mantissa */
/* QL: * a1 -i o- M99_stack pointer, six subtracted */
/* QL: * d2 destroyed */
/* QL: ri_fllin;...,?(float),a1:,... ==> ...,a1:a(float),... */
ri_fllin:
/* QL:         move.w  #$81f,d0        set exponent */
    move.w #0x81f,d0
/* QL: M99_renrm */
M99_renrm:
/* QL:         subq.l  #2,a1           make room like an integer */
    subq.l #2,a1
/* QL:         move.l  d1,d2           take a copy */
    move.l d1,d2
/* QL:         ext.l   d2              extend to long */
    ext.l d2
/* QL:         cmp.l   d1,d2           did that change it? */
    cmp.l d1,d2
/* QL:         bne.s   M99_setshft         yes - go start little shifts */
    bne.s M99_setshft
/* QL:         sub.w   #16,d0          no - knock sixteen of exponent ... */
    sub.w #16,d0
/* QL:         swap    d1              ... swap single word to msw ... */
    swap d1
/* QL:         bra.s   M99_dropjunk        ... and go on like an integer */
    bra.s M99_dropjunk
/* QL: * ri_cmp simplifies, speeds up, and makes consistent, floating point compares. */
/* QL: * It expects two fp values on the M99_stack, and leaves only one. This is similar */
/* QL: * to ri_sub, but the value left is arranged to make determination of the */
/* QL: * comparison result very easy. */
/* QL: * In essence, the value left will be zero for identical equality, negative for */
/* QL: * a < b or positive for a > b. The absolute value of the result will be */
/* QL: * approximate the condition abs(a-b) > max(abs(a),abs(b)) / 1e7, i.e. the */
/* QL: * result will be +/-1 if the comparison is pretty definate, +/- a tiny value if */
/* QL: * we have a == b but not a = b, and zero iff a is exactly equal to b (a = b). */
/* QL: * The actual bytes stored are arranged for easy tests as follows: */
/* QL: *       a < b and not a == b    08 00 80 00 00 00 */
/* QL: *           a < b and a == b    00 00 80 00 00 00 */
/* QL: *                      a = b    00 00 00 00 00 00 */
/* QL: *           a > b and a == b    00 01 40 00 00 00 */
/* QL: *       a > b and not a == b    08 01 40 00 00 00 */
/* QL: * Thus testing the msb of the exponent establishes approximate equality if it */
/* QL: * is zero, and testing the msb of the mantissa is used in all other cases. */
/* QL: * Registers... */
/* QL: * d0 -  o- 0 (ccr set) */
/* QL: * d1 -  o- mantissa of result */
/* QL: * a1 -i o- M99_stack pointer, six subtracted */
/* QL: * d2 destroyed */
/* QL: ri_cmp;...,a1:b(float),a(float),... ==> ...,b(float),a1:sgn(a-b)ish(float),... */
ri_cmp:
/* QL:         addq.l  #6,a1           set M99_stack ready for exit */
    addq.l #6,a1
/* QL:         move.w  0(a6,a1.l),d2   get a exponent */
    move.w 0(a6,a1.l),d2
/* QL:         clr.w   0(a6,a1.l)      wipe it out */
    clr.w 0(a6,a1.l)
/* QL:         move.l  2(a6,a1.l),d0   get a mantissa */
    move.l 2(a6,a1.l),d0
/* QL:         bne.s   M99_anz */
    bne.s M99_anz
/* QL: * a is zero, therefore we need only consider the sign, and zero-ness of b */
/* QL:         move.l  -4(a6,a1.l),d1  how is b? */
    move.l (-4)(a6,a1.l),d1
/* QL:         beq.s   M99_ret0            if it's zero, we only need to get out now (0=0) */
    beq.s M99_ret0
/* QL:         bpl.s   M99_msbexp          if it's positive, a < b (0<+ve) */
    bpl.s M99_msbexp
/* QL: M99_setagb */
M99_setagb:
/* QL:         addq.b  #1,1(a6,a1.l)   set the "a > b" bit */
    addq.b #1,1(a6,a1.l)
/* QL: M99_msbexp */
M99_msbexp:
/* QL:         addq.b  #8,0(a6,a1.l)   set the "not a == b" bit */
    addq.b #8,0(a6,a1.l)
/* QL: M99_msbman */
M99_msbman:
/* QL:         moveq   #2,d1           2 */
    moveq #2,d1
/* QL:         sub.b   1(a6,a1.l),d1   (1/2) did we set "a > b"? */
    sub.b 1(a6,a1.l),d1
/* QL:         ror.l   #2,d1           $40000000/$80000000 */
    ror.l #2,d1
/* QL: M99_setman */
M99_setman:
/* QL:         move.l  d1,2(a6,a1.l)   store mantissa */
    move.l d1,2(a6,a1.l)
/* QL: M99_ret0 */
M99_ret0:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Right, a isn't zero, so we'll see what b looks like */
/* QL: M99_anz */
M99_anz:
/* QL:         move.l  -4(a6,a1.l),d1  pick up b mantissa */
    move.l (-4)(a6,a1.l),d1
/* QL:         bne.s   M99_bnz */
    bne.s M99_bnz
/* QL: M99_btozero */
M99_btozero:
/* QL:         tst.l   d0              if b is 0 direction from a, check a's sign */
    tst.l d0
/* QL:         bpl.s   M99_setagb          if positive set a > b (big+ve>little+ve,0,-ve) */
    bpl.s M99_setagb
/* QL:         bra.s   M99_msbexp          if negative leave it (big-ve<little-ve,0,+ve) */
    bra.s M99_msbexp
/* QL: * Neither a or b is zero, so see if a and b differ in sign */
/* QL: M99_bnz */
M99_bnz:
/* QL:         eor.l   d0,d1           temporarily flip b */
    eor.l d0,d1
/* QL:         bmi.s   M99_btozero         their sign's differ, go set accordingly */
    bmi.s M99_btozero
/* QL:         eor.l   d0,d1           put b back normal */
    eor.l d0,d1
/* QL: * Now we're getting down to the nitty-gritty bits. Have to look at exponents */
/* QL:         sub.w   -6(a6,a1.l),d2  calculate exp(a) - exp(b) */
    sub.w (-6)(a6,a1.l),d2
/* QL:         bne.s   M99_shuff           not the same, so we haven't got exact equals */
    bne.s M99_shuff
/* QL:         sub.l   d0,d1           are they exactly the same? */
    sub.l d0,d1
/* QL:         beq.s   M99_setman          yes - that's exact equality finished with */
    beq.s M99_setman
/* QL: M99_bitgame */
M99_bitgame:
/* QL:         bgt.s   M99_bitlook         if a < b leave that (nb see below why bgt test) */
    bgt.s M99_bitlook
/* QL:         addq.b  #1,1(a6,a1.l)   set the "a > b" bit */
    addq.b #1,1(a6,a1.l)
/* QL:         not.l   d1              now difference is positive */
    not.l d1
/* QL: M99_bitlook */
M99_bitlook:
/* QL:         move.l  d1,d2 */
    move.l d1,d2
/* QL:         lsr.l   #8,d2           are difference bits 31 to 8 all zero? */
    lsr.l #8,d2
/* QL:         bne.s   M99_msbexp          no - then go set not == */
    bne.s M99_msbexp
/* QL:         mulu    #39063,d1       multiply by 1e7/256 (exact is 39062.5) */
    mulu #39063,d1
/* QL:         asl.l   #8,d1           did any bits get right into the top? */
    asl.l #8,d1
/* QL:         bvs.s   M99_msbexp          yes - then set not == */
    bvs.s M99_msbexp
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         bpl.s   M99_okbig */
    bpl.s M99_okbig
/* QL:         not.l   d0              saves checking for overflow, and is good enuff */
    not.l d0
/* QL: M99_okbig */
M99_okbig:
/* QL:         cmp.l   d0,d1           finally compare them */
    cmp.l d0,d1
/* QL:         bge.s   M99_msbexp          if abs(a-b)*1e7 >= abs(b or a), set not == */
    bge.s M99_msbexp
/* QL:         bra.s   M99_msbman          otherwise, leave == */
    bra.s M99_msbman
/* QL: M99_shuff */
M99_shuff:
/* QL:         subq.w  #1,d2           is exp(a) > exp(b) + 1? */
    subq.w #1,d2
/* QL:         bgt.s   M99_btozero         yes, then set result according to sign */
    bgt.s M99_btozero
/* QL:         beq.s   M99_shft            if exp(a) = exp(b) + 1, go do shift */
    beq.s M99_shft
/* QL:         exg     d0,d1           swap over a and b */
    exg d0,d1
/* QL:         not.l   d0              and invert both */
    not.l d0
/* QL:         not.l   d1              which will be good enough for our purposes */
    not.l d1
/* QL:         addq.w  #2,d2           is exp(a) < exp(b) - 1? */
    addq.w #2,d2
/* QL:         bne.s   M99_btozero         yes, once again the sign is the answer */
    bne.s M99_btozero
/* QL: M99_shft */
M99_shft:
/* QL:         asr.l   #1,d1           shift down the smaller exponent */
    asr.l #1,d1
/* QL:         sub.l   d0,d1           how do they compare? */
    sub.l d0,d1
/* QL:         bra.s   M99_bitgame         nb test up there is bgt, so lost carry is ok */
    bra.s M99_bitgame
/* QL:         end */
