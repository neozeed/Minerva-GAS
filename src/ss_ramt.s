/* ROM section ss_ramt */
.balign 2,0
/* QL: * The M1_logo is stored as a word (or rather, two bytes) flagging which bytes are */
/* QL: * changing from the row above. This always has bit 1 set, enabling it to double */
/* QL: * up as the loop count of 14 bytes per row as it is shifted left.  */
/* QL: M1_logo */
M1_logo:
/* QL:  dc.b $60,$02,$08,$02 */
M1_dc_anchor_275:
.byte (0x60)&255
.byte (0x02)&255
.byte (0x08)&255
.byte (0x02)&255
/* QL:  dc.b $60,$02,$1c,$07 */
M1_dc_anchor_281:
.byte (0x60)&255
.byte (0x02)&255
.byte (0x1c)&255
.byte (0x07)&255
/* QL:  dc.b $60,$02,$3e,$0f */
M1_dc_anchor_287:
.byte (0x60)&255
.byte (0x02)&255
.byte (0x3e)&255
.byte (0x0f)&255
/* QL:  dc.b $10,$02,$80 */
M1_dc_anchor_293:
.byte (0x10)&255
.byte (0x02)&255
.byte (0x80)&255
/* QL:  dc.b $60,$02,$7f,$1f */
M1_dc_anchor_298:
.byte (0x60)&255
.byte (0x02)&255
.byte (0x7f)&255
.byte (0x1f)&255
/* QL:  dc.b $1f,$fa,$8f,$ff,$f1,$ff,$ff,$ff,$ff,$ff,$ff,$c0 */
M1_dc_anchor_304:
.byte (0x1f)&255
.byte (0xfa)&255
.byte (0x8f)&255
.byte (0xff)&255
.byte (0xf1)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xc0)&255
/* QL:  dc.b $74,$0a,$ff,$bf,$cf,$f3,$e0 */
M1_dc_anchor_318:
.byte (0x74)&255
.byte (0x0a)&255
.byte (0xff)&255
.byte (0xbf)&255
.byte (0xcf)&255
.byte (0xf3)&255
.byte (0xe0)&255
/* QL:  dc.b $14,$02,$c7,$e3 */
M1_dc_anchor_327:
.byte (0x14)&255
.byte (0x02)&255
.byte (0xc7)&255
.byte (0xe3)&255
/* QL:  dc.b $ff,$fa,$01,$f3,$fd,$c0,$00,$00,$00,$00,$00,$00,$00,$00,$00 */
M1_dc_anchor_333:
.byte (0xff)&255
.byte (0xfa)&255
.byte (0x01)&255
.byte (0xf3)&255
.byte (0xfd)&255
.byte (0xc0)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
/* QL:  dc.b $20,$02,$f9 */
M1_dc_anchor_350:
.byte (0x20)&255
.byte (0x02)&255
.byte (0xf9)&255
/* QL:  dc.b $ff,$fa,$03,$e1,$f1,$e1,$ff,$81,$f8,$7f,$f0,$ff,$18,$07,$f8 */
M1_dc_anchor_355:
.byte (0xff)&255
.byte (0xfa)&255
.byte (0x03)&255
.byte (0xe1)&255
.byte (0xf1)&255
.byte (0xe1)&255
.byte (0xff)&255
.byte (0x81)&255
.byte (0xf8)&255
.byte (0x7f)&255
.byte (0xf0)&255
.byte (0xff)&255
.byte (0x18)&255
.byte (0x07)&255
.byte (0xf8)&255
/* QL:  dc.b $07,$ba,$c3,$fc,$ff,$f9,$38,$0f,$fc */
M1_dc_anchor_372:
.byte (0x07)&255
.byte (0xba)&255
.byte (0xc3)&255
.byte (0xfc)&255
.byte (0xff)&255
.byte (0xf9)&255
.byte (0x38)&255
.byte (0x0f)&255
.byte (0xfc)&255
/* QL:  dc.b $f4,$ba,$07,$c0,$e0,$e0,$c7,$fb,$3c,$1f,$fe */
M1_dc_anchor_383:
.byte (0xf4)&255
.byte (0xba)&255
.byte (0x07)&255
.byte (0xc0)&255
.byte (0xe0)&255
.byte (0xe0)&255
.byte (0xc7)&255
.byte (0xfb)&255
.byte (0x3c)&255
.byte (0x1f)&255
.byte (0xfe)&255
/* QL:  dc.b $3b,$da,$40,$f0,$03,$9e,$f1,$f3,$c0,$1e,$1e */
M1_dc_anchor_396:
.byte (0x3b)&255
.byte (0xda)&255
.byte (0x40)&255
.byte (0xf0)&255
.byte (0x03)&255
.byte (0x9e)&255
.byte (0xf1)&255
.byte (0xf3)&255
.byte (0xc0)&255
.byte (0x1e)&255
.byte (0x1e)&255
/* QL:  dc.b $e7,$fa,$0f,$80,$00,$8f,$1e,$7b,$c7,$80,$1c,$1c,$0f */
M1_dc_anchor_409:
.byte (0xe7)&255
.byte (0xfa)&255
.byte (0x0f)&255
.byte (0x80)&255
.byte (0x00)&255
.byte (0x8f)&255
.byte (0x1e)&255
.byte (0x7b)&255
.byte (0xc7)&255
.byte (0x80)&255
.byte (0x1c)&255
.byte (0x1c)&255
.byte (0x0f)&255
/* QL:  dc.b $1b,$8a,$70,$07,$0e,$7f,$87,$1f */
M1_dc_anchor_424:
.byte (0x1b)&255
.byte (0x8a)&255
.byte (0x70)&255
.byte (0x07)&255
.byte (0x0e)&255
.byte (0x7f)&255
.byte (0x87)&255
.byte (0x1f)&255
/* QL:  dc.b $d5,$fe,$1f,$00,$78,$8e,$3f,$0f,$00,$1e,$3c,$3f,$80 */
M1_dc_anchor_434:
.byte (0xd5)&255
.byte (0xfe)&255
.byte (0x1f)&255
.byte (0x00)&255
.byte (0x78)&255
.byte (0x8e)&255
.byte (0x3f)&255
.byte (0x0f)&255
.byte (0x00)&255
.byte (0x1e)&255
.byte (0x3c)&255
.byte (0x3f)&255
.byte (0x80)&255
/* QL:  dc.b $07,$0a,$1e,$0f,$3c,$7f */
M1_dc_anchor_449:
.byte (0x07)&255
.byte (0x0a)&255
.byte (0x1e)&255
.byte (0x0f)&255
.byte (0x3c)&255
.byte (0x7f)&255
/* QL:  dc.b $98,$be,$3e,$38,$0f,$1e,$0e,$38,$7b,$c0 */
M1_dc_anchor_457:
.byte (0x98)&255
.byte (0xbe)&255
.byte (0x3e)&255
.byte (0x38)&255
.byte (0x0f)&255
.byte (0x1e)&255
.byte (0x0e)&255
.byte (0x38)&255
.byte (0x7b)&255
.byte (0xc0)&255
/* QL:  dc.b $17,$3a,$3c,$3c,$07,$1e,$0f,$78,$f1 */
M1_dc_anchor_469:
.byte (0x17)&255
.byte (0x3a)&255
.byte (0x3c)&255
.byte (0x3c)&255
.byte (0x07)&255
.byte (0x1e)&255
.byte (0x0f)&255
.byte (0x78)&255
.byte (0xf1)&255
/* QL:  dc.b $88,$96,$7c,$0e,$3c,$79,$e0 */
M1_dc_anchor_480:
.byte (0x88)&255
.byte (0x96)&255
.byte (0x7c)&255
.byte (0x0e)&255
.byte (0x3c)&255
.byte (0x79)&255
.byte (0xe0)&255
/* QL:  dc.b $1d,$be,$1c,$1e,$38,$8f,$38,$07,$73,$ff,$f0 */
M1_dc_anchor_489:
.byte (0x1d)&255
.byte (0xbe)&255
.byte (0x1c)&255
.byte (0x1e)&255
.byte (0x38)&255
.byte (0x8f)&255
.byte (0x38)&255
.byte (0x07)&255
.byte (0x73)&255
.byte (0xff)&255
.byte (0xf0)&255
/* QL:  dc.b $94,$92,$f8,$1e,$78,$f8,$f3 */
M1_dc_anchor_502:
.byte (0x94)&255
.byte (0x92)&255
.byte (0xf8)&255
.byte (0x1e)&255
.byte (0x78)&255
.byte (0xf8)&255
.byte (0xf3)&255
/* QL:  dc.b $0b,$96,$1c,$03,$83,$e0,$f1,$e0 */
M1_dc_anchor_511:
.byte (0x0b)&255
.byte (0x96)&255
.byte (0x1c)&255
.byte (0x03)&255
.byte (0x83)&255
.byte (0xe0)&255
.byte (0xf1)&255
.byte (0xe0)&255
/* QL:  dc.b $97,$be,$f0,$0e,$f0,$00,$00,$00,$03,$e0,$00,$00 */
M1_dc_anchor_521:
.byte (0x97)&255
.byte (0xbe)&255
.byte (0xf0)&255
.byte (0x0e)&255
.byte (0xf0)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x00)&255
.byte (0x03)&255
.byte (0xe0)&255
.byte (0x00)&255
.byte (0x00)&255
/* QL:  dc.b $88,$02,$70,$00 */
M1_dc_anchor_535:
.byte (0x88)&255
.byte (0x02)&255
.byte (0x70)&255
.byte (0x00)&255
/* QL:  dc.b $94,$02,$00,$0f,$e0 */
M1_dc_anchor_541:
.byte (0x94)&255
.byte (0x02)&255
.byte (0x00)&255
.byte (0x0f)&255
.byte (0xe0)&255
/* QL:  dc.b $04,$02,$00 */
M1_dc_anchor_548:
.byte (0x04)&255
.byte (0x02)&255
.byte (0x00)&255
/* QL:  dc.b $10,$32,$07,$01,$c0 */
M1_dc_anchor_553:
.byte (0x10)&255
.byte (0x32)&255
.byte (0x07)&255
.byte (0x01)&255
.byte (0xc0)&255
/* QL:  dc.b $0f,$fe,$8f,$ff,$ff,$ff,$ff,$ff,$f9,$cf,$ff,$fc */
M1_dc_anchor_560:
.byte (0x0f)&255
.byte (0xfe)&255
.byte (0x8f)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xff)&255
.byte (0xf9)&255
.byte (0xcf)&255
.byte (0xff)&255
.byte (0xfc)&255
/* QL:  dc.b $00,$36,$fc,$9f,$fe */
M1_dc_anchor_574:
.byte (0x00)&255
.byte (0x36)&255
.byte (0xfc)&255
.byte (0x9f)&255
.byte (0xfe)&255
/* QL:  dc.b $ff,$00           terminate with a mask word with a zero lsb */
M1_dc_anchor_581:
.byte (0xff)&255
.byte (0x00)&255
/* QL:  ds.w 0 allign to word boundary */
.balign 2,0
/* QL: M1_l_len   equ     14*8 number of pixels per row */
.equ M1_l_len,(14*8)
/* QL: M1_l_row   equ     32 number of rows  */
.equ M1_l_row,32
/* QL: M1_l_h     equ     50 allow height to match copyright message window */
.equ M1_l_h,50
/* QL: M1_l_w     equ     (M1_l_h*M1_l_len+M1_l_row/2)/M1_l_row pad width up proportionate to height */
.equ M1_l_w,(((M1_l_h*M1_l_len)+(M1_l_row/2))/M1_l_row)
/* QL: M1_l_x     equ     (512+448)/2-M1_l_w */
.equ M1_l_x,(((512+448)/2)-M1_l_w)
/* QL: M1_l_y     equ     256-M1_l_h */
.equ M1_l_y,(256-M1_l_h)
/* QL: M1_l_off   equ     (M1_l_x*2+M1_l_w-M1_l_len+8)/(8*2)*2 offset to first byte in line */
.equ M1_l_off,((((((M1_l_x*2)+M1_l_w)-M1_l_len)+8)/(8*2))*2)
/* QL: M1_l_1st   equ     M1_l_y+(M1_l_h-M1_l_row+1)/2 first display line */
.equ M1_l_1st,(M1_l_y+(((M1_l_h-M1_l_row)+1)/2))
/* QL: M1_nextword */
M1_nextword:
/* QL:         move.l  -(a1),d2        fetch a random longword from rom */
    move.l -(a1),d2
