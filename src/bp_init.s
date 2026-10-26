/* ROM section bp_init */
.balign 2,0
/* QL: bp_init0 */
bp_init0:
/* QL:         lea    M46_bptab(pc),a1       point to start of data */
    lea M46_bptab(pc),a1
/* QL: ;*        bsr.s  bp_init */
/* QL: ;*        lea    newtab(pc),a1 */
/* QL: * Drop thru to ... */
/* QL: * The vectored utility bp_init */
/* QL: * d0 -  o- error code */
/* QL: * a1 -i  - bp input table */
/* QL: * a6 -ip - base register */
/* QL: * Documentation suggests that d2 was not preserved before... it is now. */
/* QL: reglist reg     d1-d5/a0/a2-a3  bulk of registers we need saved */
/* QL: bp_init */
bp_init:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d5/a0/a2-a3,-(sp)
/* QL:         moveq   #M46_t.mcp,d4 */
    moveq #M46_t.mcp,d4
/* QL: M46_ini */
M46_ini:
/* QL: * As we beleive we extend tables properly, lets see if we can do without: */
/* QL: *        moveq   #0,d5           clear msw */
/* QL:         move.w  (a1)+,d5        read number of mc procedures or functions */
    move.w (a1)+,d5
/* QL: *        lsl.l   #3,d5           multiply by 8 to get space nec in tables */
/* QL: *        move.l  d5,d1 */
/* QL: *        jsr     bv_chntx(pc)    estimated room needed in name table */
/* QL: *        move.l  d5,d1 */
/* QL: *        jsr     bv_chnlx(pc)    estimated room needed in name list */
/* QL: * Note: MCS ROM (etc?) underestimates, so chnam may further extend! */
/* QL: M46_readbp */
M46_readbp:
/* QL:         move.l  a1,a2           set base address */
    move.l a1,a2
/* QL:         move.w  (a1)+,d0        offset to the proc/fn */
    move.w (a1)+,d0
/* QL:         beq.s   M46_end_0           end of this table? */
    beq.s M46_end_0
/* QL:         add.w   d0,a2 */
    add.w d0,a2
/* QL:         moveq   #0,d5 */
    moveq #0,d5
/* QL:         move.b  (a1),d5         read number of chars in name */
    move.b (a1),d5
/* QL:         move.w  d5,d1 */
    move.w d5,d1
/* QL:         move.l  M46_bv_bfbas(a6),a0 name must be relative to a6 for chnam */
    move.l M46_bv_bfbas(a6),a0
/* QL:         addq.l  #1,a0           want this past length byte */
    addq.l #1,a0
/* QL:         move.l  a0,a3           set ready for chnam */
    move.l a0,a3
/* QL: M46_copy_ch */
M46_copy_ch:
/* QL:         move.w  (a1)+,-1(a6,a0.l) move words - quicker and saves rounding */
    move.w (a1)+,(-1)(a6,a0.l)
/* QL:         addq.l  #2,a0 */
    addq.l #2,a0
/* QL:         subq.w  #2,d1 */
    subq.w #2,d1
/* QL:         bcc.s   M46_copy_ch         2 bytes or more need looping */
    bcc.s M46_copy_ch
/* QL:         add.w   d1,a0 */
    add.w d1,a0
/* QL:         sf      0(a6,a0.l)      make sure it ends with junk */
    sf 0(a6,a0.l)
/* QL:         movem.l d6/a1-a2,-(sp)  save where we are (d6 destroyed by chnam) */
    movem.l d6/a1-a2,-(sp)
/* QL:         move.l  a3,a0           back to start of name */
    move.l a3,a0
/* QL:         jsr     pa_chnlt(pc)    ensure name is moderately sensible */
    jsr pa_chnlt(pc)
/* QL:         bra.s   M46_zapit           ret+0: bad name (zero length!) */
    bra.s M46_zapit
