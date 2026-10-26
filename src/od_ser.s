/* ROM section od_ser */
.balign 2,0
/* QL: * The rules for the user routines  */
/* QL: od_ser */
od_ser:
/* QL:         dc.w    M106_io-* */
.balign 2,0
M106_dc_anchor_495:
.word ((M106_io-M106_dc_anchor_495))&65535
/* QL:         dc.w    M106_open-* */
.balign 2,0
M106_dc_anchor_499:
.word ((M106_open-M106_dc_anchor_499))&65535
/* QL:         dc.w    M106_close-* */
.balign 2,0
M106_dc_anchor_503:
.word ((M106_close-M106_dc_anchor_503))&65535
/* QL: M106_io */
M106_io:
/* QL:         jsr     io_relio(pc)    use standard relative serial i/o */
    jsr io_relio(pc)
/* QL:         dc.w    M106_pend-* */
.balign 2,0
M106_dc_anchor_511:
.word ((M106_pend-M106_dc_anchor_511))&65535
/* QL:         dc.w    M106_fbyte-* */
.balign 2,0
M106_dc_anchor_515:
.word ((M106_fbyte-M106_dc_anchor_515))&65535
/* QL:         dc.w    M106_sbyte-* */
.balign 2,0
M106_dc_anchor_519:
.word ((M106_sbyte-M106_dc_anchor_519))&65535
/* QL: * Open a serial i/o channel. */
/* QL: * The name is structured as "ser{1|2}{o|e|m|s}{i|h}{r|z|c} */
/* QL: *       port number (1 or 2, default 1) */
/* QL: *       parity (0=8 bit, 1=odd, 2=even, 3=mark, 4=space) */
/* QL: *       use/ignore transmit handshake signals (0=ignore, other(default)=use) */
/* QL: *       protocol >0 <cr/lf>, 0=ctrlz, <0=raw (default raw) */
/* QL: M106_open */
M106_open:
/* QL:         subq.l  #2*4,sp         make room for parameters */
    subq.l #(2*4),sp
/* QL:         move.l  sp,a3           point a3 to them */
    move.l sp,a3
/* QL:         jsr     io_name(pc)     decode the name */
    jsr io_name(pc)
/* QL:         bra.s   M106_opn_pop         not ser */
    bra.s M106_opn_pop
/* QL:         bra.s   M106_opn_pop         bad parameter */
    bra.s M106_opn_pop
/* QL:         bra.s   M106_opn_ser         ok */
    bra.s M106_opn_ser
/* QL:         dc.w    3,'SER',4,-1,1,4,'OEMS',2,'IH',3,'RZC' */
.balign 2,0
M106_dc_anchor_543:
.word 3
.byte 83,69,82
.balign 2,0
.word 4
.word ((-1))&65535
.word 1
.word 4
.byte 79,69,77,83
.balign 2,0
.word 2
.byte 73,72
.balign 2,0
.word 3
.byte 82,90,67
.balign 2,0
/* QL: M106_opn_pop */
M106_opn_pop:
/* QL:         addq.l  #2*4,sp         discard parameter area */
    addq.l #(2*4),sp
/* QL: M106_rts0 */
M106_rts0:
/* QL:         rts */
    rts 
/* QL: M106_opn_ser */
M106_opn_ser:
/* QL:         movem.w (sp)+,d4-d7     get parameters */
    movem.w (sp)+,d4-d7
/* QL:         subq.w  #1,d6           adjust handshake */
    subq.w #1,d6
/* QL:         subq.w  #2,d7           adjust protocol */
    subq.w #2,d7
/* QL:         moveq   #M106_err.nf,d0 */
    moveq #M106_err.nf,d0
/* QL:         move.w  d4,d1 */
    move.w d4,d1
/* QL:         lea     M106_sv_ser1c(a6),a5 set address of ser1 queue pointer */
    lea M106_sv_ser1c(a6),a5
/* QL:         subq.w  #1,d1 */
    subq.w #1,d1
/* QL:         beq.s   M106_chk_inus */
    beq.s M106_chk_inus
/* QL:         addq.l  #M106_sv_ser2c-M106_sv_ser1c,a5 change to ser2 queue pointer */
.word 20621|((((M106_sv_ser2c-M106_sv_ser1c))&7)<<9)
/* QL:         subq.w  #1,d1 */
    subq.w #1,d1
/* QL:         bne.s   M106_rts0            only support ser1 or ser2 */
    bne.s M106_rts0
