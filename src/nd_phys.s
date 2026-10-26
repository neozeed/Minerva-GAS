/* ROM section nd_phys */
.balign 2,0
/* QL: * d0 -  o- error code, and sr set */
/* QL: * a0 -ip - channel definition block */
/* QL: * a2 -  o- pointer transmit control register */
/* QL: * a3 -  o- pointer to microdrive/link register */
/* QL: * d1-d3/a1 destroyed */
/* QL: reglist reg     d5-d7 */
/* QL: * Calculate M84_checksum */
/* QL: M84_csumdata */
M84_csumdata:
/* QL:         move.b  M84_net_nbyt(a0),d1 get byte count */
    move.b M84_net_nbyt(a0),d1
/* QL:         lea     M84_net_data(a0),a1 address of data */
    lea M84_net_data(a0),a1
/* QL: M84_checksum */
M84_checksum:
/* QL:         moveq   #0,d7           initialise M84_checksum */
    moveq #0,d7
/* QL: M84_chks_byt */
M84_chks_byt:
/* QL:         add.b   (a1)+,d7        add byte to M84_checksum */
    add.b (a1)+,d7
/* QL:         subq.b  #1,d1 */
    subq.b #1,d1
/* QL:         bne.s   M84_chks_byt        next byte */
    bne.s M84_chks_byt
/* QL:         rts */
    rts 
/* QL: * Set up on M84_entry */
/* QL: M84_entry */
M84_entry:
/* QL:         move.l  (sp)+,a1        get return address off stack */
    move.l (sp)+,a1
/* QL:         lea     M84_pc_mctrl,a3     set up pc register addresses */
    lea M84_pc_mctrl,a3
/* QL:         lea     M84_pc_tctrl-M84_pc_mctrl(a3),a2 */
    lea (M84_pc_tctrl-M84_pc_mctrl)(a3),a2
/* QL:         moveq   #M84_pc.netmd,d0    set up in network mode */
    moveq #M84_pc.netmd,d0
/* QL:         moveq   #1<<M84_pc..serb,d3 internally, we want d3 permanently zero */
    moveq #(1<<M84_pc..serb),d3
/* QL:         and.b   M84_sv_tmode(a6),d3 is it in actually in rs232 mode */
    and.b M84_sv_tmode(a6),d3
/* QL:         bne.s   M84_err_ne3         yes - leave this until serial o/p has cleared */
    bne.s M84_err_ne3
/* QL:         jsr     ss_wser(pc)     wait for serial to complete */
    jsr ss_wser(pc)
/* QL:         move    sr,-(sp)        save interrupt status */
    move sr,-(sp)
/* QL:         or.w    #$0700,sr       disable interrupts */
    or.w #0x0700,sr
/* QL:         movem.l reglist,-(sp)   save registers */
    movem.l d5-d7,-(sp)
/* QL:         jsr     (a1)            call the return address */
    jsr (a1)
/* QL:         movem.l (sp)+,reglist   reload registers */
    movem.l (sp)+,d5-d7
/* QL:         jsr     ss_rser(pc)     return to serial mode */
    jsr ss_rser(pc)
/* QL:         move.w  (sp)+,sr        restore interrupt state */
    move.w (sp)+,sr
/* QL:         tst.l   d0              set condition codes */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: * Send packet */
/* QL: nd_spac */
nd_spac:
/* QL:         bsr.s   M84_entry           set up */
    bsr.s M84_entry
/* QL:         bsr.s   M84_csumdata        calculate data M84_checksum */
    bsr.s M84_csumdata
/* QL:         move.b  d7,M84_net_dchk(a0) save it */
    move.b d7,M84_net_dchk(a0)
/* QL:         moveq   #M84_net_hchk-M84_net_hedr,d1 sum bytes of header for M84_checksum */
    moveq #(M84_net_hchk-M84_net_hedr),d1
/* QL:         lea     M84_net_hedr(a0),a1 */
    lea M84_net_hedr(a0),a1
/* QL:         bsr.s   M84_checksum        calculate header M84_checksum */
    bsr.s M84_checksum
/* QL:         move.b  d7,(a1)         and save it in the next location */
    move.b d7,(a1)