/* QL:                 ;               ret+2: ok, a0 moved to end */
/* QL:         sub.w   d5,a0           hopefully move back to start of name */
    sub.w d5,a0
/* QL:         cmp.l   a3,a0           had we moved on to the end of the name? */
    cmp.l a3,a0
/* QL:         bne.s   M46_zapit           no, we had something invalid about the name */
    bne.s M46_zapit
/* QL:         move.l  pa_table(pc),a2 ptr to keywords (not allowed as names) */
    move.l pa_table(pc),a2
/* QL:         jsr     pa_chnam(pc)    check (create) name */
    jsr pa_chnam(pc)
/* QL: M46_zapit */
M46_zapit:
/* QL:         moveq   #M46_err.bn,d5      ret+0: bad name (a keyword... or malformed) */
    moveq #M46_err.bn,d5
/* QL:                 ;               ret+2: ok, d5=index, a2=nt */
/* QL:         movem.l (sp)+,d6/a1/a3  restore where we are */
    movem.l (sp)+,d6/a1/a3
/* QL:         move.l  d5,d0           either nt index (msw 0) or M46_err.bn */
    move.l d5,d0
/* QL:         bmi.s   M46_fin             if we had a bad name, get out now */
    bmi.s M46_fin
/* QL:         jsr     ca_frvar(pc)    in case we are replacing an existing variable */
    jsr ca_frvar(pc)
/* QL:         move.b  d4,0(a6,a2.l)   set mc proc/fn usage */
    move.b d4,0(a6,a2.l)
/* QL:         clr.b   1(a6,a2.l)      clear type (pander to QREF ... lwr) */
    clr.b 1(a6,a2.l)
/* QL:         move.l  a3,4(a6,a2.l)   put address of proc */
    move.l a3,4(a6,a2.l)
/* QL:         bra.s   M46_readbp          and do the next proc line */
    bra.s M46_readbp
/* QL: M46_end_0 */
M46_end_0:
/* QL:         move.l  d4,d0 */
    move.l d4,d0
/* QL:         moveq   #M46_t.mcf,d4 */
    moveq #M46_t.mcf,d4
/* QL:         sub.l   d4,d0           have we just done the procedures? */
    sub.l d4,d0
/* QL:         bne.s   M46_ini             yes, go back for functions. */
    bne.s M46_ini
/* QL: M46_fin */
M46_fin:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d5/a0/a2-a3
/* QL:         rts */
    rts 
