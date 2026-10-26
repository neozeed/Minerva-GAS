/* ROM section ii_drive */
.balign 2,0
/* QL: * Front end for somewhat less destructive access. Preserves d3-d6, a0/a2/a4-a5. */
/* QL: M184_drv_end */
M184_drv_end:
/* QL:         move.l  d3,a3 */
    move.l d3,a3
/* QL:         movem.l (sp)+,d3-d6/a0/a2/a4-a5 */
    movem.l (sp)+,d3-d6/a0/a2/a4-a5
/* QL:         rts */
    rts 
/* QL: M184_ii_drive */
M184_ii_drive:
/* QL:         movem.l d3-d6/a0/a2/a4-a5,-(sp) */
    movem.l d3-d6/a0/a2/a4-a5,-(sp)
/* QL:         lea     M184_drv_end,a0 */
    lea M184_drv_end(pc),a0
/* QL: * Entry point needing no RAM at all */
/* QL: M184_ii_raw */
M184_ii_raw:
/* QL:         move.l  a3,d3 */
    move.l a3,d3
/* QL:         lea     $bfdc,a4 */
    lea 0xbfdc,a4
/* QL:         lea     1(a4),a5 */
    lea 1(a4),a5
/* QL:         lea     2(a4),a2 */
    lea 2(a4),a2
/* QL:         lea     3(a4),a3 */
    lea 3(a4),a3
/* QL:         cmp.l   #'gold',$4000a  hopefully, a magic test for the gold card */
    cmp.l #1735355492,0x4000a
/* QL:         bne.s   M184_new_cmd         if not a gc, we're operating ok */
    bne.s M184_new_cmd
/* QL: M184_err_ff */
M184_err_ff:
/* QL:         moveq   #M184_err.ff,d0      say that the I2C is not working */
    moveq #M184_err.ff,d0
/* QL:         jmp     (a0)            go home */
    jmp (a0)
/* QL: M184_parm */
M184_parm:
/* QL:         lsl.w   #7,d2           shift any existing parameter data up */
    lsl.w #7,d2
/* QL:         or.b    d5,d2           put in next seven bits */
    or.b d5,d2
/* QL: M184_new_cmd */
M184_new_cmd:
/* QL:         exg     a1,d3 */
    exg a1,d3
/* QL:         move.b  (a1)+,d5        get next command byte */
    move.b (a1)+,d5
/* QL:         exg     a1,d3 */
    exg a1,d3
/* QL:         bpl.s   M184_parm            if msb is clear, rest is 7 bits of parameter */
    bpl.s M184_parm
/* QL:         asl.b   #2,d5           check next two bits, 6=M184_special, 5=normal */
    asl.b #2,d5
/* QL:         bcs.l   M184_special         11xxxxxx - go do M184_special command sequence */
    bcs.w M184_special
/* QL:         bpl.s   M184_started         100xxxxx - no START sequence wanted */
    bpl.s M184_started
/* QL: * 101xxxxx - send START sequence plus device */
/* QL:         tst.b   (a3)         12 SDA high, assure that SCL is high */
    tst.b (a3)
/* QL:         rol.b   #3,d5        16 waste time */
    rol.b #3,d5
/* QL:         ror.b   #3,d5        16 waste time */
    ror.b #3,d5
/* QL:         tst.b   (a5)         12 SCL high, set SDA low for START */
    tst.b (a5)
/* QL:         move.b  d5,d6         8 take a copy of command to get w/r bit */
    move.b d5,d6
/* QL:         asl.b   #2,d6        14 put w/r = 0/1 into x */
    asl.b #2,d6
/* QL:         move.l  d2,d0         8 copy device */
    move.l d2,d0
/* QL:         swap    d0            8 get device number bits 7-1 */
    swap d0
/* QL:         tst.b   (a4)         12 SDA low, set SCL low */
    tst.b (a4)
/* QL:         tas     d0            8 set top bit for clever code */
    tas d0
/* QL:         addx.b  d0,d0         8 roll r/w into register, one to x */
    addx.b d0,d0
/* QL:         addx.b  d0,d0         8 roll first bit (bit 7) to x as d, one to lsb */
    addx.b d0,d0
/* QL: M184_devlp */
M184_devlp:
/* QL:         clr.w   d4            8 clear our data offset register */
    clr.w d4
/* QL:         roxl.b  #2,d4        14 set 0 for SDA low, 2 for SDA high */
    roxl.b #2,d4
