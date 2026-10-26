/* ROM section cs_area */
.balign 2,0
/* QL: * d0 c p x origin */
/* QL: * d1 c p y origin */
/* QL: * d2 c p width */
/* QL: * d3 c p height */
/* QL: * d4 c p distance to M182_scroll or pan */
/* QL: * a1 c p pointer to colour masks */
/* QL: * Internal register usage */
/* QL: * d0-d2   scratch */
/* QL: * d3      width in long words -1 (=a5/4) */
/* QL: * d4      left hand edge M182_mask */
/* QL: * d5      M182_right hand edge M182_mask */
/* QL: * d6      one stipple row colour */
/* QL: * d7      the other stipple row colour */
/* QL: * a0      channel definition block (i hope! lwr) */
/* QL: * a1      origin of area / running pointer to destination */
/* QL: * a2      end of area */
/* QL: * a3      increment between lines */
/* QL: * a4      running pointer to source */
/* QL: * a5      width -4 (=d3*4) */
/* QL: * a6      address of operation routine */
/* QL: * Set M182_up the colour masks in d6/d7 */
/* QL: M182_set_colm */
M182_set_colm:
/* QL:         move.l  (a1),d6         get even lines in upper, odd in lower word */
    move.l (a1),d6
/* QL:         move.w  d6,d7 */
    move.w d6,d7
/* QL:         swap    d7 */
    swap d7
/* QL:         move.w  d6,d7           put odd lines in both halves of d7 */
    move.w d6,d7
/* QL:         move.w  (a1),d6         put even lines in both halves of d6 */
    move.w (a1),d6
/* QL:         btst    #0,d1 */
    btst #0,d1
/* QL:         bne.s   M182_set_addr */
    bne.s M182_set_addr
/* QL:         exg     d6,d7           if even nline - swap them over */
    exg d6,d7
/* QL: * Set M182_up all the registers for addressing an area */
/* QL: M182_set_addr */
M182_set_addr:
/* QL:         add.w   d0,d2           find rhs */
    add.w d0,d2
/* QL:         move.w  M182_sd_linel(a0),a3 get line length */
    move.w M182_sd_linel(a0),a3
/* QL:         move.w  a3,d5 */
    move.w a3,d5
/* QL:         mulu    d5,d1           set y address offset */
    mulu d5,d1
/* QL:         move.l  M182_sd_scrb(a0),a1  + base of screen */
    move.l M182_sd_scrb(a0),a1
/* QL:         add.l   d1,a1 */
    add.l d1,a1
/* QL:         mulu    d5,d3           find end of screen */
    mulu d5,d3
/* QL:         move.l  d3,a2 */
    move.l d3,a2
/* QL:         move.w  d2,d3 */
    move.w d2,d3
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         asr.w   #4,d3           rhs rounded down to long words */
    asr.w #4,d3
/* QL:         move.w  d0,d4 */
    move.w d0,d4
/* QL:         lsr.w   #4,d4           x origin in longwords */
    lsr.w #4,d4
/* QL:         sub.w   d4,d3           length less one */
    sub.w d4,d3
/* QL:         move.w  d3,a5 */
    move.w d3,a5
/* QL:         add.w   a5,a5 */
    add.w a5,a5
/* QL:         add.w   a5,a5           set length less one longword in bytes */
    add.w a5,a5
/* QL:         lsl.w   #2,d4           x origin in bytes */
    lsl.w #2,d4
/* QL:         add.w   d4,a1           add to base */
    add.w d4,a1
/* QL:         add.l   a1,a2           and add base to offset of lower edge */
    add.l a1,a2
/* QL:         bsr.s   M182_mask            calc rhs M182_mask */
    bsr.s M182_mask
/* QL:         move.w  d0,d2           next will be lhs M182_mask */
    move.w d0,d2
/* QL:         neg.w   d5 */
    neg.w d5
/* QL:         move.w  d5,d0           keep a copy of negated linel for M182_scroll */
    move.w d5,d0
/* QL:         move.l  d4,d5           set rhs M182_mask */
    move.l d4,d5
