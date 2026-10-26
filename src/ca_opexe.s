/* ROM section ca_opexe */
.balign 2,0
/* QL: * Primary operator table... sorts out major decisions */
/* QL: M88_optab1 */
M88_optab1:
/* QL:  dc.w M88_i_asm-M88_e,M88_i_asm-M88_e,M88_i_asm-M88_e,M88_fp2-M88_e     + - * (i/i) / (M88_f/M88_f) */
.balign 2,0
M88_dc_anchor_1087:
.word ((M88_i_asm-M88_e))&65535
.word ((M88_i_asm-M88_e))&65535
.word ((M88_i_asm-M88_e))&65535
.word ((M88_fp2-M88_e))&65535
/* QL:  dc.w M88_c-M88_e,M88_c-M88_e,M88_c-M88_e,M88_c-M88_e,M88_c-M88_e,M88_c-M88_e,M88_c-M88_e       >= > == = <> <= < (i/i or s/s) */
.balign 2,0
M88_dc_anchor_1094:
.word ((M88_c-M88_e))&65535
.word ((M88_c-M88_e))&65535
.word ((M88_c-M88_e))&65535
.word ((M88_c-M88_e))&65535
.word ((M88_c-M88_e))&65535
.word ((M88_c-M88_e))&65535
.word ((M88_c-M88_e))&65535
/* QL:  dc.w M88_b_dyad-M88_e,M88_b_dyad-M88_e,M88_b_dyad-M88_e        || && ^^ (i/i) */
.balign 2,0
M88_dc_anchor_1104:
.word ((M88_b_dyad-M88_e))&65535
.word ((M88_b_dyad-M88_e))&65535
.word ((M88_b_dyad-M88_e))&65535
/* QL:  dc.w M88_exp-M88_e,M88_str2-M88_e                      ^ (M88_f/i) & (s/s) */
.balign 2,0
M88_dc_anchor_1110:
.word ((M88_exp-M88_e))&65535
.word ((M88_str2-M88_e))&65535
/* QL:  dc.w M88_l_dyad-M88_e,M88_l_dyad-M88_e,M88_l_dyad-M88_e        or and xor (i/i) */
.balign 2,0
M88_dc_anchor_1115:
.word ((M88_l_dyad-M88_e))&65535
.word ((M88_l_dyad-M88_e))&65535
.word ((M88_l_dyad-M88_e))&65535
/* QL:  dc.w M88_int2-M88_e,M88_int2-M88_e,M88_str2-M88_e              mod div (i/i) instr (s/s) */
.balign 2,0
M88_dc_anchor_1121:
.word ((M88_int2-M88_e))&65535
.word ((M88_int2-M88_e))&65535
.word ((M88_str2-M88_e))&65535
/* QL: * Monadics */
/* QL:  dc.w M88_i_minus-M88_e,M88_i_plus-M88_e,M88_b_not-M88_e,M88_l_not-M88_e - (i) + (n) ~~ not (i) (monadic ops) */
.balign 2,0
M88_dc_anchor_1128:
.word ((M88_i_minus-M88_e))&65535
.word ((M88_i_plus-M88_e))&65535
.word ((M88_b_not-M88_e))&65535
.word ((M88_l_not-M88_e))&65535
/* QL: * Secondary operator table... catches all the fp/fp stuff we had trouble with */
/* QL: M88_optab2 */
M88_optab2:
/* QL:  dc.w ri_add-M88_e,ri_sub-M88_e,ri_mult-M88_e,ri_div-M88_e      + - * / */
.balign 2,0
M88_dc_anchor_1138:
.word ((ri_add-M88_e))&65535
.word ((ri_sub-M88_e))&65535
.word ((ri_mult-M88_e))&65535
.word ((ri_div-M88_e))&65535
/* QL:  dc.w M88_f-M88_e,M88_f-M88_e,M88_f-M88_e,M88_f-M88_e,M88_f-M88_e,M88_f-M88_e,M88_f-M88_e               >= > == = <> <= < */
.balign 2,0
M88_dc_anchor_1145:
.word ((M88_f-M88_e))&65535
.word ((M88_f-M88_e))&65535
.word ((M88_f-M88_e))&65535
.word ((M88_f-M88_e))&65535
.word ((M88_f-M88_e))&65535
.word ((M88_f-M88_e))&65535
.word ((M88_f-M88_e))&65535
/* QL:  dc.w ri_powfp-M88_e                                ^ (adjusted to save waste) */
.balign 2,0
M88_dc_anchor_1155:
.word ((ri_powfp-M88_e))&65535
/* QL: * d0 -  o- error code (not neccesarily in condition codes) */
/* QL: * d4 -i  - operation code in lsb - must not touch msw */
/* QL: * a1 -i o- arithmetic stack pointer (must be stored by calling routine) */
/* QL: * a5 -i o- name table pointer (updated properly here) */
/* QL: * d1-d3 destroyed */
/* QL: * Care must be taken that the exit from this module ensures that the data types */
/* QL: * recorded in the top NT entries always match the data on the RI stack. */
/* QL: * If a dyadic operation removes it's second operand, a5 must be decremented by */
/* QL: * eight and stored in bv_ntp. The returned value of a1 must be stored in M88_bv_rip */
/* QL: * by the calling routine (ca_eval). */
/* QL: * These rules must be followed even on exit with a non-error code, when */
/* QL: * unraveling the table/stack is particularly sensitive! */
/* QL: ca_opexe */
ca_opexe:
/* QL:         moveq   #15,d2 */
    moveq #15,d2
