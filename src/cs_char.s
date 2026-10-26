/* ROM section cs_char */
.balign 2,0
/* QL: * Parameters: */
/* QL: * d0 x position */
/* QL: * d1 y position */
/* QL: * d2 character to display */
/* QL: * d3 attributes byte */
/* QL: * a0 channel control block */
/* QL: * a1 pointer to colour masks */
/* QL: * a2 primary fount pointer */
/* QL: * a3 secondary fount pointer */
/* QL: * all registers are preserved */
/* QL: * Internal usage: */
/* QL: * d0 bit 31 set if dh and even row count / lsw row loop index */
/* QL: * d1 bits 5-0 character shift */
/* QL: * d2 character field mask */
/* QL: * d3 bits 31-25 attributes, 31=dw / lsw character row */
/* QL: * d4 bit 31 dh / bit 30 dh row / bit 29 dh blank / lsw char row masked with ink */
/* QL: * d5 flash mask */
/* QL: * d6 paper colour masks */
/* QL: * d7 ink colour masks */
/* QL: * a1 pointer to screen */
/* QL: * a2 pointer to character in fount */
/* QL: * a3 saved char row for dh */
/* QL: * a4 internal jump address */
/* QL: * a5 underscore line number */
/* QL: reglist reg     d0-d7/a1-a5 */
/* QL: cs_char */
cs_char:
/* QL:         movem.l reglist,-(sp) */
    movem.l d0-d7/a1-a5,-(sp)
/* QL: * Set up the colour patterns */
/* QL:         movem.l (a1),d6-d7      fetch patterns */
    movem.l (a1),d6-d7
/* QL:         btst    #0,d1           odd row? */
    btst #0,d1
/* QL:         bne.s   M180_masks_ok        ... yes - carry on */
    bne.s M180_masks_ok
/* QL:         swap    d6              ... no - swap the colour masks */
    swap d6
/* QL:         swap    d7 */
    swap d7
/* QL: M180_masks_ok */
M180_masks_ok:
/* QL: * Set the fount address */
/* QL:         and.w   #$ff,d2         character is eight bit */
    and.w #0xff,d2
/* QL:         sub.b   (a2)+,d2        take away minimum character in first fount */
    sub.b (a2)+,d2
/* QL:         cmp.b   (a2)+,d2        is it in range? */
    cmp.b (a2)+,d2
/* QL:         bls.s   M180_calc_font       ... yes - use it */
    bls.s M180_calc_font
/* QL:         add.b   -2(a2),d2       ... no - restore character value */
    add.b (-2)(a2),d2
/* QL:         move.l  a3,a2           try alternative fount */
    move.l a3,a2
/* QL:         sub.b   (a2)+,d2        take away minimum character */
    sub.b (a2)+,d2
/* QL:         cmp.b   (a2)+,d2        is it in range? */
    cmp.b (a2)+,d2
/* QL:         bhi.s   M180_font_set        ... no - we're already at invalid char pattern */
    bhi.s M180_font_set
/* QL: M180_calc_font */
M180_calc_font:
/* QL:         add.w   d2,a2           address is now 9*character value on from base */
    add.w d2,a2
/* QL:         lsl.w   #3,d2 */
    lsl.w #3,d2
/* QL:         add.w   d2,a2 */
    add.w d2,a2
/* QL: M180_font_set */
M180_font_set:
/* QL: * Now find the screen position */
/* QL:         move.l  M180_sd_scrb(a0),a1  base of screen */
    move.l M180_sd_scrb(a0),a1
/* QL:         mulu    M180_sd_linel(a0),d1 and y * bytes per row */
    mulu M180_sd_linel(a0),d1
/* QL:         add.l   d1,a1           gives the row address */
    add.l d1,a1
/* QL:         moveq   #7,d1 */
    moveq #7,d1
/* QL:         and.w   d0,d1           the three ls bits of x form the shift */
    and.w d0,d1
/* QL:         lsr.w   #3,d0           and 8 pixels per byte */
    lsr.w #3,d0
/* QL:         add.w   d0,d0           ... or rather per pair of bytes */
    add.w d0,d0
/* QL:         add.w   d0,a1           ... finishes off the screen address */
    add.w d0,a1
/* QL: * Set up the attributes */
/* QL:         move.w  #-1,a5          underline at line -1!! */
    move.w #(-1),a5
/* QL:         btst    #M180_sd..ulin,d3    is underline required */
    btst #M180_sd..ulin,d3
/* QL:         beq.s   M180_ul_ok           no - leave that */
    beq.s M180_ul_ok
