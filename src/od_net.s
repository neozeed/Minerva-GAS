/* ROM section od_net */
.balign 2,0
/* QL: od_net */
od_net:
/* QL:         dc.w    M109_io-* */
.balign 2,0
M109_dc_anchor_296:
.word ((M109_io-M109_dc_anchor_296))&65535
/* QL:         dc.w    M109_open-* */
.balign 2,0
M109_dc_anchor_300:
.word ((M109_open-M109_dc_anchor_300))&65535
/* QL:         dc.w    M109_close-* */
.balign 2,0
M109_dc_anchor_304:
.word ((M109_close-M109_dc_anchor_304))&65535
/* QL: M109_io */
M109_io:
/* QL:         jsr     io_relio(pc) */
    jsr io_relio(pc)
/* QL:         dc.w    M109_pend-* */
.balign 2,0
M109_dc_anchor_312:
.word ((M109_pend-M109_dc_anchor_312))&65535
/* QL:         dc.w    M109_fbyte-* */
.balign 2,0
M109_dc_anchor_316:
.word ((M109_fbyte-M109_dc_anchor_316))&65535
/* QL:         dc.w    M109_sbyte-* */
.balign 2,0
M109_dc_anchor_320:
.word ((M109_sbyte-M109_dc_anchor_320))&65535
/* QL: M109_open */
M109_open:
/* QL:         subq.l  #4,sp           make room for parameters */
    subq.l #4,sp
/* QL:         move.l  sp,a3 */
    move.l sp,a3
/* QL:         jsr     io_name(pc)     check name */
    jsr io_name(pc)
/* QL:         bra.s   M109_opn_exit        not net */
    bra.s M109_opn_exit
/* QL:         bra.s   M109_opn_exit        bad parameters */
    bra.s M109_opn_exit
/* QL:         bra.s   M109_open_net        ok! */
    bra.s M109_open_net
/* QL:         dc.w    3,'NET',2,2,'OI',' _',0 output or input, station  */
.balign 2,0
M109_dc_anchor_338:
.word 3
.byte 78,69,84
.balign 2,0
.word 2
.word 2
.byte 79,73
.balign 2,0
.byte 32,95
.balign 2,0
.word 0
/* QL: M109_open_net */
M109_open_net:
/* QL:         assert  0,M109_net_end&3 */
/* original assertion: 0,M109_net_end&3 */
/* QL:         moveq   #(M109_net_end+3)>>2,d1 */
    moveq #((M109_net_end+3)>>2),d1
/* QL:         lsl.w   #2,d1 */
    lsl.w #2,d1
/* QL:         jsr     mm_alchp(pc)    set up channel definition block */
    jsr mm_alchp(pc)
/* QL:         bne.s   M109_opn_exit        ... oops */
    bne.s M109_opn_exit
/* QL:         move.b  3(sp),M109_net_dest(a0) set destination */
    move.b 3(sp),M109_net_dest(a0)
/* QL:         move.b  M109_sv_netnr(a6),M109_net_self(a0) set self */
    move.b M109_sv_netnr(a6),M109_net_self(a0)
/* QL:         subq.w  #2,(sp)         out -1 (or -2), in zero */
    subq.w #2,(sp)
/* QL:         move.b  1(sp),M109_net_type(a0) set in or out */
    move.b 1(sp),M109_net_type(a0)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M109_opn_exit */
M109_opn_exit:
/* QL:         addq.l  #4,sp           remove parameters */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: * Close a network channel */
/* QL: M109_close */
M109_close:
/* QL:         tst.b   M109_net_type(a0)    is it an input or output channel */
    tst.b M109_net_type(a0)
/* QL:         bge.s   M109_release         ... input */
    bge.s M109_release
/* QL:         move.b  #1,M109_net_type(a0) ... output - set eof */
    move.b #(1&255),M109_net_type(a0)
/* QL:         move.b  M109_net_rpnt(a0),M109_net_nbyt(a0) and number of bytes */
    move.b M109_net_rpnt(a0),M109_net_nbyt(a0)
/* QL: M109_tst_mdv */
M109_tst_mdv:
/* QL:         tst.b   M109_sv_mdrun(a6)    is a microdrive running? */
    tst.b M109_sv_mdrun(a6)
/* QL:         bne.s   M109_tst_mdv         yes - wait */
    bne.s M109_tst_mdv
/* QL:         move.w  #1400,d4        keep on trying for about 15 seconds */
    move.w #1400,d4
/* QL: M109_cls_loop */
M109_cls_loop:
/* QL:         jsr     nd_spac(pc)     send the packet */
    jsr nd_spac(pc)
