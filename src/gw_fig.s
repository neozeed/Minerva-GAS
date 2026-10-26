/* ROM section gw_fig */
.balign 2,0
/* QL: gw_fig */
gw_fig:
/* QL:         link    a6,#M176_lnk         make data frame */
    link a6,#M176_lnk
/* QL:         movem.l sav,-(sp)       save required registers at M176_base of frame */
    movem.l a0/a3/a5,-(sp)
/* QL:         lea     M176_menu-M176_sd.point(pc,d0.w),a5 */
    lea (M176_menu-M176_sd.point)(pc,d0.w),a5
/* QL:         move.b  (a5),d0         pick up pointer byte */
    move.b (a5),d0
/* QL:         add.w   d0,a5           point to M176_menu list for operation */
    add.w d0,a5
/* QL:         move.b  (a5)+,d0        pick up byte that says how many bytes at a1 */
    move.b (a5)+,d0
/* QL:         lea     0(a1,d0.w),a4   point a4 to M176_base of stack */
    lea 0(a1,d0.w),a4
/* QL:         move.b  (a5)+,d0        pick up first M176_proc M176_type byte */
    move.b (a5)+,d0
/* QL:         moveq   #8,d7           start octant count register (ok for elipse) */
    moveq #8,d7
/* QL:         jsr     M176_prep(pc,d0.w)   go to first section of code for operation */
    jsr M176_prep(pc,d0.w)
/* QL:         move.l  a4,a1           just in case caller would like it reset */
    move.l a4,a1
/* QL:         moveq   #0,d0           always return ok, even if we drew nothing */
    moveq #0,d0
/* QL:         movem.l (sp)+,sav       restore M176_a few registers */
    movem.l (sp)+,a0/a3/a5
/* QL:         unlk    a6              release the data frame */
    unlk a6
/* QL:         rts */
    rts 
/* QL: M176_menu dc.b M176_men_p-*,M176_men_l-*-1,M176_men_a-*-2,M176_men_e-*-3 */
M176_menu:
M176_dc_anchor_511:
.byte ((M176_men_p-M176_dc_anchor_511))&255
.byte (((M176_men_l-M176_dc_anchor_511)-1))&255
.byte (((M176_men_a-M176_dc_anchor_511)-2))&255
.byte (((M176_men_e-M176_dc_anchor_511)-3))&255
/* QL: M176_men_p dc.b -M176_ys,M176_pre_p-M176_prep,M176_sca_p-M176_m,M176_pro_p-M176_proc point */
M176_men_p:
M176_dc_anchor_518:
.byte ((-M176_ys))&255
.byte ((M176_pre_p-M176_prep))&255
.byte ((M176_sca_p-M176_m))&255
.byte ((M176_pro_p-M176_proc))&255
/* QL: M176_men_l dc.b -M176_yf,M176_pre_l-M176_prep,M176_sca_p-M176_m,M176_pro_l-M176_proc,M176_swa_p-M176_m,M176_sca_p-M176_m,$ec line */
M176_men_l:
M176_dc_anchor_525:
.byte ((-M176_yf))&255
.byte ((M176_pre_l-M176_prep))&255
.byte ((M176_sca_p-M176_m))&255
.byte ((M176_pro_l-M176_proc))&255
.byte ((M176_swa_p-M176_m))&255
.byte ((M176_sca_p-M176_m))&255
.byte (0xec)&255
/* QL: M176_men_a dc.b -M176_a,M176_pre_a-M176_prep,M176_octs_a-M176_m,M176_sincos-M176_m,M176_sca_p-M176_m,M176_pro_a-M176_proc */
M176_men_a:
M176_dc_anchor_535:
.byte ((-M176_a))&255
.byte ((M176_pre_a-M176_prep))&255
.byte ((M176_octs_a-M176_m))&255
.byte ((M176_sincos-M176_m))&255
.byte ((M176_sca_p-M176_m))&255
.byte ((M176_pro_a-M176_proc))&255
/* QL:         dc.b M176_swa_p-M176_m,M176_sca_p-M176_m,M176_calc_a-M176_m,M176_opt_x-M176_m,$dc arc */
M176_dc_anchor_543:
.byte ((M176_swa_p-M176_m))&255
.byte ((M176_sca_p-M176_m))&255
.byte ((M176_calc_a-M176_m))&255
.byte ((M176_opt_x-M176_m))&255
.byte (0xdc)&255
/* QL: M176_men_e dc.b -M176_a,M176_pre_e-M176_prep,M176_sincos-M176_m,M176_sca_e-M176_m,M176_pro_e-M176_proc */
M176_men_e:
M176_dc_anchor_551:
.byte ((-M176_a))&255
.byte ((M176_pre_e-M176_prep))&255
.byte ((M176_sincos-M176_m))&255
.byte ((M176_sca_e-M176_m))&255
.byte ((M176_pro_e-M176_proc))&255
/* QL:         dc.b M176_calc_e-M176_m,M176_opt_x-M176_m,$3d ellipse */
M176_dc_anchor_558:
.byte ((M176_calc_e-M176_m))&255
.byte ((M176_opt_x-M176_m))&255
.byte (0x3d)&255
/* QL:  ds.w 0 note: the M176_type byte need no longer be so obscure. */
.balign 2,0
/* QL: gw_psorg */
gw_psorg:
/* QL:         assert  6,M176_sd_xorg-M176_sd_yorg */
/* original assertion: 6,M176_sd_xorg-M176_sd_yorg */
/* QL:         move.l  M176_sd_yorg+8(a0),-(a1) */
    move.l (M176_sd_yorg+8)(a0),-(a1)
