/* ROM section gw_pitt */
.balign 2,0
/* QL: * d0 -i  - x coordinate (lsw) */
/* QL: * d1 -i  - y coordinate (lsw) */
/* QL: * d2 -ip - pixel word mask (lsw) */
/* QL: * d3 -i  - colour masks */
/* QL: * d6 -i  - a */
/* QL: * d7 -i  - b */
/* QL: * a0 -i  - d */
/* QL: * a1 -i  - k1 */
/* QL: * a2 -i  - k2 */
/* QL: * a3 -i  - k3 */
/* QL: * a5 -i  - pixel word address */
/* QL: * a6 -ip - stack frame */
/* QL: * d4-d5 destroyed */
/* QL: gw_pitt */
gw_pitt:
/* QL:         moveq   #4,d4 */
    moveq #4,d4
/* QL:         assert  M174_x0,M174_y0-2 */
/* original assertion: M174_x0,M174_y0-2 */
/* QL:         move.l  M174_x0(a6),d5 */
    move.l M174_x0(a6),d5
/* QL:         assert  M174_x1,M174_y1-2 */
/* original assertion: M174_x1,M174_y1-2 */
/* QL:         cmp.l   M174_x1(a6),d5 */
    cmp.l M174_x1(a6),d5
/* QL:         bne.s   M174_xyok            if start and end coincide */
    bne.s M174_xyok
/* QL:         addq.b  #1,M174_type(a6)     cancel degenerate ellipse flag */
    addq.b #1,M174_type(a6)
/* QL:         bpl.s   M174_xyok            and most things carry on, but */
    bpl.s M174_xyok
/* QL:         cmp.b   M174_octs(a6),d4     an arc of less than 5 octants */
    cmp.b M174_octs(a6),d4
/* QL:         ble.s   M174_xyok            or a line stops here */
    ble.s M174_xyok
/* QL:         rts */
    rts 
/* QL: M174_squbad */
M174_squbad:
/* QL:         tst.b   M174_octch(a6)       are we expecting a square change? */
    tst.b M174_octch(a6)
/* QL:         beq.s   M174_squgo           no - leave well enough alone */
    beq.s M174_squgo
/* QL:         sub.l   a1,d7           put b back as it was */
    sub.l a1,d7
/* QL:         bra.s   M174_doch            go try next octant */
    bra.s M174_doch
/* QL: M174_diabad */
M174_diabad:
/* QL:         tst.b   M174_octch(a6)       are we expecting a diagonal change? */
    tst.b M174_octch(a6)
/* QL:         bne.s   M174_diago           no - leave well enough alone */
    bne.s M174_diago
/* QL:         add.l   a3,d6           put a back as it was */
    add.l a3,d6
/* QL: M174_doch */
M174_doch:
/* QL:         jsr     gw_choct(pc)    go change octant */
    jsr gw_choct(pc)
/* QL:         subq.b  #1,M174_octs(a6)     have we actually used up all our octants? */
    subq.b #1,M174_octs(a6)
/* QL:         bge.s   M174_whatmove        no - try out our new position */
    bge.s M174_whatmove
/* QL:         addq.b  #3,M174_octs(a6)     just maybe... */
    addq.b #3,M174_octs(a6)
/* QL:         bclr    #4,M174_type(a6)     is it an arc, and is this our first time here? */
    bclr #4,M174_type(a6)
/* QL:         bne.s   M174_whatmove        yes - we'll let it carry on looking for end pt. */
    bne.s M174_whatmove
/* QL:         bra     M174_allover         no - then pack it in now */
    bra M174_allover
/* QL: M174_xyok */
M174_xyok:
/* QL:         move.w  #$7ffc,-(sp)    set up our counter for the second point */
    move.w #0x7ffc,-(sp)
/* QL:         cmp.b   M174_octs(a6),d4     have we got more than four octants going? */
    cmp.b M174_octs(a6),d4
/* QL:         bgt.s   M174_nospec */
    bgt.s M174_nospec
/* QL:         addq.w  #8,(sp)         yes - give it a chance to get away */
    addq.w #8,(sp)
/* QL: M174_nospec */
M174_nospec:
/* QL: * Execution routes here are optimised for line drawing */
/* QL: * Plot a point and move on to next */
/* QL: M174_mainloop */
M174_mainloop:
/* QL:         jsr     gw_pixel(pc)    plot the point */
    jsr gw_pixel(pc)
/* QL: M174_whatmove */
M174_whatmove:
/* QL:         move.l  a0,d4           which move is best? */
    move.l a0,d4
/* QL:         bge.s   M174_diamov */
    bge.s M174_diamov
/* QL: * Square move */
/* QL:         add.l   a1,d7           b += k1 */
    add.l a1,d7
/* QL:         bmi.s   M174_squbad          ahah! this won't help, go see what to do! */
    bmi.s M174_squbad
/* QL: M174_squgo */
M174_squgo:
/* QL:         sub.l   a2,d6           a -= k2 */
    sub.l a2,d6
/* QL:         add.l   d7,a0           d += b */
    add.l d7,a0
/* QL:         assert  M174_sdx,M174_sdy-2 */
/* original assertion: M174_sdx,M174_sdy-2 */
/* QL:         move.l  M174_sdx(a6),d4      square move dx and dy */
    move.l M174_sdx(a6),d4
/* QL:         bra.s   M174_doy */
    bra.s M174_doy
/* QL: * Diagonal move */
/* QL: M174_diamov */
M174_diamov:
/* QL:         sub.l   a3,d6           a -= k3 */
    sub.l a3,d6
/* QL:         bmi.s   M174_diabad          ahah! this won't help, go see what to do! */
    bmi.s M174_diabad
/* QL: M174_diago */
M174_diago:
/* QL:         add.l   a2,d7           b += k2 */
    add.l a2,d7
