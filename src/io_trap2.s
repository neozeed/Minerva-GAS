/* ROM section io_trap2 */
.balign 2,0
/* QL: io_trap2 */
io_trap2:
/* QL:         movem.l d7/a5-a6,-(sp)  save standard registers */
    movem.l d7/a5-a6,-(sp)
/* QL:         move.l  a7,d7 */
    move.l a7,d7
/* QL:         and.w   #$8000,d7 */
    and.w #0x8000,d7
/* QL:         move.l  d7,a6           do not assume there is only one screen */
    move.l d7,a6
/* QL:         moveq   #127,d7         ensure trap is positive byte only */
    moveq #127,d7
/* QL:         and.l   d7,d0 */
    and.l d7,d0
/* QL:         move.l  M18_sv_jbpnt(a6),a5 get current job pointer */
    move.l M18_sv_jbpnt(a6),a5
/* QL:         move.l  (a5),a5         ... thus base of job */
    move.l (a5),a5
/* QL:         bclr    d7,M18_jb_rela6(a5) clear and test relative addressing flag */
    bclr d7,M18_jb_rela6(a5)
/* QL:         beq.s   M18_trap_sel */
    beq.s M18_trap_sel
/* QL:         add.l   2*4(sp),a0      add a6 offset to address of name */
    add.l (2*4)(sp),a0
/* QL: M18_trap_sel */
M18_trap_sel:
/* QL: *       move.l  sp,a5           set trap level pointer to stack */
/* QL:         subq.b  #M18_io.open,d0 */
    subq.b #M18_io.open,d0
/* QL:         beq.s   M18_io_open */
    beq.s M18_io_open
/* QL:         assert  1,M18_io.close-M18_io.open,M18_io.formt-M18_io.close */
/* original assertion: 1,M18_io.close-M18_io.open,M18_io.formt-M18_io.close */
/* QL:         subq.b  #M18_io.formt-M18_io.open,d0 */
.word 20736|((((M18_io.formt-M18_io.open))&7)<<9)
/* QL:         bcs.s   M18_io_close */
    bcs.s M18_io_close
/* QL:         beq.s   M18_io_formt */
    beq.s M18_io_formt
/* QL:         subq.b  #M18_io.delet-M18_io.formt,d0 */
.word 20736|((((M18_io.delet-M18_io.formt))&7)<<9)
/* QL:         beq.s   M18_io_delet */
    beq.s M18_io_delet
/* QL:         moveq   #M18_err.bp,d0      oh dear! */
    moveq #M18_err.bp,d0
/* QL:         bra.s   M18_ssrte */
    bra.s M18_ssrte
/* QL: * d0 -  o- error code */
/* QL: * d1 -  o- drive number (msw) and number of good sectors (lsw) */
/* QL: * d2 -  o- total number of sectors */
/* QL: * a0 -i  - pointer to medium name */
/* QL: * a1 destroyed, though it needn't be */
/* QL: fmt_reg reg     d3-d6/a2-a4 */
/* QL: M18_io_formt */
M18_io_formt:
/* QL:         movem.l fmt_reg,-(sp) */
    movem.l d3-d6/a2-a4,-(sp)
/* QL:         jsr     io_fdriv(pc)    go look up a device driver for this name */
    jsr io_fdriv(pc)
/* QL:         blt.s   M18_fmtexit         driver not found */
    blt.s M18_fmtexit
/* QL:         bne.s   M18_fmtok           no physdef is ok */
    bne.s M18_fmtok
/* QL:         tst.b   M18_fs_files(a1)    any files M18_open on the medium? */
    tst.b M18_fs_files(a1)
/* QL:         beq.s   M18_fmtok           no - fine */
    beq.s M18_fmtok
/* QL:         move.l  M18_sv_chtop(a6),a1 get extension address */
    move.l M18_sv_chtop(a6),a1
/* QL:         tst.b   M18_sx_toe(a1)      are we to treate this as an error? */
    tst.b M18_sx_toe(a1)
/* QL:         bmi.s   M18_fmtok           nope, allow silly bug in dp's conqueror */
    bmi.s M18_fmtok
/* QL:         moveq   #M18_err.iu,d0      surely can't do it with files M18_open? (added lwr) */
    moveq #M18_err.iu,d0
/* QL:         bra.s   M18_fmtexit */
    bra.s M18_fmtexit
/* QL: M18_fmtok */
M18_fmtok:
/* QL:         move.l  a0,a1           oh me, oh my. why does is have to be in both? */
    move.l a0,a1
/* QL: *       movem.l (sp),d3-d4      should we really have to do this? (lwr) */
/* QL:         lea     -M18_sv_lio(a2),a3  set up base driver definition block */
    lea (-M18_sv_lio)(a2),a3
/* QL:         move.l  M18_ch_formt(a2),a4 */
    move.l M18_ch_formt(a2),a4
/* QL:         jsr     (a4) */
    jsr (a4)
/* QL: M18_fmtexit */
M18_fmtexit:
/* QL:         movem.l (sp)+,fmt_reg */
    movem.l (sp)+,d3-d6/a2-a4
/* QL:         bra.s   M18_ssrte */
    bra.s M18_ssrte
/* QL: * d0 -  o- error code (well... close calls should never say they fail!) */
/* QL: * a0 -i  - channel id */
/* QL: * a1 destroyed (though mt_close could save it...) */
/* QL: M18_io_close */
M18_io_close:
/* QL:         jsr     io_chanx(pc)    check that channel exists (a0->a5, chan->a0) */
    jsr io_chanx(pc)