/* QL: M106_chk_inus */
M106_chk_inus:
/* QL:         move    sr,-(sp)        save interrupt status */
    move sr,-(sp)
/* QL:         or.w    #$700,sr        disable interrupts to enable reopen */
    or.w #0x700,sr
/* QL:         move.l  (a5),d0         is a serial channel already allocated */
    move.l (a5),d0
/* QL:         beq.s   M106_alloc           no - go allocate it */
    beq.s M106_alloc
/* QL:         move.l  d0,a2           start of receive queue */
    move.l d0,a2
/* QL:         lea     -M106_ser_rxq(a2),a0 start of definition */
    lea (-M106_ser_rxq)(a2),a0
/* QL:         moveq   #M106_err.iu,d0 */
    moveq #M106_err.iu,d0
/* QL:         assert  0,M106_q_eoff,M106_q_nextq */
/* original assertion: 0,M106_q_eoff,M106_q_nextq */
/* QL:         bclr    #7,M106_ser_txq(a0)  was transmit eofed? (but it isn't now) */
    bclr #7,M106_ser_txq(a0)
/* QL:         beq.s   M106_popsr           no - that's no good, someone's got it M106_open! */
    beq.s M106_popsr
/* QL: *        clr.l   (a2)            clear M106_q_eoff (and M106_q_nextq?) for receive queue */
/* QL: * N.B. We'll leave the receive queue pointers alone, as there may well be */
/* QL: * input buffered up there waiting for us. (lwr) */
/* QL:         bra.s   M106_set_parms */
    bra.s M106_set_parms
/* QL: * Allocate definition block and set up queues */
/* QL: M106_alloc */
M106_alloc:
/* QL:         move.w  #M106_ser_end,d1     number of bytes needed (n.b. d1 msw is zero) */
    move.w #M106_ser_end,d1
/* QL:         jsr     mm_alchp(pc)    allocate space */
    jsr mm_alchp(pc)
/* QL:         bne.s   M106_popsr           sorry... */
    bne.s M106_popsr
/* QL:         lea     M106_ser_txq(a0),a2  set start of transmit queue */
    lea M106_ser_txq(a0),a2
/* QL:         moveq   #M106_ser_txql,d1    set queue length */
    moveq #M106_ser_txql,d1
/* QL:         jsr     io_qset(pc)     set up the transmit queue */
    jsr io_qset(pc)
/* QL:         lea     M106_ser_rxq(a0),a2  set start of receive queue */
    lea M106_ser_rxq(a0),a2
/* QL:         assert  M106_ser_rxql,M106_ser_txql */
/* original assertion: M106_ser_rxql,M106_ser_txql */
/* QL:         jsr     io_qset(pc)     set up the receive queue */
    jsr io_qset(pc)
/* QL:         move.l  a2,(a5)         tell physical layer where new receive queue is */
    move.l a2,(a5)
/* QL: * Store the parameters */
/* QL: M106_set_parms */
M106_set_parms:
/* QL:         assert  M106_ser_chno,M106_ser_par-2,M106_ser_txhs-4,M106_ser_prot-6 */
/* original assertion: M106_ser_chno,M106_ser_par-2,M106_ser_txhs-4,M106_ser_prot-6 */
/* QL:         movem.w d4-d7,M106_ser_chno(a0) put them all */
    movem.w d4-d7,M106_ser_chno(a0)
/* QL:         moveq   #M106_ops1_cmd-1-32,d1 */
    moveq #((M106_ops1_cmd-1)-32),d1
/* QL: * Tell the IPC what's going on */
/* QL: M106_do_com */
M106_do_com:
/* QL:         assert  M106_ops1_cmd,M106_ops2_cmd-1 */
/* original assertion: M106_ops1_cmd,M106_ops2_cmd-1 */
/* QL:         assert  M106_cls1_cmd,M106_cls2_cmd-1 */
/* original assertion: M106_cls1_cmd,M106_cls2_cmd-1 */
/* QL:         add.w   M106_ser_chno(a0),d1 */
    add.w M106_ser_chno(a0),d1
/* QL:         move.l  a0,a2           save channel base */
    move.l a0,a2
/* QL:         move.l  d6,d2           just for M106_close, adhere to rule: d6 preserved */
    move.l d6,d2
/* QL:         jsr     ip_adcmd(pc)    do ipc command */
    jsr ip_adcmd(pc)
/* QL:         move.l  d2,d6 */
    move.l d2,d6
/* QL:         move.l  a2,a0           restore channel base */
    move.l a2,a0
