/* ROM section pa_graph */
.balign 2,0
/* QL: M133_cd_tab */
M133_cd_tab:
/* QL:         dc.w    pa_cdnam-M133_cd_jsr */
.balign 2,0
M133_dc_anchor_1013:
.word ((pa_cdnam-M133_cd_jsr))&65535
/* QL:         dc.w    pa_cdval-M133_cd_jsr */
.balign 2,0
M133_dc_anchor_1017:
.word ((pa_cdval-M133_cd_jsr))&65535
/* QL:         dc.w    pa_cdnum-M133_cd_jsr */
.balign 2,0
M133_dc_anchor_1021:
.word ((pa_cdnum-M133_cd_jsr))&65535
/* QL:         dc.w    pa_cdsyv-M133_cd_jsr */
.balign 2,0
M133_dc_anchor_1025:
.word ((pa_cdsyv-M133_cd_jsr))&65535
/* QL:         dc.w    pa_cdops-M133_cd_jsr */
.balign 2,0
M133_dc_anchor_1029:
.word ((pa_cdops-M133_cd_jsr))&65535
/* QL:         dc.w    pa_cdmon-M133_cd_jsr */
.balign 2,0
M133_dc_anchor_1033:
.word ((pa_cdmon-M133_cd_jsr))&65535
/* QL:         dc.w    pa_cdsep-M133_cd_jsr */
.balign 2,0
M133_dc_anchor_1037:
.word ((pa_cdsep-M133_cd_jsr))&65535
/* QL:         dc.w    pa_cdstr-M133_cd_jsr */
.balign 2,0
M133_dc_anchor_1041:
.word ((pa_cdstr-M133_cd_jsr))&65535
/* QL:         dc.w    pa_cdtxt-M133_cd_jsr */
.balign 2,0
M133_dc_anchor_1045:
.word ((pa_cdtxt-M133_cd_jsr))&65535
/* QL:         dc.w    pa_cdlno-M133_cd_jsr */
.balign 2,0
M133_dc_anchor_1049:
.word ((pa_cdlno-M133_cd_jsr))&65535
/* QL: * d0 -  o- error code: negative parse failed, 0 ok or positive to reqest undo */
/* QL: * a0 -  o- input buffer, on ok return, it will be at the end of parsed text */
/* QL: * a2 -i  - start of graph tables */
/* QL: * a4 -  o- if parse failed, buffer location where we last had any luck */
/* QL: * a6 -ip - pointer to basic area */
/* QL: * d1-d6/a1/a3/a5 destroyed */
/* QL: * As far as is possible (so far) during the code, a2 holds the current */
/* QL: * backtrack stack pointer and a3, the token list pointer. */
/* QL: pa_graph */
pa_graph:
/* QL:         move.l  (a2)+,-(sp)     save keyword entry */
    move.l (a2)+,-(sp)
/* QL:         move.l  (a2),-(sp)      save graph table entry */
    move.l (a2),-(sp)
/* QL:         move.l  M133_bv_btbas(a6),M133_bv_btp(a6) reset backtrack pointer */
    move.l M133_bv_btbas(a6),M133_bv_btp(a6)
/* QL:         move.l  M133_bv_tkbas(a6),a3 get start of token list */
    move.l M133_bv_tkbas(a6),a3
/* QL:         move.l  a3,M133_bv_tkp(a6)   reset token list pointer */
    move.l a3,M133_bv_tkp(a6)
/* QL:         jsr     bv_chss(pc)     check enough room on ss for parser */
    jsr bv_chss(pc)
/* QL: *       moveq   #0,d7           set d7 to zero for ever (it's ok to drop this?) */
/* QL:         jsr     bv_chbt(pc)     a smidgen of space on the BT stack */
    jsr bv_chbt(pc)
/* QL:         subq.l  #8,M133_bv_btp(a6)   set up initial required bytes for top BF/TK */
    subq.l #8,M133_bv_btp(a6)
/* QL:         move.l  M133_bv_btp(a6),a2 */
    move.l M133_bv_btp(a6),a2
/* QL:         move.l  M133_bv_bfbas(a6),a0 set a0 to start of input buffer */
    move.l M133_bv_bfbas(a6),a0
/* QL:         move.l  a0,a4           set best so far */
    move.l a0,a4
/* QL:         moveq   #2,d6           first entry is start point for a line */
    moveq #2,d6
/* QL:         sub.l   a5,a5           marker for top of stack */
    sub.l a5,a5
/* QL: M133_morebt */
M133_morebt:
/* QL:         jsr     bv_chbt(pc) */
    jsr bv_chbt(pc)
/* QL:         move.l  M133_bv_btp(a6),a2 */
    move.l M133_bv_btp(a6),a2
/* QL: M133_graf1st */
M133_graf1st:
/* QL:         sub.w   #M133_elen,a2 */
    sub.w #M133_elen,a2
/* QL:         cmp.l   M133_bv_btp-4(a6),a2 */
    cmp.l (M133_bv_btp-4)(a6),a2
/* QL:         blt.s   M133_morebt */
    blt.s M133_morebt
