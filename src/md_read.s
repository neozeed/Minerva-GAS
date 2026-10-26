/* ROM section md_read */
.balign 2,0
/* QL: * General register usage */
/* QL: * d0 timer / used by end_gp/delay etc */
/* QL: * d1 counter of bytes to be read/written / file nr read */
/* QL: * d2 sector to be found (fsect)          / block nr read */
/* QL: * d3 M82_checksum */
/* QL: * d4 byte read / M82_checksum compare */
/* QL: * d5 loop counter (fsect) */
/* QL: * d6 bit number for read flag in control register */
/* QL: * d7 sector number */
/* QL: * a0 read / verify entry point */
/* QL: * a1 pointer to data buffer */
/* QL: * a2 pointer to read register */
/* QL: * a3 pointer to microdrive control register */
/* QL: * a4 alternative pointer to read register */
/* QL: * a5 used by fsect only - address for sector header */
/* QL: * Find and read a specified sector header */
/* QL: * d2 -ip - sector to be found (lsb) */
/* QL: * d7 -  o- last sector number found in lsb, rest zero (not if return+0) */
/* QL: * a1 -  o- 14(a5), if all ok */
/* QL: * a3 -ip - pointer to microdrive control register */
/* QL: * a5 -ip - pointer to 14 byte buffer to read sector header into */
/* QL: * d0-d1/d3-d6/a2/a4 destroyed */
/* QL: * return+0 failed, return+2 ok */
/* QL: md_fsect */
md_fsect:
/* QL:         moveq   #0,d5           search up to 256 sectors for d2 */
    moveq #0,d5
/* QL: M82_find_lop */
M82_find_lop:
/* QL:         move.l  a5,a1           put header into (a5) */
    move.l a5,a1
/* QL:         bsr.s   md_sectr        get sector */
    bsr.s md_sectr
/* QL:         rts */
    rts 
/* QL:         bra.s   M82_find_lop        bad sector look for another one */
    bra.s M82_find_lop
/* QL:         cmp.b   d7,d2           found? */
    cmp.b d7,d2
/* QL:         beq.s   M82_ret_ok */
    beq.s M82_ret_ok
/* QL:         addq.b  #1,d5           try next sector */
    addq.b #1,d5
/* QL:         bcc.s   M82_find_lop */
    bcc.s M82_find_lop
/* QL:         rts                     can't find sector */
    rts 
/* QL: * Read next sector header */
/* QL: * d7 -  o- sector number in lsb, rest zero, only on good return */
/* QL: * a3 -ip - pointer to microdrive control register */
/* QL: * d0/d3-d4/d6/a2/a4 destroyed */
/* QL: * return+0 no gap found, return+2 bad sector, return+4 ok */
/* QL: md_sectr */
md_sectr:
/* QL:         jsr     md_endgp(pc)    wait for end of gap */
    jsr md_endgp(pc)
/* QL:         rts */
    rts 
/* QL:         addq.l  #2,(sp)         ... semi good return */
    addq.l #2,(sp)
/* QL:         moveq   #14-1,d1        sector header is 14 bytes */
    moveq #(14-1),d1
/* QL:         bsr.s   M82_rblock          and read sector header */
    bsr.s M82_rblock
/* QL:         bra.s   M82_bad_sect */
    bra.s M82_bad_sect
/* QL:         cmp.b   #$ff,-14(a1)    ... but is it a sector header? */
    cmp.b #(0xff&255),(-14)(a1)
/* QL:         bne.s   M82_bad_sect */
    bne.s M82_bad_sect
/* QL:         moveq   #0,d7 */
    moveq #0,d7
/* QL:         move.b  -14+1(a1),d7    get sector number */
    move.b ((-14)+1)(a1),d7
/* QL: M82_ret_ok */
M82_ret_ok:
/* QL:         addq.l  #2,(sp)         ... good return */
    addq.l #2,(sp)
/* QL: M82_bad_sect */
M82_bad_sect:
/* QL:         rts */
    rts 
/* QL: * Read/verify has two returns */
/* QL: * d1 -  o- file number in lsb, rest zero */
/* QL: * d2 -  o- record number in lsb, rest zero */
/* QL: * a1 -i o- 512 byte block data to read or verify, updated past end if ok */
/* QL: * a3 -ip - pointer to microdrive control register */
/* QL: * d0/d3-d4/d6/a0/a2/a4 destroyed */
/* QL: * return+0 bad, return+2 ok */
/* QL: md_read */
md_read:
/* QL:         lea     M82_rblock(pc),a0 */
    lea M82_rblock(pc),a0
/* QL:         bra.s   M82_read_ver */
    bra.s M82_read_ver
/* QL: md_verin */
md_verin:
/* QL:         lea     M82_vblock(pc),a0 */
    lea M82_vblock(pc),a0
/* QL: M82_read_ver */
M82_read_ver:
/* QL:         jsr     md_endgp(pc)    wait for end of gap */
    jsr md_endgp(pc)
