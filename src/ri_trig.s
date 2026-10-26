/* ROM section ri_trig */
.balign 2,0
/* QL: * All entry points expect/affect registers as follows: */
/* QL: * d0 -  o- error code */
/* QL: * a1 -i o- arithmetic stack */
/* QL: * a6 -ip - base address */
/* QL: * d1-d3 destroyed */
/* QL: reglist reg     d4-d7/a4 */
/* QL: * Evaluates one or two polynomials */
/* QL: * Treating special cases, e.g. zero argument or coefficient, is not done here, */
/* QL: * as it is better done by putting optimisations in ri_add, etc. */
/* QL: * d4 -  o- exponent word of input tos */
/* QL: * d5 -  o- mantissa longword of input tos */
/* QL: * a1 -i o- arithmetic stack, x -> f(x) or f2(x),f1(x) */
/* QL: * a4 -i o- top of M102_poly coeffs data / start of same */
/* QL: * d0-d3/d6 destroyed */
/* QL: M102_poly */
M102_poly:
/* QL:         move.w  0(a6,a1.l),d4   fetch exponent */
    move.w 0(a6,a1.l),d4
/* QL:         move.l  2(a6,a1.l),d5   fetch mantissa */
    move.l 2(a6,a1.l),d5
/* QL: M102_poly1 */
M102_poly1:
/* QL:         move.w  -(a4),d6        find order of polynomial */
    move.w -(a4),d6
/* QL:         move.l  -(a4),2(a6,a1.l) put first coefficient on stack */
    move.l -(a4),2(a6,a1.l)
/* QL:         move.w  -(a4),0(a6,a1.l) */
    move.w -(a4),0(a6,a1.l)
/* QL: M102_polylp */
M102_polylp:
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.l  d5,2(a6,a1.l)   put argument back on stack and multiply */
    move.l d5,2(a6,a1.l)
/* QL:         move.w  d4,0(a6,a1.l) */
    move.w d4,0(a6,a1.l)
/* QL:         jsr     ri_mult(pc) */
    jsr ri_mult(pc)
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.l  -(a4),2(a6,a1.l) add next coefficient */
    move.l -(a4),2(a6,a1.l)
/* QL:         move.w  -(a4),0(a6,a1.l) */
    move.w -(a4),0(a6,a1.l)
/* QL:         jsr     ri_add(pc) */
    jsr ri_add(pc)
/* QL:         subq.w  #1,d6 */
    subq.w #1,d6
/* QL:         bgt.s   M102_polylp */
    bgt.s M102_polylp
/* QL: M102_rts0 */
M102_rts0:
/* QL:         rts */
    rts 
/* QL: M102_poly2 */
M102_poly2:
/* QL:         bsr.s   M102_poly            evaluate first polynomial */
    bsr.s M102_poly
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         bra.s   M102_poly1           evaluate next polynomial using same arg */
    bra.s M102_poly1
/* QL: ri_sin */
ri_sin:
/* QL:         movem.l reglist,-(sp)   save data registers */
    movem.l d4-d7/a4,-(sp)
/* QL:         moveq   #0,d7           set sine flag for argument reduction */
    moveq #0,d7
/* QL:         bra.s   M102_sin_cos */
    bra.s M102_sin_cos
/* QL: ri_cos */
ri_cos:
/* QL:         movem.l reglist,-(sp)   save data registers */
    movem.l d4-d7/a4,-(sp)
/* QL:         jsr     ri_abs(pc)      cosine x = cosine -x */
    jsr ri_abs(pc)
/* QL:         moveq   #-1,d7          set cosine flag for argument reduction */
    moveq #(-1),d7
/* QL: M102_sin_cos */
M102_sin_cos:
/* QL:         bsr.s   M102_argrp           M102_reduce argument by increments of pi */
    bsr.s M102_argrp
/* QL:         bne.l   M102_putzero         if huge (+/-), just return zero */
    bne.w M102_putzero
/* QL:         bsr.l   M102_dup3_m          duplicate reduced argument and square */
    bsr.w M102_dup3_m
/* QL:         bsr.s   M102_poly            p(x**2) */
    bsr.s M102_poly
/* QL:         bsr.l   M102_m_a             evaluate p(x**2)*x+x */
    bsr.w M102_m_a
/* QL:         lsr.b   #1,d7           check quadrant */
    lsr.b #1,d7
/* QL:         bcc.s   M102_exit0 */
    bcc.s M102_exit0
/* QL:         jsr     ri_neg(pc)      negate odd ones */
    jsr ri_neg(pc)
/* QL: M102_exit0 */
M102_exit0:
/* QL:         bra.l   M102_exit */
    bra.w M102_exit
/* QL: M102_argrp */
M102_argrp:
/* QL:         lea     M102_sin_tab,a4      polynomial tables */
    lea M102_sin_tab(pc),a4