/* QL:         tst.w   0(a4,d4.w)   22 SCL low, set SDA data, then SCL high */
    tst.w 0(a4,d4.w)
/* QL:         move.b  1(a4,d4.w),d6 22 SDA data, SCL high, verify data */
    move.b 1(a4,d4.w),d6
/* QL:         tst.b   0(a4,d4.w)   22 SDA data, set SCL low */
    tst.b 0(a4,d4.w)
/* QL:         bchg    d4,d6        12 toggle lsb if we were try to send a zero bit */
    bchg d4,d6
/* QL:         asr.b   #1,d6        12 peel out that bit */
    asr.b #1,d6
/* QL:         bcc.s   M184_err_ff   12 b18 if it's not set now, we have a problem!  */
    bcc.s M184_err_ff
/* QL:         add.b   d0,d0         8 fetch out next data bit */
    add.b d0,d0
/* QL:         bne.s   M184_devlp    12 b18 if this isn't our marker one going out, loop */
    bne.s M184_devlp
/* QL:         tst.w   (a2)         20 SCL low, set SDA high, then SCL high */
    tst.w (a2)
/* QL:         moveq   #1,d0         8 mask for lsb */
    moveq #1,d0
/* QL:         and.b   (a3),d0      12 sample SDAin */
    and.b (a3),d0
/* QL:         beq.s   M184_devok    12 b18 if we have an acknowledge, all is ok */
    beq.s M184_devok
/* QL:         moveq   #M184_err.nf,d0      say we didn't find the device */
    moveq #M184_err.nf,d0
/* QL: M184_stopit */
M184_stopit:
/* QL:         tst.b   (a2)         12 SDA high, set SCL low */
    tst.b (a2)
/* QL:         tst.b   (a4)         12 SCL low, set SDA low */
    tst.b (a4)
/* QL:         rol.b   #8,d0        26 waste some time */
    rol.b #8,d0
/* QL:         tst.b   (a5)         12 SDA low, set SCL high */
    tst.b (a5)
/* QL:         rol.b   #8,d0        26 waste some time */
    rol.b #8,d0
/* QL:         nop                   8 waste even more time (3 cycles to many) */
    nop 
/* QL:         tst.b   (a3)         12 SCL high, set SDA high: STOP */
    tst.b (a3)
/* QL:         tst.l   d0              make sure ccr is set */
    tst.l d0
/* QL:         jmp     (a0)            go home */
    jmp (a0)
/* QL: M184_devok */
M184_devok:
/* QL:         tst.b   (a2)         12 SDA is high, set SCL low */
    tst.b (a2)
/* QL: M184_started */
M184_started:
/* QL:         asl.b   #2,d5        14 roll out r/w and buffer to msb */
    asl.b #2,d5
/* QL:         bcs.l   M184_reader   12 b18 go do read sequence */
    bcs.w M184_reader
/* QL:         bmi.s   M184_writer   12 b18 if write from control buffer, we're ready */
    bmi.s M184_writer
/* QL:         exg     a1,d3         8 use data buffer instead of command buffer */
    exg a1,d3
/* QL:         bra.s   M184_writer      b18 go start writing */
    bra.s M184_writer
/* QL: M184_noack */
M184_noack:
/* QL:         moveq   #M184_err.te,d0      transmission error */
    moveq #M184_err.te,d0
/* QL:         add.b   d5,d5           did we swap control/data buffers */
    add.b d5,d5
/* QL:         bcs.s   M184_stopit          no, go set the ack error */
    bcs.s M184_stopit
/* QL:         exg     a1,d3           put back control and data pointers */
    exg a1,d3
/* QL:         bra.s   M184_stopit          go send a STOP */
    bra.s M184_stopit
/* QL: M184_wbllp */
M184_wbllp:
/* QL:         nop                   8 waste cycles to get timing right */
    nop 
/* QL:         tst.b   (a4)         12 SDA is low, put SCL low */
    tst.b (a4)
/* QL:         add.b   d6,d6         8 check next bit */
    add.b d6,d6
/* QL:         bpl.s   M184_wblow    12 b18 if writing zero, we're ready */
    bpl.s M184_wblow
/* QL:         cmp.w   (a2),a2      18 SCL is low, set SDA high, set SCL high (***) */
    cmp.w (a2),a2
/* QL:         dbra    d4,M184_wbhlp 26 b18 if more bits, go see about them */
    dbra d4,M184_wbhlp
