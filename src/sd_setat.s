/* ROM section sd_setat */
.balign 2,0
/* QL: * d1 c   attribute on or off / xsize */
/* QL: * d2 c   ysize */
/* QL: * a0 c   pointer to window block */
/* QL: sd_setfl */
sd_setfl:
/* QL:         btst    #M120_mc..m256,M120_sv_mcsta(a6) give up if 256 mode */
    btst #M120_mc..m256,M120_sv_mcsta(a6)
/* QL:         beq.s   M120_ok_rts */
    beq.s M120_ok_rts
/* QL:         moveq   #1<<M120_sd..flsh,d0 mask of flash bit */
    moveq #(1<<M120_sd..flsh),d0
/* QL:         bra.s   M120_check_d1 */
    bra.s M120_check_d1
/* QL: sd_setmd */
sd_setmd:
/* QL:         moveq   #1<<M120_sd..xor!1<<M120_sd..trns,d0 set both trans and xor bits */
    moveq #((1<<M120_sd..xor)|(1<<M120_sd..trns)),d0
/* QL:         lsl.b   #2,d1           move mode bits to the right place */
    lsl.b #2,d1
/* QL:         bra.s   M120_set_bit */
    bra.s M120_set_bit
/* QL: sd_setul */
sd_setul:
/* QL:         moveq   #1<<M120_sd..ulin,d0 set underline bit */
    moveq #(1<<M120_sd..ulin),d0
/* QL: M120_check_d1 */
M120_check_d1:
/* QL:         tst.b   d1              see if parameter is zero */
    tst.b d1
/* QL:         sne     d1              set whole byte */
    sne d1
/* QL:         bra.s   M120_set_bit */
    bra.s M120_set_bit
/* QL: sd_setsz */
sd_setsz:
/* QL:         jsr     sd_donl(pc)     ensure pending newline is done */
    jsr sd_donl(pc)
/* QL:         moveq   #1,d3 */
    moveq #1,d3
/* QL:         moveq   #M120_err.bp,d0 */
    moveq #M120_err.bp,d0
/* QL:         cmp.w   #3,d1           ensure character sizes are in range */
    cmp.w #3,d1
/* QL:         bhi.s   M120_rts0 */
    bhi.s M120_rts0
/* QL:         cmp.w   d3,d2 */
    cmp.w d3,d2
/* QL:         bhi.s   M120_rts0 */
    bhi.s M120_rts0
/* QL:         btst    #M120_mc..m256,M120_sv_mcsta(a6) check for 256 mode */
    btst #M120_mc..m256,M120_sv_mcsta(a6)
/* QL:         beq.s   M120_set_inc */
    beq.s M120_set_inc
/* QL:         bset    d3,d1           force width to double */
    bset d3,d1
/* QL: M120_set_inc */
M120_set_inc:
/* QL:         move.b  M120_xtab(pc,d1.w),M120_sd_xinc+1(a0) ... & reset lsb of increments */
    move.b M120_xtab(pc,d1.w),(M120_sd_xinc+1)(a0)
/* QL: ;       if ntsc */
/* QL: ;       move.b  M120_sv_tvmod(a6),d0  pick up television mode (0,1 or 2) */
/* QL: ;       and.w   #2,d0            mask down to the 525-line bit */
/* QL: ;       add.w   d0,d2            pick up second index if 525 lines */
/* QL: ;       endif */
/* QL:         move.b  M120_ytab(pc,d2.w),M120_sd_yinc+1(a0) */
    move.b M120_ytab(pc,d2.w),(M120_sd_yinc+1)(a0)
/* QL: ;       if ntsc */
/* QL: ;       sub.w   d0,d2            set d2 to rights */
/* QL: ;       endif   ; ntsc */
/* QL:         assert  M120_sd..dbwd-1,M120_sd..exwd,M120_sd..dbht+1 */
/* original assertion: M120_sd..dbwd-1,M120_sd..exwd,M120_sd..dbht+1 */
/* QL:         asr.b   #1,d2 */
    asr.b #1,d2
/* QL:         roxl.b  #M120_sd..exwd,d1    combine the sizes and shift to the right place */
    roxl.b #M120_sd..exwd,d1
/* QL:         moveq   #7<<M120_sd..dbht,d0 set all size bits */
    moveq #(7<<M120_sd..dbht),d0
/* QL:         bsr.s   M120_set_bit */
    bsr.s M120_set_bit
/* QL:         move.w  M120_sd_xpos(a0),d0  check if new character size is off side */
    move.w M120_sd_xpos(a0),d0
/* QL:         add.w   M120_sd_xinc(a0),d0 */
    add.w M120_sd_xinc(a0),d0
/* QL:         cmp.w   M120_sd_xsize(a0),d0 */
    cmp.w M120_sd_xsize(a0),d0
/* QL:         bls.s   M120_chk_botm */
    bls.s M120_chk_botm
/* QL:         jsr     sd_newl(pc)     force newline */
    jsr sd_newl(pc)
/* QL: M120_chk_botm */
M120_chk_botm:
/* QL:         move.w  M120_sd_ysize(a0),d1 */
    move.w M120_sd_ysize(a0),d1
/* QL:         sub.w   M120_sd_yinc(a0),d1 */
    sub.w M120_sd_yinc(a0),d1
/* QL:         blo.s   M120_ok_rts          hmmm... can't fit a char in, so give up? */
    blo.s M120_ok_rts
/* QL:         lea     M120_sd_ypos(a0),a1 */
    lea M120_sd_ypos(a0),a1
/* QL:         sub.w   (a1),d1         check if new character size is off bottom */
    sub.w (a1),d1
/* QL:         bhs.s   M120_ok_rts          ok, it fits */
    bhs.s M120_ok_rts
/* QL:         add.w   d1,(a1)         otherwise, scroll up by minimum possible */
    add.w d1,(a1)
/* QL:         moveq   #M120_sd.scrol,d0 */
    moveq #M120_sd.scrol,d0
/* QL:         jsr     sd_scrol(pc) */
    jsr sd_scrol(pc)
/* QL: M120_ok_rts */
M120_ok_rts:
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL: M120_rts0 */
M120_rts0:
/* QL:         rts */
    rts 
/* QL: M120_set_bit */
M120_set_bit:
/* QL:         and.b   d0,d1           set bits required */
    and.b d0,d1
/* QL:         not.b   d0              invert the mask */
    not.b d0
/* QL:         and.b   d0,M120_sd_cattr(a0) mask out the bits required */
    and.b d0,M120_sd_cattr(a0)
/* QL:         or.b    d1,M120_sd_cattr(a0) and reset them */
    or.b d1,M120_sd_cattr(a0)
/* QL:         bra.s   M120_ok_rts */
    bra.s M120_ok_rts
/* QL: M120_xtab    dc.b    6,8,12,16 */
M120_xtab:
M120_dc_anchor_583:
.byte (6)&255
.byte (8)&255
.byte (12)&255
.byte (16)&255
/* QL: M120_ytab    dc.b    10,20 */
M120_ytab:
M120_dc_anchor_590:
.byte (10)&255
.byte (20)&255
/* QL: ;       if ntsc */
/* QL: ;ytab2 */
/* QL: ;        assert  M120_ytab+2,ytab2 */
/* QL: ;        dc.b    8,16            vertical spacings for ntsc */
/* QL: ;        endif */
/* QL:         end */