/* QL: * d0 -  o- error if non-zero */
/* QL: * d7 -i o- 0 normal, -1 for cos / integer reducer */
/* QL: * a1 -ip - arithmetic stack (uses 8 bytes extra) */
/* QL: * a4 -i o- pointer to end of reducer table (if ok, moved to start of table) */
/* QL: * d1-d5 destroyed */
/* QL: M102_argrd */
M102_argrd:
/* QL:         move.w  -(a4),d0        this is non-zero, so will register as an error */
    move.w -(a4),d0
/* QL:         cmp.w   0(a6,a1.l),d0   is this too huge? */
    cmp.w 0(a6,a1.l),d0
/* QL:         bcs.s   M102_rts0            yes - get out now */
    bcs.s M102_rts0
/* QL:         jsr     ri_dup(pc)      duplicate top of stack */
    jsr ri_dup(pc)
/* QL:         bsr.s   M102_nxt_mult        multiply by reducer */
    bsr.s M102_nxt_mult
/* QL:         tst.b   d7              check for cos */
    tst.b d7
/* QL:         bne.s   M102_sym_red */
    bne.s M102_sym_red
/* QL:         jsr     ri_nlint(pc)    nearest integer for normal */
    jsr ri_nlint(pc)
/* QL:         move.w  d1,d7           save segment number */
    move.w d1,d7
/* QL:         jsr     ri_flong(pc)    then float it */
    jsr ri_flong(pc)
/* QL:         bra.s   M102_reduce */
    bra.s M102_reduce
/* QL: M102_sym_red */
M102_sym_red:
/* QL:         jsr     ri_lint(pc)     cos truncates */
    jsr ri_lint(pc)
/* QL:         addq.l  #4,a1 */
    addq.l #4,a1
/* QL:         add.w   d1,d7           save segment number for cos */
    add.w d1,d7
/* QL:         add.l   d1,d1           to add a half: double, */
    add.l d1,d1
/* QL:         addq.l  #1,d1           add one, */
    addq.l #1,d1
/* QL:         jsr     ri_fllin(pc)    float and */
    jsr ri_fllin(pc)
/* QL:         subq.w  #1,0(a6,a1.l)   halve it */
    subq.w #1,0(a6,a1.l)
/* QL: M102_reduce */
M102_reduce:
/* QL:         move.w  0(a6,a1.l),d4   save floated range reducer */
    move.w 0(a6,a1.l),d4
/* QL:         move.l  2(a6,a1.l),d5 */
    move.l 2(a6,a1.l),d5
/* QL:         bsr.s   M102_mult_sub        subtract exact binary near reducer*n */
    bsr.s M102_mult_sub
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.l  d5,2(a6,a1.l)   restore reducer */
    move.l d5,2(a6,a1.l)
/* QL:         move.w  d4,0(a6,a1.l)   subtract corrector*n */
    move.w d4,0(a6,a1.l)
/* QL: M102_mult_sub */
M102_mult_sub:
/* QL:         pea     ri_sub(pc) */
    pea ri_sub(pc)
/* QL: M102_nxt_mult */
M102_nxt_mult:
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.l  -(a4),2(a6,a1.l) fetch next number */
    move.l -(a4),2(a6,a1.l)
/* QL:         move.w  -(a4),0(a6,a1.l) */
    move.w -(a4),0(a6,a1.l)
/* QL:         jmp     ri_mult(pc) */
    jmp ri_mult(pc)
/* QL: * Tangent and cotangent */
/* QL: ri_tan */
ri_tan:
/* QL:         movem.l reglist,-(sp)   save data registers */
    movem.l d4-d7/a4,-(sp)
/* QL:         moveq   #0,d6           tan is tan */
    moveq #0,d6
/* QL:         bra.s   M102_tan_cot */
    bra.s M102_tan_cot
/* QL: ri_cot */
ri_cot:
/* QL:         movem.l reglist,-(sp)   save data registers */
    movem.l d4-d7/a4,-(sp)
/* QL:         moveq   #-1,d6          cot is 1/tan */
    moveq #(-1),d6
/* QL:         jsr     ri_neg(pc)      (but 1/tan negates) */
    jsr ri_neg(pc)
/* QL: M102_tan_cot */
M102_tan_cot:
/* QL:         clr.w   d7 */
    clr.w d7
/* QL:         addq.w  #1,0(a6,a1.l)   multiply argument by 2 */
    addq.w #1,0(a6,a1.l)
/* QL:         bsr.s   M102_argrp           reduces original arg by increments of pi/2 */
    bsr.s M102_argrp
/* QL:         bne.l   M102_putzero         if very large, just say answer is zero */
    bne.w M102_putzero
/* QL:         subq.w  #1,0(a6,a1.l)   divide argument back down */
    subq.w #1,0(a6,a1.l)
/* QL:         eor.b   d6,d7           if cot then swap quadrants */
    eor.b d6,d7
