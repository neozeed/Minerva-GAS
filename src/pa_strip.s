/* ROM section pa_strip */
.balign 2,0
/* QL: * N.B. This routine was unsafe for some fp numbers (e.g. 1073776525!) text in */
/* QL: * quotes or remark statements, etc... total rehash by lwr (saves all regs now) */
/* QL: * a6 -ip - basic area */
/* QL: reglist reg     d0-d2/a2-a5 */
/* QL: pa_strip */
pa_strip:
/* QL:         movem.l reglist,-(sp) */
    movem.l d0-d2/a2-a5,-(sp)
/* QL:         assert  M130_bv_tkbas,M130_bv_tkp-4 */
/* original assertion: M130_bv_tkbas,M130_bv_tkp-4 */
/* QL:         movem.l M130_bv_tkbas(a6),a4-a5 start and end of token list */
    movem.l M130_bv_tkbas(a6),a4-a5
/* QL:         move.l  a4,a2           where to store stripped line */
    move.l a4,a2
/* QL:         moveq   #1,d2           flag for start of line */
    moveq #1,d2
/* QL:         bra.s   M130_enter */
    bra.s M130_enter
/* QL: M130_skip */
M130_skip:
/* QL:         sf      d2              no more space skipping */
    sf d2
/* QL:         addq.l  #2,a4           drop forced or single space */
    addq.l #2,a4
/* QL: M130_enter */
M130_enter:
/* QL:         move.w  0(a6,a4.l),d1   pick up M130_next token */
    move.w 0(a6,a4.l),d1
/* QL:         bra.s   M130_loop */
    bra.s M130_loop
/* QL: M130_next */
M130_next:
/* QL:         cmp.w   #M130_w.space,d1     check for a forced space */
    cmp.w #M130_w.space,d1
/* QL:         beq.s   M130_skip            if so, we can scrap it */
    beq.s M130_skip
/* QL:         assert  0,M130_b.spc&127 */
/* original assertion: 0,M130_b.spc&127 */
/* QL:         lsr.w   #7,d1 */
    lsr.w #7,d1
/* QL:         lsr.b   #1,d1 */
    lsr.b #1,d1
/* QL:         bne.s   M130_other */
    bne.s M130_other
/* QL:         neg.b   d2              still at start of line? */
    neg.b d2
/* QL:         bmi.s   M130_skip            yes - leave off leading spaces */
    bmi.s M130_skip
/* QL:         sub.b   d2,1(a6,a4.l) */
    sub.b d2,1(a6,a4.l)
/* QL:         beq.s   M130_skip            M130_skip if no more than a single space */
    beq.s M130_skip
/* QL: M130_other */
M130_other:
/* QL:         cmp.b   #M130_b.lno-M130_b.spc,d1 line no? */
    cmp.b #((M130_b.lno-M130_b.spc)&255),d1
/* QL:         seq     d2 */
    seq d2
/* QL:         subq.b  #M130_b.key-M130_b.spc,d1 keyword? */
.word 20737|((((M130_b.key-M130_b.spc))&7)<<9)
/* QL:         seq     d1 */
    seq d1
/* QL:         or.b    d1,d2           either leaves d2.b=-1 as space flag */
    or.b d1,d2
/* QL: M130_copy */
M130_copy:
/* QL:         move.l  a4,a3           remember where we are */
    move.l a4,a3
/* QL:         jsr     ib_nxtk(pc) */
    jsr ib_nxtk(pc)
/* QL: M130_clp */
M130_clp:
/* QL:         move.w  0(a6,a3.l),0(a6,a2.l) M130_copy down what we just moved past */
    move.w 0(a6,a3.l),0(a6,a2.l)
/* QL:         addq.l  #2,a2 */
    addq.l #2,a2
/* QL:         addq.l  #2,a3 */
    addq.l #2,a3
/* QL:         cmp.l   a4,a3 */
    cmp.l a4,a3
/* QL:         bne.s   M130_clp */
    bne.s M130_clp
/* QL: M130_loop */
M130_loop:
/* QL:         cmp.l   a5,a4           are we finished? */
    cmp.l a5,a4
/* QL:         bcs.s   M130_next            no - try M130_next token */
    bcs.s M130_next
/* QL:         move.l  a2,M130_bv_tkp(a6)   set new end of list */
    move.l a2,M130_bv_tkp(a6)
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d0-d2/a2-a5
/* QL:         rts */
    rts 
/* QL:         vect4000 pa_strip */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ pa$strip,(pa_strip-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
