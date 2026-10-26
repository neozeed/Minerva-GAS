/* ROM section ip_int */
.balign 2,0
/* QL: * Check out the IPC as one of the routines on the frame interrupt polling list. */
/* QL: * d0-d2/d4-d7/a0-a3 destroyed. */
/* QL: * d3 -ip - count of missed poll interrupts */
/* QL: ip_poll */
ip_poll:
/* QL:         move    sr,-(sp) */
    move sr,-(sp)
/* QL:         or.w    #$700,sr        disable interrupts */
    or.w #0x700,sr
/* QL:         bsr.s   ip_ipcr */
    bsr.s ip_ipcr
/* QL:         move    (sp)+,sr        n.b. rte is no good on a 68020 */
    move (sp)+,sr
/* QL:         rts */
    rts 
/* QL: * This maintains the sound and wp flags, keyboard and serial port input. */
/* QL: * It is called on either frame or interface interrupts. */
/* QL: * d3 -ip - count of missed poll interrupts */
/* QL: * a0 -  o- M21_pc_ipcrd */
/* QL: * a1 -  o- M21_pc_ipcwr */
/* QL: * d0-d2/d4-d7/a2-a3 destroyed. */
/* QL: ip_ipcr */
ip_ipcr:
/* QL:         moveq   #M21_stat_cmd-32*3,d1 status command + read a byte (2 nibbles) */
    moveq #(M21_stat_cmd-(32*3)),d1
/* QL:         bsr.s   ip_adcmd        set a0-a1, ask for status and receive status */
    bsr.s ip_adcmd
/* QL:                 ;               1?w21??sk------- */
/* QL:         exg     d1,d7           save it */
    exg d1,d7
/* QL:         assert  0,M21_ipc..kb */
/* original assertion: 0,M21_ipc..kb */
/* QL:         ; bit 7 is the last bit fetched, and the n flag will be set by it */
/* QL: * Also see if there is input pending on the keyboard */
/* QL:         bpl.s   M21_nokbd           don't bother if not */
    bpl.s M21_nokbd
/* QL:         move.l  M21_sv_keyq(a6),d0  fetch ptr to current keyboard queue */
    move.l M21_sv_keyq(a6),d0
/* QL:         beq.s   M21_nokbd           no queue, don't bother reading the IPC */
    beq.s M21_nokbd
/* QL:         move.l  d0,a2 */
    move.l d0,a2
/* QL:         moveq   #M21_rdkb_cmd-32*2,d1 read kbd command + read one nibble */
    moveq #(M21_rdkb_cmd-(32*2)),d1
/* QL:         bsr.s   M21_ip_cmd          give it */
    bsr.s M21_ip_cmd
/* QL:         ror.w   #7,d1 */
    ror.w #7,d1
/* QL:         move.b  d1,d5           save it for "held" flag in bit 4 */
    move.b d1,d5
/* QL:         moveq   #7,d4 */
    moveq #7,d4
/* QL:         and.b   d1,d4           extract number of keystrokes */
    and.b d1,d4
/* QL:         bra.s   M21_char1           enter at bottom of loop */
    bra.s M21_char1
/* QL: M21_rdch */
M21_rdch:
/* QL:         moveq   #-2*3,d1        read 3 nibbles */
    moveq #((-2)*3),d1
/* QL:         bsr.s   ip_rdwr         read the shift/ctrl/alt nibble and key number */
    bsr.s ip_rdwr
/* QL:         lsr.l   #7,d1           key number byte in d1 */
    lsr.l #7,d1
/* QL:         move.w  d1,d2 */
    move.w d1,d2
/* QL:         lsr.w   #8,d2           shift/ctrl/alt in d2 */
    lsr.w #8,d2
/* QL:         jsr     ip_kbrd(pc)     go process it */
    jsr ip_kbrd(pc)
/* QL: M21_char1 */
M21_char1:
/* QL:         dbra    d4,M21_rdch         and again if there are more characters */
    dbra d4,M21_rdch