/* QL:         move.l  M176_sd_yorg+4(a0),-(a1) */
    move.l (M176_sd_yorg+4)(a0),-(a1)
/* QL:         move.l  M176_sd_yorg+0(a0),-(a1) */
    move.l (M176_sd_yorg+0)(a0),-(a1)
/* QL:         rts */
    rts 
/* QL: gw_pscal */
gw_pscal:
/* QL:         move.w  M176_sd_ysize(a0),-(a1) */
    move.w M176_sd_ysize(a0),-(a1)
/* QL:         subq.w  #1,(a1) */
    subq.w #1,(a1)
/* QL:         moveq   #M176_ri.float,d0 */
    moveq #M176_ri.float,d0
/* QL:         jsr     ri_abex(pc) */
    jsr ri_abex(pc)
/* QL:         move.l  M176_sd_scal+2(a0),-(a1) */
    move.l (M176_sd_scal+2)(a0),-(a1)
/* QL:         move.w  M176_sd_scal(a0),-(a1) */
    move.w M176_sd_scal(a0),-(a1)
/* QL:         rts */
    rts 
/* QL: * Push screen aspect ratio onto stack */
/* QL: gw_asp */
gw_asp:
/* QL: ; if ntsc */
/* QL: ;       move.l  #$6623b79c,-(a1) 2/(4/3*575/512*51.2/51.95) * 1.173 */
/* QL: ;       move.w  #$801,-(a1) */
/* QL: ; else */
/* QL: *        move.l  #$56b851ec,-(a1) 2 / ( (4/3) * (575/512) * (51.2/51.95) ) */
/* QL: *        move.w  #$801,-(a1)      (acually rounded(?) to 1.355) */
/* QL: * The aspect ratio, according to the above, should have been pushing */
/* QL: * $56bbe1ba onto the stack! as we can multiply/divide quicker (now) if the */
/* QL: * least significant half of the mantissa is zero (and keeping as close, one */
/* QL: * part in 32647, to the wrong value, but on the right side of it) ... */
/* QL:         clr.w   -(a1) */
    clr.w -(a1)
/* QL:         move.l  #$80156b9,-(a1)  2 / ( (4/3) * (575/512) * (51.2/51.95) ) */
    move.l #0x80156b9,-(a1)
/* QL: ; endif */
/* QL:         rts */
    rts 
/* QL: M176_prep */
M176_prep:
/* QL: M176_pre_e */
M176_pre_e:
/* QL:         bsr.s   M176_abexm           go convert angle to sine/cosine */
    bsr.s M176_abexm
/* QL:         moveq   #M176_ord_e-M176_m,d0 */
    moveq #(M176_ord_e-M176_m),d0
/* QL:         cmp.w   #$801,M176_ec(a4)    we want major >= minor ... */
    cmp.w #0x801,M176_ec(a4)
/* QL:         bcc.s   M176_eccok           ... so if eccentricity is less than 1.0 ... */
    bcc.s M176_eccok
/* QL:         moveq   #M176_inv_e-M176_m,d0     ... first rotate by pi/2 and flip eccentricity */
    moveq #(M176_inv_e-M176_m),d0
/* QL: M176_eccok */
M176_eccok:
/* QL:         bsr.s   M176_abexn           do eccentricity calcs */
    bsr.s M176_abexn
/* QL:         bra.s   M176_setoct */
    bra.s M176_setoct
/* QL: M176_pre_a */
M176_pre_a:
/* QL:         bsr.s   M176_abexm           get octants (also halves the angle) */
    bsr.s M176_abexm
/* QL:         and.w   (a1),d7         check if int(angle/(pi/4)) bit 3 is set */
    and.w (a1),d7
/* QL:         beq.s   M176_noflip          not set, it's ok (this works for big angles!) */
    beq.s M176_noflip
/* QL:         not.w   (a1)            if set, invert it all (gets -ve ok) */
    not.w (a1)
/* QL: M176_noflip */
M176_noflip:
/* QL:         move.w  (a1)+,d7        found number of octants in subtended angle */
    move.w (a1)+,d7
/* QL: * This only needs to be M176_a low estimate, as the algorithm understands that arcs */
/* QL: * are M176_a pain, and it will let them search on for M176_a bit to find their end point. */
/* QL:         bsr.s   M176_abexm           convert angle to sine/cosine */
    bsr.s M176_abexm
/* QL: M176_pre_l */
M176_pre_l:
/* QL:         and.b   #7,d7           line -> 0, arc -> 0..7 */
    and.b #(7&255),d7
/* QL: M176_setoct */
M176_setoct:
/* QL:         move.b  d7,M176_octs(a6)     set the octant count */
    move.b d7,M176_octs(a6)
/* QL: M176_pre_p */
M176_pre_p:
/* QL:         lea     M176_base(a4),a1     put a1 at standard position */
    lea M176_base(a4),a1
/* QL:         bsr.s   gw_psorg        copy origins to stack */
    bsr.s gw_psorg