/* QL:         not.l   d5              invert rhs M182_mask */
    not.l d5
/* QL:         bne.s   M182_mask            if not all outside, go set lhs */
    bne.s M182_mask
/* QL:         moveq   #-1,d5          make rhs all ones */
    moveq #(-1),d5
/* QL: M182_mask */
M182_mask:
/* QL:         moveq   #-1,d4          M182_fill M182_mask */
    moveq #(-1),d4
/* QL:         and.w   #15,d2          use least significant 4 bits of position */
    and.w #15,d2
/* QL:         lsr.w   d2,d4           shift to form M182_mask ffab */
    lsr.w d2,d4
/* QL:         move.w  d4,d2           save ab */
    move.w d4,d2
/* QL:         lsl.l   #8,d4           M182_mask -> fab0 */
    lsl.l #8,d4
/* QL:         move.w  d2,d4           -> faab */
    move.w d2,d4
/* QL:         lsl.l   #8,d4           -> aab0 */
    lsl.l #8,d4
/* QL:         move.b  d2,d4           -> aabb */
    move.b d2,d4
/* QL:         rts */
    rts 
/* QL: cs_over */
cs_over:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d0-d7/a0-a6,-(sp)
/* QL:         bsr.s   M182_set_colm        set M182_up colour masks and pointers */
    bsr.s M182_set_colm
/* QL:         lea     M182_over_op,a6      set M182_up over operation address */
    lea M182_over_op(pc),a6
/* QL:         tst.w   d3              longword count minus one */
    tst.w d3
/* QL:         bne.s   M182_area_c_1        more than one - OK */
    bne.s M182_area_c_1
/* QL:         and.l   d5,d4           just one - superimpose lhs and rhs masks */
    and.l d5,d4
/* QL:         bra.s   M182_area_c_1 */
    bra.s M182_area_c_1
/* QL: M182_set_cm_1 */
M182_set_cm_1:
/* QL:         bra.s   M182_set_colm */
    bra.s M182_set_colm
/* QL: cs_recol */
cs_recol:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d0-d7/a0-a6,-(sp)
/* QL:         move.l  a1,a4           save pointer to remap */
    move.l a1,a4
/* QL:         bsr.s   M182_set_addr        set scan pointers etc. */
    bsr.s M182_set_addr
/* QL:         add.w   d3,d3           remap operates on words */
    add.w d3,d3
/* QL:         addq.w  #1,d3 */
    addq.w #1,d3
/* QL:         btst    #3,M182_sv_mcsta(a6) check display mode */
    btst #3,M182_sv_mcsta(a6)
/* QL:         lea     M182_rmap4_op,a6     set 4 colour mode */
    lea M182_rmap4_op(pc),a6
/* QL:         beq.s   M182_area_c_1 */
    beq.s M182_area_c_1
/* QL:         lea     M182_rmap8_op,a6     set 8 colour mode */
    lea M182_rmap8_op(pc),a6
/* QL: M182_area_c_1 */
M182_area_c_1:
/* QL:         bra.s   M182_area_com */
    bra.s M182_area_com
/* QL: cs_scrol */
cs_scrol:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d0-d7/a0-a6,-(sp)
/* QL:         bsr.s   M182_set_cm_1        set M182_up colour masks and pointers */
    bsr.s M182_set_cm_1
/* QL:         move.w  M182_spd4+2(sp),d2   get displacement */
    move.w (M182_spd4+2)(sp),d2
/* QL:         muls    d0,d2           scale M182_up by negated line length */
    muls d0,d2
/* QL:         bgt.s   M182_up              M182_scroll pixels down? */
    bgt.s M182_up
/* QL:         exg     a2,a1           operate the other way */
    exg a1,a2
/* QL:         move.w  d0,a3           use negated line length */
    move.w d0,a3
/* QL:         add.l   a3,a1           adjust where we write */
    add.l a3,a1
/* QL:         add.l   a3,a2 */
    add.l a3,a2