/* QL:         jmp     (a2)            go do appropriate bit */
    jmp (a2)
/* QL: M1_l_loop */
M1_l_loop:
/* QL:         move.b  (a3)+,-1(a0)    if carry was set, we patch in our new byte */
    move.b (a3)+,(-1)(a0)
/* QL: M1_l_copy */
M1_l_copy:
/* QL:         move.w  -M1_sl(a0),(a0)+   repeat word from row above */
    move.w (-M1_sl)(a0),(a0)+
/* QL:         add.w   d7,d7           check our mask */
    add.w d7,d7
/* QL:         bcc.s   M1_l_copy          if carry clear, we have no new byte for here */
    bcc.s M1_l_copy
/* QL:         bne.s   M1_l_loop          if it's zero, we just overshot, but so what! */
    bne.s M1_l_loop
/* QL: M1_do_2nd */
M1_do_2nd:
/* QL:         btst    d0,d5           is this a quick reset? */
    btst d0,d5
/* QL:         beq.s   M1_chk_rnd         no, keep checking randoms */
    beq.s M1_chk_rnd
/* QL:         move.l  d0,(a4)+        just wipe memory for quick reset */
    move.l d0,(a4)+
/* QL: * Come here on second pass, until we've got past the M1_logo */
/* QL: M1_do_logo */
M1_do_logo:
/* QL:         move.l  a4,d3 */
    move.l a4,d3