/* QL:         jsr     ip_kbend(pc)    go finish off autorepeat setting */
    jsr ip_kbend(pc)
/* QL: M21_nokbd */
M21_nokbd:
/* QL: * update the sound process finished system variable */
/* QL:         rol.w   #9+M21_ipc..kb-M21_ipc..so,d7 */
    rol.w #((9+M21_ipc..kb)-M21_ipc..so),d7
/* QL:                 ;               1?w21??s carry=s */
/* QL:         scs     M21_sv_sound(a6)    set to ones if running, else zero */
    scs M21_sv_sound(a6)
/* QL:                 ;               1?w21??s */
/* QL:         rol.b   #8+M21_ipc..so-M21_ipc..wp,d7 */
    rol.b #((8+M21_ipc..so)-M21_ipc..wp),d7
/* QL:                 ;               21??s1?w carry=w, sign=ser2 */
/* QL:         scc     M21_sv_wp(a6)       set the write protect flag, IPC P26 input */
    scc M21_sv_wp(a6)
/* QL:         move.l  M21_sv_chtop(a6),a3 get extension address */
    move.l M21_sv_chtop(a6),a3
/* QL:         move.b  d7,$4e(a3)      experimental 21??s1?w */
    move.b d7,0x4e(a3)
/* QL: * now see if there is input pending on the rs232 channels */
/* QL:         assert  M21_ipc..s2,M21_ipc..wp-1 */
/* original assertion: M21_ipc..s2,M21_ipc..wp-1 */
/* QL:         bpl.s   M21_noser2 */
    bpl.s M21_noser2
/* QL:         moveq   #M21_rds2_cmd-3*32,d5 read serial 2 + read a byte (2 nibbles) */
    moveq #(M21_rds2_cmd-(3*32)),d5
/* QL:         move.l  M21_sv_ser2c(a6),d0 fetch queue pointer */
    move.l M21_sv_ser2c(a6),d0
/* QL:         bsr.s   M21_rdser           get the input (maybe) */
    bsr.s M21_rdser
/* QL: M21_noser2 */
M21_noser2:
/* QL:         assert  M21_ipc..s1,M21_ipc..s2-1 */
/* original assertion: M21_ipc..s1,M21_ipc..s2-1 */
/* QL:                 ;               21??01?w */
/* QL:         add.b   d7,d7           check for ser1 and state of wp */
    add.b d7,d7
/* QL:                 ;               1??01?w0 sign=ser1 */
/* QL:         bpl.s   M21_noser1 */
    bpl.s M21_noser1
/* QL:         moveq   #M21_rds1_cmd-3*32,d5 read serial 1 + read a byte (2 nibbles) */
    moveq #(M21_rds1_cmd-(3*32)),d5
/* QL:         move.l  M21_sv_ser1c(a6),d0 */
    move.l M21_sv_ser1c(a6),d0
/* QL:         bsr.s   M21_rdser           get the input (maybe) */
    bsr.s M21_rdser
/* QL: M21_noser1 */
M21_noser1:
/* QL:         rts */
    rts 
/* QL: * set up addresses for the IPC read and write routines */
/* QL: * a0 -  o- M21_pc_ipcrd, IPC read address */
/* QL: * a1 -  o- M21_pc_ipcwr, IPC write address */
/* QL: ip_setad */
ip_setad:
/* QL:         lea     M21_pc_ipcwr,a1     write address */
    lea M21_pc_ipcwr,a1
/* QL:         lea     M21_pc_ipcrd-M21_pc_ipcwr(a1),a0 read address */
    lea (M21_pc_ipcrd-M21_pc_ipcwr)(a1),a0
/* QL:         rts */
    rts 
