/* ROM section ca_cncat */
.balign 2,0
/* QL: * This routine should be optimised to cater for some of the special cases: */
/* QL: * b$ null just needs a1+=2, if we ignore funny length a$ */
/* QL: * LEN(b$)=1 and a$ odd is fairly simple, but LEN(a$&b$) must have a check */
/* QL: * LEN(a$)+LEN(b$) small could be quicker */
/* QL: ca_cncat */
ca_cncat:
/* QL:         movem.l reglist,-(sp)   save anything we might want to keep */
    movem.l a0/a2-a4,-(sp)
/* QL:         lea     M86_cncat,a2 */
    lea M86_cncat(pc),a2
/* QL:         moveq   #M86_mt.extop,d0 */
    moveq #M86_mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         movem.l (sp)+,reglist   restore registers */
    movem.l (sp)+,a0/a2-a4
/* QL:         moveq   #0,d0           assume we're OK */
    moveq #0,d0
/* QL: * The following is a protection against lazy programmers, who use */
/* QL: * "addq.w #3/bclr #0" to round up and get past a string plus its length: */
/* QL:         cmp.l   #32765,d3       might adding 3 make it overflow?  */
    cmp.l #32765,d3
/* QL:         bcs.s   M86_rts0            good, it's not too long (even for cretins) */
    bcs.s M86_rts0
/* QL:         addq.l  #1,d3 */
    addq.l #1,d3
/* QL:         bclr    d0,d3 */
    bclr d0,d3
/* QL:         add.l   d3,a1           drop all chars of the string */
    add.l d3,a1
/* QL:         move.w  d0,0(a6,a1.l)   make result the null string */
    move.w d0,0(a6,a1.l)
/* QL:         moveq   #M86_err.ov,d0      'overflow' error code for too-long string */
    moveq #M86_err.ov,d0
/* QL: M86_rts0 */
M86_rts0:
/* QL:         rts */
    rts 
/* QL: * supervisor mode code */
/* QL: M86_cncat */
M86_cncat:
/* QL:         add.l   a6,a1 */
    add.l a6,a1
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.w  (a1)+,d2        get length of b$ and set source for b$ chars */
    move.w (a1)+,d2
/* QL:         lea     0(a1,d2.l),a0   end of b$ */
    lea 0(a1,d2.l),a0
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL:         and.b   d2,d0           get odd-ness of length of b$ */
    and.b d2,d0
/* QL:         add.l   d0,a0           skip any junk byte */
    add.l d0,a0
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         move.w  (a0)+,d3        get length of a$ and set source for a$ chars */
    move.w (a0)+,d3
/* QL:         lea     0(a0,d3.l),a3   end of a$ */
    lea 0(a0,d3.l),a3
/* QL:         moveq   #1,d1 */
    moveq #1,d1
/* QL:         and.b   d3,d1           get odd-ness of length of a$ */
    and.b d3,d1
/* QL:         add.l   d1,a3           skip any junk byte */
    add.l d1,a3
/* QL:         cmp.w   d1,d0           was either, but not both, string odd? */
    cmp.w d1,d0
/* QL:         beq.s   M86_xeven           no, then this is the end of a$&b$ */
    beq.s M86_xeven
/* QL:         move.b  -(a3),-1(a0)    if len(a$) was odd, this may need doing */
    move.b -(a3),(-1)(a0)
/* QL:         tas     d1              set bit 7 to remember odd length result */
    tas d1
/* QL: M86_xeven */
M86_xeven:
/* QL:         move.l  a3,a4           keep a copy of end of a$&b$ */
    move.l a3,a4
/* QL: * Now for some strategy... we can do little a$ or b$ strings by just grabbing */
/* QL: * the whole string into a register, shuffling the other string, then tacking */
/* QL: * in the saved string wherever it belongs. In particular, b$='' is real easy! */
/* QL:         moveq   #4,d0 */
    moveq #4,d0
/* QL:         cmp.w   d2,d0           N.B. little b$'s are favorite! */
    cmp.w d2,d0
/* QL:         bcc.s   M86_ashuff          len(b$)<5, a$ words go down, or even stay put! */
    bcc.s M86_ashuff
/* QL:         cmp.w   d3,d0 */
    cmp.w d3,d0
/* QL:         bcc.s   M86_bshuff          len(a$)<5, b$ bytes, or even words, go up */
    bcc.s M86_bshuff
/* QL:         bsr.s   M86_reverse         M86_reverse a$ bytes (plus a junk byte, maybe) */
    bsr.s M86_reverse
/* QL:         sub.l   d3,a3           this is where the join is, and where b$ goes */
    sub.l d3,a3
/* QL:         bsr.s   M86_reva1           M86_reverse b$ bytes (plus some junk) */
    bsr.s M86_reva1
/* QL:         bsr.s   M86_seta1           set final a$&b$ regs */
    bsr.s M86_seta1
/* QL:         pea     M86_setlen          M86_reverse a$&b$ to get it right, then set length */
    pea M86_setlen(pc)
/* QL: M86_reva1 */
M86_reva1:
/* QL:         move.l  a1,a0           source from a1 */
    move.l a1,a0
/* QL: M86_reverse */
M86_reverse:
/* QL:         move.l  a3,d1 */
    move.l a3,d1
/* QL:         sub.l   a0,d1 */
    sub.l a0,d1
/* QL:         lsr.l   #1,d1           swap count, an odd middle byte stays put */
    lsr.l #1,d1
/* QL:         bra.s   M86_revent          enter at the bottom of the loop */
    bra.s M86_revent
/* QL: M86_revlp */
M86_revlp:
/* QL:         move.b  (a0),d0 */
    move.b (a0),d0
/* QL:         move.b  -(a3),(a0)+ */
    move.b -(a3),(a0)+
