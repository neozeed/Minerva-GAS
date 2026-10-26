/* ROM section bp_turtl */
.balign 2,0
/* QL: bp_move */
bp_move:
/* QL:         moveq   #M38_moveblk-M38_turnblk,d7 */
    moveq #(M38_moveblk-M38_turnblk),d7
/* QL: bp_turn */
bp_turn:
/* QL:         subq.w  #M38_trntoblk-M38_turnblk,d7 */
.word 20807|((((M38_trntoblk-M38_turnblk))&7)<<9)
/* QL: bp_turno */
bp_turno:
/* QL:         jsr     bv_chri(pc)     allocate some space on the stack */
    jsr bv_chri(pc)
/* QL:         jsr     bp_chan(pc)     get channel number, if any */
    jsr bp_chan(pc)
/* QL:         bne.s   M38_rts0            propagate any error */
    bne.s M38_rts0
/* QL:         jsr     ca_gtfp1(pc)    get a single floating point parameter */
    jsr ca_gtfp1(pc)
/* QL:         bne.s   M38_rts0            propagate any error */
    bne.s M38_rts0
/* QL:         lea     M38_trntoblk(pc,d7.w),a3 point to interpreter block */
    lea M38_trntoblk(pc,d7.w),a3
/* QL:         lea     M38_ch.lench(a2),a4 top of channel definition */
    lea M38_ch.lench(a2),a4
/* QL:         jsr     ri_execb(pc)    execute block */
    jsr ri_execb(pc)
/* QL:         bne.s   M38_rts0            get out on errors */
    bne.s M38_rts0
/* QL:         tst.w   d7 */
    tst.w d7
/* QL:         ble.s   M38_rts0            only move has anything more to do */
    ble.s M38_rts0
/* QL:         tst.b   M38_ch.pen(a6,a2.l) */
    tst.b M38_ch.pen(a6,a2.l)
/* QL:         beq.s   M38_rts0            if the pen is up then we're done */
    beq.s M38_rts0
/* QL:         moveq   #M38_sd.line,d0     line M38_ccpx, M38_ccpy, x2, y2 */
    moveq #M38_sd.line,d0
/* QL:         moveq   #-1,d3 */
    moveq #(-1),d3
/* QL:         trap    #4 */
    trap #4
/* QL:         trap    #3 */
    trap #3
/* QL: M38_rts0 */
M38_rts0:
/* QL:         rts */
    rts 
/* QL: bp_pendn ; pen = 1 */
bp_pendn:
/* QL:         addq.b  #1,d7 */
    addq.b #1,d7
/* QL: bp_penup ; pen = 0 */
bp_penup:
/* QL:         jsr     bp_chan(pc)     get channel number, if any */
    jsr bp_chan(pc)
/* QL:         bne.s   M38_rts0            propagate any error */
    bne.s M38_rts0
/* QL:         move.b  d7,M38_ch.pen(a6,a2.l) set pen status */
    move.b d7,M38_ch.pen(a6,a2.l)
/* QL:         rts */
    rts 
