/* ROM section od_pipe */
.balign 2,0
/* QL: od_pipe */
od_pipe:
/* QL:         dc.w    io_serq-* */
.balign 2,0
M107_dc_anchor_576:
.word ((io_serq-M107_dc_anchor_576))&65535
/* QL:         dc.w    M107_open-* */
.balign 2,0
M107_dc_anchor_580:
.word ((M107_open-M107_dc_anchor_580))&65535
/* QL:         dc.w    M107_close-* */
.balign 2,0
M107_dc_anchor_584:
.word ((M107_close-M107_dc_anchor_584))&65535
/* QL: M107_pop_exit */
M107_pop_exit:
/* QL:         add.l   d4,sp           remove parameters from stack */
    add.l d4,sp
/* QL: M107_rts0 */
M107_rts0:
/* QL:         rts */
    rts 
/* QL: M107_open */
M107_open:
/* QL:         lea     M107_sv_lio(a3),a4   keep driver definition link address */
    lea M107_sv_lio(a3),a4
/* QL:         moveq   #2*5,d4         N.B. this is preserved by io.name (and it's 10) */
    moveq #(2*5),d4
/* QL:         sub.l   d4,sp           make room on stack for parameters */
    sub.l d4,sp
/* QL:         move.l  sp,a3           and point a3 to it */
    move.l sp,a3
/* QL:         jsr     io_name(pc)     check device name */
    jsr io_name(pc)
/* QL:         bra.s   M107_pop_exit        not pipe */
    bra.s M107_pop_exit
/* QL:         bra.s   M107_pop_exit        bad parameters */
    bra.s M107_pop_exit
/* QL:         bra.s   M107_opn_pipe        ok! */
    bra.s M107_opn_pipe
/* QL:         dc.w    4,'PIPE',5,-1,0,3,'XTP',-1,0,' _',0,1,'K' */
.balign 2,0
M107_dc_anchor_614:
.word 4
.byte 80,73,80,69
.balign 2,0
.word 5
.word ((-1))&65535
.word 0
.word 3
.byte 88,84,80
.balign 2,0
.word ((-1))&65535
.word 0
.byte 32,95
.balign 2,0
.word 0
.word 1
.byte 75
.balign 2,0
/* QL: * d0 -i o- io key / error flag */
/* QL: * d1 -i o- IOSS */
/* QL: * d2 -i o- IOSS */
/* QL: * d3 -i  - IOSS */
/* QL: * a0 -ip - pointer to channel definition block */
/* QL: * a1 -i o- IOSS */
/* QL: * a2-a3 destroyed */
/* QL: io_serq */
io_serq:
/* QL:         lea     M107_ch_qin(a0),a2   get address of input queue */
    lea M107_ch_qin(a0),a2
/* QL:         move.l  d0,a3           save I/O command */
    move.l d0,a3
/* QL:         subq.b  #M107_io.fstrg,d0    is operation simple input? */
    subq.b #M107_io.fstrg,d0
/* QL:         bls.s   M107_test_q          yes - that's OK */
    bls.s M107_test_q
/* QL:         sub.b   #M107_fs.headr-M107_io.fstrg,d0 */
    sub.b #((M107_fs.headr-M107_io.fstrg)&255),d0
/* QL:         subq.b  #M107_fs.load-M107_fs.headr,d0 */
.word 20736|((((M107_fs.load-M107_fs.headr))&7)<<9)
/* QL:         bls.s   M107_test_q          fine - fs op is input */
    bls.s M107_test_q
/* QL:         addq.l  #M107_ch_qout-M107_ch_qin,a2 get address of output queue */
.word 20618|((((M107_ch_qout-M107_ch_qin))&7)<<9)
/* QL: M107_test_q */
M107_test_q:
/* QL:         move.l  (a2),a2         point to queue */
    move.l (a2),a2
/* QL:         move.l  a2,d0           does queue exist (address non zero) */
    move.l a2,d0
/* QL:         exg     a3,d0           restore command */
    exg a3,d0
/* QL:         beq.s   M107_err_bp          oops - no queue indeed */
    beq.s M107_err_bp
/* QL:         jsr     io_relio(pc)    simple serial io with relative pointers */
    jsr io_relio(pc)
