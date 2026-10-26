/* ROM section cn_ftod */
.balign 2,0
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- number of characters in string */
/* QL: * a0 -i o- start of string buffer, output at end */
/* QL: * a1 -i o- arithmetic stack, float removed */
/* QL: reglist reg     d2-d4 */
/* QL: cn_ftod */
cn_ftod:
/* QL:         movem.l reglist,-(sp) */
    movem.l d2-d4,-(sp)
/* QL:         move.w  a0,-(sp)        only need lsw to calculate length */
    move.w a0,-(sp)
/* QL:         moveq   #0,d4           set exponent */
    moveq #0,d4
/* QL:         move.l  2(a6,a1.l),d0   check mantissa */
    move.l 2(a6,a1.l),d0
/* QL:         bgt.s   M65_redent          positive is ok */
    bgt.s M65_redent
/* QL:         beq.l   M65_zero            M65_zero is a special case */
    beq.w M65_zero
/* QL:         move.b  #'-',0(a6,a0.l) put negative in */
    move.b #(45&255),0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         jsr     ri_neg(pc)      negate (will make it strictly positive) */
    jsr ri_neg(pc)
/* QL:         bra.s   M65_redent */
    bra.s M65_redent
/* QL: M65_put_10 */
M65_put_10:
/* QL:         subq.w  #1,d4           take one from exponent */
    subq.w #1,d4
/* QL:         moveq   #10,d0 */
    moveq #10,d0
/* QL:         jmp     ri_n_b(pc) */
    jmp ri_n_b(pc)
/* QL: M65_rep13 */
M65_rep13:
/* QL:         move.w  #$82c,0(a6,a1.l) 1e13 = largest power of 10 with exact fp */
    move.w #0x82c,0(a6,a1.l)
/* QL:         move.l  #$48c27395,2(a6,a1.l) */
    move.l #0x48c27395,2(a6,a1.l)
/* QL:         sub.w   #13-1,d4        take additional from exponent */
    sub.w #(13-1),d4
/* QL:         rts */
    rts 
/* QL: M65_redloop */
M65_redloop:
/* QL:         bsr.s   M65_put_10          divide by ten or ... */
    bsr.s M65_put_10
/* QL:         cmp.w   #M65_fphuge,0(a6,a1.l) */
    cmp.w #M65_fphuge,0(a6,a1.l)
/* QL:         ble.s   M65_godiv */
    ble.s M65_godiv
/* QL:         bsr.s   M65_rep13           ... 1e13 if it is huge */
    bsr.s M65_rep13
/* QL: M65_godiv */
M65_godiv:
/* QL:         jsr     ri_div(pc) */
    jsr ri_div(pc)
/* QL: M65_redent */
M65_redent:
/* QL:         cmp.l   #M65_fphigh,0(a6,a1.l) have we got less than M65_ndigs+2 yet? */
    cmp.l #M65_fphigh,0(a6,a1.l)
/* QL:         bgt.s   M65_redloop         no - divide down by something */
    bgt.s M65_redloop
/* QL:         neg.w   d4              negate exponent for proper value */
    neg.w d4
/* QL: M65_increase */
M65_increase:
/* QL:         cmp.l   #M65_fplow,0(a6,a1.l) have we got at least M65_ndigs+1 yet? */
    cmp.l #M65_fplow,0(a6,a1.l)
/* QL:         bgt.s   M65_integer         yes - go do M65_integer calcs now */
    bgt.s M65_integer
/* QL:         bsr.s   M65_put_10          multiply by 10 or ... */
    bsr.s M65_put_10
/* QL:         cmp.w   #M65_fptiny,0(a6,a1.l) */
    cmp.w #M65_fptiny,0(a6,a1.l)
/* QL:         bgt.s   M65_gomul */
    bgt.s M65_gomul
/* QL:         bsr.s   M65_rep13           ... 1e13 if it was tiny */
    bsr.s M65_rep13
/* QL: M65_gomul */
M65_gomul:
/* QL:         jsr     ri_mult(pc) */
    jsr ri_mult(pc)
/* QL:         bra.s   M65_increase        try again */
    bra.s M65_increase
/* QL: M65_divl_10 */
M65_divl_10:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         swap    d1 */
    swap d1
/* QL:         move.w  d1,d0           get msw of number */
    move.w d1,d0
/* QL:         divu    #10,d0          divide it by 10 */
    divu #10,d0
/* QL:         move.w  d0,d1 */
    move.w d0,d1
/* QL:         swap    d1              msw of quotient ready */
    swap d1
/* QL:         move.w  d1,d0           now remainder of 1st div and lsw of number */
    move.w d1,d0
/* QL:         divu    #10,d0          divide this by 10 */
    divu #10,d0
/* QL:         move.w  d0,d1           whole of quotient ready */
    move.w d0,d1
/* QL:         swap    d0              leave remainder in lsw */
    swap d0
/* QL:         addq.w  #1,d4           say we've done it */
    addq.w #1,d4
/* QL:         rts */
    rts 
/* QL: M65_integer */
M65_integer:
/* QL:         moveq   #31,d0          convert reduced fp to M65_integer */
    moveq #31,d0
/* QL:         sub.w   0(a6,a1.l),d0   find shift */
    sub.w 0(a6,a1.l),d0
/* QL:         move.l  2(a6,a1.l),d1   get mantissa */
    move.l 2(a6,a1.l),d1