/* QL:         btst    #0,M182_spd3+3(sp)   ensure that colour masks are M182_right way */
    btst #0,(M182_spd3+3)(sp)
/* QL:         bne.s   M182_set_dn          odd height is ok */
    bne.s M182_set_dn
/* QL:         exg     d6,d7 */
    exg d6,d7
/* QL: M182_set_dn */
M182_set_dn:
/* QL:         lea     0(a1,d2.l),a4   set source address */
    lea 0(a1,d2.l),a4
/* QL:         cmp.l   a4,a2 */
    cmp.l a4,a2
/* QL:         bra.s   M182_scroll */
    bra.s M182_scroll
/* QL: M182_up */
M182_up:
/* QL:         lea     0(a1,d2.l),a4   set source address */
    lea 0(a1,d2.l),a4
/* QL:         cmp.l   a2,a4 */
    cmp.l a2,a4
/* QL: M182_scroll */
M182_scroll:
/* QL:         bge.s   M182_fill            no area left */
    bge.s M182_fill
/* QL:         lea     M182_scrol_op,a6     set M182_scroll operation address */
    lea M182_scrol_op(pc),a6
/* QL:         sub.l   d2,a2           reduced area */
    sub.l d2,a2
/* QL:         bsr     M182_area_op */
    bsr M182_area_op
/* QL:         add.l   d2,a2           restore end address */
    add.l d2,a2
/* QL:         bra.s   M182_fill            and M182_fill rest of area */
    bra.s M182_fill
/* QL: cs_fill */
cs_fill:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d0-d7/a0-a6,-(sp)
/* QL:         bsr.s   M182_set_cm_1        set M182_up colour masks */
    bsr.s M182_set_cm_1
/* QL: M182_fill */
M182_fill:
/* QL:         lea     M182_fill_op,a6      set M182_up M182_fill operation address */
    lea M182_fill_op(pc),a6
/* QL:         bra.s   M182_area_com */
    bra.s M182_area_com
/* QL: cs_pan */
cs_pan:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d0-d7/a0-a6,-(sp)
/* QL:         bsr.s   M182_set_cm_1        set M182_up colour masks and pointers */
    bsr.s M182_set_cm_1
/* QL:         swap    d3              save width counter in msw */
    swap d3
/* QL:         move.w  #-16,d3         M182_mask for setting shift length */
    move.w #(-16),d3
/* QL:         move.w  #4,a0           pointers go M182_up, maybe */
    move.w #4,a0
/* QL:         move.w  M182_spd4+2(sp),d2   get displacement */
    move.w (M182_spd4+2)(sp),d2
/* QL:         bpl.s   M182_right */
    bpl.s M182_right
/* QL:         neg.w   d2 */
    neg.w d2
/* QL:         or.w    d2,d3           (-displacement) mod 16 - 16 */
    or.w d2,d3
/* QL:         neg.w   d3              16 - (-displacement) mod 16 */
    neg.w d3
/* QL:         swap    d3              shift to msw */
    swap d3
/* QL:         lsr.w   #4,d2           and horizontal offset in d2 */
    lsr.w #4,d2
/* QL:         cmp.w   d2,d3           is there anything left to pan? */
    cmp.w d2,d3
/* QL:         bcs.s   M182_fill            just clear it */
    bcs.s M182_fill
/* QL:         sub.w   d2,d3           else reduce length */
    sub.w d2,d3
/* QL: M182_pan_go */
M182_pan_go:
/* QL:         lsl.w   #2,d2           back to byte count */
    lsl.w #2,d2
/* QL:         lea     0(a1,d2.w),a4   set the source */
    lea 0(a1,d2.w),a4
/* QL:         addq.w  #1,d3           adjust long word count */
    addq.w #1,d3
/* QL:         lea     M182_pan_op,a6 */
    lea M182_pan_op(pc),a6
/* QL: M182_area_com */
M182_area_com:
/* QL:         bsr.s   M182_area_op */
    bsr.s M182_area_op
/* QL:         movem.l (sp)+,reg_list  restore all registers */
    movem.l (sp)+,d0-d7/a0-a6