/* QL:         and.b   -7(a6,a5.l),d2  mask any separator which may be here */
    and.b (-7)(a6,a5.l),d2
/* QL:         move.b  d2,-7(a6,a5.l)  store the masked type */
    move.b d2,(-7)(a6,a5.l)
/* QL:         clr.w   d1 */
    clr.w d1
/* QL: M88_jmp2 */
M88_jmp2:
/* QL:         moveq   #0,d0           assume we'll have no errors */
    moveq #0,d0
/* QL:         add.b   d4,d1 */
    add.b d4,d1
/* QL:         add.w   d1,d1 */
    add.w d1,d1
/* QL:         move.w  M88_optab1-2(pc,d1.w),d1 what might we do for this operation? */
    move.w (M88_optab1-2)(pc,d1.w),d1
/* QL:         subq.b  #M88_t.fp,d2        set up condition code for the 2nd operand type */
    subq.b #M88_t.fp,d2
/* QL:         jmp     M88_e(pc,d1.w)      go do something */
.word 0x4efb
.word 4096|((M88_e-.)&255)
/* QL: M88_i_asm */
M88_i_asm:
/* QL:         ble.s   M88_fp2             not an integer, so we'll have to do fp/fp */
    ble.s M88_fp2
/* QL:         bsr.s   M88_try1st          what's the 1st operand type? */
    bsr.s M88_try1st
/* QL:         ble.s   M88_fp2             not integer, so must do fp/fp again */
    ble.s M88_fp2
/* QL:         bsr.l   M88_drop2           we're definately happy... */
    bsr.w M88_drop2
/* QL:         move.w  -2(a6,a1.l),d1 */
    move.w (-2)(a6,a1.l),d1
/* QL:         subq.b  #M88_b.dif,d4       which of +, - or * is it? */
    subq.b #M88_b.dif,d4
/* QL:         bgt.s   M88_i_mul */
    bgt.s M88_i_mul
/* QL:         beq.s   M88_i_sub */
    beq.s M88_i_sub
/* QL:         add.w   d1,0(a6,a1.l) */
    add.w d1,0(a6,a1.l)
/* QL:         bvs.s   M88_i_ext           ouch! have to extend answer into fp */
    bvs.s M88_i_ext
/* QL: M88_doneit */
M88_doneit:
/* QL:         rts */
    rts 
/* QL: M88_i_sub */
M88_i_sub:
/* QL:         sub.w   d1,0(a6,a1.l) */
    sub.w d1,0(a6,a1.l)
/* QL:         bvc.s   M88_doneit          nice! */
    bvc.s M88_doneit
/* QL:         scc     d3 */
    scc d3
/* QL:         add.b   d3,d3           invert the extend bit */
    add.b d3,d3
/* QL: M88_i_ext */
M88_i_ext:
/* QL:         move.w  0(a6,a1.l),d3   get the bulk of the answer */
    move.w 0(a6,a1.l),d3
/* QL:         swap    d3 */
    swap d3
/* QL:         roxr.l  #1,d3           roll in the extend bit */
    roxr.l #1,d3
/* QL:         subq.l  #4,a1 */
    subq.l #4,a1
/* QL:         move.w  #$810,0(a6,a1.l) */
    move.w #0x810,0(a6,a1.l)
/* QL:         move.l  d3,2(a6,a1.l) */
    move.l d3,2(a6,a1.l)
/* QL: M88_make_fp */
M88_make_fp:
/* QL:         subq.b  #M88_t.int-M88_t.fp,-7(a6,a5.l)  change type from int to fp */
    subq.b #(M88_t.int-M88_t.fp),(-7)(a6,a5.l)
/* QL:         rts */
    rts 
/* QL: M88_i_mul */
M88_i_mul:
/* QL:         muls    0(a6,a1.l),d1 */
    muls 0(a6,a1.l),d1
/* QL:         move.w  d1,0(a6,a1.l)   store lsw, and hope it's ok... */
    move.w d1,0(a6,a1.l)
/* QL:         move.w  d1,d2 */
    move.w d1,d2
/* QL:         ext.l   d2 */
    ext.l d2
/* QL:         cmp.l   d2,d1           did the result still fit into a short integer? */
    cmp.l d2,d1
/* QL:         beq.s   M88_anrts           hurrah! */
    beq.s M88_anrts
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL:         jsr     ri_fllin(pc)    go float it */
    jsr ri_fllin(pc)