/* QL:         bsr.s   M102_dup3_m          duplicate reduced argument and square */
    bsr.s M102_dup3_m
/* QL:         lea     M102_tan_tab,a4      evaluate p(x**2) */
    lea M102_tan_tab(pc),a4
/* QL:         bsr.l   M102_poly2           and q(x**2) */
    bsr.w M102_poly2
/* QL:         addq.l  #6,a1           leave q(x**2) where it is */
    addq.l #6,a1
/* QL:         bsr.s   M102_m_a             evaluate p(x**2)*x+x */
    bsr.s M102_m_a
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.l  -10(a6,a1.l),2(a6,a1.l) move q(x**2) up */
    move.l (-10)(a6,a1.l),2(a6,a1.l)
/* QL:         move.w  -12(a6,a1.l),0(a6,a1.l) */
    move.w (-12)(a6,a1.l),0(a6,a1.l)
/* QL:         lsr.b   #1,d7           check quadrant */
    lsr.b #1,d7
/* QL:         bcc.s   M102_tc_div */
    bcc.s M102_tc_div
/* QL:         jsr     ri_swap(pc)     really -q/p */
    jsr ri_swap(pc)
/* QL:         jsr     ri_neg(pc) */
    jsr ri_neg(pc)
/* QL: M102_tc_div */
M102_tc_div:
/* QL:         jsr     ri_div(pc)      find p/q */
    jsr ri_div(pc)
/* QL: M102_exit */
M102_exit:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d4-d7/a4
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         bne.l   ri_errov (pc)   n.b. this is external */
    bne.w ri_errov
/* QL: M102_rts1 */
M102_rts1:
/* QL:         rts */
    rts 
/* QL: M102_dup3_m */
M102_dup3_m:
/* QL:         jsr     ri_dup(pc)      stack => x,x */
    jsr ri_dup(pc)
/* QL: M102_dup2_m */
M102_dup2_m:
/* QL:         jsr     ri_dup(pc)      stack => x,x,x */
    jsr ri_dup(pc)
/* QL:         jmp     ri_squar(pc)    stack => x,x,x^2 */
    jmp ri_squar(pc)
/* QL: M102_m_a */
M102_m_a:
/* QL:         jsr     ri_mult(pc)     p*next to top */
    jsr ri_mult(pc)
/* QL:         jmp     ri_add(pc)      p*next to top+next but one */
    jmp ri_add(pc)
/* QL: ri_acos */
ri_acos:
/* QL:         bsr.s   M102_side2           got x, want y for arctan2 */
    bsr.s M102_side2
/* QL:         bne.s   M102_rts1            can't have arg > 1 */
    bne.s M102_rts1
/* QL:         jsr     ri_swap(pc)     put 'em the right way round */
    jsr ri_swap(pc)
/* QL:         bra.s   ri_arg          go do it */
    bra.s ri_arg
/* QL: ri_asin */
ri_asin:
/* QL:         bsr.s   M102_side2           got y, want x for arctan2 */
    bsr.s M102_side2
/* QL:         bne.s   M102_rts1            can't have arg > 1 */
    bne.s M102_rts1
/* QL:         bra.s   ri_arg          go do it */
    bra.s ri_arg
/* QL: M102_side2 */
M102_side2:
/* QL:         bsr.s   M102_dup2_m          stack => y,y**2 */
    bsr.s M102_dup2_m
/* QL:         bne.s   M102_rts1            mustn't have overflow! */
    bne.s M102_rts1
/* QL:         bsr.s   M102_put_1_s         stack => y,1,y**2 */
    bsr.s M102_put_1_s
/* QL:         pea     ri_sqrt(pc)     stack => y,sqrt(1-y**2) */
    pea ri_sqrt(pc)
/* QL:         jmp     ri_sub(pc) */
    jmp ri_sub(pc)
/* QL: ri_acot */
ri_acot:
/* QL:         pea     ri_arg */
    pea ri_arg(pc)
/* QL: M102_put_1_s */
M102_put_1_s:
/* QL:         pea     ri_swap(pc)     return via swap */
    pea ri_swap(pc)
/* QL: M102_put_1 */
M102_put_1:
/* QL:         jmp     ri_one(pc) */
    jmp ri_one(pc)
/* QL: ri_atan */
ri_atan:
/* QL:         bsr.s   M102_put_1 */
    bsr.s M102_put_1
/* QL: ri_arg  ; tos = x, nos = y  */
ri_arg:
/* QL:         movem.l reglist,-(sp) */
    movem.l d4-d7/a4,-(sp)
/* QL:         sf      d7              clear flag byte */
    sf d7
/* QL:         tst.b   6+2(a6,a1.l)    is y coord negative? */
    tst.b (6+2)(a6,a1.l)
/* QL:         bpl.s   M102_t2_chkx         no, skip negate */
    bpl.s M102_t2_chkx