/* QL:         addq.l  #2,a5           yes - underline at row 1 */
    addq.l #2,a5
/* QL: M180_ul_ok */
M180_ul_ok:
/* QL:         moveq   #16,d4          max field width 16 and clear dh flags */
    moveq #16,d4
/* QL:         move.w  M180_sd_xinc(a0),d2 */
    move.w M180_sd_xinc(a0),d2
/* QL:         beq     M180_getout          just in case x-inc was zero! */
    beq M180_getout
/* QL:         sub.w   d2,d4 */
    sub.w d2,d4
/* QL:         bcc.s   M180_inc_ok */
    bcc.s M180_inc_ok
/* QL:         moveq   #0,d4           if x-inc is greater than 16, we stop at 16 */
    moveq #0,d4
/* QL:         ; This needs a bit more fiddling to stick paper into any further */
/* QL:         ; columns when M180_normal writing is occuring.... */
/* QL: M180_inc_ok */
M180_inc_ok:
/* QL:         moveq   #0,d2           start field mask */
    moveq #0,d2
/* QL:         bset    d4,d2 */
    bset d4,d2
/* QL:         neg.w   d2 */
    neg.w d2
/* QL:         ror.l   #8,d2 */
    ror.l #8,d2
/* QL:         ror.l   d1,d2           rotate character mask to position */
    ror.l d1,d2
/* QL:         moveq   #0,d5           clear flash mask */
    moveq #0,d5
/* QL:         ror.l   #M180_sd..dbwd+1,d3  are characters double width */
    ror.l #(M180_sd..dbwd+1),d3
/* QL:         bpl.s   M180_width_ok        ... no - that's done */
    bpl.s M180_width_ok
/* QL:         addq.w  #8,d1           set double width shift */
    addq.w #8,d1
/* QL:         btst    #31-M180_sd..dbwd+M180_sd..flsh,d3 is flash required? */
    btst #((31-M180_sd..dbwd)+M180_sd..flsh),d3
/* QL:         beq.s   M180_width_ok        ... no - check for extend */
    beq.s M180_width_ok
/* QL:         move.w  #$4000,d5       set flash on bit */
    move.w #0x4000,d5
/* QL:         bchg    d4,d5           set flash off bit */
    bchg d4,d5
/* QL:         ror.l   d1,d5           rotate flash mask to position */
    ror.l d1,d5
/* QL: M180_width_ok */
M180_width_ok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         move.w  M180_sd_yinc(a0),d0 */
    move.w M180_sd_yinc(a0),d0
/* QL:         beq.l   M180_getout          let's not mess with zero height chars! */
    beq.w M180_getout
/* QL:         subq.w  #1,d0           ready for dbra */
    subq.w #1,d0
/* QL:         btst    #31-M180_sd..dbwd+M180_sd..dbht,d3 are tall characters required? */
    btst #((31-M180_sd..dbwd)+M180_sd..dbht),d3
/* QL:         beq.s   M180_hght_ok */
    beq.s M180_hght_ok
/* QL:         moveq   #-1,d4          set up tall flags */
    moveq #(-1),d4
/* QL:         ror.l   #1,d0           halve row count but save lsb in bit 31 */
    ror.l #1,d0
/* QL: M180_hght_ok */
M180_hght_ok:
/* QL: * Now set up the jump address for character writing mode */
/* QL:         lea     M180_normal,a4       assume M180_normal writing */
    lea M180_normal(pc),a4
/* QL:         btst    #31-M180_sd..dbwd+M180_sd..trns,d3 check for transparent strip */
    btst #((31-M180_sd..dbwd)+M180_sd..trns),d3
/* QL:         beq.s   M180_col_loop */
    beq.s M180_col_loop
/* QL:         subq.l  #M180_normal-M180_transp,a4 */
.word 20876|((((M180_normal-M180_transp))&7)<<9)
/* QL:         btst    #31-M180_sd..dbwd+M180_sd..xor,d3 check for M180_xor ink */
    btst #((31-M180_sd..dbwd)+M180_sd..xor),d3
/* QL:         beq.s   M180_col_loop */
    beq.s M180_col_loop
/* QL:         subq.l  #M180_transp-M180_xor,a4 */
.word 20876|((((M180_transp-M180_xor))&7)<<9)
/* QL: * Main loop for each word column occupied by character */
/* QL: collist reg     d0/d6-d7/a1-a2 */
/* QL: M180_col_loop */
M180_col_loop:
/* QL:         movem.l collist,-(sp) */
    movem.l d0/d6-d7/a1-a2,-(sp)