/* QL:         bra.s   M88_make_fp         change it to fp */
    bra.s M88_make_fp
/* QL: M88_try1st */
M88_try1st:
/* QL:         moveq   #15,d3 */
    moveq #15,d3
/* QL:         and.b   -15(a6,a5.l),d3 what's the 1st operand type? */
    and.b (-15)(a6,a5.l),d3
/* QL:         move.b  d3,-15(a6,a5.l) */
    move.b d3,(-15)(a6,a5.l)
/* QL:         subq.b  #M88_t.fp,d3 */
    subq.b #M88_t.fp,d3
/* QL:         rts */
    rts 
/* QL: M88_e */
M88_e:
/* QL: M88_fp2x */
M88_fp2x:
/* QL:         subq.w  #3,d4           adjust opcode to save 3 words in table for pow */
    subq.w #3,d4
/* QL: M88_fp2 */
M88_fp2:
/* QL:         bsr.s   M88_cnvrtf          convert 2nd operand to float */
    bsr.s M88_cnvrtf
/* QL:         bne.s   M88_anrts           nasty - it didn't work! */
    bne.s M88_anrts
/* QL:         bsr.s   M88_drop6           that's taken care of */
    bsr.s M88_drop6
/* QL:         move.l  -4(a6,a1.l),-(sp) */
    move.l (-4)(a6,a1.l),-(sp)
/* QL:         move.w  -6(a6,a1.l),-(sp) save 2nd operand */
    move.w (-6)(a6,a1.l),-(sp)
/* QL:         bsr.s   M88_cnvrtf          convert 1st operand to float */
    bsr.s M88_cnvrtf
/* QL:         bne.s   M88_ohdear6 */
    bne.s M88_ohdear6
/* QL:         subq.l  #6,a1           space down the stack */
    subq.l #6,a1
/* QL:         move.w  (sp)+,0(a6,a1.l) restore 2nd operand */
    move.w (sp)+,0(a6,a1.l)
/* QL:         move.l  (sp)+,2(a6,a1.l) */
    move.l (sp)+,2(a6,a1.l)
/* QL:         moveq   #(M88_optab2-M88_optab1)/2,d1 */
    moveq #((M88_optab2-M88_optab1)/2),d1
/* QL:         bra.l   M88_jmp2            go do secondary jump table */
    bra.w M88_jmp2
/* QL: M88_ohdear6 */
M88_ohdear6:
/* QL:         addq.l  #6,sp           discard the saved fp */
    addq.l #6,sp
/* QL: M88_anrts */
M88_anrts:
/* QL:         rts */
    rts 
/* QL: M88_exp */
M88_exp:
/* QL:         ble.s   M88_fp2x            2nd operand not integer - do the standard stuff */
    ble.s M88_fp2x
/* QL:         bsr.s   M88_drop2 */
    bsr.s M88_drop2
/* QL:         move.w  -2(a6,a1.l),-(sp) save integer power */
    move.w (-2)(a6,a1.l),-(sp)
/* QL:         bsr.s   M88_cnvrtf          convert 1st operand to float */
    bsr.s M88_cnvrtf
/* QL:         bne.s   M88_ohdear2 */
    bne.s M88_ohdear2
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  (sp)+,0(a6,a1.l) */
    move.w (sp)+,0(a6,a1.l)
/* QL:         jmp     ri_power(pc)    go do integer power */
    jmp ri_power(pc)
/* QL: * Various comparisons */
/* QL: M88_c */
M88_c:
/* QL:         beq.s   M88_fp2             if fp, make both fp */
    beq.s M88_fp2
/* QL:         bmi.l   M88_c_fpstr         if str, go see if both are strings */
    bmi.w M88_c_fpstr
/* QL:         bsr.s   M88_try1st          what's the 1st operand like? */
    bsr.s M88_try1st
/* QL:         ble.s   M88_fp2             if not int, must do fp/fp */
    ble.s M88_fp2
/* QL:         bsr.s   M88_drop2           yipee! we have int/int compare... do it here */
    bsr.s M88_drop2
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL:         move.w  0(a6,a1.l),d1 */
    move.w 0(a6,a1.l),d1
/* QL:         cmp.w   -2(a6,a1.l),d1 */
    cmp.w (-2)(a6,a1.l),d1
/* QL:         bgt.s   M88_c_bit */
    bgt.s M88_c_bit
/* QL:         sne     d0 */
    sne d0
/* QL:         ext.w   d0 */
    ext.w d0
/* QL: M88_c_bit */
M88_c_bit:
/* QL:         clr.w   d1 */
    clr.w d1
/* QL:         dc.w    $093b,M88_patcmp+1-*-2 btst    d4,M88_patcmp+1(pc,d0.w) */
.balign 2,0
M88_dc_anchor_1371:
.word 0x093b
.word ((((M88_patcmp+1)-M88_dc_anchor_1371)-2))&65535
/* QL:         sne     d1 */
    sne d1
/* QL:         neg.b   d1 */
    neg.b d1
