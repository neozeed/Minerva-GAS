/* ROM section sd_wdef */
.balign 2,0
/* QL: * d0 -  o- M113_error code */
/* QL: * d1 -i  - M113_border colour */
/* QL: * d2 -i  - M113_border width (we now use only the lsb, to avoid bug in TK2!) */
/* QL: * a0 -ip - window channel definition block */
/* QL: * a1 -i  - pointer to width, height, x and y (wdef only) */
/* QL: * d3-d4 destroyed */
/* QL: reglist reg     d1-d2/a2 */
/* QL: sd_wdef */
sd_wdef:
/* QL:         movem.l reglist,-(sp)   save registers, all but a2 get scrapped really */
    movem.l d1-d2/a2,-(sp)
/* QL:         move.l  a1,a2           save param pointer */
    move.l a1,a2
/* QL:         jsr     gw_floof(pc)    force flood off, in case window height changes */
    jsr gw_floof(pc)
/* QL:         jsr     sd_home(pc)     home the cursor */
    jsr sd_home(pc)
/* QL:         movem.w (a2),d0-d3      load up window definition */
    movem.w (a2),d0-d3
/* QL:         exg     d0,d2           put xmin */
    exg d0,d2
/* QL:         exg     d1,d3           and ymin in the right place */
    exg d1,d3
/* QL:         move.w  #256,d4         bit number 0 and ready to check y */
    move.w #256,d4
/* QL:         bclr    d4,d0           ensure both xwidth and xmin are even */
    bclr d4,d0
/* QL:         bclr    d4,d2 */
    bclr d4,d2
/* QL:         bsr.s   M113_xycheck         check that ymin/ywidth are sensible */
    bsr.s M113_xycheck
/* QL:         add.w   d4,d4           = 512, ready to check x */
    add.w d4,d4
/* QL:         bsr.s   M113_xycheck         check that xmin/xwidth are sensible */
    bsr.s M113_xycheck
/* QL:         clr.w   M113_sd_borwd(a0)    reset M113_border width (lwr: why?) */
    clr.w M113_sd_borwd(a0)
/* QL:         bra.s   M113_border */
    bra.s M113_border
/* QL: M113_xycheck */
M113_xycheck:
/* QL:         tst.w   d3 */
    tst.w d3
/* QL:         ble.s   M113_pop_err         width/height must be strict positive */
    ble.s M113_pop_err
/* QL:         add.w   d3,d1           get rhs/bot */
    add.w d3,d1
/* QL:         cmp.w   d4,d1           compare to max */
    cmp.w d4,d1
/* QL:         bhi.s   M113_pop_err         must be at most that */
    bhi.s M113_pop_err
/* QL:         sub.w   d3,d1           go back to lhs/top */
    sub.w d3,d1
/* QL:         bmi.s   M113_pop_err         that must be positive */
    bmi.s M113_pop_err
/* QL:         exg     d0,d1           swap lhs/top for next call */
    exg d0,d1
/* QL:         exg     d3,d2           swap width/height for next call */
    exg d3,d2
/* QL:         rts */
    rts 
/* QL: * A little piece of code to adjust a window for a M113_border */
/* QL: M113_rst_wind */
M113_rst_wind:
/* QL:         neg.w   d4              remove M113_border */
    neg.w d4
/* QL: M113_adj_wind */
M113_adj_wind:
/* QL:         add.w   d4,d1           add M113_border to ymin */
    add.w d4,d1
/* QL:         add.w   d4,d4           double the M113_border */
    add.w d4,d4
/* QL:         sub.w   d4,d3           and take it away from ysize */
    sub.w d4,d3
/* QL:         ble.s   M113_pop_err */
    ble.s M113_pop_err
/* QL:         add.w   d4,d0           add M113_border to xmin */
    add.w d4,d0
/* QL:         add.w   d4,d4           double it again */
    add.w d4,d4
/* QL:         sub.w   d4,d2           and take it away from xsize */
    sub.w d4,d2
/* QL:         ble.s   M113_pop_err */
    ble.s M113_pop_err
/* QL:         asr.w   #2,d4           restore M113_border width and set z if it is zero */
    asr.w #2,d4
/* QL:         rts */
    rts 
/* QL: M113_pop_err */
M113_pop_err:
/* QL:         addq.l  #4,sp           remove return address */
    addq.l #4,sp
/* QL: M113_error */
M113_error:
/* QL:         moveq   #M113_err.or,d0      out of range */
    moveq #M113_err.or,d0
/* QL:         bra.s   M113_exit */
    bra.s M113_exit
/* QL: M113_fill */
M113_fill:
/* QL:         jmp     cs_fill(pc) */
    jmp cs_fill(pc)