/* QL:         bsr.s   gw_pscal        copy scale data to stack */
    bsr.s gw_pscal
/* QL:         moveq   #M176_setsc-M176_m,d0     adjust the scale stuff */
    moveq #(M176_setsc-M176_m),d0
/* QL:         bsr.s   M176_abexn */
    bsr.s M176_abexn
/* QL: * Set up miscellaneous bits of the frame data */
/* QL:         btst    #M176_sd..xor,M176_sd_cattr(a0) */
    btst #M176_sd..xor,M176_sd_cattr(a0)
/* QL:         sne     M176_over(a6)        flag $ff = "M176_over -1" */
    sne M176_over(a6)
/* QL:         move.b  M176_sd_fmod(a0),M176_fmod(a6) flag <>0 = "fill 1" */
    move.b M176_sd_fmod(a0),M176_fmod(a6)
/* QL:         assert  M176_sd_xmin,M176_sd_ymin-2,M176_sd_xsize-4,M176_sd_ysize-6 */
/* original assertion: M176_sd_xmin,M176_sd_ymin-2,M176_sd_xsize-4,M176_sd_ysize-6 */
/* QL:         assert  M176_xmin,M176_ymin-2,M176_xsize-4,M176_ysize-6 */
/* original assertion: M176_xmin,M176_ymin-2,M176_xsize-4,M176_ysize-6 */
/* QL:         movem.l M176_sd_xmin(a0),d0-d1 */
    movem.l M176_sd_xmin(a0),d0-d1
/* QL:         movem.l d0-d1,M176_xmin(a6)  window top left corner and size */
    movem.l d0-d1,M176_xmin(a6)
/* QL: * Set up stuff that's dependent on the current screen mode */
/* QL:         moveq   #M176_mt.dmode,d0 */
    moveq #M176_mt.dmode,d0
/* QL:         moveq   #-1,d1 */
    moveq #(-1),d1
/* QL:         moveq   #-1,d2 */
    moveq #(-1),d2
/* QL:         trap    #1 */
    trap #1
/* QL:         asr.b   #4,d1           shift bit 3 into x. x = 0/1, mode 512/256 */
    asr.b #4,d1
/* QL:         subx.w  d0,d0 */
    subx.w d0,d0
/* QL:         bsr.s   gw_asp          put on M176_a copy of the aspect ratio for scaling */
    bsr.s gw_asp
/* QL:         add.w   d0,(a1)         divide scale by factor of two if mode 256 */
    add.w d0,(a1)
/* QL:         bsr.s   gw_asp          put on aspect ratio */
    bsr.s gw_asp
/* QL:         neg.w   d0 */
    neg.w d0
/* QL:         addq.w  #1,d0          */
    addq.w #1,d0
/* QL:         move.w  d0,M176_xinc(a6)     2 for mode 256 or 1 for mode 512 */
    move.w d0,M176_xinc(a6)
/* QL:         bsr.s   M176_abexm           scale the start point input params */
    bsr.s M176_abexm
/* QL:         lea     M176_x0(a6),a2       where to put start point */
    lea M176_x0(a6),a2
/* QL:         bsr.s   M176_xyext           pick off and adjust start point */
    bsr.s M176_xyext
/* QL:         move.b  (a5)+,d0 */
    move.b (a5)+,d0
/* QL:         jmp     M176_proc(pc,d0.w)   jump to what to do next */
.word 0x4efb
.word 0|((M176_proc-.)&255)
/* QL: M176_abexm */
M176_abexm:
/* QL:         move.b  (a5)+,d0        use next M176_menu byte to decide what calcs to do */
    move.b (a5)+,d0
/* QL: M176_abexn */
M176_abexn:
/* QL:         ext.w   d0 */
    ext.w d0
/* QL:         beq.s   M176_rts0            dummy entries have d0=0 at this point */
    beq.s M176_rts0
/* QL:         lea     M176_m,a3 */
    lea M176_m(pc),a3
/* QL:         add.w   d0,a3 */
    add.w d0,a3
/* QL:         jsr     ri_abexb(pc) */
    jsr ri_abexb(pc)
/* QL:         beq.s   M176_rts0 */
    beq.s M176_rts0
/* QL:         addq.l  #4,sp           don't accept errors, draw nothing */
    addq.l #4,sp
/* QL: M176_rts0 */
M176_rts0:
/* QL:         rts */
    rts 
/* QL: M176_xyext */
M176_xyext:
/* QL:         move.l  (a1)+,d1        get x/y (doubled) */
    move.l (a1)+,d1
/* QL:         asr.w   #1,d1           make y proper, propagating sign */
    asr.w #1,d1
/* QL:         subx.w  d2,d2           carry = rounding */
    subx.w d2,d2
/* QL:         sub.w   d2,d1           do y rounding */
    sub.w d2,d1
/* QL:         swap    d1              put y in msw for now */
    swap d1
/* QL:         move.w  M176_xinc(a6),d0     get x-increment, 1/2 */
    move.w M176_xinc(a6),d0
/* QL:         asr.w   d0,d1           make x near proper, propagating sign */
    asr.w d0,d1
/* QL:         subx.w  d2,d2           carry = rounding */
    subx.w d2,d2
/* QL:         sub.w   d2,d1           do x rounding */
    sub.w d2,d1
