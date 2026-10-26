/* ROM section bp_stop */
.balign 2,0
/* QL: bp_retry */
bp_retry:
/* QL:         subq.b  #1,M48_bv_cnstm(a6) redo the last statement */
    subq.b #1,M48_bv_cnstm(a6)
/* QL:         bge.s   bp_conte        assuming it's non zero! */
    bge.s bp_conte
/* QL:         sf      M48_bv_cnstm(a6)    start at beginning then */
    sf M48_bv_cnstm(a6)
/* QL: bp_conte */
bp_conte:
/* QL:         bsr.s   M48_optlin */
    bsr.s M48_optlin
/* QL:         beq.s   bp_conti */
    beq.s bp_conti
/* QL:         move.w  d4,M48_bv_cnlno(a6) set continue line number */
    move.w d4,M48_bv_cnlno(a6)
/* QL:         sf      M48_bv_cnstm(a6)    statement zero */
    sf M48_bv_cnstm(a6)
/* QL:         clr.w   M48_bv_cnind(a6)    no in-line index */
    clr.w M48_bv_cnind(a6)
/* QL:         sf      M48_bv_cninl(a6)    not in-line */
    sf M48_bv_cninl(a6)
/* QL: bp_conti */
bp_conti:
/* QL:         sf      M48_bv_wherr(a6)    set when off again */
    sf M48_bv_wherr(a6)
/* QL:         moveq   #M48_s.retry-M48_s.stop,d7 */
    moveq #(M48_s.retry-M48_s.stop),d7
/* QL: bp_stop */
bp_stop:
/* QL:         addq.b  #M48_s.stop-M48_s.new,d7 */
.word 20487|((((M48_s.stop-M48_s.new))&7)<<9)
/* QL: bp_new */
bp_new:
/* QL:         addq.b  #M48_s.new,d7 */
    addq.b #M48_s.new,d7
/* QL: M48_stops */
M48_stops:
/* QL:         moveq   #-1,d4 */
    moveq #(-1),d4
/* QL:         bra.s   M48_setnxl */
    bra.s M48_setnxl
/* QL: bp_run */
bp_run:
/* QL:         moveq   #M48_s.run,d7 */
    moveq #M48_s.run,d7
/* QL:         pea     M48_setnxs          d0=0, set to request 1st statement */
    pea M48_setnxs(pc)
/* QL: * d0 -  0- 0 */
/* QL: * d4 -  o- zero (ccr = z) or optional line number present (ccr gt). */
/* QL: * d1-d3 destroyed iff line number returned */
/* QL: M48_optlin */
M48_optlin:
/* QL:         moveq   #0,d4           default zero line number */
    moveq #0,d4
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         beq.s   M48_retok */
    beq.s M48_retok
/* QL:         jsr     ca_gtin1(pc) */
    jsr ca_gtin1(pc)
/* QL:         bne.s   M48_popex */
    bne.s M48_popex
/* QL:         move.w  0(a6,a1.l),d4   optional line number must be 1..32767 */
    move.w 0(a6,a1.l),d4
/* QL:         bgt.s   M48_rts1 */
    bgt.s M48_rts1
/* QL:         moveq   #M48_err.bp,d0 */
    moveq #M48_err.bp,d0
/* QL: M48_popex */
M48_popex:
/* QL:         addq.l  #4,sp           skip return address, no need to go back */
    addq.l #4,sp
/* QL: M48_rts1 */
M48_rts1:
/* QL:         rts */
    rts 
/* QL: bp_load */
bp_load:
/* QL:         pea     bp_lrun */
    pea bp_lrun(pc)
/* QL: M48_tstsing */
M48_tstsing:
/* QL:         tst.b   M48_bv_sing(a6)     if not single, load->lrun and merge->mrun */
    tst.b M48_bv_sing(a6)
/* QL:         beq.s   M48_rts1 */
    beq.s M48_rts1
/* QL:         assert  M48_s.load-M48_s.lrun,M48_s.merge-M48_s.mrun */
/* original assertion: M48_s.load-M48_s.lrun,M48_s.merge-M48_s.mrun */
/* QL:         addq.b  #M48_s.load-M48_s.lrun,d7 */
.word 20487|((((M48_s.load-M48_s.lrun))&7)<<9)
/* QL:         rts */
    rts 
/* QL: bp_merge */
bp_merge:
/* QL:         bsr.s   M48_tstsing         if not a single line, merge -> mrun */
    bsr.s M48_tstsing
