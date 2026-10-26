/* ROM section od_con */
.balign 2,0
/* QL: od_con */
od_con:
/* QL:         dc.w    M108_io-* */
.balign 2,0
M108_dc_anchor_685:
.word ((M108_io-M108_dc_anchor_685))&65535
/* QL:         dc.w    M108_open-* */
.balign 2,0
M108_dc_anchor_689:
.word ((M108_open-M108_dc_anchor_689))&65535
/* QL:         dc.w    M108_close-* */
.balign 2,0
M108_dc_anchor_693:
.word ((M108_close-M108_dc_anchor_693))&65535
/* QL: M108_open */
M108_open:
/* QL:         sub.w   #5*2,sp         make room on stack for parameters */
    sub.w #(5*2),sp
/* QL:         move.l  sp,a3           and point a3 to it */
    move.l sp,a3
/* QL:         jsr     io_name(pc)     check device name (con) */
    jsr io_name(pc)
/* QL:         bra.s   M108_scr             not found - try M108_open screen */
    bra.s M108_scr
/* QL:         bra.s   M108_opn_exit        bad parameter */
    bra.s M108_opn_exit
/* QL:         bra.s   M108_open_con        recognised!! */
    bra.s M108_open_con
/* QL: ;        if ntsc */
/* QL: ;        dc.w    3,'CON',5,' _',420,' X',160,' A',46,' X',0,' _',128 */
/* QL: ;        else */
/* QL:         dc.w    3,'CON',5,' _',448,' X',180,' A',32,' X',16,' _',128 */
.balign 2,0
M108_dc_anchor_714:
.word 3
.byte 67,79,78
.balign 2,0
.word 5
.byte 32,95
.balign 2,0
.word 448
.byte 32,88
.balign 2,0
.word 180
.byte 32,65
.balign 2,0
.word 32
.byte 32,88
.balign 2,0
.word 16
.byte 32,95
.balign 2,0
.word 128
/* QL: ;        endif */
/* QL: M108_open_con */
M108_open_con:
/* QL:         moveq   #M108_sd_end+M108_q_queue+2,d1 window def + key header + min 2 queue */
    moveq #((M108_sd_end+M108_q_queue)+2),d1
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.w  8(sp),d2        get queue length (-ve lengths as unsiged!) */
    move.w 8(sp),d2
/* QL:         add.l   d2,d1 */
    add.l d2,d1
/* QL:         bsr.s   M108_open_sub        M108_open channel and initialise */
    bsr.s M108_open_sub
/* QL:         bne.s   M108_opn_exit */
    bne.s M108_opn_exit
/* QL:         lea     M108_sd_end(a0),a2   find address of queue header */
    lea M108_sd_end(a0),a2
/* QL:         moveq   #M108_sd_end+M108_q_queue,d2 */
    moveq #(M108_sd_end+M108_q_queue),d2
/* QL:         sub.l   d2,d1           set actual length of queue */
    sub.l d2,d1
/* QL:         jsr     io_qsetl(pc)    set up queue header */
    jsr io_qsetl(pc)
/* QL:         lea     M108_sv_keyq(a6),a3  point to keyboard queue pointer */
    lea M108_sv_keyq(a6),a3
/* QL:         tst.l   (a3)            is this going to be the only queue? */
    tst.l (a3)
/* QL:         bne.s   M108_link_in         no - go slot it in with the rest */
    bne.s M108_link_in
/* QL:         move.l  a2,(a3)         make this the current queue (and link to self) */
    move.l a2,(a3)
/* QL: M108_link_in */
M108_link_in:
/* QL:         assert  M108_q_nextq,0 */
/* original assertion: M108_q_nextq,0 */
/* QL:         move.l  (a3),a3 */
    move.l (a3),a3
/* QL:         move.l  (a3),(a2)       move next queue pointer across */
    move.l (a3),(a2)
/* QL:         move.l  a2,(a3)         and link in */
    move.l a2,(a3)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         bra.s   M108_opn_exit */
    bra.s M108_opn_exit
/* QL: M108_scr */
M108_scr:
/* QL:         jsr     io_name(pc)     check name (M108_scr) */
    jsr io_name(pc)
/* QL:         bra.s   M108_opn_exit        not recognised */
    bra.s M108_opn_exit
/* QL:         bra.s   M108_opn_exit        bad parameters */
    bra.s M108_opn_exit
/* QL:         bra.s   M108_open_scr        recognised!! */
    bra.s M108_open_scr
/* QL: ;        if ntsc */
/* QL: ;        dc.w    3,'SCR',4,' _',420,' X',160,' A',46,' X',0 */
/* QL: ;        else */
/* QL:         dc.w    3,'SCR',4,' _',448,' X',180,' A',32,' X',16 */
.balign 2,0
M108_dc_anchor_794:
.word 3
.byte 83,67,82
.balign 2,0
.word 4
.byte 32,95
.balign 2,0
.word 448
.byte 32,88
.balign 2,0
.word 180
.byte 32,65
.balign 2,0
.word 32
.byte 32,88
.balign 2,0
.word 16
/* QL: ;        endif */
/* QL: M108_open_scr */
M108_open_scr:
/* QL:         moveq   #M108_sd_end+4,d1    window def + 1 dummy */
    moveq #(M108_sd_end+4),d1
/* QL:         bsr.s   M108_open_sub */
    bsr.s M108_open_sub
/* QL: M108_opn_exit */
M108_opn_exit:
/* QL:         add.w   #5*2,sp          remove parameters from stack */
    add.w #(5*2),sp
/* QL:         rts */
    rts 
/* QL: M108_open_sub */
M108_open_sub:
/* QL:         jsr     mm_alchp(pc)    allocate table space */
    jsr mm_alchp(pc)
/* QL:         bne.s   M108_ops_exit */
    bne.s M108_ops_exit
/* QL:         move.l  d1,-(sp)        save length allocated */
    move.l d1,-(sp)
/* QL:         sub.l   a1,a1 */
    sub.l a1,a1
/* QL:         move.l  a1,a2 */
    move.l a1,a2
/* QL:         jsr     sd_setfo(pc)    set fount pointers */
    jsr sd_setfo(pc)
/* QL:         addq.b  #4,M108_sd_icolr(a0) set ink colour to green */
    addq.b #4,M108_sd_icolr(a0)
/* QL:         tas     M108_sd_linel+1(a0)  set 128 bytes per line */
    tas (M108_sd_linel+1)(a0)
/* QL:         move.l  #$807<<16!100<<(15-7),M108_sd_scal(a0) initial scale 100.0 */
    move.l #((0x807<<16)|(100<<(15-7))),M108_sd_scal(a0)
/* QL:         assert  $20000,M108_ra_bot */
/* original assertion: $20000,M108_ra_bot */
/* QL:         assert  $8000,M108_ra_ssize */
/* original assertion: $8000,M108_ra_ssize */
/* QL:         jsr     ip_dspm(pc)     make sure M108_sx_dspm is up-to-date */
    jsr ip_dspm(pc)
/* QL:         move.b  M108_sx_dspm(a4),d0 */
    move.b M108_sx_dspm(a4),d0
/* QL:         addq.b  #M108_ra_bot>>16,M108_sd_scrb+1(a0) set base of first screen */
    addq.b #(M108_ra_bot>>16),(M108_sd_scrb+1)(a0)
/* QL:         move.l  M108_sv_jbpnt(a6),a1 */
    move.l M108_sv_jbpnt(a6),a1
/* QL:         move.l  (a1),a1 */
    move.l (a1),a1
/* QL:         move.w  a6,d1           are two screens available? */
    move.w a6,d1
/* QL:         btst    #0,M108_jb_rela6(a1) and is job default screen one? (lsb set) */
    btst #0,M108_jb_rela6(a1)
/* QL:         ble.s   M108_setscr0         no - then we're there */
    ble.s M108_setscr0
