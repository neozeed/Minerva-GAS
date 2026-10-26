/* ROM section gw_pixad */
.balign 2,0
/* QL: * d0 -ip - x coordinate (lsw) */
/* QL: * d1 -ip - y coordinate (lsw) */
/* QL: * d2 -  o- pixel mask within word (msw preserved) */
/* QL: * d3 -  o- colour masks (lsw for line at y coordinate) */
/* QL: * a0 -ip - channel definition block */
/* QL: * a5 -  o- screen address of word containing pixel */
/* QL: * a6 -ip - graphics stack frame */
/* QL: gw_pixad */
gw_pixad:
/* QL:         move.w  d0,-(sp)        save x coordinate */
    move.w d0,-(sp)
/* QL:         move.w  d1,d2           copy y coordinate */
    move.w d1,d2
/* QL:         add.w   M172_sd_xmin(a0),d0  adjust for window position */
    add.w M172_sd_xmin(a0),d0
/* QL:         add.w   M172_sd_ymin(a0),d2 */
    add.w M172_sd_ymin(a0),d2
/* QL:         move.l  M172_sd_scrb(a0),a5  get screen base address */
    move.l M172_sd_scrb(a0),a5
/* QL:         move.w  M172_sd_linel(a0),d3 */
    move.w M172_sd_linel(a0),d3
/* QL:         move.w  d3,M172_linel(a6)    set line length */
    move.w d3,M172_linel(a6)
/* QL:         neg.w   d3 */
    neg.w d3
/* QL:         move.w  d3,M172_linem(a6)    and its negation */
    move.w d3,M172_linem(a6)
/* QL:         muls    d2,d3           multiply line length by line number (nb signed) */
    muls d2,d3
/* QL:         sub.l   d3,a5           pixel line address (note d3 was negated) */
    sub.l d3,a5
/* QL:         move.l  M172_sd_imask(a0),d3 basic colour mask */
    move.l M172_sd_imask(a0),d3
/* QL:         lsr.b   #1,d2 */
    lsr.b #1,d2
/* QL:         bcs.s   M172_noswap */
    bcs.s M172_noswap
/* QL:         swap    d3              if line number is even then swap colour masks */
    swap d3
/* QL: M172_noswap */
M172_noswap:
/* QL:         move.w  #$8080,d2       basic pixel mask for 4 colour */
    move.w #0x8080,d2
/* QL:         btst    d2,M172_xinc+1(a6) */
    btst d2,(M172_xinc+1)(a6)
/* QL:         bne.s   M172_rotate */
    bne.s M172_rotate
/* QL:         move.w  #$c0c0,d2       basic pixel mask for 8 colour */
    move.w #0xc0c0,d2
/* QL: M172_rotate */
M172_rotate:
/* QL:         ror.w   d0,d2           M172_rotate pixel mask M172_over pixel position in word */
    ror.w d0,d2
/* QL:         asr.w   #3,d0           word number in line */
    asr.w #3,d0
/* QL:         add.w   d0,d0           byte offset in line */
    add.w d0,d0
/* QL:         add.w   d0,a5           finally, pixel word address */
    add.w d0,a5
/* QL:         move.w  (sp)+,d0        reload original x coordinate */
    move.w (sp)+,d0
/* QL:         rts */
    rts 
/* QL:         end */
