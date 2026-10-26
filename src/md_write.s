/* ROM section md_write */
.balign 2,0
/* QL: * d0   s used by delay */
/* QL: * d1 c s counter of bytes to be read/written (call wblok only) */
/* QL: * d3   s checksum */
/* QL: * d4   s byte to be written */
/* QL: * d5   s inner loop counter */
/* QL: * d6   s bit number of control bit in cont register */
/* QL: * a0   s saved value of a1 */
/* QL: * a1 cr  buffer pointer */
/* QL: * a2   s pointer to transmit register */
/* QL: * a3 c   pointer to microdrive control register */
/* QL: * a4   s subroutine return address */
/* QL: M83_tdoff   equ     M83_pc_tdata-M83_pc_mctrl */
.equ M83_tdoff,(M83_pc_tdata-M83_pc_mctrl)
/* QL: md_write */
md_write:
/* QL:         move.b  #M83_pc.erase,(a3)  erase on */
    move.b #(M83_pc.erase&255),(a3)
/* QL:         delay   (3600-40)       wait */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL: wsubw maclab 313 to 27193 step 3 us */
/* QL:  move.w #([us]*15-46)/52,d0 eight byte fine sequence */
    move.w #((((3600-40)*15)-46)/52),d0
/* QL:  subq.w #1,d0 */
    subq.w #1,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         move.l  a1,a0           08  save buffer pointer */
    move.l a1,a0
/* QL:         lea     4(sp),a1        16  set pointer to header */
    lea 4(sp),a1
/* QL:         moveq   #2-1,d1         08  ... of two bytes */
    moveq #(2-1),d1
/* QL:         lea     M83_wr_rec(pc),a4   16  return to write record */
    lea M83_wr_rec(pc),a4
/* QL:         bra.s   M83_wr_init         18  ... when init and written header */
    bra.s M83_wr_init
/* QL: M83_wr_rec */
M83_wr_rec:
/* QL:         move.l  a0,a1           08  reset buffer pointer */
    move.l a0,a1
/* QL:         move.w  #$1ff,d1        16  ... record of 512 bytes */
    move.w #0x1ff,d1
/* QL:         moveq   #6-1,d5         08  preamble of 6+2 bytes */
    moveq #(6-1),d5
/* QL:         lea     M83_end_wr(pc),a4   16  return to M83_exit */
    lea M83_end_wr(pc),a4
/* QL:         bra.s   M83_wr_inpre        18  ... when record written */
    bra.s M83_wr_inpre
/* QL: M83_end_wr */
M83_end_wr:
/* QL:         moveq   #M83_pc.read,d4     write off / erase off */
    moveq #M83_pc.read,d4
/* QL: M83_exit */
M83_exit:
/* QL:         delay   120             wait for bytes to go away */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL: qdbra maclab 21 to 309 step 2 us */
/* QL:  moveq #([us]*15-50)/36,d0 six byte sequence */
    moveq #(((120*15)-50)/36),d0
/* QL:  dbra d0,* */
    dbra d0,.
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         move.b  d4,(a3)         turn off */
    move.b d4,(a3)
/* QL:         rts */
    rts 
/* QL: md_wblok */
md_wblok:
/* QL:         lea     M83_end_wb(pc),a4   16  return to M83_end_wb */
    lea M83_end_wb(pc),a4
/* QL:         bra.s   M83_wr_init         18  ... when we have initialised and written */
    bra.s M83_wr_init
/* QL: M83_end_wb */
M83_end_wb:
/* QL:         moveq   #M83_pc.erase,d4    write off / erase on */
    moveq #M83_pc.erase,d4
/* QL:         bra.s   M83_exit            after delay */
    bra.s M83_exit
/* QL: M83_wr_init */
M83_wr_init:
/* QL:         moveq   #M83_pc.write,d0    08  enable write */
    moveq #M83_pc.write,d0
/* QL:         move.b  d0,(a3)      12+08 */
    move.b d0,(a3)
/* QL:         move.b  d0,(a3)      12+08 */
    move.b d0,(a3)
/* QL:         moveq   #M83_pc..txfl,d6    08  buffer full bit in microdrive read register */
    moveq #M83_pc..txfl,d6
/* QL:         lea     M83_tdoff(a3),a2    16  pointer to transmit register */
    lea M83_tdoff(a3),a2
/* QL:         moveq   #9,d5           08  10 byte preamble */
    moveq #9,d5
/* QL: M83_wr_inpre */
M83_wr_inpre:
/* QL:         moveq   #0,d4           08  ... of zero */
    moveq #0,d4
/* QL: M83_wr_pream */
M83_wr_pream:
/* QL:         bsr.s   M83_wbyte       102+72  write preamble bytes in a loop */
    bsr.s M83_wbyte
/* QL:         subq.b  #1,d5           08 */
    subq.b #1,d5
/* QL:         bge.s   M83_wr_pream     12/18 */
    bge.s M83_wr_pream
/* QL:         moveq   #-1,d4          08  two bytes of ff */
    moveq #(-1),d4
/* QL:         bsr.s   M83_wbyte       102+72 */
    bsr.s M83_wbyte
/* QL:         bsr.s   M83_wbyte       102+72 */
    bsr.s M83_wbyte
/* QL:         move.w  #$0f0f,d3       16  initialise checksum */
    move.w #0x0f0f,d3
/* QL:         moveq   #0,d4           08  clear upper part of word */
    moveq #0,d4
/* QL: M83_wr_loop */
M83_wr_loop:
/* QL:         move.b  (a1)+,d4     12+08  fetch next byte */
    move.b (a1)+,d4
/* QL:         add.w   d4,d3           08  accumulate checksum */
    add.w d4,d3
/* QL:         bsr.s   M83_wbyte       102+72  146-226 cycles 19.5-30.1 us since preamble */
    bsr.s M83_wbyte
/* QL:         dbra    d1,M83_wr_loop   26/18  loop is 140-220 cycles 18.7-29.3 us */
    dbra d1,M83_wr_loop
/* QL:         move.w  d3,d4           08  write lsb first */
    move.w d3,d4
/* QL:         bsr.s   M83_wbyte       102+72  136-208 cycles 18.1-27.7us since last write */
    bsr.s M83_wbyte
/* QL:         lsr.w   #8,d4           26  now msb */
    lsr.w #8,d4
/* QL:         bsr.s   M83_wbyte       102+72 */
    bsr.s M83_wbyte
/* QL:         jmp     (a4)            16 */
    jmp (a4)
/* QL: * Write a byte */
/* QL: M83_wbyte */
M83_wbyte:
/* QL:         btst    d6,(a3)      12+08  is it ready for byte? */
    btst d6,(a3)
/* QL:         bne.s   M83_wbyte        12/18 */
    bne.s M83_wbyte
/* QL:         move.b  d4,(a2)      12(08) move byte to transmit register */
    move.b d4,(a2)
/* QL:         rts                  32+32 */
    rts 
/* QL: * Single byte write including bsr (34+32): 102-172 cycles 13.6-22.9 us */
/* QL: * Critical time is write checksum to first byte of record preamble */
/* QL: * In M83_wbyte     32+32 */
/* QL: *  jmp (a4)    16 */
/* QL: * In M83_wr_rec    66 */
/* QL: * In wr_rpet   42+32 */
/* QL: * In wbytes    36 */
/* QL: *     192+64=256 cycles 34.1 us */
/* QL:         vect4000 md_write */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ md$write,(md_write-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
