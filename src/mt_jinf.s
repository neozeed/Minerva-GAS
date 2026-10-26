/* ROM section mt_jinf */
.balign 2,0
/* QL: * d0 -  o- 0 */
/* QL: * d1 -i o- job id / job id of next job in M26_tree */
/* QL: * d2 -i o- job number at top of M26_tree / job id of owner of requested job */
/* QL: * d3 -  o- msb status (-1 suspended) and lsb priority */
/* QL: * a0 -  o- base address of code of requested job (i.e. job header + M26_jb_end) */
/* QL: mt_jinf */
mt_jinf:
/* QL:         jsr     ss_jobx(pc)     does job exist?  (sets a0) */
    jsr ss_jobx(pc)
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         tst.w   M26_jb_stat(a0)     is job suspended */
    tst.w M26_jb_stat(a0)
/* QL:         beq.s   M26_set_prio */
    beq.s M26_set_prio
/* QL:         moveq   #-1,d3          yes - set suspended */
    moveq #(-1),d3
/* QL: M26_set_prio */
M26_set_prio:
/* QL:         move.b  M26_jb_princ(a0),d3 set priority */
    move.b M26_jb_princ(a0),d3
/* QL:         move.l  d2,d0           stop scanning at top of M26_tree */
    move.l d2,d0
/* QL:         move.l  a0,-(sp)        save job base address */
    move.l a0,-(sp)
/* QL:         bsr.s   M26_tree            ... and find next job */
    bsr.s M26_tree
/* QL:         move.l  (sp)+,a0        restore base address of this job */
    move.l (sp)+,a0
/* QL:         move.l  M26_jb_owner(a0),d2 ... find owner of this job */
    move.l M26_jb_owner(a0),d2
/* QL:         lea     M26_jb_end(a0),a0   ... and base address of job */
    lea M26_jb_end(a0),a0
/* QL:         jmp     ss_noer(pc) */
    jmp ss_noer(pc)
/* QL: * Scans a M26_tree of jobs - one each entry */
/* QL: * d0 -ip - job number at top of M26_tree (d0.w) */
/* QL: * d1 -i o- current job id / next job id (0 = end of M26_tree) */
/* QL: * d2 -  o- id of owner of next job */
/* QL: * a0 -  o- base address of next job */
/* QL: * a1 -  o- pointer to table entry for next job */
/* QL: M26_up_tree */
M26_up_tree:
/* QL:         moveq   #0,d1           next job is 0 */
    moveq #0,d1
/* QL:         cmp.w   d2,d0           are we already at top of M26_tree? */
    cmp.w d2,d0
/* QL:         beq.s   M26_rts0            yes - there are no more jobs in M26_tree */
    beq.s M26_rts0
/* QL:         move.w  d2,d1           find address of owner */
    move.w d2,d1
/* QL:         bsr.s   M26_find_add */
    bsr.s M26_find_add
/* QL:         beq.s   M26_rts0            silly! someone gave an invalid job as top! */
    beq.s M26_rts0
/* QL:         move.l  M26_jb_owner(a0),d2 get owner of owner */
    move.l M26_jb_owner(a0),d2
/* QL: M26_next_job */
M26_next_job:
/* QL:         addq.w  #1,d1           next job */
    addq.w #1,d1
/* QL:         cmp.w   M26_sv_jbmax(a6),d1 is this beyond highest job number */
    cmp.w M26_sv_jbmax(a6),d1
/* QL:         bgt.s   M26_up_tree         yes - there are no daughter jobs */
    bgt.s M26_up_tree
/* QL:         bsr.s   M26_find_add        find address of job */
    bsr.s M26_find_add
/* QL:         tst.b   (a1)            does it exist? */
    tst.b (a1)
/* QL:         blt.s   M26_next_job        no try another */
    blt.s M26_next_job
