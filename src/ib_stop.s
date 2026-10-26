/* ROM section ib_stop */
.balign 2,0
/* QL: M170_stop_tab macro */
/* QL:  M170_stop_tab clear new stop run lrun load mrun merge retry outm */
/* QL: M170_stop_tab */
M170_stop_tab:
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: M170_s.clear 1*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
M170_dc_anchor_468:
.word ((M170_s_clear-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: M170_s.new 2*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
M170_dc_anchor_477:
.word ((M170_s_new-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: M170_s.stop 3*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
M170_dc_anchor_486:
.word ((M170_s_stop-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: M170_s.run 4*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
M170_dc_anchor_495:
.word ((M170_s_run-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: M170_s.lrun 5*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
M170_dc_anchor_504:
.word ((M170_s_lrun-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: M170_s.load 6*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
M170_dc_anchor_513:
.word ((M170_s_load-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: M170_s.mrun 7*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
M170_dc_anchor_522:
.word ((M170_s_mrun-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: M170_s.merge 8*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
M170_dc_anchor_531:
.word ((M170_s_merge-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: M170_s.retry 9*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
M170_dc_anchor_540:
.word ((M170_s_retry-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  assert s.[.parm([i])] [i]*2-2 */
/* original assertion: M170_s.outm 10*2-2 */
/* QL:  dc.w   s_[.parm([i])]-ib_stop */
.balign 2,0
M170_dc_anchor_549:
.word ((M170_s_outm-ib_stop))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: * Use stop number to do real work for commands which stop program execution. */
/* QL: ib_stop */
ib_stop:
/* QL:         move.w  M170_bv_stopn(a6),d1 read the stop number */
    move.w M170_bv_stopn(a6),d1
/* QL:         move.w  M170_stop_tab(pc,d1.w),d1 get the offset to go to */
    move.w M170_stop_tab(pc,d1.w),d1
/* QL:         jmp     ib_stop(pc,d1.w) and go to it */
.word 0x4efb
.word 4096|((ib_stop-.)&255)
/* QL: M170_s_outm */
M170_s_outm:
/* QL:         jsr     ib_error(pc)    write the 'out of memory' message then clear */
    jsr ib_error(pc)
/* QL:         move.l  M170_bv_rtp(a6),a0   get top of return stack */
    move.l M170_bv_rtp(a6),a0
/* QL:         sf      M170_bv_auto(a6) */
    sf M170_bv_auto(a6)
/* QL: M170_nx_rt */
M170_nx_rt:
/* QL:         cmp.l   M170_bv_rtbas(a6),a0 bottom of return stack yet ? */
    cmp.l M170_bv_rtbas(a6),a0
/* QL:         ble.s   M170_clear_1 */
    ble.s M170_clear_1
/* QL:         move.b  -M170_rt.rsrtt(a6,a0.l),d0 look at type */
    move.b (-M170_rt.rsrtt)(a6,a0.l),d0
/* QL:         beq.s   M170_gsub            GOSUB */
    beq.s M170_gsub
/* QL:         assert  M170_rt.rsba,M170_rt.rstl+8 */
/* original assertion: M170_rt.rsba,M170_rt.rstl+8 */
/* QL:         movem.l -M170_rt.rsba(a6,a0.l),d0-d2 offset of base of args and top locals */
    movem.l (-M170_rt.rsba)(a6,a0.l),d0-d2
/* QL:         sub.l   d0,d2           this is how many there are */
    sub.l d0,d2
/* QL:         add.l   M170_bv_ntbas(a6),d0 plus base of table */
    add.l M170_bv_ntbas(a6),d0
/* QL:         bra.s   M170_rt_ent */
    bra.s M170_rt_ent
/* QL: M170_rt_loop */
M170_rt_loop:
/* QL:         clr.l   0(a6,d0.l)      wipe the entry as spare */
    clr.l 0(a6,d0.l)
/* QL:         addq.l  #8,d0 */
    addq.l #8,d0
/* QL: M170_rt_ent */
M170_rt_ent:
/* QL:         subq.l  #8,d2 */
    subq.l #8,d2
/* QL:         bcc.s   M170_rt_loop */
    bcc.s M170_rt_loop
/* QL:         sub.w   #M170_rt.lenpr,a0 */
    sub.w #M170_rt.lenpr,a0
/* QL: M170_gsub */
M170_gsub:
/* QL:         subq.l  #M170_rt.lentl-M170_rt.lenpr,a0 */
.word 20872|((((M170_rt.lentl-M170_rt.lenpr))&7)<<9)
/* QL:         bra.s   M170_nx_rt */
    bra.s M170_nx_rt
/* QL: M170_nt_clear */
M170_nt_clear:
/* QL:         clr.l   0(a6,a2.l)      hopefully, we might be able to reuse this entry */
    clr.l 0(a6,a2.l)
/* QL: *       clr.l   4(a6,a2.l)      no need to clear VV pointer */
/* QL: M170_nt_next */
M170_nt_next:
/* QL:         addq.l  #8,a2           move to next row */
    addq.l #8,a2
/* QL: M170_nt_ent */
M170_nt_ent:
/* QL:         cmp.l   M170_bv_ntp(a6),a2   finished? */
    cmp.l M170_bv_ntp(a6),a2
/* QL:         beq.s   M170_nt_done */
    beq.s M170_nt_done
/* QL: M170_nt_loop */
M170_nt_loop:
/* QL:         move.b  0(a6,a2.l),d0   what type is this name? */
    move.b 0(a6,a2.l),d0
/* QL:         subq.b  #M170_t.mcp,d0 */
    subq.b #M170_t.mcp,d0
/* QL:         bcc.s   M170_nt_keep         always keep m/c proc/fn */
    bcc.s M170_nt_keep
/* QL:         addq.b  #M170_t.mcp-M170_t.intern,d0 */
.word 20480|((((M170_t.mcp-M170_t.intern))&7)<<9)
/* QL:         beq.s   M170_nt_clear        always discard internal */
    beq.s M170_nt_clear
/* QL:         tst.w   2(a6,a2.l)      look at namelist offset */
    tst.w 2(a6,a2.l)
/* QL:         ble.s   M170_nt_clear        if not +ve, then this is not required */
    ble.s M170_nt_clear
/* QL: * N.B. We know that "PRINT" is the name with NL offset 0, and it's an m/c proc */
/* QL: * Also, we'll drop basic PROC/FN's, as npass will reset them properly later */
/* QL:         jsr     bv_vtype(pc)    make it unset with proper type */
    jsr bv_vtype(pc)
/* QL:         moveq   #-1,d0 */
    moveq #(-1),d0
/* QL:         move.l  d0,4(a6,a2.l)   set no value */
    move.l d0,4(a6,a2.l)
/* QL: M170_nt_keep */
M170_nt_keep:
/* QL:         move.l  a2,a0           remember the highest active NT entry */
    move.l a2,a0
/* QL:         bra.s   M170_nt_next */
    bra.s M170_nt_next
/* QL: M170_s_clear */
M170_s_clear:
/* QL:         bsr.s   M170_qunrv2 */
    bsr.s M170_qunrv2
/* QL: M170_clear_1 */
M170_clear_1:
/* QL:         bsr.s   ib_clvv         clear variables and reset data */
    bsr.s ib_clvv
/* QL:         jsr     bv_clear(pc)    return RT and VV space to system */
    jsr bv_clear(pc)
/* QL:         st      M170_bv_edit(a6)     force an npass after this */
    st M170_bv_edit(a6)
/* QL:         move.l  M170_bv_ntbas(a6),a2 start at bottom of name table */
    move.l M170_bv_ntbas(a6),a2
/* QL:         bra.s   M170_nt_ent */
    bra.s M170_nt_ent
/* QL: M170_nt_done */
M170_nt_done:
/* QL:         addq.l  #8,a0 */
    addq.l #8,a0
/* QL:         move.l  a0,M170_bv_ntp(a6)   keep just the last active NT entry */
    move.l a0,M170_bv_ntp(a6)
/* QL: M170_s_run */
M170_s_run:
/* QL:         move.w  M170_bv_nxlin(a6),-(sp) just for DEF as last line of file! */
    move.w M170_bv_nxlin(a6),-(sp)
/* QL:         move.w  M170_bv_stopn(a6),-(sp) */
    move.w M170_bv_stopn(a6),-(sp)
/* QL:         moveq   #2+2+2*4,d1     select stack depth */
    moveq #((2+2)+(2*4)),d1
/* QL:         bsr.s   M170_qunrvl */
    bsr.s M170_qunrvl
/* QL:         move.w  (sp)+,M170_bv_stopn(a6) */
    move.w (sp)+,M170_bv_stopn(a6)
/* QL:         move.w  (sp)+,M170_bv_nxlin(a6) */
    move.w (sp)+,M170_bv_nxlin(a6)
/* QL:         jsr     ib_npass(pc)    where to run from already set */
    jsr ib_npass(pc)
/* QL:         bra.s   M170_end_seq */
    bra.s M170_end_seq
/* QL: M170_s_stop */
M170_s_stop:
/* QL:         tst.b   M170_bv_wherr(a6)    are we doing a WHEN? */
    tst.b M170_bv_wherr(a6)
/* QL:         sf      M170_bv_wherr(a6) */
    sf M170_bv_wherr(a6)
/* QL:         bne.s   M170_end_seq         yes, don't change continue status then */
    bne.s M170_end_seq
/* QL:         jsr     ib_pserr(pc)    set continuation status but no errmess */
    jsr ib_pserr(pc)
/* QL:         bra.s   M170_ok_rts */
    bra.s M170_ok_rts
/* QL: M170_qunrv2 */
M170_qunrv2:
/* QL:         moveq   #2*4,d1         select stack depth */
    moveq #(2*4),d1
/* QL: M170_qunrvl */
M170_qunrvl:
/* QL:         tst.b   M170_bv_unrvl(a6)    do we need to unravel first? */
    tst.b M170_bv_unrvl(a6)
/* QL:         beq.s   M170_rts0            no */
    beq.s M170_rts0
/* QL:         jmp     ib_unret(pc) */
    jmp ib_unret(pc)
/* QL: * A common routine to initialise things hit at least by CLEAR. */
/* QL: * d0 -  o- 0 */
/* QL: ib_clvv */
ib_clvv:
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL:         assert  M170_bv_dalno,M170_bv_dastm-2,M170_bv_daitm-3 */
/* original assertion: M170_bv_dalno,M170_bv_dastm-2,M170_bv_daitm-3 */
/* QL:         move.l  d0,M170_bv_dalno(a6) clear data line number & statement, but item=1 */
    move.l d0,M170_bv_dalno(a6)
/* QL:         jsr     ib_whzap(pc)    kill when variable handling */
    jsr ib_whzap(pc)
/* QL:         move.l  M170_bv_vvbas(a6),M170_bv_vvp(a6) delete the VV area */
    move.l M170_bv_vvbas(a6),M170_bv_vvp(a6)
/* QL:         clr.l   M170_bv_vvfre(a6)    drop VV free list */
    clr.l M170_bv_vvfre(a6)
/* QL:         move.l  M170_bv_rtbas(a6),M170_bv_rtp(a6) delete the return stack */
    move.l M170_bv_rtbas(a6),M170_bv_rtp(a6)
/* QL:         moveq   #M170_bv_btp-M170_bv_ribas,d0 */
    moveq #(M170_bv_btp-M170_bv_ribas),d0
/* QL: M170_ri_set */
M170_ri_set:
/* QL:         move.l  M170_bv_ribas(a6),M170_bv_ribas(a6,d0.w) delete RI, TG and BT stacks */
    move.l M170_bv_ribas(a6),M170_bv_ribas(a6,d0.w)
/* QL:         addq.l  #4,d0           move up to next pointer */
    addq.l #4,d0
/* QL:         bne.s   M170_ri_set          until change in direction */
    bne.s M170_ri_set
/* QL:         sf      M170_bv_unrvl(a6)    no unravel now */
    sf M170_bv_unrvl(a6)
/* QL: M170_rts0 */
M170_rts0:
/* QL:         rts */
    rts 
/* QL: M170_s_mrun */
M170_s_mrun:
/* QL: M170_s_merge */
M170_s_merge:
/* QL:         bsr.s   M170_qunrv2 */
    bsr.s M170_qunrv2
/* QL: M170_end_seq */
M170_end_seq:
/* QL:         move.b  M170_bv_sing(a6),M170_bv_comln(a6) save on return if single line */
    move.b M170_bv_sing(a6),M170_bv_comln(a6)
/* QL: M170_ok_rts */
M170_ok_rts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M170_ib_new */
M170_ib_new:
/* QL: M170_s_lrun */
M170_s_lrun:
/* QL: M170_s_load */
M170_s_load:
/* QL: M170_s_new */
M170_s_new:
/* QL: * N.B. Qload,Qlrun search from $a000 for next two instns to find this entry  */
/* QL:         move.l  M170_bv_chp(a6),a3 */
    move.l M170_bv_chp(a6),a3
/* QL:         move.l  M170_bv_chbas(a6),a2 */
    move.l M170_bv_chbas(a6),a2
/* QL:         add.w   #M170_ch.lench*3,a2  channels 0, 1 and 2 */
    add.w #(M170_ch.lench*3),a2
/* QL:         moveq   #M170_bv_lnp-M170_bv_chp,d0 kill off LN/RT as well */
    moveq #(M170_bv_lnp-M170_bv_chp),d0
/* QL: M170_chzap */
M170_chzap:
/* QL:         move.l  a2,M170_bv_chp(a6,d0.w) */
    move.l a2,M170_bv_chp(a6,d0.w)
/* QL:         subq.w  #4,d0 */
    subq.w #4,d0
/* QL:         bcc.s   M170_chzap */
    bcc.s M170_chzap
/* QL:         bra.s   M170_ch_next */
    bra.s M170_ch_next
/* QL: M170_s_retry */
M170_s_retry:
/* QL: *       clr.w   M170_bv_stopn(a6)    set to zero for return  $$$ why ? $$$ */
/* QL:         move.w  M170_bv_cnlno(a6),M170_bv_nxlin(a6) copy line number to continue after */
    move.w M170_bv_cnlno(a6),M170_bv_nxlin(a6)
/* QL:         move.b  M170_bv_cnstm(a6),M170_bv_nxstm(a6) copy statement to continue after */
    move.b M170_bv_cnstm(a6),M170_bv_nxstm(a6)
/* QL:         move.w  #-1,M170_bv_cnlno(a6) and reset the continue linum for next time */
    move.w #(-1),M170_bv_cnlno(a6)
/* QL:         move.b  M170_bv_cninl(a6),M170_bv_inlin(a6) copy old inline flag */
    move.b M170_bv_cninl(a6),M170_bv_inlin(a6)
/* QL:         move.w  M170_bv_cnind(a6),M170_bv_index(a6) copy old index variable */
    move.w M170_bv_cnind(a6),M170_bv_index(a6)
/* QL: M170_retry_1 */
M170_retry_1:
/* QL:         sf      M170_bv_comln(a6)    don't save */
    sf M170_bv_comln(a6)
/* QL:         bra.s   M170_ok_rts */
    bra.s M170_ok_rts
/* QL: M170_ch_loop */
M170_ch_loop:
/* QL:         move.l  0(a6,a2.l),d0   read channel id */
    move.l 0(a6,a2.l),d0
/* QL:         blt.s   M170_ch_add          it's closed already */
    blt.s M170_ch_add
/* QL:         move.l  d0,a0 */
    move.l d0,a0
/* QL:         moveq   #M170_io.close,d0 */
    moveq #M170_io.close,d0
/* QL:         trap    #2              close it */
    trap #2
/* QL: M170_ch_add */
M170_ch_add:
/* QL:         add.w   #M170_ch.lench,a2    move to next channel block */
    add.w #M170_ch.lench,a2
/* QL: M170_ch_next */
M170_ch_next:
/* QL:         cmp.l   a3,a2           any channels left? */
    cmp.l a3,a2
/* QL:         blt.s   M170_ch_loop */
    blt.s M170_ch_loop
/* QL:         moveq   #-1,d1 */
    moveq #(-1),d1
/* QL:         moveq   #-1,d2 */
    moveq #(-1),d2
/* QL:         moveq   #M170_mt.dmode,d0    find the current display mode */
    moveq #M170_mt.dmode,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         moveq   #M170_mt.dmode,d0    and reset it to clear attributes */
    moveq #M170_mt.dmode,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         jsr     bp_lszap(pc)    wipe out list info */
    jsr bp_lszap(pc)
/* QL:         bsr.l   ib_clvv         clear the VV table and reset data */
    bsr.w ib_clvv
/* QL:         tas     d0              set d0.l to 128, minimal BF size */
    tas d0
/* QL:         add.l   (a6),d0 */
    add.l (a6),d0
/* QL:         moveq   #M170_bv_pfp,d1 */
    moveq #M170_bv_pfp,d1
/* QL: M170_zappf */
M170_zappf:
/* QL:         move.l  d0,0(a6,d1.w)   zap TK and PF */
    move.l d0,0(a6,d1.w)
/* QL:         subq.w  #4,d1 */
    subq.w #4,d1
/* QL:         bne.s   M170_zappf */
    bne.s M170_zappf
/* QL:         jsr     bv_names(pc)    clear all but mcprocs, mcfns */
    jsr bv_names(pc)
/* QL:         bra.s   M170_retry_1         never do rest of command line (names gone) */
    bra.s M170_retry_1
/* QL:         vect4000 M170_ib_new */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ ib$new,(M170_ib_new-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
