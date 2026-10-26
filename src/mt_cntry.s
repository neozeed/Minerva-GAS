/* ROM section mt_cntry */
.balign 2,0
/* QL: * d0.l -  o- 0 for ok or M36_err.bp for bad parameter */
/* QL: * d1.l -i o- translation table <-1 on, -1 no change, 0 off or 1 local default. */
/* QL: * d2.l -i o- message table address, <=0 no change or 1 local default. */
/* QL: * d1-d2 are undefined on error and nothing will have been altered. */
/* QL: * Values of 1 in either/both of d1/d2 will be changed to their default address. */
/* QL: reglist reg     d4/a0-a2 */
/* QL: mt_cntry */
mt_cntry:
/* QL:         assert  0,M36_mt.cntry>>6 ; and we hope(?) >>3 is non-zero */
/* original assertion: 0,M36_mt.cntry>>6 */
/* QL:         movem.l reglist,-(sp) */
    movem.l d4/a0-a2,-(sp)
/* QL:         move.l  M36_sv_chtop(a6),a0 basic pointer for default settings */
    move.l M36_sv_chtop(a6),a0
/* QL:         assert  M36_sv_trtab,M36_sv_mgtab-4 */
/* original assertion: M36_sv_trtab,M36_sv_mgtab-4 */
/* QL:         movem.l M36_sv_trtab(a6),a1-a2 pick up current settings */
    movem.l M36_sv_trtab(a6),a1-a2
/* QL: M36_get_it */
M36_get_it:
/* QL:         exg     d1,d2 */
    exg d1,d2
/* QL:         exg     a1,a2           if all ok, these swap twice */
    exg a2,a1
/* QL:         move.l  d1,d4           check param */
    move.l d1,d4
/* QL:         ble.s   M36_skip2           <=0 doesn't alter addresses */
    ble.s M36_skip2
/* QL:         asr.l   #1,d4           check out parameter ... */
    asr.l #1,d4
/* QL:         beq.s   M36_setdef          ... one, leave with default */
    beq.s M36_setdef
/* QL:         bcc.s   M36_chk_head        ... even, that's needs header checked */
    bcc.s M36_chk_head
/* QL: M36_err_bp */
M36_err_bp:
/* QL:         moveq   #M36_err.bp,d0      say bad parameter */
    moveq #M36_err.bp,d0
/* QL:         bra.s   M36_to_rte */
    bra.s M36_to_rte
/* QL: M36_setdef */
M36_setdef:
/* QL:         move.l  M36_sx_msg(a0),d1   pick up default address */
    move.l M36_sx_msg(a0),d1
/* QL: M36_chk_head */
M36_chk_head:
/* QL:         move.l  d1,a1           use the address */
    move.l d1,a1
/* QL:         cmp.w   #$4afb,(a1)     correct table start value? */
    cmp.w #0x4afb,(a1)
/* QL:         bne.s   M36_err_bp          no... that's an error */
    bne.s M36_err_bp
/* QL: M36_skip2 */
M36_skip2:
/* QL:         subq.l  #M36_sx_msg-M36_sx_trn,a0 point to tranlate default second time round */
.word 20872|((((M36_sx_msg-M36_sx_trn))&7)<<9)
/* QL:         lsr.b   #3,d0           have we done both yet? */
    lsr.b #3,d0
/* QL:         bne.s   M36_get_it          no - do the second parameter */
    bne.s M36_get_it
/* QL:         movem.l a1-a2,M36_sv_trtab(a6) store possibly modified values */
    movem.l a1-a2,M36_sv_trtab(a6)
/* QL:         move.l  d1,d4 */
    move.l d1,d4
/* QL:         not.l   d4              was translate table parameter exactly -1 */
    not.l d4
/* QL:         beq.s   M36_to_rte          yes - don't touch M36_sv_tran */
    beq.s M36_to_rte
/* QL:         not.l   d4              only precise zero turns off flag */
    not.l d4
/* QL:         sne     M36_sv_tran(a6)     set flag for translate */
    sne M36_sv_tran(a6)
/* QL: M36_to_rte */
M36_to_rte:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d4/a0-a2
/* QL:         jmp     ss_rte(pc) */
    jmp ss_rte(pc)
/* QL:         end */