/* QL: M182_area_rts */
M182_area_rts:
/* QL:         rts */
    rts 
/* QL: M182_right */
M182_right:
/* QL:         or.w    d2,d3           displacement mod 16 - 16 */
    or.w d2,d3
/* QL:         and.w   #$1f,d3         16 + displacement mod 16 */
    and.w #0x1f,d3
/* QL:         swap    d3              in msw of d3 */
    swap d3
/* QL:         lsr.w   #4,d2           find the long word shift */
    lsr.w #4,d2
/* QL:         cmp.w   d2,d3           anything left to pan? */
    cmp.w d2,d3
/* QL:         bcs.s   M182_fill            just clear it */
    bcs.s M182_fill
/* QL:         sub.w   d2,d3           else reduce the length */
    sub.w d2,d3
/* QL:         exg     a5,d0           negate the length */
    exg a5,d0
/* QL:         neg.l   d0 */
    neg.l d0
/* QL:         exg     d0,a5 */
    exg d0,a5
/* QL:         exg     d4,d5           swap the masks */
    exg d4,d5
/* QL:         subq.w  #8,a0           go backwards */
    subq.w #8,a0
/* QL:         sub.w   a5,a1           from other end */
    sub.w a5,a1
/* QL:         sub.w   a5,a2 */
    sub.w a5,a2
/* QL:         neg.w   d2              negate shift count */
    neg.w d2
/* QL:         bra.s   M182_pan_go */
    bra.s M182_pan_go
/* QL: * Now for the general area operation */
/* QL: M182_op_retrn */
M182_op_retrn:
/* QL:         subq.l  #4,a1           backspace to end of line */
    subq.l #4,a1
/* QL: M182_op_retx */
M182_op_retx:
/* QL:         move.l  (a1),d0         get the long word written */
    move.l (a1),d0
/* QL:         and.l   d5,d0           M182_mask it */
    and.l d5,d0
/* QL:         move.l  d5,d1           move M182_mask */
    move.l d5,d1
/* QL:         not.l   d1              negate */
    not.l d1
/* QL:         and.l   (sp)+,d1        M182_mask old contents */
    and.l (sp)+,d1
/* QL:         or.l    d1,d0           combine the bits */
    or.l d1,d0
/* QL:         move.l  d0,(a1)         and put edge back */
    move.l d0,(a1)
/* QL: * Now restore left hand edge (can save 6 bytes if following code is subroutine) */
/* QL:         sub.l   a5,a1           goto left hand edge */
    sub.l a5,a1
/* QL:         move.l  (a1),d0         get the long word written */
    move.l (a1),d0
/* QL:         and.l   d4,d0           M182_mask it */
    and.l d4,d0
/* QL:         move.l  d4,d1           get the M182_mask */
    move.l d4,d1
/* QL:         not.l   d1 */
    not.l d1
/* QL:         and.l   (sp)+,d1        negate M182_mask with old contents */
    and.l (sp)+,d1
/* QL:         or.l    d1,d0           combine the bits */
    or.l d1,d0
/* QL:         move.l  d0,(a1)         and put edge back */
    move.l d0,(a1)
/* QL:         add.l   a3,a1           move to next line */
    add.l a3,a1
/* QL: M182_area_op */
M182_area_op:
/* QL:         cmp.l   a2,a1           is it end? */
    cmp.l a2,a1
/* QL:         beq.s   M182_area_rts */
    beq.s M182_area_rts
/* QL:         move.w  d3,d0           set loop count */
    move.w d3,d0
/* QL:         bmi.s   M182_area_rts        oops */
    bmi.s M182_area_rts
/* QL:         exg     d6,d7           next line is next colour */
    exg d6,d7
/* QL:         move.l  (a1),-(sp)      save left hand edge */
    move.l (a1),-(sp)
/* QL:         move.l  0(a1,a5.w),-(sp) save M182_right hand edge */
    move.l 0(a1,a5.w),-(sp)
/* QL:         jmp     (a6)            do line operation */
    jmp (a6)
