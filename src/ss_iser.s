/* ROM section ss_iser */
.balign 2,0
/* QL: * Wait for completion of serial transmit */
/* QL: * Note: this uses an entirely new method of waiting, which depends on bit 7, in */
/* QL: * the M7_pc_intr byte (which i will refer to as "baud", and which is a square wave */
/* QL: * at the current baud rate), making it totally gold card compatible. */
/* QL: * experimentally verified, the following sequence of events takes place during */
/* QL: * serial transmissions: */
/* QL: * 1) a byte written to M7_pc_tdata will instantly set M7_pc..txfl in pc_ipcrd. */
/* QL: * 2) this is recognised at the next trailing edge of baud (going from 1 to 0) */
/* QL: * 3) at the next trailing edge of baud, pc..intt in M7_pc_intr is set to one. */
/* QL: * 4) not quite instantly after this, M7_pc..txfl goes to zero. */
/* QL: * 5) another byte may be sent at this point. */
/* QL: * 6) on the next leading edge of baud, the serial line begins the start bit. */
/* QL: * 7) the data bits and two stop bits are started on subsequent leading edges. */
/* QL: * 8) if another byte had been sent, M7_pc..txfl will go to zero half way through */
/* QL: *    the final stop bit, just after that trailing edge of baud, and thus */
/* QL: *    repeating the pattern from 4) above. */
/* QL: * Unfortunately, once M7_pc..txfl has gone away, there is no guaranteed way to */
/* QL: * tell where within the last byte one might be. */
/* QL: * d0 -i  - M7_pc.netmd for net required, M7_pc.mdvmd for mdv required */
/* QL: ss_wser */
ss_wser:
/* QL:         subq.w  #1,M7_sv_timo(a6)  decrement timeout */
    subq.w #1,M7_sv_timo(a6)
/* QL:         blt.s   M7_nowait          fine if it was zero (or negative!) */
    blt.s M7_nowait
/* QL: M7_wait */
M7_wait:
/* QL:         move.l  d0,-(sp)        save operation */
    move.l d0,-(sp)
/* QL: M7_full */
M7_full:
/* QL:         btst    #M7_pc..txfl,M7_pc_ipcrd */
    btst #M7_pc..txfl,M7_pc_ipcrd
/* QL:         bne.s   M7_full            M7_wait until transmit buffer is empty */
    bne.s M7_full
/* QL:         moveq   #12-1,d0        start bit comes 1/2 bit later, 8 data + 2 stop */
    moveq #(12-1),d0
/* QL: M7_high */
M7_high:
/* QL:         tst.b   M7_pc_intr */
    tst.b M7_pc_intr
/* QL:         bmi.s   M7_high             (actually always M7_low when buffer empties) */
    bmi.s M7_high
/* QL: M7_low */
M7_low:
/* QL:         tst.b   M7_pc_intr */
    tst.b M7_pc_intr
/* QL:         bpl.s   M7_low */
    bpl.s M7_low
/* QL:         dbra    d0,M7_high */
    dbra d0,M7_high
/* QL:         move.l  (sp)+,d0        restore operation */
    move.l (sp)+,d0
/* QL: M7_nowait */
M7_nowait:
/* QL:         clr.w   M7_sv_timo(a6)     clear M7_wait */
    clr.w M7_sv_timo(a6)
/* QL:         and.b   #M7_pc.notmd,M7_sv_tmode(a6) not rs232 */
    and.b #(M7_pc.notmd&255),M7_sv_tmode(a6)
/* QL:         or.b    d0,M7_sv_tmode(a6) either mdv or net */
    or.b d0,M7_sv_tmode(a6)
/* QL:         assert  1<<7,M7_pc.maskt */
/* original assertion: 1<<7,M7_pc.maskt */
/* QL:         bclr    #7,M7_sv_pcint(a6) disable transmit interrupt */
    bclr #7,M7_sv_pcint(a6)
/* QL:         bra.s   M7_exit */
    bra.s M7_exit
/* QL: * Re-enable serial transmit */
/* QL: ss_rser */
ss_rser:
/* QL:         and.b   #M7_pc.notmd,M7_sv_tmode(a6) set rs232 mode, ser1 */
    and.b #(M7_pc.notmd&255),M7_sv_tmode(a6)
/* QL:         tas     M7_sv_pcint(a6)    enable transmit interrupt */
    tas M7_sv_pcint(a6)
/* QL: M7_exit */
M7_exit:
/* QL:         move.b  M7_sv_tmode(a6),M7_pc_tctrl set pc */
    move.b M7_sv_tmode(a6),M7_pc_tctrl
/* QL:         rts */
    rts 
/* QL:         vect4000 ss_rser,ss_wser */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ ss$rser,(ss_rser-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ ss$wser,(ss_wser-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
