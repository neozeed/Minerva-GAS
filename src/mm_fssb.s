/* ROM section mm_fssb */
.balign 2,0
/* QL: * Workhorse for releasing slave blocks, most of this was in io_slave */
/* QL: reglist reg     d0-d1/d3/a0-a4 */
/* QL: M53_sb_slave */
M53_sb_slave:
/* QL:         movem.l reglist,-(sp) */
    movem.l d0-d1/d3/a0-a4,-(sp)
/* QL:         move.w  #M53_sv_fsdef<<2&(-256)!$f0,d1 mask for drive id and part offset */
    move.w #(((M53_sv_fsdef<<2)&(-256))|0xf0),d1
/* QL:         assert  0,M53_bt_stat */
/* original assertion: 0,M53_bt_stat */
/* QL:         and.b   (a1),d1         pick out drive bits from status */
    and.b (a1),d1
/* QL:         asr.w   #2,d1           shift id to make pointer to table */
    asr.w #2,d1
/* QL:         move.l  M53_sv_fsdef&63(a6,d1.w),a2 get physical definition block */
    move.l (M53_sv_fsdef&63)(a6,d1.w),a2
/* QL:         move.l  M53_fs_drivr(a2),a4 driver linkage address */
    move.l M53_fs_drivr(a2),a4
/* QL:         lea     -M53_sv_lio(a4),a3  base of driver definition block */
    lea (-M53_sv_lio)(a4),a3
/* QL:         move.l  M53_ch_slave(a4),a4 get entry point of slave */
    move.l M53_ch_slave(a4),a4
/* QL:         jsr     (a4) */
    jsr (a4)
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d0-d1/d3/a0-a4
/* QL: M53_sb_allop */
M53_sb_allop:
/* QL:         moveq   #M53_bt.actn,d2     set up action (read or write) mask */
    moveq #M53_bt.actn,d2
/* QL:         and.b   (a1),d2         is action pending */
    and.b (a1),d2
/* QL:         bne.s   M53_sb_slave        yes - go ensure slaving */
    bne.s M53_sb_slave
/* QL:         sf      (a1)            take this block */
    sf (a1)
/* QL: M53_ea_top */
M53_ea_top:
/* QL:         add.l   d3,a1           move pointer to next one */
    add.l d3,a1
/* QL: M53_ea_bot */
M53_ea_bot:
/* QL:         subq.l  #M53_bt_end,d0 */
    subq.l #M53_bt_end,d0
/* QL:         bge.s   M53_sb_allop        any more blocks? */
    bge.s M53_sb_allop
/* QL:         bra.s   M53_ok_rts */
    bra.s M53_ok_rts
/* QL: * Allocate space from slave blocks */
/* QL: * d0 -  o- 0 or M53_err.om */
/* QL: * d1 -i o- space to be allocated (may be rounded up) */
/* QL: * a0 -  o- new top or bottom pointer */
/* QL: * d2-d3/a1-a2 destroyed */
/* QL: mm_altop */
mm_altop:
/* QL:         add.l   #M53_sblen-1,d1     rounding up */
    add.l #(M53_sblen-1),d1
/* QL:         bsr.s   M53_sb_top          set up pointers to top */
    bsr.s M53_sb_top
/* QL:         sub.l   d1,a0 */
    sub.l d1,a0
/* QL:         lea     (1-M53_spare)*M53_sblen(a0),a2 allow M53_spare space */
    lea ((1-M53_spare)*M53_sblen)(a0),a2
/* QL:         cmp.l   M53_sv_free(a6),a2  check remaining space */
    cmp.l M53_sv_free(a6),a2
/* QL:         ble.s   M53_err_om */
    ble.s M53_err_om
/* QL:         move.l  a0,M53_sv_basic(a6) save top pointer */
    move.l a0,M53_sv_basic(a6)
/* QL:         bra.s   M53_ea_top          allocate slave blocks */
    bra.s M53_ea_top
/* QL: mm_albot */
mm_albot:
/* QL:         add.l   #M53_sblen-1,d1     rounding up */
    add.l #(M53_sblen-1),d1
/* QL:         bsr.s   M53_sb_bot          set up pointers to bottom */
    bsr.s M53_sb_bot
/* QL:         add.l   d1,a0 */
    add.l d1,a0
/* QL:         lea     (M53_spare-1)*M53_sblen(a0),a2 allow M53_spare space */
    lea ((M53_spare-1)*M53_sblen)(a0),a2
