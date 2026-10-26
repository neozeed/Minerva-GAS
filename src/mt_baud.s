/* ROM section mt_baud */
.balign 2,0
/* QL: * d0 -  o- M33_err.bp if the baud rate is illegal, 0 if it's ok and has been set. */
/* QL: * d1 -i  - baud rate. one of 75/300/600/1200/2400/4800/9600/19200 or negative. */
/* QL: * An extended command for hermes allows the two ports to be individually set, */
/* QL: * and can prevent the simple calls from affecting the baud rates if they say */
/* QL: * not to. */
/* QL: * The format is to give d1.w with bits 15..7 all 1, bit 6 = 0/1 for ser1/ser2, */
/* QL: * Bit 5 zero and a value in bits 4..0 to be stored in the control byte. */
/* QL: * Bit 4 set means ordinary mt.baud calls will no longer affect this port. */
/* QL: * Bit 3 is reserved and should be zero. */
/* QL: * Bits 2..0 give the baud rate. */
/* QL: * Bit 1 of M33_sx_toe may be set to disallow the extended command. */
/* QL: * The existing control byte, with bit 7 set = bytes lost and bit 6 set = frame */
/* QL: * errors detected, is returned in d1.b. Bit 5 is undefined. Bits 4..0 are as */
/* QL: * above. This will also clear bits 7..5 of the control byte. */
/* QL: * The old code simply sets bits 2..0 of each byte of M33_sv_timov to the calculated */
/* QL: * 0..7 baud rate, provided they do not have their inhibit flag (bit 4) set. */
/* QL: reglist reg     d3/d6/a0-a2/a4 */
/* QL: mt_baud */
mt_baud:
/* QL:         movem.l reglist,-(sp) */
    movem.l d3/d6/a0-a2/a4,-(sp)
/* QL:         move    sr,d3           save current status register */
    move sr,d3
/* QL:         or.w    #$700,sr        disable interrupts */
    or.w #0x700,sr
/* QL:         clr.b   d0              actually going to keep ser mode */
    clr.b d0
/* QL:         jsr     ss_wser(pc)     make sure any current transmit is finished */
    jsr ss_wser(pc)
/* QL:         jsr     ss_rser(pc)     go back to ser1 */
    jsr ss_rser(pc)
/* QL:         moveq   #M33_err.bp,d0      if baud rate not in table */
    moveq #M33_err.bp,d0
/* QL:         move.l  M33_sv_chtop(a6),a4 */
    move.l M33_sv_chtop(a6),a4
/* QL:         assert  1,M33_err.bp&7 */
/* original assertion: 1,M33_err.bp&7 */
/* QL:         btst    d0,M33_sx_toe(a4) */
    btst d0,M33_sx_toe(a4)
/* QL:         lea     M33_sv_timov+2(a6),a4 */
    lea (M33_sv_timov+2)(a6),a4
/* QL:         bne.s   M33_std_baud */
    bne.s M33_std_baud
/* QL:         move.w  d1,d7 */
    move.w d1,d7
/* QL:         bpl.s   M33_std_baud */
    bpl.s M33_std_baud
/* QL:         ext.w   d7 */
    ext.w d7
/* QL:         cmp.w   d1,d7 */
    cmp.w d1,d7
/* QL:         bne.s   M33_std_baud */
    bne.s M33_std_baud
/* QL:         lsl.b   #2,d7 */
    lsl.b #2,d7
/* QL:         bmi.s   M33_std_baud */
    bmi.s M33_std_baud
/* QL:         bcs.s   M33_putser */
    bcs.s M33_putser
/* QL:         subq.l  #1,a4 */
    subq.l #1,a4
/* QL: M33_putser */
M33_putser:
/* QL:         move.b  -(a4),d1        pick up old setting */
    move.b -(a4),d1
/* QL:         lsr.b   #2,d7 */
    lsr.b #2,d7
/* QL:         move.b  d7,(a4)         replace current setting for ser control */
    move.b d7,(a4)
/* QL:         lea     M33_sv_timov(a6),a4 */
    lea M33_sv_timov(a6),a4
/* QL:         bra.s   M33_baud_ok */
    bra.s M33_baud_ok
/* QL: M33_std_baud */
M33_std_baud:
/* QL:         moveq   #7,d7 */
    moveq #7,d7
/* QL:         move.w  #300>>1,a0      most double up, 300, 600... 19200 baud */
    move.w #(300>>1),a0
/* QL:         cmp.w   #75,d1          but first is 75 baud */
    cmp.w #75,d1
/* QL:         bra.s   M33_chk_baud */
    bra.s M33_chk_baud
/* QL: M33_look_up */
M33_look_up:
/* QL:         add.w   a0,a0           double baud rate next */
    add.w a0,a0
/* QL:         cmp.w   a0,d1           is that it? */
    cmp.w a0,d1
/* QL: M33_chk_baud */
M33_chk_baud:
/* QL:         dbeq    d7,M33_look_up      no - keep trying... */
    dbeq d7,M33_look_up
/* QL:         bne.s   M33_baud_ex         the encoded baud rate is in d7 */
    bne.s M33_baud_ex
/* QL:         moveq   #M33_baud_cmd-32*2,d1 change baud rate command plus 1 nibble */
    moveq #(M33_baud_cmd-(32*2)),d1
/* QL:         lsl.w   #4,d1 */
    lsl.w #4,d1
/* QL:         or.b    d7,d1           slot in baud rate nibble */
    or.b d7,d1
/* QL:         ror.l   #4,d1 */
    ror.l #4,d1
/* QL:         jsr     ip_adcmd(pc)    give command and parameter to ipc */
    jsr ip_adcmd(pc)
/* QL:         bsr.s   M33_qorin           if allowed, put it into ser2 control */
    bsr.s M33_qorin
/* QL:         bsr.s   M33_qorin           if allowed, put it into ser1 control */
    bsr.s M33_qorin
/* QL: M33_baud_ok */
M33_baud_ok:
/* QL:         moveq   #7,d7 */
    moveq #7,d7
/* QL:         and.b   (a4),d7         pick up current ser1 baud */
    and.b (a4),d7
/* QL:         subq.l  #M33_sv_timov-M33_sv_tmode,a4 get address of the system variable */
.word 20876|((((M33_sv_timov-M33_sv_tmode))&7)<<9)
/* QL:         bsr.s   M33_orinbaud        always put it into sv */
    bsr.s M33_orinbaud
/* QL:         move.b  (a4),M33_pc_tctrl   write it to tx control reg */
    move.b (a4),M33_pc_tctrl
/* QL:         moveq   #0,d0           ok */
    moveq #0,d0
/* QL: M33_baud_ex */
M33_baud_ex:
/* QL:         move    d3,sr           reinstate interrupts */
    move d3,sr
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d3/d6/a0-a2/a4
/* QL:         jmp     ss_rte(pc)      come back from trap */
    jmp ss_rte(pc)
/* QL: M33_qorin */
M33_qorin:
/* QL:         btst    #4,-(a4) */
    btst #4,-(a4)
/* QL:         bne.s   M33_rts0            only if inhibit bit is clear */
    bne.s M33_rts0
/* QL: M33_orinbaud */
M33_orinbaud:
/* QL:         and.b   #$f8,(a4) */
    and.b #(0xf8&255),(a4)
/* QL:         or.b    d7,(a4)         change baud rate in this slot */
    or.b d7,(a4)
/* QL: M33_rts0 */
M33_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