/* QL:         sub.l   d6,a0           d -= a */
    sub.l d6,a0
/* QL:         assert  M174_ddx,M174_ddy-2 */
/* original assertion: M174_ddx,M174_ddy-2 */
/* QL:         move.l  M174_ddx(a6),d4      diagonal move dx and dy */
    move.l M174_ddx(a6),d4
/* QL: * Now adjust the screen address, and masks */
/* QL: M174_doy */
M174_doy:
/* QL:         tst.w   d4 */
    tst.w d4
/* QL:         beq.s   M174_dox */
    beq.s M174_dox
/* QL:         add.w   d4,d1           y += dy */
    add.w d4,d1
/* QL:         add.w   M174_linem+1(a6,d4.w),a5 move scr ptr by a line (words -M174_linel,M174_linel) */
    add.w (M174_linem+1)(a6,d4.w),a5
/* QL:         swap    d3              swap colour mask */
    swap d3
/* QL: M174_dox */
M174_dox:
/* QL:         swap    d4 */
    swap d4
/* QL:         tst.w   d4 */
    tst.w d4
/* QL:         beq.s   M174_countit */
    beq.s M174_countit
/* QL:         bmi.s   M174_xless */
    bmi.s M174_xless
/* QL:         add.w   d4,d0           x += dx */
    add.w d4,d0
/* QL:         ror.w   d4,d2           if dx > 0 rotate pixel mask right by it */
    ror.w d4,d2
/* QL:         bcc.s   M174_countit */
    bcc.s M174_countit
/* QL:         addq.l  #2,a5           if wrapped then move screen ptr forward a word */
    addq.l #2,a5
/* QL:         bra.s   M174_countit */
    bra.s M174_countit
/* QL: M174_xless */
M174_xless:
/* QL:         add.w   d4,d0           x += dx */
    add.w d4,d0
/* QL:         neg.w   d4 */
    neg.w d4
/* QL:         rol.w   d4,d2           if dx < 0 rotate pixel mask left by it negated */
    rol.w d4,d2
/* QL:         bcc.s   M174_countit */
    bcc.s M174_countit
/* QL:         subq.l  #2,a5           if wrapped then move screen ptr back a word */
    subq.l #2,a5
/* QL: M174_countit */
M174_countit:
/* QL:         subq.w  #4,(sp)         count down our M174_special flag + count */
    subq.w #4,(sp)
/* QL:         ble.s   M174_special         if greater than zero, we're happy in main pass */
    ble.s M174_special
/* QL: M174_chkend */
M174_chkend:
/* QL:         cmp.b   #2,M174_octs(a6)     are we into the last couple of octants? */
    cmp.b #(2&255),M174_octs(a6)
/* QL:         bgt.s   M174_mainloop        not even on last one or two */
    bgt.s M174_mainloop
/* QL:         move.w  d1,d5           check if within one pixel in y */
    move.w d1,d5
/* QL:         sub.w   M174_y1(a6),d5 */
    sub.w M174_y1(a6),d5
/* QL:         addq.w  #1,d5 */
    addq.w #1,d5
/* QL:         subq.w  #3,d5 */
    subq.w #3,d5
/* QL:         bcc.s   M174_mainloop        not within one, so carry on */
    bcc.s M174_mainloop
/* QL:         move.w  d0,d4           check if within one pixel in x */
    move.w d0,d4
/* QL:         sub.w   M174_x1(a6),d4 */
    sub.w M174_x1(a6),d4
/* QL:         bpl.s   M174_dxispos */
    bpl.s M174_dxispos
/* QL:         neg.w   d4 */
    neg.w d4
/* QL: M174_dxispos */
M174_dxispos:
/* QL:         cmp.w   M174_xinc(a6),d4     within 1 for 512, or 2 for 256 mode? */
    cmp.w M174_xinc(a6),d4
/* QL:         bhi.s   M174_mainloop        no - carry on */
    bhi.s M174_mainloop
/* QL: M174_lastone */
M174_lastone:
/* QL:         move.w  #4,(sp)         set counter so it'll drop out after this one */
    move.w #4,(sp)
/* QL:                 ;               but make certain this isn't the first or last! */
/* QL: M174_special */
M174_special:
/* QL:         beq.s   M174_allover         pixel count hit zero on main pass */
    beq.s M174_allover
/* QL:         move.w  d0,d5 */
    move.w d0,d5
/* QL:         swap    d5 */
    swap d5
/* QL:         move.w  d1,d5 */
    move.w d1,d5
/* QL:         cmp.l   M174_x0(a6),d5       is this an attempt to redraw the first point? */
    cmp.l M174_x0(a6),d5
/* QL:         beq.s   M174_killit          yes - stop now */
    beq.s M174_killit
/* QL:         cmp.l   M174_x1(a6),d5       is this an attempt to draw the end point? */
    cmp.l M174_x1(a6),d5
/* QL:         bne     M174_mainloop        no - carry on */
    bne M174_mainloop
/* QL: M174_allover */
M174_allover:
/* QL: ;       move.w  #4,(sp)         one last thing ... */
/* QL: ;       subq.b  #8,M174_type(a6)     ... is the degenerate ellipse flag still set? */
/* QL: ;       bne.s   M174_mainloop        yes - then we want to draw the last point */
/* QL: ; The above is not currently in use. If it seems a good idea, the ellipse */
/* QL: ; calculation should change its M174_type flag from $3d to $08 when it decides that */
/* QL: ; an ellipse is degenerate, and changes it to a line. */
/* QL: M174_killit */
M174_killit:
/* QL:         addq.l  #2,sp           lose counter */
    addq.l #2,sp
/* QL:         rts */
    rts 
/* QL:         end */