/* QL:         move.b  d2,d3           replicate character mask byte */
    move.b d2,d3
/* QL:         lsl.w   #8,d2 */
    lsl.w #8,d2
/* QL:         move.b  d3,d2 */
    move.b d3,d2
/* QL:         lsl.w   #8,d5           move flash mask up to ms byte */
    lsl.w #8,d5
/* QL: * Inner loop for each row */
/* QL: M180_row_loop */
M180_row_loop:
/* QL:         cmp.w   #9,d0           row number 9 or greater? */
    cmp.w #9,d0
/* QL:         bge.s   M180_blank_row       if so, jump, to get blank line */
    bge.s M180_blank_row
/* QL:         cmp.w   a5,d0           check for underline row */
    cmp.w a5,d0
/* QL:         beq.s   M180_set_under */
    beq.s M180_set_under
/* QL:         clr.w   d3              clear upper byte */
    clr.w d3
/* QL:         move.b  (a2)+,d3        and fetch next row */
    move.b (a2)+,d3
/* QL:         beq.s   M180_blank_row       if zero - ignore all the next rubbish */
    beq.s M180_blank_row
/* QL:         tst.l   d3              for double width, M180_spread characters out */
    tst.l d3
/* QL:         bpl.s   M180_shft_chr */
    bpl.s M180_shft_chr
/* QL:         tst.l   d5              are we setting flash at all? */
    tst.l d5
/* QL:         beq.s   M180_noflash         no - that's ok */
    beq.s M180_noflash
/* QL:         and.b   #$7f,d3         yes - can't allow first bit to set ink! */
    and.b #(0x7f&255),d3
/* QL: M180_noflash */
M180_noflash:
/* QL:         move.w  d3,d4 */
    move.w d3,d4
/* QL:         and.b   #15,d4 */
    and.b #(15&255),d4
/* QL:         lsr.b   #4,d3 */
    lsr.b #4,d3
/* QL:         move.b  M180_spread(pc,d3.w),d3 */
    move.b M180_spread(pc,d3.w),d3
/* QL:         lsl.w   #8,d3 */
    lsl.w #8,d3
/* QL:         move.b  M180_spread(pc,d4.w),d3 */
    move.b M180_spread(pc,d4.w),d3
/* QL: M180_shft_chr */
M180_shft_chr:
/* QL:         ror.w   d1,d3           shift to position and replicate */
    ror.w d1,d3
/* QL:         move.b  d3,d4           replicate a byte */
    move.b d3,d4
/* QL:         lsl.w   #8,d3 */
    lsl.w #8,d3
/* QL:         move.b  d4,d3 */
    move.b d4,d3
/* QL:         and.w   d2,d3           mask character with field */
    and.w d2,d3
/* QL: M180_mask_ink */
M180_mask_ink:
/* QL:         move.w  d3,a3           save masked character row in case dh */
    move.w d3,a3
/* QL:         move.w  d3,d4 */
    move.w d3,d4
/* QL:         and.w   d7,d4           mask character with ink */
    and.w d7,d4
/* QL:         or.w    d5,d4           put flash in */
    or.w d5,d4
/* QL:         jmp     (a4)            jump to code for writing mode */
    jmp (a4)
/* QL: M180_spread */
M180_spread:
/* QL:         dc.l    $00030c0f,$30333c3f,$c0c3cccf,$f0f3fcff */
.balign 2,0
M180_dc_anchor_442:
.long 0x00030c0f
.long 0x30333c3f
.long 0xc0c3cccf
.long 0xf0f3fcff
/* QL: M180_set_under */
M180_set_under:
/* QL:         move.w  d2,d3           full row underline */
    move.w d2,d3
/* QL:         addq.l  #1,a2           move fount pointer past ignored byte */
    addq.l #1,a2
/* QL:         move.w  d3,a3           save masked character row in case dh */
    move.w d3,a3
/* QL:         move.w  d3,d4 */
    move.w d3,d4
/* QL:         and.w   d7,d4           mask character with ink (can't flash) */
    and.w d7,d4
/* QL:         jmp     (a4)            jump to code for writing mode */
    jmp (a4)
/* QL: M180_dh_row */
M180_dh_row:
/* QL:         bchg    #30,d4          toggle row bit */
    bchg #30,d4
/* QL:         beq.s   M180_next_row        if it was already second row, carry on M180_normal */
    beq.s M180_next_row