/* QL: M182_fill_op */
M182_fill_op:
/* QL:         move.l  d6,(a1)+        put in colour */
    move.l d6,(a1)+
/* QL:         dbra    d0,M182_fill_op      until end of op */
    dbra d0,M182_fill_op
/* QL:         bra.s   M182_op_retrn */
    bra.s M182_op_retrn
/* QL: * Over is treated specially to stop the cursor flickering so much the first and */
/* QL: * last dword are masked before xoring-in. */
/* QL: * This frig is not nearly so simple for the other operations! */
/* QL: M182_over_op */
M182_over_op:
/* QL:         move.l  d4,d1           do first dword always */
    move.l d4,d1
/* QL:         and.l   d6,d1           d1 has exor colour masked with start-window */
    and.l d6,d1
/* QL:         eor.l   d1,(a1)+ */
    eor.l d1,(a1)+
/* QL:         subq.w  #1,d0           if only one dword, that's it */
    subq.w #1,d0
/* QL:         bmi.s   M182_op_retrn */
    bmi.s M182_op_retrn
/* QL:         bra.s   M182_over_skip */
    bra.s M182_over_skip
/* QL: M182_over_loop */
M182_over_loop:
/* QL:         eor.l   d6,(a1)+        xor in dwords 2 to n-1 if required */
    eor.l d6,(a1)+
/* QL: M182_over_skip */
M182_over_skip:
/* QL:         dbra    d0,M182_over_loop */
    dbra d0,M182_over_loop
/* QL:         move.l  d5,d1           do last dword if required */
    move.l d5,d1
/* QL:         and.l   d6,d1           M182_mask in start/end M182_mask to colour change word */
    and.l d6,d1
/* QL:         eor.l   d1,(a1)+ */
    eor.l d1,(a1)+
/* QL:         bra.s   M182_op_retrn */
    bra.s M182_op_retrn
/* QL: M182_scrol_op */
M182_scrol_op:
/* QL:         lea     0(a1,d2.l),a4   set source address */
    lea 0(a1,d2.l),a4
/* QL:         addq.w  #1,d0           put it back to a simple count */
    addq.w #1,d0
/* QL:         moveq   #3,d1           speed M182_up by widening loop to 16 bytes at a go */
    moveq #3,d1
/* QL:         and.b   d0,d1           pick off two lsb's */
    and.b d0,d1
/* QL:         neg.w   d1              negate them */
    neg.w d1
/* QL:         add.w   d1,d1           and double for entry point to loop */
    add.w d1,d1
/* QL:         lsr.w   #2,d0           divide count by four */
    lsr.w #2,d0
/* QL:         jmp     M182_scrol_lp+8(pc,d1.w) enter loop at neat place */
.word 0x4efb
.word 4096|(((M182_scrol_lp+8)-.)&255)
/* QL: M182_scrol_lp */
M182_scrol_lp:
/* QL:         move.l  (a4)+,(a1)+     move long word */
    move.l (a4)+,(a1)+
/* QL:         move.l  (a4)+,(a1)+     move long word */
    move.l (a4)+,(a1)+
/* QL:         move.l  (a4)+,(a1)+     move long word */
    move.l (a4)+,(a1)+
/* QL:         move.l  (a4)+,(a1)+     move long word */
    move.l (a4)+,(a1)+
/* QL:         dbra    d0,M182_scrol_lp     until end of op */
    dbra d0,M182_scrol_lp
/* QL: M182_op_ret_1 */
M182_op_ret_1:
/* QL:         bra.s   M182_op_retrn */
    bra.s M182_op_retrn
/* QL: M182_rmap8_op */
M182_rmap8_op:
/* QL:         move.b  (a1),d6         fetch green and flash bits */
    move.b (a1),d6
/* QL:         move.b  1(a1),d7        red/blue byte */
    move.b 1(a1),d7
/* QL:         lsl.w   #8,d7           in bits 15..8 */
    lsl.w #8,d7
/* QL:         swap    d0              save loop count in top of d0 */
    swap d0
