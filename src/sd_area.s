/* ROM section sd_area */
.balign 2,0
/* QL: * d0 -i o- area key / 0(no error) */
/* QL: * d1 -i  - distance to pan/scroll (sd.panxx, sd.scroll and sd.scrxx only) */
/* QL: * a0 -ip - channel definition block */
/* QL: * a1 -i  - recolour map address (M116_sd.recol only) */
/* QL: * d1-d3/a1-a2 destroyed */
/* QL: regon   reg     d0-d1/d5-d7/a0-a1 */
/* QL: regoff  reg     d4-d7/a0-a1 */
/* QL: sd_recol */
sd_recol:
/* QL:         moveq   #0,d0           recolour whole window only */
    moveq #0,d0
/* QL:         lea     cs_recol(pc),a2 set cs entry point for recolour */
    lea cs_recol(pc),a2
/* QL:         bra.s   M116_go_coset        a1 has recolour table already */
    bra.s M116_go_coset
/* QL: sd_clear */
sd_clear:
/* QL:         jsr     sd_home(pc)     reset cursor for full clear, d0.l = 0 on return */
    jsr sd_home(pc)
/* QL: sd_clrxx */
sd_clrxx:
/* QL:         assert  0,M116_sd.clrtp&7-1,M116_sd.clrbt&7-2,M116_sd.clrln&7-3,M116_sd.clrrt&7-4 */
/* original assertion: 0,M116_sd.clrtp&7-1,M116_sd.clrbt&7-2,M116_sd.clrln&7-3,M116_sd.clrrt&7-4 */
/* QL:         lea     cs_fill(pc),a2  set cs entry point for area fill */
    lea cs_fill(pc),a2
/* QL:         bra.s   M116_go_area */
    bra.s M116_go_area
/* QL: sd_scrol */
sd_scrol:
/* QL:         assert  0,M116_sd.scrol&7,M116_sd.scrtp&7-1,M116_sd.scrbt&7-2 */
/* original assertion: 0,M116_sd.scrol&7,M116_sd.scrtp&7-1,M116_sd.scrbt&7-2 */
/* QL:         lea     cs_scrol(pc),a2 set cs entry point for scroll */
    lea cs_scrol(pc),a2
/* QL:         bra.s   M116_go_area */
    bra.s M116_go_area
/* QL: sd_pan */
sd_pan:
/* QL:         assert  3,M116_sd.pan&7,M116_sd.panln&7-3,M116_sd.panrt&7-4 */
/* original assertion: 3,M116_sd.pan&7,M116_sd.panln&7-3,M116_sd.panrt&7-4 */
/* QL:         subq.b  #3,d0 */
    subq.b #3,d0
/* QL:         lea     cs_pan(pc),a2   set cs entry point for pan */
    lea cs_pan(pc),a2
/* QL:         btst    #M116_mc..m256,M116_sv_mcsta(a6) is it low res mode */
    btst #M116_mc..m256,M116_sv_mcsta(a6)
/* QL:         beq.s   M116_go_area         pan even distances only */
    beq.s M116_go_area
/* QL:         bclr    #0,d1           pan even distances only */
    bclr #0,d1
/* QL: * Now set up the parameters for different types of area ops */
/* QL: * 0 full area */
/* QL: * 1 top of window */
/* QL: * 2 bottom of window */
/* QL: * 3 cursor line */
/* QL: * 4 right of cursor line */
/* QL: * 5 cursor only (for prettier io.edlin - new call!) */
/* QL: M116_go_area */
M116_go_area:
/* QL:         lea     M116_sd_pmask(a0),a1 fill with paper colour */
    lea M116_sd_pmask(a0),a1
/* QL: M116_go_coset */
M116_go_coset:
/* QL:         move.l  d4,-(sp)        save d4 */
    move.l d4,-(sp)
/* QL:         movem.l regon,-(sp)     save distance and temp registers */
    movem.l d0-d1/d5-d7/a0-a1,-(sp)
/* QL:         ;       d0         d1         d2         d3 */
/* QL:         assert  M116_sd_xmin    M116_sd_ymin-2  M116_sd_xsize-4 M116_sd_ysize-6  M116_sd_xpos-10 M116_sd_ypos-12 M116_sd_xinc-14 M116_sd_yinc-16 */
/* original assertion: M116_sd_xmin    M116_sd_ymin-2  M116_sd_xsize-4 M116_sd_ysize-6  M116_sd_xpos-10 M116_sd_ypos-12 M116_sd_xinc-14 M116_sd_yinc-16 */
/* QL:         ;       d6         d7         a0         a1 */
/* QL:         movem.w M116_sd_xmin(a0),d0-d4/d6-d7/a0-a1 get all window parameters */
    movem.w M116_sd_xmin(a0),d0-d4/d6-d7/a0-a1