/* QL:         cmp.w   #(M1_l_1st+1)<<M1_sls,d3 at the M1_logo line + 1 yet? */
    cmp.w #((M1_l_1st+1)<<M1_sls),d3
/* QL:         bcs.s   M1_do_2nd          no, carry on */
    bcs.s M1_do_2nd
/* QL:         assert  7,M1_sls */
/* original assertion: 7,M1_sls */
/* QL:         add.b   d3,d3           are we at the start of a line */
    add.b d3,d3
/* QL:         bne.s   M1_do_2nd          no, continue 2nd pass */
    bne.s M1_do_2nd
/* QL:         lea     M1_l_off-M1_sl(a4),a0 pointer to left hand edge above */
    lea (M1_l_off-M1_sl)(a4),a0
/* QL:         move.b  (a3)+,d7 */
    move.b (a3)+,d7
/* QL:         asl.w   #8,d7           pick up the mask word (not on a word bdry!) */
    asl.w #8,d7
/* QL:         move.b  (a3)+,d7        (note - d7.b=0 also marks end of 2nd pass) */
    move.b (a3)+,d7
/* QL:         bne.s   M1_l_copy          all real mask words have bit 1 set */
    bne.s M1_l_copy
/* QL:         btst    d0,d5           is this a quick reset? */
    btst d0,d5
