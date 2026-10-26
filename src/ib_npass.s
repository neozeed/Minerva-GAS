/* ROM section ib_npass */
.balign 2,0
/* QL: * d0-d5/a0/a2 destroyed (did also zap d6... doesn't now) */
/* QL: * ccr not meaningful */
/* QL: * M149_bv_edit used/cleared */
/* QL: * Variable table tidied up, duff values thrown out */
/* QL: * Happens to M149_return d5=0 unless... what was I going to say? */
/* QL: ib_npass */
ib_npass:
/* QL:         move.l  a4,-(sp) */
    move.l a4,-(sp)
/* QL: * Set mask for interesting keywords */
/* QL:         move.l  #1<<M149_b.for!1<<M149_b.rep!1<<M149_b.def!1<<M149_b.else!1<<M149_b.dim!1<<M149_b.let,d4 */
    move.l #((((((1<<M149_b.for)|(1<<M149_b.rep))|(1<<M149_b.def))|(1<<M149_b.else))|(1<<M149_b.dim))|(1<<M149_b.let)),d4
/* QL:         tst.b   M149_bv_sing(a6)     is the single line flag set */
    tst.b M149_bv_sing(a6)
/* QL:         beq.s   M149_doprog          no - skip this bit */
    beq.s M149_doprog
/* QL:         move.l  M149_bv_tkbas(a6),a4 do token list first */
    move.l M149_bv_tkbas(a6),a4
/* QL:         moveq   #0,d5 */
    moveq #0,d5
/* QL:         bsr.s   M149_doline */
    bsr.s M149_doline
/* QL: M149_doprog */
M149_doprog:
/* QL:         tst.b   M149_bv_edit(a6)     has program been edited since last npass? */
    tst.b M149_bv_edit(a6)
/* QL:         sf      M149_bv_edit(a6)     ..clear flag anyway */
    sf M149_bv_edit(a6)
/* QL:         beq.s   M149_return          no change, pointless going thro' it again */
    beq.s M149_return
/* QL:         move.l  M149_bv_pfbas(a6),a4 beg of program file */
    move.l M149_bv_pfbas(a6),a4
/* QL:         bra.s   M149_progent */
    bra.s M149_progent
/* QL: M149_proglp */
M149_proglp:
/* QL:         move.w  -2(a6,a4.l),d5  save linum in case this is a def stat */
    move.w (-2)(a6,a4.l),d5
/* QL:         bsr.s   M149_doline */
    bsr.s M149_doline
/* QL: M149_progent */
M149_progent:
/* QL:         addq.l  #6,a4           skip pre-word and line number */
    addq.l #6,a4
/* QL:         cmp.l   M149_bv_pfp(a6),a4 */
    cmp.l M149_bv_pfp(a6),a4
/* QL:         blt.s   M149_proglp */
    blt.s M149_proglp
/* QL: M149_return */
M149_return:
/* QL:         move.l  (sp)+,a4 */
    move.l (sp)+,a4
/* QL: M149_rts0 */
M149_rts0:
/* QL:         rts */
    rts 
/* QL: M149_is_nam */
M149_is_nam:
/* QL:         move.l  a4,d3           save pointer to name */
    move.l a4,d3
/* QL:         bsr.s   ib_s4non        move past it and get next token */
    bsr.s ib_s4non
/* QL:         cmp.w   #M149_w.equal,d1 */
    cmp.w #M149_w.equal,d1
/* QL:         bne.s   M149_nxstat          only interested in {let} name = */
    bne.s M149_nxstat
/* QL:         move.l  d3,a4           go back to name */
    move.l d3,a4
/* QL: M149_varnam */
M149_varnam:
/* QL:         moveq   #M149_t.var,d3       this should be a simple variable */
    moveq #M149_t.var,d3
/* QL: M149_othnam */
M149_othnam:
/* QL:         bsr.s   M149_fillnam         go make sure we are ok on usage of this name */
    bsr.s M149_fillnam