/* QL: bp_mrun */
bp_mrun:
/* QL:         addq.b  #M48_s.mrun-M48_s.lrun,d7 */
.word 20487|((((M48_s.mrun-M48_s.lrun))&7)<<9)
/* QL:         bsr.s   bp_chunr        can't do merging if in proc/fn */
    bsr.s bp_chunr
/* QL: bp_lrun */
bp_lrun:
/* QL:         addq.b  #M48_s.lrun,d7 */
    addq.b #M48_s.lrun,d7
/* QL:         jsr     bp_fopin(pc) */
    jsr bp_fopin(pc)
/* QL:         bne.s   M48_rts1 */
    bne.s M48_rts1
/* QL:         bsr.s   bp_comch        set new command channel */
    bsr.s bp_comch
/* QL:         assert  0,M48_s.lrun-8,M48_s.load-10,M48_s.mrun-12,M48_s.merge-14 */
/* original assertion: 0,M48_s.lrun-8,M48_s.load-10,M48_s.mrun-12,M48_s.merge-14 */
/* QL:         move.w  d7,d4           00001ms0 m=merge, s=stop */
    move.w d7,d4
/* QL:         lsl.b   #6,d4           s0000000 c=merge */
    lsl.b #6,d4
/* QL:         bmi.s   M48_stops           load/merge: don't carry on at all */
    bmi.s M48_stops
/* QL:         bcc.s   M48_setnxl          lrun: run from top */
    bcc.s M48_setnxl
/* QL:         bra.s   M48_snglin          mrun: run from top if single line, else next */
    bra.s M48_snglin
/* QL: bp_clear */
bp_clear:
/* QL:         moveq   #-1,d4 */
    moveq #(-1),d4
/* QL: M48_snglin */
M48_snglin:
/* QL:         tst.b   M48_bv_sing(a6)     if single line, don't run anything */
    tst.b M48_bv_sing(a6)
/* QL:         bne.s   M48_setnxl */
    bne.s M48_setnxl
/* QL:         move.w  M48_bv_linum(a6),d4 continue running from current pos */
    move.w M48_bv_linum(a6),d4
/* QL:         move.b  M48_bv_stmnt(a6),d0 */
    move.b M48_bv_stmnt(a6),d0
/* QL: M48_setnxs */
M48_setnxs:
/* QL:         move.b  d0,M48_bv_nxstm(a6) */
    move.b d0,M48_bv_nxstm(a6)
/* QL: M48_setnxl */
M48_setnxl:
/* QL:         move.w  d4,M48_bv_nxlin(a6) */
    move.w d4,M48_bv_nxlin(a6)
/* QL:         sf      M48_bv_cont(a6) */
    sf M48_bv_cont(a6)
/* QL:         move.w  d7,M48_bv_stopn(a6) */
    move.w d7,M48_bv_stopn(a6)
/* QL: M48_retok */
M48_retok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: bp_chunr */
bp_chunr:
/* QL:         move.l  M48_bv_rtp(a6),d0 */
    move.l M48_bv_rtp(a6),d0
/* QL:         sub.l   M48_bv_rtbas(a6),d0 */
    sub.l M48_bv_rtbas(a6),d0
/* QL:         beq.s   M48_rts1            fine if nothing on return stack */
    beq.s M48_rts1
/* QL:         tst.b   M48_bv_sing(a6) */
    tst.b M48_bv_sing(a6)
/* QL:         sne     M48_bv_undo(a6)     if single line, undo, and try again */
    sne M48_bv_undo(a6)
/* QL:         moveq   #M48_err.ni,d0      if in prog, say not implemented */
    moveq #M48_err.ni,d0
/* QL:         bra.s   M48_popex */
    bra.s M48_popex
/* QL: * d0 -  o- 0 (ccr set) */
/* QL: * a0 -ip - new channel ID to put in comch */
/* QL: * a1 destroyed */
/* QL: bp_comch */
bp_comch:
/* QL:         move.l  a0,-(sp) */
    move.l a0,-(sp)
/* QL:         move.l  M48_bv_comch(a6),d0 if current comch is non-zero, close it */
    move.l M48_bv_comch(a6),d0
/* QL:         beq.s   M48_comclr */
    beq.s M48_comclr
/* QL:         move.l  d0,a0 */
    move.l d0,a0
/* QL:         moveq   #M48_io.close,d0 */
    moveq #M48_io.close,d0
/* QL:         trap    #2 */
    trap #2
/* QL: M48_comclr */
M48_comclr:
/* QL:         move.l  (sp)+,M48_bv_comch(a6) */
    move.l (sp)+,M48_bv_comch(a6)
/* QL:         bra.s   M48_retok */
    bra.s M48_retok
/* QL:         end */