/* QL:         bne.l   M1_qfin            yes, just go tidy last few bits */
    bne.w M1_qfin
/* QL:         lea     M1_chk_rnd,a2      change to full 2nd pass */
    lea M1_chk_rnd(pc),a2
/* QL: M1_chk_rnd */
M1_chk_rnd:
/* QL:         cmp.l   (a4),d2         check the random word */
    cmp.l (a4),d2
/* QL:         bne.s   M1_bad_rand        if it fails */
    bne.s M1_bad_rand
/* QL:         move.l  d0,(a4)         write zeroes to ram */
    move.l d0,(a4)
/* QL:         tst.l   (a4)+           check them */
    tst.l (a4)+
/* QL:         dbne    d6,M1_nextword     loop */
    dbne d6,M1_nextword
/* QL:         move.l  d0,a0 */
    move.l d0,a0
/* QL:         bra.s   M1_chk_fail */
    bra.s M1_chk_fail
/* QL: M1_do_1st */
M1_do_1st:
/* QL: * First time round, write ones, read ones, write random and check */
/* QL:         move.l  d7,(a4)         write ones to ram */
    move.l d7,(a4)
/* QL:         cmp.l   (a4),d7         check them */
    cmp.l (a4),d7
/* QL:         bne.s   M1_hangup */
    bne.s M1_hangup
/* QL:         move.l  d2,(a4)         write it to ram */
    move.l d2,(a4)
/* QL:         cmp.l   (a4)+,d2        check it */
    cmp.l (a4)+,d2
/* QL:         dbne    d6,M1_nextword     loop */
    dbne d6,M1_nextword
/* QL:         move.l  d2,a0 */
    move.l d2,a0
/* QL: M1_chk_fail */
M1_chk_fail:
/* QL:         lea     M1_ranpat*4,a1     ready for next block */
    lea (M1_ranpat*4),a1
/* QL:         beq.l   M1_nextlump        keep going until a fail */
    beq.w M1_nextlump
/* QL:         subq.l  #4,a4           back up to failed location */
    subq.l #4,a4