/* QL:         moveq   #0,d0           set return code */
    moveq #0,d0
/* QL: M106_popsr */
M106_popsr:
/* QL:         move    (sp)+,sr        n.b. rte is no good on a 68020, etc */
    move (sp)+,sr
/* QL:         rts */
    rts 
/* QL: * Close a serial channel. */
/* QL: * The channel structure is not discarded here, as there may be further data */
/* QL: * pending in the transmit queue. This deserves more thought! (lwr) */
/* QL: M106_close */
M106_close:
/* QL:         tst.b   M106_ser_prot+1(a0)  is it ctrl/z or crlf protocol? */
    tst.b (M106_ser_prot+1)(a0)
/* QL:         bmi.s   M106_cl_czok         nope - no ctrl/z needed */
    bmi.s M106_cl_czok
/* QL: M106_cl_czlp */
M106_cl_czlp:
/* QL:         moveq   #'z'&31,d1      we need to put ctrl/z onto the queue */
    moveq #(122&31),d1
/* QL:         bsr.s   M106_sbyte           try to put out the ctrl/z */
    bsr.s M106_sbyte
/* QL:         addq.l  #-M106_err.nc,d0     is it not complete? */
.word 20608|((((-M106_err.nc))&7)<<9)
/* QL:         beq.s   M106_cl_czlp         hopefully, we will eventually get there! */
    beq.s M106_cl_czlp
/* QL: * The above loop is not wildly satisfactory, as it can be held up indefinately */
/* QL: * by a "serh" channel with the handshake holding off output permanently. */
/* QL: * The original technique relied on outputting the ctrl/z when the IPC had */
/* QL: * emptied the queue, but this was prone to the syndrome of changing */
/* QL: * protocols before the code had actioned the protocol. E.g. sending a series */
/* QL: * of small ctrl/z files, then changing to "serr" would not send any ctrl/z's! */
/* QL: * An alternative scheme to avoid the handshake problems suffers from the same */
/* QL: * flaw as the above. This would be to use a special byte in the output queue */
/* QL: * as an "escape" character. A preferred value would be a zero byte. The output */
/* QL: * would then double up single nulls when they were real, say, and restore them */
/* QL: * in the input routine. Other byte values after a null would be used to pass */
/* QL: * M106_open/M106_close parameters down. */
/* QL: M106_cl_czok */
M106_cl_czok:
/* QL:         move    sr,-(sp) */
    move sr,-(sp)
/* QL:         or.w    #$700,sr        be cautious - make sure no mishaps! (lwr) */
    or.w #0x700,sr
/* QL:         tas     M106_ser_txq+M106_q_eoff(a0) ok, so we know how to set end of file! */
    tas (M106_ser_txq+M106_q_eoff)(a0)
/* QL: *        lea     M106_ser_txq(a0),a2  set end of file */
/* QL: *        jsr     io_qeof(pc)     mark queue as end of file */
/* QL:         moveq   #M106_cls1_cmd-1-32,d1 */
    moveq #((M106_cls1_cmd-1)-32),d1
/* QL:         bra.s   M106_do_com */
    bra.s M106_do_com
/* QL: * Come here to test if the serial port has input pending */
/* QL: M106_pend */
M106_pend:
/* QL:         lea     M106_ser_rxq(a0),a2  get queue address */
    lea M106_ser_rxq(a0),a2
/* QL:         jmp     io_qtest(pc)    see if queue is empty */
    jmp io_qtest(pc)
/* QL: * Read a character from a serial port. */
/* QL: * The code that stuffed the bytes into the queue is in the ipc routines. */
/* QL: * This routine takes a byte out of the specified queue, and checks any parity. */
/* QL: * An optional user routine may then be used to convert the byte. This can */
/* QL: * discard unwanted bytes by setting d0=M106_err.nc and skipping its return address. */
/* QL: * Many-to-one conversions may be acheived by retaining context. One-to-many */
/* QL: * conversions are currently difficult/impossible! */
/* QL: * The cr/lf and ctrl/z requirement are actioned last. */
/* QL: M106_fbyte */
M106_fbyte:
/* QL:         lea     M106_ser_rxq(a0),a2  get address of queue */
    lea M106_ser_rxq(a0),a2
/* QL:         jsr     io_qout(pc)     take out a byte */
    jsr io_qout(pc)
/* QL:         bne.s   M106_rts1            there isn't one... */
    bne.s M106_rts1
/* QL:         move.b  M106_ser_par+1(a0),d2 get parity requirements */
    move.b (M106_ser_par+1)(a0),d2
