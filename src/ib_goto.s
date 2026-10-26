/* ROM section ib_goto */
.balign 2,0
/* QL: ib_goto */
ib_goto:
/* QL:         moveq   #1,d4           only one linenumber required */
    moveq #1,d4
/* QL:         bra.s   M167_get_key */
    bra.s M167_get_key
/* QL: ib_ongo */
ib_ongo:
/* QL:         bsr.s   M167_read_exp        get control value */
    bsr.s M167_read_exp
/* QL:         ble.s   M167_err_or          selector not allowed to be -ve or 0 */
    ble.s M167_err_or
/* QL:         addq.l  #2,a4           skip the go */
    addq.l #2,a4
/* QL: M167_get_key */
M167_get_key:
/* QL:         jsr     ib_nxnon(pc)    get a non-space, it will be a keyword */
    jsr ib_nxnon(pc)
/* QL:         move.b  d1,d5           save to or sub */
    move.b d1,d5
/* QL: M167_get_exp */
M167_get_exp:
/* QL:         subq.w  #1,d4           are we at the wanted expression yet? */
    subq.w #1,d4
/* QL:         beq.s   M167_get_lno         yes, go get the line number */
    beq.s M167_get_lno
/* QL:         jsr     ib_nxcom(pc)    skip optional expression to get to next comma */
    jsr ib_nxcom(pc)
/* QL:         bne.s   M167_get_exp         found a comma, so keep going */
    bne.s M167_get_exp
/* QL: M167_err_or */
M167_err_or:
/* QL:         subq.l  #4,sp */
    subq.l #4,sp
/* QL: M167_err_nul */
M167_err_nul:
/* QL:         moveq   #M167_err.or,d0 */
    moveq #M167_err.or,d0
/* QL: M167_popret */
M167_popret:
/* QL:         addq.l  #4,sp           don't bother with immediate return */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: M167_read_exp */
M167_read_exp:
/* QL:         move.l  a4,a0           start of expression */
    move.l a4,a0
/* QL:         jsr     ca_evali(pc)    get line number!!! */
    jsr ca_evali(pc)
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         blt.s   M167_popret */
    blt.s M167_popret
/* QL:         beq.s   M167_err_nul         this was a null (we could allow omitted slots) */
    beq.s M167_err_nul
/* QL:         addq.l  #2,M167_bv_rip(a6) */
    addq.l #2,M167_bv_rip(a6)
/* QL:         move.w  0(a6,a1.l),d4 */
    move.w 0(a6,a1.l),d4
/* QL:         rts */
    rts 
/* QL: M167_get_lno */
M167_get_lno:
/* QL:         addq.l  #2,a4           skip to/sub or comma */
    addq.l #2,a4
/* QL:         bsr.s   M167_read_exp        read the line number */
    bsr.s M167_read_exp
/* QL:         assert  0,(M167_b.keyto&1)-1,M167_b.sub&1 */
/* original assertion: 0,(M167_b.keyto&1)-1,M167_b.sub&1 */
/* QL:         lsl.b   #7,d5           is this sub ? (and if so, set d5.b=0) */
    lsl.b #7,d5
/* QL:         bne.s   M167_clinl */
    bne.s M167_clinl
/* QL:         jsr     ib_call(pc)     yes - go do rt setup for this */
    jsr ib_call(pc)
/* QL: M167_clinl */
M167_clinl:
/* QL:         sf      M167_bv_inlin(a6)    inline flag no longer applies */
    sf M167_bv_inlin(a6)
/* QL:         tst.b   M167_bv_sing(a6)     has user typed go to/sub n as a command? */
    tst.b M167_bv_sing(a6)
/* QL:         beq.s   M167_golin           no, so all is ok */
    beq.s M167_golin
/* QL:         jsr     ib_stbas(pc)    position at first line in program */
    jsr ib_stbas(pc)
/* QL:         bne.s   M167_okrts           isn't one */
    bne.s M167_okrts
/* QL: M167_golin */
M167_golin:
/* QL:         jsr     ib_golin(pc)    move to line */
    jsr ib_golin(pc)
/* QL:         subq.l  #2,a4           move back over previous line feed */
    subq.l #2,a4
/* QL: M167_okrts */
M167_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL:         end */