/* QL:         lsr.l   d0,d1           shift it (will be 4..7 shifts) */
    lsr.l d0,d1
/* QL:         move.l  #M65_maxint,d2      this is number we want to finish below */
    move.l #M65_maxint,d2
/* QL: M65_round */
M65_round:
/* QL:         bsr.s   M65_divl_10         divide by 10 */
    bsr.s M65_divl_10
/* QL:         cmp.l   d2,d1           is it more than M65_ndigs digits */
    cmp.l d2,d1
/* QL:         bge.s   M65_round           this should happen one in about 64k times */
    bge.s M65_round
/* QL:         subq.b  #5,d0           is remainder >= 5 */
    subq.b #5,d0
/* QL:         bmi.s   M65_remok           no - that's ok then */
    bmi.s M65_remok
/* QL:         addq.l  #1,d1           M65_round up */
    addq.l #1,d1
/* QL:         cmp.l   d2,d1           that might just sneak over ... */
    cmp.l d2,d1
/* QL:         blt.s   M65_remok           nope... that's ok */
    blt.s M65_remok
/* QL:         bsr.s   M65_divl_10         one in a million times! */
    bsr.s M65_divl_10
/* QL: M65_remok */
M65_remok:
/* QL:         addq.w  #M65_ndigs+1,a0     convert digits leaving one space for dp */
    addq.w #(M65_ndigs+1),a0
/* QL:         moveq   #M65_ndigs-1,d2 */
    moveq #(M65_ndigs-1),d2
/* QL:         moveq   #'0',d3 */
    moveq #48,d3
/* QL: M65_con_dig */
M65_con_dig:
/* QL:         bsr.s   M65_divl_10         divide by 10 */
    bsr.s M65_divl_10
/* QL:         add.b   d3,d0           add ascii '0' to remainder to make char */
    add.b d3,d0
/* QL:         subq.l  #1,a0 */
    subq.l #1,a0
/* QL:         move.b  d0,0(a6,a0.l)   put char in string */
    move.b d0,0(a6,a0.l)
/* QL:         dbra    d2,M65_con_dig */
    dbra d2,M65_con_dig
/* QL: * Check if exponent is required */
/* QL:         move.l  a0,d2           copy buffer pointer for leading char move */
    move.l a0,d2
/* QL:         addq.l  #M65_ndigs,a0       move a0 to last char of string */
    addq.l #M65_ndigs,a0
/* QL:         moveq   #1,d0           no exponent required? (also d0.msw=0) */
    moveq #1,d0
/* QL:         cmp.w   #M65_ndigs,d4       is exponent too small or large? */
    cmp.w #M65_ndigs,d4
/* QL:         bcs.s   M65_dp_end          0..ndigs-1 then we're in business */
    bcs.s M65_dp_end
/* QL:         move.w  d4,d0           exponent required, dp after after 1st digit */
    move.w d4,d0
/* QL:         moveq   #0,d4           just move the first character */
    moveq #0,d4
/* QL: M65_dp_loop */
M65_dp_loop:
/* QL:         move.b  0(a6,d2.l),-1(a6,d2.l) move leading characters down */
    move.b 0(a6,d2.l),(-1)(a6,d2.l)
/* QL:         addq.l  #1,d2 */
    addq.l #1,d2
/* QL: M65_dp_end */
M65_dp_end:
/* QL:         dbra    d4,M65_dp_loop */
    dbra d4,M65_dp_loop
/* QL:         moveq   #'.',d1         dp */
    moveq #46,d1
/* QL:         move.b  d1,-1(a6,d2.l)  put dp into string */
    move.b d1,(-1)(a6,d2.l)
/* QL: M65_zer_loop */
M65_zer_loop:
/* QL:         subq.l  #1,a0 */
    subq.l #1,a0
/* QL:         cmp.b   0(a6,a0.l),d3   is trailing digit a M65_zero? */
    cmp.b 0(a6,a0.l),d3
/* QL:         beq.s   M65_zer_loop        ... yes check next */
    beq.s M65_zer_loop
/* QL:         cmp.b   0(a6,a0.l),d1   is last char now the dp */
    cmp.b 0(a6,a0.l),d1
/* QL:         beq.s   M65_put_exp         yes - ignore it */
    beq.s M65_put_exp
/* QL:         addq.l  #1,a0           no  - include it */
    addq.l #1,a0
/* QL: M65_put_exp */
M65_put_exp:
/* QL:         subq.w  #1,d0           was exponent required */
    subq.w #1,d0
/* QL:         beq.s   M65_exit            ... no (now d0.l=0) */
    beq.s M65_exit
/* QL:         move.b  #'e',0(a6,a0.l) ... yes put in e */
    move.b #(101&255),0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL: M65_zero */
M65_zero:
/* QL:         jsr     cn_0tod(pc)     convert to string */
    jsr cn_0tod(pc)
/* QL: M65_exit */
M65_exit:
/* QL:         addq.l  #6,a1           remove fp from stack */
    addq.l #6,a1
/* QL:         move.w  a0,d1           get end pointer (we have d1.msw=0 here) */
    move.w a0,d1
/* QL:         sub.w   (sp)+,d1        take away start to give length of string */
    sub.w (sp)+,d1
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d2-d4
/* QL:         rts */
    rts 
/* QL:         end */