/* QL:         tas     M108_sd_scrb+2(a0)   set $28000, base of second screen */
    tas (M108_sd_scrb+2)(a0)
/* QL:         bra.s   M108_setscr1 */
    bra.s M108_setscr1
/* QL: M108_setscr0 */
M108_setscr0:
/* QL:         add.b   d0,d0           fetch up screen 0 bits */
    add.b d0,d0
/* QL: M108_setscr1 */
M108_setscr1:
/* QL:         move.b  M108_sv_mcsta(a6),-(sp) hold onto the current mode */
    move.b M108_sv_mcsta(a6),-(sp)
/* QL:         move.b  d0,M108_sv_mcsta(a6) replace temporarily with mode 4/8 as needed */
    move.b d0,M108_sv_mcsta(a6)
/* QL:         jsr     sd_modes(pc)    go set up mode dependent info */
    jsr sd_modes(pc)
/* QL:         clr.w   d2              no border */
    clr.w d2
/* QL:         lea     2+4+4(sp),a1    definition is on stack */
    lea ((2+4)+4)(sp),a1
/* QL:         jsr     sd_wdef(pc) */
    jsr sd_wdef(pc)
/* QL:         move.b  (sp)+,M108_sv_mcsta(a6) restore the current mode */
    move.b (sp)+,M108_sv_mcsta(a6)
/* QL:         move.l  (sp),d1         restore length allocated */
    move.l (sp),d1
/* QL:         move.l  d0,(sp)         save error key */
    move.l d0,(sp)
/* QL:         beq.s   M108_ops_pop         if not zero ... */
    beq.s M108_ops_pop
/* QL:         bsr.s   M108_rechp           ... release space allocated */
    bsr.s M108_rechp
/* QL: M108_ops_pop */
M108_ops_pop:
/* QL:         move.l  (sp)+,d0        restore error key */
    move.l (sp)+,d0
/* QL: M108_ops_exit */
M108_ops_exit:
/* QL:         rts */
    rts 
/* QL: M108_close */
M108_close:
/* QL:         lea     M108_sd_end(a0),a3   set pointer to keyboard queue */
    lea M108_sd_end(a0),a3
/* QL:         move.l  (a3),d1         is there one? */
    move.l (a3),d1
/* QL:         beq.s   M108_rechp */
    beq.s M108_rechp
/* QL:         sub.l   a2,a2           in case it's the only one */
    sub.l a2,a2
/* QL:         cmp.l   d1,a3           is it the only queue? */
    cmp.l d1,a3
/* QL:         beq.s   M108_new_q           yes - this'll sort it out */
    beq.s M108_new_q
/* QL:         move.l  a3,a2           now we need to unlink */
    move.l a3,a2
/* QL:         cmp.l   M108_sv_keyq(a6),a3  is this current queue? */
    cmp.l M108_sv_keyq(a6),a3
/* QL:         bne.s   M108_unlk_q          no - leave the cursor alone */
    bne.s M108_unlk_q
/* QL: M108_more_q */
M108_more_q:
/* QL:         move.l  (a2),a2         get next q */
    move.l (a2),a2
/* QL:         tst.b   M108_sd_curf-M108_sd_end(a2) is cursor of next queue active? */
    tst.b (M108_sd_curf-M108_sd_end)(a2)
/* QL:         bne.s   M108_new_q           ... yes - use it */
    bne.s M108_new_q
/* QL:         cmp.l   (a2),a3         was that the last? */
    cmp.l (a2),a3
/* QL:         bne.s   M108_more_q          ... no - keep looking */
    bne.s M108_more_q
/* QL: M108_new_q */
M108_new_q:
/* QL:         move.l  a2,M108_sv_keyq(a6)  set new queue */
    move.l a2,M108_sv_keyq(a6)
/* QL:         move.l  a3,a2 */
    move.l a3,a2
/* QL: M108_unlk_q */
M108_unlk_q:
/* QL:         move.l  (a2),a2         look at next queue */
    move.l (a2),a2
/* QL:         cmp.l   (a2),a3         does this point to queue to be closed? */
    cmp.l (a2),a3
/* QL:         bne.s   M108_unlk_q */
    bne.s M108_unlk_q
/* QL:         move.l  (a3),(a2)       link past this queue */
    move.l (a3),(a2)
/* QL: M108_rechp */
M108_rechp:
/* QL:         jsr     gw_floof(pc)    release any fill buffer! */
    jsr gw_floof(pc)
/* QL:         jmp     mm_rechp(pc)    release table space */
    jmp mm_rechp(pc)