/* QL: M149_nxstat */
M149_nxstat:
/* QL:         jsr     ib_eos(pc)      skip to end of this statement */
    jsr ib_eos(pc)
/* QL:         addq.l  #2,a4           skip whatever that was (:/then/else/nl) */
    addq.l #2,a4
/* QL:         blt.s   M149_rts0            if end of line, get out */
    blt.s M149_rts0
/* QL: M149_doline */
M149_doline:
/* QL:         bsr.s   ib_nxnon        find token at start of this statement */
    bsr.s ib_nxnon
/* QL:         sub.b   #M149_b.nam,d0 */
    sub.b #(M149_b.nam&255),d0
/* QL:         beq.s   M149_is_nam          a name, so go see about it */
    beq.s M149_is_nam
/* QL:         addq.b  #M149_b.nam-M149_b.key,d0 */
.word 20480|((((M149_b.nam-M149_b.key))&7)<<9)
/* QL:         bne.s   M149_nxstat          not a keyword, so we don't want it */
    bne.s M149_nxstat
/* QL:         addq.l  #2,a4           skip the keyword token */
    addq.l #2,a4
/* QL: * Decide what to do about the keyword, if anything */
/* QL:         btst    d1,d4 */
    btst d1,d4
/* QL:         beq.s   M149_nxstat          not interested in this statement at all */
    beq.s M149_nxstat
/* QL:         assert  0,M149_b.for-2,M149_b.rep-4,M149_b.def-7,M149_b.else-20,M149_b.dim-25,M149_b.let-27 */
/* original assertion: 0,M149_b.for-2,M149_b.rep-4,M149_b.def-7,M149_b.else-20,M149_b.dim-25,M149_b.let-27 */
/* QL:         subq.b  #M149_b.def,d1 */
    subq.b #M149_b.def,d1
/* QL:         ble.s   M149_is_frd */
    ble.s M149_is_frd
/* QL:         assert  0,(M149_b.else-M149_b.def)&2,(M149_b.dim-M149_b.def)&2-2,(M149_b.let-M149_b.def)&2 */
/* original assertion: 0,(M149_b.else-M149_b.def)&2,(M149_b.dim-M149_b.def)&2-2,(M149_b.let-M149_b.def)&2 */
/* QL:         lsr.b   #2,d1           move bit 1 to carry, to distiguish just dim */
    lsr.b #2,d1
/* QL:         bcc.s   M149_doline          note that else can come as statement start */
    bcc.s M149_doline
/* QL: * Also note that we always expect a name after let, so we can ignore it! */
/* QL:         subq.l  #2,a4           backspace to start M149_loop for dim */
    subq.l #2,a4
/* QL: M149_is_dim */
M149_is_dim:
/* QL:         bsr.s   ib_nxnam        go find a name */
    bsr.s ib_nxnam
/* QL:         beq.s   M149_nxstat          dim all done, go for next statement */
    beq.s M149_nxstat
/* QL:         moveq   #M149_t.arr,d3       want an array name here */
    moveq #M149_t.arr,d3
/* QL:         bsr.s   M149_fillnam         go check it out */
    bsr.s M149_fillnam
/* QL:         bra.s   M149_is_dim */
    bra.s M149_is_dim
/* QL: *is_rep */
/* QL: *       bsr.s   ib_nxnon        get token after repeat */
/* QL: *       cmp.b   #M149_b.nam,d0       is it a name (??? what else can it be? lwr) */
/* QL: *       bne.s   M149_nxstat          no - forget it */
/* QL: *       bra.s   M149_varnam          go check it's a simple variable (at least?) */
/* QL: *is_for */
/* QL: M149_is_frd */
M149_is_frd:
/* QL:         beq.s   M149_is_def */
    beq.s M149_is_def
/* QL:         bsr.s   ib_nxnon        get name following for */
    bsr.s ib_nxnon
/* QL:         bra.s   M149_varnam          it should be a simple variable */
    bra.s M149_varnam
/* QL: M149_is_def */
M149_is_def:
/* QL:         bsr.s   ib_nxnon        get keyword after define */
    bsr.s ib_nxnon
