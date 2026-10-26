/* ROM section bp_grafx */
.balign 2,0
/* QL: M42_etc_1 */
M42_etc_1:
/* QL:         add.b   #M42_sd.point,d7    make up the genuine trap code (bits 6..0) */
    add.b #(M42_sd.point&255),d7
/* QL:         ror.w   #8,d7           hide in msb, also lastsep = none */
    ror.w #8,d7
/* QL:         sf      d5              nextsep = none */
    sf d5
/* QL:         move.l  a5,d6           save a5 (smashed by M42_get_fp) */
    move.l a5,d6
/* QL:         moveq   #15,d0 */
    moveq #15,d0
/* QL:         and.b   1(a6,a3.l),d0 */
    and.b 1(a6,a3.l),d0
/* QL:         bne.s   M42_notnull         if first param is null then */
    bne.s M42_notnull
/* QL:         jsr     bp_gsep(pc)     skip it, getting separator */
    jsr bp_gsep(pc)
/* QL:         move.b  d5,d7           lastsep = nextsep */
    move.b d5,d7
/* QL:         bra.s   M42_nohash          else */
    bra.s M42_nohash
/* QL: M42_notnull */
M42_notnull:
/* QL:         tst.b   1(a6,a3.l) */
    tst.b 1(a6,a3.l)
/* QL:         bpl.s   M42_nohash          if there's a hash then */
    bpl.s M42_nohash
/* QL:         move.b  1(a6,a3.l),d7   get the separator first */
    move.b 1(a6,a3.l),d7
/* QL:         add.b   d7,d7           only without the hash flag */
    add.b d7,d7
/* QL:         lsr.b   #5,d7           and in the right place, too */
    lsr.b #5,d7
/* QL: M42_nohash */
M42_nohash:
/* QL:         jsr     bp_chan(pc)     get the channel number */
    jsr bp_chan(pc)
/* QL:         lea     M42_ch.lench(a2),a4 for execution blocks */
    lea M42_ch.lench(a2),a4
/* QL:         move.l  (sp)+,a2        save our return address for looping */
    move.l (sp)+,a2
/* QL:         bne.s   M42_rts0            propagate any error */
    bne.s M42_rts0
/* QL:         moveq   #127,d1 */
    moveq #127,d1
/* QL:         add.w   d1,d1 */
    add.w d1,d1
/* QL:         jsr     bv_chrix(pc)    allocate some space on the stack (too much?) */
    jsr bv_chrix(pc)
/* QL:         move.l  M42_bv_rip(a6),d4 */
    move.l M42_bv_rip(a6),d4
/* QL:         sub.l   M42_bv_ribas(a6),d4 save original M42_bv_rip offset */
    sub.l M42_bv_ribas(a6),d4
/* QL: M42_go_loop */
M42_go_loop:
/* QL:         move.l  d4,a1 */
    move.l d4,a1
/* QL:         add.l   M42_bv_ribas(a6),a1 set pointer to original M42_bv_rip */
    add.l M42_bv_ribas(a6),a1
/* QL:         move.l  a1,M42_bv_rip(a6) */
    move.l a1,M42_bv_rip(a6)
/* QL:         jmp     (a2) */
    jmp (a2)
/* QL: bp_gcur */
bp_gcur:
/* QL:         addq.b  #M42_sd.gcur-M42_sd.point,d7 set graphics position */
.word 20487|((((M42_sd.gcur-M42_sd.point))&7)<<9)
/* QL:         bsr.s   M42_etc */
    bsr.s M42_etc
/* QL:         jsr     ca_gtfp(pc)     absorb all the parameters */
    jsr ca_gtfp(pc)
/* QL:         bne.s   M42_rts0 */
    bne.s M42_rts0
/* QL:         move.l  a3,d6           say we've taken them all */
    move.l a3,d6