/* QL: * IPC combined command and read routine */
/* QL: * The input value contains up to 6 command nibbles and a count. */
/* QL: * Three entries points are provided, the first of which (ip_adcmd) calls */
/* QL: * ip_setad to set up a0-a1 before dropping into the second (M21_ip_cmd) which just */
/* QL: * rolls the 4 lsbs around to the top to provided the initial command nibble. */
/* QL: * The final entry (ip_rdwr) is then dropped into. */
/* QL: * Bits 31..8 are then the command/data nibbles, with all ones (15) used for */
/* QL: * pure reading, and they are sent starting with the nibble in bits 31..28. */
/* QL: * Bits 7..4 are ignored, but for convenience they will probably be set to ones. */
/* QL: * Bits 3..1 may be -1..-6(7..2), giving the negated total nibble count (1..6). */
/* QL: * Bit 0 is ignored. */
/* QL: * If the above seems complicated, it is simple to use, with typical calls: */
/* QL: * To send an initial command nibble: "moveq #xxx_cmd-32,d1;jsr ip_adcmd". */
/* QL: * Another command & read "n" nibbles "moveq #xxx_cmd-32*(1+n),d1;jsr M21_ip_cmd" */
/* QL: * To just read "n" nibbles "moveq #-2*n,d1;jsr ip_rdwr". */
/* QL: * The returned value will provide up to six nibbles in bits 30..7, the one in */
/* QL: * bits 14..7 being the last, or only, such nibble. X and bits 31 down will in */
/* QL: * fact be the bits after the last bit that was sent, if that's of any use! */
/* QL: * The remaining bits 6..0 are as read from M21_pc_ipcrd along with the final bit. */
/* QL: * The final bit will set the ccr n flag. */
/* QL: * The reasoning behind combining the read and write functions like this is that */
/* QL: * the IPC takes a little time to process each bit, enough to set up a new write */
/* QL: * value without impairing the overall speed. The code here is arranged to make */
/* QL: * the actual handshake with the IPC turn round bits as rapidly as they can be */
/* QL: * read, with just one instruction more than if they were merely being written. */
/* QL: * By allowing up to six nibbles to be involved in each transfer, we are able, */
/* QL: * for example, to read the serial input three bytes at at time. */
/* QL: * d1 -i o- nibble count and commands / read nibbles in 30..7 (ccr for 7..0) */
/* QL: * a0 -ip - M21_pc_ipcrd */
/* QL: * a1 -ip - M21_pc_ipcwr */
/* QL: * d0/d6 destroyed (d0.l=12+2*<last bit sent>, d6.l=$ffff0001) */
/* QL: ip_adcmd */
ip_adcmd:
/* QL:         bsr.s   ip_setad        set up addresses */
    bsr.s ip_setad
/* QL: M21_ip_cmd */
M21_ip_cmd:
/* QL:         ror.l   #4,d1           roll command to top nibble */
    ror.l #4,d1
/* QL: ip_rdwr */
ip_rdwr:
/* QL:         add.l   d1,d1           note lsb now zero */
    add.l d1,d1
/* QL:         moveq   #%1100>>2,d0    forming write byte for first bit */
    moveq #(0b1100>>2),d0
/* QL:         roxl.b  #2,d0 */
    roxl.b #2,d0
/* QL:         move.b  d0,(a1)         send it now, to get the IPC under way */
    move.b d0,(a1)
/* QL:         moveq   #-2-7*4,d6      %1111ccc10, ccc = -ve total nibble count */
    moveq #((-2)-(7*4)),d6
/* QL:         or.b    d1,d6           form -ve count now, before waiting for the IPC */
    or.b d1,d6
/* QL: M21_iploop */
M21_iploop:
/* QL:         add.l   d1,d1           roll up the read bit */
    add.l d1,d1
/* QL:         moveq   #%1100>>2,d0    forming write byte for next bit */
    moveq #(0b1100>>2),d0
/* QL:         roxl.b  #2,d0 */
    roxl.b #2,d0
/* QL: M21_ipwait1 */
M21_ipwait1:
/* QL:         btst    #6,(a0)         has the previous bit been used by the IPC yet? */
    btst #6,(a0)