/* QL:         addq.b  #2,d7           set flag bit */
    addq.b #2,d7
/* QL:         addq.l  #6,a1 */
    addq.l #6,a1
/* QL:         jsr     ri_neg(pc)      force positive y coord (ri_neg leaves x alone!) */
    jsr ri_neg(pc)
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL: M102_t2_chkx */
M102_t2_chkx:
/* QL:         move.l  2(a6,a1.l),d1   check for negative x coordinate */
    move.l 2(a6,a1.l),d1
/* QL:         bpl.s   M102_t2_chkg */
    bpl.s M102_t2_chkg
/* QL:         addq.b  #4,d7           set flag bit */
    addq.b #4,d7
/* QL:         jsr     ri_neg(pc) */
    jsr ri_neg(pc)
/* QL: M102_t2_chkg */
M102_t2_chkg:
/* QL:         move.w  0(a6,a1.l),d0   get x coord exponent */
    move.w 0(a6,a1.l),d0
/* QL:         cmp.w   6(a6,a1.l),d0   compare exponents */
    cmp.w 6(a6,a1.l),d0
/* QL:         bcs.s   M102_t2_swap         if x << y we swap */
    bcs.s M102_t2_swap
/* QL:         bne.s   M102_t2_div          if x >> y we're ready to divide */
    bne.s M102_t2_div
/* QL:         cmp.l   2+6(a6,a1.l),d1 compare mantissas */
    cmp.l (2+6)(a6,a1.l),d1
/* QL:         bcs.s   M102_t2_swap         if x < y, so swap first */
    bcs.s M102_t2_swap
/* QL:         bne.s   M102_t2_div          if x > y, go do divide */
    bne.s M102_t2_div
/* QL:         tst.l   d1              are we being told to do arctan2(0,0)? */
    tst.l d1
/* QL:         beq.l   M102_tc_div          if so, perform a divide to force the error */
    beq.w M102_tc_div
/* QL: M102_t2_swap */
M102_t2_swap:
/* QL:         jsr     ri_swap(pc)     swap x <--> y, so we now have nos <= tos */
    jsr ri_swap(pc)
/* QL:         addq.b  #8,d7           remember we did it (not r = pi/2 - r) */
    addq.b #8,d7
/* QL: M102_t2_div */
M102_t2_div:
/* QL:         bsr.s   M102_div             now we have a nice 0..1 to arctan(x) */
    bsr.s M102_div
/* QL:         cmp.w   #$7ff,0(a6,a1.l) */
    cmp.w #0x7ff,0(a6,a1.l)
/* QL:         bcs.s   M102_atn_eval        if t < .25, ok */
    bcs.s M102_atn_eval
/* QL:         bne.s   M102_atn_pi6         if t >= .5, must M102_reduce */
    bne.s M102_atn_pi6
/* QL:         cmp.l   #$4498517a,2(a6,a1.l) compare to tan(pi/12) = 2 - sqrt(3) */
    cmp.l #0x4498517a,2(a6,a1.l)
/* QL:         ble.s   M102_atn_eval        if it's not bigger than that, we're ok */
    ble.s M102_atn_eval
/* QL: M102_atn_pi6         ; arctan(x) = pi/6 + arctan((sqrt(3)*x-1)/(x+sqrt(3)) */
M102_atn_pi6:
/* QL:         jsr     ri_dup(pc)      x,x */
    jsr ri_dup(pc)
/* QL:         bsr.s   M102_sqrt3           x,x,sqrt(3) */
    bsr.s M102_sqrt3
/* QL:         bsr.s   M102_mult0           x,sqrt(3)*x */
    bsr.s M102_mult0
/* QL:         jsr     ri_one(pc)      x,sqrt(3)*x,1 */
    jsr ri_one(pc)
/* QL:         jsr     ri_sub(pc)      x,sqrt(3)*x-1 */
    jsr ri_sub(pc)
/* QL:         jsr     ri_swap(pc)     sqrt(3)*x-1,x */
    jsr ri_swap(pc)
/* QL:         bsr.s   M102_sqrt3           sqrt(3)*x-1,x,sqrt(3) */
    bsr.s M102_sqrt3
/* QL:         jsr     ri_add(pc)      sqrt(3)*x-1,x+sqrt(3) */
    jsr ri_add(pc)
/* QL:         bsr.s   M102_div             (sqrt(3)*x-1)/(x+sqrt(3)) */
    bsr.s M102_div
/* QL:         addq.b  #1,d7           set r = r + pi/6 flag */
    addq.b #1,d7
/* QL:         ; note. we now have a range -pi/12..pi/12 left to do.  */
/* QL: M102_atn_eval */
M102_atn_eval:
/* QL:         bsr.l   M102_dup3_m          stack => f,f,f*f */
    bsr.w M102_dup3_m
