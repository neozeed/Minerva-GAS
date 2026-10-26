/* ROM section ii_clock */
.balign 2,0
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- seconds since dot */
/* QL: * a0 -i  - system variables base */
/* QL: * a6 -ip - basic variables base */
/* QL: * d2-d4/d6/a1-a4 destroyed */
/* QL: ii_clock */
ii_clock:
/* QL:         move.l  M183_sv_free(a0),a1  set buffer pointer */
    move.l M183_sv_free(a0),a1
/* QL:         move.l  a1,a4           duplicate start of transfer */
    move.l a1,a4
/* QL:         lea     M183_cmd,a3          point to command sequence and masks */
    lea M183_cmd(pc),a3
/* QL:         bsr.s   M183_ii_drive        try to get the I2C M183_clock M183_stuff */
    bsr.s M183_ii_drive
/* QL:         move.l  a1,a2           top of M183_clock data */
    move.l a1,a2
/* QL:         beq.s   M183_more            if it works, great (1st byte is junk) */
    beq.s M183_more
/* QL:         moveq   #M183_mt.rclck,d0    fall back to internal M183_clock read */
    moveq #M183_mt.rclck,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         rts */
    rts 
/* QL: M183_ii_drive */
M183_ii_drive:
/* QL:         move.w  M183_ii.drive,a2 */
    move.w M183_ii.drive,a2
/* QL:         jmp     $4000(a2) */
    jmp 0x4000(a2)
/* QL: M183_more */
M183_more:
/* QL:         and.b   -(a2),d0        use mask byte to junk msd flags bits */
    and.b -(a2),d0
/* QL:         moveq   #15,d1          mask for lsd and msbs all zero */
    moveq #15,d1
/* QL:         and.b   (a2),d1         get lsd */
    and.b (a2),d1
/* QL:         lsr.b   #1,d0 */
    lsr.b #1,d0
/* QL:         add.b   d0,d1           lsd + msd/2 */
    add.b d0,d1
/* QL:         lsr.b   #2,d0 */
    lsr.b #2,d0
/* QL:         add.b   d0,d1           lsd + msd*16/2 + msd*16/8 = lsd + 10*msd */
    add.b d0,d1
/* QL:         move.l  d1,(a1)+        push onto stack */
    move.l d1,(a1)+
/* QL:         move.b  (a3)+,d0        get next mask byte */
    move.b (a3)+,d0
/* QL:         bne.s   M183_more            if not ending zero, keep on going */
    bne.s M183_more
/* QL: * This bit copes with 12/24 hour + am/pm */
/* QL:         move.l  (a2)+,d3        ss:mm:hh dd, just want 2 lsbs of hh */
    move.l (a2)+,d3
/* QL:         add.w   d3,d3           check them */
    add.w d3,d3
/* QL:         bcc.s   M183_notpm           skip if 24hr */
    bcc.s M183_notpm
/* QL:         bpl.s   M183_notpm           skip if 12hr and am */
    bpl.s M183_notpm
/* QL:         add.b   #12,-9(a1)      add 12 to hours for 12hr and pm */
    add.b #(12&255),(-9)(a1)
/* QL: M183_notpm */
M183_notpm:
/* QL: * This bit clicks the year by using a copy of the tens of month at the year lsb */
/* QL:         movem.l (a4)+,d3-d4/d6  take up id, junk and year+flag+rebooter */
    movem.l (a4)+,d3-d4/d6
/* QL:         swap    d6              swap to rebooter and year+flag */
    swap d6
/* QL:         move.b  (a2),d1         get bcd month again */
    move.b (a2),d1
/* QL:         lsr.b   #4,d1           move ten months to lsb */
    lsr.b #4,d1
/* QL:         eor.b   d6,d1           flip with ten month flag after lsb of year */
    eor.b d6,d1
/* QL:         asr.b   #1,d1           move to x reg */
    asr.b #1,d1
/* QL:         addx.w  d0,d6           if they differed, increment year+flag */
    addx.w d0,d6
/* QL:         move.l  d6,(a1)         put them in the buffer */
    move.l d6,(a1)
/* QL:         move.l  a1,d4           save stack top for later */
    move.l a1,d4
/* QL:         lsr.w   #1,d6           lose the 10 month flag now */
    lsr.w #1,d6
/* QL:         bsr.s   M183_ii_drive        slot back in the lsw of boot and the year+flag */
    bsr.s M183_ii_drive
/* QL:         cmp.l   M183_sp_id(sp),d3    check QDOS id */
    cmp.l M183_sp_id(sp),d3
/* QL:         bne.s   M183_clock           no match, so don't trust the ram layout */
    bne.s M183_clock
