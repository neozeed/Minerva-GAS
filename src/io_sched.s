/* ROM section io_sched */
.balign 2,0
/* QL: * Check out a busy channel so see if the waiting job is still around */
/* QL: * a0 -ip - channel pointer to channel with non-zero M16_ch_stat */
/* QL: * a1 -  o- job header of waiting job, if ccr returned is z */
/* QL: * d0 destroyed (job number * 2^18 if ccr=z) */
/* QL: io_jbchk */
io_jbchk:
/* QL:         move.l  M16_ch_jobwt(a0),d0 fetch job number */
    move.l M16_ch_jobwt(a0),d0
/* QL:         lsl.w   #2,d0 */
    lsl.w #2,d0
/* QL:         move.l  M16_sv_jbbas(a6),a1 */
    move.l M16_sv_jbbas(a6),a1
/* QL:         add.w   d0,a1           job table address */
    add.w d0,a1
/* QL:         tst.b   (a1)            is it still there? */
    tst.b (a1)
/* QL:         bmi.s   M16_rts0            while we waited for io, job went */
    bmi.s M16_rts0
/* QL:         move.l  (a1),a1         find base of job */
    move.l (a1),a1
/* QL:         swap    d0              check tag */
    swap d0
/* QL:         sub.w   M16_jb_tag(a1),d0 */
    sub.w M16_jb_tag(a1),d0
/* QL: M16_rts0 */
M16_rts0:
/* QL:         rts */
    rts 
/* QL: * This was altered to scan all channels each time, but buttons caused problems. */
/* QL: * d0-d7/a0-a5 destroyed */
/* QL: io_sched */
io_sched:
/* QL:         assert  M16_sv_chmax-2,M16_sv_chpnt-4,M16_sv_chbas-8 */
/* original assertion: M16_sv_chmax-2,M16_sv_chpnt-4,M16_sv_chbas-8 */
/* QL:         movem.l M16_sv_chmax-2(a6),d7/a3-a4 get channel max, pointer and base */
    movem.l (M16_sv_chmax-2)(a6),d7/a3-a4
/* QL:         move.l  a3,a5           save current channel pointer */
    move.l a3,a5
/* QL: M16_chk_last */
M16_chk_last:
/* QL:         cmp.l   a4,a5           at marker? */
    cmp.l a4,a5
/* QL:         bne.s   M16_chk_chan        no, carry on */
    bne.s M16_chk_chan
/* QL:         lsl.w   #2,d7           multiply max by 4 (note: never all that large) */
    lsl.w #2,d7
/* QL:         bcs.s   M16_rts0            second marker, so get out now */
    bcs.s M16_rts0
/* QL:         lea     4(a5,d7.w),a5   start again at top of list */
    lea 4(a5,d7.w),a5
/* QL:         moveq   #-1,d7          set flag so we don't do this again */
    moveq #(-1),d7
/* QL:         move.l  a3,a4           marker now original pointer */
    move.l a3,a4
/* QL: M16_chk_chan */
M16_chk_chan:
/* QL:         move.l  -(a5),d0        is this vacant */
    move.l -(a5),d0
/* QL:         bmi.s   M16_chk_last        yes, skip it */
    bmi.s M16_chk_last
/* QL:         move.l  d0,a0 */
    move.l d0,a0
/* QL:         move.b  M16_ch_stat(a0),d4  is channel waiting for i/o */
    move.b M16_ch_stat(a0),d4
/* QL:         beq.s   M16_chk_last        no, forget it */
    beq.s M16_chk_last
/* QL: * A channel waiting on io has been found */
/* QL:         move.l  a5,M16_sv_chpnt(a6) reset current channel number */
    move.l a5,M16_sv_chpnt(a6)
/* QL:         bsr.s   io_jbchk        check out waiting job */
    bsr.s io_jbchk
/* QL:         bne.s   M16_job_gone        while we waited for io, job went! */
    bne.s M16_job_gone
/* QL: * A note: can we ever get caught out by a channel that appears to have a job */
/* QL: * waiting on it, but the job has actually got out of suspension somehow? */
/* QL:         moveq   #0,d6           initialise a1 offset as zero */
    moveq #0,d6
/* QL:         addq.b  #1,d4           was a1 an absolute address */
    addq.b #1,d4
/* QL:         beq.s   M16_offdone */
    beq.s M16_offdone
/* QL:         move.l  M16_jb_a0+6*4(a1),d6 no, so add job's a6 to a1, and remember */
    move.l (M16_jb_a0+(6*4))(a1),d6
/* QL: M16_offdone */
M16_offdone:
/* QL:         movem.l d6/a1,-(sp)     save offset and job pointer */
    movem.l d6/a1,-(sp)
/* QL:         moveq   #0,d0           clear msbs of d0 */
    moveq #0,d0
/* QL:         move.b  M16_ch_actn(a0),d0  ... and restore action key */
    move.b M16_ch_actn(a0),d0
/* QL:         moveq   #-1,d3          this is a repeat call */
    moveq #(-1),d3
/* QL:         movem.l M16_jb_d0+4(a1),d1-d2 restore ioss data regs */
    movem.l (M16_jb_d0+4)(a1),d1-d2
/* QL:         movem.l M16_jb_a0+4(a1),a1-a2 restore ioss address regs */
    movem.l (M16_jb_a0+4)(a1),a1-a2
/* QL:         add.l   d6,a1           add any offset to a1 */
    add.l d6,a1
/* QL:         move.l  M16_ch_drivr(a0),a4 get address of driver definition */
    move.l M16_ch_drivr(a0),a4
/* QL:         lea     -M16_sv_lio(a4),a3  set base address of definition */
    lea (-M16_sv_lio)(a4),a3
/* QL:         move.l  M16_ch_inout(a4),a4 get i/o entry point */
    move.l M16_ch_inout(a4),a4
/* QL:         jsr     (a4)            call it */
    jsr (a4)
/* QL:         sub.l   (sp)+,a1        remove offset from a1 */
    sub.l (sp)+,a1
/* QL:         move.l  (sp)+,a2        restore job pointer */
    move.l (sp)+,a2
/* QL:         movem.l d0-d1,M16_jb_d0(a2) save the updated d0 and d1 */
    movem.l d0-d1,M16_jb_d0(a2)
/* QL:         move.l  a1,M16_jb_a0+4(a2)  save the updated address reg a1 */
    move.l a1,(M16_jb_a0+4)(a2)
/* QL:         addq.l  #-M16_err.nc,d0     check if operation is now complete */
.word 20608|((((-M16_err.nc))&7)<<9)
/* QL:         beq.s   M16_rts1            skip if it's still not complete */
    beq.s M16_rts1
/* QL:         clr.w   M16_jb_stat(a2)     set status active */
    clr.w M16_jb_stat(a2)
/* QL: M16_job_gone */
M16_job_gone:
/* QL:         sf      M16_ch_stat(a0)     set status ok */
    sf M16_ch_stat(a0)
/* QL: M16_rts1 */
M16_rts1:
/* QL:         rts */
    rts 
/* QL:         end */