/* QL:         subq.w  #1,d0           change shift to 0/1 */
    subq.w #1,d0
/* QL:         lsl.w   d0,d1           put x to final place (lsb=0 for mode 8) */
    lsl.w d0,d1
/* QL:         swap    d1              swap back to right way round */
    swap d1
/* QL:         move.l  d1,(a2)+        store x/y */
    move.l d1,(a2)+
/* QL:         rts */
    rts 
/* QL: M176_proc */
M176_proc:
/* QL: * M176_sd.point: call just the bits we need, and forget all the dross. */
/* QL: M176_pro_p */
M176_pro_p:
/* QL:         movem.w M176_x0(a6),d0-d1 */
    movem.w M176_x0(a6),d0-d1
/* QL:         jsr     gw_pixad(pc) */
    jsr gw_pixad(pc)
/* QL:         jmp     gw_pixel(pc) */
    jmp gw_pixel(pc)
/* QL: * Process the ellipse */
/* QL: M176_pro_e */
M176_pro_e:
/* QL:         move.l  d1,(a2)+        repeat start point as end point */
    move.l d1,(a2)+
/* QL:         cmp.w   #$800,M176_ax(a4)    is the narrow bit less than one pixel? */
    cmp.w #0x800,M176_ax(a4)
/* QL:         bcs.s   M176_rts0            yes - we'll not bother to draw anything! */
    bcs.s M176_rts0
/* QL: * There is the idea of drawing two shallow arcs, but I don't know (lwr)... */
/* QL: * However, eventually it would be M176_a good idea to break an ellipse into */
/* QL: * sections, anyway, so we can draw huge ones without wandering miles offscreen */
/* QL: * in the process. */
/* QL: M176_allset */
M176_allset:
/* QL:         bsr.s   M176_abexm           do the main calculations */
    bsr.s M176_abexm
/* QL:         bsr.s   M176_abexm           produce the rounding factor */
    bsr.s M176_abexm
/* QL:         bra.s   M176_abguv */
    bra.s M176_abguv
/* QL: * M176_sd.line: simple one */
/* QL: M176_pro_l */
M176_pro_l:
/* QL:         bsr.s   M176_abexm           swap in end point */
    bsr.s M176_abexm
/* QL:         bsr.s   M176_abexm           process end point */
    bsr.s M176_abexm
/* QL:         bsr.s   M176_xyext           fetch end point */
    bsr.s M176_xyext
/* QL:         moveq   #0,d2           M176_alpha = 0 */
    moveq #0,d2
/* QL:         moveq   #0,d3           M176_beta = 0 */
    moveq #0,d3
/* QL:         moveq   #0,d4           M176_gamma = 0 */
    moveq #0,d4
/* QL:         assert  M176_x0,M176_y0-2,M176_x1-4,M176_y1-6 */
/* original assertion: M176_x0,M176_y0-2,M176_x1-4,M176_y1-6 */
/* QL:         movem.w M176_x0(a6),d0-d1/d6-d7 get start and end points (sign extended) */
    movem.w M176_x0(a6),d0-d1/d6-d7
/* QL:         sub.l   d0,d6 */
    sub.l d0,d6
/* QL:         cmp.b   #2,M176_xinc+1(a6)   mode 512? */
    cmp.b #(2&255),(M176_xinc+1)(a6)
/* QL:         beq.s   M176_uset            (note: 512 mode start/end x already even) */
    beq.s M176_uset
/* QL:         add.l   d6,d6           M176_u = delta x * 2 / mode */
    add.l d6,d6
/* QL: M176_uset */
M176_uset:
/* QL:         sub.l   d1,d7 */
    sub.l d1,d7
/* QL:         add.l   d7,d7           M176_v = delta y * 2 */
    add.l d7,d7
/* QL:         bra.s   M176_trans           go do it! */
    bra.s M176_trans
/* QL: * Process an arc */
/* QL: M176_pro_a */
M176_pro_a:
/* QL:         bsr.s   M176_abexm           swap in end point */
    bsr.s M176_abexm
/* QL:         bsr.s   M176_abexm           process end point */
    bsr.s M176_abexm
/* QL:         bsr.s   M176_xyext           fetch end point */
    bsr.s M176_xyext
/* QL:         movem.w M176_x0(a6),d0-d4    pick up start and end points */
    movem.w M176_x0(a6),d0-d4
/* QL:         sub.l   d0,d2           M176_x1 - M176_x0 */
    sub.l d0,d2
/* QL:         sub.l   d1,d3           M176_y1 - M176_y0 */
    sub.l d1,d3
/* QL:         movem.l d2-d3,-(a1)     put them on the stack */
    movem.l d2-d3,-(a1)
/* QL:         bra.s   M176_allset */
    bra.s M176_allset
