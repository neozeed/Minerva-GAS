/* ROM section gw_gcur */
.balign 2,0
/* QL: gw_gcur */
gw_gcur:
/* QL:         lea     -M179_gx(a1),a4      point to bottom of stack */
    lea (-M179_gx)(a1),a4
/* QL:         jsr     gw_psorg(pc)    push the window origin */
    jsr gw_psorg(pc)
/* QL:         jsr     gw_asp(pc)      get the aspect ratio */
    jsr gw_asp(pc)
/* QL:         jsr     gw_pscal(pc)    push the window size and scale */
    jsr gw_pscal(pc)
/* QL:         lea     M179_main,a3         the M179_main interpreter block */
    lea M179_main(pc),a3
/* QL:         bsr.s   M179_abexb           -, -, -, -, M179_px', M179_py' */
    bsr.s M179_abexb
/* QL:         lea     M179_px(a4),a1       point to the answers: M179_px', M179_py' */
    lea M179_px(a4),a1
/* QL:         subq.l  #M179_main-M179_nint,a3   the little interpreter block */
.word 20875|((((M179_main-M179_nint))&7)<<9)
/* QL:         bsr.s   M179_abexb */
    bsr.s M179_abexb
/* QL:         move.w  (a1)+,d1        x = int(M179_px) */
    move.w (a1)+,d1
/* QL:         bsr.s   M179_abexb */
    bsr.s M179_abexb
/* QL:         move.w  (a1)+,d2        y = int(M179_py) */
    move.w (a1)+,d2
/* QL:         bset    #M179_sd..gchr,M179_sd_cattr(a0) set graphics positioned char flag */
    bset #M179_sd..gchr,M179_sd_cattr(a0)
/* QL:         jmp     sd_setc(pc)     set the text cursor */
    jmp sd_setc(pc)
/* QL: M179_abexb */
M179_abexb:
/* QL:         jmp     ri_abexb(pc) */
    jmp ri_abexb(pc)
/* QL: M179_nint */
M179_nint:
/* QL:  dc.b M179_ri.nint,M179_ri.term */
M179_dc_anchor_340:
.byte (M179_ri.nint)&255
.byte (M179_ri.term)&255
/* QL: M179_main */
M179_main:
/* QL: * scale, height-1, aspect, M179_yorg, M179_xorg, M179_gx, M179_gy, M179_px, M179_py */
/* QL:  dc.b M179_ri.over,M179_ri.swap,M179_ri.div            (height-1)/scale */
M179_dc_anchor_347:
.byte (M179_ri.over)&255
.byte (M179_ri.swap)&255
.byte (M179_ri.div)&255
/* QL: * (height-1)/scale, height-1, aspect, M179_yorg, M179_xorg, M179_gx, M179_gy, M179_px, M179_py */
/* QL:  dc.b M179_yorg,M179_gy,M179_ri.sub,M179_ri.over,M179_ri.mult */
M179_dc_anchor_353:
.byte (M179_yorg)&255
.byte (M179_gy)&255
.byte (M179_ri.sub)&255
.byte (M179_ri.over)&255
.byte (M179_ri.mult)&255
/* QL:  dc.b M179_ri.roll,M179_ri.add                    y' = (height-1)*(1-(y-M179_yorg)/scale) */
M179_dc_anchor_360:
.byte (M179_ri.roll)&255
.byte (M179_ri.add)&255
/* QL: * y', (height-1)/scale, aspect, -, M179_xorg, M179_gx, -, M179_px, M179_py */
/* QL:  dc.b M179_py,M179_ri.add,M179_ri.store+M179_yorg           t = M179_py + y' */
M179_dc_anchor_365:
.byte (M179_py)&255
.byte (M179_ri.add)&255
.byte ((M179_ri.store+M179_yorg))&255
/* QL: * (height-1)/scale, aspect, M179_py', M179_xorg, M179_gx, -, M179_px, M179_py */
/* QL:  dc.b M179_gx,M179_xorg,M179_ri.sub,M179_ri.mult,M179_ri.mult    x' = (x-M179_xorg)*aspect*(height-1)/scale */
M179_dc_anchor_371:
.byte (M179_gx)&255
.byte (M179_xorg)&255
.byte (M179_ri.sub)&255
.byte (M179_ri.mult)&255
.byte (M179_ri.mult)&255
/* QL: * x', M179_py', -, -, -, M179_px, M179_py */
/* QL:  dc.b M179_px,M179_ri.add,M179_ri.store+M179_px             M179_px' = M179_px + x' */
M179_dc_anchor_379:
.byte (M179_px)&255
.byte (M179_ri.add)&255
.byte ((M179_ri.store+M179_px))&255
/* QL: * M179_py', -, -, -, M179_px', M179_py */
/* QL:  dc.b M179_ri.store+M179_py                       M179_py' = t */
M179_dc_anchor_385:
.byte ((M179_ri.store+M179_py))&255
/* QL: * -, -, -, -, M179_px', M179_py' */
/* QL:  dc.b M179_ri.term */
M179_dc_anchor_389:
.byte (M179_ri.term)&255
/* QL: * N.B. The above is all arranged so that errors in scaling the graphics */
/* QL: * coordinates will effectively result in M179_px, M179_py being unchanged. */
/* QL:         end */