/* QL:         tst.b   (a2)         12 SDA is high, put SCL low */
    tst.b (a2)
/* QL:         nop                   8 waste cycles to get timing right */
    nop 
/* QL:         bra.s   M184_chkack      b18 go check acknowledge */
    bra.s M184_chkack
/* QL: M184_wbhigh */
M184_wbhigh:
/* QL:         tst.b   (a3)         12 SDA is high, set SCL high */
    tst.b (a3)
/* QL:         dbra    d4,M184_wbhlp 26 b18 if more bits, go see about them */
    dbra d4,M184_wbhlp
/* QL:         tst.b   (a2)         12 SDA is high, put SCL low */
    tst.b (a2)
/* QL:         nop                   8 waste cycles to get timing right */
    nop 
/* QL:         bra.s   M184_chkack      b18 go check acknowledge */
    bra.s M184_chkack
/* QL: M184_wbhlp */
M184_wbhlp:
/* QL:         nop                   8 waste cycles to get timing right */
    nop 
/* QL:         tst.b   (a2)         12 SDA is high, put SCL low */
    tst.b (a2)
/* QL:         add.b   d6,d6         8 check next bit */
    add.b d6,d6
/* QL:         bmi.s   M184_wbhigh   12 b18 if writing one, we're ready */
    bmi.s M184_wbhigh
/* QL:         cmp.w   (a4),a4      18 SCL is low, set SDA low, set SCL high (***) */
    cmp.w (a4),a4
/* QL:         tst.b   (a5)         12 SDA is low, set SCL high */
    tst.b (a5)
/* QL:         dbra    d4,M184_wbllp 26 b18 if more bits, go see about them */
    dbra d4,M184_wbllp
/* QL:         tst.b   (a4)         12 SDA is low, set SCL low */
    tst.b (a4)
/* QL:         tst.b   (a2)         12 SCL is low, set SDA high */
    tst.b (a2)
/* QL:         asl.l   #1,d0        14 waste cycles to get timing right */
    asl.l #1,d0
/* QL: M184_chkack */
M184_chkack:
/* QL:         move.b  (a3),d0      12 set SCL high and sample at the same time */
    move.b (a3),d0
/* QL:         asr.l   #1,d0        14 check if the ack was there (squeeze 2 cycles) */
    asr.l #1,d0
/* QL:         bcs.s   M184_noack    12 b18 argh! go zap this transfer */
    bcs.s M184_noack
/* QL:         tst.b   (a2)         12 so, all is ok, drop SCL */
    tst.b (a2)
/* QL: M184_writer */
M184_writer:
/* QL:         dbra    d2,M184_wbyte 26 b18 see if we've got any more to do */
    dbra d2,M184_wbyte
/* QL:         bra.s   M184_wrdone */
    bra.s M184_wrdone
/* QL: M184_wbyte */
M184_wbyte:
/* QL:         moveq   #8-1,d4       8 set for another 8 bits */
    moveq #(8-1),d4
/* QL:         move.b  (a1)+,d6     12 get the next byte */
    move.b (a1)+,d6
/* QL:         bmi.s   M184_wbhigh      b18 if it has msb set, we're ready */
    bmi.s M184_wbhigh
/* QL:         tst.b   (a4)         12 SCL is low, set SDA low */
    tst.b (a4)
/* QL: M184_wblow */
M184_wblow:
/* QL:         tst.b   (a5)         12 SDA is low, set SCL high */
    tst.b (a5)
/* QL:         dbra    d4,M184_wbllp 26 b18 if more bits, go see about them */
    dbra d4,M184_wbllp
/* QL:         tst.b   (a4)         12 SDA is low, set SCL low */
    tst.b (a4)
/* QL:         tst.b   (a2)         12 SCL is low, set SDA high */
    tst.b (a2)
/* QL:         asl.l   #1,d0        14 waste cycles to get timing right */
    asl.l #1,d0
/* QL:         move.b  (a3),d0      12 set SCL high and sample at the same time */
    move.b (a3),d0
/* QL:         asr.l   #1,d0        14 check if the ack was there (squeeze 2 cycles) */
    asr.l #1,d0
/* QL:         bcs.s   M184_noack    12 b18 argh! go zap this transfer */
    bcs.s M184_noack
/* QL:         tst.b   (a2)         12 so, all is ok, drop SCL */
    tst.b (a2)