/* QL:         subq.l  #M84_net_hchk-M84_net_hedr,a1 restore a1 to point to header */
.word 20873|((((M84_net_hchk-M84_net_hedr))&7)<<9)
/* QL: * Send a scout */
/* QL:         assert  M84_net_hedr,M84_net_self-1 */
/* original assertion: M84_net_hedr,M84_net_self-1 */
/* QL:         move.w  (a1),d6         get station number in lsb */
    move.w (a1),d6
/* QL:         not.b   d6              inverted */
    not.b d6
/* QL:         move.b  M84_sv_tmode(a6),d2 get basic byte to send to xmit reg */
    move.b M84_sv_tmode(a6),d2
/* QL:         moveq   #10-1,d1        send station number, 2*inactive: 10 bit */
    moveq #(10-1),d1
/* QL:         moveq   #115,d0 */
    moveq #115,d0
/* QL:         mulu    M84_sv_rand(a6),d0 */
    mulu M84_sv_rand(a6),d0
/* QL:         move.w  d0,M84_sv_rand(a6)  set up random wait >3ms=536 loops */
    move.w d0,M84_sv_rand(a6)
/* QL:         ext.w   d0              ... d0 becomes -128 to 127 */
    ext.w d0
/* QL:         add.w   #536+128-1,d0   ... now 536-1 to 891-1, 3 to 5.7 ms */
    add.w #((536+128)-1),d0
/* QL: M84_ss_wait */
M84_ss_wait:
/* QL:         btst    d3,(a3)         12 check if net is idle */
    btst d3,(a3)
/* QL:         bne.s   M84_err_ne3         12 ... no it's not */
    bne.s M84_err_ne3
/* QL:         dbra    d0,M84_ss_wait   18/26 loop is 42-48 cycles 5.6 us min */
    dbra d0,M84_ss_wait
/* QL: M84_ss_bit */
M84_ss_bit:
/* QL:         lsl.b   #1,d6           12 get next bit out of station number */
    lsl.b #1,d6
/* QL:         rol.b   #1,d2           12 */
    rol.b #1,d2
/* QL:         roxr.b  #1,d2           12 and put it in basic byte */
    roxr.b #1,d2
/* QL:         move.b  d2,(a2)         12 send next bit */
    move.b d2,(a2)
/* QL:         bmi.s   M84_ss_activ     18/12 if M84_output is active - cannot test */
    bmi.s M84_ss_activ
/* QL:         moveq   #6-1,d0         08 test M84_output 6 times */
    moveq #(6-1),d0
/* QL: M84_ss_test */
M84_ss_test:
/* QL:         btst    d3,(a3)         12 check if network is active */
    btst d3,(a3)
/* QL:         beq.s   M84_ss_tdbra        18 funny test to make loop n*12 */
    beq.s M84_ss_tdbra
/* QL: M84_err_ne3 */
M84_err_ne3:
/* QL:         bra.s   M84_err_ne2         ... oops */
    bra.s M84_err_ne2
/* QL: M84_ss_tdbra */
M84_ss_tdbra:
/* QL:         dbra    d0,M84_ss_test   18/26 loop is 48 cycles long */
    dbra d0,M84_ss_test
/* QL:         bra.s   M84_ss_next         18 */
    bra.s M84_ss_next
/* QL: M84_ss_activ */
M84_ss_activ:
/* QL:         moveq   #17-1,d0        08 wait a bit */
    moveq #(17-1),d0
/* QL:         dbra    d0,*           314 */
    dbra d0,.
/* QL: M84_ss_next */
M84_ss_next:
/* QL:         dbra    d1,M84_ss_bit    18/26 bit loop is 402 cycles (active) 412 (test) */
    dbra d1,M84_ss_bit
/* QL: * Scout sent ok */
/* QL:         moveq   #M84_net_data-M84_net_hedr,d1 send header first, bit 15 = header/data */
    moveq #(M84_net_data-M84_net_hedr),d1
/* QL:         bsr.s   M84_output          send header */
    bsr.s M84_output
/* QL:         tst.b   M84_net_dest(a0)    are we doing a broadcast? */
    tst.b M84_net_dest(a0)
/* QL:         beq.s   M84_sp_bcst         yes - we don't want an ack */
    beq.s M84_sp_bcst