/* QL: M88_storeint */
M88_storeint:
/* QL:         move.w  d1,0(a6,a1.l) */
    move.w d1,0(a6,a1.l)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL:         assert  8+M88_b.near-7,8+M88_b.gt-6,8+M88_b.ge-5,8,M88_b.lt-3,M88_b.le-2,M88_b.ne-1,M88_b.eq */
/* original assertion: 8+M88_b.near-7,8+M88_b.gt-6,8+M88_b.ge-5,8,M88_b.lt-3,M88_b.le-2,M88_b.ne-1,M88_b.eq */
/* QL: M88_patcmp  dc.b    %00001110,%10100101,%01100010,0 patterns for <, = and > */
M88_patcmp:
M88_dc_anchor_1390:
.byte (0b00001110)&255
.byte (0b10100101)&255
.byte (0b01100010)&255
.byte (0)&255
/* QL: M88_cnvrtf */
M88_cnvrtf:
/* QL:         moveq   #M88_t.fp,d0 */
    moveq #M88_t.fp,d0
/* QL:         jmp     ca_cnvrt(pc) */
    jmp ca_cnvrt(pc)
/* QL: M88_drop6 */
M88_drop6:
/* QL:         addq.l  #4,a1 */
    addq.l #4,a1
/* QL: M88_drop2 */
M88_drop2:
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL:         move.l  a1,M88_bv_rip(a6) */
    move.l a1,M88_bv_rip(a6)
/* QL: M88_drop */
M88_drop:
/* QL:         subq.l  #8,a5 */
    subq.l #8,a5
/* QL:         move.l  a5,M88_bv_ntp(a6) */
    move.l a5,M88_bv_ntp(a6)
/* QL:         rts */
    rts 
/* QL: M88_int2 */
M88_int2:
/* QL:         moveq   #M88_t.int,d0 */
    moveq #M88_t.int,d0
/* QL:         bsr.s   M88_cnvrt0          convert 2nd operand to int */
    bsr.s M88_cnvrt0
/* QL:         bne.s   M88_aprts */
    bne.s M88_aprts
/* QL:         bsr.s   M88_drop2           that's taken care of */
    bsr.s M88_drop2
/* QL:         move.w  -2(a6,a1.l),-(sp) save 2nd operand */
    move.w (-2)(a6,a1.l),-(sp)
/* QL:         moveq   #M88_t.int,d0 */
    moveq #M88_t.int,d0
/* QL:         bsr.s   M88_cnvrt0          convert 1st operand to int */
    bsr.s M88_cnvrt0
/* QL:         beq.l   M88_div_mod */
    beq.w M88_div_mod
/* QL: M88_ohdear2 */
M88_ohdear2:
/* QL:         addq.l  #2,sp           discard saved 2nd operand */
    addq.l #2,sp
/* QL: M88_aprts */
M88_aprts:
/* QL:         rts */
    rts 
/* QL: M88_cnvrts */
M88_cnvrts:
/* QL:         moveq   #M88_t.str,d0       make operand into a string (can't fail!) */
    moveq #M88_t.str,d0
/* QL: M88_cnvrt0 */
M88_cnvrt0:
/* QL:         jmp     ca_cnvrt(pc) */
    jmp ca_cnvrt(pc)
/* QL: M88_gostr2 */
M88_gostr2:
/* QL:         lsr.b   #2,d4           which of & or instr are we doing? */
    lsr.b #2,d4
/* QL:         bcc.s   M88_gocncat         & is the hard one */
    bcc.s M88_gocncat
/* QL:         movem.l d7/a0,-(sp) */
    movem.l d7/a0,-(sp)
/* QL:         bsr.s   M88_add_a1          step over first string */
    bsr.s M88_add_a1
/* QL:         move.l  a1,d7           remember where it started */
    move.l a1,d7
/* QL:         bsr.s   M88_add_a1_0        step past second string */
    bsr.s M88_add_a1_0
/* QL:         exg     a0,d7           now put a0/a1 strings and d7 = top of stack */
    exg a0,d7
/* QL:         bra.s   M88_istrnow */
    bra.s M88_istrnow
/* QL: M88_gocncat */
M88_gocncat:
/* QL:         pea     ca_cncat(pc) */
    pea ca_cncat(pc)
/* QL: M88_drops */
M88_drops:
/* QL:         bra.s   M88_drop */
    bra.s M88_drop
/* QL: M88_str2 */
M88_str2:
/* QL:         bsr.s   M88_cnvrts          make the 2nd operand into a string */
    bsr.s M88_cnvrts
/* QL:         bsr.l   M88_try1st          what's the 1st parameter like? */
    bsr.w M88_try1st
/* QL:         blt.s   M88_gostr2          phew! already a string, so no need for .... */
    blt.s M88_gostr2
/* QL:         movem.l d7/a0,-(sp)     registers that need to be saved */
    movem.l d7/a0,-(sp)
/* QL:         bsr.s   M88_add_a1          find out where the second operand lives */
    bsr.s M88_add_a1