/* QL:         cmp.l   M26_jb_owner(a0),d2 is this job owned by the right job */
    cmp.l M26_jb_owner(a0),d2
/* QL:         bne.s   M26_next_job        no - try another */
    bne.s M26_next_job
/* QL:         swap    d1              save lsw */
    swap d1
/* QL:         move.w  M26_jb_tag(a0),d1   fetch tag */
    move.w M26_jb_tag(a0),d1
/* QL:         swap    d1              full job id */
    swap d1
/* QL: M26_rts0 */
M26_rts0:
/* QL:         rts */
    rts 
/* QL: M26_tree */
M26_tree:
/* QL:         move.l  d1,d2           look for job owned by this job */
    move.l d1,d2
/* QL:         moveq   #0,d1           start at beginning of table */
    moveq #0,d1
/* QL:         bra.s   M26_next_job */
    bra.s M26_next_job
/* QL: M26_find_add */
M26_find_add:
/* QL:         bsr.s   M26_jbptr           go make up pointer */
    bsr.s M26_jbptr
/* QL:         move.l  (a1),a0         this is base of job itself */
    move.l (a1),a0
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error flag */
/* QL: * d1 -i  - id of job to be removed */
/* QL: * d3 -i  - error code to send to any waiting jobs */
/* QL: * d2/a0-a3 destroyed */
/* QL: mt_rjob */
mt_rjob:
/* QL:         jsr     ss_jobx(pc)     check if job exists */
    jsr ss_jobx(pc)
/* QL:         move.l  d1,d0           set top of M26_tree */
    move.l d1,d0
/* QL: * Check if any job in M26_tree is active */
/* QL: M26_chk_loop */
M26_chk_loop:
/* QL:         tst.b   M26_jb_princ(a0)    is job active */
    tst.b M26_jb_princ(a0)
/* QL:         bne.s   M26_jb_activ        yes - cannot delete */
    bne.s M26_jb_activ
/* QL:         bsr.s   M26_tree            find next job */
    bsr.s M26_tree
/* QL:         tst.l   d1              is this end of M26_tree */
    tst.l d1
/* QL:         bne.s   M26_chk_loop        no - check this job */
    bne.s M26_chk_loop
/* QL:         move.l  d0,d1           restore top of M26_tree job */
    move.l d0,d1
/* QL: * Drop into force remove job */
/* QL: * d0 -  o- error flag */
/* QL: * d1 -i  - id of job to be removed */
/* QL: * d3 -i  - error code to send to any waiting jobs */
/* QL: * d2/a0-a3 destroyed */
/* QL: mt_frjob */
mt_frjob:
/* QL:         jsr     ss_jobx(pc)     check if job exists */
    jsr ss_jobx(pc)
/* QL:         move.l  d1,d0           set top of M26_tree */
    move.l d1,d0
/* QL:         bne.s   M26_okdel           do not try to delete job 0 */
    bne.s M26_okdel
/* QL:         cmp.l   M26_sv_jbpnt(a6),a0 is this job 0 removing itself!!? */
    cmp.l M26_sv_jbpnt(a6),a0
/* QL:         beq.s   M26_help */
    beq.s M26_help
/* QL: M26_jb_activ */
M26_jb_activ:
/* QL:         moveq   #M26_err.nc,d0      job still active - not complete */
    moveq #M26_err.nc,d0
/* QL: M26_ssrte */
M26_ssrte:
/* QL:         jmp     ss_rte(pc) */
    jmp ss_rte(pc)
/* QL: M26_help */
M26_help:
/* QL: * Job 0 has suicided, until we can think of something better... */
/* QL:         sf      M26_jb_princ(a0)    make it go very quiet */
    sf M26_jb_princ(a0)
/* QL:         bra.s   M26_discard         M26_discard whatever it was doing */
    bra.s M26_discard
/* QL: M26_del_elop */
M26_del_elop:
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL:         tst.l   (sp)+           check if this job is deleted */
    tst.l (sp)+
