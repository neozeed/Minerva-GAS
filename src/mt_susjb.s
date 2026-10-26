/* ROM section mt_susjb */
.balign 2,0
/* QL: * d0 -  o- error return */
/* QL: * d1 -i o- job id (-1 = self) */
/* QL: * d2 -ip - new priority */
/* QL: * a0 -  o- base address of job */
/* QL: * a6 -ip - base address of system variables */
/* QL: mt_prior */
mt_prior:
/* QL:         jsr     ss_jobx(pc)     check if job exists */
    jsr ss_jobx(pc)
/* QL:         move.b  d2,M29_jb_princ(a0) set new priority */
    move.b d2,M29_jb_princ(a0)
/* QL:         bne.s   M29_exit_ok         is priority zero */
    bne.s M29_exit_ok
/* QL:         sf      M29_jb_prior(a0)    ... yes - kill it */
    sf M29_jb_prior(a0)
/* QL:         bra.s   M29_exit_ok */
    bra.s M29_exit_ok
/* QL: * d0 -  o- error return */
/* QL: * d1 -i o- job id (-1 = self) */
/* QL: * d2 -ip - new priority */
/* QL: * d3 -ip - timeout (anything but zero is wait for completion) */
/* QL: * a0 -  o- base address of job */
/* QL: * a6 -ip - base address of system variables */
/* QL: * a3 destroyed iff d3 <> 0 */
/* QL: mt_activ */
mt_activ:
/* QL:         jsr     ss_jobx(pc)     check if job exists */
    jsr ss_jobx(pc)
/* QL:         moveq   #M29_err.nc,d0 */
    moveq #M29_err.nc,d0
/* QL:         tst.b   M29_jb_princ(a0)    is job active? */
    tst.b M29_jb_princ(a0)
/* QL:         bne.s   M29_re_sched        yes - can't do it twice! */
    bne.s M29_re_sched
/* QL:         move.b  d2,M29_jb_princ(a0) */
    move.b d2,M29_jb_princ(a0)
/* QL:         move.l  M29_jb_start(a0),d7 do it have the facilty to be activated? */
    move.l M29_jb_start(a0),d7
/* QL:         ble.s   M29_re_sched        no - don't do anything silly! */
    ble.s M29_re_sched
/* QL:         move.l  d7,M29_jb_pc(a0)    set start address in saved pc */
    move.l d7,M29_jb_pc(a0)
/* QL:         tst.w   d3              is it wait on completion? */
    tst.w d3
/* QL:         beq.s   M29_exit_ok         ... no - just reschedule */
    beq.s M29_exit_ok
/* QL:         st      M29_jb_wflag(a0)    set job waiting flag */
    st M29_jb_wflag(a0)
/* QL:         jsr     ss_jobc(pc)     get current job id and address */
    jsr ss_jobc(pc)
/* QL:         move.l  d0,M29_jb_wjob(a0)  ... and set id of waiting job */
    move.l d0,M29_jb_wjob(a0)
/* QL:         move.w  #-2,M29_jb_stat(a3) ... then timeout */
    move.w #(-2),M29_jb_stat(a3)
/* QL: * note - when suspended jobs can be reactivated we could set d0 to M29_err.nc here */
/* QL: M29_exit_ok */
M29_exit_ok:
/* QL:         moveq   #0,d0           set no error */
    moveq #0,d0
/* QL: M29_re_sched */
M29_re_sched:
/* QL:         jmp     ss_reshd(pc)    ... and re-schedule */
    jmp ss_reshd(pc)
/* QL: * d0 -  o- error flag */
/* QL: * d1 -i o- job id (-1 = self) */
/* QL: * d3 -ip - timeout */
/* QL: * a0 -  o- address of job header */
/* QL: * a1 -ip - zero or address of hold flag byte */
/* QL: * a6 -ip - base address of system variables */
/* QL: mt_susjb */
mt_susjb:
/* QL:         jsr     ss_jobx(pc)     check job number */
    jsr ss_jobx(pc)
/* QL:         move.w  d3,M29_jb_stat(a0)  suspend */
    move.w d3,M29_jb_stat(a0)
/* QL:         move.l  a1,M29_jb_hold(a0)  and set hold */
    move.l a1,M29_jb_hold(a0)
/* QL:         bra.s   M29_exit_ok         no error */
    bra.s M29_exit_ok
/* QL: * d0 -  o- error flag */
/* QL: * d1 -i o- job id (-1 = self) */
/* QL: * a0 -  o- address of job header */
/* QL: * a6 -ip - base address of system variables */
/* QL: mt_reljb */
mt_reljb:
/* QL:         jsr     ss_jobx(pc)     check job number */
    jsr ss_jobx(pc)
/* QL:         tst.w   M29_jb_stat(a0)     is it suspended? */
    tst.w M29_jb_stat(a0)
/* QL:         beq.s   M29_exit_ok */
    beq.s M29_exit_ok
/* QL:         clr.w   M29_jb_stat(a0)     release it */
    clr.w M29_jb_stat(a0)
/* QL:         move.l  M29_jb_hold(a0),d0  and check if hold flag exists */
    move.l M29_jb_hold(a0),d0
/* QL:         beq.s   M29_exit_ok */
    beq.s M29_exit_ok
/* QL:         exg     d0,a0 */
    exg d0,a0
/* QL:         sf      (a0)            clear hold flag byte */
    sf (a0)
/* QL:         move.l  d0,a0 */
    move.l d0,a0
/* QL:         bra.s   M29_exit_ok */
    bra.s M29_exit_ok
/* QL:         end */