/* QL: M84_sp_block */
M84_sp_block:
/* QL:         addq.b  #1,d1           read one byte response */
    addq.b #1,d1
/* QL:         lea     M84_net_data-1(a0),a1 stuff it in end of header block */
    lea (M84_net_data-1)(a0),a1
/* QL:         bsr.l   M84_inpbyte         fetch byte (in both d2 and d7) */
    bsr.w M84_inpbyte
/* QL: M84_err_ne2 */
M84_err_ne2:
/* QL:         bne.s   M84_err_ne1 */
    bne.s M84_err_ne1
/* QL:         subq.b  #1,d7           check if response was acknowledge */
    subq.b #1,d7
/* QL:         bne.s   M84_err_ne1 */
    bne.s M84_err_ne1
/* QL:         not.w   d1              was that the data? */
    not.w d1
/* QL:         bpl.s   M84_inc_blk         yes - go update block count */
    bpl.s M84_inc_blk
/* QL:         bsr.s   M84_outpdata        send data */
    bsr.s M84_outpdata
/* QL:         bra.s   M84_sp_block        go back to get acknowledge */
    bra.s M84_sp_block
/* QL: * Send header/data/acknowledge */
/* QL: * d1 -i o- lsb only: byte count / 0 */
/* QL: * d7 -  o- 0 */
/* QL: * d6 -i o- byte to be sent, bits 15..14 one / $(ffff)ff00 */
/* QL: * a1 -i o- data pointer / updated */
/* QL: * d3/a0/a2/a6 standard */
/* QL: M84_outpdata */
M84_outpdata:
/* QL:         move.b  M84_net_nbyt(a0),d1 send all bytes of data block */
    move.b M84_net_nbyt(a0),d1
/* QL: M84_output */
M84_output:
/* QL:         moveq   #-1,d6          08 preset top byte of word to ones */
    moveq #(-1),d6
/* QL: M84_outb_byt */
M84_outb_byt:
/* QL:         move.b  (a1)+,d6        12+ get next byte */
    move.b (a1)+,d6
/* QL: M84_outpack */
M84_outpack:
/* QL:         lsl.w   #1,d6           12 clear lsb for start flag */
    lsl.w #1,d6
/* QL:         rol.w   #2,d6           14 set two lsbs for leader/stop */
    rol.w #2,d6
/* QL:         moveq   #13,d7          08 13 bits - 2 leader, start, 8 data, 2 stop */
    moveq #13,d7
/* QL:         move.b  M84_sv_tmode(a6),d0 20 set up basic byte to write to xmit reg */
    move.b M84_sv_tmode(a6),d0
/* QL: M84_outb_bit */
M84_outb_bit:
/* QL:         asr.w   #1,d6           12 shift next bit out and bring a one in */
    asr.w #1,d6
/* QL:         addx.b  d0,d0           08 roll it into basic byte lsb */
    addx.b d0,d0
/* QL:         rol.b   #7,d0           24 roll back to bit 7 */
    rol.b #7,d0
/* QL:         move.b  d0,(a2)       12+1 send bit */
    move.b d0,(a2)
/* QL:         subq.w  #1,d7           08 decrement counter */
    subq.w #1,d7
/* QL:         bne.s   M84_outb_bit     18/12 loop is 83 cycles long */
    bne.s M84_outb_bit
/* QL:         subq.b  #1,d1           08 */
    subq.b #1,d1
/* QL:         bne.s   M84_outb_byt     18/12 stop is 4 bits+ a bit */
    bne.s M84_outb_byt
/* QL:         move.b  M84_sv_tmode(a6),(a2) 16 deactivate net */
    move.b M84_sv_tmode(a6),(a2)
/* QL:         rts */
    rts 
/* QL: * Final bits */
/* QL: M84_sp_bcst */
M84_sp_bcst:
/* QL:         delay   500             ; give receiver time to get to reading data */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL: wsubw maclab 313 to 27193 step 3 us */
/* QL:  move.w #([us]*15-46)/52,d0 eight byte fine sequence */
    move.w #(((500*15)-46)/52),d0
/* QL:  subq.w #1,d0 */
    subq.w #1,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         bsr.s   M84_outpdata */
    bsr.s M84_outpdata