/* QL: * We wish to arrange for the values used in squch and diach to have as many */
/* QL: * significant bits as we can, to keep accuracy. */
/* QL: * Also, in order to have no rounding errors, the values we set up need M176_alpha */
/* QL: * and M176_beta multiples of four and M176_gamma, M176_u and M176_v even. */
/* QL: * Further to the above, the following are the worst case values that we will */
/* QL: * need to cope with signed arithmetic on: */
/* QL: *       M176_alpha + M176_beta + 2*M176_gamma */
/* QL: *       M176_alpha/2 + M176_gamma/2 + M176_u + M176_v */
/* QL: *       M176_beta/2 + M176_gamma/2 + M176_u + M176_v */
/* QL: *       M176_alpha/4 + M176_u/2 + M176_beta/2 + M176_gamma/2 + M176_v */
/* QL: *       M176_beta/4 + M176_v/2 + M176_alpha/2 + M176_gamma/2 + M176_u */
/* QL: * We actually know that M176_alpha, M176_beta and M176_gamma are less than one, except for */
/* QL: * an arc, when M176_alpha and M176_beta are less than two, but M176_gamma is zero. */
/* QL: * The main interest is the values of M176_u and v. If these are less than one, we've */
/* QL: * got M176_a pretty degenerate figure to draw! */
/* QL: * Finally, when the ellipse was set up, it tried to arrange itself M176_a start */
/* QL: * point on the minor axis. However, aspect ratio scaling will disturb this, */
/* QL: * meaning we need an extra guard bit to stop the algorithm screwing up. */
/* QL: * We have already arranged the top of the arithmetic stack to contain: */
/* QL: * abs(M176_u')+abs(M176_v')+8,M176_alpha/2,M176_beta/2,M176_gamma,M176_u,M176_v,... */
/* QL: M176_abguv */
M176_abguv:
/* QL:         move.w  (a1),d5 */
    move.w (a1),d5
/* QL:         addq.l  #6,a1 */
    addq.l #6,a1
/* QL:         sub.w   #$800+27,d5     dividing power of two */
    sub.w #(0x800+27),d5
/* QL:         bsr.s   M176_optim */
    bsr.s M176_optim
/* QL:         add.l   d7,d7 */
    add.l d7,d7
/* QL:         move.l  d7,d2           M176_alpha */
    move.l d7,d2
/* QL:         bsr.s   M176_optim */
    bsr.s M176_optim
/* QL:         add.l   d7,d7 */
    add.l d7,d7
/* QL:         move.l  d7,d3           M176_beta */
    move.l d7,d3
/* QL:         bsr.s   M176_optim */
    bsr.s M176_optim
/* QL:         move.l  d7,d4           M176_gamma */
    move.l d7,d4
/* QL:         bsr.s   M176_optim */
    bsr.s M176_optim
/* QL:         move.l  d7,d6           M176_u */
    move.l d7,d6
/* QL:         bsr.s   M176_optim           M176_v */
    bsr.s M176_optim
/* QL:         movem.w M176_x0(a6),d0-d1    put start coords them into their registers */
    movem.w M176_x0(a6),d0-d1
/* QL: M176_trans */
M176_trans:
/* QL:         move.b  (a5)+,M176_type(a6)  finally set the call M176_type: l=M176_ec M176_a=dc e=3d */
    move.b (a5)+,M176_type(a6)
/* QL: * Now transform from coefficients to pitteway algorithm variables and set up */
/* QL: * the initial values. Also find the starting octant of the figure, the pixel */
/* QL: * address and masks, and rearrange the registers */
/* QL:         jsr     gw_trans(pc) */
    jsr gw_trans(pc)
/* QL: * Now the figure may be drawn. Call Pitteway! */
/* QL:         jmp     gw_pitt(pc) */
    jmp gw_pitt(pc)
/* QL: M176_optim */
M176_optim:
/* QL:         sub.w   d5,(a1)         scale parameters to improve numerics */
    sub.w d5,(a1)
/* QL:         bpl.s   M176_goopt           are we getting M176_a tiny value (too tiny!) */
    bpl.s M176_goopt
/* QL:         clr.w   (a1)            yes, just zap exponent so nlint is happy */
    clr.w (a1)
/* QL: M176_goopt */
M176_goopt:
/* QL:         moveq   #M176_ri.nlint,d0 */
    moveq #M176_ri.nlint,d0
/* QL:         jsr     ri_abex(pc) */
    jsr ri_abex(pc)
/* QL:         move.l  (a1)+,d7 */
    move.l (a1)+,d7
/* QL:         add.l   d7,d7           most want to be even */
    add.l d7,d7
/* QL:         rts */
    rts 