/* QL:         moveq   #2,d7           length of an int */
    moveq #2,d7
/* QL:         tst.b   d3 */
    tst.b d3
/* QL:         bne.s   M88_cop1wrd */
    bne.s M88_cop1wrd
/* QL:         moveq   #6,d7           length of an fp */
    moveq #6,d7
/* QL:         move.l  2(a6,a0.l),-4(a6,a1.l) copy mantissa */
    move.l 2(a6,a0.l),(-4)(a6,a1.l)
/* QL: M88_cop1wrd */
M88_cop1wrd:
/* QL:         sub.l   d7,a1 */
    sub.l d7,a1
/* QL:         move.w  0(a6,a0.l),0(a6,a1.l) copy exponent or integer */
    move.w 0(a6,a0.l),0(a6,a1.l)
/* QL:         add.l   a0,d7           this is the top of the stack */
    add.l a0,d7
/* QL:         move.l  a1,M88_bv_rip(a6)   say where we are at the moment */
    move.l a1,M88_bv_rip(a6)
/* QL:         move.b  -15(a6,a5.l),-7(a6,a5.l) fudge top entry look like 2nd!!! */
    move.b (-15)(a6,a5.l),(-7)(a6,a5.l)
/* QL:         sub.l   M88_bv_ribas(a6),d7 make it depth of stack, in case it moves */
    sub.l M88_bv_ribas(a6),d7
/* QL:         bsr.s   M88_cnvrts          make the 1st operand into a string (d0.l=0) */
    bsr.s M88_cnvrts
/* QL:         add.l   M88_bv_ribas(a6),d7 add back base of stack */
    add.l M88_bv_ribas(a6),d7
/* QL:         assert  0,M88_b.join&2,M88_b.instr&2-2 */
/* original assertion: 0,M88_b.join&2,M88_b.instr&2-2 */
/* QL:         lsr.b   #2,d4           which of & or instr are we doing? */
    lsr.b #2,d4
/* QL:         bcc.s   M88_gocnc           & is the hard one */
    bcc.s M88_gocnc
/* QL:         bsr.s   M88_add_a1 */
    bsr.s M88_add_a1
/* QL: M88_istrnow */
M88_istrnow:
/* QL:         exg     a0,a1 */
    exg a1,a0
/* QL:         moveq   #1,d0           set for instr */
    moveq #1,d0
/* QL:         jsr     ut_istr(pc) */
    jsr ut_istr(pc)
/* QL:         move.l  d7,a1 */
    move.l d7,a1
/* QL:         movem.l (sp)+,d7/a0 */
    movem.l (sp)+,d7/a0
/* QL:         subq.l  #2,a1           where to put integer result */
    subq.l #2,a1
/* QL:         bsr.s   M88_drops */
    bsr.s M88_drops
/* QL:         move.b  #M88_t.int,-7(a6,a5.l) */
    move.b #(M88_t.int&255),(-7)(a6,a5.l)
/* QL:         bra.l   M88_storeint */
    bra.w M88_storeint
/* QL: M88_add_a1_0 */
M88_add_a1_0:
/* QL:         move.l  a0,a1 */
    move.l a0,a1
/* QL: M88_add_a1 */
M88_add_a1:
/* QL:         move.w  0(a6,a1.l),d2   length of string now at tos */
    move.w 0(a6,a1.l),d2
/* QL:         lea     2(a1,d2.w),a0   M88_drop length and chars */
    lea 2(a1,d2.w),a0
/* QL:         rol.b   #8,d2           check for odd length */
    rol.b #8,d2
/* QL:         bcc.s   M88_rts9 */
    bcc.s M88_rts9
/* QL:         addq.l  #1,a0           skip pad byte */
    addq.l #1,a0
/* QL: M88_rts9 */
M88_rts9:
/* QL:         rts */
    rts 
/* QL: * d0.l = 0 */
/* QL: M88_gocnc */
M88_gocnc:
/* QL:         bsr.s   M88_drops */
    bsr.s M88_drops
/* QL:         move.b  #M88_t.str,-7(a6,a5.l) */
    move.b #(M88_t.str&255),(-7)(a6,a5.l)
/* QL:         bsr.s   M88_add_a1          now a1 = 1st string, a0 = 2nd string */
    bsr.s M88_add_a1
/* QL:         move.w  d2,d4           save 1st string length */
    move.w d2,d4
/* QL:         move.w  0(a6,a0.l),d1   2nd string length */
    move.w 0(a6,a0.l),d1
/* QL:         add.w   d1,d2           combined length */
    add.w d1,d2
/* QL:         exg     d7,a1 */
    exg d7,a1
/* QL:         exg     a0,a1           source into a1, destination into a0 */
    exg a1,a0
/* QL: * d7/d4 = tos string, a1/d1 = nos string, a0 = all removed, d2 = d1+d4 */
/* QL:         cmp.w   #32765,d2       we won't let it get too huge... */
    cmp.w #32765,d2
