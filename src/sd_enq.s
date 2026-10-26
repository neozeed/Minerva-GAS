/* ROM section sd_enq */
.balign 2,0
/* QL: * a0 c p base of definition block */
/* QL: * a1 c p base of enquiry block */
/* QL: sd_pxenq */
sd_pxenq:
/* QL:         jsr     sd_donl(pc)     do newline if pending */
    jsr sd_donl(pc)
/* QL: M112_get_size */
M112_get_size:
/* QL:         move.l  M112_sd_xsize(a0),(a1) get size */
    move.l M112_sd_xsize(a0),(a1)
/* QL:         move.l  M112_sd_xpos(a0),4(a1) get position */
    move.l M112_sd_xpos(a0),4(a1)
/* QL:         bra.s   M112_okrts */
    bra.s M112_okrts
/* QL: sd_chenq */
sd_chenq:
/* QL:         bsr.s   sd_pxenq        fetch pixel size / position */
    bsr.s sd_pxenq
/* QL:         addq.l  #4,a0           temporarily adjust window block pointer */
    addq.l #4,a0
/* QL:         addq.l  #6,a1           point to y position */
    addq.l #6,a1
/* QL:         bsr.s   M112_chr_calc        recalculate y size and position */
    bsr.s M112_chr_calc
/* QL:         addq.l  #2,a1           point to x position */
    addq.l #2,a1
/* QL: M112_chr_calc */
M112_chr_calc:
/* QL:         subq.l  #2,a0           move window pointer back */
    subq.l #2,a0
/* QL:         bsr.s   M112_chr_posn        first do position */
    bsr.s M112_chr_posn
/* QL:         subq.l  #4,a1           then move back to size */
    subq.l #4,a1
/* QL: M112_chr_posn */
M112_chr_posn:
/* QL:         move.w  (a1),d0         get pixel size / position (msw is already zero) */
    move.w (a1),d0
/* QL:         divu    M112_sd_xinc(a0),d0  divide by character increment */
    divu M112_sd_xinc(a0),d0
/* QL:         move.w  d0,(a1)         put it back */
    move.w d0,(a1)
/* QL: M112_okrts */
M112_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL:         end */