/* QL: M108_io.bp equ 6 makes macro simpler */
.equ M108_io.bp,6
/* QL: M108_io_tabl macro */
/* QL:         M108_io_tabl pend fbyte fline fstrg edlin sbyte bp sstrg */
/* QL: M108_io_tabl */
M108_io_tabl:
/* QL: io_tabe setstr (M108_io_bp-$78) */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 1-1 M108_io.pend */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
M108_dc_anchor_971:
.byte (((M108_io_pend-(M108_io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 2-1 M108_io.fbyte */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
M108_dc_anchor_979:
.byte (((M108_io_fbyte-(M108_io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 3-1 M108_io.fline */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
M108_dc_anchor_987:
.byte (((M108_io_fline-(M108_io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 4-1 M108_io.fstrg */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
M108_dc_anchor_995:
.byte (((M108_io_fstrg-(M108_io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 5-1 M108_io.edlin */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
M108_dc_anchor_1003:
.byte (((M108_io_edlin-(M108_io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 6-1 M108_io.sbyte */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
M108_dc_anchor_1011:
.byte (((M108_io_sbyte-(M108_io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 7-1 M108_io.bp */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
M108_dc_anchor_1019:
.byte (((M108_io_bp-(M108_io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:         assert  [i]-1 io.[.parm([i])] */
/* original assertion: 8-1 M108_io.sstrg */
/* QL:         dc.b    (io_[.parm([i])]-[io_tabe])&$ffff force error if not positive */
M108_dc_anchor_1027:
.byte (((M108_io_sstrg-(M108_io_bp-0x78))&0xffff))&255
/* QL:  ifnum [i] < 8 goto l */
/* QL:         assert  8 [.nparms] */
/* original assertion: 8 8 */
/* QL: * First byte of next instruction is $78, which completes the above table with */
/* QL: * a ninth entry (for entry code $08) which also goes to io_bp. */
/* QL: M108_io */
M108_io:
/* QL:         moveq   #M108_sd.extop,d4    N.B. see above!!!! */
    moveq #M108_sd.extop,d4
/* QL:         assert  1,M108_sd.extop&7 */
/* original assertion: 1,M108_sd.extop&7 */
/* QL:         tst.b   d3 */
    tst.b d3
/* QL:         bne.s   M108_tst_stat */
    bne.s M108_tst_stat
/* QL:         bset    d4,M108_sd_flags(a0) set flag bit 1 on 1st entry */
    bset d4,M108_sd_flags(a0)
/* QL: M108_tst_stat */
M108_tst_stat:
/* QL:         tst.b   M108_sv_scrst(a6)    is screen frozen? */
    tst.b M108_sv_scrst(a6)
/* QL:         beq.s   M108_io_chk */
    beq.s M108_io_chk
/* QL:         moveq   #M108_err.nc,d0      yes - operation not complete */
    moveq #M108_err.nc,d0
/* QL:         rts */
    rts 
/* QL: M108_io_chk */
M108_io_chk:
/* QL:         bclr    d4,M108_sd_flags(a0) clear flag bit 1 if we get here */
    bclr d4,M108_sd_flags(a0)
/* QL:         sne     d7              iff it was set, set d7.b for 1st entry  */
    sne d7
/* QL:         cmp.b   d4,d0           check if normal serial i/o */
    cmp.b d4,d0
/* QL:         bhs.s   M108_io_dirct */
    bhs.s M108_io_dirct
/* QL:         move.w  d2,d5           set d5 to buffer length */
    move.w d2,d5
/* QL:         move.l  d1,d4           set d4 to character count (msw 0 for fline) */
    move.l d1,d4
/* QL:         cmp.b   #M108_io.sbyte,d0    check if an input operation */
    cmp.b #(M108_io.sbyte&255),d0
/* QL:         bcc.s   M108_io_jump         no - ok */
    bcc.s M108_io_jump
/* QL:         lea     M108_sd_end(a0),a2   find address of keyboard queue */
    lea M108_sd_end(a0),a2
/* QL:         tst.l   (a2)            check if input queue exists */
    tst.l (a2)
/* QL:         beq.s   M108_io_bp           no - bum */
    beq.s M108_io_bp
/* QL:         tst.b   d7              is this the first time to here? */
    tst.b d7
/* QL:         beq.s   M108_io_jump         no - don't try to switch queues */
    beq.s M108_io_jump
/* QL:         move.l  M108_sv_keyq(a6),a4  yes - get current input queue */
    move.l M108_sv_keyq(a6),a4
/* QL:         tst.b   M108_sd_curf-M108_sd_end(a4) is the cursor for this active? */
    tst.b (M108_sd_curf-M108_sd_end)(a4)
/* QL:         bne.s   M108_io_jump */
    bne.s M108_io_jump
/* QL:         move.l  a2,M108_sv_keyq(a6)  no - switch to this one */
    move.l a2,M108_sv_keyq(a6)
/* QL: M108_io_jump */
M108_io_jump:
/* QL:         move.l  a1,a4           buffer address in a4 */
    move.l a1,a4
/* QL:         move.b  M108_io_tabl(pc,d0.w),d0 find code for fancy entry points */
    move.b M108_io_tabl(pc,d0.w),d0
/* QL:         jmp     [io_tabe](pc,d0.w) */
.word 0x4efb
.word 0|(((M108_io_bp-0x78)-.)&255)
/* QL: M108_io_sbyte */
M108_io_sbyte:
/* QL:         cmp.b   #10,d1          is it newline */
    cmp.b #(10&255),d1
/* QL:         beq.s   M108_new_line */
    beq.s M108_new_line
/* QL:         tst.b   M108_sd_nlsta(a0)    check for out of range flag */
    tst.b M108_sd_nlsta(a0)
/* QL:         beq.s   M108_out_byt1 */
    beq.s M108_out_byt1
/* QL:         move.b  d1,-(sp) */
    move.b d1,-(sp)
/* QL:         bsr.s   M108_nl_sub */
    bsr.s M108_nl_sub
/* QL:         move.b  (sp)+,d1 */
    move.b (sp)+,d1
/* QL: M108_out_byt1 */
M108_out_byt1:
/* QL:         bsr.s   M108_sd_sbyte */
    bsr.s M108_sd_sbyte
/* QL:         beq.s   M108_rts_2           only error is out of range! */
    beq.s M108_rts_2
/* QL:         move.w  M108_sd_xinc(a0),d0  move the cursor across (not done if o/r) */
    move.w M108_sd_xinc(a0),d0
/* QL:         add.w   d0,M108_sd_xpos(a0) */
    add.w d0,M108_sd_xpos(a0)
/* QL:         assert  M108_sd..gchr,7 */
/* original assertion: M108_sd..gchr,7 */
/* QL:         tst.b   M108_sd_cattr(a0)    is this graphics (no auto nl?) */
    tst.b M108_sd_cattr(a0)
/* QL:         bmi.s   M108_out_exok */
    bmi.s M108_out_exok
/* QL:         move.b  #1,M108_sd_nlsta(a0) set implicit newline (rats! no reg byte > 0) */
    move.b #(1&255),M108_sd_nlsta(a0)
/* QL:         tst.b   M108_sd_curf(a0)     check if cursor visible */
    tst.b M108_sd_curf(a0)
/* QL:         beq.s   M108_out_exok        ... no it is alright */
    beq.s M108_out_exok
/* QL: M108_nl_sub */
M108_nl_sub:
/* QL:         bsr.s   M108_curoff          if cursor is visible, hide it */
    bsr.s M108_curoff
/* QL:         moveq   #0,d0           ensure no error... sd_newl preserves this */
    moveq #0,d0
/* QL:         jmp     sd_newl(pc) */
    jmp sd_newl(pc)
/* QL: M108_io_pend */
M108_io_pend:
/* QL:         jmp     io_qtest(pc)    check this queue */
    jmp io_qtest(pc)
/* QL: M108_io_sslop */
M108_io_sslop:
/* QL:         move.b  (a4)+,d1        get character */
    move.b (a4)+,d1
/* QL:         bsr.s   M108_io_sbyte        write it */
    bsr.s M108_io_sbyte
/* QL:         addq.w  #1,d4 */
    addq.w #1,d4
/* QL: M108_io_sstrg */
M108_io_sstrg:
/* QL:         cmp.w   d4,d5           end of buffer? */
    cmp.w d4,d5
/* QL:         bne.s   M108_io_sslop        nope - go send it */
    bne.s M108_io_sslop
/* QL:         bra.s   M108_io_ok */
    bra.s M108_io_ok
/* QL: M108_sd_sbyte */
M108_sd_sbyte:
/* QL:         moveq   #M108_io.sbyte,d0    send byte */
    moveq #M108_io.sbyte,d0
/* QL: M108_io_dirct */
M108_io_dirct:
/* QL:         jmp     sd_entry(pc)    use screen driver */
    jmp sd_entry(pc)
/* QL: M108_io_bp */
M108_io_bp:
/* QL:         moveq   #M108_err.bp,d0 */
    moveq #M108_err.bp,d0
/* QL:         bra.s   M108_io_mexit */
    bra.s M108_io_mexit
/* QL: M108_new_line */
M108_new_line:
/* QL:         tst.b   M108_sd_nlsta(a0)    test newline pending */
    tst.b M108_sd_nlsta(a0)
/* QL:         bge.s   M108_new_exp         ... it was not explicit before */
    bge.s M108_new_exp
/* QL:         bsr.s   M108_nl_sub          a new line was pending so do it */
    bsr.s M108_nl_sub
/* QL: M108_new_exp */
M108_new_exp:
/* QL:         st      M108_sd_nlsta(a0)    ... and this one is explicit */
    st M108_sd_nlsta(a0)
/* QL: M108_out_exok */
M108_out_exok:
/* QL:         moveq   #0,d0           no error - newline given or done */
    moveq #0,d0
/* QL: M108_rts_2 */
M108_rts_2:
/* QL:         rts */
    rts 
/* QL: M108_io_fbyte */
M108_io_fbyte:
/* QL:         lea     M108_sd_end(a0),a2   a2 is io_q.. queue pointer */
    lea M108_sd_end(a0),a2
/* QL:         jmp     io_qout(pc) */
    jmp io_qout(pc)
/* QL: M108_io_fslop */
M108_io_fslop:
/* QL:         bsr.s   M108_io_fbyte        get next character */
    bsr.s M108_io_fbyte
/* QL:         bne.s   M108_io_mexit        is it available? */
    bne.s M108_io_mexit
/* QL:         move.b  d1,(a4)+        put in buffer */
    move.b d1,(a4)+
/* QL:         addq.w  #1,d4 */
    addq.w #1,d4
/* QL: M108_io_fstrg */
M108_io_fstrg:
/* QL:         cmp.w   d4,d5           check for end of buffer */
    cmp.w d4,d5
/* QL:         bne.s   M108_io_fslop */
    bne.s M108_io_fslop
/* QL: M108_io_ok */
M108_io_ok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M108_io_mexit */
M108_io_mexit:
/* QL:         move.w  d4,d1           set character count */
    move.w d4,d1
/* QL:         move.l  a4,a1           save buffer pointer */
    move.l a4,a1
/* QL:         bclr    #M108_sd..gchr,M108_sd_cattr(a0) reset normal character positioning */
    bclr #M108_sd..gchr,M108_sd_cattr(a0)
/* QL:         rts */
    rts 
/* QL: M108_curoff */
M108_curoff:
/* QL:         tst.b   M108_sd_curf(a0) */
    tst.b M108_sd_curf(a0)
/* QL:         ble.s   M108_rts_2 */
    ble.s M108_rts_2
/* QL:         jmp     sd_curt(pc)     toggle the cursor */
    jmp sd_curt(pc)
/* QL: * During edlin/fline: */
/* QL: * d0 returned error code only */
/* QL: * d4.msw -1=edlin, 0=fline */
/* QL: * d4.lsw current count of valid chars in buffer ( < d5.lsw, except at end ) */
/* QL: * d5.msw not used (zero, at present) */
/* QL: * d5.lsw screen offset of start of buffer (-ve = off top of screen) */
/* QL: * d6.msw not used (undefined, could easily be 0) */
/* QL: * d6.lsw cursor position within buffer ( <= d4.lsw ) */
/* QL: * a0 chan / a2 queue ptr */
/* QL: * a4 start of buffer */
/* QL: * a5 stack M108_frame pointer to screen info */
/* QL: * d1-d3/a1-a3 destroyed */
/* QL: M108_io_edlin */
M108_io_edlin:
/* QL:         moveq   #-1,d4          for edlin set flag in msb of d4 */
    moveq #(-1),d4
/* QL: M108_io_fline        ;               n.b. ioss set d1.l to 0 before fline entry */
M108_io_fline:
/* QL:         move.l  d1,d6           get the cursor position */
    move.l d1,d6
/* QL:         swap    d6 */
    swap d6
/* QL:         move.w  d1,d4           to be safe, refuse chars > 32767 ... */
    move.w d1,d4
/* QL:         bmi.s   M108_io_bp */
    bmi.s M108_io_bp
/* QL:         cmp.w   d4,d5           ... or chars so far > buffer length ... */
    cmp.w d4,d5
/* QL:         blt.s   M108_io_bp */
    blt.s M108_io_bp
/* QL:         cmp.w   d6,d4           ... or cursor > chars so far */
    cmp.w d6,d4
/* QL:         bcs.s   M108_io_bp */
    bcs.s M108_io_bp
/* QL:         sub.w   d4,a4           reset buff pointer to base */
    sub.w d4,a4
/* QL:         move.w  d5,-(sp)        save buffer length */
    move.w d5,-(sp)
/* QL:         move.b  M108_sd_curf(a0),-(sp) save state of cursor */
    move.b M108_sd_curf(a0),-(sp)
/* QL:         tst.b   d7              is this the first time we've got this far? */
    tst.b d7
/* QL:         beq.s   M108_ed_next         no - skip this stuff */
    beq.s M108_ed_next
/* QL:         bsr.s   M108_curoff          if cursor is visible, hide it */
    bsr.s M108_curoff
/* QL:         jsr     sd_donl(pc)     *** this should probably be somewhere else */
    jsr sd_donl(pc)
/* QL: M108_ed_next */
M108_ed_next:
/* QL:         move.b  d7,d1           1st time in? */
    move.b d7,d1
/* QL:         bne.s   M108_ed_gotc         yes: use alt prefix as M108_redraw, nice for startup */
    bne.s M108_ed_gotc
/* QL:         bsr.s   M108_io_fbyte        fetch byte from input queue */
    bsr.s M108_io_fbyte
/* QL:         beq.s   M108_ed_gotc         something there */
    beq.s M108_ed_gotc
/* QL:         tst.b   (sp)            check state of cursor */
    tst.b (sp)
/* QL:         blt.s   M108_ed_exit         it is meant to be invisible */
    blt.s M108_ed_exit
/* QL:         move.l  d0,-(sp) */
    move.l d0,-(sp)
/* QL:         jsr     sd_cure(pc)     enable the cursor */
    jsr sd_cure(pc)
/* QL:         move.l  (sp)+,d0         */
    move.l (sp)+,d0
/* QL: M108_ed_exit */
M108_ed_exit:
/* QL:         add.w   d4,a4           set a4 to end of line */
    add.w d4,a4
/* QL:         move.w  d6,d1           save the cursor position */
    move.w d6,d1
/* QL:         swap    d1 */
    swap d1
/* QL:         addq.l  #4,sp           get rid of cursor status and save max len */
    addq.l #4,sp
/* QL:         bra.s   M108_io_mexit */
    bra.s M108_io_mexit
/* QL: M108_ed_gotc */
M108_ed_gotc:
/* QL:         bsr.s   M108_curoff          ensure cursor is off */
    bsr.s M108_curoff
/* QL: * create stack M108_frame with all details on current position and screen M108_size */
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         lea     M108_sd_xinc(a0),a1 */
    lea M108_sd_xinc(a0),a1
/* QL: M108_enqset */
M108_enqset:
/* QL:         move.l  d0,d2 */
    move.l d0,d2
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         moveq   #0,d5 */
    moveq #0,d5
/* QL:         move.w  M108_sd_xsize-M108_sd_xinc(a1),d5 */
    move.w (M108_sd_xsize-M108_sd_xinc)(a1),d5
/* QL:         move.w  M108_sd_xpos-M108_sd_xinc(a1),d0 */
    move.w (M108_sd_xpos-M108_sd_xinc)(a1),d0
/* QL:         bpl.s   M108_enqlft */
    bpl.s M108_enqlft
/* QL:         clr.w   d0              pull in from off left of screen */
    clr.w d0
/* QL: M108_enqlft */
M108_enqlft:
/* QL:         sub.w   d0,d5 */
    sub.w d0,d5
/* QL:         bpl.s   M108_enqrgt */
    bpl.s M108_enqrgt
/* QL:         add.w   d5,d0 */
    add.w d5,d0
/* QL:         clr.w   d5              pull in from off right of screen */
    clr.w d5
/* QL: M108_enqrgt */
M108_enqrgt:
/* QL:         divu    (a1),d0 */
    divu (a1),d0
/* QL:         move.w  d0,-(sp) */
    move.w d0,-(sp)
/* QL:         divu    (a1)+,d5 */
    divu (a1)+,d5
/* QL:         add.w   d5,d0 */
    add.w d5,d0
/* QL:         bne.s   M108_enqok */
    bne.s M108_enqok
/* QL:         moveq   #1,d0           protect against silly windows/cursors! */
    moveq #1,d0
/* QL: M108_enqok */
M108_enqok:
/* QL:         not.b   d3 */
    not.b d3
/* QL:         bne.s   M108_enqset */
    bne.s M108_enqset
/* QL: * d0=M108_dy/height, d2=M108_dx/M108_width, (sp)=row, 2(sp)=col */
/* QL:         move.w  (sp)+,d5        pick off row */
    move.w (sp)+,d5
/* QL:         mulu    d2,d5 */
    mulu d2,d5
/* QL:         move.w  (sp)+,a2        pick off col */
    move.w (sp)+,a2
/* QL:         add.w   a2,d5           M108_width*row+col = screen loc of cursor */
    add.w a2,d5
/* QL:         sub.w   d6,d5           screen loc of start of buff, signed */
    sub.w d6,d5
/* QL:         move.w  d2,d3 */
    move.w d2,d3
/* QL:         swap    d2 */
    swap d2
/* QL:         mulu    d0,d3 */
    mulu d0,d3
/* QL:         move.w  d3,d0 */
    move.w d3,d0
/* QL:         move.l  d0,-(sp)        save M108_dy,M108_size */
    move.l d0,-(sp)
/* QL:         assert  4,M108_dy,M108_size-2 */
/* original assertion: 4,M108_dy,M108_size-2 */
/* QL:         move.l  d2,-(sp)        save M108_width,M108_dx */
    move.l d2,-(sp)
/* QL:         assert  0,M108_width,M108_dx-2 */
/* original assertion: 0,M108_width,M108_dx-2 */
/* QL:         move.l  sp,a5           mark the M108_frame */
    move.l sp,a5
/* QL: * Stack M108_frame now active */
/* QL:         lea     M108_edittabl,a1 */
    lea M108_edittabl(pc),a1
/* QL: M108_ed_tloop */
M108_ed_tloop:
/* QL:         move.w  (a1)+,d0        fetch table bytes: msb=jmp/2, lsb=topchar */
    move.w (a1)+,d0
/* QL:         sub.b   d1,d0           is the character > lsb byte of entry? */
    sub.b d1,d0
/* QL:         bcs.s   M108_ed_tloop        yes, continue scan */
    bcs.s M108_ed_tloop
/* QL:         lsr.w   #8,d0           pull down execute vector byte */
    lsr.w #8,d0
/* QL:         add.b   d0,d0 */
    add.b d0,d0
/* QL:         subx.l  d7,d7           put delete flag into d7 ms bits */
    subx.l d7,d7
/* QL:         lea     0(a4,d6.w),a1   pointer to cursor byte */
    lea 0(a4,d6.w),a1
/* QL:         moveq   #' ',d2         for word searches */
    moveq #32,d2
/* QL:         move.w  d6,d7           set convenient initial value for d7.lsw */
    move.w d6,d7
/* QL:         jsr     M108_dis_base(pc,d0.w) go action the byte */
    jsr M108_dis_base(pc,d0.w)
/* QL:         bsr.s   M108_ed_exec1 */
    bsr.s M108_ed_exec1
/* QL:         addq.l  #M108_frame,sp       lose stack M108_frame */
    addq.l #M108_frame,sp
/* QL:         moveq   #M108_err.bo,d0      in case buffer has become full */
    moveq #M108_err.bo,d0
/* QL:         asl.l   #8,d7           clear 1st time flag and test exit flag */
    asl.l #8,d7
/* QL:         bvc.l   M108_ed_next         still all ones or zeroes, that's fine */
    bvc.w M108_ed_next
/* QL: M108_ed_exitp */
M108_ed_exitp:
/* QL:         bpl.s   M108_ed_exit         buffer is full */
    bpl.s M108_ed_exit
/* QL:         addq.w  #1,d4           terminator present */
    addq.w #1,d4
/* QL:         jsr     sd_curs(pc)     get rid of cursor */
    jsr sd_curs(pc)
/* QL:         bsr.l   M108_new_line  */
    bsr.w M108_new_line
/* QL:         clr.w   d6 */
    clr.w d6
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         bra.s   M108_ed_exitp */
    bra.s M108_ed_exitp
/* QL: M108_dis_base */
M108_dis_base:
/* QL: M108_dis_entr */
M108_dis_entr:
/* QL:         moveq   #10,d1          convert shift/enter to normal enter */
    moveq #10,d1
/* QL: M108_dis_endr */
M108_dis_endr:
/* QL:         move.b  d1,0(a4,d4.w)   store terminator in final byte */
    move.b d1,0(a4,d4.w)
/* QL:         bset    #31-8,d7        cause termination after positioning */
    bset #(31-8),d7
/* QL:         bra.s   M108_dis_allr        move cursor across rest of line */
    bra.s M108_dis_allr
/* QL: M108_dis_escp */
M108_dis_escp:
/* QL:         tst.l   d4 */
    tst.l d4
/* QL:         bmi.s   M108_dis_endr */
    bmi.s M108_dis_endr
/* QL:         bra.s   M108_dis_ignr        change up/down/esc to ignore for fline */
    bra.s M108_dis_ignr
/* QL: M108_dis_rowl */
M108_dis_rowl:
/* QL:         cmp.w   a2,d6 */
    cmp.w a2,d6
/* QL:         ble.s   M108_dis_escp */
    ble.s M108_dis_escp
/* QL:         sub.w   M108_width(a5),d7 */
    sub.w M108_width(a5),d7
/* QL:         bge.s   M108_dis_sbc */
    bge.s M108_dis_sbc
/* QL: M108_dis_alll */
M108_dis_alll:
/* QL:         clr.w   d7 */
    clr.w d7
/* QL:         bra.s   M108_dis_sbc */
    bra.s M108_dis_sbc
/* QL: M108_dis_rowr */
M108_dis_rowr:
/* QL:         add.w   d4,a2 */
    add.w d4,a2
/* QL:         sub.w   M108_width(a5),a2 */
    sub.w M108_width(a5),a2
/* QL:         cmp.w   a2,d6           is cursor going to go down off line with eod? */
    cmp.w a2,d6
/* QL:         bgt.s   M108_dis_escp        yes: go check for edlin termination */
    bgt.s M108_dis_escp
/* QL:         add.w   M108_width(a5),d7    move whole row */
    add.w M108_width(a5),d7
/* QL:         bra.s   M108_dis_rgt         go check if we need to trim it to eod */
    bra.s M108_dis_rgt
/* QL: M108_dis_onel */
M108_dis_onel:
/* QL:         beq.s   M108_dis_rts */
    beq.s M108_dis_rts
/* QL:         subq.w  #1,d7 */
    subq.w #1,d7
/* QL:         bra.s   M108_dis_sbc */
    bra.s M108_dis_sbc
/* QL: M108_dis_oner */
M108_dis_oner:
/* QL:         addq.w  #1,d7 */
    addq.w #1,d7
/* QL:         bra.s   M108_dis_rgt */
    bra.s M108_dis_rgt
/* QL: M108_dis_tabl */
M108_dis_tabl:
/* QL:         beq.s   M108_dis_rts */
    beq.s M108_dis_rts
/* QL:         subq.w  #1,d7 */
    subq.w #1,d7
/* QL:         bra.s   M108_dis_tabx */
    bra.s M108_dis_tabx
/* QL: M108_dis_tabr */
M108_dis_tabr:
/* QL:         addq.w  #8,d7 */
    addq.w #8,d7
/* QL: M108_dis_tabx */
M108_dis_tabx:
/* QL:         and.w   #-8,d7 */
    and.w #(-8),d7
/* QL: M108_dis_rgt */
M108_dis_rgt:
/* QL:         cmp.w   d4,d7 */
    cmp.w d4,d7
/* QL:         ble.s   M108_dis_sbc */
    ble.s M108_dis_sbc
/* QL: M108_dis_allr */
M108_dis_allr:
/* QL:         move.w  d4,d7 */
    move.w d4,d7
/* QL: M108_dis_ignr */
M108_dis_ignr:
/* QL: M108_dis_sbc */
M108_dis_sbc:
/* QL:         sub.w   d6,d7 */
    sub.w d6,d7
/* QL: M108_dis_rts */
M108_dis_rts:
/* QL:         rts */
    rts 
/* QL: M108_ed_exec1 */
M108_ed_exec1:
/* QL:         bra.s   M108_ed_exec */
    bra.s M108_ed_exec
/* QL: M108_dis_spac */
M108_dis_spac:
/* QL:         moveq   #' ',d1         change shift/space to ordinary space */
    moveq #32,d1
/* QL: M108_dis_char */
M108_dis_char:
/* QL:         bsr.s   M108_dis_allr        tail end char count */
    bsr.s M108_dis_allr
/* QL:         add.w   d7,a1           start at top of buffer */
    add.w d7,a1
/* QL:         bra.s   M108_ins_ent */
    bra.s M108_ins_ent
/* QL: M108_dis_wrdl */
M108_dis_wrdl:
/* QL: M108_wrdls */
M108_wrdls:
/* QL:         subq.w  #1,d7 */
    subq.w #1,d7
/* QL:         bcs.s   M108_wrdx */
    bcs.s M108_wrdx
/* QL:         cmp.b   -(a1),d2 */
    cmp.b -(a1),d2
/* QL:         beq.s   M108_wrdls */
    beq.s M108_wrdls
/* QL: M108_wrdln */
M108_wrdln:
/* QL:         subq.w  #1,d7 */
    subq.w #1,d7
/* QL:         bcs.s   M108_wrdx */
    bcs.s M108_wrdx
/* QL:         cmp.b   -(a1),d2 */
    cmp.b -(a1),d2
/* QL:         bne.s   M108_wrdln */
    bne.s M108_wrdln
/* QL:         addq.l  #1,a1 */
    addq.l #1,a1
/* QL:         bra.s   M108_wrdx */
    bra.s M108_wrdx
/* QL: M108_dis_wrdr */
M108_dis_wrdr:
/* QL:         bsr.s   M108_dis_allr */
    bsr.s M108_dis_allr
/* QL: M108_wrdrn */
M108_wrdrn:
/* QL:         subq.w  #1,d7 */
    subq.w #1,d7
/* QL:         bcs.s   M108_wrdx */
    bcs.s M108_wrdx
/* QL:         cmp.b   (a1)+,d2 */
    cmp.b (a1)+,d2
/* QL:         bne.s   M108_wrdrn */
    bne.s M108_wrdrn
/* QL: M108_wrdrs */
M108_wrdrs:
/* QL:         subq.w  #1,d7 */
    subq.w #1,d7
/* QL:         bcs.s   M108_wrdx */
    bcs.s M108_wrdx
/* QL:         cmp.b   (a1)+,d2 */
    cmp.b (a1)+,d2
/* QL:         beq.s   M108_wrdrs */
    beq.s M108_wrdrs
/* QL:         subq.l  #1,a1 */
    subq.l #1,a1
/* QL: M108_wrdx */
M108_wrdx:
/* QL:         move.w  a1,d7 */
    move.w a1,d7
/* QL:         sub.w   a4,d7 */
    sub.w a4,d7
/* QL:         bra.s   M108_dis_sbc */
    bra.s M108_dis_sbc
/* QL: M108_ins_lp */
M108_ins_lp:
/* QL:         move.b  -(a1),1(a1) */
    move.b -(a1),1(a1)
/* QL: M108_ins_ent */
M108_ins_ent:
/* QL:         dbra    d7,M108_ins_lp */
    dbra d7,M108_ins_lp
/* QL:         move.b  d1,(a1)         insert new char at cursor */
    move.b d1,(a1)
/* QL:         addq.w  #1,d4           add this into buffer count */
    addq.w #1,d4
/* QL:         move.w  d4,d7 */
    move.w d4,d7
/* QL:         add.w   d5,d7 */
    add.w d5,d7
/* QL:         move.w  d6,d0 */
    move.w d6,d0
/* QL:         add.w   d5,d0 */
    add.w d5,d0
/* QL:         bsr.s   M108_redraw1         write to end of data (or end of screen) */
    bsr.s M108_redraw1
/* QL:         moveq   #1,d7           force finish up with position right one */
    moveq #1,d7
/* QL:         rts                     if buffer is full it'll catch it after this */
    rts 
/* QL: M108_ed_exec */
M108_ed_exec:
/* QL:         tst.l   d7 */
    tst.l d7
/* QL:         bpl.s   M108_op_move */
    bpl.s M108_op_move
/* QL: * Delete */
/* QL:         move.w  d5,d3 */
    move.w d5,d3
/* QL:         add.w   d4,d3           offset to end of displayed/displayable data */
    add.w d4,d3
/* QL:         tst.w   d7              check distance for delete left/right */
    tst.w d7
/* QL:         bpl.s   M108_op_bdel */
    bpl.s M108_op_bdel
/* QL:         neg.w   d7              make delete left distance positive */
    neg.w d7
/* QL:         sub.w   d7,d6           new cursor for delete left */
    sub.w d7,d6
/* QL: M108_op_bdel */
M108_op_bdel:
/* QL:         sub.w   d7,d4           less chars in buffer */
    sub.w d7,d4
/* QL:         lea     0(a4,d6.w),a1   char destination */
    lea 0(a4,d6.w),a1
/* QL:         move.w  d4,d0 */
    move.w d4,d0
/* QL:         sub.w   d6,d0           chars to be shifted down in buffer */
    sub.w d6,d0
/* QL:         bra.s   M108_op_bdent */
    bra.s M108_op_bdent
/* QL: M108_op_bdlp */
M108_op_bdlp:
/* QL:         move.b  0(a1,d7.w),(a1)+ pack buffer chars down */
    move.b 0(a1,d7.w),(a1)+
/* QL: M108_op_bdent */
M108_op_bdent:
/* QL:         dbra    d0,M108_op_bdlp */
    dbra d0,M108_op_bdlp
/* QL:         move.w  d3,d7           set old eod */
    move.w d3,d7
/* QL:         move.w  d6,d0 */
    move.w d6,d0
/* QL:         add.w   d5,d0           start display here, maybe */
    add.w d5,d0
/* QL:         bpl.s   M108_redraw          ready now if cursor is staying on screen */
    bpl.s M108_redraw
/* QL:         not.w   d0 */
    not.w d0
/* QL:         ext.l   d0 */
    ext.l d0
/* QL:         divu    M108_width(a5),d0    rows that need pulling in, less one */
    divu M108_width(a5),d0
/* QL:         addq.w  #1,d0 */
    addq.w #1,d0
/* QL:         mulu    M108_width(a5),d0    total to adjust base by */
    mulu M108_width(a5),d0
/* QL:         add.w   d0,d5           pull base up */
    add.w d0,d5
/* QL:         move.w  d4,d3 */
    move.w d4,d3
/* QL:         add.w   d5,d3           new eod */
    add.w d5,d3
/* QL:         cmp.w   d3,d7           is it now further down than the old one? */
    cmp.w d3,d7
/* QL:         bge.s   M108_redeodok */
    bge.s M108_redeodok
/* QL:         move.w  d3,d7           yes, so use new eod */
    move.w d3,d7
/* QL: M108_redeodok */
M108_redeodok:
/* QL:         assert  2,M108_dy-M108_dx,M108_sd_ypos-M108_sd_xpos */
/* original assertion: 2,M108_dy-M108_dx,M108_sd_ypos-M108_sd_xpos */
/* QL:         move.l  M108_dx(a5),M108_sd_xpos(a0) */
    move.l M108_dx(a5),M108_sd_xpos(a0)
/* QL:         moveq   #M108_sd.scrtp,d0    clean up top row scrap, maybe */
    moveq #M108_sd.scrtp,d0
/* QL:         bsr.s   M108_scrxx */
    bsr.s M108_scrxx
/* QL: *       clr.w   d0              need to display from start of screen */
/* QL: M108_redraw1 */
M108_redraw1:
/* QL:         bra.s   M108_redraw */
    bra.s M108_redraw
/* QL: M108_op_move */
M108_op_move:
/* QL:         add.w   d7,d6           go straight to new cursor position */
    add.w d7,d6
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         move.w  d6,d1 */
    move.w d6,d1
/* QL:         add.w   d5,d1 */
    add.w d5,d1
/* QL:         bmi.s   M108_op_scrdn        have to scroll screen down to get cursor on */
    bmi.s M108_op_scrdn
/* QL:         clr.w   d0 */
    clr.w d0
/* QL:         sub.w   M108_size(a5),d1 */
    sub.w M108_size(a5),d1
/* QL:         blt.s   M108_op_noscr */
    blt.s M108_op_noscr
/* QL: * We need to display the cursor, so we'll have to scroll up some */
/* QL:         divu    M108_width(a5),d1 */
    divu M108_width(a5),d1
/* QL:         addq.w  #1,d1           this number of rows */
    addq.w #1,d1
/* QL:         bsr.s   M108_negscrol */
    bsr.s M108_negscrol
/* QL:         move.w  d1,d0 */
    move.w d1,d0
/* QL: M108_op_noscr */
M108_op_noscr:
/* QL:         move.w  M108_size(a5),d7 */
    move.w M108_size(a5),d7
/* QL:         add.w   d7,d0 */
    add.w d7,d0
/* QL:         bra.s   M108_redraw */
    bra.s M108_redraw
/* QL: M108_negscrol */
M108_negscrol:
/* QL:         neg.w   d1 */
    neg.w d1
/* QL: M108_scrol */
M108_scrol:
/* QL:         moveq   #M108_sd.scrol,d0 */
    moveq #M108_sd.scrol,d0
/* QL: M108_scrxx */
M108_scrxx:
/* QL:         move.w  d1,-(sp) */
    move.w d1,-(sp)
/* QL:         muls    M108_sd_yinc(a0),d1 */
    muls M108_sd_yinc(a0),d1
/* QL:         jsr     sd_scrol(pc)   do the scroll */
    jsr sd_scrol(pc)
/* QL:         move.w  (sp)+,d1 */
    move.w (sp)+,d1
/* QL:         muls    M108_width(a5),d1 */
    muls M108_width(a5),d1
/* QL:         add.w   d1,d5 */
    add.w d1,d5
/* QL:         rts */
    rts 
/* QL: M108_op_scrdn */
M108_op_scrdn:
/* QL:         not.w   d1 */
    not.w d1
/* QL:         divu    M108_width(a5),d1 */
    divu M108_width(a5),d1
/* QL:         addq.w  #1,d1           this number of rows */
    addq.w #1,d1
/* QL:         bsr.s   M108_scrol */
    bsr.s M108_scrol
/* QL: *       clr.w   d0 */
/* QL:         move.w  d1,d7 */
    move.w d1,d7
/* QL: *       bra.s   M108_redraw          draw that */
/* QL: * Draw any amount of the screen, includes final position to cursor */
/* QL: * d0 start screen offset */
/* QL: * d4 eod */
/* QL: * d5 buffer screen offset */
/* QL: * d6 cursor */
/* QL: * d7 end screen offset */
/* QL: M108_redraw */
M108_redraw:
/* QL:         move.w  d6,-(sp) */
    move.w d6,-(sp)
/* QL:         add.w   d5,d4 */
    add.w d5,d4
/* QL:         add.w   d5,d6 */
    add.w d5,d6
/* QL:         move.w  d4,d1 */
    move.w d4,d1
/* QL:         cmp.w   d6,d1           is cursor supposed to be at eod? */
    cmp.w d6,d1
/* QL:         beq.s   M108_redecur */
    beq.s M108_redecur
/* QL:         subq.w  #1,d1           no - so relax a bit (signed arith on this now!) */
    subq.w #1,d1
/* QL: M108_redecur */
M108_redecur:
/* QL:         sub.w   M108_size(a5),d1 */
    sub.w M108_size(a5),d1
/* QL:         add.w   M108_width(a5),d1 */
    add.w M108_width(a5),d1
/* QL:         ext.l   d1 */
    ext.l d1
/* QL:         divs    M108_width(a5),d1    we'd like to scroll up this many rows */
    divs M108_width(a5),d1
/* QL:         ext.l   d6 */
    ext.l d6
/* QL:         divs    M108_width(a5),d6    this is how many rows we can scroll up */
    divs M108_width(a5),d6
/* QL:         cmp.w   d6,d1 */
    cmp.w d6,d1
/* QL:         ble.s   M108_redscrl */
    ble.s M108_redscrl
/* QL:         move.w  d6,d1           at most, push cursor to top row */
    move.w d6,d1
/* QL: M108_redscrl */
M108_redscrl:
/* QL:         tst.w   d1 */
    tst.w d1
/* QL:         ble.s   M108_redscrex        either we couldn't, or didn't want to scroll! */
    ble.s M108_redscrex
/* QL:         move.w  d0,-(sp) */
    move.w d0,-(sp)
/* QL:         bsr.s   M108_negscrol */
    bsr.s M108_negscrol
/* QL:         move.w  (sp)+,d0 */
    move.w (sp)+,d0
/* QL:         add.w   d1,d0 */
    add.w d1,d0
/* QL:         add.w   d1,d4 */
    add.w d1,d4
/* QL:         move.w  d4,d7           we must now want to show to eod */
    move.w d4,d7
/* QL: M108_redscrex */
M108_redscrex:
/* QL:         move.w  d0,d6 */
    move.w d0,d6
/* QL:         bpl.s   M108_redent */
    bpl.s M108_redent
/* QL:         clr.w   d6 */
    clr.w d6
/* QL: M108_redloop */
M108_redloop:
/* QL:         cmp.w   M108_size(a5),d6 */
    cmp.w M108_size(a5),d6
/* QL:         bcc.s   M108_redlast */
    bcc.s M108_redlast
/* QL:         moveq   #5,d0           clear space at end */
    moveq #5,d0
/* QL:         lea     sd_clrxx(pc),a1 new call: lets us wipe space to paper colour */
    lea sd_clrxx(pc),a1
/* QL:         cmp.w   d4,d6 */
    cmp.w d4,d6
/* QL:         bge.s   M108_redgo           after eod must want clearing */
    bge.s M108_redgo
/* QL:         move.w  d6,d1 */
    move.w d6,d1
/* QL:         sub.w   d5,d1 */
    sub.w d5,d1
/* QL:         blt.s   M108_redgo           before start of data must want clearing */
    blt.s M108_redgo
/* QL:         lea     M108_sd_sbyte,a1 */
    lea M108_sd_sbyte(pc),a1
/* QL:         move.b  0(a4,d1.w),d1   get a real data byte to display */
    move.b 0(a4,d1.w),d1
/* QL: M108_redgo */
M108_redgo:
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.w  d6,d2 */
    move.w d6,d2
/* QL:         divu    M108_width(a5),d2 */
    divu M108_width(a5),d2
/* QL:         move.w  d2,d3 */
    move.w d2,d3
/* QL:         lea     M108_sd_yinc(a0),a2 */
    lea M108_sd_yinc(a0),a2
/* QL:         mulu    (a2),d3 */
    mulu (a2),d3
/* QL:         swap    d2 */
    swap d2
/* QL:         assert  M108_sd_xpos,M108_sd_ypos-2,M108_sd_xinc-4,M108_sd_yinc-6 */
/* original assertion: M108_sd_xpos,M108_sd_ypos-2,M108_sd_xinc-4,M108_sd_yinc-6 */
/* QL:         mulu    -(a2),d2 */
    mulu -(a2),d2
/* QL:         swap    d2 */
    swap d2
/* QL:         move.w  d3,d2 */
    move.w d3,d2
/* QL:         add.l   M108_dx(a5),d2 */
    add.l M108_dx(a5),d2
/* QL:         assert  M108_dx,M108_dy-2 */
/* original assertion: M108_dx,M108_dy-2 */
/* QL:         move.l  d2,-(a2)        store calculated cursor position */
    move.l d2,-(a2)
/* QL:         jsr     (a1)            clear char to paper, draw real char or get out */
    jsr (a1)
/* QL:         addq.w  #1,d6 */
    addq.w #1,d6
/* QL: M108_redent */
M108_redent:
/* QL:         cmp.w   d7,d6 */
    cmp.w d7,d6
/* QL:         blt.s   M108_redloop */
    blt.s M108_redloop
/* QL: M108_redlast */
M108_redlast:
/* QL:         lea     M108_redstop,a1 */
    lea M108_redstop(pc),a1
/* QL:         move.w  (sp)+,d6 */
    move.w (sp)+,d6
/* QL:         add.w   d5,d6 */
    add.w d5,d6
/* QL:         bra.s   M108_redgo */
    bra.s M108_redgo
/* QL: M108_redstop */
M108_redstop:
/* QL:         addq.l  #4,sp           discard return */
    addq.l #4,sp
/* QL:         sub.w   d5,d6 */
    sub.w d5,d6
/* QL:         sub.w   d5,d4 */
    sub.w d5,d4
/* QL:         cmp.w   M108_buflen(a5),d4   is the buffer full yet? */
    cmp.w M108_buflen(a5),d4
/* QL:         bne.s   M108_redok           no - we're ok */
    bne.s M108_redok
/* QL:         moveq   #1,d7 */
    moveq #1,d7
/* QL:         ror.l   #1,d7           $80000000 for buffer overflow */
    ror.l #1,d7
/* QL: M108_redok */
M108_redok:
/* QL:         rts */
    rts 
/* QL: M108_flg.del equ     $8000           flag for deletion (or initial re-display) */
.equ M108_flg.del,0x8000
/* QL: M108_flg.    equ     0               no flag */
.equ M108_flg.,0
/* QL: cno setnum 0 */
/* QL:  assert 0 (M108_dis_ignr-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_ignr-M108_dis_base)&$ff01 */
/* QL: ed macro chr,dis,del */
/* QL: M108_edittabl */
M108_edittabl:
/* QL:  ed $09 tabr */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (M108_dis_ignr-M108_dis_base)<<7!M108_flg.[del]!([chr]-1) */
.balign 2,0
M108_dc_anchor_1997:
.word (((((M108_dis_ignr-M108_dis_base)<<7)|M108_flg.)|(0x09-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_tabr-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2006:
.word (((((M108_dis_tabr-M108_dis_base)<<7)|M108_flg.)|0x09))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $0a entr */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_entr-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2018:
.word (((((M108_dis_entr-M108_dis_base)<<7)|M108_flg.)|0x0a))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $1b escp */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (M108_dis_ignr-M108_dis_base)<<7!M108_flg.[del]!([chr]-1) */
.balign 2,0
M108_dc_anchor_2025:
.word (((((M108_dis_ignr-M108_dis_base)<<7)|M108_flg.)|(0x1b-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_escp-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2034:
.word (((((M108_dis_escp-M108_dis_base)<<7)|M108_flg.)|0x1b))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $20 char */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (M108_dis_ignr-M108_dis_base)<<7!M108_flg.[del]!([chr]-1) */
.balign 2,0
M108_dc_anchor_2041:
.word (((((M108_dis_ignr-M108_dis_base)<<7)|M108_flg.)|(0x20-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: chr setnum $c0-1 */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_char-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2051:
.word (((((M108_dis_char-M108_dis_base)<<7)|M108_flg.)|191))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c0 onel */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_onel-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2063:
.word (((((M108_dis_onel-M108_dis_base)<<7)|M108_flg.)|0xc0))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c1 alll */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_alll-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2075:
.word (((((M108_dis_alll-M108_dis_base)<<7)|M108_flg.)|0xc1))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c2 onel del */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_onel-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2087:
.word (((((M108_dis_onel-M108_dis_base)<<7)|M108_flg.del)|0xc2))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c3 alll del */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_alll-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2099:
.word (((((M108_dis_alll-M108_dis_base)<<7)|M108_flg.del)|0xc3))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c4 wrdl */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_wrdl-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2111:
.word (((((M108_dis_wrdl-M108_dis_base)<<7)|M108_flg.)|0xc4))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c6 wrdl del */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (M108_dis_ignr-M108_dis_base)<<7!M108_flg.[del]!([chr]-1) */
.balign 2,0
M108_dc_anchor_2118:
.word (((((M108_dis_ignr-M108_dis_base)<<7)|M108_flg.del)|(0xc6-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_wrdl-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2127:
.word (((((M108_dis_wrdl-M108_dis_base)<<7)|M108_flg.del)|0xc6))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c8 oner */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (M108_dis_ignr-M108_dis_base)<<7!M108_flg.[del]!([chr]-1) */
.balign 2,0
M108_dc_anchor_2134:
.word (((((M108_dis_ignr-M108_dis_base)<<7)|M108_flg.)|(0xc8-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_oner-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2143:
.word (((((M108_dis_oner-M108_dis_base)<<7)|M108_flg.)|0xc8))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $c9 allr */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_allr-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2155:
.word (((((M108_dis_allr-M108_dis_base)<<7)|M108_flg.)|0xc9))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $ca oner del */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_oner-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2167:
.word (((((M108_dis_oner-M108_dis_base)<<7)|M108_flg.del)|0xca))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $cb allr del */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_allr-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2179:
.word (((((M108_dis_allr-M108_dis_base)<<7)|M108_flg.del)|0xcb))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $cc wrdr */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_wrdr-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2191:
.word (((((M108_dis_wrdr-M108_dis_base)<<7)|M108_flg.)|0xcc))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $ce wrdr del */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (M108_dis_ignr-M108_dis_base)<<7!M108_flg.[del]!([chr]-1) */
.balign 2,0
M108_dc_anchor_2198:
.word (((((M108_dis_ignr-M108_dis_base)<<7)|M108_flg.del)|(0xce-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_wrdr-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2207:
.word (((((M108_dis_wrdr-M108_dis_base)<<7)|M108_flg.del)|0xce))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $d0 rowl */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (M108_dis_ignr-M108_dis_base)<<7!M108_flg.[del]!([chr]-1) */
.balign 2,0
M108_dc_anchor_2214:
.word (((((M108_dis_ignr-M108_dis_base)<<7)|M108_flg.)|(0xd0-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_rowl-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2223:
.word (((((M108_dis_rowl-M108_dis_base)<<7)|M108_flg.)|0xd0))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $d8 rowr */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (M108_dis_ignr-M108_dis_base)<<7!M108_flg.[del]!([chr]-1) */
.balign 2,0
M108_dc_anchor_2230:
.word (((((M108_dis_ignr-M108_dis_base)<<7)|M108_flg.)|(0xd8-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_rowr-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2239:
.word (((((M108_dis_rowr-M108_dis_base)<<7)|M108_flg.)|0xd8))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $fc spac */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL:  dc.w (M108_dis_ignr-M108_dis_base)<<7!M108_flg.[del]!([chr]-1) */
.balign 2,0
M108_dc_anchor_2246:
.word (((((M108_dis_ignr-M108_dis_base)<<7)|M108_flg.)|(0xfc-1)))&65535
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_spac-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2255:
.word (((((M108_dis_spac-M108_dis_base)<<7)|M108_flg.)|0xfc))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $fd tabl */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_tabl-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2267:
.word (((((M108_dis_tabl-M108_dis_base)<<7)|M108_flg.)|0xfd))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $fe entr */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_entr-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2279:
.word (((((M108_dis_entr-M108_dis_base)<<7)|M108_flg.)|0xfe))&65535
/* QL: cno setnum [chr]+1 */
/* QL:  ed $ff ignr del ; alt cheats a bits. Initial entry uses it. Shorter macro def. */
/* QL:  ifnum [chr] = [cno] goto n */
/* QL: n maclab */
/* QL:  ifnum [chr] <> $20 goto g */
/* QL: g maclab */
/* QL:  assert 0 (dis_[dis]-M108_dis_base)&$ff01 */
/* original assertion: 0 (M108_dis_ignr-M108_dis_base)&$ff01 */
/* QL:  dc.w (dis_[dis]-M108_dis_base)<<7!M108_flg.[del]![chr] */
.balign 2,0
M108_dc_anchor_2291:
.word (((((M108_dis_ignr-M108_dis_base)<<7)|M108_flg.del)|0xff))&65535
/* QL: cno setnum [chr]+1 */
/* QL:         end */