/* QL:         bpl.s   M26_ssrte           no, that's ok */
    bpl.s M26_ssrte
/* QL: M26_discard */
M26_discard:
/* QL:         add.w   #3*4+2+4,sp     M26_discard stacked d7/a5-a6, sr and pc */
    add.w #(((3*4)+2)+4),sp
/* QL:         jmp     ss_dljob(pc)    yes, re-enter scheduler, job deleted */
    jmp ss_dljob(pc)
/* QL: M26_jbptr */
M26_jbptr:
/* QL:         move.w  d1,a1           find address of job entry */
    move.w d1,a1
/* QL:         add.w   a1,a1           job number *4 */
    add.w a1,a1
/* QL:         add.w   a1,a1 */
    add.w a1,a1
/* QL:         add.l   M26_sv_jbbas(a6),a1 + base address */
    add.l M26_sv_jbbas(a6),a1
/* QL:         rts */
    rts 
/* QL: M26_okdel */
M26_okdel:
/* QL:         bsr.s   M26_jbptr           make up job pointer */
    bsr.s M26_jbptr
/* QL: M26_mrk_loop */
M26_mrk_loop:
/* QL:         addq.b  #8,(a1)         mark job */
    addq.b #8,(a1)
/* QL:         bsr.s   M26_tree            find next job */
    bsr.s M26_tree
/* QL:         tst.w   d1              is this end of M26_tree */
    tst.w d1
/* QL:         bne.s   M26_mrk_loop        no - mark this job */
    bne.s M26_mrk_loop
/* QL: * All jobs to be deleted have been marked with +ve in msb of table entry */
/* QL: * We get cleverer these days... first M26_close all channels, in case any other */
/* QL: * jobs are waiting on a channel that goes with this set of jobs. */
/* QL:         assert  M26_sv_chbas,M26_sv_chtop-4 */
/* original assertion: M26_sv_chbas,M26_sv_chtop-4 */
/* QL:         movem.l M26_sv_chbas(a6),a2-a3 */
    movem.l M26_sv_chbas(a6),a2-a3
/* QL: M26_chloop */
M26_chloop:
/* QL:         move.l  -(a3),d0        get next channel pointer */
    move.l -(a3),d0
/* QL:         bmi.s   M26_chnext          not in use, skip it */
    bmi.s M26_chnext
/* QL:         move.l  d0,a0 */
    move.l d0,a0
/* QL:         move.w  M26_ch_owner+2(a0),d1 fetch owner job number, then make pointer */
    move.w (M26_ch_owner+2)(a0),d1
/* QL:         bsr.s   M26_jbptr */
    bsr.s M26_jbptr
/* QL:         tst.b   (a1) */
    tst.b (a1)
/* QL:         ble.s   M26_chnext */
    ble.s M26_chnext
/* QL:         bsr.s   mt_close        if one of ours, M26_close the channel now */
    bsr.s mt_close
/* QL: M26_chnext */
M26_chnext:
/* QL:         cmp.l   a2,a3 */
    cmp.l a2,a3
/* QL:         bne.s   M26_chloop          carry one through all the channel table */
    bne.s M26_chloop
/* QL: * Close entries in common heap for all jobs being deleted. */
/* QL: * This used to be done on a per job basis, but it's quicker to do a single scan */
/* QL: * as there can be a lot of cases of released memory joining up. */
/* QL:         move.l  M26_sv_cheap(a6),a2 start scanning through common heap */
    move.l M26_sv_cheap(a6),a2
/* QL: M26_chk_tbl */
M26_chk_tbl:
/* QL:         move.w  M26_hp_owner+2(a2),d0 */
    move.w (M26_hp_owner+2)(a2),d0
/* QL:         cmp.w   M26_sv_jbmax(a6),d0 a safety check, in case memory corrupted */
    cmp.w M26_sv_jbmax(a6),d0
