/* ROM section ib_chinl */
.balign 2,0
/* QL: * a4 -ip - position in program file */
/* QL: * d0 -  o- inline (0) or not (-ve) */
/* QL: * d1 destroyed */
/* QL: ib_chinl */
ib_chinl:
/* QL:         move.l  a4,-(sp)        save what we're going back with */
    move.l a4,-(sp)
/* QL:         jsr     ib_eos(pc)      get end of current statement */
    jsr ib_eos(pc)
/* QL: M163_test */
M163_test:
/* QL:         tst.b   d0              are we at line feed? */
    tst.b d0
/* QL:         blt.s   M163_popret          -lf, not an i/l clause then */
    blt.s M163_popret
/* QL:         jsr     ib_s2non(pc)    skip col/then/else and get next non-space */
    jsr ib_s2non(pc)
/* QL:         move.l  a4,d1           save this position */
    move.l a4,d1
/* QL:         jsr     ib_eos(pc)      and get the end of the statement */
    jsr ib_eos(pc)
/* QL:         cmp.l   a4,d1           (-lf), was the statement empty? */
    cmp.l a4,d1
/* QL:         beq.s   M163_test            no, therefore this is an i/l clause */
    beq.s M163_test
/* QL:         moveq   #0,d0           set yes flag */
    moveq #0,d0
/* QL: M163_popret */
M163_popret:
/* QL:         move.l  (sp)+,a4        restore the register */
    move.l (sp)+,a4
/* QL:         rts */
    rts 
/* QL:         end */