/* QL:         dc.w    io_qtest-* */
.balign 2,0
M107_dc_anchor_671:
.word ((io_qtest-M107_dc_anchor_671))&65535
/* QL:         dc.w    io_qout-* */
.balign 2,0
M107_dc_anchor_675:
.word ((io_qout-M107_dc_anchor_675))&65535
/* QL:         dc.w    io_qin-* */
.balign 2,0
M107_dc_anchor_679:
.word ((io_qin-M107_dc_anchor_679))&65535
/* QL: M107_opn_pipe */
M107_opn_pipe:
/* QL:         movem.w (sp)+,d2/d5-d7  grab all the parameters bar last */
    movem.w (sp)+,d2/d5-d7
/* QL:         mulu    (sp)+,d4        1->10 for length in kilobytes */
    mulu (sp)+,d4
/* QL:         asl.l   d4,d7 */
    asl.l d4,d7
/* QL:         moveq   #-4,d4          start with input queue (so as not to zap eof) */
    moveq #(-4),d4
/* QL:         ror.b   #2,d5           put -xpt up in top two bits */
    ror.b #2,d5
/* QL:         beq.s   M107_old_pipe */
    beq.s M107_old_pipe
/* QL:         cmp.w   #5,(a0) */
    cmp.w #5,(a0)
/* QL:         beq.s   M107_special         got one of "pipex", "pipep" or "pipet" */
    beq.s M107_special
/* QL: M107_new_pipe */
M107_new_pipe:
/* QL:         subq.w  #M107_io.dir,d3 */
    subq.w #M107_io.dir,d3
/* QL:         bcc.s   M107_err_bp */
    bcc.s M107_err_bp
/* QL:         bsr.s   M107_alhead */
    bsr.s M107_alhead
/* QL:         bne.s   M107_rts0 */
    bne.s M107_rts0
/* QL: M107_newopen */
M107_newopen:
/* QL:         tst.w   d2 */
    tst.w d2
/* QL:         beq.s   M107_newnext */
    beq.s M107_newnext
/* QL:         lea     M107_idlink(a4),a2   point to base of linked list of id queues */
    lea M107_idlink(a4),a2
/* QL:         bra.s   M107_entry */
    bra.s M107_entry
/* QL: M107_lookup */
M107_lookup:
/* QL:         move.l  d1,a2 */
    move.l d1,a2
/* QL:         cmp.w   M107_pp_id(a2),d2    look for matching id */
    cmp.w M107_pp_id(a2),d2
/* QL:         beq.s   M107_gotit */
    beq.s M107_gotit
/* QL: M107_entry */
M107_entry:
/* QL:         move.l  (a2),d1 */
    move.l (a2),d1
/* QL:         bne.s   M107_lookup */
    bne.s M107_lookup
/* QL:         tst.l   d7 */
    tst.l d7
/* QL:         ble.s   M107_err_bp          must have a proper length now */
    ble.s M107_err_bp
/* QL:         move.l  a2,a1           save link pointer */
    move.l a2,a1
/* QL:         move.l  a0,a5           remember our channel */
    move.l a0,a5
/* QL:         bsr.s   M107_alqueue         much the same as old output pipe */
    bsr.s M107_alqueue
/* QL:         move.l  a5,a0           put channel back */
    move.l a5,a0
/* QL:         bne.s   M107_newfail */
    bne.s M107_newfail
/* QL:         st      M107_pp_tag(a2)      flag as new queue */
    st M107_pp_tag(a2)
/* QL:         move.l  a2,(a1)         tack onto end of linked list */
    move.l a2,(a1)
/* QL:         move.w  d2,M107_pp_id(a2)    store id */
    move.w d2,M107_pp_id(a2)
/* QL: M107_gotit */
M107_gotit:
/* QL:         move.l  a2,M107_ch_qout(a0,d4.w) store pipe */
    move.l a2,M107_ch_qout(a0,d4.w)
/* QL:         addq.w  #1,M107_pp_write(a2,d4.w) increment read/write */
    addq.w #1,M107_pp_write(a2,d4.w)
/* QL:         move.b  d5,d1 */
    move.b d5,d1