/* QL:         beq.s   M106_rx_pok          no parity required - go check next bit */
    beq.s M106_rx_pok
/* QL:         subq.b  #2,d2           odd=-1 even=0 mark=1 space=2 */
    subq.b #2,d2
/* QL:         bhi.s   M106_rx_plus         mark/space - go check it */
    bhi.s M106_rx_plus
/* QL:         moveq   #127,d0         don't include the top bit */
    moveq #127,d0
/* QL:         and.b   d1,d0 */
    and.b d1,d0
/* QL: M106_rx_shft */
M106_rx_shft:
/* QL:         eor.b   d0,d2           flip lsb of parity reg for one bit */
    eor.b d0,d2
/* QL:         lsr.b   #1,d0           shift next bit */
    lsr.b #1,d0
/* QL:         bne.s   M106_rx_shft         loop until all non-zero bits done */
    bne.s M106_rx_shft
/* QL: M106_rx_plus */
M106_rx_plus:
/* QL:         lsl.b   #7,d2           move type bit to msb */
    lsl.b #7,d2
/* QL:         eor.b   d2,d1           flip top bit of data byte */
    eor.b d2,d1
/* QL:         bmi.s   M106_err_te          now set - go report error */
    bmi.s M106_err_te
/* QL: M106_rx_pok */
M106_rx_pok:
/* QL:         moveq   #M106_sx_itran,d2    appropriate translation routine offset */
    moveq #M106_sx_itran,d2
/* QL:         bsr.s   M106_extrn           go see about it */
    bsr.s M106_extrn
/* QL:         tst.b   M106_ser_prot+1(a0)  is it ctrl/z or cr/lf protocol? */
    tst.b (M106_ser_prot+1)(a0)
/* QL:         blt.s   M106_ok_rts          no - we're finished */
    blt.s M106_ok_rts
/* QL:         beq.s   M106_rx_cz           zero, just do ctrl/z check */
    beq.s M106_rx_cz
/* QL:         bsr.s   M106_cr_proto        handle cr/lf exchange */
    bsr.s M106_cr_proto
/* QL: M106_rx_cz */
M106_rx_cz:
/* QL:         moveq   #M106_err.ef,d0 */
    moveq #M106_err.ef,d0
/* QL:         cmp.b   #'z'&31,d1      is it ctrl/z? */
    cmp.b #((122&31)&255),d1
/* QL:         beq.s   M106_rts1 */
    beq.s M106_rts1
/* QL: M106_ok_rts */
M106_ok_rts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M106_rts1 */
M106_rts1:
/* QL:         rts */
    rts 
/* QL: M106_cr_proto */
M106_cr_proto:
/* QL:         moveq   #13,d0 */
    moveq #13,d0
/* QL:         sub.b   d1,d0           is it cr? */
    sub.b d1,d0
/* QL:         beq.s   M106_rx_cr           yes, flip it */
    beq.s M106_rx_cr
/* QL:         subq.b  #13-10,d0       is it lf? */
.word 20736|((((13-10))&7)<<9)
/* QL:         bne.s   M106_rts1            no, return now */
    bne.s M106_rts1
/* QL:         addq.b  #2*3,d1 */
    addq.b #(2*3),d1
/* QL: M106_rx_cr */
M106_rx_cr:
/* QL:         subq.b  #3,d1           cr <--> lf */
    subq.b #3,d1
/* QL:         rts */
    rts 
/* QL: M106_err_te */
M106_err_te:
/* QL:         moveq   #M106_err.te,d0      transmission error (and -ve for proto return) */
    moveq #M106_err.te,d0
/* QL:         rts */
    rts 
