/* ROM section bp_windw */
.balign 2,0
/* QL: * Colour parameter generator. */
/* QL: * Takes 1 to 3 items from stack and produces a byte containing M37_colour */
/* QL: * information in the standard format. No return on error. */
/* QL: M37_colour */
M37_colour:
/* QL:         bsr.s   M37_pickup          get final parameter */
    bsr.s M37_pickup
/* QL:         move.w  d2,d1 */
    move.w d2,d1
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         beq.s   M37_chk_256         if one parameter then exit */
    beq.s M37_chk_256
/* QL:         moveq   #8,d0 */
    moveq #8,d0
/* QL:         cmp.w   d0,d1 */
    cmp.w d0,d1
/* QL:         bcc.s   M37_err_pop         error if not in 0..7 */
    bcc.s M37_err_pop
/* QL:         moveq   #3<<3,d2        default stipple is three */
    moveq #(3<<3),d2
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         beq.s   M37_col_2p          only two parameters */
    beq.s M37_col_2p
/* QL:         lsl.w   #3,d1           last was actually stipple pattern, shift it */
    lsl.w #3,d1
/* QL:         bsr.s   M37_pickup          get contrast M37_colour */
    bsr.s M37_pickup
/* QL:         bcc.s   M37_err_pop         error if not in 0..7 */
    bcc.s M37_err_pop
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bne.s   M37_err_pop         error if not 1..3 parameters */
    bne.s M37_err_pop
/* QL: M37_col_2p */
M37_col_2p:
/* QL:         or.w    d2,d1           combine stipple and M37_colour */
    or.w d2,d1
/* QL:         bsr.s   M37_pickup          get background M37_colour */
    bsr.s M37_pickup
/* QL:         bcc.s   M37_err_pop */
    bcc.s M37_err_pop
/* QL:         eor.w   d2,d1 */
    eor.w d2,d1
/* QL:         lsl.w   #3,d1 */
    lsl.w #3,d1
/* QL:         or.w    d2,d1           bodge background in */
    or.w d2,d1
/* QL: M37_chk_256 */
M37_chk_256:
/* QL:         cmp.w   #256,d1         check single parameter 0..255 or stipple 0..3 */
    cmp.w #256,d1
/* QL:         bcs.s   M37_rts0 */
    bcs.s M37_rts0
/* QL: M37_err_pop */
M37_err_pop:
/* QL:         moveq   #M37_err.bp,d0 */
    moveq #M37_err.bp,d0
/* QL: M37_pop_ret */
M37_pop_ret:
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL: M37_rts0 */
M37_rts0:
/* QL:         rts */
    rts 
/* QL: * BLOCK{#chan;}width,height,x,y{,<M37_colour>} */
/* QL: bp_block */
bp_block:
/* QL:         moveq   #M37_sd.fill-M37_sd.bordr,d7     fill a block */
    moveq #(M37_sd.fill-M37_sd.bordr),d7
/* QL: * BORDER{#chan;}{border{,<M37_colour>}} */
/* QL: bp_bordr */
bp_bordr:
/* QL:         subq.b  #M37_sd.wdef-M37_sd.bordr,d7 redefine a border only */
.word 20743|((((M37_sd.wdef-M37_sd.bordr))&7)<<9)
/* QL: * WINDOW{#chan;}width,height,x,y{,border{,<M37_colour>}} */
/* QL: bp_windw */
bp_windw:
/* QL:         bsr.s   M37_iparm */
    bsr.s M37_iparm
/* QL:         moveq   #0,d2           default width is zero */
    moveq #0,d2
/* QL:         moveq   #-128,d1        default M37_colour is transparent (BLOCK=black) */
    moveq #(-128),d1
/* QL:         add.b   #M37_sd.wdef,d7 */
    add.b #(M37_sd.wdef&255),d7
/* QL:         bcs.s   M37_brdr */
    bcs.s M37_brdr
/* QL:         subq.w  #4,d3 */
    subq.w #4,d3
/* QL:         beq.s   M37_blk_mod */
    beq.s M37_blk_mod
/* QL:         assert  0,1-1&M37_sd.wdef,1&M37_sd.fill */
/* original assertion: 0,1-1&M37_sd.wdef,1&M37_sd.fill */
/* QL:         btst    d2,d7 */
    btst d2,d7
/* QL:         bne.s   M37_brdr */
    bne.s M37_brdr
/* QL:         bsr.s   M37_colour */
    bsr.s M37_colour
/* QL:         bra.s   M37_blk_mod */
    bra.s M37_blk_mod
/* QL: M37_brdr */
M37_brdr:
/* QL:         subq.w  #1,d3           correct range for M37_colour parameters */
    subq.w #1,d3