/* QL: * A bug in JS means that people had to call CURSOR with exactly four parameters */
/* QL: * to get here. If there was a #channel at the front, they could only give three */
/* QL: * of the required four parameters and had to hope that the RI stack happened */
/* QL: * to have a zero next! However, in true JS fashion, this seems to have been the */
/* QL: * case... so to cope with people wangling their way around the JS bug, the */
/* QL: * correct check for exactly four parameters has been replaced with this check */
/* QL: * that at least validates there to be no more than four parameters: */
/* QL:         subq.w  #4,d3           did we get just four? (or JS bug three) */
    subq.w #4,d3
/* QL:         bhi.s   M42_err_bp          nope - that's not our problem */
    bhi.s M42_err_bp
/* QL: M42_dotrap */
M42_dotrap:
/* QL:         move.w  d7,d0           move trap vector into d0 */
    move.w d7,d0
/* QL:         ror.w   #8,d0           get it into ls byte */
    ror.w #8,d0
/* QL:         moveq   #-1,d3 */
    moveq #(-1),d3
/* QL:         trap    #4 */
    trap #4
/* QL:         trap    #3              draw the figure */
    trap #3
/* QL: M42_loop */
M42_loop:
/* QL:         move.b  d5,d7           lastsep = nextsep */
    move.b d5,d7
/* QL:         cmp.l   d6,a3 */
    cmp.l d6,a3
/* QL:         blt.s   M42_go_loop         if params left then M42_loop */
    blt.s M42_go_loop
/* QL: M42_rts0 */
M42_rts0:
/* QL:         rts */
    rts 
/* QL: bp_scale */
bp_scale:
/* QL:         addq.b  #M42_sd.scale-M42_sd.point,d7 */
.word 20487|((((M42_sd.scale-M42_sd.point))&7)<<9)
/* QL:         bsr.s   M42_etc     scale (ch#,) */
    bsr.s M42_etc
/* QL:         bsr.s   M42_get2fp          s,x, */
    bsr.s M42_get2fp
/* QL:         bra.s   M42_g1dotrap                y */
    bra.s M42_g1dotrap
/* QL: M42_etc */
M42_etc:
/* QL:         cmp.l   a5,a3 */
    cmp.l a5,a3
/* QL:         blt.s   M42_etc_1           continue if there is at least one parameter */
    blt.s M42_etc_1
/* QL:         addq.l  #4,sp           drop return address */
    addq.l #4,sp
/* QL: M42_err_bp */
M42_err_bp:
/* QL:         moveq   #M42_err.bp,d0 */
    moveq #M42_err.bp,d0
/* QL:         rts */
    rts 
/* QL: bp_poinr */
bp_poinr:
/* QL:         tas     d7 */
    tas d7
/* QL: bp_point */
bp_point:
/* QL:         bsr.s   M42_etc     point (ch#,) */
    bsr.s M42_etc
/* QL:         bra.s   M42_gcdotrap        x,y */
    bra.s M42_gcdotrap
/* QL: bp_liner */
bp_liner:
/* QL:         tas     d7 */
    tas d7
/* QL: bp_line */
bp_line:
/* QL:         addq.b  #M42_sd.line-M42_sd.point,d7 */
.word 20487|((((M42_sd.line-M42_sd.point))&7)<<9)
/* QL:         bsr.s   M42_etc     line (ch#,) */
    bsr.s M42_etc
/* QL:         bsr.s   M42_chkto */
    bsr.s M42_chkto
/* QL:         beq.s   M42_loop            either: x,y (don't plot) */
    beq.s M42_loop
/* QL: M42_gcdotrap */
M42_gcdotrap:
/* QL:         bsr.s   M42_getcords */
    bsr.s M42_getcords
/* QL:         bra.s   M42_dotrap          or:     TO x,y (plot) */
    bra.s M42_dotrap
/* QL: bp_arcr */
bp_arcr:
/* QL:         tas     d7 */
    tas d7
/* QL: bp_arc */
bp_arc:
/* QL:         addq.b  #M42_sd.arc-M42_sd.point,d7 */
.word 20487|((((M42_sd.arc-M42_sd.point))&7)<<9)
/* QL:         bsr.s   M42_etc             arc (ch#,) */
    bsr.s M42_etc