/* QL:         move.l  a0,d2           now d2 is test value that failed */
    move.l a0,d2
/* QL: M1_bad_rand */
M1_bad_rand:
/* QL:         move.l  d2,d7           now d7 is test value that failed */
    move.l d2,d7
/* QL: * fail locations: indicate failure by screen writing */
/* QL: M1_hangup */
M1_hangup:
/* QL:         move.l  (a4),d6         pick up failing longword */
    move.l (a4),d6
/* QL:         moveq   #8<<3+4,d5      set d5 for full, single tv screen reset & count */
    moveq #((8<<3)+4),d5
/* QL:         lea     M1_scr1-M1_scr2+128*32+64-8*6(a6),a1 start of first display line */
    lea ((((M1_scr1-M1_scr2)+(128*32))+64)-(8*6))(a6),a1
/* QL: M1_sh_word */
M1_sh_word:
/* QL:         moveq   #7*4,d3         7 lines each repeated 4 times */
    moveq #(7*4),d3
/* QL: M1_sh_line */
M1_sh_line:
/* QL:         moveq   #-32/4,d2       hex digits per longword */
    moveq #((-32)/4),d2
/* QL: M1_sh_byte */
M1_sh_byte:
/* QL:         lea     tb_hex-$4000+6,a0 base of small hex digits */
    lea ((tb_hex-0x4000)+6)(pc),a0
/* QL:         rol.l   #4,d7           roll next digit to lsb's */
    rol.l #4,d7
/* QL:         moveq   #15,d1 */
    moveq #15,d1
/* QL:         and.b   d7,d1 */
    and.b d7,d1
/* QL:         moveq   #9*4,d0         (also 6*6) */
    moveq #(9*4),d0
/* QL:         mulu    d0,d1 */
    mulu d0,d1
/* QL:         sub.w   d3,d1 */
    sub.w d3,d1
/* QL:         asr.w   #2,d1 */
    asr.w #2,d1
/* QL:         add.w   d1,a0           pick out row of char */
    add.w d1,a0
/* QL:         move.b  $4000(a0),d1 */
    move.b 0x4000(a0),d1
/* QL: M1_sh_bit */
M1_sh_bit:
/* QL:         cmp.b   #6*4,d3 */
    cmp.b #((6*4)&255),d3
/* QL:         bcc.s   M1_bltop */
    bcc.s M1_bltop
/* QL:         add.b   d1,d1 */
    add.b d1,d1
/* QL: M1_bltop */
M1_bltop:
/* QL:         scs     (a1)+ */
    scs (a1)+
/* QL:         scs     (a1)+ */
    scs (a1)+
/* QL:         subq.b  #6,d0 */
    subq.b #6,d0
/* QL:         bne.s   M1_sh_bit */
    bne.s M1_sh_bit
/* QL:         addq.w  #1,d2           count down digits (nb saving msw=-1) */
    addq.w #1,d2
/* QL:         bne.s   M1_sh_byte */
    bne.s M1_sh_byte
/* QL:         lea     128-2*8*6(a1),a1 */
    lea (128-((2*8)*6))(a1),a1
/* QL:         subq.b  #1,d3           count rows */
    subq.b #1,d3
/* QL:         bne.s   M1_sh_line */
    bne.s M1_sh_line
/* QL:         move.l  d6,d7           after bad data, do expected data */
    move.l d6,d7
/* QL:         move.l  a4,d6           finally do failing address */
    move.l a4,d6
/* QL:         asr.l   #1,d5 */
    asr.l #1,d5
/* QL:         bcc.s   M1_sh_word */
    bcc.s M1_sh_word
/* QL:         lea     M1_pc_clock+3,a0 */
    lea (M1_pc_clock+3),a0
/* QL:         moveq   #15,d0          hang on for 1/4 minute (gold card compat.) */
    moveq #15,d0
/* QL:         add.b   (a0),d0 */
    add.b (a0),d0
/* QL: M1_waste */
M1_waste:
/* QL:         cmp.b   (a0),d0 */
    cmp.b (a0),d0
/* QL:         bne.s   M1_waste */
    bne.s M1_waste
/* QL:         bra.s   M1_retry */
    bra.s M1_retry
/* QL: * Start of ram test: come here at power on and after "reset" instruction */
/* QL: ss_ramt */
ss_ramt:
/* QL:         cmp.l   M1_magic,a5        check for M1_magic number in a5 */
    cmp.l M1_magic,a5
