/* ROM section ib_proc */
.balign 2,0
/* QL: * d0 -  o- error code */
/* QL: * d2 -  o- error code */
/* QL: * a1 -  o- M161_bv_rip */
/* QL: * a2 -i  - name table entry */
/* QL: * a4 -i o- program pointer to next token after proc name, updated to eos */
/* QL: * d1/d3-d6/a0/a3/a5 destroyed */
/* QL: ib_proc */
ib_proc:
/* QL:         move.l  4(a6,a2.l),d5   just want absolute address of procedure */
    move.l 4(a6,a2.l),d5
/* QL: M161_nextgo */
M161_nextgo:
/* QL:         sf      M161_bv_undo(a6)     turn undo off */
    sf M161_bv_undo(a6)
/* QL:         move.l  a4,a0           put prog pointer in a0 */
    move.l a4,a0
/* QL:         assert  M161_bv_ntbas,M161_bv_ntp-4 */
/* original assertion: M161_bv_ntbas,M161_bv_ntp-4 */
/* QL:         movem.l M161_bv_ntbas(a6),d6/a3 */
    movem.l M161_bv_ntbas(a6),d6/a3
/* QL:         sub.l   d6,a3           offset of base of args */
    sub.l d6,a3
/* QL:         sub.l   a4,d6           program pointer offset, in case of M161_redo */
    sub.l a4,d6
/* QL:         jsr     ca_garg(pc)     get the arguments (only touches d0-d1/a0-a1/a5) */
    jsr ca_garg(pc)
/* QL:         move.l  M161_bv_ntbas(a6),a4 may have moved */
    move.l M161_bv_ntbas(a6),a4
/* QL:         bne.s   M161_carg            wrong */
    bne.s M161_carg
/* QL:         jsr     ib_cheos(pc)    check that d1 is an end of statement */
    jsr ib_cheos(pc)
/* QL:         bne.s   M161_err_bp */
    bne.s M161_err_bp
/* QL:         sub.l   a4,a5           top of args offset */
    sub.l a4,a5
/* QL:         sub.l   a4,a0           program offset */
    sub.l a4,a0
/* QL:         move.l  M161_bv_rip(a6),a1 */
    move.l M161_bv_rip(a6),a1
/* QL:         sub.l   M161_bv_ribas(a6),a1 ri offset */
    sub.l M161_bv_ribas(a6),a1
/* QL:         movem.l d5-d7/a0-a1/a3/a5,-(sp) don't want to lose our place, do we? */
    movem.l d5-d7/a0-a1/a3/a5,-(sp)
/* QL:         moveq   #0,d7           absolute guarantee of zero in d7 */
    moveq #0,d7
/* QL:         add.l   a4,a3 */
    add.l a4,a3
/* QL:         add.l   a4,a5 */
    add.l a4,a5
/* QL:         assert  M161_bv_linum,M161_bv_lengt-2 */
/* original assertion: M161_bv_linum,M161_bv_lengt-2 */
/* QL:         move.l  M161_bv_linum(a6),-(sp) */
    move.l M161_bv_linum(a6),-(sp)
/* QL:         move.b  M161_bv_stmnt(a6),-(sp) */
    move.b M161_bv_stmnt(a6),-(sp)
/* QL:         assert  M161_bv_inlin,M161_bv_sing-1,M161_bv_index-2 */
/* original assertion: M161_bv_inlin,M161_bv_sing-1,M161_bv_index-2 */
/* QL:         move.l  M161_bv_inlin(a6),-(sp) */
    move.l M161_bv_inlin(a6),-(sp)
/* QL:         move.l  d5,a2 */
    move.l d5,a2
/* QL:         jsr     (a2)            do the relevent mc proc */
    jsr (a2)
/* QL: * The stack looks like this to the called code: */
/* QL: *       $00 l return address */
/* QL: *       $04 b M161_bv_inlin */
/* QL: *       $05 b M161_bv_sing */
/* QL: *       $06 w M161_bv_index */
/* QL: *       $08 b M161_bv_stmnt */
/* QL: *       $09 b junk */
/* QL: *       $0a w M161_bv_linum */
/* QL: *       $0c w M161_bv_lengt */
/* QL: *       $0e l (d5) m/c code address, in case of a M161_redo */
/* QL: *       $12 l (d6) prog offset from M161_bv_ntbas, before garg, for M161_redo (positive) */
/* QL: *       $16 l (d7) data register (always zero, wasting space on here!) */
/* QL: *       $1a l (a0) current program offset down from M161_bv_ntbas (negative) */
/* QL: *       $1e l (a1) ri stack offset down from M161_bv_ribas (negative) */
/* QL: *       $22 l (a3-ntbas) offset to top of args up from M161_bv_ntbas */
/* QL: *       $26 l (a5-ntbas) offset to bottom of args up from M161_bv_ntbas */
/* QL: * I have stopped saving d5-d6 in to get space for undo stuff, swapped the */
/* QL: * current prog offset with the ri offset and changed registers on the call. */
/* QL: * Previously, a0 had a copy of nt_bas and a4 was the current prog offset. */
/* QL: * With luck, no one will have expected particular register values, other than */
/* QL: * d0/d7/a3/a5, and no further exploration up the stack! */
/* QL: * N.B. Beware! Qload and Qlrun zero out the two arg ptrs above by referencing */
/* QL: * them as $22(sp) and $26(sp). Qload also expects msw d6 zero!!!! (lwr) */
/* QL:         move.l  (sp)+,M161_bv_inlin(a6) */
    move.l (sp)+,M161_bv_inlin(a6)