/* QL:         move.b  d1,d3           save it */
    move.b d1,d3
/* QL:         bsr.s   ib_s2non        skip it and get name token */
    bsr.s ib_s2non
/* QL:         assert  M149_b.proc-M149_t.bpr,M149_b.fn-M149_t.bfn */
/* original assertion: M149_b.proc-M149_t.bpr,M149_b.fn-M149_t.bfn */
/* QL:         subq.b  #M149_b.proc-M149_t.bpr,d3 */
.word 20739|((((M149_b.proc-M149_t.bpr))&7)<<9)
/* QL:         bra.s   M149_othnam          go verify basic proc/fn here */
    bra.s M149_othnam
/* QL: ib_s4non */
ib_s4non:
/* QL:         addq.l  #2,a4           move past half of current token */
    addq.l #2,a4
/* QL: ib_s2non */
ib_s2non:
/* QL:         addq.l  #2,a4           move past current token */
    addq.l #2,a4
/* QL: ib_nxnon */
ib_nxnon:
/* QL:         move.b  0(a6,a4.l),d0   look at current token */
    move.b 0(a6,a4.l),d0
/* QL:         cmp.b   #M149_b.spc,d0       space? */
    cmp.b #(M149_b.spc&255),d0
/* QL:         beq.s   ib_s2non        yes, then skip it */
    beq.s ib_s2non
/* QL:         move.w  0(a6,a4.l),d1   get the full token */
    move.w 0(a6,a4.l),d1
/* QL:         rts */
    rts 
/* QL: M149_fillnam */
M149_fillnam:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         move.w  2(a6,a4.l),d0   pick up index */
    move.w 2(a6,a4.l),d0
/* QL:         lsl.l   #3,d0 */
    lsl.l #3,d0
/* QL:         move.l  M149_bv_ntbas(a6),a2 */
    move.l M149_bv_ntbas(a6),a2
/* QL:         add.l   d0,a2           form name table pointer */
    add.l d0,a2
/* QL:         move.b  0(a6,a2.l),d0   have a look before we commit ourselves */
    move.b 0(a6,a2.l),d0
/* QL:         cmp.b   d0,d3           are they the same? */
    cmp.b d0,d3
/* QL:         beq.s   M149_set_type        yes - leave well enough alone */
    beq.s M149_set_type
/* QL:         subq.b  #M149_t.var,d0       is it already a simple variable */
    subq.b #M149_t.var,d0
/* QL:         blt.s   M149_set_type        unset or internal, so set it */
    blt.s M149_set_type
/* QL:         beq.s   M149_free_set        variable, free and set */
    beq.s M149_free_set
/* QL:         subq.b  #M149_t.arr-M149_t.var,d0 */
.word 20736|((((M149_t.arr-M149_t.var))&7)<<9)
/* QL:         beq.s   M149_rts1            already an array, so can't reset */
    beq.s M149_rts1
/* QL:         subq.b  #M149_t.bfn-M149_t.arr,d0 */
.word 20736|((((M149_t.bfn-M149_t.arr))&7)<<9)
/* QL:         ble.s   M149_proc_fn         basic proc/fn */
    ble.s M149_proc_fn
/* QL:         subq.b  #M149_t.mcp-M149_t.bfn,d0 */
.word 20736|((((M149_t.mcp-M149_t.bfn))&7)<<9)
/* QL:         blt.s   M149_free_set        rep/for, free and reset; mcpr/mcfn, check */
    blt.s M149_free_set
/* QL: M149_proc_fn */
M149_proc_fn:
/* QL:         cmp.b   #M149_t.bpr,d3 */
    cmp.b #(M149_t.bpr&255),d3
/* QL:         bge.s   M149_set_type        only reset proc/fn to proc/fn */
    bge.s M149_set_type
/* QL: M149_free_set */
M149_free_set:
/* QL:         jsr     ca_frvar(pc)    d1/a0 destroyed, d0=error */
    jsr ca_frvar(pc)