/* QL:         bne.s   M21_ipwait1         no, wait for it */
    bne.s M21_ipwait1
/* QL:         move.b  (a0),d1         get data bit in bit 7 */
    move.b (a0),d1
/* QL:         move.b  d0,(a1)         we are ready instantly to send next write byte */
    move.b d0,(a1)
/* QL:         addq.w  #1,d6           (pity, but 2 extra cycles for addq.l) */
    addq.w #1,d6
/* QL:         ble.s   M21_iploop          go start preparing next write byte */
    ble.s M21_iploop
/* QL:         add.l   d1,d1           roll up the penultimate bit */
    add.l d1,d1
/* QL: M21_ipwait2 */
M21_ipwait2:
/* QL:         btst    #6,(a0)         has final bit been processed by the IPC? */
    btst #6,(a0)
/* QL:         bne.s   M21_ipwait2         no - wait for it */
    bne.s M21_ipwait2
/* QL:         move.b  (a0),d1         get final data bit in bit 7, plus rest of stuff */
    move.b (a0),d1
/* QL:         rts */
    rts 
/* QL: * This routine gets a stream of bytes from the serial input channel of the IPC */
/* QL: * and shoves them into the appropriate queue. */
/* QL: * ccr-i  - z set if d0.l=0 */
/* QL: * d0 -i  - serial channel queue address */
/* QL: * d5 -ip - IPC serial read command for this channel */
/* QL: * a0 -ip - M21_pc_ipcrd */
/* QL: * a1 -ip - M21_pc_ipcwr */
/* QL: * a2 -  o- serial channel queue address */
/* QL: * d1-d2/d4/d6/a3 destroyed */
/* QL: M21_rdser */
M21_rdser:
/* QL:         beq.s   M21_rts0            no queue, so leave data in IPC */
    beq.s M21_rts0
/* QL:         move.l  d0,a2           set up serial channel */
    move.l d0,a2
/* QL:         bsr.s   M21_qtest           see how much room in queue */
    bsr.s M21_qtest
/* QL:         cmp.w   #M21_sbsize,d2      is it enough for a full IPC buffer? */
    cmp.w #M21_sbsize,d2
/* QL:         blt.s   M21_rts0            can't guarantee we can read it all, so leave it */
    blt.s M21_rts0
/* QL:         move.l  d5,d1           restore the appropriate IPC command */
    move.l d5,d1
/* QL:         bsr.s   M21_ip_cmd          send it, read number of bytes to be transferred */
    bsr.s M21_ip_cmd
/* QL:         ror.w   #7,d1 */
    ror.w #7,d1
/* QL:         lea     M21_sv_timov-M21_rds1_cmd+3*32(a6),a3 base serial control byte address */
    lea ((M21_sv_timov-M21_rds1_cmd)+(3*32))(a6),a3
/* QL:         assert  M21_rds1_cmd,M21_rds2_cmd-1 */
/* original assertion: M21_rds1_cmd,M21_rds2_cmd-1 */
/* QL:         add.w   d5,a3 */
    add.w d5,a3
/* QL:         moveq   #-32,d4 */
    moveq #(-32),d4
/* QL:         and.b   d1,d4 */
    and.b d1,d4
/* QL:         or.b    d4,(a3)         accumulate lost data/frame error/?? flags */
    or.b d4,(a3)
/* QL:         eor.b   d1,d4           keep the byte count (0..31(23)) */
    eor.b d1,d4
/* QL:         bra.s   M21_rsent           enter loop */
    bra.s M21_rsent
/* QL: M21_rdsch */
M21_rdsch:
/* QL:         moveq   #-2*6,d1        three bytes (6 nibbles) */
    moveq #((-2)*6),d1
/* QL:         bsr.s   ip_rdwr         read them in */
    bsr.s ip_rdwr
/* QL:         add.l   d1,d1           put them in msbs */
    add.l d1,d1