/* QL: * Build basic procedure/function tables */
/* QL: * Although we go to the trouble of calculating the "correct" estimate for the */
/* QL: * first word of each table, we no longer care what it is. */
/* QL: pfhead  macro   head */
/* QL: pfadd   macro */
/* QL: pftail  macro */
/* QL: M46_bptab pfhead bp_ */
/* QL: pfhead  setstr  [head] */
/* QL: pfnl    setnum  7 */
/* QL: pfnt    setnum  0 */
/* QL: pflab   setstr  pft_[.l] */
/* QL: pfunln  setstr  _ */
/* QL: [.lab]  dc.w    [pflab] */
.balign 2,0
M46_bptab:
M46_dc_anchor_427:
.word M46_pft_1
/* QL:  pfadd print run stop input window border ink strip paper block pan scroll */
/* QL: ind     setnum  0 */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_445:
.word ((bp_print-M46_dc_anchor_445))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_448:
.byte (5)&255
.byte 80,82,73,78,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_467:
.word ((bp_run-M46_dc_anchor_467))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_470:
.byte (3)&255
.byte 82,85,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_489:
.word ((bp_stop-M46_dc_anchor_489))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_492:
.byte (4)&255
.byte 83,84,79,80
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_512:
.word ((bp_input-M46_dc_anchor_512))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_515:
.byte (5)&255
.byte 73,78,80,85,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_535:
.word ((bp_windw-M46_dc_anchor_535))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_538:
.byte (6)&255
.byte 87,73,78,68,79,87
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_558:
.word ((bp_bordr-M46_dc_anchor_558))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_561:
.byte (6)&255
.byte 66,79,82,68,69,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_580:
.word ((bp_ink-M46_dc_anchor_580))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_583:
.byte (3)&255
.byte 73,78,75
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_603:
.word ((bp_strip-M46_dc_anchor_603))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_606:
.byte (5)&255
.byte 83,84,82,73,80
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_626:
.word ((bp_paper-M46_dc_anchor_626))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_629:
.byte (5)&255
.byte 80,65,80,69,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_649:
.word ((bp_block-M46_dc_anchor_649))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_652:
.byte (5)&255
.byte 66,76,79,67,75
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_671:
.word ((bp_pan-M46_dc_anchor_671))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_674:
.byte (3)&255
.byte 80,65,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_694:
.word ((bp_scrol-M46_dc_anchor_694))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_697:
.byte (6)&255
.byte 83,67,82,79,76,76
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: done    maclab */
/* QL:  pfadd csize flash under over cursor at scale point line ellipse circle arc */
/* QL: ind     setnum  0 */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_723:
.word ((bp_csize-M46_dc_anchor_723))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_726:
.byte (5)&255
.byte 67,83,73,90,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_746:
.word ((bp_flash-M46_dc_anchor_746))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_749:
.byte (5)&255
.byte 70,76,65,83,72
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_769:
.word ((bp_under-M46_dc_anchor_769))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_772:
.byte (5)&255
.byte 85,78,68,69,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_791:
.word ((bp_over-M46_dc_anchor_791))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_794:
.byte (4)&255
.byte 79,86,69,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_814:
.word ((bp_cursr-M46_dc_anchor_814))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_817:
.byte (6)&255
.byte 67,85,82,83,79,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_836:
.word ((bp_at-M46_dc_anchor_836))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_839:
.byte (2)&255
.byte 65,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_859:
.word ((bp_scale-M46_dc_anchor_859))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_862:
.byte (5)&255
.byte 83,67,65,76,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_882:
.word ((bp_point-M46_dc_anchor_882))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_885:
.byte (5)&255
.byte 80,79,73,78,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_904:
.word ((bp_line-M46_dc_anchor_904))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_907:
.byte (4)&255
.byte 76,73,78,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_927:
.word ((bp_ellie-M46_dc_anchor_927))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_930:
.byte (7)&255
.byte 69,76,76,73,80,83,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_950:
.word ((bp_circe-M46_dc_anchor_950))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_953:
.byte (6)&255
.byte 67,73,82,67,76,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_972:
.word ((bp_arc-M46_dc_anchor_972))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_975:
.byte (3)&255
.byte 65,82,67
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: done    maclab */
/* QL:  pfadd point_r turn turnto penup pendown move list open close format copy */
/* QL: ind     setnum  0 */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1001:
.word ((bp_poinr-M46_dc_anchor_1001))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1004:
.byte (7)&255
.byte 80,79,73,78,84,95,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1023:
.word ((bp_turn-M46_dc_anchor_1023))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1026:
.byte (4)&255
.byte 84,85,82,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1046:
.word ((bp_turno-M46_dc_anchor_1046))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1049:
.byte (6)&255
.byte 84,85,82,78,84,79
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1069:
.word ((bp_penup-M46_dc_anchor_1069))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1072:
.byte (5)&255
.byte 80,69,78,85,80
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1092:
.word ((bp_pendn-M46_dc_anchor_1092))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1095:
.byte (7)&255
.byte 80,69,78,68,79,87,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1114:
.word ((bp_move-M46_dc_anchor_1114))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1117:
.byte (4)&255
.byte 77,79,86,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1136:
.word ((bp_list-M46_dc_anchor_1136))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1139:
.byte (4)&255
.byte 76,73,83,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1158:
.word ((bp_open-M46_dc_anchor_1158))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1161:
.byte (4)&255
.byte 79,80,69,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1181:
.word ((bp_close-M46_dc_anchor_1181))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1184:
.byte (5)&255
.byte 67,76,79,83,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1204:
.word ((bp_formt-M46_dc_anchor_1204))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1207:
.byte (6)&255
.byte 70,79,82,77,65,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1226:
.word ((bp_copy-M46_dc_anchor_1226))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1229:
.byte (4)&255
.byte 67,79,80,89
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: done    maclab */
/* QL:  pfadd copy_n delete dir exec exec_w lbytes sexec sbytes save merge mrun load */
/* QL: ind     setnum  0 */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1255:
.word ((bp_copyn-M46_dc_anchor_1255))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1258:
.byte (6)&255
.byte 67,79,80,89,95,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1278:
.word ((bp_delee-M46_dc_anchor_1278))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1281:
.byte (6)&255
.byte 68,69,76,69,84,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1300:
.word ((bp_dir-M46_dc_anchor_1300))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1303:
.byte (3)&255
.byte 68,73,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1322:
.word ((bp_exec-M46_dc_anchor_1322))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1325:
.byte (4)&255
.byte 69,88,69,67
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1345:
.word ((bp_execw-M46_dc_anchor_1345))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1348:
.byte (6)&255
.byte 69,88,69,67,95,87
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1368:
.word ((bp_lbyts-M46_dc_anchor_1368))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1371:
.byte (6)&255
.byte 76,66,89,84,69,83
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1391:
.word ((bp_sexec-M46_dc_anchor_1391))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1394:
.byte (5)&255
.byte 83,69,88,69,67
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1414:
.word ((bp_sbyts-M46_dc_anchor_1414))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1417:
.byte (6)&255
.byte 83,66,89,84,69,83
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1436:
.word ((bp_save-M46_dc_anchor_1436))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1439:
.byte (4)&255
.byte 83,65,86,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1459:
.word ((bp_merge-M46_dc_anchor_1459))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1462:
.byte (5)&255
.byte 77,69,82,71,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1481:
.word ((bp_mrun-M46_dc_anchor_1481))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1484:
.byte (4)&255
.byte 77,82,85,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1503:
.word ((bp_load-M46_dc_anchor_1503))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1506:
.byte (4)&255
.byte 76,79,65,68
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: done    maclab */
/* QL:  pfadd lrun new clear open_in open_new cls call recol randomise pause poke */
/* QL: ind     setnum  0 */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1531:
.word ((bp_lrun-M46_dc_anchor_1531))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1534:
.byte (4)&255
.byte 76,82,85,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1553:
.word ((bp_new-M46_dc_anchor_1553))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1556:
.byte (3)&255
.byte 78,69,87
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1576:
.word ((bp_clear-M46_dc_anchor_1576))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1579:
.byte (5)&255
.byte 67,76,69,65,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1599:
.word ((bp_openn-M46_dc_anchor_1599))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1602:
.byte (7)&255
.byte 79,80,69,78,95,73,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1622:
.word ((bp_openw-M46_dc_anchor_1622))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1625:
.byte (8)&255
.byte 79,80,69,78,95,78,69,87
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1644:
.word ((bp_cls-M46_dc_anchor_1644))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1647:
.byte (3)&255
.byte 67,76,83
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1666:
.word ((bp_call-M46_dc_anchor_1666))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1669:
.byte (4)&255
.byte 67,65,76,76
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1689:
.word ((bp_recol-M46_dc_anchor_1689))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1692:
.byte (5)&255
.byte 82,69,67,79,76
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1712:
.word ((bp_rande-M46_dc_anchor_1712))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1715:
.byte (9)&255
.byte 82,65,78,68,79,77,73,83,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1735:
.word ((bp_pause-M46_dc_anchor_1735))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1738:
.byte (5)&255
.byte 80,65,85,83,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1757:
.word ((bp_poke-M46_dc_anchor_1757))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1760:
.byte (4)&255
.byte 80,79,75,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: done    maclab */
/* QL:  pfadd poke_w poke_l baud beep continue retry read net mode renum dline sdate */
/* QL: ind     setnum  0 */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1786:
.word ((bp_pokew-M46_dc_anchor_1786))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1789:
.byte (6)&255
.byte 80,79,75,69,95,87
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1809:
.word ((bp_pokel-M46_dc_anchor_1809))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1812:
.byte (6)&255
.byte 80,79,75,69,95,76
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1831:
.word ((bp_baud-M46_dc_anchor_1831))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1834:
.byte (4)&255
.byte 66,65,85,68
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1853:
.word ((bp_beep-M46_dc_anchor_1853))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1856:
.byte (4)&255
.byte 66,69,69,80
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1876:
.word ((bp_conte-M46_dc_anchor_1876))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1879:
.byte (8)&255
.byte 67,79,78,84,73,78,85,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1899:
.word ((bp_retry-M46_dc_anchor_1899))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1902:
.byte (5)&255
.byte 82,69,84,82,89
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1921:
.word ((bp_read-M46_dc_anchor_1921))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1924:
.byte (4)&255
.byte 82,69,65,68
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1943:
.word ((bp_net-M46_dc_anchor_1943))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1946:
.byte (3)&255
.byte 78,69,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1965:
.word ((bp_mode-M46_dc_anchor_1965))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1968:
.byte (4)&255
.byte 77,79,68,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_1988:
.word ((bp_renum-M46_dc_anchor_1988))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_1991:
.byte (5)&255
.byte 82,69,78,85,77
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2011:
.word ((bp_dline-M46_dc_anchor_2011))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2014:
.byte (5)&255
.byte 68,76,73,78,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2034:
.word ((bp_sdate-M46_dc_anchor_2034))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2037:
.byte (5)&255
.byte 83,68,65,84,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: done    maclab */
/* QL:  pfadd adate line_r ellipse_r circle_r arc_r auto edit fill width report tra */
/* QL: ind     setnum  0 */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2063:
.word ((bp_adate-M46_dc_anchor_2063))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2066:
.byte (5)&255
.byte 65,68,65,84,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2086:
.word ((bp_liner-M46_dc_anchor_2086))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2089:
.byte (6)&255
.byte 76,73,78,69,95,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2109:
.word ((bp_ellir-M46_dc_anchor_2109))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2112:
.byte (9)&255
.byte 69,76,76,73,80,83,69,95,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2132:
.word ((bp_circr-M46_dc_anchor_2132))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2135:
.byte (8)&255
.byte 67,73,82,67,76,69,95,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2154:
.word ((bp_arcr-M46_dc_anchor_2154))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2157:
.byte (5)&255
.byte 65,82,67,95,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2176:
.word ((bp_auto-M46_dc_anchor_2176))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2179:
.byte (4)&255
.byte 65,85,84,79
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2198:
.word ((bp_edit-M46_dc_anchor_2198))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2201:
.byte (4)&255
.byte 69,68,73,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2220:
.word ((bp_fill-M46_dc_anchor_2220))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2223:
.byte (4)&255
.byte 70,73,76,76
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2243:
.word ((bp_width-M46_dc_anchor_2243))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2246:
.byte (5)&255
.byte 87,73,68,84,72
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2266:
.word ((bp_repot-M46_dc_anchor_2266))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2269:
.byte (6)&255
.byte 82,69,80,79,82,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2288:
.word ((bp_tra-M46_dc_anchor_2288))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2291:
.byte (3)&255
.byte 84,82,65
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: done    maclab */
/* QL:  pftail */
/* QL:         dc.w    0 */
.balign 2,0
M46_dc_anchor_2304:
.word 0
/* QL:         ifnum   [pfnl] < [pfnt] goto defit */
/* QL: defit   maclab */
/* QL: [pflab] equ     [pfnt]>>3 */
.equ M46_pft_1,(648>>3)
/* QL:  pfhead bf_ */
/* QL: pfhead  setstr  [head] */
/* QL: pfnl    setnum  7 */
/* QL: pfnt    setnum  0 */
/* QL: pflab   setstr  pft_[.l] */
/* QL: pfunln  setstr  _ */
/* QL: [.lab]  dc.w    [pflab] */
.balign 2,0
M46_dc_anchor_2318:
.word M46_pft_10
/* QL:  pfadd acos acot asin atan cos cot exp ln log10 sin sqrt tan deg rad rnd int */
/* QL: ind     setnum  0 */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2335:
.word ((bf_acos-M46_dc_anchor_2335))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2338:
.byte (4)&255
.byte 65,67,79,83
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2357:
.word ((bf_acot-M46_dc_anchor_2357))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2360:
.byte (4)&255
.byte 65,67,79,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2379:
.word ((bf_asin-M46_dc_anchor_2379))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2382:
.byte (4)&255
.byte 65,83,73,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2401:
.word ((bf_atan-M46_dc_anchor_2401))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2404:
.byte (4)&255
.byte 65,84,65,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2423:
.word ((bf_cos-M46_dc_anchor_2423))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2426:
.byte (3)&255
.byte 67,79,83
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2445:
.word ((bf_cot-M46_dc_anchor_2445))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2448:
.byte (3)&255
.byte 67,79,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2467:
.word ((bf_exp-M46_dc_anchor_2467))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2470:
.byte (3)&255
.byte 69,88,80
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2489:
.word ((bf_ln-M46_dc_anchor_2489))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2492:
.byte (2)&255
.byte 76,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2512:
.word ((bf_log10-M46_dc_anchor_2512))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2515:
.byte (5)&255
.byte 76,79,71,49,48
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2534:
.word ((bf_sin-M46_dc_anchor_2534))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2537:
.byte (3)&255
.byte 83,73,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2556:
.word ((bf_sqrt-M46_dc_anchor_2556))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2559:
.byte (4)&255
.byte 83,81,82,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2578:
.word ((bf_tan-M46_dc_anchor_2578))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2581:
.byte (3)&255
.byte 84,65,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2600:
.word ((bf_deg-M46_dc_anchor_2600))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2603:
.byte (3)&255
.byte 68,69,71
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2622:
.word ((bf_rad-M46_dc_anchor_2622))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2625:
.byte (3)&255
.byte 82,65,68
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2644:
.word ((bf_rnd-M46_dc_anchor_2644))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2647:
.byte (3)&255
.byte 82,78,68
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2666:
.word ((bf_int-M46_dc_anchor_2666))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2669:
.byte (3)&255
.byte 73,78,84
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: done    maclab */
/* QL:  pfadd abs pi peek peek_w peek_l respr eof inkey$ chr$ code keyrow beeping len */
/* QL: ind     setnum  0 */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2694:
.word ((bf_abs-M46_dc_anchor_2694))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2697:
.byte (3)&255
.byte 65,66,83
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2716:
.word ((bf_pi-M46_dc_anchor_2716))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2719:
.byte (2)&255
.byte 80,73
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2738:
.word ((bf_peek-M46_dc_anchor_2738))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2741:
.byte (4)&255
.byte 80,69,69,75
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2761:
.word ((bf_peekw-M46_dc_anchor_2761))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2764:
.byte (6)&255
.byte 80,69,69,75,95,87
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2784:
.word ((bf_peekl-M46_dc_anchor_2784))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2787:
.byte (6)&255
.byte 80,69,69,75,95,76
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2807:
.word ((bf_respr-M46_dc_anchor_2807))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2810:
.byte (5)&255
.byte 82,69,83,80,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2829:
.word ((bf_eof-M46_dc_anchor_2829))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2832:
.byte (3)&255
.byte 69,79,70
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: ref     setstr  [.left(ref,[.len(ref)]-1)]s */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2853:
.word ((bf_inkes-M46_dc_anchor_2853))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2856:
.byte (6)&255
.byte 73,78,75,69,89,36
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: ref     setstr  [.left(ref,[.len(ref)]-1)]s */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2876:
.word ((bf_chrs-M46_dc_anchor_2876))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2879:
.byte (4)&255
.byte 67,72,82,36
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2898:
.word ((bf_code-M46_dc_anchor_2898))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2901:
.byte (4)&255
.byte 67,79,68,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2921:
.word ((bf_keyrw-M46_dc_anchor_2921))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2924:
.byte (6)&255
.byte 75,69,89,82,79,87
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2944:
.word ((bf_beepg-M46_dc_anchor_2944))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2947:
.byte (7)&255
.byte 66,69,69,80,73,78,71
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2966:
.word ((bf_len-M46_dc_anchor_2966))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2969:
.byte (3)&255
.byte 76,69,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: done    maclab */
/* QL:  pfadd dimn day$ date date$ fill$ ver$ err_nc err_nj err_om err_or err_bo */
/* QL: ind     setnum  0 */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_2994:
.word ((bf_dimn-M46_dc_anchor_2994))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_2997:
.byte (4)&255
.byte 68,73,77,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: ref     setstr  [.left(ref,[.len(ref)]-1)]s */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3017:
.word ((bf_days-M46_dc_anchor_3017))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3020:
.byte (4)&255
.byte 68,65,89,36
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3039:
.word ((bf_date-M46_dc_anchor_3039))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3042:
.byte (4)&255
.byte 68,65,84,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: ref     setstr  [.left(ref,[.len(ref)]-1)]s */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3063:
.word ((bf_dates-M46_dc_anchor_3063))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3066:
.byte (5)&255
.byte 68,65,84,69,36
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: ref     setstr  [.left(ref,[.len(ref)]-1)]s */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3087:
.word ((bf_fills-M46_dc_anchor_3087))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3090:
.byte (5)&255
.byte 70,73,76,76,36
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: ref     setstr  [.left(ref,[.len(ref)]-1)]s */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3110:
.word ((bf_vers-M46_dc_anchor_3110))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3113:
.byte (4)&255
.byte 86,69,82,36
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3133:
.word ((bf_errnc-M46_dc_anchor_3133))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3136:
.byte (6)&255
.byte 69,82,82,95,78,67
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3156:
.word ((bf_errnj-M46_dc_anchor_3156))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3159:
.byte (6)&255
.byte 69,82,82,95,78,74
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3179:
.word ((bf_errom-M46_dc_anchor_3179))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3182:
.byte (6)&255
.byte 69,82,82,95,79,77
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3202:
.word ((bf_error-M46_dc_anchor_3202))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3205:
.byte (6)&255
.byte 69,82,82,95,79,82
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3225:
.word ((bf_errbo-M46_dc_anchor_3225))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3228:
.byte (6)&255
.byte 69,82,82,95,66,79
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: done    maclab */
/* QL:  pfadd err_no err_nf err_ex err_iu err_ef err_df err_bn err_te err_ff err_bp */
/* QL: ind     setnum  0 */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3254:
.word ((bf_errno-M46_dc_anchor_3254))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3257:
.byte (6)&255
.byte 69,82,82,95,78,79
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3277:
.word ((bf_errnf-M46_dc_anchor_3277))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3280:
.byte (6)&255
.byte 69,82,82,95,78,70
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3300:
.word ((bf_errex-M46_dc_anchor_3300))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3303:
.byte (6)&255
.byte 69,82,82,95,69,88
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3323:
.word ((bf_erriu-M46_dc_anchor_3323))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3326:
.byte (6)&255
.byte 69,82,82,95,73,85
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3346:
.word ((bf_erref-M46_dc_anchor_3346))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3349:
.byte (6)&255
.byte 69,82,82,95,69,70
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3369:
.word ((bf_errdf-M46_dc_anchor_3369))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3372:
.byte (6)&255
.byte 69,82,82,95,68,70
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3392:
.word ((bf_errbn-M46_dc_anchor_3392))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3395:
.byte (6)&255
.byte 69,82,82,95,66,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3415:
.word ((bf_errte-M46_dc_anchor_3415))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3418:
.byte (6)&255
.byte 69,82,82,95,84,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3438:
.word ((bf_errff-M46_dc_anchor_3438))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3441:
.byte (6)&255
.byte 69,82,82,95,70,70
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3461:
.word ((bf_errbp-M46_dc_anchor_3461))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3464:
.byte (6)&255
.byte 69,82,82,95,66,80
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: done    maclab */
/* QL:  pfadd err_fe err_xp err_ov err_ni err_ro err_bl ernum erlin */
/* QL: ind     setnum  0 */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3490:
.word ((bf_errfe-M46_dc_anchor_3490))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3493:
.byte (6)&255
.byte 69,82,82,95,70,69
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3513:
.word ((bf_errxp-M46_dc_anchor_3513))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3516:
.byte (6)&255
.byte 69,82,82,95,88,80
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3536:
.word ((bf_errov-M46_dc_anchor_3536))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3539:
.byte (6)&255
.byte 69,82,82,95,79,86
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3559:
.word ((bf_errni-M46_dc_anchor_3559))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3562:
.byte (6)&255
.byte 69,82,82,95,78,73
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3582:
.word ((bf_errro-M46_dc_anchor_3582))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3585:
.byte (6)&255
.byte 69,82,82,95,82,79
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3605:
.word ((bf_errbl-M46_dc_anchor_3605))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3608:
.byte (6)&255
.byte 69,82,82,95,66,76
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3628:
.word ((bf_ernum-M46_dc_anchor_3628))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3631:
.byte (5)&255
.byte 69,82,78,85,77
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: txt     setstr  [.parm([ind])] */
/* QL: ref     setnum  [.instr(txt,pfunln)] */
/* QL: ref     setstr  [pfhead][.left(txt,[ref]-1)][.right(txt,[.len(txt)]-[ref])] */
/* QL:         ifnum   [.len(ref)] < 8 goto lenok */
/* QL: ref     setstr  [.left(ref,7)][.right(ref,1)] */
/* QL: lenok   maclab */
/* QL:         ifstr   [.right(ref,1)] <> $ goto useit */
/* QL: useit   maclab */
/* QL:         xref    [ref] */
/* QL:         dc.w    [ref]-* */
.balign 2,0
M46_dc_anchor_3651:
.word ((bf_erlin-M46_dc_anchor_3651))&65535
/* QL:         dc.b    [.len(txt)],'[.ucase(txt)]' */
M46_dc_anchor_3654:
.byte (5)&255
.byte 69,82,76,73,78
/* QL: pfnl    setnum  [pfnl]+[.len(txt)]+1 */
/* QL: pfnt    setnum  [pfnt]+8 */
/* QL:         goto    loop */
/* QL: loop    maclab */
/* QL: ind     setnum  [ind]+1 */
/* QL:         ifnum   [ind] > [.nparms] goto done */
/* QL: done    maclab */
/* QL:  pftail */
/* QL:         dc.w    0 */
.balign 2,0
M46_dc_anchor_3667:
.word 0
/* QL:         ifnum   [pfnl] < [pfnt] goto defit */
/* QL: defit   maclab */
/* QL: [pflab] equ     [pfnt]>>3 */
.equ M46_pft_10,(464>>3)
/* QL: ;*Note: A new table such as that below should be added just above this line. */
/* QL: ;*newtab pfhead proc_prefix */
/* QL: ;* pfadd newproc_name ... */
/* QL: ;* pftail */
/* QL: ;* pfhead fn_prefix */
/* QL: ;* pfadd newfn_name ... */
/* QL: ;* pftail */
/* QL:         end */