/* QL:         move.w  #4-1,d0         pixels per word */
    move.w #(4-1),d0
/* QL:         moveq   #7,d1           M182_mask for colour index */
    moveq #7,d1
/* QL: M182_pix8_lop */
M182_pix8_lop:
/* QL:         moveq   #0,d2           clear working register */
    moveq #0,d2
/* QL:         move.b  d6,d2           get green/flash */
    move.b d6,d2
/* QL:         roxr.b  #2,d2           green bit to extend */
    roxr.b #2,d2
/* QL:         move.w  d7,d2           red/blue to d2 bits 9,8 */
    move.w d7,d2
/* QL:         ror.w   #2,d2           bits 7,6 */
    ror.w #2,d2
/* QL:         roxl.b  #3,d2           grb to d2 bits 2,1,0 */
    roxl.b #3,d2
/* QL:         and.w   d1,d2           M182_mask to 0..7 */
    and.w d1,d2
/* QL:         move.b  0(a4,d2.w),d7   get new colour */
    move.b 0(a4,d2.w),d7
/* QL:         ror.w   #2,d7           shift round red/blue */
    ror.w #2,d7
/* QL:         ror.b   #1,d6           preserve flash bit */
    ror.b #1,d6
/* QL:         roxr.b  #1,d7           green bit into extend */
    roxr.b #1,d7
/* QL:         roxr.b  #1,d6           set new green */
    roxr.b #1,d6
/* QL:         dbra    d0,M182_pix8_lop     take next pixel */
    dbra d0,M182_pix8_lop
/* QL:         swap    d0              get back outer loop count to d0.w */
    swap d0
/* QL:         lsr.w   #8,d7           get green/red into correct word */
    lsr.w #8,d7
/* QL:         move.b  d6,(a1)+        put word back */
    move.b d6,(a1)+
/* QL:         move.b  d7,(a1)+ */
    move.b d7,(a1)+
/* QL:         dbra    d0,M182_rmap8_op     next word */
    dbra d0,M182_rmap8_op
/* QL:         bra.s   M182_op_ret_1 */
    bra.s M182_op_ret_1
/* QL: M182_rmap4_op */
M182_rmap4_op:
/* QL:         move.b  (a1),d6         fetch word */
    move.b (a1),d6
/* QL:         move.b  1(a1),d7 */
    move.b 1(a1),d7
/* QL:         moveq   #8-1,d1         pixels per word */
    moveq #(8-1),d1
/* QL: M182_pix4_lop */
M182_pix4_lop:
/* QL:         moveq   #0,d2           clear working register */
    moveq #0,d2
/* QL:         roxr.b  #1,d6           green bit */
    roxr.b #1,d6
/* QL:         addx.b  d2,d2           rotated into d2 */
    addx.b d2,d2
/* QL:         roxr.b  #1,d7 */
    roxr.b #1,d7
/* QL:         roxl.b  #2,d2           gr0 in bits 2,1,0 */
    roxl.b #2,d2
/* QL:         move.b  0(a4,d2.w),d2   get new colour */
    move.b 0(a4,d2.w),d2
/* QL:         add.b   d7,d7           shift d7 left again by one */
    add.b d7,d7
/* QL:         roxr.b  #2,d2           red */
    roxr.b #2,d2
/* QL:         roxr.b  #1,d7           into red */
    roxr.b #1,d7
/* QL:         add.b   d6,d6           shift d6 left again by one */
    add.b d6,d6
/* QL:         roxr.b  #1,d2           green */
    roxr.b #1,d2
/* QL:         roxr.b  #1,d6           into green */
    roxr.b #1,d6
/* QL:         dbra    d1,M182_pix4_lop     take next pixel */
    dbra d1,M182_pix4_lop
/* QL:         move.b  d6,(a1)+        put word back */
    move.b d6,(a1)+
/* QL:         move.b  d7,(a1)+ */
    move.b d7,(a1)+
/* QL:         dbra    d0,M182_rmap4_op     next word */
    dbra d0,M182_rmap4_op