/* QL: * Execution blocks for initial arc / elipse parameter arithmetic. */
/* QL: M176_octs_a */
M176_octs_a:
/* QL: * Note: for arc, we are only interested in the half angle. */
/* QL: * M176_a*2, M176_yf, M176_xf, M176_ys, M176_xs */
/* QL:  dc.b M176_ri.halve,M176_ri.dup,M176_ri.k,M176_ri.pi-3,M176_ri.div,M176_ri.int,M176_ri.term */
M176_dc_anchor_951:
.byte (M176_ri.halve)&255
.byte (M176_ri.dup)&255
.byte (M176_ri.k)&255
.byte ((M176_ri.pi-3))&255
.byte (M176_ri.div)&255
.byte (M176_ri.int)&255
.byte (M176_ri.term)&255
/* QL: * int(M176_a*2/(pi/4)).w, M176_a, M176_yf, M176_xf, M176_ys, M176_xs */
/* QL:         assert  M176_a,M176_ca,M176_sa+6 */
/* original assertion: M176_a,M176_ca,M176_sa+6 */
/* QL: M176_sincos */
M176_sincos:
/* QL: * N.B. We've turned the y-axis upside down! */
/* QL: * M176_a, ... */
/* QL:  dc.b M176_ri.dup,M176_ri.cos,M176_ri.swap       M176_ca = cosine(M176_a) */
M176_dc_anchor_967:
.byte (M176_ri.dup)&255
.byte (M176_ri.cos)&255
.byte (M176_ri.swap)&255
/* QL:  dc.b M176_ri.sin,M176_ri.neg,M176_ri.term       M176_sa = -sine(M176_a) */
M176_dc_anchor_972:
.byte (M176_ri.sin)&255
.byte (M176_ri.neg)&255
.byte (M176_ri.term)&255
/* QL: * M176_sa, M176_ca, ... */
/* QL: M176_inv_e */
M176_inv_e:
/* QL: * -M176_ca, M176_sa, M176_ax/M176_ec, 1/M176_ec, yc, xc */
/* QL:  dc.b M176_ri.neg,M176_ri.swap                    angle = angle' + pi/2 */
M176_dc_anchor_981:
.byte (M176_ri.neg)&255
.byte (M176_ri.swap)&255
/* QL:  dc.b M176_ax,M176_ec,M176_ri.mult,M176_ri.store+M176_ax,M176_ri.term M176_ax = M176_ax' * M176_ec' = minor axis */
M176_dc_anchor_985:
.byte (M176_ax)&255
.byte (M176_ec)&255
.byte (M176_ri.mult)&255
.byte ((M176_ri.store+M176_ax))&255
.byte (M176_ri.term)&255
/* QL: * M176_sa, M176_ca, M176_ax, -, yc, xc */
/* QL: M176_ord_e */
M176_ord_e:
/* QL: * M176_sa, M176_ca, M176_ax, M176_ec, yc, xc */
/* QL:  dc.b M176_ec,M176_ri.recip,M176_ri.store+M176_ec,M176_ri.term   M176_ec = 1/M176_ec */
M176_dc_anchor_996:
.byte (M176_ec)&255
.byte (M176_ri.recip)&255
.byte ((M176_ri.store+M176_ec))&255
.byte (M176_ri.term)&255
/* QL: * M176_sa, M176_ca, M176_ax, -, yc, xc */
/* QL: * Execution blocks for scaling */
/* QL: M176_setsc */
M176_setsc:
/* QL: * scale, h-1, M176_yo, M176_xo, M176_asp, M176_masp,... */
/* QL:  dc.b M176_ri.over,M176_ri.swap,M176_ri.div,M176_ri.term */
M176_dc_anchor_1007:
.byte (M176_ri.over)&255
.byte (M176_ri.swap)&255
.byte (M176_ri.div)&255
.byte (M176_ri.term)&255
/* QL: * (h-1)/scale, h-1, M176_yo, M176_xo, M176_asp, M176_masp,... */
/* QL: * N.B. Note that both start and end point use the same calculation. This */
/* QL: * ensures that sequences of lines and arcs, where the end point of one is the */
/* QL: * start point of the next, will be guaranteed to come up with the same pixel. */
/* QL: M176_sca_e */
M176_sca_e:
/* QL: * ..., M176_sa, M176_ca, M176_ax, -, yc, xc */
/* QL:  dc.b M176_ax,M176_sa,M176_ri.mult,M176_xs,M176_ri.add,M176_ri.store+M176_xs       M176_xs = xc + M176_v */
M176_dc_anchor_1020:
.byte (M176_ax)&255
.byte (M176_sa)&255
.byte (M176_ri.mult)&255
.byte (M176_xs)&255
.byte (M176_ri.add)&255
.byte ((M176_ri.store+M176_xs))&255
/* QL: * ..., M176_sa, M176_ca, M176_ax, M176_ec, yc, M176_xs */
/* QL:  dc.b M176_ax,M176_ca,M176_ri.mult,M176_ys,M176_ri.add,M176_ri.store+M176_ys       M176_ys = yc + M176_u (later negation) */
M176_dc_anchor_1029:
.byte (M176_ax)&255
.byte (M176_ca)&255
.byte (M176_ri.mult)&255
.byte (M176_ys)&255
.byte (M176_ri.add)&255
.byte ((M176_ri.store+M176_ys))&255
/* QL:  dc.b M176_ax,M176_sc,M176_ri.mult,M176_ri.store+M176_ax                 M176_ax = M176_ax*(h-1)/scale */
M176_dc_anchor_1037:
.byte (M176_ax)&255
.byte (M176_sc)&255
.byte (M176_ri.mult)&255
.byte ((M176_ri.store+M176_ax))&255
/* QL: M176_sca_p */
M176_sca_p:
/* QL: * ..., (h-1)/scale, h-1, M176_yo, M176_xo, M176_asp, M176_masp, ... */
/* QL:  dc.b M176_yo,M176_ys,M176_ri.sub,M176_sc,M176_ri.mult */
M176_dc_anchor_1046:
.byte (M176_yo)&255
.byte (M176_ys)&255
.byte (M176_ri.sub)&255
.byte (M176_sc)&255
.byte (M176_ri.mult)&255
/* QL:  dc.b M176_h1,M176_ri.add,M176_ri.doubl,M176_ri.int                 int(2*((y-M176_yf)*(h-1)/scale+h-1)) */
M176_dc_anchor_1053:
.byte (M176_h1)&255
.byte (M176_ri.add)&255
.byte (M176_ri.doubl)&255
.byte (M176_ri.int)&255
/* QL:  dc.b M176_xs,M176_xo,M176_ri.sub,M176_sc,M176_ri.mult */
M176_dc_anchor_1059:
.byte (M176_xs)&255
.byte (M176_xo)&255
.byte (M176_ri.sub)&255
.byte (M176_sc)&255
.byte (M176_ri.mult)&255
/* QL:  dc.b M176_asp,M176_ri.mult,M176_ri.doubl,M176_ri.int,M176_ri.term       int(2*(x-M176_xo)*(h-1)/scale*M176_asp) */
M176_dc_anchor_1066:
.byte (M176_asp)&255
.byte (M176_ri.mult)&255
.byte (M176_ri.doubl)&255
.byte (M176_ri.int)&255
.byte (M176_ri.term)&255
/* QL: * int(x').w, int(y').w, ... */
/* QL: M176_swa_p */
M176_swa_p:
/* QL:  dc.b M176_yf,M176_ri.store+M176_ys,M176_xf,M176_ri.store+M176_xs replace start point with end point */
M176_dc_anchor_1076:
.byte (M176_yf)&255
.byte ((M176_ri.store+M176_ys))&255
.byte (M176_xf)&255
.byte ((M176_ri.store+M176_xs))&255
/* QL: M176_m dc.b M176_ri.term */
M176_m:
M176_dc_anchor_1083:
.byte (M176_ri.term)&255
/* QL: * Execution blocks are referenced byte relative to m. An entry in the M176_menu of */
/* QL: * zero will in fact skip doing any calculations at all. This is used so that we */
/* QL: * can break up the calcuations into convienient bits. */
/* QL: * Execution block for arc arithmetic */
/* QL: M176_calc_a */
M176_calc_a:
/* QL: * int(M176_x1-M176_x0).l, int(M176_y1-M176_y0).l, ... */
/* QL:  dc.b M176_ri.flong,M176_asp,M176_ri.div,M176_ri.store+M176_xf re-incorporate aspect ratio with delta x */
M176_dc_anchor_1093:
.byte (M176_ri.flong)&255
.byte (M176_asp)&255
.byte (M176_ri.div)&255
.byte ((M176_ri.store+M176_xf))&255
/* QL:  dc.b M176_ri.flong */
M176_dc_anchor_1099:
.byte (M176_ri.flong)&255
/* QL: * M176_yf-M176_ys, ...  */
/* QL:  dc.b M176_ri.dup,M176_ca,M176_ri.mult         (M176_yf - M176_ys) * M176_ca */
M176_dc_anchor_1103:
.byte (M176_ri.dup)&255
.byte (M176_ca)&255
.byte (M176_ri.mult)&255
/* QL:  dc.b M176_xf,M176_sa,M176_ri.mult             (M176_xf - M176_xs) * M176_sa */
M176_dc_anchor_1108:
.byte (M176_xf)&255
.byte (M176_sa)&255
.byte (M176_ri.mult)&255
/* QL:  dc.b M176_ri.sub,M176_masp,M176_ri.div                M176_v = ((M176_yf-M176_ys) * M176_ca - (M176_xf-M176_xs) * M176_sa)/M176_masp */
M176_dc_anchor_1113:
.byte (M176_ri.sub)&255
.byte (M176_masp)&255
.byte (M176_ri.div)&255
/* QL:  dc.b M176_ri.swap,M176_sa,M176_ri.mult        (M176_yf - M176_ys) * M176_sa */
M176_dc_anchor_1118:
.byte (M176_ri.swap)&255
.byte (M176_sa)&255
.byte (M176_ri.mult)&255
/* QL:  dc.b M176_xf,M176_ca,M176_ri.mult             (M176_xf - M176_xs) * M176_ca */
M176_dc_anchor_1123:
.byte (M176_xf)&255
.byte (M176_ca)&255
.byte (M176_ri.mult)&255
/* QL:  dc.b M176_ri.add                            M176_u = (M176_xf-M176_xs) * M176_ca + (M176_yf-M176_ys) * M176_sa */
M176_dc_anchor_1128:
.byte (M176_ri.add)&255
/* QL: * M176_u, M176_v, ... */
/* QL:  dc.b M176_ri.zero                           M176_gamma = 0 */
M176_dc_anchor_1132:
.byte (M176_ri.zero)&255
/* QL:  dc.b M176_sa,M176_masp,M176_ri.squar,M176_ri.div           M176_beta/2 = 2 * M176_sa / 2 / M176_masp^2 */
M176_dc_anchor_1135:
.byte (M176_sa)&255
.byte (M176_masp)&255
.byte (M176_ri.squar)&255
.byte (M176_ri.div)&255
/* QL:  dc.b M176_sa,M176_ri.term                        M176_alpha/2 = 2 * M176_sa / 2 */
M176_dc_anchor_1141:
.byte (M176_sa)&255
.byte (M176_ri.term)&255
/* QL: * M176_alpha/2, M176_beta/2, M176_gamma, M176_u, M176_v, ... */
/* QL: M176_opt_x */
M176_opt_x:
/* QL: * M176_alpha/2, M176_beta/2, M176_gamma, M176_u, M176_v, ... */
/* QL:  dc.b M176_u,M176_ri.abs,M176_v,M176_ri.abs,M176_ri.add,M176_ri.n,8,M176_ri.add    abs(M176_u')+abs(M176_v')+8 (for round) */
M176_dc_anchor_1149:
.byte (M176_u)&255
.byte (M176_ri.abs)&255
.byte (M176_v)&255
.byte (M176_ri.abs)&255
.byte (M176_ri.add)&255
.byte (M176_ri.n)&255
.byte (8)&255
.byte (M176_ri.add)&255
/* QL: * abs(M176_u')+abs(M176_v')+8, M176_alpha/2, M176_beta/2, M176_gamma, M176_u, M176_v, ... */
/* QL:  dc.b M176_ri.term */
M176_dc_anchor_1160:
.byte (M176_ri.term)&255
/* QL: * Execution block for ellipse calculations (last, to give M176_m more room) */
/* QL: M176_calc_e */
M176_calc_e:
/* QL: * ... */
/* QL:  dc.b M176_ax,M176_sa,M176_ri.mult,M176_masp,M176_ri.div         M176_v = M176_ax * M176_sa / M176_masp */
M176_dc_anchor_1167:
.byte (M176_ax)&255
.byte (M176_sa)&255
.byte (M176_ri.mult)&255
.byte (M176_masp)&255
.byte (M176_ri.div)&255
/* QL: * M176_v, ... */
/* QL:  dc.b M176_ax,M176_ca,M176_ri.mult                     M176_u = M176_ax * M176_ca */
M176_dc_anchor_1175:
.byte (M176_ax)&255
.byte (M176_ca)&255
.byte (M176_ri.mult)&255
/* QL: * M176_u, M176_v, ... */
/* QL:  dc.b M176_ri.one,M176_ec,M176_ri.squar,M176_ri.sub         ee = 1 - 1 / M176_ec^2 */
M176_dc_anchor_1181:
.byte (M176_ri.one)&255
.byte (M176_ec)&255
.byte (M176_ri.squar)&255
.byte (M176_ri.sub)&255
/* QL: * ee, M176_u, M176_v, ... */
/* QL:  dc.b M176_ri.dup,M176_sa,M176_ri.mult */
M176_dc_anchor_1188:
.byte (M176_ri.dup)&255
.byte (M176_sa)&255
.byte (M176_ri.mult)&255
/* QL: * ee*M176_sa, ee, M176_u, M176_v, ... */
/* QL:  dc.b M176_ri.dup,M176_sa,M176_ri.mult */
M176_dc_anchor_1194:
.byte (M176_ri.dup)&255
.byte (M176_sa)&255
.byte (M176_ri.mult)&255
/* QL: * ee*M176_sa^2, ee*M176_sa, ee, M176_u, M176_v, ... */
/* QL:  dc.b M176_ri.swap,M176_ca,M176_ri.mult,M176_masp,M176_ri.div    M176_gamma = ee * M176_sa * M176_ca / M176_masp */
M176_dc_anchor_1200:
.byte (M176_ri.swap)&255
.byte (M176_ca)&255
.byte (M176_ri.mult)&255
.byte (M176_masp)&255
.byte (M176_ri.div)&255
/* QL: * M176_gamma, ee*M176_sa^2, ee, M176_u, M176_v, ... */
/* QL:  dc.b M176_ri.one,M176_ri.roll,M176_ri.sub,M176_ri.halve    M176_alpha/2 = (1 - ee * M176_sa^2) / 2 */
M176_dc_anchor_1208:
.byte (M176_ri.one)&255
.byte (M176_ri.roll)&255
.byte (M176_ri.sub)&255
.byte (M176_ri.halve)&255
/* QL: * (1-ee*M176_sa^2)/2, M176_gamma, ee, M176_u, M176_v, ... */
/* QL:  dc.b M176_ri.roll,M176_ri.halve,M176_ri.one,M176_ri.swap,M176_ri.sub */
M176_dc_anchor_1215:
.byte (M176_ri.roll)&255
.byte (M176_ri.halve)&255
.byte (M176_ri.one)&255
.byte (M176_ri.swap)&255
.byte (M176_ri.sub)&255
/* QL: * 1-ee/2, (1-ee*M176_sa^2)/2, M176_gamma, M176_u, M176_v, ... */
/* QL:  dc.b M176_ri.over,M176_ri.sub */
M176_dc_anchor_1223:
.byte (M176_ri.over)&255
.byte (M176_ri.sub)&255
/* QL: * (1-ee*M176_ca^2)/2, (1-ee*M176_sa^2)/2, M176_gamma, M176_u, M176_v, ... */
/* QL:  dc.b M176_masp,M176_ri.squar,M176_ri.div              M176_beta/2 = (1-ee*M176_ca^2) / M176_masp^2 / 2 */
M176_dc_anchor_1228:
.byte (M176_masp)&255
.byte (M176_ri.squar)&255
.byte (M176_ri.div)&255
/* QL: * M176_beta, M176_alpha, M176_gamma, M176_u, M176_v, ... */
/* QL:  dc.b M176_ri.swap,M176_ri.term */
M176_dc_anchor_1234:
.byte (M176_ri.swap)&255
.byte (M176_ri.term)&255
/* QL: * M176_alpha, M176_beta, M176_gamma, M176_u, M176_v, ... */
/* QL:         end */
