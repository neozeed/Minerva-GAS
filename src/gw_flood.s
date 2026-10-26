/* ROM section gw_flood */
.balign 2,0
/* QL: * d0 -  o- error code */
/* QL: * d1 -i  - parameter */
/* QL: * a0 -ip - channel definition block */
/* QL: * a1 destroyed */
/* QL: gw_floof */
gw_floof:
/* QL:         moveq   #0,d1           force M177_flood to turn off */
    moveq #0,d1
/* QL: gw_flood */
gw_flood:
/* QL:         move.l  d1,-(sp) */
    move.l d1,-(sp)
/* QL:         lea     M177_sd_fuse(a0),a1  set convenient pointer */
    lea M177_sd_fuse(a0),a1
/* QL:         lsr.l   #1,d1           check parameter */
    lsr.l #1,d1
/* QL:         beq.s   M177_flood           0/1, go do M177_flood stuff */
    beq.s M177_flood
/* QL:         bcc.s   M177_vector */
    bcc.s M177_vector
/* QL:         clr.l   (sp)            an odd number restores default fill action */
    clr.l (sp)
/* QL: M177_vector */
M177_vector:
/* QL:         move.l  (sp)+,(a1)      update the user M177_vector */
    move.l (sp)+,(a1)
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M177_flood */
M177_flood:
/* QL:         move.b  M177_sd_fmod-M177_sd_fuse(a1),d0 check current fill mode, d0 zero if off */
    move.b (M177_sd_fmod-M177_sd_fuse)(a1),d0
/* QL:         assert  M177_sd_fbuf,M177_sd_fuse-4 */
/* original assertion: M177_sd_fbuf,M177_sd_fuse-4 */
/* QL:         move.l  -(a1),a0        pick up any old buffer */
    move.l -(a1),a0
/* QL:         beq.s   M177_wasnt           skip if current fill mode was zero */
    beq.s M177_wasnt
/* QL:         jsr     mm_rechp(pc)    if it was on, release the buffer and say so */
    jsr mm_rechp(pc)
/* QL: M177_wasnt */
M177_wasnt:
/* QL:         move.l  (sp)+,d1 */
    move.l (sp)+,d1
/* QL:         beq.s   M177_clear           if new mode is zero then wipe it out */
    beq.s M177_clear
/* QL:         assert  M177_sd_ysize,M177_sd_borwd-2 */
/* original assertion: M177_sd_ysize,M177_sd_borwd-2 */
/* QL:         movem.w M177_sd_ysize-M177_sd_fbuf(a1),d0-d1 */
    movem.w (M177_sd_ysize-M177_sd_fbuf)(a1),d0-d1
/* QL:         add.w   d1,d1           including borders (so only wdef needs care) */
    add.w d1,d1
/* QL:         add.w   d0,d1           get total count of rasters */
    add.w d0,d1
/* QL:         addq.w  #(M177_hp_end+3)>>2,d1 */
    addq.w #((M177_hp_end+3)>>2),d1
/* QL:         lsl.l   #2,d1           space required is header+4*rasters */
    lsl.l #2,d1
/* QL:         jsr     mm_alchp(pc)    allocate and M177_clear a new buffer */
    jsr mm_alchp(pc)
/* QL:         beq.s   M177_setit */
    beq.s M177_setit
/* QL: M177_clear */
M177_clear:
/* QL:         sub.l   a0,a0           turning mode off or any error, M177_clear buffer */
    sub.l a0,a0
/* QL: M177_setit */
M177_setit:
/* QL:         move.l  a0,(a1)+        update the buffer pointer */
    move.l a0,(a1)+
/* QL:         sne     d1 */
    sne d1
/* QL:         neg.b   d1 */
    neg.b d1
/* QL:         move.b  d1,M177_sd_fmod-M177_sd_fuse(a1) finally, set fill mode zero/one */
    move.b d1,(M177_sd_fmod-M177_sd_fuse)(a1)
/* QL:         lea     -M177_sd_fuse(a1),a0 put back channel definition block pointer */
    lea (-M177_sd_fuse)(a1),a0
/* QL:         rts */
    rts 
/* QL:         end */