/* QL:         bsr.s   M42_chkto                   TO (or) x,y, */
    bsr.s M42_chkto
/* QL:         bsr.s   M42_getcords                        x,y, then ang */
    bsr.s M42_getcords
/* QL: M42_g1dotrap */
M42_g1dotrap:
/* QL:         bsr.s   M42_get1fp */
    bsr.s M42_get1fp
/* QL: M42_dotrap_1 */
M42_dotrap_1:
/* QL:         bra.s   M42_dotrap */
    bra.s M42_dotrap
/* QL: bp_circr */
bp_circr:
/* QL: bp_ellir */
bp_ellir:
/* QL:         tas     d7 */
    tas d7
/* QL: bp_circe */
bp_circe:
/* QL: bp_ellie */
bp_ellie:
/* QL:         addq.b  #M42_sd.elips-M42_sd.point,d7 */
.word 20487|((((M42_sd.elips-M42_sd.point))&7)<<9)
/* QL:         bsr.s   M42_etc             ellipse (ch#,) */
    bsr.s M42_etc
/* QL:         bsr.s   M42_getcords                x,y, */
    bsr.s M42_getcords
/* QL:         bsr.s   M42_get1fp                          hgt */
    bsr.s M42_get1fp
/* QL:         cmp.b   #M42_b.sepcom,d5 */
    cmp.b #(M42_b.sepcom&255),d5
/* QL:         bne.s   M42_notcom */
    bne.s M42_notcom
/* QL:         bsr.s   M42_get2fp                  if comma then:  ,ecc,rot */
    bsr.s M42_get2fp
/* QL:         bra.s   M42_doswap */
    bra.s M42_doswap
/* QL: M42_notcom */
M42_notcom:
/* QL:         jsr     ri_one(pc)              ecc=1 (a circle) */
    jsr ri_one(pc)
/* QL:         jsr     ri_zero(pc)             rot=0 */
    jsr ri_zero(pc)
/* QL: M42_doswap */
M42_doswap:
/* QL:         jsr     ri_roll(pc)             x,y,hgt,ecc,rot -> x,y,ecc,rot,hgt */
    jsr ri_roll(pc)
/* QL:         jsr     ri_swap(pc)             x,y,ecc,rot,hgt -> x,y,ecc,hgt,rot */
    jsr ri_swap(pc)
/* QL:         bra.s   M42_dotrap_1 */
    bra.s M42_dotrap_1
/* QL: M42_get2fp */
M42_get2fp:
/* QL:         bsr.s   M42_get_fp          get floating point parameter */
    bsr.s M42_get_fp
/* QL:         bne.s   M42_exit_fp */
    bne.s M42_exit_fp
/* QL: M42_get1fp */
M42_get1fp:
/* QL:         bsr.s   M42_get_fp          get (another) floating point parameter */
    bsr.s M42_get_fp
/* QL:         bne.s   M42_exit_fp */
    bne.s M42_exit_fp
/* QL:         rts */
    rts 
/* QL: M42_chkto */
M42_chkto:
/* QL:         cmp.b   #M42_b.septo,d7 */
    cmp.b #(M42_b.septo&255),d7
/* QL:         bne.s   M42_getcords        if lastsep <> 'TO' then getcoords */
    bne.s M42_getcords
/* QL:         moveq   #M42_getblk-M42_savblk,d0 */
    moveq #(M42_getblk-M42_savblk),d0
/* QL:         bsr.s   M42_execb           else use ccp */
    bsr.s M42_execb
/* QL:         move.l  a1,M42_bv_rip(a6)   update M42_bv_rip, return 'TO' (z clear, as a1<>0) */
    move.l a1,M42_bv_rip(a6)
/* QL:         rts */
    rts 
/* QL: M42_getcords */
M42_getcords:
/* QL:         bsr.s   M42_get_fp          get x coord */
    bsr.s M42_get_fp
/* QL:         bne.s   M42_exit_fp */
    bne.s M42_exit_fp
/* QL:         bsr.s   M42_get_fp          get y coord */
    bsr.s M42_get_fp