/* QL:         bcs.l   M88_cncat */
    bcs.w M88_cncat
/* QL:         moveq   #M88_err.ov,d0      overflow error */
    moveq #M88_err.ov,d0
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL: M88_putlen */
M88_putlen:
/* QL:         lea     -2(a0),a1 */
    lea (-2)(a0),a1
/* QL:         movem.l (sp)+,d7/a0 */
    movem.l (sp)+,d7/a0
/* QL:         move.w  d2,0(a6,a1.l) */
    move.w d2,0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: M88_c_fpstr */
M88_c_fpstr:
/* QL:         bsr.l   M88_try1st          what's the 1st operand like? */
    bsr.w M88_try1st
/* QL:         bge.l   M88_fp2             if not str, must do fp/fp */
    bge.w M88_fp2
/* QL: * We have two strings to compare... so do it */
/* QL:         bsr.l   M88_drop */
    bsr.w M88_drop
/* QL:         cmp.b   #M88_b.near,d4      is it == ? */
    cmp.b #(M88_b.near&255),d4
/* QL:         sne     d0 */
    sne d0
/* QL:         addq.b  #3,d0 */
    addq.b #3,d0
/* QL:         move.l  a0,-(sp) */
    move.l a0,-(sp)
/* QL:         bsr.s   M88_add_a1          a0 is at start of string b */
    bsr.s M88_add_a1
/* QL:         jsr     ut_cstr(pc) */
    jsr ut_cstr(pc)
/* QL:         bsr.s   M88_add_a1_0        a0 is at end of string b */
    bsr.s M88_add_a1_0
/* QL:         lea     -2(a0),a1       a1 is now ready for t or M88_f value */
    lea (-2)(a0),a1
/* QL:         move.l  (sp)+,a0 */
    move.l (sp)+,a0
/* QL:         bra.l   M88_c_bt2 */
    bra.w M88_c_bt2
/* QL: M88_b_dyad */
M88_b_dyad:
/* QL:         moveq   #M88_t.int,d0 */
    moveq #M88_t.int,d0
/* QL:         bra.s   M88_logic */
    bra.s M88_logic
/* QL: M88_l_dyad */
M88_l_dyad:
/* QL:         assert  M88_b.lor-M88_b.bor,M88_b.land-M88_b.band,M88_b.land-M88_b.band */
/* original assertion: M88_b.lor-M88_b.bor,M88_b.land-M88_b.band,M88_b.land-M88_b.band */
/* QL:         subq.b  #M88_b.lor-M88_b.bor,d4 */
.word 20740|((((M88_b.lor-M88_b.bor))&7)<<9)
/* QL:         moveq   #M88_t.log,d0 */
    moveq #M88_t.log,d0
/* QL: M88_logic */
M88_logic:
/* QL:         move.w  d0,-(sp) */
    move.w d0,-(sp)
/* QL:         bsr.s   M88_lcnv */
    bsr.s M88_lcnv
/* QL:         bsr.l   M88_drop2 */
    bsr.w M88_drop2
/* QL:         move.w  (sp),d0 */
    move.w (sp),d0
/* QL:         move.w  -2(a6,a1.l),(sp) */
    move.w (-2)(a6,a1.l),(sp)
/* QL:         bsr.s   M88_lcnv */
    bsr.s M88_lcnv
/* QL:         move.w  (sp)+,d1 */
    move.w (sp)+,d1
/* QL:         assert  0,M88_b.bor&3,M88_b.band&3-1,M88_b.bxor&3-2 */
/* original assertion: 0,M88_b.bor&3,M88_b.band&3-1,M88_b.bxor&3-2 */
/* QL:         asl.b   #7,d4 */
    asl.b #7,d4
/* QL:         bmi.s   M88_l_and */
    bmi.s M88_l_and
/* QL:         bcs.s   M88_l_xor */
    bcs.s M88_l_xor
/* QL:         or.w    d1,0(a6,a1.l) */
    or.w d1,0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: M88_l_and */
M88_l_and:
/* QL:         and.w   d1,0(a6,a1.l) */
    and.w d1,0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: M88_l_xor */
M88_l_xor:
/* QL:         eor.w   d1,0(a6,a1.l) */
    eor.w d1,0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: M88_lcnv */
M88_lcnv:
/* QL:         bsr.s   M88_cnv0 */
    bsr.s M88_cnv0
/* QL:         beq.s   M88_aorts */
    beq.s M88_aorts
/* QL:         addq.l  #6,sp           M88_drop saved word and return address */
    addq.l #6,sp
/* QL:         rts */
    rts 
/* QL: M88_i_minus */
M88_i_minus:
/* QL:         ble.s   M88_f_minus         rats! have to do it in fp */
    ble.s M88_f_minus
/* QL:         neg.w   0(a6,a1.l) */
    neg.w 0(a6,a1.l)
/* QL:         bvc.s   M88_aorts           only $8000 screws up here, and stays! */
    bvc.s M88_aorts