/* QL:         bsr.s   M21_qnext           stuff first */
    bsr.s M21_qnext
/* QL:         bsr.s   M21_qnext           stuff second */
    bsr.s M21_qnext
/* QL:         bsr.s   M21_qnext           stuff third */
    bsr.s M21_qnext
/* QL: M21_rsent */
M21_rsent:
/* QL:         subq.b  #3,d4 */
    subq.b #3,d4
/* QL:         bge.s   M21_rdsch           loop around */
    bge.s M21_rdsch
/* QL:         addq.b  #3,d4 */
    addq.b #3,d4
/* QL:         beq.s   M21_rts0            finished if multiple of 3 */
    beq.s M21_rts0
/* QL: M21_rsone */
M21_rsone:
/* QL:         moveq   #-2*2,d1        one byte (2 nibbles) */
    moveq #((-2)*2),d1
/* QL:         bsr.s   ip_rdwr */
    bsr.s ip_rdwr
/* QL:         ror.w   #7,d1 */
    ror.w #7,d1
/* QL:         bsr.s   M21_qin */
    bsr.s M21_qin
/* QL:         subq.b  #1,d4 */
    subq.b #1,d4
/* QL:         bne.s   M21_rsone */
    bne.s M21_rsone
/* QL: M21_rts0 */
M21_rts0:
/* QL:         rts */
    rts 
/* QL: M21_qnext */
M21_qnext:
/* QL:         rol.l   #8,d1 */
    rol.l #8,d1
/* QL: M21_qin */
M21_qin:
/* QL:         jmp     io_qin(pc) */
    jmp io_qin(pc)
/* QL: * Scheduler list routine for handling serial output */
/* QL: * d3 -ip - count of missed poll interrupts */
/* QL: * d0-d2/d4-d6/a0-a5 destroyed. */
/* QL: ip_sched */
ip_sched:
/* QL:         sf      d4              say this is from scheduler loop */
    sf d4
/* QL:         move    sr,-(sp) */
    move sr,-(sp)
/* QL:         or.w    #$700,sr        disable interrupts */
    or.w #0x700,sr
/* QL:         bsr.s   ip_txqo         go send any rs232 */
    bsr.s ip_txqo
/* QL:         move    (sp)+,sr        n.b. rte is no good on a 68020 */
    move (sp)+,sr
/* QL:         rts                     back to calling code */
    rts 
/* QL: M21_qtest */
M21_qtest:
/* QL:         jmp     io_qtest(pc) */
    jmp io_qtest(pc)
/* QL: * This is called either via ip_sched, or on rs232 transmit interrupts. */
/* QL: * It will swap queues when nothing can be done on the one it is looking at, */
/* QL: * and, as a new enhancement, it will only change over if there is something to */
/* QL: * be sent by the other channel. */
/* QL: * It takes a byte out of the transmit queue (if there is one) and sends it */
/* QL: * over the serial channel. */
/* QL: * If this has been called from the scheduler, memory is released if the */
/* QL: * transmit queue is closed and both queues for a port are empty. */
/* QL: * d3 -ip - count of missed poll interrupts */
/* QL: * d4 -ip - lsb $ff = interrupt, 0 = scheduler */
/* QL: * d0-d2/d5-d6/a0-a5 destroyed. */
/* QL: ip_txqo */
ip_txqo:
/* QL:         lea     M21_pc_mctrl,a1     set up control register address */
    lea M21_pc_mctrl,a1
/* QL:         btst    #M21_pc..txfl,(a1)  is transmit buffer full? */
    btst #M21_pc..txfl,(a1)
/* QL:         bne.s   M21_rts0            yes - don't bother even think about sending */
    bne.s M21_rts0
/* QL:         lea     M21_sv_tmode(a6),a4 set address of transmit mode system variable */
    lea M21_sv_tmode(a6),a4
/* QL:         moveq   #0,d5           set msb zero, so we know what we're doing */
    moveq #0,d5