/* QL:         bra.s   M182_op_ret_1 */
    bra.s M182_op_ret_1
/* QL: M182_pan_op */
M182_pan_op:
/* QL:         movem.l d6/a4-a5,-(sp)  save colour, source and width */
    movem.l d6/a4-a5,-(sp)
/* QL:         add.l   a1,a5           set pointer to rhs */
    add.l a1,a5
/* QL:         move.l  (a5),d2         overwrite rhs with background */
    move.l (a5),d2
/* QL:         and.l   d5,d2           M182_mask in */
    and.l d5,d2
/* QL:         move.l  d5,d1           this area */
    move.l d5,d1
/* QL:         not.l   d1 */
    not.l d1
/* QL:         and.l   d6,d1           M182_mask in colour outside */
    and.l d6,d1
/* QL:         or.l    d1,d2 */
    or.l d1,d2
/* QL:         move.l  d2,(a5) */
    move.l d2,(a5)
/* QL:         add.l   a0,a5           move a5 on to form end check */
    add.l a0,a5
/* QL:         swap    d3              get shift */
    swap d3
/* QL:         movep.w 0(a4),d1        get the first long word's worth */
    movep.w 0(a4),d1
/* QL:         movep.w 1(a4),d2 */
    movep.w 1(a4),d2
/* QL:         bra.s   M182_pan_elop */
    bra.s M182_pan_elop
/* QL: M182_pan_last */
M182_pan_last:
/* QL:         move.l  sp,a4           get last long word off stack */
    move.l sp,a4
/* QL: M182_pan_loop */
M182_pan_loop:
/* QL:         swap    d1              move existing contents of green */
    swap d1
/* QL:         swap    d2              and red/blue M182_up */
    swap d2
/* QL:         movep.w 0(a4),d1        fetch new long word */
    movep.w 0(a4),d1
/* QL:         movep.w 1(a4),d2 */
    movep.w 1(a4),d2
/* QL:         move.l  d1,d6           move green to a convenient register */
    move.l d1,d6
/* QL:         ror.l   d3,d6           rotate */
    ror.l d3,d6
/* QL:         movep.w d6,0(a1)        and save it */
    movep.w d6,0(a1)
/* QL:         move.l  d2,d6           now again for red/blue */
    move.l d2,d6
/* QL:         ror.l   d3,d6 */
    ror.l d3,d6
/* QL:         movep.w d6,1(a1) */
    movep.w d6,1(a1)
/* QL:         add.l   a0,a1           move destination on */
    add.l a0,a1
/* QL: M182_pan_elop */
M182_pan_elop:
/* QL:         add.l   a0,a4           move source on */
    add.l a0,a4
/* QL:         subq.w  #1,d0           decrement counter */
    subq.w #1,d0
/* QL:         bgt.s   M182_pan_loop */
    bgt.s M182_pan_loop
/* QL:         beq.s   M182_pan_last */
    beq.s M182_pan_last
/* QL:         movem.l (sp)+,d6/a4     restore colour and source pointer */
    movem.l (sp)+,d6/a4
/* QL:         swap    d3              restore loop count */
    swap d3
/* QL:         bra.s   M182_pan_efil */
    bra.s M182_pan_efil
/* QL: M182_pan_fill */
M182_pan_fill:
/* QL:         move.l  d6,(a1)         M182_fill with colour */
    move.l d6,(a1)
/* QL:         add.l   a0,a1 */
    add.l a0,a1
/* QL: M182_pan_efil */
M182_pan_efil:
/* QL:         cmp.l   a1,a5           end? */
    cmp.l a1,a5
/* QL:         bne.s   M182_pan_fill */
    bne.s M182_pan_fill
/* QL:         move.l  (sp)+,a5        restore width */
    move.l (sp)+,a5
/* QL:         add.l   a3,a4           move destination to next line */
    add.l a3,a4
/* QL:         sub.l   a0,a1           adjust running pointer */
    sub.l a0,a1
/* QL:         bra     M182_op_retx */
    bra M182_op_retx
/* QL:         end */