/* QL:         move.l  a2,M133_bv_btp(a6) */
    move.l a2,M133_bv_btp(a6)
/* QL:         add.l   a5,a5           clear flag */
    add.l a5,a5
/* QL:         move.l  a5,M133_svgr(a6,a2.l) */
    move.l a5,M133_svgr(a6,a2.l)
/* QL:         move.l  (sp),a5         start of graphs */
    move.l (sp),a5
/* QL:         add.w   -2(a5,d6.w),a5  set new graph offset */
    add.w (-2)(a5,d6.w),a5
/* QL:         bra.s   M133_newposs */
    bra.s M133_newposs
/* QL: M133_code1st */
M133_code1st:
/* QL:         bmi.s   M133_symb1st */
    bmi.s M133_symb1st
/* QL: * Bits 7-5 clear, posibility is a coded atom */
/* QL:         move.l  4(sp),a2        point to keywords as code might be a name */
    move.l 4(sp),a2
/* QL:         lsr.b   #3,d6 */
    lsr.b #3,d6
/* QL:         add.b   d6,d6 */
    add.b d6,d6
/* QL:         move.w  M133_cd_tab-2(pc,d6.w),d6 get code offset */
    move.w (M133_cd_tab-2)(pc,d6.w),d6
/* QL: M133_cd_jsr */
M133_cd_jsr:
/* QL:         jsr     M133_cd_jsr(pc,d6.w) go do requested routine */
    jsr M133_cd_jsr(pc,d6.w)
/* QL:         bra.s   M133_fail1st */
    bra.s M133_fail1st
/* QL:         bra.s   M133_ok1st */
    bra.s M133_ok1st
/* QL: M133_kywd1st */
M133_kywd1st:
/* QL:         lsl.b   #2,d6 */
    lsl.b #2,d6
/* QL:         bcc.s   M133_code1st */
    bcc.s M133_code1st
/* QL: * Bit 6 set, possibility is a keyword */
/* QL:         move.l  4(sp),a2        start of keywords */
    move.l 4(sp),a2
/* QL:         lsr.b   #3,d6           put keyword number straight */
    lsr.b #3,d6
/* QL:         jsr     pa_kywrd(pc)    see if it matches */
    jsr pa_kywrd(pc)
/* QL:         bra.s   M133_fail1st         nope - too bad */
    bra.s M133_fail1st
/* QL:         moveq   #M133_b.key,d4       keyword token */
    moveq #M133_b.key,d4
/* QL:         move.b  d6,d5           keyword number */
    move.b d6,d5
/* QL:         bra.s   M133_tok1st */
    bra.s M133_tok1st
/* QL: M133_fail1st */
M133_fail1st:
/* QL:         move.l  M133_bv_btp(a6),a2   get BT pointer */
    move.l M133_bv_btp(a6),a2
/* QL:         movem.l M133_svbf(a6,a2.l),a0/a3 move buffer and token pointers back */
    movem.l M133_svbf(a6,a2.l),a0/a3
/* QL:         move.l  a3,M133_bv_tkp(a6)   set token position, in case it moved... */
    move.l a3,M133_bv_tkp(a6)
/* QL: M133_skp2nd */
M133_skp2nd:
/* QL:         addq.l  #1,a5           look at next possibility */
    addq.l #1,a5
/* QL: M133_get1st */
M133_get1st:
/* QL:         moveq   #0,d6           clear all of d6 */
    moveq #0,d6
/* QL:         move.b  (a5)+,d6        put possibility into d6 */
    move.b (a5)+,d6
/* QL:         beq.s   M133_eoposs          if end of possibilities, go back */
    beq.s M133_eoposs
/* QL:         bpl.s   M133_kywd1st */
    bpl.s M133_kywd1st
/* QL: * Bit 7 set, possibility is an exit or graph */
/* QL:         and.b   #$7e,d6         clear bits 7 and 0 */
    and.b #(0x7e&255),d6
/* QL:         bne.s   M133_graf1st         go do it if it's a real graph */
    bne.s M133_graf1st
/* QL:         movem.l a0/a3,M133_svbf+M133_elen(a6,a2.l) record exit buffer and token pointers */
    movem.l a0/a3,(M133_svbf+M133_elen)(a6,a2.l)
/* QL:         bset    d6,M133_flge(a6,a2.l) mark this as a possible exit */
    bset d6,M133_flge(a6,a2.l)
/* QL:         bra.s   M133_get1st          carry on */
    bra.s M133_get1st
/* QL: M133_symb1st */
M133_symb1st:
/* QL: * Bit 5 set, possibility is a symbol */
/* QL:         lsr.b   #3,d6           get actual symbol number (+16) */
    lsr.b #3,d6
/* QL:         move.b  0(a6,a0.l),d1   next char in buffer */
    move.b 0(a6,a0.l),d1
/* QL:         cmp.b   pa_tbsym-1-16(pc,d6.w),d1 is character the required symbol? */
    cmp.b ((pa_tbsym-1)-16)(pc,d6.w),d1
/* QL:         bne.s   M133_skp2nd          no - just skip it */
    bne.s M133_skp2nd