/* QL:         bhi.s   M26_nxt_tbl */
    bhi.s M26_nxt_tbl
/* QL:         lsl.w   #2,d0 */
    lsl.w #2,d0
/* QL:         beq.s   M26_nxt_tbl         don't touch it if it's got job 0 as owner */
    beq.s M26_nxt_tbl
/* QL:         move.l  M26_sv_jbbas(a6),a0 */
    move.l M26_sv_jbbas(a6),a0
/* QL:         add.w   d0,a0 */
    add.w d0,a0
/* QL:         tst.b   (a0)            are we removing this job? */
    tst.b (a0)
/* QL:         ble.s   M26_nxt_tbl         no - don't think about it any more */
    ble.s M26_nxt_tbl
/* QL:         move.l  a2,a0           put heap pointer in right register */
    move.l a2,a0
/* QL:         bsr.s   M26_close           get rid of it */
    bsr.s M26_close
/* QL:         cmp.l   M26_sv_free(a6),a2  is it off end? */
    cmp.l M26_sv_free(a6),a2
/* QL:         bcc.s   M26_mem_ex          yes! memory must have been released to sb's! */
    bcc.s M26_mem_ex
/* QL: M26_nxt_tbl */
M26_nxt_tbl:
/* QL:         assert  M26_hp_len,0 */
/* original assertion: M26_hp_len,0 */
/* QL:         add.l   (a2),a2         move to next item */
    add.l (a2),a2
/* QL:         cmp.l   M26_sv_free(a6),a2  is it off end? */
    cmp.l M26_sv_free(a6),a2
/* QL:         bcs.s   M26_chk_tbl */
    bcs.s M26_chk_tbl
/* QL: M26_mem_ex */
M26_mem_ex:
/* QL: * All common heap has been cleaned out, now see off the jobs themselves */
/* QL:         clr.l   -(sp)           set job number, msb set if current job deleted */
    clr.l -(sp)
/* QL: M26_del_loop */
M26_del_loop:
/* QL:         addq.l  #1,(sp)         next job */
    addq.l #1,(sp)
/* QL:         move.l  (sp),d1 */
    move.l (sp),d1
/* QL:         cmp.w   M26_sv_jbmax(a6),d1 all done? */
    cmp.w M26_sv_jbmax(a6),d1
/* QL:         bhi.s   M26_del_elop */
    bhi.s M26_del_elop
/* QL:         bsr.s   M26_jbptr           make up the job pointer */
    bsr.s M26_jbptr
/* QL:         tst.b   (a1)            is this job to be deleted? */
    tst.b (a1)
/* QL:         ble.s   M26_del_loop        ... no */
    ble.s M26_del_loop
/* QL: * this job is to be deleted */
/* QL:         cmp.l   M26_sv_jbpnt(a6),a1 is this the current job */
    cmp.l M26_sv_jbpnt(a6),a1
/* QL:         bne.s   M26_notcur */
    bne.s M26_notcur
/* QL:         tas     (sp)            set flag to say current job is deleted */
    tas (sp)
/* QL: M26_notcur */
M26_notcur:
/* QL:         sf      (a1)            remove the mark so address is valid */
    sf (a1)
/* QL:         move.l  (a1),a2         get address of header */
    move.l (a1),a2
/* QL:         st      (a1)            mark it deleted now */
    st (a1)
/* QL: * Release any waiting jobs */
/* QL:         tst.b   M26_jb_wflag(a2)    is a job waiting? */
    tst.b M26_jb_wflag(a2)
/* QL:         beq.s   M26_del_tbl */
    beq.s M26_del_tbl
/* QL:         move.l  M26_jb_wjob(a2),d1  get job id */
    move.l M26_jb_wjob(a2),d1
/* QL:         jsr     ss_joba(pc)     find job address */
    jsr ss_joba(pc)
/* QL:         bne.s   M26_del_tbl         oops - it's gone away!! */
    bne.s M26_del_tbl