/* QL:         delay   2000            ; give other end a chance to use the data */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL: wsubw maclab 313 to 27193 step 3 us */
/* QL:  move.w #([us]*15-46)/52,d0 eight byte fine sequence */
    move.w #(((2000*15)-46)/52),d0
/* QL:  subq.w #1,d0 */
    subq.w #1,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL: M84_inc_blk */
M84_inc_blk:
/* QL:         addq.b  #1,M84_net_blkl(a0) increment block count */
    addq.b #1,M84_net_blkl(a0)
/* QL:         bcc.s   M84_okrts1 */
    bcc.s M84_okrts1
/* QL:         addq.b  #1,M84_net_blkh(a0) and upper byte */
    addq.b #1,M84_net_blkh(a0)
/* QL: M84_okrts1 */
M84_okrts1:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Receive a packet from the net */
/* QL: nd_rpac */
nd_rpac:
/* QL:         bsr.s   M84_rpac_nc         initially sets nothing read / not end of file */
    bsr.s M84_rpac_nc
/* QL:         bsr.l   M84_entry */
    bsr.w M84_entry
/* QL: * Wait for a gap in transmission */
/* QL: M84_rwait_gp */
M84_rwait_gp:
/* QL:         move.w  #5859-1,d6      give up waiting after 5859*8.5=50ms of active! */
    move.w #(5859-1),d6
/* QL: M84_rwait_2m */
M84_rwait_2m:
/* QL:         move.w  #438-1,d0       16 wait for 438*6.4=2.8ms of solid no activity */
    move.w #(438-1),d0
/* QL: M84_rwait_lp */
M84_rwait_lp:
/* QL:         btst    d3,(a3)         12 is net active */
    btst d3,(a3)
/* QL:         beq.s   M84_rwait_nx        18 no ... decrement gap time counter */
    beq.s M84_rwait_nx
/* QL:         dbra    d6,M84_rwait_2m  18/26 start waiting again, or timeout */
    dbra d6,M84_rwait_2m
/* QL: M84_err_ne1 */
M84_err_ne1:
/* QL:         bra.s   M84_err_nc0         exit if no suitable gap in transmission */
    bra.s M84_err_nc0
/* QL: M84_rwait_nx */
M84_rwait_nx:
/* QL:         dbra    d0,M84_rwait_lp  18/26 48 cycles / 6.4 us loop */
    dbra d0,M84_rwait_lp
/* QL: * Wait for a scout */
/* QL:         move.w  #3125-1,d0      timeout = 3125*6.4=20ms */
    move.w #(3125-1),d0
/* QL: M84_rwait_sc */
M84_rwait_sc:
/* QL:         btst    d3,(a3)         12 wait for beginning of scout */
    btst d3,(a3)
/* QL:         bne.s   M84_got_sc          18 drop out if beginning of scout */
    bne.s M84_got_sc
/* QL:         dbra    d0,M84_rwait_sc  18/26 */
    dbra d0,M84_rwait_sc
/* QL:         bra.s   M84_err_nc0         no scout in 20ms, so return nc */
    bra.s M84_err_nc0
/* QL: * Got the scout - so wait until it has gone away */
/* QL: M84_got_sc */
M84_got_sc:
/* QL:         delay   530             ; wait for end of scout */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL: wsubw maclab 313 to 27193 step 3 us */
/* QL:  move.w #([us]*15-46)/52,d0 eight byte fine sequence */
    move.w #(((530*15)-46)/52),d0
/* QL:  subq.w #1,d0 */
    subq.w #1,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         moveq   #M84_net_data-M84_net_hedr,d1 read 8 bytes */
    moveq #(M84_net_data-M84_net_hedr),d1
/* QL:         bsr.s   M84_inpdata         header to data, last byte (hchk) left in d2 */
    bsr.s M84_inpdata
/* QL:         subq.l  #M84_net_data-M84_net_hedr,a1 backspace buffer pointer */
.word 20873|((((M84_net_data-M84_net_hedr))&7)<<9)
/* QL:         bne.s   M84_rwait_gp        skip if it timed out */
    bne.s M84_rwait_gp
/* QL:         assert  M84_net_hchk,M84_net_data-1 */
/* original assertion: M84_net_hchk,M84_net_data-1 */
/* QL:         sub.b   d2,d7           check M84_checksum (M84_checksum has been summed) */
    sub.b d2,d7