/* QL: M88_f_minus */
M88_f_minus:
/* QL:         bsr.s   M88_cnvf */
    bsr.s M88_cnvf
/* QL:         bne.s   M88_aorts */
    bne.s M88_aorts
/* QL:         jmp     ri_neg(pc) */
    jmp ri_neg(pc)
/* QL: M88_i_plus */
M88_i_plus:
/* QL:         bge.s   M88_aorts           don't bother if it's already numeric */
    bge.s M88_aorts
/* QL: M88_cnvf */
M88_cnvf:
/* QL:         moveq   #M88_t.fp,d0 */
    moveq #M88_t.fp,d0
/* QL: M88_cnv0 */
M88_cnv0:
/* QL:         jmp     ca_cnvrt(pc) */
    jmp ca_cnvrt(pc)
/* QL: M88_b_not */
M88_b_not:
/* QL:         moveq   #M88_t.int,d0 */
    moveq #M88_t.int,d0
/* QL:         bsr.s   M88_cnv0 */
    bsr.s M88_cnv0
/* QL:         bne.s   M88_aorts */
    bne.s M88_aorts
/* QL:         not.w   0(a6,a1.l)      invert all bits */
    not.w 0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: M88_l_not */
M88_l_not:
/* QL:         moveq   #M88_t.log,d0 */
    moveq #M88_t.log,d0
/* QL:         bsr.s   M88_cnv0 */
    bsr.s M88_cnv0
/* QL:         bne.s   M88_aorts */
    bne.s M88_aorts
/* QL:         bchg    d0,1(a6,a1.l)   swap 0 <--> 1 */
    bchg d0,1(a6,a1.l)
/* QL: M88_aorts */
M88_aorts:
/* QL:         rts */
    rts 
/* QL: M88_f */
M88_f:
/* QL:         jsr     ri_cmp(pc) */
    jsr ri_cmp(pc)
/* QL:         addq.l  #4,a1 */
    addq.l #4,a1
/* QL:         cmp.b   #M88_b.near,d4      if op was == ... */
    cmp.b #(M88_b.near&255),d4
/* QL:         beq.s   M88_f_approx        go see to that */
    beq.s M88_f_approx
/* QL:         move.b  -2(a6,a1.l),d0  get msb mantissa, $80 <, 0 = or $40 > */
    move.b (-2)(a6,a1.l),d0
/* QL:         beq.s   M88_c_bt2           zero result is ready */
    beq.s M88_c_bt2
/* QL:         rol.b   #2,d0           that was $40 -> 1, $80 -> 2 */
    rol.b #2,d0
/* QL:         bcs.s   M88_c_bt2           so carry will be set if we've got a good 1 */
    bcs.s M88_c_bt2
/* QL: M88_c_bt1 */
M88_c_bt1:
/* QL:         moveq   #-1,d0          set -1 */
    moveq #(-1),d0
/* QL: M88_c_bt2 */
M88_c_bt2:
/* QL:         move.b  #M88_t.int,-7(a6,a5.l) make into an integer */
    move.b #(M88_t.int&255),(-7)(a6,a5.l)
/* QL:         bra.l   M88_c_bit */
    bra.w M88_c_bit
/* QL: M88_f_approx */
M88_f_approx:
/* QL:         move.b  -4(a6,a1.l),d0  msb exponent is 0 if == is true, 8 otherwise */
    move.b (-4)(a6,a1.l),d0
/* QL:         bne.s   M88_c_bt1 */
    bne.s M88_c_bt1
/* QL:         bra.s   M88_c_bt2 */
    bra.s M88_c_bt2
/* QL: M88_div_mod */
M88_div_mod:
/* QL:         move.w  0(a6,a1.l),d1   get a */
    move.w 0(a6,a1.l),d1
/* QL:         ext.l   d1 */
    ext.l d1
/* QL:         move.w  (sp)+,d0        get b */
    move.w (sp)+,d0
/* QL:         beq.s   M88_dmzero          oops */
    beq.s M88_dmzero
/* QL:         smi     d2              flag if negative, as remainder will need negate */
    smi d2
/* QL:         bpl.s   M88_dmbypos */
    bpl.s M88_dmbypos
/* QL:         neg.l   d1              if b was -ve, negate a and b */
    neg.l d1
/* QL:         neg.w   d0 */
    neg.w d0
/* QL:         bvs.s   M88_dmby32k         sort out div/mod -32768 */
    bvs.s M88_dmby32k
/* QL: M88_dmbypos */
M88_dmbypos:
/* QL:         divs    d0,d1           get a/b */
    divs d0,d1
/* QL:         bvs.s   M88_dmovr           oops (must have been trying to do -32768/-1) */
    bvs.s M88_dmovr
/* QL: M88_dmok */
M88_dmok:
/* QL:         tst.l   d1              has remainder come out negative? */
    tst.l d1
/* QL:         bpl.s   M88_dmrpos          no, that's ok */
    bpl.s M88_dmrpos