/* QL:         bcs.s   M37_blk_mod         if no parameters, full default */
    bcs.s M37_blk_mod
/* QL:         beq.s   M37_bord_w          if no M37_colour then 'transparent' */
    beq.s M37_bord_w
/* QL:         bsr.s   M37_colour          get M37_colour */
    bsr.s M37_colour
/* QL: M37_bord_w */
M37_bord_w:
/* QL:         bsr.s   M37_pickup          get width */
    bsr.s M37_pickup
/* QL: M37_blk_mod */
M37_blk_mod:
/* QL:         subq.l  #4*2,a1 */
    subq.l #(4*2),a1
/* QL:         bra.s   M37_trap4d7 */
    bra.s M37_trap4d7
/* QL: M37_pickup */
M37_pickup:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  0(a6,a1.l),d2   get contrast/background M37_colour */
    move.w 0(a6,a1.l),d2
/* QL:         cmp.w   d0,d2 */
    cmp.w d0,d2
/* QL:         rts */
    rts 
/* QL: * RECOL{#chan;}p0,p1,p2,p3,p4,p5,p6,p7 pn are replacement colours for M37_colour n */
/* QL: bp_recol */
bp_recol:
/* QL:         bsr.s   M37_iparm */
    bsr.s M37_iparm
/* QL:         subq.w  #8,d3           must have 8 parameters */
    subq.w #8,d3
/* QL:         bne.s   M37_err_bp */
    bne.s M37_err_bp
/* QL:         move.l  a1,a2 */
    move.l a1,a2
/* QL:         moveq   #8-1,d0 */
    moveq #(8-1),d0
/* QL: M37_tr_loop */
M37_tr_loop:
/* QL:         subq.l  #2,a2 */
    subq.l #2,a2
/* QL:         subq.l  #1,a1 */
    subq.l #1,a1
/* QL:         move.b  1(a6,a2.l),0(a6,a1.l) compress words to bytes */
    move.b 1(a6,a2.l),0(a6,a1.l)
/* QL:         dbra    d0,M37_tr_loop */
    dbra d0,M37_tr_loop
/* QL:         moveq   #M37_sd.recol,d7 */
    moveq #M37_sd.recol,d7
/* QL: M37_trap4d7 */
M37_trap4d7:
/* QL:         trap    #4              it's rel a6 (all bar BORDER need this) */
    trap #4
/* QL:         bra.s   M37_trap3d7 */
    bra.s M37_trap3d7
/* QL: * WIDTH{#chan;}charsperline */
/* QL: bp_width */
bp_width:
/* QL:         bsr.s   M37_iparm           get integer parameters */
    bsr.s M37_iparm
/* QL:         subq.w  #1,d3           ... just one */
    subq.w #1,d3
/* QL:         bne.s   M37_err_bp */
    bne.s M37_err_bp
/* QL:         move.w  d2,M37_ch.width(a6,a2.l) set width */
    move.w d2,M37_ch.width(a6,a2.l)
/* QL:         rts */
    rts 
/* QL: * PAPER{#chan;}<M37_colour> */
/* QL: bp_paper */
bp_paper:
/* QL:         subq.b  #M37_sd.setin-M37_sd.setpa,d7 */
.word 20743|((((M37_sd.setin-M37_sd.setpa))&7)<<9)
/* QL: * INK{#chan;}<M37_colour> */
/* QL: bp_ink */
bp_ink:
/* QL:         addq.b  #M37_sd.setin-M37_sd.setst,d7 */
.word 20487|((((M37_sd.setin-M37_sd.setst))&7)<<9)
/* QL: * STRIP{#chan;}<M37_colour> */
/* QL: bp_strip */
bp_strip:
/* QL:         bsr.s   M37_iparm */
    bsr.s M37_iparm
/* QL:         bsr.l   M37_colour          turn parameter(s) into M37_colour */
    bsr.w M37_colour
/* QL: M37_setxx */
M37_setxx:
/* QL:         moveq   #M37_sd.setst,d0    if paper ... */
    moveq #M37_sd.setst,d0
/* QL:         add.b   d0,d7 */
    add.b d0,d7
/* QL:         bcc.s   M37_trap3d7 */
    bcc.s M37_trap3d7
/* QL:         bsr.s   M37_trap3d0         ... do strip first */
    bsr.s M37_trap3d0
/* QL: * d0 -  o- error code (ccr not set) */
/* QL: * d1 -i o- as per trap action */
/* QL: * d2 -i o- as per trap action */
/* QL: * d3 -  o- -1 */
/* QL: * d7 -ip - code for trap #3 */
/* QL: * a0 -ip - qdos channel id */
/* QL: * a1 -i  - as per trap action */
/* QL: M37_trap3d7 */
M37_trap3d7:
/* QL:         move.b  d7,d0           set operation key */
    move.b d7,d0