/* QL:         beq.s   M1_d1set           if it's there, d1 is valid (we hope!) */
    beq.s M1_d1set
/* QL:         moveq   #-1,d7 */
    moveq #(-1),d7
/* QL:         dbra    d7,*            M1_waste some time in case of glitch */
    dbra d7,.
/* QL:         lea     M1_iicmd,a3        load command sequence address */
    lea M1_iicmd(pc),a3
/* QL:         lea     M1_iiret,a0        load return address */
    lea M1_iiret(pc),a0
/* QL:         move.w  M1_ii.raw,a5       use vector to get to i2c code */
    move.w M1_ii.raw,a5
/* QL:         jmp     $4000(a5)       jump to i2c raw entry point address */
    jmp 0x4000(a5)
/* QL: M1_iiret */
M1_iiret:
/* QL:         beq.s   M1_d1set */
    beq.s M1_d1set
/* QL:         moveq   #8,d1           full reset, default tv mode single screen */
    moveq #8,d1
/* QL: M1_d1set */
M1_d1set:
/* QL:         move.l  d1,d5           set d5 for later and passing on to ss_init */
    move.l d1,d5
/* QL:         and.w   #-M1_m16k,d1       the top address we're being asked to use */
    and.w #(-M1_m16k),d1
/* QL:         move.l  d1,a4           upper limit to check ram to */
    move.l d1,a4
/* QL: M1_retry */
M1_retry:
/* QL:         move.l  #M1_i_sp,sp        ignore original sp and set proper one */
    move.l #M1_i_sp,sp
/* QL:         lea     M1_scr2-M1_i_sp(sp),a6 keep a useful address in a6 */
    lea (M1_scr2-M1_i_sp)(sp),a6
/* QL: ;        if      ntsc */
/* QL: ;        move.b  #64,M1_mc_stat     set 512 pixel mode, 60hz */
/* QL: ;        else */
/* QL:         sf      M1_mc_stat         set 512 pixel mode, display screen 0 */
    sf M1_mc_stat
/* QL: ;        endif */
/* QL:         moveq   #-1,d7          set flag for first time round, and ones test */
    moveq #(-1),d7
/* QL:         move.l  a4,a5           copy upper limit */
    move.l a4,a5
/* QL:         btst    #2,d5           is this a forced limit? */
    btst #2,d5
/* QL:         bne.s   M1_res_a5          yes, go use it, whatever it is! */
    bne.s M1_res_a5
/* QL:         move.l  a6,a5           start address for checking */
    move.l a6,a5
/* QL:         move.w  #M1_m16k,a0        16k increment */
    move.w #M1_m16k,a0
/* QL:         sub.l   a0,a4           pop a bit off limit, so it will compare nice */
    sub.l a0,a4
/* QL:         bra.s   M1_find_ext */
    bra.s M1_find_ext
/* QL: M1_next_add */
M1_next_add:
/* QL:         move.l  a5,(a5)         set address to self */
    move.l a5,(a5)
/* QL:         move.l  a6,a1           start at bottom */
    move.l a6,a1
/* QL: M1_smash */
M1_smash:
/* QL:         cmp.l   (a1),a1         check all test words are intact */
    cmp.l (a1),a1
/* QL:         bne.s   M1_res_a5          if not, stop here */
    bne.s M1_res_a5
/* QL:         cmp.l   a1,a5 */
    cmp.l a1,a5
/* QL:         add.l   a0,a1 */
    add.l a0,a1
/* QL:         bne.s   M1_smash */
    bne.s M1_smash
/* QL:         add.l   a0,a5           bump up available ram by 16k */
    add.l a0,a5
/* QL: M1_find_ext */
M1_find_ext:
/* QL:         cmp.l   a5,a4           are we up to requested/bad memory yet? */
    cmp.l a5,a4
/* QL:         bcc.s   M1_next_add        no, try for more */
    bcc.s M1_next_add
/* QL: M1_res_a5 */
M1_res_a5:
/* QL:         moveq   #64,d1          (just in case clock bits are zero) */
    moveq #64,d1
/* QL:         or.w    M1_pc_clock+2,d1 */
    or.w (M1_pc_clock+2),d1
/* QL:         lsl.w   #3,d1           2048 possible random starts */
    lsl.w #3,d1
/* QL:         lsr.w   #1,d1 */
    lsr.w #1,d1