/* QL:         moveq   #7,d4           extract key ... */
    moveq #7,d4
/* QL:         and.l   (sp)+,d4        ... out of the way */
    and.l (sp)+,d4
/* QL:         beq.s   M116_end_all         key 0 - we've done it */
    beq.s M116_end_all
/* QL:         subq.b  #2,d4 */
    subq.b #2,d4
/* QL:         beq.s   M116_set_2 */
    beq.s M116_set_2
/* QL:         bpl.s   M116_set_345 */
    bpl.s M116_set_345
/* QL:         cmp.w   d7,d3           check ypos against ysize */
    cmp.w d7,d3
/* QL:         ble.s   M116_end_all         if cursor position is below screen, do whole */
    ble.s M116_end_all
/* QL:         move.w  d7,d3           key 1 - only operate down to cursor */
    move.w d7,d3
/* QL:         bmi.s   M116_end_zap         if cursor is above screen, do nothing */
    bmi.s M116_end_zap
/* QL:         bra.s   M116_end_all */
    bra.s M116_end_all
/* QL: M116_set_2 */
M116_set_2:
/* QL:         add.w   a1,d7           calculate incremented ypos */
    add.w a1,d7
/* QL:         bmi.s   M116_end_all         if negative, do whole window */
    bmi.s M116_end_all
/* QL:         sub.l   d7,d3           key 2 - go down to bottom */
    sub.l d7,d3
/* QL:         bls.s   M116_end_zap         if below window, do nothing */
    bls.s M116_end_zap
/* QL:         bra.s   M116_end_ypos */
    bra.s M116_end_ypos
/* QL: * Check that bottom of area is not below bottom of window */
/* QL: * OK if ypos + yinc <= ysize, i.e. ysize - ypos - yinc <= 0 */
/* QL: M116_set_345 */
M116_set_345:
/* QL:         sub.l   a1,d3 */
    sub.l a1,d3
/* QL:         blo.s   M116_end_zap         do nothing if yinc > ysize */
    blo.s M116_end_zap
/* QL:         cmp.l   d7,d3 */
    cmp.l d7,d3
/* QL:         blo.s   M116_end_zap         do nothing if cursor start off screen */
    blo.s M116_end_zap
/* QL:         move.w  a1,d3           we do yinc for key > 2, if all ok */
    move.w a1,d3
/* QL:         subq.b  #2,d4 */
    subq.b #2,d4
/* QL:         bmi.s   M116_end_ypos        key 3 - we've done it */
    bmi.s M116_end_ypos
/* QL:         sub.w   d6,d2           do xsize - xpos */
    sub.w d6,d2
/* QL:         bls.s   M116_end_zap         do nothing if cursor off left/right of screen */
    bls.s M116_end_zap
/* QL:         add.w   d6,d0           start at xmin+xpos */
    add.w d6,d0
/* QL:         tst.b   d4 */
    tst.b d4
/* QL:         beq.s   M116_end_ypos        key 4 - we're ready */
    beq.s M116_end_ypos
/* QL:         exg     a0,d2           key 5 - only operate on cursor */
    exg a0,d2
/* QL:         cmp.w   a0,d2 */
    cmp.w a0,d2
/* QL:         bls.s   M116_end_ypos */
    bls.s M116_end_ypos
/* QL: M116_end_zap */
M116_end_zap:
/* QL:         lea     M116_rts0,a2         lose routine, we're skipping any action */
    lea M116_rts0(pc),a2
/* QL: M116_end_ypos */
M116_end_ypos:
/* QL:         add.w   d7,d1           start at ymin+ypos */
    add.w d7,d1
/* QL: M116_end_all */
M116_end_all:
/* QL:         movem.l (sp)+,regoff    restore distance and temp registers */
    movem.l (sp)+,d4-d7/a0-a1
/* QL:         jsr     (a2)            do it */
    jsr (a2)
/* QL: M116_exit */
M116_exit:
/* QL:         move.l  (sp)+,d4        reload d4 */
    move.l (sp)+,d4
/* QL:         moveq   #0,d0           register no error, ever */
    moveq #0,d0
/* QL: M116_rts0 */
M116_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