/* QL:         move.b  d0,(a3) */
    move.b d0,(a3)
/* QL: M86_revent */
M86_revent:
/* QL:         dbra    d1,M86_revlp */
    dbra d1,M86_revlp
/* QL:         move.l  a4,a3           needed two out of three times */
    move.l a4,a3
/* QL:         rts */
    rts 
/* QL: M86_shuff */
M86_shuff:
/* QL:         move.l  (a1),d0         grab the whole of the M86_short string */
    move.l (a1),d0
/* QL: M86_seta1 */
M86_seta1:
/* QL:         add.l   d2,d3 */
    add.l d2,d3
/* QL:         sub.l   d3,a4 */
    sub.l d3,a4
/* QL:         move.l  a4,a1           this will be the final string pointer */
    move.l a4,a1
/* QL:         rts */
    rts 
/* QL: M86_ashuff */
M86_ashuff:
/* QL:         exg     d2,d3           we make d2 = len(a$) */
    exg d2,d3
/* QL:         bsr.s   M86_shuff           set it up */
    bsr.s M86_shuff
/* QL:         cmp.l   a0,a4           hmm... b$='' or len(b$)=1 and len(a$) odd? */
    cmp.l a0,a4
/* QL:         bne.s   M86_apity           no, then we must do a proper shuffle. */
    bne.s M86_apity
/* QL:         add.l   d2,a4           a$ isn't moving, so skip right past it */
    add.l d2,a4
/* QL:         bra.s   M86_shent           go to copy in the possible single b$ byte */
    bra.s M86_shent
/* QL: M86_apity */
M86_apity:
/* QL:         lsr.w   #2,d2           full longwords in a$ */
    lsr.w #2,d2
/* QL:         bcc.s   M86_awent           no odd word to do */
    bcc.s M86_awent
/* QL:         move.w  (a0)+,(a4)+     move the odd single word */
    move.w (a0)+,(a4)+
/* QL:         bra.s   M86_awent           enter word copy loop */
    bra.s M86_awent
/* QL: M86_adown */
M86_adown:
/* QL:         move.l  (a0)+,(a4)+     copy a$ down in longwords */
    move.l (a0)+,(a4)+
/* QL: M86_awent */
M86_awent:
/* QL:         dbra    d2,M86_adown */
    dbra d2,M86_adown
/* QL:         asr.b   #1,d1           did a$ have an odd byte? */
    asr.b #1,d1
/* QL:         bcc.s   M86_short */
    bcc.s M86_short
/* QL:         move.b  (a0)+,(a4)+     yes - we move it now */
    move.b (a0)+,(a4)+
/* QL: * As we know len(b$) was not zero, it's ok to drop straight in here */
/* QL: M86_short */
M86_short:
/* QL:         rol.l   #8,d0 */
    rol.l #8,d0
/* QL:         move.b  d0,(a4)+        move a small string byte into the result */
    move.b d0,(a4)+
/* QL: M86_shent */
M86_shent:
/* QL:         cmp.l   a3,a4 */
    cmp.l a3,a4
/* QL:         bcs.s   M86_short           carry on to the end of the small string */
    bcs.s M86_short
/* QL: M86_setlen */
M86_setlen:
/* QL:         move.w  d3,-(a1)        this is the final length, and a1 is ok! */
    move.w d3,-(a1)
/* QL:         sub.l   a6,a1           set a1 to be an offset again */
    sub.l a6,a1
/* QL:         rte */
    rte 
/* QL: M86_bshuff */
M86_bshuff:
/* QL:         exg     a1,a0           a$ is the M86_short string */
    exg a0,a1
/* QL:         add.l   d2,a0           end of b$ is our source */
    add.l d2,a0
/* QL:         bsr.s   M86_shuff           set it all up */
    bsr.s M86_shuff
/* QL:         tst.b   d1              was len(a$&b$) odd? */
    tst.b d1
/* QL:         bpl.s   M86_bword           no - don't need to do odd byte */
    bpl.s M86_bword
/* QL:         move.b  -(a0),-(a3) */
    move.b -(a0),-(a3)
/* QL:         subq.w  #1,d2 */
    subq.w #1,d2
/* QL: M86_bword */
M86_bword:
/* QL:         asr.b   #1,d1           was len(a$) odd? */
    asr.b #1,d1
/* QL:         bcs.s   M86_bbent           yes, that's tough, have to do all byte shuffle */
    bcs.s M86_bbent
/* QL:         lsr.w   #2,d2           we know this is now even (figure it out!) */
    lsr.w #2,d2
/* QL:         bcc.s   M86_bwent           no carry, do longwords! */
    bcc.s M86_bwent
/* QL:         move.w  -(a0),-(a3)     copy the odd word */
    move.w -(a0),-(a3)
/* QL:         bra.s   M86_bwent           enter loop at bottom */
    bra.s M86_bwent
/* QL: M86_bbloop */
M86_bbloop:
/* QL:         move.b  -(a0),-(a3)     copy b$ bytes */
    move.b -(a0),-(a3)
/* QL: M86_bbent */
M86_bbent:
/* QL:         dbra    d2,M86_bbloop */
    dbra d2,M86_bbloop
/* QL:         bra.s   M86_short           len(a$) odd implies at least one byte! */
    bra.s M86_short
/* QL: M86_bwloop */
M86_bwloop:
/* QL:         move.l  -(a0),-(a3)     copy b$ longwords */
    move.l -(a0),-(a3)
/* QL: M86_bwent */
M86_bwent:
/* QL:         dbra    d2,M86_bwloop */
    dbra d2,M86_bwloop
/* QL:         bra.s   M86_shent           len(a$) could have been zero */
    bra.s M86_shent
/* QL:         end */