/* QL:         move.b  (a4),d5         get transmit mode */
    move.b (a4),d5
/* QL:         assert  M21_pc..sern,M21_pc..serb-1 */
/* original assertion: M21_pc..sern,M21_pc..serb-1 */
/* QL:         lsl.b   #8-M21_pc..serb,d5  are we set to rs232 mode? */
    lsl.b #(8-M21_pc..serb),d5
/* QL:         bcs.s   M21_rts0            no - don't try to transmit */
    bcs.s M21_rts0
/* QL:         assert  M21_pc..dtr1,M21_pc..cts2-1 */
/* original assertion: M21_pc..dtr1,M21_pc..cts2-1 */
/* QL:         spl     d5              find out which port is in use */
    spl d5
/* QL: M21_other1 */
M21_other1:
/* QL:         move.b  d5,d6 */
    move.b d5,d6
/* QL:         lea     M21_sv_ser1c(a6),a5 address of ser1 receive queue */
    lea M21_sv_ser1c(a6),a5
/* QL:         bne.s   M21_serset */
    bne.s M21_serset
/* QL:         addq.l  #M21_sv_ser2c-M21_sv_ser1c,a5 ser2 queue */
.word 20621|((((M21_sv_ser2c-M21_sv_ser1c))&7)<<9)
/* QL: M21_serset */
M21_serset:
/* QL:         move.l  (a5),d1         is there a queue for this port? */
    move.l (a5),d1
/* QL:         beq.s   M21_q_change        there isn't one, try the other next time */
    beq.s M21_q_change
/* QL:         move.l  d1,a0           this is the receive queue */
    move.l d1,a0
/* QL:         lea     M21_ser_txq-M21_ser_rxq(a0),a2 this is the transmit queue */
    lea (M21_ser_txq-M21_ser_rxq)(a0),a2
/* QL:         bsr.s   M21_qtest           have a look at the queue now, to delay h/s test */
    bsr.s M21_qtest
/* QL:         beq.s   M21_chk_hs          byte ready, so go start thinking */
    beq.s M21_chk_hs
/* QL: M21_q_err */
M21_q_err:
/* QL:         addq.l  #-M21_err.nc,d0 */
.word 20608|((((-M21_err.nc))&7)<<9)
/* QL:         bpl.s   M21_q_change        if not eof, go try to change port */
    bpl.s M21_q_change
/* QL:         tst.b   d4              check if this is a scheduler loop call */
    tst.b d4
/* QL:         bne.s   M21_q_change        no - can't do eof as it releases memory */
    bne.s M21_q_change
/* QL:         move.l  a0,a2 */
    move.l a0,a2
/* QL:         bsr.s   M21_qtest           have a look at the receive queue */
    bsr.s M21_qtest
/* QL:         beq.s   M21_q_change        don't release if there's input data pending */
    beq.s M21_q_change
/* QL:         clr.l   (a5)            clear queue pointer */
    clr.l (a5)
/* QL:         sub.w   #M21_ser_rxq,a0 */
    sub.w #M21_ser_rxq,a0
/* QL:         jmp     mm_rechp(pc)    get rid of the channel */
    jmp mm_rechp(pc)
/* QL: M21_chk_hs */
M21_chk_hs:
/* QL:         tst.b   M21_ser_txhs+1-M21_ser_txq(a2) are we checking handshakes? */
    tst.b ((M21_ser_txhs+1)-M21_ser_txq)(a2)
/* QL:         beq.s   M21_txready         no - go straight for a byte */
    beq.s M21_txready
/* QL:         addq.b  #M21_pc..cts2,d6    get handshake bit number */
    addq.b #M21_pc..cts2,d6
/* QL:         btst    d6,(a1)         how is the handshake line? */
    btst d6,(a1)
/* QL:         beq.s   M21_txready         ready - we'll go send this, or switch ports */
    beq.s M21_txready
/* QL: M21_q_change */
M21_q_change:
/* QL:         not.l   d5              have we looked at the other one yet? */
    not.l d5