/* QL:         dbra    d2,M184_wbyte 26 b18 see if we've got any more to do */
    dbra d2,M184_wbyte
/* QL: M184_wrdone */
M184_wrdone:
/* QL:         add.b   d5,d5           did we swap control/data buffers */
    add.b d5,d5
/* QL:         bcs.s   M184_chkstop         no, skip swap */
    bcs.s M184_chkstop
/* QL:         exg     a1,d3           put back control and data pointers */
    exg a1,d3
/* QL: M184_chkstop */
M184_chkstop:
/* QL:         add.b   d5,d5         8 do we want to send a STOP */
    add.b d5,d5
/* QL:         bne.s   M184_err_bp   12 b18 object to spare bit(s) set */
    bne.s M184_err_bp
/* QL:         bcc.s   M184_clrparm  12 b18 nope, leave SDA high and get next command */
    bcc.s M184_clrparm
/* QL:         tst.b   (a4)         12 send SDA low */
    tst.b (a4)
/* QL:         rol.b   #8,d0        26 waste some time */
    rol.b #8,d0
/* QL:         tst.b   (a5)         12 send SCL high */
    tst.b (a5)
/* QL:         moveq   #7,d0         8 */
    moveq #7,d0
/* QL:         lsr.b   d0,d0        24 waste some time (about 1 cycle too much) */
    lsr.b d0,d0
/* QL:         tst.b   (a3)         12 send SDA high for STOP */
    tst.b (a3)
/* QL: M184_clrparm */
M184_clrparm:
/* QL:         clr.w   d2              reset parameter */
    clr.w d2
/* QL:         bra.l   M184_new_cmd         go get next command */
    bra.w M184_new_cmd
/* QL: * Read sequence */
/* QL: M184_rdlp */
M184_rdlp:
/* QL:         move.b  (a3),d6      12 SDA high, set SCL high and sample SDAin */
    move.b (a3),d6
/* QL:         asl.b   #1,d6        12 juggle to get timing right */
    asl.b #1,d6
/* QL:         asr.b   #2,d6        14 get SDAin to x */
    asr.b #2,d6
/* QL:         tst.b   (a2)         12 SDA high, set SCL low */
    tst.b (a2)
/* QL:         addx.b  d0,d0         8 roll SDAin into register */
    addx.b d0,d0
/* QL:         bcc.s   M184_rdlp     12 b18 if not at marker yet, loop */
    bcc.s M184_rdlp
/* QL:         cmp.w   (a4),a4      18 SCL low, set SDA low, set SCL high (***) */
    cmp.w (a4),a4
/* QL:         tst.b   d5            8 check if we are reading to register */
    tst.b d5
/* QL:         bpl.s   M184_rreg     12 b18 if so, we can afford to be slower, max 4 byte! */
    bpl.s M184_rreg
/* QL:         move.b  d0,(a1)+    >12 store this byte (6+ cycles slow) */
    move.b d0,(a1)+
/* QL: M184_rrent */
M184_rrent:
/* QL:         tst.b   (a4)         12 SDA low, set SCL low */
    tst.b (a4)
/* QL:         tst.b   (a2)         12 SCL low, set SDA high */
    tst.b (a2)
/* QL: M184_reader */
M184_reader:
/* QL:         moveq   #1,d0         8 set marker bit */
    moveq #1,d0
/* QL:         dbra    d2,M184_rdlp  26 b18 */
    dbra d2,M184_rdlp
/* QL:         bclr    #5,d5        22 check acknowledge bit */
    bclr #5,d5
/* QL:         bne.s   M184_acklast  12 b18 final byte acknowledged, STOP not permitted */
    bne.s M184_acklast
/* QL: M184_rnlp */
M184_rnlp:
/* QL:         move.b  (a3),d6      12 SDA high, set SCL high and sample SDAin */
    move.b (a3),d6
/* QL:         asl.b   #1,d6        12 juggle to get timing right */
    asl.b #1,d6
/* QL:         asr.b   #2,d6        14 get SDAin to x */
    asr.b #2,d6
/* QL:         tst.b   (a2)         12 SDA high, set SCL low */
    tst.b (a2)
/* QL:         addx.b  d0,d0         8 roll SDAin into register */
    addx.b d0,d0
/* QL:         bcc.s   M184_rnlp     12 b18 if not at marker yet, loop */
    bcc.s M184_rnlp
/* QL:         nop                   8 lose 2 too many cycles */
    nop 