/* QL:         rts                     get out if we couldn't find one */
    rts 
/* QL:         move.l  a1,-(sp)        save block pointer */
    move.l a1,-(sp)
/* QL:         clr.w   -(sp)           clean block header on stack */
    clr.w -(sp)
/* QL:         move.l  sp,a1 */
    move.l sp,a1
/* QL:         moveq   #2-1,d1         block header is 2 bytes */
    moveq #(2-1),d1
/* QL:         bsr.s   M82_rblock          and read block header */
    bsr.s M82_rblock
/* QL:         bra.s   M82_bad_blok        failed */
    bra.s M82_bad_blok
/* QL:         move.b  #M82_pc.read,d1     set up pll reset byte */
    move.b #(M82_pc.read&255),d1
/* QL:         move.b  d1,(a3)         reset pll */
    move.b d1,(a3)
/* QL:         delay   25              wait for a zero to clock through */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL: qdbra maclab 21 to 309 step 2 us */
/* QL:  moveq #([us]*15-50)/36,d0 six byte sequence */
    moveq #(((25*15)-50)/36),d0
/* QL:  dbra d0,* */
    dbra d0,.
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         move.b  d1,(a3)         reset controller */
    move.b d1,(a3)
/* QL:         move.w  #512-1,d1       read 512 byte block */
    move.w #(512-1),d1
/* QL:         move.l  2(sp),a1        restore a1 */
    move.l 2(sp),a1
/* QL:         jsr     (a0)            read / verify */
    jsr (a0)
/* QL:         bra.s   M82_bad_blok        failed - hmmm... why set d1/d2, as undef above */
    bra.s M82_bad_blok
/* QL:         addq.l  #2,6(sp)        change over to a good return */
    addq.l #2,6(sp)
/* QL: M82_bad_blok */
M82_bad_blok:
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.b  1(sp),d2        funny motorola stack handling */
    move.b 1(sp),d2
/* QL:         move.b  (sp)+,d1 */
    move.b (sp)+,d1
/* QL:         addq.l  #4,sp           remove buffer address */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: * d1 -i  - byte count less one */
/* QL: * a1 -i o- buffer address, updated past last byte */
/* QL: * a3 -ip - pointer to microdrive control register */
/* QL: * d0/d3-d4/d6/a2/a4 destroyed */
/* QL: * return+0 bad, return+2 ok */
/* QL: M82_rblock */
M82_rblock:
/* QL:         moveq   #0,d4           upper part of data word */
    moveq #0,d4
/* QL:         bra.s   M82_rvcomm */
    bra.s M82_rvcomm
/* QL: * Verify long block - has two returns */
/* QL: * a1 -i o- long (512+98) block data to be verified, if ok, updated past end */
/* QL: * a3 -ip - pointer to microdrive control register */
/* QL: * d0-d1/d3-d4/d6/a2/a4 destroyed */
/* QL: * return+0 verify failed, return+2 ok */
/* QL: md_veril */
md_veril:
/* QL:         jsr     md_endgp(pc)    wait for end of gap */
    jsr md_endgp(pc)
/* QL:         rts                     gap not seen */
    rts 
/* QL:         move.w  #2+2+8+512+86-1,d1 long block used when formatting */
    move.w #(((((2+2)+8)+512)+86)-1),d1
/* QL:         bsr.s   M82_vblock          verify it */
    bsr.s M82_vblock
/* QL:         rts                     verification failed */
    rts 
/* QL: M82_plustwo */
M82_plustwo:
/* QL:         addq.l  #2,(sp)         good return */
    addq.l #2,(sp)
/* QL:         rts */
    rts 
/* QL: read_byt macro ; min 74, max 674 (d0=21-1, d0 * 30 in loop) */
/* QL: M82_verif */
M82_verif:
/* QL:         cmp.b   (a1)+,d4     12+contention compare byte */
    cmp.b (a1)+,d4
/* QL:         dbne    d1,M82_rvloop 18/26 (or 20 = fall out on bad verify) */
    dbne d1,M82_rvloop
/* QL:         bne.s   M82_rvb_exit  18/12 give up if byte failed to verify */
    bne.s M82_rvb_exit
/* QL: * Read M82_checksum */
/* QL: * Time from last read or verify = 158 cycles 21.1 us max */
/* QL: * Time for the single loop = 126, so on average, 142 should be fine! */
/* QL: * Note d1 is equal to -1 */
/* QL: M82_checksum */
M82_checksum:
/* QL:         read_byt      ; (674)74 wait for next byte */
/* QL: wait[.l] */
M82_wait2:
/* QL:         btst    d6,(a3)      12 * wait for bit set */
    btst d6,(a3)
/* QL:         dbne    d0,wait[.l] 18/20 loop/ne or 26 on timeout */
    dbne d0,M82_wait2