/* QL:         bne.s   M149_rts1            couldn't free it so don't reset either */
    bne.s M149_rts1
/* QL: M149_set_type */
M149_set_type:
/* QL:         move.b  d3,0(a6,a2.l)   replace it */
    move.b d3,0(a6,a2.l)
/* QL:         subq.b  #M149_t.bpr,d3       is this a basic procedure or function? */
    subq.b #M149_t.bpr,d3
/* QL:         blt.s   M149_rts1 */
    blt.s M149_rts1
/* QL:         move.w  d5,4(a6,a2.l)   yes, then set the line number */
    move.w d5,4(a6,a2.l)
/* QL: M149_rts1 */
M149_rts1:
/* QL:         rts */
    rts 
/* QL: * Look next name or comma token, ignoring anything in nested parentheses */
/* QL: * ccr z set if not found */
/* QL: * d1 -i o- msw preserved, lsw zero */
/* QL: * a4 -i o- pointer to tokenised line. 1st token skipped, ends at found or eos */
/* QL: * d0-d3 destroyed */
/* QL: * (d0.lsb only is changed: M149_b.nam if found nxnam, otherwise always M149_b.sym) */
/* QL: * (d2.l set to 2 by nxcom, lsw only set to $03fe by nxnam) */
/* QL: * (d3.l=$ff if found, or not found but 255 levels down!) */
/* QL: * We actually scan over a " ... ) ... ( ... " pairing - maybe we shouldn't? */
/* QL: ib_nxnam */
ib_nxnam:
/* QL:         move.w  #M149_w.nam-M149_w.colon,d2 */
    move.w #(M149_w.nam-M149_w.colon),d2
/* QL:         bra.s   M149_nxone */
    bra.s M149_nxone
/* QL: ib_nxcom */
ib_nxcom:
/* QL:         moveq   #M149_w.symcom-M149_w.colon,d2 */
    moveq #(M149_w.symcom-M149_w.colon),d2
/* QL: M149_nxone */
M149_nxone:
/* QL:         moveq   #1,d3           nest level */
    moveq #1,d3
/* QL: M149_sub1 */
M149_sub1:
/* QL:         subq.b  #2,d3           decrement nest level */
    subq.b #2,d3
/* QL: M149_add1 */
M149_add1:
/* QL:         addq.b  #1,d3           increment nest level */
    addq.b #1,d3
/* QL: M149_loop */
M149_loop:
/* QL:         jsr     ib_nxtk(pc) */
    jsr ib_nxtk(pc)
/* QL:         sub.w   #M149_w.eol,d1 */
    sub.w #M149_w.eol,d1
/* QL:         beq.s   M149_rts2            exit at end of line */
    beq.s M149_rts2
/* QL:         addq.w  #M149_w.eol-M149_w.cpar,d1 */
.word 20545|((((M149_w.eol-M149_w.cpar))&7)<<9)
/* QL:         beq.s   M149_sub1            pop level on close parenthesis */
    beq.s M149_sub1
/* QL:         addq.w  #M149_w.cpar-M149_w.opar,d1 */
.word 20545|((((M149_w.cpar-M149_w.opar))&7)<<9)
/* QL:         beq.s   M149_add1            push level on open parenthesis */
    beq.s M149_add1
/* QL:         addq.w  #M149_w.opar-M149_w.colon,d1 */
.word 20545|((((M149_w.opar-M149_w.colon))&7)<<9)
/* QL:         beq.s   M149_rts2            exit at colon */
    beq.s M149_rts2
/* QL:         sub.w   d2,d1           is this what we are looking for ? */
    sub.w d2,d1
/* QL:         bne.s   M149_loop            no, keep going */
    bne.s M149_loop
/* QL:         subq.b  #1,d3           are we outside sets of brackets? */
    subq.b #1,d3
/* QL:         bcc.s   M149_add1            no, keep going */
    bcc.s M149_add1
/* QL: M149_rts2 */
M149_rts2:
/* QL:         rts */
    rts 
/* QL:         end */