/* QL:         tst.b   (a3)         12 SDA high, set SCL high for no ack */
    tst.b (a3)
/* QL:         add.b   d5,d5         8 check if we are reading to register */
    add.b d5,d5
/* QL:         bcc.s   M184_rnreg    12 b18 if so, go roll it in */
    bcc.s M184_rnreg
/* QL:         move.b  d0,(a1)+    >12 store this byte */
    move.b d0,(a1)+
/* QL: M184_rnrent */
M184_rnrent:
/* QL:         tst.b   (a2)         12 SDA high, set SCL low */
    tst.b (a2)
/* QL:         bra.s   M184_chkstop     b18 go check for STOP required */
    bra.s M184_chkstop
/* QL: M184_acklast */
M184_acklast:
/* QL:         add.b   d5,d5           clear off the buffer bit when last byte ack'ed */
    add.b d5,d5
/* QL:         beq.s   M184_clrparm         should be all zero now */
    beq.s M184_clrparm
/* QL: M184_err_bp */
M184_err_bp:
/* QL:         moveq   #M184_err.bp,d0 */
    moveq #M184_err.bp,d0
/* QL:         jmp     (a0) */
    jmp (a0)
/* QL: M184_rreg */
M184_rreg:
/* QL:         rol.l   #8,d1 */
    rol.l #8,d1
/* QL:         move.b  d0,d1 */
    move.b d0,d1
/* QL:         bra.s   M184_rrent */
    bra.s M184_rrent
/* QL: M184_rnreg */
M184_rnreg:
/* QL:         rol.l   #8,d1 */
    rol.l #8,d1
/* QL:         move.b  d0,d1 */
    move.b d0,d1
/* QL:         bra.s   M184_rnrent */
    bra.s M184_rnrent
/* QL: *       |  1  |  1  |  g  |  v  |  d  |  c  |  1  |  q  | */
/* QL: M184_special */
M184_special:
/* QL:         bmi.s   M184_grpok           skip if g (group) bit is already set */
    bmi.s M184_grpok
/* QL:         swap    d2              set device group data */
    swap d2
/* QL:         clr.w   d2              zero the parameter value */
    clr.w d2
/* QL: M184_grpok */
M184_grpok:
/* QL:         moveq   #11,d0          clear msb's and shift count */
    moveq #11,d0
/* QL:         asl.b   #2,d5           check v bit */
    asl.b #2,d5
/* QL:         bcs.s   M184_verok           skip if v (validate) bit is set */
    bcs.s M184_verok
/* QL:         st      d6              we have all ones, and x=0 */
    st d6
/* QL: M184_verlp */
M184_verlp:
/* QL:         tst.b   (a2)         12 SDA high after 1st, set SCL low */
    tst.b (a2)
/* QL:         ror.b   #8,d6        26 */
    ror.b #8,d6
/* QL:         tst.b   (a3)         12 SDA high, set SCL high = nak */
    tst.b (a3)
/* QL:         rol.b   d0,d6        32 */
    rol.b d0,d6
/* QL:         tst.b   (a5)         12 SCL high, set SDA low = START */
    tst.b (a5)
/* QL:         ror.b   d0,d6        32 */
    ror.b d0,d6
/* QL:         tst.b   (a3)         12 SCL high, set SDA high = STOP */
    tst.b (a3)
/* QL:         roxl.b  #2,d6        14 */
    roxl.b #2,d6
/* QL:         bcs.s   M184_verlp    12 b18 wait for x back at start (exec code 9 times) */
    bcs.s M184_verlp
/* QL: M184_verok */
M184_verok:
/* QL:         move.b  d5,d0 */
    move.b d5,d0
/* QL:         lsr.b   #6,d0           put d/c bits into register */
    lsr.b #6,d0
/* QL:         bcc.s   M184_err_bp          object to spare bit zero */
    bcc.s M184_err_bp
/* QL:         tst.b   0(a4,d0.w)      set SDA/SCL as requested */
    tst.b 0(a4,d0.w)
/* QL:         lsl.b   #4,d5 */
    lsl.b #4,d5
/* QL:         bcc.l   M184_new_cmd */
    bcc.w M184_new_cmd
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         jmp     (a0)            return ok */
    jmp (a0)
/* QL:         vect4000 M184_ii_drive,M184_ii_raw */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ ii$drive,(M184_ii_drive-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ ii$raw,(M184_ii_raw-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