/* QL:         cmp.b   d2,d7 */
    cmp.b d2,d7
/* QL:         bne.s   M84_rwait_gp */
    bne.s M84_rwait_gp
/* QL: * We have seen a valid header, so we don't go back looking for a scout anymore */
/* QL: * since, if the packet isn't for us, we don't want to waste time here with the */
/* QL: * following data block. */
/* QL: * Now check if this packet is for me */
/* QL:         assert  M84_net_hedr,M84_net_dest,M84_net_self-1 */
/* original assertion: M84_net_hedr,M84_net_dest,M84_net_self-1 */
/* QL:         move.w  M84_net_dest(a0),d7 fetch my own station numbers */
    move.w M84_net_dest(a0),d7
/* QL:         ror.w   #8,d7           swap them over */
    ror.w #8,d7
/* QL:         cmp.w   (a1),d7         do source and dest cross match? */
    cmp.w (a1),d7
/* QL:         beq.s   M84_chk_blk         yes - that's great */
    beq.s M84_chk_blk
/* QL:         tst.b   d7              if destination (self) is zero - broadcast */
    tst.b d7
/* QL:         beq.s   M84_chk_dest        yes - check if just destinations match */
    beq.s M84_chk_dest
/* QL:         cmp.b   M84_net_self(a0),d7 is it the 'receive from any' code? */
    cmp.b M84_net_self(a0),d7
/* QL:         bne.s   M84_err_nc0         no - return nc and ioss will try again later */
    bne.s M84_err_nc0
/* QL: M84_chk_dest */
M84_chk_dest:
/* QL:         cmp.b   (a1),d7         do destinations match? */
    cmp.b (a1),d7
/* QL:         bne.s   M84_err_nc0         no - return nc and ioss will try again later */
    bne.s M84_err_nc0
/* QL: * Properly addressed to us, so check if this data block is the one required */
/* QL: M84_chk_blk */
M84_chk_blk:
/* QL:         bsr.s   M84_goodhdr         go sort out valid header */
    bsr.s M84_goodhdr
/* QL:         bne.s   M84_rpac_nc */
    bne.s M84_rpac_nc
/* QL:         cmp.b   M84_net_dchk(a0),d7 check M84_checksum */
    cmp.b M84_net_dchk(a0),d7
/* QL:         bne.s   M84_rpac_nc */
    bne.s M84_rpac_nc
/* QL:         bsr.s   M84_acknwldg        all ok - acknowledge */
    bsr.s M84_acknwldg
/* QL:         tst.w   d5              check this was the right block */
    tst.w d5
/* QL:         beq.s   M84_inc_blk */
    beq.s M84_inc_blk
/* QL: M84_rpac_nc */
M84_rpac_nc:
/* QL:         assert  M84_net_type,M84_net_nbyt-1 */
/* original assertion: M84_net_type,M84_net_nbyt-1 */
/* QL:         clr.w   M84_net_type(a0)    nothing read / not end of file */
    clr.w M84_net_type(a0)
/* QL: M84_err_nc0 */
M84_err_nc0:
/* QL:         moveq   #M84_err.nc,d0      not complete */
    moveq #M84_err.nc,d0
/* QL:         rts */
    rts 
/* QL: * Send acknowledgement */
/* QL: M84_acknwldg */
M84_acknwldg:
/* QL:         moveq   #1,d1           write one byte */
    moveq #1,d1
/* QL:         move.w  #$ff01,d6       the acknowledge byte is a one */
    move.w #0xff01,d6
/* QL:         tst.b   M84_net_dest(a0)    are we receiving a broadcast? */
    tst.b M84_net_dest(a0)
/* QL:         bne.l   M84_outpack         no - go do it */
    bne.w M84_outpack
/* QL: M84_rts9 */
M84_rts9:
/* QL:         rts                     yes - don't bother acknowledging */
    rts 
/* QL: M84_goodhdr */
M84_goodhdr:
/* QL:         assert  M84_net_hedr,M84_net_blkl-2,M84_net_blkh-3 */
/* original assertion: M84_net_hedr,M84_net_blkl-2,M84_net_blkh-3 */
/* QL:         move.l  (a1),d5         fetch incoming block number to lsw */
    move.l (a1),d5