/* QL:         moveq   #$c0-256,d3     left arrow key */
    moveq #(0xc0-256),d3
/* QL:         move.b  d3,M183_sp_flag(sp)  show them I2C is around */
    move.b d3,M183_sp_flag(sp)
/* QL:         move.l  M183_sv_keyq(a0),a2  get #0's key queue */
    move.l M183_sv_keyq(a0),a2
/* QL:         move.w  M183_io.qtest,a3 */
    move.w M183_io.qtest,a3
/* QL:         jsr     (a3)            see what character is present */
    jsr (a3)
/* QL:         cmp.b   d1,d3 */
    cmp.b d1,d3
/* QL:         beq.s   M183_clock           if left arrow, they are avoiding I2C */
    beq.s M183_clock
/* QL:         move.w  (a4)+,M183_sp_rom(sp) set ROM inhibit word */
    move.w (a4)+,M183_sp_rom(sp)
/* QL:         move.b  (a4)+,M183_sv_netnr(a0) set network address */
    move.b (a4)+,M183_sv_netnr(a0)
/* QL:         move.l  M183_sv_chtop(a0),a0 get system extension address */
    move.l M183_sv_chtop(a0),a0
/* QL:         move.b  (a4)+,M183_sx_toe(a0) set turn off enhancements flag */
    move.b (a4)+,M183_sx_toe(a0)
/* QL:         move.b  (a4),M183_bv_toe(a6) set basic tokenisation flag */
    move.b (a4),M183_bv_toe(a6)
/* QL: * Two spare bytes */
/* QL:         move.l  (a4)+,d3        get stuffer length */
    move.l (a4)+,d3
/* QL:         move.w  M183_io.qin,a1 */
    move.w M183_io.qin,a1
/* QL:         bra.s   M183_stent */
    bra.s M183_stent
/* QL: M183_stuff */
M183_stuff:
/* QL:         move.b  (a4)+,d1 */
    move.b (a4)+,d1
/* QL:         jsr     (a1)            put byte into keyboard queue */
    jsr (a1)
/* QL: M183_stent */
M183_stent:
/* QL:         subq.b  #1,d3 */
    subq.b #1,d3
/* QL:         bpl.s   M183_stuff           allow max 128 stuffer chars */
    bpl.s M183_stuff
/* QL: M183_clock */
M183_clock:
/* QL:         move.w  d6,d1           we kept the year and msw d1 is zero */
    move.w d6,d1
/* QL:         move.l  d4,a1           reload M183_clock data stack pointer */
    move.l d4,a1
/* QL:         sub.l   a6,a1           set rel a6 pointer to 5 longs */
    sub.l a6,a1
/* QL:         jsr     bf_datez(pc)    go convert year and the rest to seconds-dot */
    jsr bf_datez(pc)
/* QL:         moveq   #M183_mt.sclck,d0    now set the internal M183_clock with it all */
    moveq #M183_mt.sclck,d0
/* QL:         trap    #1              read or set M183_clock */
    trap #1
/* QL:         rts */
    rts 
/* QL: * Command sequences: i/o 10srbpa0, special 11gvdc1q */
/* QL: M183_cmd */
M183_cmd:
/* QL:         dc.b    0,$a0/2,%11011110       set device */
M183_dc_anchor_1486:
.byte (0)&255
.byte ((0xa0/2))&255
.byte (0b11011110)&255
/* QL:         dc.b    1,%10100000,16          start, write address of id word */
M183_dc_anchor_1491:
.byte (1)&255
.byte (0b10100000)&255
.byte (16)&255
/* QL:         dc.b    1,128-16+8-1,%10111100  start, read most of ram, stop */
M183_dc_anchor_1496:
.byte (1)&255
.byte ((((128-16)+8)-1))&255
.byte (0b10111100)&255
/* QL:         dc.b    $ff                     finish */
M183_dc_anchor_1501:
.byte (0xff)&255
/* QL:         dc.b    $10,$30,$30,$70,$70,0   masks for mm/dd hh:mm:ss & stop */
M183_dc_anchor_1504:
.byte (0x10)&255
.byte (0x30)&255
.byte (0x30)&255
.byte (0x70)&255
.byte (0x70)&255
.byte (0)&255
/* QL:         dc.b    1,%10100000,22          start, write address of lsw of boot */
M183_dc_anchor_1512:
.byte (1)&255
.byte (0b10100000)&255
.byte (22)&255
/* QL:         dc.b    4,%10001100             write boot/year+flag from buffer, stop */
M183_dc_anchor_1517:
.byte (4)&255
.byte (0b10001100)&255
/* QL:         dc.b    $ff                     finish */
M183_dc_anchor_1521:
.byte (0xff)&255
/* QL:         end */