/* QL:         dbeq    d4,M109_cls_loop     and keep trying until gone */
    dbeq d4,M109_cls_loop
/* QL: M109_release */
M109_release:
/* QL:         jmp     mm_rechp(pc) */
    jmp mm_rechp(pc)
/* QL: M109_get_pak */
M109_get_pak:
/* QL:         sf      M109_net_rpnt(a0)    reset running pointer */
    sf M109_net_rpnt(a0)
/* QL:         jsr     nd_rpac(pc)     and get next block */
    jsr nd_rpac(pc)
/* QL:         bne.s   M109_exit */
    bne.s M109_exit
/* QL: M109_pend */
M109_pend:
/* QL:         move.b  M109_net_type(a0),d0 type should be read ok (0) or eof (1) */
    move.b M109_net_type(a0),d0
/* QL:         blt.s   M109_err_bp */
    blt.s M109_err_bp
/* QL:         clr.w   d2              set running pointer */
    clr.w d2
/* QL:         move.b  M109_net_rpnt(a0),d2 */
    move.b M109_net_rpnt(a0),d2
/* QL:         move.b  M109_net_data(a0,d2.w),d1 set next byte */
    move.b M109_net_data(a0,d2.w),d1
/* QL:         sub.b   M109_net_nbyt(a0),d2 check pointer against number of bytes */
    sub.b M109_net_nbyt(a0),d2
/* QL:         bcs.s   M109_exit_ok         ... buffer not empty */
    bcs.s M109_exit_ok
/* QL:         tst.b   d0              buffer empty - is it eof? */
    tst.b d0
/* QL:         beq.s   M109_get_pak         ... no - get a new buffer */
    beq.s M109_get_pak
/* QL:         moveq   #M109_err.ef,d0      ... yes - thats it */
    moveq #M109_err.ef,d0
/* QL:         rts */
    rts 
/* QL: M109_err_bp */
M109_err_bp:
/* QL:         moveq   #M109_err.bp,d0 */
    moveq #M109_err.bp,d0
/* QL:         rts */
    rts 
/* QL: * Fetch a byte from the network */
/* QL: M109_fbyte */
M109_fbyte:
/* QL:         bsr.s   M109_pend            anything pending? */
    bsr.s M109_pend
/* QL:         bne.s   M109_exit            ... no */
    bne.s M109_exit
/* QL:         addq.b  #1,M109_net_rpnt(a0) update pointer */
    addq.b #1,M109_net_rpnt(a0)
/* QL: M109_exit_ok */
M109_exit_ok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M109_exit */
M109_exit:
/* QL:         rts */
    rts 
/* QL: * Send a byte to the network */
/* QL: M109_sbyte */
M109_sbyte:
/* QL:         tst.b   M109_net_type(a0)    is it an output? */
    tst.b M109_net_type(a0)
/* QL:         bge.s   M109_err_bp          ... oh no it isn't */
    bge.s M109_err_bp
/* QL:         moveq   #1,d2           next M109_write to buffer position */
    moveq #1,d2
/* QL:         add.b   M109_net_rpnt(a0),d2 */
    add.b M109_net_rpnt(a0),d2
/* QL:         bcc.s   M109_write           is in the buffer */
    bcc.s M109_write
/* QL:         move.b  d1,-(sp) */
    move.b d1,-(sp)
/* QL:         assert  M109_net_type,M109_net_nbyt-1 */
/* original assertion: M109_net_type,M109_net_nbyt-1 */
/* QL:         move.w  #$00ff,M109_net_type(a0) set type and number of bytes */
    move.w #0x00ff,M109_net_type(a0)
/* QL:         jsr     nd_spac(pc)     send packet */
    jsr nd_spac(pc)
/* QL:         move.b  (sp)+,d1 */
    move.b (sp)+,d1
/* QL:         st      M109_net_type(a0)    restore type to M109_write */
    st M109_net_type(a0)
/* QL:         tst.l   d0              did it go? */
    tst.l d0
/* QL:         bne.s   M109_exit */
    bne.s M109_exit
/* QL:         moveq   #1,d2           set next byte pointer */
    moveq #1,d2
/* QL: M109_write */
M109_write:
/* QL:         move.b  d1,M109_net_data-1(a0,d2.w) set this byte */
    move.b d1,(M109_net_data-1)(a0,d2.w)
/* QL:         move.b  d2,M109_net_rpnt(a0) and pointer to next */
    move.b d2,M109_net_rpnt(a0)
/* QL:         bra.s   M109_exit_ok */
    bra.s M109_exit_ok
/* QL:         end */
