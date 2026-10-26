/* ROM section io_trap3 */
.balign 2,0
/* QL: * Preserves d2,d3,a0,a2,a3 and all non volatile registers */
/* QL: * Used to assume a6 was preserved by I/O routine, but it doesn't now. */
/* QL: * (The manual states that it should be preserved, but JS did save it, and hence */
/* QL: * some idiot distributed a nasty piece of sd.extop code that zapped it!) */
/* QL: io_trap3 */
io_trap3:
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
/* QL:         jsr     io_chanx(pc)    check a0 id, a0->a5 and chan->a0 */
    jsr io_chanx(pc)
/* QL:         tas     M19_ch_stat(a0)     is there a job waiting for completion? */
    tas M19_ch_stat(a0)
/* QL:         bne.s   M19_busy */
    bne.s M19_busy
/* QL: reglist reg     d2-d6/a2-a6 */
/* QL:         movem.l reglist,-(sp) */
    movem.l d2-d6/a2-a6,-(sp)
/* QL:         clr.l   -(sp)           make room for a1 offset */
    clr.l -(sp)
/* QL: M19_stack_d3 equ    4+4 */
.equ M19_stack_d3,(4+4)
/* QL: M19_stack_a6 equ    4+4*9 */
.equ M19_stack_a6,(4+(4*9))
/* QL: M19_stack   equ     4+4*10 */
.equ M19_stack,(4+(4*10))
/* QL:         cmp.b   #M19_fs.save,d0     is it an unknown key? */
    cmp.b #(M19_fs.save&255),d0
/* QL:         bgt.s   M19_get_job         yes */
    bgt.s M19_get_job
/* QL:         cmp.b   #M19_fs.heads,d0    is it header, load or save? */
    cmp.b #(M19_fs.heads&255),d0
/* QL:         bge.s   M19_clr_d1          yes */
    bge.s M19_clr_d1
/* QL:         cmp.b   #M19_io.sstrg,d0    is it a standard io op? */
    cmp.b #(M19_io.sstrg&255),d0
/* QL:         bgt.s   M19_get_job         no */
    bgt.s M19_get_job
/* QL:         btst    #1,d0           is it key 2,3,6 or 7? */
    btst #1,d0
/* QL:         beq.s   M19_get_job         no */
    beq.s M19_get_job
/* QL: M19_clr_d1 */
M19_clr_d1:
/* QL:         moveq   #0,d1           set initial number of bytes sent / fetched */
    moveq #0,d1
/* QL: M19_get_job */
M19_get_job:
/* QL:         move.l  M19_sv_jbpnt(a6),a3 get address of job */
    move.l M19_sv_jbpnt(a6),a3
/* QL:         move.l  (a3),a3 */
    move.l (a3),a3
/* QL:         bclr    #7,M19_jb_rela6(a3) test and clear msb of relative flag */
    bclr #7,M19_jb_rela6(a3)
/* QL:         beq.s   M19_go */
    beq.s M19_go
/* QL:         move.l  M19_stack+8(sp),(sp) get user value of a6 */
    move.l (M19_stack+8)(sp),(sp)
/* QL:         add.l   (sp),a1         make a1 absolute */
    add.l (sp),a1
/* QL: M19_go */
M19_go:
/* QL:         move.l  M19_ch_drivr(a0),a4 fetch address of driver */
    move.l M19_ch_drivr(a0),a4
/* QL:         move.b  d0,M19_ch_actn(a0)  save action */
    move.b d0,M19_ch_actn(a0)
/* QL:         moveq   #0,d3           this is first call for operation */
    moveq #0,d3
/* QL:         lea     -M19_sv_lio(a4),a3  set base address of definition block */
    lea (-M19_sv_lio)(a4),a3
/* QL:         move.l  M19_ch_inout(a4),a4 indirect */
    move.l M19_ch_inout(a4),a4
/* QL:         jsr     (a4)            M19_go */
    jsr (a4)
/* QL:         sub.l   (sp),a1         reset a1 to relative (if it was) */
    sub.l (sp),a1