/* QL:         swap    d0              (note, msw was zero, as no error at int cnvrt) */
    swap d0
/* QL:         add.l   d0,d1           force remainder to positive */
    add.l d0,d1
/* QL:         subq.w  #1,d1           push quotient down one (can't overflow) */
    subq.w #1,d1
/* QL: M88_dmrpos */
M88_dmrpos:
/* QL:         assert  0,M88_b.idiv&1-1,M88_b.mod&1 */
/* original assertion: 0,M88_b.idiv&1-1,M88_b.mod&1 */
/* QL:         asr.b   #1,d4 */
    asr.b #1,d4
/* QL:         bcs.s   M88_storint2 */
    bcs.s M88_storint2
/* QL:         swap    d1 */
    swap d1
/* QL:         tst.b   d2              was it a negative divisor? */
    tst.b d2
/* QL:         beq.s   M88_storint2        no - leave positive remainder */
    beq.s M88_storint2
/* QL:         neg.w   d1              yes - make remainder negative */
    neg.w d1
/* QL: M88_storint2 */
M88_storint2:
/* QL:         bra.l   M88_storeint */
    bra.w M88_storeint
/* QL: M88_dmby32k */
M88_dmby32k:
/* QL:         add.w   d1,d1           was original a zero or -32768? */
    add.w d1,d1
/* QL:         beq.s   M88_dma32k0         yes, go sort those as special cases */
    beq.s M88_dma32k0
/* QL:         lsr.w   #1,d1           force +ve and mod is ready */
    lsr.w #1,d1
/* QL:         swap    d1              +/-ve div -32768 = -1/0, mod is -a&&32767 */
    swap d1
/* QL:         bra.s   M88_dmrpos */
    bra.s M88_dmrpos
/* QL: M88_dma32k0 */
M88_dma32k0:
/* QL:         addx.b  d1,d1           ahah! 0 = 0/0, -32768 div/mod -32768 = 1/0 */
    addx.b d1,d1
/* QL:         bra.s   M88_dmrpos */
    bra.s M88_dmrpos
/* QL: M88_dmovr */
M88_dmovr:
/* QL:         clr.w   d1              -32768 mod -1 = 0 is a valid answer ... */
    clr.w d1
/* QL:         asr.b   #1,d4           ... but -32768 div -1 = 32768 doesn't fit! */
    asr.b #1,d4
/* QL:         bcc.s   M88_storint2 */
    bcc.s M88_storint2
/* QL: M88_dmzero */
M88_dmzero:
/* QL:         moveq   #M88_err.ov,d0 */
    moveq #M88_err.ov,d0
/* QL:         rts */
    rts 
/* QL: * d0=0, d7/d4 = tos string, a1/d1 = nos string, a0 = all removed, d2 = d1+d4 */
/* QL: M88_cncat */
M88_cncat:
/* QL:         btst    d0,d2           is length going to be odd? */
    btst d0,d2
/* QL:         beq.s   M88_notodd */
    beq.s M88_notodd
/* QL:         subq.l  #1,a0           yes - leave the odd junk byte */
    subq.l #1,a0
/* QL: M88_notodd */
M88_notodd:
/* QL:         bsr.s   M88_copup           copy 2nd operand bytes up the stack */
    bsr.s M88_copup
/* QL:         move.l  d7,a1           get back 1st string */
    move.l d7,a1
/* QL:         move.w  d4,d1           length of 1st string */
    move.w d4,d1
/* QL:         pea     M88_putlen          go back to store length */
    pea M88_putlen(pc)
/* QL: M88_copup */
M88_copup:
/* QL: * The following test needs tuning... the break even point must come somewhere */
/* QL:         add.w   d1,a1           end of source string */
    add.w d1,a1
/* QL:         cmp.w   #64,d1          is it worth getting clever? */
    cmp.w #64,d1
/* QL:         bcs.s   M88_copsent         no - go do slow stuff */
    bcs.s M88_copsent
/* QL:         sub.w   d1,a1           back to start of source string */
    sub.w d1,a1
/* QL:         addq.l  #2,a1           miss out length */
    addq.l #2,a1
/* QL:         sub.w   d1,a0           start of destination area */
    sub.w d1,a0
/* QL:         ext.l   d1              clear msw */
    ext.l d1
/* QL:         jmp     mm_mrtor(pc)    go use the fast copy */
    jmp mm_mrtor(pc)
/* QL: M88_copsl */
M88_copsl:
/* QL:         subq.l  #1,a0 */
    subq.l #1,a0
/* QL:         subq.l  #1,a1 */
    subq.l #1,a1
/* QL:         move.b  2(a6,a1.l),0(a6,a0.l) */
    move.b 2(a6,a1.l),0(a6,a0.l)
/* QL: M88_copsent */
M88_copsent:
/* QL:         dbra    d1,M88_copsl */
    dbra d1,M88_copsl
/* QL:         rts */
    rts 
/* QL:         vect4000 ca_opexe */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ ca$opexe,(ca_opexe-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