/* QL:         lea     M102_atn_tab,a4      load address of arctan table */
    lea M102_atn_tab(pc),a4
/* QL:         bsr.s   M102_p2div           evaluate both polynomials and divide them */
    bsr.s M102_p2div
/* QL:         bsr.l   M102_m_a             form result */
    bsr.w M102_m_a
/* QL:         lsr.b   #1,d7           check whether to add pi/6 */
    lsr.b #1,d7
/* QL:         bcc.s   M102_chk_aneg */
    bcc.s M102_chk_aneg
/* QL:         moveq   #M102_ri.pi6,d0 */
    moveq #M102_ri.pi6,d0
/* QL:         bsr.s   M102_k_b             put pi/6 on stack */
    bsr.s M102_k_b
/* QL:         jsr     ri_add(pc)      add it */
    jsr ri_add(pc)
/* QL: M102_chk_aneg */
M102_chk_aneg:
/* QL:         moveq   #%01101001,d1 */
    moveq #0b01101001,d1
/* QL:         btst    d7,d1           check whether to negate result (odd octant) */
    btst d7,d1
/* QL:         bne.s   M102_chk_ppi         if tos<0 eor nos<0 eor swapped = 1, no negate */
    bne.s M102_chk_ppi
/* QL:         jsr     ri_neg(pc) */
    jsr ri_neg(pc)
/* QL: M102_chk_ppi */
M102_chk_ppi:
/* QL:         subq.b  #2,d7           is that all (-pi/4 to +pi/4) */
    subq.b #2,d7
/* QL:         bmi.s   M102_exit2           yes, get out */
    bmi.s M102_exit2
/* QL:         moveq   #M102_ri.pi,d0 */
    moveq #M102_ri.pi,d0
/* QL:         subq.b  #2,d7           do we need pi? (-pi..-3pi/4 & 3pi/4..-pi) */
    subq.b #2,d7
/* QL:         spl     d1 */
    spl d1
/* QL:         add.b   d1,d0           halve pi to pi/2 usually */
    add.b d1,d0
/* QL:         bsr.s   M102_k_b */
    bsr.s M102_k_b
/* QL:         lsr.b   #1,d7           do we want to negate it? */
    lsr.b #1,d7
/* QL:         bcc.s   M102_add_pi_k        nope, go add the constant */
    bcc.s M102_add_pi_k
/* QL:         neg.l   2(a6,a1.l) */
    neg.l 2(a6,a1.l)
/* QL: M102_add_pi_k */
M102_add_pi_k:
/* QL:         jsr     ri_add(pc) */
    jsr ri_add(pc)
/* QL: M102_exit2 */
M102_exit2:
/* QL:         bra.l   M102_exit */
    bra.w M102_exit
/* QL: M102_p2div */
M102_p2div:
/* QL:         bsr.l   M102_poly2           evaluate both polynomials, and then */
    bsr.w M102_poly2
/* QL: M102_div */
M102_div:
/* QL:         jmp     ri_div(pc)      divide */
    jmp ri_div(pc)
/* QL: M102_sqrt3 */
M102_sqrt3:
/* QL:         moveq   #M102_ri.sqrt3,d0 */
    moveq #M102_ri.sqrt3,d0
/* QL: M102_k_b */
M102_k_b:
/* QL:         jmp     ri_k_b(pc) */
    jmp ri_k_b(pc)
/* QL: ri_log10 */
ri_log10:
/* QL:         bsr.s   ri_ln           evaluate natural log */
    bsr.s ri_ln
/* QL:         bne.s   M102_rts2 */
    bne.s M102_rts2
/* QL:         moveq   #M102_ri.loge,d0     put log10(e) on stack */
    moveq #M102_ri.loge,d0
/* QL:         jsr     ri_k_b(pc) */
    jsr ri_k_b(pc)
/* QL: M102_mult0 */
M102_mult0:
/* QL:         jmp     ri_mult(pc)     multiply */
    jmp ri_mult(pc)
/* QL: M102_rts2 */
M102_rts2:
/* QL:         rts */
    rts 
/* QL: ri_ln */
ri_ln:
/* QL:         movem.l reglist,-(sp) */
    movem.l d4-d7/a4,-(sp)
/* QL:         move.w  #$800,d0        prepare to float (and d0<>0) */
    move.w #0x800,d0
/* QL:         move.l  2(a6,a1.l),d1   pick up mantissa */
    move.l 2(a6,a1.l),d1
/* QL:         ble.s   M102_exit2           negative log? */
    ble.s M102_exit2
/* QL:         move.w  0(a6,a1.l),d7   pick up exponent */
    move.w 0(a6,a1.l),d7
/* QL:         sub.w   d0,d7           get rid of offset */
    sub.w d0,d7
/* QL: * Now we have the problem of putting the numerator in d0,d1 and the denominator */
/* QL: * in d5 (always between .5 and 1) */
/* QL:         moveq   #2,d2           ready to add 1 */
    moveq #2,d2