/* QL:         sub.w   M84_net_blkl(a0),d5 and compare against required */
    sub.w M84_net_blkl(a0),d5
/* QL:         bne.s   M84_rblock          if not correct skip it (other missed ack) */
    bne.s M84_rblock
/* QL:         assert  M84_net_type,M84_net_nbyt-1,M84_net_dchk-2,M84_net_hchk-3,M84_net_data-4 */
/* original assertion: M84_net_type,M84_net_nbyt-1,M84_net_dchk-2,M84_net_hchk-3,M84_net_data-4 */
/* QL:         move.l  M84_net_type-M84_net_hedr(a1),-(a1) copy flag, nbytes etc */
    move.l (M84_net_type-M84_net_hedr)(a1),-(a1)
/* QL: * If the acknowledges fail, or the data's bad, we'll have to clear this again */
/* QL: M84_rblock */
M84_rblock:
/* QL:         bsr.s   M84_acknwldg        acknowledge header */
    bsr.s M84_acknwldg
/* QL:         move.b  M84_net_nbyt(a0),d1 set up number of bytes to read */
    move.b M84_net_nbyt(a0),d1
/* QL: * Drop through to read the data bytes */
/* QL: * Read a block from the net and accumulate M84_checksum */
/* QL: M84_inpdata */
M84_inpdata:
/* QL:         lea     M84_net_data(a0),a1 put it in data block */
    lea M84_net_data(a0),a1
/* QL: M84_inpbyte */
M84_inpbyte:
/* QL:         moveq   #0,d7           clear M84_checksum */
    moveq #0,d7
/* QL:         move.w  #400,d0         wait for active up to 400*48 cycles 2.56 ms */
    move.w #400,d0
/* QL: M84_i_wnext */
M84_i_wnext:
/* QL:         dbra    d0,M84_i_wait    18/26 loop 48 cycles */
    dbra d0,M84_i_wait
/* QL:         bra.s   M84_err_nc0            exit if timed out */
    bra.s M84_err_nc0
/* QL: M84_i_bytwt */
M84_i_bytwt:
/* QL:         btst    d3,(a3)         12 wait for start bit */
    btst d3,(a3)
/* QL:         dbeq    d6,M84_i_bytwt   18/26/20 loop is 30 cycles */
    dbeq d6,M84_i_bytwt
/* QL:         bne.s   M84_err_nc0         12 not complete if no start bit found */
    bne.s M84_err_nc0
/* QL:         moveq   #8-1,d6         08 read 8 bits */
    moveq #(8-1),d6
/* QL:         moveq   #0,d0           08 one shot at validating stop bit / ok exit */
    moveq #0,d0
/* QL:         ror.b   #4,d3           18 delay */
    ror.b #4,d3
/* QL: M84_i_bit */
M84_i_bit:
/* QL:         ror.l   #8,d2           28 save bits so far at msb, and delay */
    ror.l #8,d2
/* QL:         move.b  (a3),d2         12 read bit (106..117 cycles since start bit) */
    move.b (a3),d2
/* QL:         rol.l   #7,d2           26 construct byte */
    rol.l #7,d2
/* QL:         dbra    d6,M84_i_bit     18/26 loop is 84 cycles */
    dbra d6,M84_i_bit
/* QL:         move.b  d2,(a1)+        12+ store byte */
    move.b d2,(a1)+
/* QL:         add.b   d2,d7           08 accumulate M84_checksum */
    add.b d2,d7
/* QL:         subq.b  #1,d1           08 */
    subq.b #1,d1
/* QL:         beq.s   M84_rts9            12 exit ok, all done */
    beq.s M84_rts9
/* QL: * Now validate 1st (or 2nd) stop bit, 104 cycles after last test */
/* QL: M84_i_wait */
M84_i_wait:
/* QL:         btst    d3,(a3)         12 is net active yet */
    btst d3,(a3)
/* QL:         beq.s   M84_i_wnext      18/12 funny test to make wait loop n*48 */
    beq.s M84_i_wnext
/* QL:         moveq   #71-1,d6        08 give up after about 30*71 cycles (2 bytes) */
    moveq #(71-1),d6
/* QL:         bra.s   M84_i_bytwt         18 */
    bra.s M84_i_bytwt
/* QL:         end */