/* QL:         cmp.l   M53_sv_basic(a6),a2 check remaining space */
    cmp.l M53_sv_basic(a6),a2
/* QL:         bge.s   M53_err_om */
    bge.s M53_err_om
/* QL:         move.l  a0,M53_sv_free(a6)  save bottom pointer */
    move.l a0,M53_sv_free(a6)
/* QL:         bra.s   M53_ea_bot */
    bra.s M53_ea_bot
/* QL: M53_err_om */
M53_err_om:
/* QL:         moveq   #M53_err.om,d0      out of memory - set flag */
    moveq #M53_err.om,d0
/* QL:         bra.s   M53_rts0 */
    bra.s M53_rts0
/* QL: * Find pointers to slave blocks */
/* QL: M53_sb_top */
M53_sb_top:
/* QL:         move.l  M53_sv_basic(a6),a0 change the top end */
    move.l M53_sv_basic(a6),a0
/* QL:         moveq   #-M53_bt_end,d3     and scan down through the slave blocks */
    moveq #(-M53_bt_end),d3
/* QL:         bra.s   M53_sb_addr */
    bra.s M53_sb_addr
/* QL: M53_sb_bot */
M53_sb_bot:
/* QL:         move.l  M53_sv_free(a6),a0  change the bottom end */
    move.l M53_sv_free(a6),a0
/* QL:         moveq   #M53_bt_end,d3      and scan up through the slave blocks */
    moveq #M53_bt_end,d3
/* QL: M53_sb_addr */
M53_sb_addr:
/* QL:         move.l  a0,d0           the slave block entries are at address */
    move.l a0,d0
/* QL:         sub.l   a6,d0           less base (system vars) */
    sub.l a6,d0
/* QL:         lsr.l   #M53_sbbit-M53_btbit,d0 divided by M53_sblen/M53_bt_end */
    lsr.l #(M53_sbbit-M53_btbit),d0
/* QL:         move.l  M53_sv_btbas(a6),a1 plus the base of the slave block table */
    move.l M53_sv_btbas(a6),a1
/* QL:         add.l   d0,a1 */
    add.l d0,a1
/* QL:         and.w   #-M53_sblen,d1      truncate to a multiple of M53_sblen */
    and.w #(-M53_sblen),d1
/* QL:         move.l  d1,d0 */
    move.l d1,d0
/* QL:         asr.l   #M53_sbbit-M53_btbit,d0 slave blocks table area size (keep sign!) */
    asr.l #(M53_sbbit-M53_btbit),d0
/* QL:         rts */
    rts 
/* QL: * Release space to slave blocks */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -i o- space to be released (may be rounded down) */
/* QL: * a0 -  o- new top or bottom pointer */
/* QL: * d3/a1 destroyed */
/* QL: mm_retop */
mm_retop:
/* QL:         bsr.s   M53_sb_top          set up pointers to top */
    bsr.s M53_sb_top
/* QL:         add.l   d1,a0 */
    add.l d1,a0
/* QL:         move.l  a0,M53_sv_basic(a6) */
    move.l a0,M53_sv_basic(a6)
/* QL:         bra.s   M53_er_top */
    bra.s M53_er_top
/* QL: mm_rebot */
mm_rebot:
/* QL:         bsr.s   M53_sb_bot          set up pointers to bottom */
    bsr.s M53_sb_bot
/* QL:         sub.l   d1,a0 */
    sub.l d1,a0
/* QL:         move.l  a0,M53_sv_free(a6) */
    move.l a0,M53_sv_free(a6)
/* QL:         bra.s   M53_er_bot */
    bra.s M53_er_bot
/* QL: M53_sb_rel */
M53_sb_rel:
/* QL:         move.b  #M53_bt.empty,(a1)  mark block as empty */
    move.b #(M53_bt.empty&255),(a1)
/* QL: M53_er_bot */
M53_er_bot:
/* QL:         sub.l   d3,a1           move to next block */
    sub.l d3,a1
/* QL: M53_er_top */
M53_er_top:
/* QL:         subq.l  #M53_bt_end,d0 */
    subq.l #M53_bt_end,d0
/* QL:         bge.s   M53_sb_rel          any more blocks? */
    bge.s M53_sb_rel
/* QL: M53_ok_rts */
M53_ok_rts:
/* QL:         moveq   #0,d0           OK (even if a negative d1 was supplied) */
    moveq #0,d0
/* QL: M53_rts0 */
M53_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