/* QL:         cmp.l   #$5a82799a,d1   check for > sqrt(1/2) */
    cmp.l #0x5a82799a,d1
/* QL:         bgt.s   M102_note_10 */
    bgt.s M102_note_10
/* QL:         subq.w  #1,d7           M102_reduce exponent */
    subq.w #1,d7
/* QL:         moveq   #1,d2           change to .5 */
    moveq #1,d2
/* QL: M102_note_10 */
M102_note_10:
/* QL:         move.l  d1,d5 */
    move.l d1,d5
/* QL:         ror.l   #2,d2           1 (.5) */
    ror.l #2,d2
/* QL:         sub.l   d2,d1           subtract 1 (.5) from numerator */
    sub.l d2,d1
/* QL:         add.l   d2,d5           add .5 (.25) to denominator */
    add.l d2,d5
/* QL:         lsr.l   #1,d5           sort out denom */
    lsr.l #1,d5
/* QL:         move.w  d0,0(a6,a1.l) */
    move.w d0,0(a6,a1.l)
/* QL:         move.l  d5,2(a6,a1.l)   put denominator on stack */
    move.l d5,2(a6,a1.l)
/* QL:         jsr     ri_renrm(pc)    and renormalise numerator and put on stack */
    jsr ri_renrm(pc)
/* QL:         jsr     ri_rdiv(pc)     reversed divide */
    jsr ri_rdiv(pc)
/* QL:         bsr.l   M102_dup3_m          set up stack for M102_poly evaluation (z,z,w) */
    bsr.w M102_dup3_m
/* QL:         jsr     ri_dup(pc)      z,z,w,w */
    jsr ri_dup(pc)
/* QL:         lea     M102_log_tab,a4      use coefficients for log */
    lea M102_log_tab(pc),a4
/* QL:         bsr.s   M102_p2div           eval polynomials (z,z,w,a(w),b(w)) and divide */
    bsr.s M102_p2div
/* QL:         bsr.s   M102_mult0           multiply to form z,z,r(w) */
    bsr.s M102_mult0
/* QL:         bsr.s   M102_m_a1            form final reduced result */
    bsr.s M102_m_a1
/* QL: * Now add the exponent */
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  d7,0(a6,a1.l)   float it on stack */
    move.w d7,0(a6,a1.l)
/* QL:         jsr     ri_float(pc) */
    jsr ri_float(pc)
/* QL:         moveq   #M102_ri.ln2,d0      ln(2) */
    moveq #M102_ri.ln2,d0
/* QL:         jsr     ri_k_b(pc) */
    jsr ri_k_b(pc)
/* QL:         pea     M102_exit */
    pea M102_exit(pc)
/* QL: M102_m_a1 */
M102_m_a1:
/* QL:         bra.l   M102_m_a             multiply and add */
    bra.w M102_m_a
/* QL: ri_exp */
ri_exp:
/* QL:         movem.l reglist,-(sp) */
    movem.l d4-d7/a4,-(sp)
/* QL:         clr.w   d7              exp needs d7 = 0 */
    clr.w d7
/* QL:         lea     M102_exp_tab,a4      exponent polynomial tables */
    lea M102_exp_tab(pc),a4
/* QL:         bsr.l   M102_argrd           M102_reduce argument by increments of ln(2) */
    bsr.w M102_argrd
/* QL:         bne.s   M102_expbad          if exponent large, go see about under/overflow */
    bne.s M102_expbad
/* QL:         bsr.l   M102_dup2_m          stack => g,g**2 */
    bsr.w M102_dup2_m
/* QL:         bsr.l   M102_poly2           stack => g,p,q */
    bsr.w M102_poly2
/* QL:         addq.l  #6,a1           work on p */
    addq.l #6,a1
/* QL:         jsr     ri_mult(pc)     stack => g*p,-,q */
    jsr ri_mult(pc)
/* QL:         jsr     ri_dup(pc)      stack => g*p,g*p,q */
    jsr ri_dup(pc)
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         jsr     ri_swap(pc)     stack => g*p,q,g*p */
    jsr ri_swap(pc)
/* QL:         jsr     ri_sub(pc)      stack => g*p,q-g*p */
    jsr ri_sub(pc)
/* QL:         jsr     ri_div(pc)      stack => g*p/(q-g*p) */
    jsr ri_div(pc)
/* QL:         addq.w  #1,0(a6,a1.l)   stack => 2*g*p/(q-g*p) */
    addq.w #1,0(a6,a1.l)
/* QL:         jsr     ri_one(pc)      stack => 2*g*p/(q-g*p),1.0 */
    jsr ri_one(pc)
/* QL:         jsr     ri_add(pc)      stack => (q+g*p)/(q-g*p) */
    jsr ri_add(pc)