/* QL:         addq.l  #1,a0           move past the character */
    addq.l #1,a0
/* QL:         moveq   #M133_b.sym,d4       symbol token */
    moveq #M133_b.sym,d4
/* QL:         moveq   #15,d5 */
    moveq #15,d5
/* QL:         and.b   d6,d5           symbol number */
    and.b d6,d5
/* QL: M133_tok1st */
M133_tok1st:
/* QL:         jsr     pa_tok1(pc)     put the two byte token in the list */
    jsr pa_tok1(pc)
/* QL: M133_ok1st */
M133_ok1st:
/* QL:         move.l  M133_bv_btp(a6),a2 */
    move.l M133_bv_btp(a6),a2
/* QL: M133_get2nd */
M133_get2nd:
/* QL:         move.b  (a5),d6         look at linked position */
    move.b (a5),d6
/* QL:         beq.s   M133_isexit          if zero, graph is completed ok */
    beq.s M133_isexit
/* QL: M133_do2nd */
M133_do2nd:
/* QL:         ext.w   d6              make byte 2 into a word offset */
    ext.w d6
/* QL:         add.w   d6,a5           move to linked position */
    add.w d6,a5
/* QL: M133_newposs */
M133_newposs:
/* QL:         cmp.b   #' ',0(a6,a0.l) are we at a space? */
    cmp.b #(32&255),0(a6,a0.l)
/* QL:         bne.s   M133_nospace */
    bne.s M133_nospace
/* QL:         jsr     pa_cdspc(pc)    tokenise any preceeding spaces */
    jsr pa_cdspc(pc)
/* QL:         move.l  M133_bv_btp(a6),a2   this can have moved... annoying */
    move.l M133_bv_btp(a6),a2
/* QL: M133_nospace */
M133_nospace:
/* QL:         movem.l a0/a3,M133_svbf(a6,a2.l) remember where we are in buffer and tokens */
    movem.l a0/a3,M133_svbf(a6,a2.l)
/* QL:         bra.s   M133_get1st          go work on it */
    bra.s M133_get1st
/* QL: M133_eoposs */
M133_eoposs:
/* QL:         cmp.l   a0,a4 */
    cmp.l a0,a4
/* QL:         bgt.s   M133_popout */
    bgt.s M133_popout
/* QL:         move.l  a0,a4           remember best in the buffer we got to */
    move.l a0,a4
/* QL: M133_popout */
M133_popout:
/* QL:         add.w   #M133_elen,a2 */
    add.w #M133_elen,a2
/* QL:         move.l  a2,M133_bv_btp(a6)   set backtrack stack level  */
    move.l a2,M133_bv_btp(a6)
/* QL:         movem.l M133_svbf-4(a6,a2.l),d0/a0/a3 pick up saved GR/BF/TK pointers */
    movem.l (M133_svbf-4)(a6,a2.l),d0/a0/a3
/* QL:         move.l  a3,M133_bv_tkp(a6)   reset token list to this point */
    move.l a3,M133_bv_tkp(a6)
/* QL:         lsr.l   #1,d0           have we seen a possible exit? */
    lsr.l #1,d0
/* QL:         move.l  d0,a5 */
    move.l d0,a5
/* QL:         bcs.s   M133_qdone           yes, steam ahead, if we haven't finished */
    bcs.s M133_qdone
/* QL:         bne.s   M133_skp2nd          not at top, go fail this one */
    bne.s M133_skp2nd
/* QL:         moveq   #-1,d0          we are at the top, so the parse has failed */
    moveq #(-1),d0
/* QL:         bra.s   M133_parsex */
    bra.s M133_parsex
/* QL: M133_isexit */
M133_isexit:
/* QL:         add.w   #M133_elen,a2        graph matched, so pop return point */
    add.w #M133_elen,a2
/* QL:         move.l  a2,M133_bv_btp(a6)   set backtrack stack to new position */
    move.l a2,M133_bv_btp(a6)
/* QL:         move.l  M133_svbf-4(a6,a2.l),d0 pick up old graph position */
    move.l (M133_svbf-4)(a6,a2.l),d0
/* QL:         lsr.l   #1,d0           is that now zero? */
    lsr.l #1,d0
/* QL:         move.l  d0,a5 */
    move.l d0,a5
/* QL: M133_qdone */
M133_qdone:
/* QL:         bne.s   M133_get2nd          no - go down 2nd byte, otherwise completed ok! */
    bne.s M133_get2nd
/* QL: M133_parsex */
M133_parsex:
/* QL:         addq.l  #8,sp */
    addq.l #8,sp
/* QL: M133_pa_ini ; just so people who call this don't get confused! */
M133_pa_ini:
/* QL:         rts */
    rts 
/* QL: pa_tbsym dc.b '=:#,(){} ',10 symbols including line feed */
pa_tbsym:
M133_dc_anchor_1300:
.byte 61,58,35,44,40,41,123,125,32
.byte (10)&255
/* QL:         vect4000 pa_graph,M133_pa_ini */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ pa$graph,(pa_graph-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ pa$ini,(M133_pa_ini-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