/* QL:         jsr     mt_close(pc)    go do the closure */
    jsr mt_close(pc)
/* QL: M18_ssrte */
M18_ssrte:
/* QL:         jmp     ss_rte(pc) */
    jmp ss_rte(pc)
/* QL: * d0 -  o- error code */
/* QL: * d1 -  o- current job id */
/* QL: * a0 -i  - pointer to word length prefixed device/file name */
/* QL: * d3/a1 destroyed */
/* QL: M18_io_delet */
M18_io_delet:
/* QL:         move.l  a0,a1           save address of name */
    move.l a0,a1
/* QL:         jsr     ss_joby(pc)     get own job id in d1, address in a0 */
    jsr ss_joby(pc)
/* QL:         exg     a0,a1           address of job goes to a1 */
    exg a1,a0
/* QL:         st      d3              d3 key for delete */
    st d3
/* QL:         jsr     io_fopen(pc)    delete file */
    jsr io_fopen(pc)
/* QL:         bra.s   M18_ssrte */
    bra.s M18_ssrte
/* QL: * d0 -  o- error code */
/* QL: * d1 -i o- job id (real one on output) */
/* QL: * d3 -ip - access code */
/* QL: * a0 -i o- filename / cahnnelid */
/* QL: * a1 destroyed */
/* QL: op_save reg     a0/a2-a4 */
/* QL: opn_reg reg     d1-d6/a1-a3/a6  M18_open allowed to destroy all regs, as per doc! */
/* QL: M18_io_open */
M18_io_open:
/* QL:         move.l  a0,a1           save address of name */
    move.l a0,a1
/* QL:         jsr     ss_jobx(pc)     check if job exists (no return on failure) */
    jsr ss_jobx(pc)
/* QL:         exg     a0,a1           address of job goes to a1 */
    exg a1,a0
/* QL:         movem.l op_save,-(sp)   save a few registers to be used here */
    movem.l a0/a2-a4,-(sp)
/* QL:         moveq   #M18_err.no,d0      out of room / select sys_tag table */
    moveq #M18_err.no,d0
/* QL:         lea     M18_sv_chbas(a6),a4 this is the table to look in */
    lea M18_sv_chbas(a6),a4
/* QL:         jsr     ss_tag(pc)      look for new channel slot */
    jsr ss_tag(pc)
/* QL:         bmi.s   M18_exit_op         couldn't find a new slot */
    bmi.s M18_exit_op
/* QL:         move.l  d0,(sp)         set new channel id (maybe) */
    move.l d0,(sp)
/* QL:         lea     M18_sv_drlst(a6),a2 get address of first device driver */
    lea M18_sv_drlst(a6),a2
/* QL: M18_chk_next */
M18_chk_next:
/* QL:         move.l  (a2),a2         try next driver */
    move.l (a2),a2
/* QL:         move.l  a2,d0 */
    move.l a2,d0
/* QL:         beq.s   M18_chk_file */
    beq.s M18_chk_file
/* QL: M18_chk_loop */
M18_chk_loop:
/* QL:         movem.l opn_reg,-(sp) */
    movem.l d1-d6/a1-a3/a6,-(sp)
/* QL:         lea     -M18_sv_lio(a2),a3  set base of driver definition block */
    lea (-M18_sv_lio)(a2),a3
/* QL:         move.l  M18_ch_open(a2),a4  indirect */
    move.l M18_ch_open(a2),a4
/* QL:         jsr     (a4)            try opening this device type */
    jsr (a4)
/* QL:         movem.l (sp)+,opn_reg */
    movem.l (sp)+,d1-d6/a1-a3/a6
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         beq.s   M18_open            was channel opened */
    beq.s M18_open
/* QL:         cmp.w   #M18_err.nf,d0      check if error was 'not found' */
    cmp.w #M18_err.nf,d0
/* QL:         beq.s   M18_chk_next        that was ok */
    beq.s M18_chk_next
/* QL: M18_exit_op */
M18_exit_op:
/* QL:         movem.l (sp)+,op_save */
    movem.l (sp)+,a0/a2-a4
/* QL:         bra.s   M18_ssrte */
    bra.s M18_ssrte
/* QL: * Finally try the file system */
/* QL: M18_chk_file */
M18_chk_file:
/* QL:         moveq   #M18_err.bp,d0 */
    moveq #M18_err.bp,d0
/* QL:         cmp.b   #M18_io.dir,d3      check access key */
    cmp.b #(M18_io.dir&255),d3
/* QL:         bhi.s   M18_exit_op */
    bhi.s M18_exit_op
/* QL:         jsr     io_fopen(pc) */
    jsr io_fopen(pc)
/* QL:         bne.s   M18_exit_op */
    bne.s M18_exit_op
/* QL: M18_open */
M18_open:
/* QL:         move.l  a0,(a3)         set address of channel definition block */
    move.l a0,(a3)
/* QL:         addq.l  #4,a0           length of block is in header already */
    addq.l #4,a0
/* QL:         move.l  a2,(a0)+        put address of device driver in */
    move.l a2,(a0)+
/* QL:         move.l  d1,(a0)+        put job id in */
    move.l d1,(a0)+
/* QL:         move.l  a3,(a0)+        address of release flag */
    move.l a3,(a0)+
/* QL:         move.w  (sp),(a0)+      put tag in */
    move.w (sp),(a0)+
/* QL:         clr.w   (a0)+           status ok, no pending action */
    clr.w (a0)+
/* QL:         clr.l   (a0)+           no job waiting */
    clr.l (a0)+
/* QL:         bra.s   M18_exit_op */
    bra.s M18_exit_op
/* QL:         end */