/* QL:         add.w   d7,0(a6,a1.l)   add exponent */
    add.w d7,0(a6,a1.l)
/* QL:         move.b  0(a6,a1.l),d0 */
    move.b 0(a6,a1.l),d0
/* QL:         asr.b   #4,d0           if ok or overflow, we're ready */
    asr.b #4,d0
/* QL:         bmi.s   M102_putzero         if negative, we've underflowed */
    bmi.s M102_putzero
/* QL: M102_exit3 */
M102_exit3:
/* QL:         bra.l   M102_exit */
    bra.w M102_exit
/* QL: M102_expbad */
M102_expbad:
/* QL:         tst.b   2(a6,a1.l)      big exponent, check for +ve or -ve mantissa */
    tst.b 2(a6,a1.l)
/* QL:         bpl.s   M102_exit3           force overflow for large values */
    bpl.s M102_exit3
/* QL: M102_putzero */
M102_putzero:
/* QL:         addq.l  #6,a1 */
    addq.l #6,a1
/* QL:         jsr     ri_zero(pc)     make result be zero */
    jsr ri_zero(pc)
/* QL:         bra.s   M102_exit3 */
    bra.s M102_exit3
/* QL: * Exponent tables */
/* QL:         dc.w    $0800,$4000,$0000       0.5 */
.balign 2,0
M102_dc_anchor_750:
.word 0x0800
.word 0x4000
.word 0x0000
/* QL:         dc.w    $07fc,$6db4,$ce83       0.05356751765 */
.balign 2,0
M102_dc_anchor_756:
.word 0x07fc
.word 0x6db4
.word 0xce83
/* QL:         dc.w    $07f5,$4def,$09ca       0.0002972936368 */
.balign 2,0
M102_dc_anchor_762:
.word 0x07f5
.word 0x4def
.word 0x09ca
/* QL:         dc.w    2 */
.balign 2,0
M102_dc_anchor_768:
.word 2
/* QL:         dc.w    $07ff,$4000,$0000       0.25 */
.balign 2,0
M102_dc_anchor_772:
.word 0x07ff
.word 0x4000
.word 0x0000
/* QL:         dc.w    $07f9,$617d,$e4ba       0.005950425498 */
.balign 2,0
M102_dc_anchor_778:
.word 0x07f9
.word 0x617d
.word 0xe4ba
/* QL:         dc.w    1 */
.balign 2,0
M102_dc_anchor_784:
.word 1
/* QL:         dc.w    $07ed,$5fdf,$473e       corrector 1.42860682e-6 */
.balign 2,0
M102_dc_anchor_788:
.word 0x07ed
.word 0x5fdf
.word 0x473e
/* QL:         dc.w    $0800,$58b9,$0000       near ln(2) .69314575 */
.balign 2,0
M102_dc_anchor_794:
.word 0x0800
.word 0x58b9
.word 0x0000
/* QL:         dc.w    $0801,$5c55,$1d95       1/ln(2) 1.44269504 */
.balign 2,0
M102_dc_anchor_800:
.word 0x0801
.word 0x5c55
.word 0x1d95
/* QL:         dc.w    $80b                    silly range (under/overflow certain) */
.balign 2,0
M102_dc_anchor_806:
.word 0x80b
/* QL: M102_exp_tab */
M102_exp_tab:
/* QL: * Log tables */
/* QL:         dc.w    $0803,$a6bc,$eee1       -5.5788737502 */
.balign 2,0
M102_dc_anchor_813:
.word 0x0803
.word 0xa6bc
.word 0xeee1
/* QL:         dc.w    $0801,$4000,$0000       1.0 */
.balign 2,0
M102_dc_anchor_819:
.word 0x0801
.word 0x4000
.word 0x0000
/* QL:         dc.w    1 */
.balign 2,0
M102_dc_anchor_825:
.word 1
/* QL:         dc.w    $07ff,$88fb,$e7c1       -0.4649062303 */
.balign 2,0
M102_dc_anchor_829:
.word 0x07ff
.word 0x88fb
.word 0xe7c1
/* QL:         dc.w    $07fa,$6f6b,$44f3       0.01360095469 */
.balign 2,0
M102_dc_anchor_835:
.word 0x07fa
.word 0x6f6b
.word 0x44f3
/* QL:         dc.w    1 */
.balign 2,0
M102_dc_anchor_841:
.word 1
/* QL: M102_log_tab */
M102_log_tab:
/* QL: * Arctangent tables */
/* QL:         dc.w    $0803,$451f,$bedf       4.3202503892 */
.balign 2,0
M102_dc_anchor_848:
.word 0x0803
.word 0x451f
.word 0xbedf
/* QL:         dc.w    $0803,$4c09,$1df8       4.7522258460 */
.balign 2,0
M102_dc_anchor_854:
.word 0x0803
.word 0x4c09
.word 0x1df8
/* QL:         dc.w    $0801,$4000,$0000       1.0 */
.balign 2,0
M102_dc_anchor_860:
.word 0x0801
.word 0x4000
.word 0x0000
/* QL:         dc.w    2 */
.balign 2,0
M102_dc_anchor_866:
.word 2
/* QL:         dc.w    $0000,$0000,$0000       0.0 */
.balign 2,0
M102_dc_anchor_870:
.word 0x0000
.word 0x0000
.word 0x0000
/* QL:         dc.w    $0801,$a3d5,$ac3b       -1.4400834487 */
.balign 2,0
M102_dc_anchor_876:
.word 0x0801
.word 0xa3d5
.word 0xac3b
/* QL:         dc.w    $0800,$a3d6,$2904       -0.7200268489 */
.balign 2,0
M102_dc_anchor_882:
.word 0x0800
.word 0xa3d6
.word 0x2904
/* QL:         dc.w    2 */
.balign 2,0
M102_dc_anchor_888:
.word 2
/* QL: M102_atn_tab */
M102_atn_tab:
/* QL: * Tangent tables */
/* QL:         dc.w    $0801,$4000,$0000       1.0 */
.balign 2,0
M102_dc_anchor_895:
.word 0x0801
.word 0x4000
.word 0x0000
/* QL:         dc.w    $07ff,$8e28,$7bc1       -0.44469477203 */
.balign 2,0
M102_dc_anchor_901:
.word 0x07ff
.word 0x8e28
.word 0x7bc1
/* QL:         dc.w    $07fb,$416d,$50cd       0.01597339213 */
.balign 2,0
M102_dc_anchor_907:
.word 0x07fb
.word 0x416d
.word 0x50cd
/* QL:         dc.w    2 */
.balign 2,0
M102_dc_anchor_913:
.word 2
/* QL:         dc.w    $0000,$0000,$0000       0.0 */
.balign 2,0
M102_dc_anchor_917:
.word 0x0000
.word 0x0000
.word 0x0000
/* QL:         dc.w    $07fd,$8df7,$443e       -0.11136144036 */
.balign 2,0
M102_dc_anchor_923:
.word 0x07fd
.word 0x8df7
.word 0x443e
/* QL:         dc.w    $07f7,$4676,$1a70       0.001075154738 */
.balign 2,0
M102_dc_anchor_929:
.word 0x07f7
.word 0x4676
.word 0x1a70
/* QL:         dc.w    2 */
.balign 2,0
M102_dc_anchor_935:
.word 2
/* QL: M102_tan_tab */
M102_tan_tab:
/* QL: * Sine/cosine table */
/* QL:         dc.w    $0000,$0000,$0000       0.0 */
.balign 2,0
M102_dc_anchor_942:
.word 0x0000
.word 0x0000
.word 0x0000
/* QL:         dc.w    $07fe,$aaaa,$aab0       -0.16666666609 */
.balign 2,0
M102_dc_anchor_948:
.word 0x07fe
.word 0xaaaa
.word 0xaab0
/* QL:         dc.w    $07fa,$4444,$42dd       0.8333330721e-2 */
.balign 2,0
M102_dc_anchor_954:
.word 0x07fa
.word 0x4444
.word 0x42dd
/* QL:         dc.w    $07f4,$97fa,$15c1       -0.1984083282e-3 */
.balign 2,0
M102_dc_anchor_960:
.word 0x07f4
.word 0x97fa
.word 0x15c1
/* QL:         dc.w    $07ee,$5c5a,$e940       0.2752397107e-5 */
.balign 2,0
M102_dc_anchor_966:
.word 0x07ee
.word 0x5c5a
.word 0xe940
/* QL:         dc.w    $07e7,$997c,$79c0       -0.2386834641e-7 */
.balign 2,0
M102_dc_anchor_972:
.word 0x07e7
.word 0x997c
.word 0x79c0
/* QL:         dc.w    5 */
.balign 2,0
M102_dc_anchor_978:
.word 5
/* QL:         dc.w    $07f0,$b544,$42d2       corrector -8.9089102e-6 */
.balign 2,0
M102_dc_anchor_982:
.word 0x07f0
.word 0xb544
.word 0x42d2
/* QL:         dc.w    $0802,$6488,$0000       near pi 3.14160156 */
.balign 2,0
M102_dc_anchor_988:
.word 0x0802
.word 0x6488
.word 0x0000
/* QL:         dc.w    $07ff,$517c,$c1b7       1/pi .31830989 */
.balign 2,0
M102_dc_anchor_994:
.word 0x07ff
.word 0x517c
.word 0xc1b7
/* QL:         dc.w    $81f                    silly range (all accuracy lost) */
.balign 2,0
M102_dc_anchor_1000:
.word 0x81f
/* QL: M102_sin_tab */
M102_sin_tab:
/* QL:         end */