/* QL:         addq.l  #-M19_err.nc,d0     was operation complete? */
.word 20608|((((-M19_err.nc))&7)<<9)
/* QL:         bne.s   M19_exit_don */
    bne.s M19_exit_don
/* QL:         move.w  M19_stack_d3+2(sp),d3 was immediate return requested? */
    move.w (M19_stack_d3+2)(sp),d3
/* QL:         bne.s   M19_wait */
    bne.s M19_wait
/* QL: M19_exit_don */
M19_exit_don:
/* QL:         subq.l  #-M19_err.nc,d0     put back proper error code */
.word 20864|((((-M19_err.nc))&7)<<9)
/* QL:         addq.l  #4,sp           get rid of a1 offset */
    addq.l #4,sp
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d2-d6/a2-a6
/* QL:         sf      M19_ch_stat(a0)     channel not in use */
    sf M19_ch_stat(a0)
/* QL: M19_exit */
M19_exit:
/* QL:         move.l  a5,a0           restore channel id */
    move.l a5,a0
/* QL:         jmp     ss_rte(pc) */
    jmp ss_rte(pc)
/* QL: M19_busy */
M19_busy:
/* QL:         tst.w   d3              is this an immediate return */
    tst.w d3
/* QL:         beq.s   M19_exit_nc         yes - return non-complete */
    beq.s M19_exit_nc
/* QL:         subq.l  #2,14(sp)       no - backspace pc by two */
    subq.l #2,14(sp)
/* QL:         bra.s   M19_re_sched        and re-schedule */
    bra.s M19_re_sched
/* QL: M19_exit_nc */
M19_exit_nc:
/* QL:         move.l  M19_sv_jbpnt(a6),a0 get address of job */
    move.l M19_sv_jbpnt(a6),a0
/* QL:         move.l  (a0),a0 */
    move.l (a0),a0
/* QL:         bclr    #7,M19_jb_rela6(a0) clear msb of relative flag */
    bclr #7,M19_jb_rela6(a0)
/* QL:         moveq   #M19_err.nc,d0 */
    moveq #M19_err.nc,d0
/* QL:         bra.s   M19_exit */
    bra.s M19_exit
/* QL: M19_wait */
M19_wait:
/* QL:         move.l  M19_stack_a6(sp),a6 restore a6 */
    move.l M19_stack_a6(sp),a6
/* QL:         jsr     ss_jobc(pc)     get job entry address and id */
    jsr ss_jobc(pc)
/* QL:         move.l  d0,M19_ch_jobwt(a0) and set id of waiting job */
    move.l d0,M19_ch_jobwt(a0)
/* QL:         lea     M19_ch_stat(a0),a0  get pointer to M19_wait flag (already $80) */
    lea M19_ch_stat(a0),a0
/* QL:         tst.l   (sp)+           check if this was a relative a1 call */
    tst.l (sp)+
/* QL:         bne.s   M19_mark_job */
    bne.s M19_mark_job
/* QL:         st      (a0)            set M19_wait flag (a1 abs) */
    st (a0)
/* QL: M19_mark_job */
M19_mark_job:
/* QL:         move.l  a0,M19_jb_hold(a3)  tell the scheduler where it is */
    move.l a0,M19_jb_hold(a3)
/* QL:         move.w  d3,M19_jb_stat(a3)  set M19_wait status */
    move.w d3,M19_jb_stat(a3)
/* QL:         sf      M19_jb_prior(a3)    reset priority */
    sf M19_jb_prior(a3)
/* QL:         moveq   #M19_err.nc,d0      restore error flag */
    moveq #M19_err.nc,d0
/* QL:         movem.l (sp)+,reglist   and registers */
    movem.l (sp)+,d2-d6/a2-a6
/* QL: M19_re_sched */
M19_re_sched:
/* QL:         move.l  a5,a0           restore channel id */
    move.l a5,a0
/* QL:         jmp     ss_reshd(pc)    re-schedule */
    jmp ss_reshd(pc)
/* QL:         end */