/* QL: M38_ccpy    equ     M38_ch.ccpy-M38_ch.lench */
.equ M38_ccpy,(M38_ch.ccpy-M38_ch.lench)
/* QL: M38_ccpx    equ     M38_ch.ccpx-M38_ch.lench */
.equ M38_ccpx,(M38_ch.ccpx-M38_ch.lench)
/* QL: M38_angle   equ     M38_ch.angle-M38_ch.lench */
.equ M38_angle,(M38_ch.angle-M38_ch.lench)
/* QL: M38_turnblk ; stack: rel M38_angle */
M38_turnblk:
/* QL:  dc.b M38_angle,M38_ri.add */
M38_dc_anchor_390:
.byte (M38_angle)&255
.byte (M38_ri.add)&255
/* QL: M38_trntoblk ; stack: abs M38_angle */
M38_trntoblk:
/* QL:  dc.b M38_ri.n,90,M38_ri.doubl,M38_ri.doubl         360, ang */
M38_dc_anchor_396:
.byte (M38_ri.n)&255
.byte (90)&255
.byte (M38_ri.doubl)&255
.byte (M38_ri.doubl)&255
/* QL:  dc.b M38_ri.over,M38_ri.over,M38_ri.div,M38_ri.int     int(ang/360), 360, ang */
M38_dc_anchor_402:
.byte (M38_ri.over)&255
.byte (M38_ri.over)&255
.byte (M38_ri.div)&255
.byte (M38_ri.int)&255
/* QL:  dc.b M38_ri.float,M38_ri.mult,M38_ri.sub           ang - 360*float(int(ang/360)) */
M38_dc_anchor_408:
.byte (M38_ri.float)&255
.byte (M38_ri.mult)&255
.byte (M38_ri.sub)&255
/* QL:  dc.b M38_angle+M38_ri.store,M38_ri.term            store it away (always 0..360) */
M38_dc_anchor_413:
.byte ((M38_angle+M38_ri.store))&255
.byte (M38_ri.term)&255
/* QL:         assert  0 > M38_turnblk-M38_trntoblk */
/* original assertion: 0 > M38_turnblk-M38_trntoblk */
/* QL: M38_moveblk ; stack: distance (d) */
M38_moveblk:
/* QL:  dc.b M38_ccpx,M38_ccpy,M38_ri.roll                 d, M38_ccpy, M38_ccpx */
M38_dc_anchor_421:
.byte (M38_ccpx)&255
.byte (M38_ccpy)&255
.byte (M38_ri.roll)&255
/* QL:  dc.b M38_angle,M38_ri.k,M38_ri.pi180,M38_ri.mult       a, d, M38_ccpy, M38_ccpx */
M38_dc_anchor_426:
.byte (M38_angle)&255
.byte (M38_ri.k)&255
.byte (M38_ri.pi180)&255
.byte (M38_ri.mult)&255
/* QL:  dc.b M38_ri.over,M38_ri.over,M38_ri.cos,M38_ri.mult    cos(a)*d, a, d, M38_ccpy, M38_ccpx */
M38_dc_anchor_432:
.byte (M38_ri.over)&255
.byte (M38_ri.over)&255
.byte (M38_ri.cos)&255
.byte (M38_ri.mult)&255
/* QL:  dc.b M38_ccpx,M38_ri.add,M38_ri.dup,M38_ccpx+M38_ri.store  M38_ccpx'(saved), a, d, cpy, M38_ccpx */
M38_dc_anchor_438:
.byte (M38_ccpx)&255
.byte (M38_ri.add)&255
.byte (M38_ri.dup)&255
.byte ((M38_ccpx+M38_ri.store))&255
/* QL:  dc.b M38_ri.roll,M38_ri.roll,M38_ri.sin,M38_ri.mult    sin(a)*d, M38_ccpx', M38_ccpy, M38_ccpx */
M38_dc_anchor_444:
.byte (M38_ri.roll)&255
.byte (M38_ri.roll)&255
.byte (M38_ri.sin)&255
.byte (M38_ri.mult)&255
/* QL:  dc.b M38_ccpy,M38_ri.add,M38_ri.dup,M38_ccpy+M38_ri.store  M38_ccpy'(saved), M38_ccpx', M38_ccpy, M38_ccpx */
M38_dc_anchor_450:
.byte (M38_ccpy)&255
.byte (M38_ri.add)&255
.byte (M38_ri.dup)&255
.byte ((M38_ccpy+M38_ri.store))&255
/* QL:  dc.b M38_ri.term                           M38_ccpy', M38_ccpx', M38_ccpy, M38_ccpx */
M38_dc_anchor_456:
.byte (M38_ri.term)&255
/* QL:         assert  0 < M38_moveblk-M38_trntoblk */
/* original assertion: 0 < M38_moveblk-M38_trntoblk */
/* QL:         end */