/* QL:         cmp.w   #-2,M26_jb_stat(a0) is this waiting on job completion? */
    cmp.w #(-2),M26_jb_stat(a0)
/* QL:         bne.s   M26_del_tbl */
    bne.s M26_del_tbl
/* QL:         clr.w   M26_jb_stat(a0)     release job */
    clr.w M26_jb_stat(a0)
/* QL:         move.l  d3,M26_jb_d0(a0)    set error return */
    move.l d3,M26_jb_d0(a0)
/* QL: M26_del_tbl */
M26_del_tbl:
/* QL: * Finally, release job space */
/* QL:         move.l  a2,a0 */
    move.l a2,a0
/* QL:         move.l  d3,-(sp) */
    move.l d3,-(sp)
/* QL:         jsr     mm_retrn(pc) */
    jsr mm_retrn(pc)
/* QL:         move.l  (sp)+,d3 */
    move.l (sp)+,d3
/* QL:         bra.s   M26_del_loop        next job */
    bra.s M26_del_loop
/* QL: * a0 -i  - area in common heap to be "closed" */
/* QL: * d0/a1 destroyed (a1 could be saved...) */
/* QL: clreg   reg     d1-d7/a2-a6     all registers can be smashed by M26_close */
/* QL: mt_close */
mt_close:
/* QL:         tst.b   M26_ch_stat(a0)     is anyone waiting on this channel? */
    tst.b M26_ch_stat(a0)
/* QL:         beq.s   M26_close           nope, just scrap it */
    beq.s M26_close
/* QL:         jsr     io_jbchk(pc)    check if job is still around */
    jsr io_jbchk(pc)
/* QL:         bne.s   M26_close           nope, forget about it */
    bne.s M26_close
/* QL:         moveq   #M26_err.no,d0 */
    moveq #M26_err.no,d0
/* QL:         move.l  d0,M26_jb_d0(a1)    tell job the channel is no longer open */
    move.l d0,M26_jb_d0(a1)
/* QL:         clr.w   M26_jb_stat(a1)     job is no longer waiting */
    clr.w M26_jb_stat(a1)
/* QL: M26_close */
M26_close:
/* QL:         movem.l clreg,-(sp)     save registers */
    movem.l d1-d7/a2-a6,-(sp)
/* QL:         assert  0,M26_hp_drivr-4,M26_hp_owner-8,M26_hp_rflag-12 */
/* original assertion: 0,M26_hp_drivr-4,M26_hp_owner-8,M26_hp_rflag-12 */
/* QL:         lea     M26_hp_rflag(a0),a1 */
    lea M26_hp_rflag(a0),a1
/* QL:         move.l  (a1),d0         check release flag address */
    move.l (a1),d0
/* QL:         beq.s   M26_cls_tbl */
    beq.s M26_cls_tbl
/* QL:         move.l  d0,a3 */
    move.l d0,a3
/* QL:         st      (a3)            flag this entry gone */
    st (a3)
/* QL:         clr.l   (a1)            clean out the release flag now! */
    clr.l (a1)
/* QL: M26_cls_tbl */
M26_cls_tbl:
/* QL:         clr.l   -(a1)           M26_discard the owner now! */
    clr.l -(a1)
/* QL:         move.l  -(a1),a1        fetch address of driver for this item */
    move.l -(a1),a1
/* QL:         lea     -M26_sv_lio(a1),a3  set base of driver definition block */
    lea (-M26_sv_lio)(a1),a3
/* QL:         move.l  M26_hp_close(a1),a1 M26_close item */
    move.l M26_hp_close(a1),a1
/* QL:         jsr     (a1) */
    jsr (a1)
/* QL:         movem.l (sp)+,clreg     restore registers */
    movem.l (sp)+,d1-d7/a2-a6
/* QL:         rts */
    rts 
/* QL:         end */