/* QL:         bpl.s   M107_newnext */
    bpl.s M107_newnext
/* QL:         add.b   d1,d1 */
    add.b d1,d1
/* QL:         move.b  d1,M107_pp_perm(a2) */
    move.b d1,M107_pp_perm(a2)
/* QL: M107_newnext */
M107_newnext:
/* QL:         exg     d2,d6 */
    exg d2,d6
/* QL:         addq.w  #4,d4 */
    addq.w #4,d4
/* QL:         beq.s   M107_newopen */
    beq.s M107_newopen
/* QL:         rts */
    rts 
/* QL: M107_err_bp */
M107_err_bp:
/* QL:         moveq   #M107_err.bp,d0 */
    moveq #M107_err.bp,d0
/* QL:         rts */
    rts 
/* QL: M107_alhead */
M107_alhead:
/* QL:         moveq   #M107_ch_qend,d1     reserve just enough space for channel header */
    moveq #M107_ch_qend,d1
/* QL: M107_alchp */
M107_alchp:
/* QL:         jmp     mm_alchp(pc)    allocate space */
    jmp mm_alchp(pc)
/* QL: M107_old_pipe */
M107_old_pipe:
/* QL:         move.w  d2,d6           as d5 was not set, d6 must have been zero */
    move.w d2,d6
/* QL:         bne.s   M107_new_pipe        default out=in, if id present */
    bne.s M107_new_pipe
/* QL:         tst.l   d7              check length of pipe */
    tst.l d7
/* QL:         ble.s   M107_open_in         -ve can happen!, so this is safe! */
    ble.s M107_open_in
/* QL:         bsr.s   M107_alqueue */
    bsr.s M107_alqueue
/* QL: M107_setqout */
M107_setqout:
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL: M107_setqio */
M107_setqio:
/* QL:         move.l  a2,M107_ch_qout(a0,d4.w) put pointer to queue in definition data */
    move.l a2,M107_ch_qout(a0,d4.w)
/* QL:         rts */
    rts 
/* QL: M107_special */
M107_special:
/* QL:         bsr.s   M107_alqueue         set up queue channel */
    bsr.s M107_alqueue
/* QL:         bne.s   M107_rts1            give up if no good */
    bne.s M107_rts1
/* QL:         bsr.s   M107_setqio          make it input */
    bsr.s M107_setqio
/* QL:         bsr.s   M107_setqout         make it output */
    bsr.s M107_setqout
/* QL:         assert  M107_q_eoff,M107_q_nextq,M107_q_end-4,M107_q_nextin-8,M107_q_nxtout-12 */
/* original assertion: M107_q_eoff,M107_q_nextq,M107_q_end-4,M107_q_nextin-8,M107_q_nxtout-12 */
/* QL:         subq.l  #1,(a2)+        mark as at eof immediately, and M107_special */
    subq.l #1,(a2)+
/* QL:         add.b   d5,d5 */
    add.b d5,d5
/* QL:         bcc.s   M107_specfail */
    bcc.s M107_specfail
/* QL:         bpl.s   M107_rts1            finished if "pipet", the throwaway pipe */
    bpl.s M107_rts1
/* QL:         lea     tb_multx+1,a1   point to end of multibasic module, plus one */
    lea (tb_multx+1)(pc),a1
/* QL:         move.l  a1,(a2)+        set M107_q_end */
    move.l a1,(a2)+
/* QL:         subq.l  #1,a1           point to actual end of module */
    subq.l #1,a1
/* QL:         move.l  a1,(a2)+        set M107_q_nextin */
    move.l a1,(a2)+
/* QL:         lea     tb_multi,a1     point to start of multibasic module */
    lea tb_multi(pc),a1
/* QL:         move.l  a1,(a2) */
    move.l a1,(a2)
/* QL:         sub.l   a2,a2 */
    sub.l a2,a2
/* QL: M107_setqio2 */
M107_setqio2:
/* QL:         bra.s   M107_setqio          "pipep" is read-only */
    bra.s M107_setqio
/* QL: M107_alqueue */
M107_alqueue:
/* QL:         moveq   #M107_ch_qend+M107_q_queue+1,d1 */
    moveq #((M107_ch_qend+M107_q_queue)+1),d1
