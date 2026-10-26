/* ROM section ib_def */
.balign 2,0
/* QL: * d2 -il - which end to look for */
/* QL: * Have to put in something to deal with DEF FN f(x)=x+1 */
/* QL: ib_def */
ib_def:
/* QL:         moveq   #M162_b.def,d2 */
    moveq #M162_b.def,d2
/* QL: ib_def1 */
ib_def1:
/* QL:         jsr     ib_nxst(pc)     get start of next statement */
    jsr ib_nxst(pc)
/* QL:         bne.s   M162_okrts           end of program */
    bne.s M162_okrts
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   #M162_w.end,d1       keep looking for an END */
    cmp.w #M162_w.end,d1
/* QL:         bne.s   ib_def1 */
    bne.s ib_def1
/* QL:         jsr     ib_s2non(pc) */
    jsr ib_s2non(pc)
/* QL:         cmp.b   d2,d1           ENDDEF (or ENDWHEN) */
    cmp.b d2,d1
/* QL:         bne.s   ib_def1 */
    bne.s ib_def1
/* QL: M162_okrts */
M162_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL:         end */