/* QL: * sx_itrn: input translation routine: */
/* QL: * d1 -i o- byte after parity action / byte to be cr/lf/cz processed */
/* QL: * a0 -ip - base of serial channel definition */
/* QL: * a2 -i  - base of serial input queue */
/* QL: * d0/d2-d3/a1/a3 destroyed. */
/* QL: * d1 should be used to supply bytes to the caller. */
/* QL: * Skipping the return address and setting d0 to M106_err.nc will cause the input */
/* QL: * byte to be discarded. (d1 may be destroyed). */
/* QL: * Only one-to-none and one-to-one conversions are convenient. */
/* QL: * sx_otrn: output translation routine: */
/* QL: * d1 -i o- byte after cr/lf/cz action / byte to be parity processed */
/* QL: * a0 -ip - base of serial channel definition */
/* QL: * a2 -i  - base of serial output queue */
/* QL: * d0/d2-d3/a1/a3 destroyed. */
/* QL: * If the value in d1 is not to be sent, an appropriate value should be set in */
/* QL: * d0 (M106_err.nc normally) and the return address skipped. */
/* QL: * A one-to-many translation must verify that the queue has space, by calling */
/* QL: * io_qtest through the vector at $de, and if there is insufficient space, */
/* QL: * set M106_err.nc in d0 and skip the return address. */
/* QL: * If the space is ok, the return address should be "jsr"ed to for all but the */
/* QL: * last byte, leaving that to go as normal. */
/* QL: * Only one-to-none, one-to-one and one-to-many conversions are convenient. */
/* QL: * If the return address mentioned above is used, it requires the following: */
/* QL: * d0 -  o- 0 (or error - queue full (M106_err.nc) - should never happen!) */
/* QL: * d1 -i o- byte to put in queue (output with parity actioned) */
/* QL: * a2 -ip - pointer to queue */
/* QL: * d2/a3 destroyed */
/* QL: M106_extrn */
M106_extrn:
/* QL:         tst.b   M106_sv_tran(a6)     check if translation wanted */
    tst.b M106_sv_tran(a6)
/* QL:         beq.s   M106_rts1            no, leave it alone */
    beq.s M106_rts1
/* QL:         move.l  M106_sv_chtop(a6),a3 dig into system extension */
    move.l M106_sv_chtop(a6),a3
/* QL:         move.l  0(a3,d2.l),a3   come out with current translate routine addr */
    move.l 0(a3,d2.l),a3
/* QL:         jmp     (a3)            call via vector */
    jmp (a3)
/* QL: * Write a character to a serial port. */
/* QL: * This actions lf<->cr conversions first. */
/* QL: * An optional user routine may then handle the character. */
/* QL: * The byte is then stuffed in the output queue with appropriate parity. */
/* QL: M106_sbyte */
M106_sbyte:
/* QL:         lea     M106_ser_txq(a0),a2  transmit queue address */
    lea M106_ser_txq(a0),a2
/* QL:         tst.b   M106_ser_prot+1(a0)  is it ctrl/z or cr/lf protocol? */
    tst.b (M106_ser_prot+1)(a0)
/* QL:         ble.s   M106_tx_nop          no - we're finished */
    ble.s M106_tx_nop
/* QL:         bsr.s   M106_cr_proto        handle cr/lf exchange */
    bsr.s M106_cr_proto
/* QL: M106_tx_nop */
M106_tx_nop:
/* QL:         moveq   #M106_sx_otran,d2    the appropriate user routine slot */
    moveq #M106_sx_otran,d2
/* QL:         bsr.s   M106_extrn           go do translate, if enabled */
    bsr.s M106_extrn
/* QL: * N.B. The remainder of this section may be "jsr"ed to by the user routine. */
/* QL:         move.b  M106_ser_par+1(a0),d2 get parity requirements */
    move.b (M106_ser_par+1)(a0),d2
/* QL:         beq.s   M106_tx_pok          no parity, send it as is */
    beq.s M106_tx_pok
/* QL:         add.b   d1,d1           lose current msb of byte */
    add.b d1,d1
/* QL:         lsl.b   #6,d2           odd=$40, even=$80, mark=$c0, space=$00 */
    lsl.b #6,d2
/* QL:         add.b   d2,d2           odd/mark=$80, even/space=$00 */
    add.b d2,d2
/* QL:         bvc.s   M106_tx_par          mark/space - go put in the top bit */
    bvc.s M106_tx_par
/* QL:         move.b  d1,d0           make copy of remaining 7 bits of byte */
    move.b d1,d0
/* QL: M106_tx_shft */
M106_tx_shft:
/* QL:         eor.b   d0,d2           flip msb of parity reg for one bit */
    eor.b d0,d2
/* QL:         add.b   d0,d0           shift up next bit */
    add.b d0,d0
/* QL:         bne.s   M106_tx_shft         loop until all non-zero bits done */
    bne.s M106_tx_shft
/* QL: M106_tx_par */
M106_tx_par:
/* QL:         add.b   d2,d2           move parity bit into x */
    add.b d2,d2
/* QL:         roxr.b  #1,d1           put it into the byte */
    roxr.b #1,d1
/* QL: M106_tx_pok */
M106_tx_pok:
/* QL:         jmp     io_qin(pc)      stuff byte into queue */
    jmp io_qin(pc)
/* QL:         end */