/* QL: * Entry point to just redefine a M113_border */
/* QL: sd_bordr */
sd_bordr:
/* QL:         move.b  d1,M113_sd_bcolr(a0) save M113_border colour */
    move.b d1,M113_sd_bcolr(a0)
/* QL: sd_bordn */
sd_bordn:
/* QL:         movem.l reglist,-(sp)   save registers, all but a2 get scrapped really */
    movem.l d1-d2/a2,-(sp)
/* QL:         cmp.w   M113_sd_borwd(a0),d2 has M113_border width changed? */
    cmp.w M113_sd_borwd(a0),d2
/* QL:         beq.s   M113_rem_bord */
    beq.s M113_rem_bord
/* QL:         jsr     sd_home(pc)     home cursor */
    jsr sd_home(pc)
/* QL: M113_rem_bord */
M113_rem_bord:
/* QL:         movem.w M113_sd_xmin(a0),d0-d4 get old window definition */
    movem.w M113_sd_xmin(a0),d0-d4
/* QL:         bsr.s   M113_rst_wind        and remove the M113_border */
    bsr.s M113_rst_wind
/* QL: M113_border */
M113_border:
/* QL:         move.b  7(sp),d4        get new M113_border width */
    move.b 7(sp),d4
/* QL:         ext.w   d4              check M113_border width, ignoring msb (tk2 bug!!!) */
    ext.w d4
/* QL:         bmi.s   M113_error           get out if it's silly */
    bmi.s M113_error
/* QL:         bsr.s   M113_adj_wind        adjust the window and set status on d4 */
    bsr.s M113_adj_wind
/* QL:         movem.w d0-d4,M113_sd_xmin(a0) put in definition block */
    movem.w d0-d4,M113_sd_xmin(a0)
/* QL:         beq.s   M113_exit_ok         if there is no M113_border - give up now */
    beq.s M113_exit_ok
/* QL:         move.l  (sp),d1         get new M113_border colour */
    move.l (sp),d1
/* QL:         cmp.b   #128,d1         check if it is transparent */
    cmp.b #(128&255),d1
/* QL:         beq.s   M113_exit_ok */
    beq.s M113_exit_ok
/* QL:         move.l  sp,a1           put mask on stack */
    move.l sp,a1
/* QL:         jsr     cs_color(pc)    convert to colour mask */
    jsr cs_color(pc)
/* QL:         move.w  M113_sd_ymin(a0),d1  restore the ymin */
    move.w M113_sd_ymin(a0),d1
/* QL: * Now to draw the M113_border */
/* QL: * For convenience we reset the window to full size */
/* QL:         bsr.s   M113_rst_wind */
    bsr.s M113_rst_wind
/* QL:         neg.w   d4 */
    neg.w d4
/* QL:         exg     d4,d3           set ysize to M113_border width */
    exg d4,d3
/* QL:         bsr.s   M113_fill            M113_fill 1 */
    bsr.s M113_fill
/* QL:         add.w   d4,d1           set ymin to bottom */
    add.w d4,d1
/* QL:         sub.w   d3,d1           less M113_border width */
    sub.w d3,d1
/* QL:         bsr.s   M113_fill            M113_fill 2 */
    bsr.s M113_fill
/* QL:         exg     d4,d3           restore ysize */
    exg d4,d3
/* QL:         sub.w   d3,d1           ymin less a M113_border */
    sub.w d3,d1
/* QL:         add.w   d4,d4           double the M113_border */
    add.w d4,d4
/* QL:         sub.w   d4,d3           ysize less two borders */
    sub.w d4,d3
/* QL:         add.w   d4,d1           ymin plus M113_border */
    add.w d4,d1
/* QL:         exg     d4,d2           set xsize to M113_border width */
    exg d4,d2
/* QL:         bsr.s   M113_fill            M113_fill 3 */
    bsr.s M113_fill
/* QL:         add.w   d4,d0           set xmin to rhs */
    add.w d4,d0
/* QL:         sub.w   d2,d0           less M113_border width */
    sub.w d2,d0
/* QL:         bsr.s   M113_fill            M113_fill 4 */
    bsr.s M113_fill
/* QL: *       1111111111111111111     This is the pattern of filling that went on */
/* QL: *       1111111111111111111     above. Note that (unlike older versions) the */
/* QL: *       3333           4444     corners are not filled in twice. */
/* QL: *       3333           4444 */
/* QL: *       3333           4444 */
/* QL: *       2222222222222222222 */
/* QL: *       2222222222222222222 */
/* QL: M113_exit_ok */
M113_exit_ok:
/* QL:         moveq   #0,d0           no M113_error */
    moveq #0,d0
/* QL: M113_exit */
M113_exit:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d2/a2
/* QL:         rts */
    rts 
/* QL:         end */