/* QL:         tst.l   d0              is it the last row of an odd height? */
    tst.l d0
/* QL:         beq.s   M180_col_end         yes - then it's finished */
    beq.s M180_col_end
/* QL:         bset    #29,d4          is it 2nd row of a blank character? */
    bset #29,d4
/* QL:         beq.s   M180_blank_2nd       yes - go do that */
    beq.s M180_blank_2nd
/* QL:         move.w  a3,d3           restore the character */
    move.w a3,d3
/* QL:         bra.s   M180_mask_ink        go do M180_normal stuff  */
    bra.s M180_mask_ink
/* QL: M180_blank_row */
M180_blank_row:
/* QL:         bclr    #29,d4          clear flag in case dh */
    bclr #29,d4
/* QL: M180_blank_2nd */
M180_blank_2nd:
/* QL:         btst    #31-M180_sd..dbwd+M180_sd..trns,d3 is it anything but M180_normal writing? */
    btst #((31-M180_sd..dbwd)+M180_sd..trns),d3
/* QL:         bne.s   M180_end_row         yes - nothing to do */
    bne.s M180_end_row
/* QL:         move.w  (a1),d4         pick up existing stuff */
    move.w (a1),d4
/* QL:         eor.w   d6,d4           flip with paper pattern bits */
    eor.w d6,d4
/* QL:         and.w   d2,d4           keep just the field area we want to affect */
    and.w d2,d4
/* QL: M180_xor */
M180_xor:
/* QL:         eor.w   d4,(a1)         M180_xor into screen */
    eor.w d4,(a1)
/* QL:         bra.s   M180_end_row */
    bra.s M180_end_row
/* QL: M180_transp */
M180_transp:
/* QL:         not.w   d3              mask in background not part of character */
    not.w d3
/* QL:         and.w   (a1),d3 */
    and.w (a1),d3
/* QL:         bra.s   M180_combine */
    bra.s M180_combine
/* QL: M180_normal */
M180_normal:
/* QL:         eor.w   d2,d3           invert character in field */
    eor.w d2,d3
/* QL:         and.w   d6,d3           mask inverse character with paper */
    and.w d6,d3
/* QL:         or.w    d4,d3           put in ink/flash */
    or.w d4,d3
/* QL:         move.w  d2,d4           get inverted field mask in d4 */
    move.w d2,d4
/* QL:         not.w   d4 */
    not.w d4
/* QL:         and.w   (a1),d4         blank out character area of screen */
    and.w (a1),d4
/* QL: M180_combine */
M180_combine:
/* QL:         or.w    d3,d4           M180_combine the two */
    or.w d3,d4
/* QL:         move.w  d4,(a1)         and put in screen */
    move.w d4,(a1)
/* QL: M180_end_row */
M180_end_row:
/* QL:         swap    d6              swap colours */
    swap d6
/* QL:         swap    d7 */
    swap d7
/* QL:         add.w   M180_sd_linel(a0),a1 take next line */
    add.w M180_sd_linel(a0),a1
/* QL:         tst.l   d4              check for double height */
    tst.l d4
/* QL:         bmi.s   M180_dh_row */
    bmi.s M180_dh_row
/* QL: M180_next_row */
M180_next_row:
/* QL:         dbra    d0,M180_row_loop */
    dbra d0,M180_row_loop
/* QL: M180_col_end */
M180_col_end:
/* QL:         movem.l (sp)+,collist   recover various registers */
    movem.l (sp)+,d0/d6-d7/a1-a2
/* QL:         clr.w   d2              check for any remaining bits */
    clr.w d2
/* QL:         rol.l   #8,d2           ... by rotating mask to next byte */
    rol.l #8,d2
/* QL:         bne.s   M180_nxt_col         if there's more, go do it */
    bne.s M180_nxt_col
/* QL: M180_getout */
M180_getout:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d0-d7/a1-a5
/* QL:         rts */
    rts 
/* QL: M180_nxt_col */
M180_nxt_col:
/* QL:         clr.w   d5              roll in next byte's worth of flash mask */
    clr.w d5
/* QL:         rol.l   #8,d5 */
    rol.l #8,d5
/* QL:         asr.l   #4,d4           reset dh flags */
    asr.l #4,d4
/* QL:         eor.b   #8,d1           flip bytes on the rotate */
    eor.b #(8&255),d1
/* QL:         addq.l  #2,a1           move to next column */
    addq.l #2,a1
/* QL:         bra.l   M180_col_loop */
    bra.w M180_col_loop
/* QL:         end */