/* QL: M37_trap3d0 */
M37_trap3d0:
/* QL:         moveq   #-1,d3          infinite timeout */
    moveq #(-1),d3
/* QL:         trap    #3              perform it */
    trap #3
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code, with ccr set */
/* QL: * d1 -  o- last but one parameter */
/* QL: * d2 -  o- last parameter */
/* QL: * d3 -  o- number of parameters */
/* QL: * a0 -  o- qdos channel id */
/* QL: * a1 -  o- rel a6 pointer past last parameter */
/* QL: * a2 -  o- rel a6 pointer to channel table entry */
/* QL: * a3 -ip - start of nt entries for integer parameters */
/* QL: * a5 -ip - top of nt entries for integer parameters */
/* QL: M37_iparm */
M37_iparm:
/* QL:         jsr     bp_chan(pc)     get channel to a0 */
    jsr bp_chan(pc)
/* QL:         bne.s   M37_popretne        error if it doesn't work */
    bne.s M37_popretne
/* QL:         jsr     ca_gtint(pc)    call parameter routine */
    jsr ca_gtint(pc)
/* QL: M37_popretne */
M37_popretne:
/* QL:         bne.l   M37_pop_ret         error if anything fails */
    bne.w M37_pop_ret
/* QL:         add.l   d3,a1 */
    add.l d3,a1
/* QL:         add.l   d3,a1           point past last parameter */
    add.l d3,a1
/* QL:         movem.w -4(a6,a1.l),d1-d2 pick up last two parameters */
    movem.w (-4)(a6,a1.l),d1-d2
/* QL: M37_rts1 */
M37_rts1:
/* QL:         rts */
    rts 
/* QL: * OVER{#chan;}{flag} 0=ink on strip, 1=ink only, -1=ink xor (existing contents) */
/* QL: bp_over */
bp_over:
/* QL:         addq.b  #(M37_sd.setmd-M37_sd.setul)<<1!1,d7 */
.word 20487|((((((M37_sd.setmd-M37_sd.setul)<<1)|1))&7)<<9)
/* QL: * UNDER{#chan;}flag 0=off, 1=on. */
/* QL: bp_under */
bp_under:
/* QL:         addq.b  #(M37_sd.setul-M37_sd.setfl)<<1,d7 */
.word 20487|(((((M37_sd.setul-M37_sd.setfl)<<1))&7)<<9)
/* QL: * FLASH{#chan;}flag 0=off, 1=on. ignored in 512 mode. */
/* QL: bp_flash */
bp_flash:
/* QL:         addq.b  #(M37_sd.setfl-M37_sd.setst)<<1,d7 */
.word 20487|(((((M37_sd.setfl-M37_sd.setst)<<1))&7)<<9)
/* QL:         bsr.s   M37_iparm */
    bsr.s M37_iparm
/* QL:         move.w  d3,d1 */
    move.w d3,d1
/* QL:         beq.s   M37_setxx */
    beq.s M37_setxx
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bne.s   M37_err_bp */
    bne.s M37_err_bp
/* QL:         asr.b   #1,d7 */
    asr.b #1,d7
/* QL:         addx.b  d3,d3 */
    addx.b d3,d3
/* QL:         move.w  d2,d1 */
    move.w d2,d1
/* QL:         add.w   d3,d2 */
    add.w d3,d2
/* QL:         addq.w  #2,d3 */
    addq.w #2,d3
/* QL:         sub.w   d3,d2           error if not 0..1 or, for OVER, -1..1 */
    sub.w d3,d2
/* QL:         bcs.s   M37_setxx */
    bcs.s M37_setxx
/* QL: M37_err_bp */
M37_err_bp:
/* QL:         moveq   #M37_err.bp,d0 */
    moveq #M37_err.bp,d0
/* QL:         rts */
    rts 
/* QL: * FILL{#chan;}parameter */
/* QL: bp_fill */
bp_fill:
/* QL:         jsr     bp_chan(pc)     get channel number, if any */
    jsr bp_chan(pc)
/* QL:         bne.s   M37_rts1 */
    bne.s M37_rts1
/* QL:         jsr     ca_gtli1(pc)    get a single long integer to d1 */
    jsr ca_gtli1(pc)
/* QL:         bne.s   M37_rts1 */
    bne.s M37_rts1
/* QL:         moveq   #M37_sd.flood,d0 */
    moveq #M37_sd.flood,d0
/* QL:         bra.s   M37_trap3d0         go do it */
    bra.s M37_trap3d0