/* QL:         bmi.s   M21_other1          no - so go see if that might be worth doing */
    bmi.s M21_other1
/* QL: * We drop out here when there was nothing we could do with either port. */
/* QL: M21_rts1 */
M21_rts1:
/* QL:         rts */
    rts 
/* QL: * Everything ok, so let's send the byte M21_qtest gave us, or switch channels */
/* QL: M21_txready */
M21_txready:
/* QL:         lea     M21_sv_timov(a6),a3 set a convenient pointer */
    lea M21_sv_timov(a6),a3
/* QL:         tst.l   d5              are we looking at the current port? */
    tst.l d5
/* QL:         bpl.s   M21_do_send         yes, so we really can send it */
    bpl.s M21_do_send
/* QL: * Check for timeout before changing port */
/* QL: * ZX8302 should only be told change the port when all bytes sent to the current */
/* QL: * port must have certainly been transmitted, or they'll go to the wrong port! */
/* QL:         assert  M21_sv_timo,M21_sv_timov-2 */
/* original assertion: M21_sv_timo,M21_sv_timov-2 */
/* QL:         sub.w   d3,-(a3)        decrement timeout */
    sub.w d3,-(a3)
/* QL:         bge.s   M21_rts1            still not down far enough */
    bge.s M21_rts1
/* QL:         clr.w   (a3)+           clear timeout, as top byte is set */
    clr.w (a3)+
/* QL:         eor.b   #1<<M21_pc..sern,(a4) change port in the system variable */
    eor.b #((1<<M21_pc..sern)&255),(a4)
/* QL: M21_do_send */
M21_do_send:
/* QL:         ext.w   d5 */
    ext.w d5
/* QL:         moveq   #M21_pc.bmask,d0    we want just the baud rate */
    moveq #M21_pc.bmask,d0
/* QL:         and.b   1(a3,d5.w),d0   we hold ser1/ser2 control bytes here now */
    and.b 1(a3,d5.w),d0
/* QL:         and.b   #-1-M21_pc.bmask,(a4) lose baud rate in the system variable */
    and.b #(((-1)-M21_pc.bmask)&255),(a4)
/* QL:         or.b    d0,(a4)         insert correct baud rate in the system variable */
    or.b d0,(a4)
/* QL:         move.b  (a4),M21_pc_tctrl-M21_pc_mctrl(a1) set the zx8302 */
    move.b (a4),(M21_pc_tctrl-M21_pc_mctrl)(a1)
/* QL:         assert  M21_sv_timo,M21_sv_timov-2 */
/* original assertion: M21_sv_timo,M21_sv_timov-2 */
/* QL:         move.b  M21_timov(pc,d0.w),-(a3) use table to set timeout */
    move.b M21_timov(pc,d0.w),-(a3)
/* QL:         move.b  d1,M21_pc_tdata-M21_pc_mctrl(a1) send byte now, as late at possible */
    move.b d1,(M21_pc_tdata-M21_pc_mctrl)(a1)
/* QL:         jmp     io_qout(pc)     discard the byte we have sent */
    jmp io_qout(pc)
/* QL: * We know that we will not be here unless the transmit buffer was empty. */
/* QL: * We know this occurs 1/2 bit before the start, 8 data and 2 stop bits begin. */
/* QL: * Therefore we need only make sure that 11.5 bit times expire before we can */
/* QL: * change ports. */
/* QL: * We cannot count the first clock tick, because it may come instantly. */
/* QL: * At 60Hz tick rate, 11.5 bits at 75 baud require 60*11.5/75 = 9.2 ticks. */
/* QL: M21_timov   dc.b    1,1,1,1,1,2,3,10 */
M21_timov:
M21_dc_anchor_1082:
.byte (1)&255
.byte (1)&255
.byte (1)&255
.byte (1)&255
.byte (1)&255
.byte (2)&255
.byte (3)&255
.byte (10)&255
/* QL:         end */