/* QL:         move.b  (sp)+,M161_bv_stmnt(a6) */
    move.b (sp)+,M161_bv_stmnt(a6)
/* QL:         move.l  (sp)+,M161_bv_linum(a6) */
    move.l (sp)+,M161_bv_linum(a6)
/* QL:         movem.l (sp)+,d5-d7/a0-a1/a3/a5 now then, where were we? */
    movem.l (sp)+,d5-d7/a0-a1/a3/a5
/* QL:         add.l   M161_bv_ribas(a6),a1 */
    add.l M161_bv_ribas(a6),a1
/* QL:         move.l  a1,M161_bv_rip(a6)   restore ri pointer */
    move.l a1,M161_bv_rip(a6)
/* QL:         move.l  M161_bv_ntbas(a6),a4 */
    move.l M161_bv_ntbas(a6),a4
/* QL:         add.l   a4,a0           restore position in program */
    add.l a4,a0
/* QL:         add.l   a4,a5           top of args on nt */
    add.l a4,a5
/* QL:         bsr.s   M161_carg */
    bsr.s M161_carg
/* QL:         tst.b   M161_bv_undo(a6)     um, must we undo the return stack first? */
    tst.b M161_bv_undo(a6)
/* QL:         bne.s   M161_redo            yes, go see to it */
    bne.s M161_redo
/* QL:         rts */
    rts 
/* QL: M161_err_bp */
M161_err_bp:
/* QL:         moveq   #M161_err.bp,d0 */
    moveq #M161_err.bp,d0
/* QL: M161_carg */
M161_carg:
/* QL:         sub.l   a4,d6           prog pointer for M161_redo (negated) */
    sub.l a4,d6
/* QL:         add.l   a4,a3           bottom of args on nt */
    add.l a4,a3
/* QL:         move.l  a0,a4           prog pointer back into correct register */
    move.l a0,a4
/* QL:         jmp     ca_carg(pc)     clear out the arguments */
    jmp ca_carg(pc)
/* QL: M161_redo */
M161_redo:
/* QL:         neg.l   d6              un-negate saved program pointer */
    neg.l d6
/* QL:         move.l  d6,a4           put back the saved program pointer */
    move.l d6,a4
/* QL:         move.l  a4,-(sp)           \ */
    move.l a4,-(sp)
/* QL:         move.l  d5,-(sp)            \ */
    move.l d5,-(sp)
/* QL:         move.l  M161_bv_linum(a6),-(sp)   > save full current context */
    move.l M161_bv_linum(a6),-(sp)
/* QL:         move.b  M161_bv_stmnt(a6),-(sp)  / */
    move.b M161_bv_stmnt(a6),-(sp)
/* QL:         move.l  M161_bv_inlin(a6),-(sp) / */
    move.l M161_bv_inlin(a6),-(sp)
/* QL:         moveq   #7*4+2,d1       tell unret how deep the stack is */
    moveq #((7*4)+2),d1
/* QL:         jsr     ib_unret(pc)    go unravel everything */
    jsr ib_unret(pc)
/* QL:         move.l  (sp)+,M161_bv_inlin(a6) */
    move.l (sp)+,M161_bv_inlin(a6)
/* QL:         move.b  (sp)+,M161_bv_stmnt(a6) */
    move.b (sp)+,M161_bv_stmnt(a6)
/* QL:         move.l  (sp)+,M161_bv_linum(a6) */
    move.l (sp)+,M161_bv_linum(a6)
/* QL:         move.l  (sp)+,d5 */
    move.l (sp)+,d5
/* QL:         move.l  (sp)+,a4 */
    move.l (sp)+,a4
/* QL:         bra.l   M161_nextgo */
    bra.w M161_nextgo
/* QL:         end */