/* QL: * CSIZE{#chan;}width,height width 0..3, height 0..1 */
/* QL: * Note: in 256 mode width 0 or 1 will appear as 2 and 3 respectively */
/* QL: bp_csize */
bp_csize:
/* QL:         moveq   #(M37_sd.setsz-M37_sd.pos)&255,d7 */
    moveq #((M37_sd.setsz-M37_sd.pos)&255),d7
/* QL: * AT{#chan;}row,column */
/* QL: bp_at */
bp_at:
/* QL:         subq.b  #(M37_sd.pixp-M37_sd.pos),d7 */
.word 20743|((((M37_sd.pixp-M37_sd.pos))&7)<<9)
/* QL: M37_twopar */
M37_twopar:
/* QL:         bsr.s   M37_iparm */
    bsr.s M37_iparm
/* QL:         subq.w  #2,d3 */
    subq.w #2,d3
/* QL: M37_err_nebp */
M37_err_nebp:
/* QL:         bne.s   M37_err_bp          error if not two parameters */
    bne.s M37_err_bp
/* QL:         add.b   #M37_sd.pixp,d7     if it's AT ... */
    add.b #(M37_sd.pixp&255),d7
/* QL:         bcc.s   M37_trap3d7 */
    bcc.s M37_trap3d7
/* QL:         exg     d1,d2           ... definition is reversed */
    exg d1,d2
/* QL: M37_trap3d7a */
M37_trap3d7a:
/* QL:         bra.s   M37_trap3d7 */
    bra.s M37_trap3d7
/* QL: * CURSOR{#chan;}{xgraph,ygraph,}xpixel,ypixel */
/* QL: bp_cursr */
bp_cursr:
/* QL:         lea     4*8(a3),a4      are there less than four params? */
    lea (4*8)(a3),a4
/* QL:         cmp.l   a4,a5           (2 or 3 is what we're after) */
    cmp.l a4,a5
/* QL:         blt.s   M37_twopar          yes - it must be plain pixel position  */
    blt.s M37_twopar
/* QL:         jmp     bp_gcur(pc)     no - go do graphics */
    jmp bp_gcur(pc)
/* QL: * PAN{#chan;}distance{,screen section} */
/* QL: * SCROLL{#chan;}distance{,screen section} */
/* QL: * CLS{#chan;}{screen section} */
/* QL: * distance may be positive or negative */
/* QL: * screen section may be:- */
/* QL: * 0: whole screen (default) */
/* QL: * 1: top of window (not pan) */
/* QL: * 2: bottom of window (not pan) */
/* QL: * 3: cursor line (not scroll) */
/* QL: * 4: right hand end of cursor line (not scroll) */
/* QL: bp_cls */
bp_cls:
/* QL:         moveq   #(M37_sd.clear-M37_sd.pan)<<1-1,d7 */
    moveq #(((M37_sd.clear-M37_sd.pan)<<1)-1),d7
/* QL: bp_pan */
bp_pan:
/* QL:         addq.b  #(M37_sd.pan-M37_sd.scrol)<<1,d7 */
.word 20487|(((((M37_sd.pan-M37_sd.scrol)<<1))&7)<<9)
/* QL: bp_scrol */
bp_scrol:
/* QL:         bsr.s   M37_iparm           get distance to pan or scroll */
    bsr.s M37_iparm
/* QL:         exg     d2,d0           get distance or part = last parameter (d2=0) */
    exg d2,d0
/* QL:         sub.w   d3,a1 */
    sub.w d3,a1
/* QL:         sub.w   d3,a1           back up to start of parameters */
    sub.w d3,a1
/* QL:         add.b   #M37_sd.scrol<<1!1,d7 */
    add.b #(((M37_sd.scrol<<1)|1)&255),d7
/* QL:         lsr.b   #1,d7 */
    lsr.b #1,d7
/* QL:         subx.w  d2,d3           insist on at least one parameter for pan/scroll */
    subx.w d2,d3
/* QL:         bcs.s   M37_err_nebp */
    bcs.s M37_err_nebp
/* QL:         movem.w 0(a6,a1.l),d1/d2 pick up one or two parameters */
    movem.w 0(a6,a1.l),d1/d2
/* QL:         subq.w  #1,d3           check if optional part parameter was present */
    subq.w #1,d3
/* QL:         bcs.s   M37_chkls           ok if no option parameter */
    bcs.s M37_chkls
/* QL:         add.b   d0,d7           add option to call byte */
    add.b d0,d7
/* QL: M37_chkls */
M37_chkls:
/* QL:         jsr     bp_lsqzp(pc)    if this is the list window, zap list info */
    jsr bp_lsqzp(pc)
/* QL:         bra.s   M37_trap3d7a */
    bra.s M37_trap3d7a
/* QL:         end */