/* QL:         add.l   d7,d1 */
    add.l d7,d1
/* QL:         bsr.s   M107_alchp */
    bsr.s M107_alchp
/* QL:         bne.s   M107_rts1 */
    bne.s M107_rts1
/* QL:         lea     M107_ch_qend(a0),a2  set up pointer to queue header */
    lea M107_ch_qend(a0),a2
/* QL:         move.l  d7,d1           pass length of pipe */
    move.l d7,d1
/* QL:         addq.l  #1,d1           including the extra byte for wrap effect */
    addq.l #1,d1
/* QL:         jsr     io_qsetl(pc)    set up queue */
    jsr io_qsetl(pc)
/* QL:         moveq   #0,d0           ensure ccr is z (d0 was already zero) */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M107_specfail */
M107_specfail:
/* QL:         moveq   #M107_err.bn,d0 */
    moveq #M107_err.bn,d0
/* QL: M107_newfail */
M107_newfail:
/* QL:         move.l  d0,d4 */
    move.l d0,d4
/* QL:         bsr.s   M107_close           drop failed channel */
    bsr.s M107_close
/* QL:         move.l  d4,d0 */
    move.l d4,d0
/* QL: M107_rts1 */
M107_rts1:
/* QL:         rts */
    rts 
/* QL: M107_open_in */
M107_open_in:
/* QL:         cmp.w   M107_sv_chmax(a6),d3 */
    cmp.w M107_sv_chmax(a6),d3
/* QL:         bhi.s   M107_err_bp          don't wander off end of channel table! */
    bhi.s M107_err_bp
/* QL:         lsl.w   #2,d3           fetch id */
    lsl.w #2,d3
/* QL:         move.l  M107_sv_chbas(a6),a2 base of channel table */
    move.l M107_sv_chbas(a6),a2
/* QL:         move.l  0(a2,d3.w),a2   pick up link channel */
    move.l 0(a2,d3.w),a2
/* QL:         move.l  a2,d1           is it ok? */
    move.l a2,d1
/* QL:         bmi.s   M107_err_bp          no good, it's closed! */
    bmi.s M107_err_bp
/* QL:         cmp.l   M107_ch_drivr(a2),a4 is this the same driver? */
    cmp.l M107_ch_drivr(a2),a4
/* QL: M107_err_bpne */
M107_err_bpne:
/* QL:         bne.s   M107_err_bp          nope - don't think that's a good idea! */
    bne.s M107_err_bp
/* QL:         add.w   #M107_ch_qin,a2      find the other queue */
    add.w #M107_ch_qin,a2
/* QL:         assert  M107_ch_qin,M107_ch_qout-4,M107_ch_qend-8 */
/* original assertion: M107_ch_qin,M107_ch_qout-4,M107_ch_qend-8 */
/* QL:         tst.l   (a2)+ */
    tst.l (a2)+
/* QL:         bne.s   M107_err_bpne        can't M107_open input to input! */
    bne.s M107_err_bpne
/* QL:         cmp.l   (a2)+,a2        proper old pipe? */
    cmp.l (a2)+,a2
/* QL:         bne.s   M107_err_bpne        no - complain */
    bne.s M107_err_bpne
/* QL:         moveq   #M107_err.iu,d0 */
    moveq #M107_err.iu,d0
/* QL:         tst.l   (a2)            check M107_q_nextq */
    tst.l (a2)
/* QL:         bne.s   M107_rts1            ouch! already linked to an input pipe */
    bne.s M107_rts1
/* QL:         bsr.l   M107_alhead */
    bsr.w M107_alhead
/* QL:         bne.s   M107_rts1 */
    bne.s M107_rts1
/* QL:         move.l  a0,(a2)         cross link the blocks */
    move.l a0,(a2)
/* QL:         bra.s   M107_setqio2 */
    bra.s M107_setqio2
/* QL: M107_close */
M107_close:
/* QL:         assert  M107_ch_qin,M107_ch_qout-4 */
/* original assertion: M107_ch_qin,M107_ch_qout-4 */
/* QL:         moveq   #-4,d3 */
    moveq #(-4),d3