/* QL:         beq.s   M82_rvb_exit  18/12 get out now if we are too far off spec */
    beq.s M82_rvb_exit
/* QL:         move.b  (a2),d4      12 * read byte, at least 44 cycles since flag set */
    move.b (a2),d4
/* QL:         exg     a2,a4        10 toggle read address */
    exg a4,a2
/* QL:         moveq   #21-1,d0      8 reset read timeout to one byte, half speed */
    moveq #(21-1),d0
/* QL:         ror.w   #8,d4        26 move byte round */
    ror.w #8,d4
/* QL:         addq.w  #1,d1         8 increment counter */
    addq.w #1,d1
/* QL:         beq.s   M82_checksum  18/12 go for other byte */
    beq.s M82_checksum
/* QL:         cmp.w   d4,d3           is M82_checksum correct? */
    cmp.w d4,d3
/* QL:         beq.s   M82_plustwo         yes, so go do return+2 */
    beq.s M82_plustwo
/* QL: M82_rvb_exit */
M82_rvb_exit:
/* QL:         rts */
    rts 
/* QL: * d1 -i  - byte count less one */
/* QL: * a1 -i o- buffer address, updated past last byte */
/* QL: * a3 -ip - pointer to microdrive control register */
/* QL: * d0/d3-d4/d6/a2/a4 destroyed */
/* QL: * return+0 bad, return+2 ok */
/* QL: M82_vblock */
M82_vblock:
/* QL:         moveq   #1,d4           upper part of data word */
    moveq #1,d4
/* QL:         ror.l   #1,d4           put flag in msb for verify */
    ror.l #1,d4
/* QL: M82_rvcomm */
M82_rvcomm:
/* QL:         move.w  #$0f0f,d3       set up M82_checksum register */
    move.w #0x0f0f,d3
/* QL:         moveq   #M82_pc..rxrd,d6    check for read */
    moveq #M82_pc..rxrd,d6
/* QL:         lea     M82_pc_trak1-M82_pc_mctrl(a3),a2 set up read addresses */
    lea (M82_pc_trak1-M82_pc_mctrl)(a3),a2
/* QL:         lea     M82_pc_trak2-M82_pc_mctrl(a3),a4 */
    lea (M82_pc_trak2-M82_pc_mctrl)(a3),a4
/* QL:         move.w  #257-1,d0       wait for up to 1 ms before giving up 1st byte */
    move.w #(257-1),d0
/* QL: M82_rvloop */
M82_rvloop:
/* QL:         read_byt      ; (674)74 get the next byte (7754 on very 1st byte) */
/* QL: wait[.l] */
M82_wait3:
/* QL:         btst    d6,(a3)      12 * wait for bit set */
    btst d6,(a3)
/* QL:         dbne    d0,wait[.l] 18/20 loop/ne or 26 on timeout */
    dbne d0,M82_wait3
/* QL:         beq.s   M82_rvb_exit  18/12 get out now if we are too far off spec */
    beq.s M82_rvb_exit
/* QL:         move.b  (a2),d4      12 * read byte, at least 44 cycles since flag set */
    move.b (a2),d4
/* QL:         exg     a2,a4        10 toggle read address */
    exg a4,a2
/* QL:         moveq   #21-1,d0      8 reset read timeout to one byte, half speed */
    moveq #(21-1),d0
/* QL:         add.w   d4,d3         8 add byte to M82_checksum */
    add.w d4,d3
/* QL:         tst.l   d4            8 read or verify */
    tst.l d4
/* QL:         bmi.s   M82_verif     18/12 branch out for verify, so loop ends match up */
    bmi.s M82_verif
/* QL:         move.b  d4,(a1)+     12+contention store it */
    move.b d4,(a1)+
/* QL:         dbra    d1,M82_rvloop 18/26 */
    dbra d1,M82_rvloop
/* QL:         bra.s   M82_checksum     18 */
    bra.s M82_checksum
/* QL: * Read(verify) loop is >= 132(150) cycles. Bear in mind that the verify really */
/* QL: * must be occurring on the same hardware! It should be near perfect! */
/* QL: * In essense, we should be able to cope with a read data rate which is well */
/* QL: * over twice specification! (17.6us per byte). */
/* QL: * We also tolerate even greater factor slower data rates (97.6us per byte). */
/* QL: * These correspond to worst case drive speeds, in both senses, of over 50%. */
/* QL: * Actually, our worst case may crop up with a block header. If we just miss */
/* QL: * seeing the first data ready flag, and we must take the first M82_checksum byte */
/* QL: * before the second comes up. (Or does buffering mean this is is no problem?) */
/* QL: * This will be 29(late)+132(data)+132(data)+158(1st M82_checksum)=451 cycles, which */
/* QL: * must not exceed 3 byte periods. It is only just over 20us, still OK. */
/* QL:         vect4000 md_read,md_sectr,md_verin */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ md$read,(md_read-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ md$sectr,(md_sectr-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ md$verin,(md_verin-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