/* QL:         bne.s   M42_exit_fp */
    bne.s M42_exit_fp
/* QL:         tst.w   d7 */
    tst.w d7
/* QL:         bpl.s   M42_execb */
    bpl.s M42_execb
/* QL:         moveq   #M42_relblk-M42_savblk,d0 */
    moveq #(M42_relblk-M42_savblk),d0
/* QL: M42_execb */
M42_execb:
/* QL:         move.l  a3,-(sp) */
    move.l a3,-(sp)
/* QL:         lea     M42_savblk(pc,d0.w),a3 */
    lea M42_savblk(pc,d0.w),a3
/* QL:         jsr     ri_execb(pc) */
    jsr ri_execb(pc)
/* QL:         move.l  (sp)+,a3 */
    move.l (sp)+,a3
/* QL:         rts                     return 'not TO' (assume no error) */
    rts 
/* QL: M42_get_fp */
M42_get_fp:
/* QL:         cmp.l   d6,a3 */
    cmp.l d6,a3
/* QL:         bge.l   M42_err_bp          return bad parameter if no args left */
    bge.w M42_err_bp
/* QL:         move.l  a4,-(sp) */
    move.l a4,-(sp)
/* QL:         move.b  d5,d7           lastsep = nextsep */
    move.b d5,d7
/* QL:         jsr     bp_gsep(pc)     get next separator */
    jsr bp_gsep(pc)
/* QL:         move.l  a3,a5 */
    move.l a3,a5
/* QL:         jsr     ca_etos(pc)     evaluate parameter to top of stack */
    jsr ca_etos(pc)
/* QL:         bne.s   M42_exit_fp */
    bne.s M42_exit_fp
/* QL:         moveq   #M42_t.fp,d0 */
    moveq #M42_t.fp,d0
/* QL:         jsr     ca_cnvrt(pc)    convert to floating point */
    jsr ca_cnvrt(pc)
/* QL: M42_exit_fp */
M42_exit_fp:
/* QL:         move.l  (sp)+,a4 */
    move.l (sp)+,a4
/* QL:         rts */
    rts 
/* QL: M42_ccpx    equ     M42_ch.ccpx-M42_ch.lench */
.equ M42_ccpx,(M42_ch.ccpx-M42_ch.lench)
/* QL: M42_ccpy    equ     M42_ch.ccpy-M42_ch.lench */
.equ M42_ccpy,(M42_ch.ccpy-M42_ch.lench)
/* QL: M42_relblk */
M42_relblk:
/* QL:  dc.b M42_ri.swap,M42_ccpx,M42_ri.add,M42_ri.swap       make relative x absolute */
M42_dc_anchor_1696:
.byte (M42_ri.swap)&255
.byte (M42_ccpx)&255
.byte (M42_ri.add)&255
.byte (M42_ri.swap)&255
/* QL:  dc.b M42_ccpy,M42_ri.add                       make relative y absolute */
M42_dc_anchor_1702:
.byte (M42_ccpy)&255
.byte (M42_ri.add)&255
/* QL: M42_savblk */
M42_savblk:
/* QL:  dc.b M42_ri.over,M42_ri.store+M42_ccpx             save M42_ccpx */
M42_dc_anchor_1708:
.byte (M42_ri.over)&255
.byte ((M42_ri.store+M42_ccpx))&255
/* QL:  dc.b M42_ri.dup,M42_ri.store+M42_ccpy,M42_ri.term      save M42_ccpy */
M42_dc_anchor_1712:
.byte (M42_ri.dup)&255
.byte ((M42_ri.store+M42_ccpy))&255
.byte (M42_ri.term)&255
/* QL: M42_getblk */
M42_getblk:
/* QL:  dc.b M42_ccpx,M42_ccpy,M42_ri.term                 get M42_ccpx, M42_ccpy */
M42_dc_anchor_1719:
.byte (M42_ccpx)&255
.byte (M42_ccpy)&255
.byte (M42_ri.term)&255
/* QL:         end */