/* QL:         bsr.s   M107_closeque        M107_close input connection */
    bsr.s M107_closeque
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         bsr.s   M107_closeque        M107_close output connection */
    bsr.s M107_closeque
/* QL: M107_delete */
M107_delete:
/* QL:         jmp     mm_rechp(pc) */
    jmp mm_rechp(pc)
/* QL: M107_closeque */
M107_closeque:
/* QL:         move.l  M107_ch_qout(a0,d3.w),d0 get queue pointer (qout, then qin) */
    move.l M107_ch_qout(a0,d3.w),d0
/* QL:         beq.s   M107_rts1 */
    beq.s M107_rts1
/* QL:         move.l  d0,a2 */
    move.l d0,a2
/* QL:         moveq   #-1,d1          M107_special queue marker */
    moveq #(-1),d1
/* QL:         cmp.l   (a2),d1 */
    cmp.l (a2),d1
/* QL:         beq.s   M107_rts1            no M107_special handling needed for M107_special queues */
    beq.s M107_rts1
/* QL:         tst.b   M107_pp_tag(a2) */
    tst.b M107_pp_tag(a2)
/* QL:         bmi.s   M107_closrdwr        go handle new id pipes */
    bmi.s M107_closrdwr
/* QL:         move.l  d3,d0 */
    move.l d3,d0
/* QL:         bne.s   M107_close_in        note d0=0 if we stay here */
    bne.s M107_close_in
/* QL:         tst.l   (a2)            is output connected at the other end? */
    tst.l (a2)
/* QL:         beq.s   M107_rts1            no - we will M107_delete it */
    beq.s M107_rts1
/* QL:         addq.l  #4,sp           discard return, as we will keep the pipe */
    addq.l #4,sp
/* QL: M107_qeof */
M107_qeof:
/* QL:         jmp     io_qeof(pc)     mark as at end of file */
    jmp io_qeof(pc)
/* QL: M107_closrdwr */
M107_closrdwr:
/* QL:         assert  M107_pp_read,M107_pp_perm-2,M107_pp_write-4 */
/* original assertion: M107_pp_read,M107_pp_perm-2,M107_pp_write-4 */
/* QL:         subq.l  #1,M107_pp_write-2(a2,d3.w) dec read/write count */
    subq.l #1,(M107_pp_write-2)(a2,d3.w)
/* QL:         tst.l   M107_pp_perm(a2)     permanent or any writers? */
    tst.l M107_pp_perm(a2)
/* QL: M107_rtsne */
M107_rtsne:
/* QL:         bne.s   M107_rts1            yes - return, as we must keep this going */
    bne.s M107_rts1
/* QL:         lea     M107_sv_lio+M107_idlink(a3),a1 point at base of our linked list */
    lea (M107_sv_lio+M107_idlink)(a3),a1
/* QL:         exg     a2,a0 */
    exg a0,a2
/* QL:         jsr     ut_unlnk(pc)    unlink from our list (if it's still there!) */
    jsr ut_unlnk(pc)
/* QL:         exg     a2,a0 */
    exg a0,a2
/* QL:         bsr.s   M107_qeof            mark as at end of file */
    bsr.s M107_qeof
/* QL:         tst.w   M107_pp_read(a2)     any readers left? */
    tst.w M107_pp_read(a2)
/* QL:         bne.s   M107_rtsne           yes, so all done for the moment */
    bne.s M107_rtsne
/* QL: M107_delque */
M107_delque:
/* QL:         move.l  a0,a1 */
    move.l a0,a1
/* QL:         lea     -M107_ch_qend(a2),a0 */
    lea (-M107_ch_qend)(a2),a0
/* QL:         bsr.s   M107_delete */
    bsr.s M107_delete
/* QL:         move.l  a1,a0 */
    move.l a1,a0
/* QL:         rts */
    rts 
/* QL: M107_close_in */
M107_close_in:
/* QL:         tst.b   (a2) */
    tst.b (a2)
/* QL:         bmi.s   M107_delque          if eof is set, M107_delete the old output channel */
    bmi.s M107_delque
/* QL:         clr.l   (a2)            remove pointer to this block */
    clr.l (a2)
/* QL:         rts     */
    rts 
/* QL:         end */