/* QL:         moveq   #0,d0           permanently zero */
    moveq #0,d0
/* QL:         btst    d0,d5           check if quick reset */
    btst d0,d5
/* QL:         bne.s   M1_onepass         if quick, only do 2nd pass */
    bne.s M1_onepass
/* QL:         lea     M1_do_1st,a2       set jump address for first pass */
    lea M1_do_1st(pc),a2
/* QL: M1_nextpass */
M1_nextpass:
/* QL:         lea     M1_scr1-M1_scr2(a6),a4 beginning of ram to be tested */
    lea (M1_scr1-M1_scr2)(a6),a4
/* QL:         move.w  d1,a1           randomised start on entry to pass */
    move.w d1,a1
/* QL: M1_nextlump */
M1_nextlump:
/* QL:         add.l   a4,a1           offset by high place in rom for random pattern */
    add.l a4,a1
/* QL:         cmp.l   a1,a5           will this go beyond top of ram? */
    cmp.l a1,a5
/* QL:         bcc.s   M1_ranok           no, use full count */
    bcc.s M1_ranok
/* QL:         move.l  a5,a1           yes, drop back a bit */
    move.l a5,a1
/* QL: M1_ranok */
M1_ranok:
/* QL:         sub.l   a4,a1           this is top of pattern now */
    sub.l a4,a1
/* QL:         move.w  a1,d6 */
    move.w a1,d6
/* QL:         lsr.w   #2,d6           this is the longword counter */
    lsr.w #2,d6
/* QL:         dbra    d6,M1_nextword     if not at end, do next longword */
    dbra d6,M1_nextword
/* QL:         dbra    d6,*            give refresh 150ms to fall over */
    dbra d6,.
/* QL:         dbra    d6,*            another 150ms at a different memory address */
    dbra d6,.
/* QL: M1_onepass */
M1_onepass:
/* QL:         lea     M1_do_logo,a2      at begining of second pass, M1_logo checks on */
    lea M1_do_logo(pc),a2
/* QL:         lea     M1_logo,a3         set pointer to M1_logo */
    lea M1_logo(pc),a3
/* QL:         lsl.w   #8,d7           is this the second pass? */
    lsl.w #8,d7
/* QL:         bne.s   M1_nextpass        no, so go for 2nd pass */
    bne.s M1_nextpass
/* QL: M1_gogogo */
M1_gogogo:
/* QL:         move.w  #$3fe0,d0       nine bits we will adjust ssp with */
    move.w #0x3fe0,d0
/* QL:         and.w   d5,d0           pick them out of reset longword */
    and.w d5,d0
/* QL:         lsl.l   #8,d0           move them up to their right place */
    lsl.l #8,d0
/* QL:         add.l   d0,sp           set system stack pointer */
    add.l d0,sp
/* QL:         jmp     ss_init(pc)     and jump into system initialisation */
    jmp ss_init(pc)
/* QL: M1_qfin */
M1_qfin:
/* QL:         move.l  d0,(a4)+        clean out last bit of screen after M1_logo */
    move.l d0,(a4)+
/* QL:         move.w  a4,d3 */
    move.w a4,d3
/* QL:         bne.s   M1_qfin */
    bne.s M1_qfin
/* QL:         bra.s   M1_gogogo */
    bra.s M1_gogogo
/* QL: M1_iicmd */
M1_iicmd:
/* QL:         dc.b    %11001110       trash device, send initialise */
M1_dc_anchor_967:
.byte (0b11001110)&255
/* QL:         dc.b    $a0/2,%11011110 set device */
M1_dc_anchor_970:
.byte ((0xa0/2))&255
.byte (0b11011110)&255
/* QL:         dc.b    1,%10100000,20  START/write address byte */
M1_dc_anchor_974:
.byte (1)&255
.byte (0b10100000)&255
.byte (20)&255
/* QL:         dc.b    4-1,%10110000   START/read d1 four bytes, NAK last */
M1_dc_anchor_979:
.byte ((4-1))&255
.byte (0b10110000)&255
/* QL:         dc.b    3,%10100100,22,0,8 start/write address, kill lsw boot, STOP */
M1_dc_anchor_983:
.byte (3)&255
.byte (0b10100100)&255
.byte (22)&255
.byte (0)&255
.byte (8)&255
/* QL:         dc.b    $ff             terminate sequence */
M1_dc_anchor_990:
.byte (0xff)&255
/* QL:         end */
