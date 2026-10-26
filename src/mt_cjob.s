/* ROM section mt_cjob */
.balign 2,0
/* QL: reg_save reg    d1-d2/a1-a4 */
/* QL: reg_pick reg    d0/d2/a1 */
/* QL: * d0 -  o- error flag */
/* QL: * d1 -i o- owner job / job id */
/* QL: * d2 -ip - length of code or 0 */
/* QL: * d3 -i o- length of data space (rounded up to fill acquired transient space) */
/* QL: * a0 -  o- base address of job */
/* QL: * a1 -ip - job start address or zero to use base of job area */
/* QL: * a6 -ip - base address of system variables */
/* QL: * d7 destroyed */
/* QL: mt_cjob */
mt_cjob:
/* QL:         jsr     ss_jobx(pc) */
    jsr ss_jobx(pc)
/* QL:         movem.l reg_save,-(sp) */
    movem.l d1-d2/a1-a4,-(sp)
/* QL:         moveq   #M25_err.nj,d0      error code we want from sys_jtag if it fails */
    moveq #M25_err.nj,d0
/* QL:         add.l   d2,d3           this will be the prog + data size requested */
    add.l d2,d3
/* QL:         ble.s   M25_exit            a minor point - refuse silly parameters */
    ble.s M25_exit
/* QL:         jsr     ss_jtag(pc)     go get us a new job slot */
    jsr ss_jtag(pc)
/* QL:         bmi.s   M25_exit            return negative means d0 not changed */
    bmi.s M25_exit
/* QL:         move.l  a3,a4           save pointer into job table */
    move.l a3,a4
/* QL:         move.l  (sp),d7         fetch owner off the stack */
    move.l (sp),d7
/* QL:         move.l  d0,(sp)         put new job id on the stack */
    move.l d0,(sp)
/* QL:         moveq   #M25_jb_end,d1      header is not included */
    moveq #M25_jb_end,d1
/* QL:         add.l   d3,d1           so add it to length required */
    add.l d3,d1
/* QL:         jsr     mm_altrn(pc)    and allocate space */
    jsr mm_altrn(pc)
/* QL:         bne.s   M25_exit            ok? */
    bne.s M25_exit
/* QL:         movem.l (sp),reg_pick   restore prog space and start (d0 ignored) */
    movem.l (sp),d0/d2/a1
/* QL: * Now set up the job control block in the header */
/* QL:         lea     M25_jb_end(a0),a2   job base for misc setup */
    lea M25_jb_end(a0),a2
/* QL:         assert  ((M25_jb_end-M25_jb_tag)/4)*4,M25_jb_end-M25_jb_tag */
/* original assertion: ((M25_jb_end-M25_jb_tag)/4)*4,M25_jb_end-M25_jb_tag */
/* QL:         moveq   #(M25_jb_end-M25_jb_tag)/4-1,d0 clear all but length/start/owner/hold */
    moveq #(((M25_jb_end-M25_jb_tag)/4)-1),d0
/* QL: M25_clr_head */
M25_clr_head:
/* QL:         clr.l   -(a2) */
    clr.l -(a2)
/* QL:         dbra    d0,M25_clr_head */
    dbra d0,M25_clr_head
/* QL:         move.l  M25_sv_trapv(a6),M25_jb_trapv(a0) dup callers trap vector ptr */
    move.l M25_sv_trapv(a6),M25_jb_trapv(a0)
/* QL:         move.l  M25_sv_jbpnt(a6),a3 */
    move.l M25_sv_jbpnt(a6),a3
/* QL:         move.l  (a3),a3 */
    move.l (a3),a3
/* QL:         moveq   #15,d0          allow for four inherited flag bits */
    moveq #15,d0
/* QL:         and.b   M25_jb_rela6(a3),d0 */
    and.b M25_jb_rela6(a3),d0
/* QL:         move.b  d0,M25_jb_rela6(a0) dup caller's flag bits */
    move.b d0,M25_jb_rela6(a0)
/* QL:         move.w  (sp),(a2)       set tag */
    move.w (sp),(a2)
/* QL:         clr.l   -(a2)           clear M25_jb_hold, as it happens */
    clr.l -(a2)
/* QL:         assert  M25_jb_owner,M25_jb_tag-8 */
/* original assertion: M25_jb_owner,M25_jb_tag-8 */
/* QL:         move.l  d7,-(a2)        set owner */
    move.l d7,-(a2)
/* QL:         move.l  a4,a3           put back pointer to job table */
    move.l a4,a3
/* QL:         bsr.s   mt_cj0          do the bit in common with sys_init */
    bsr.s mt_cj0
/* QL:         move.l  d2,-(a3)        set length of code in saved a4 */
    move.l d2,-(a3)
/* QL:         sub.l   d2,d3           d3 = real data size... not that anyone cares! */
    sub.l d2,d3
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL: M25_exit */
M25_exit:
/* QL:         movem.l (sp)+,reg_save */
    movem.l (sp)+,d1-d2/a1-a4
/* QL:         jmp     ss_rte(pc) */
    jmp ss_rte(pc)
/* QL: * A bit of code shared with sys_init */
/* QL: * d1 -i  - overall size of area, including header */
/* QL: * d3 -  o- prog+data size, i.e. d1 less M25_jb_end */
/* QL: * a0 -i o- pointer to job header / job base address */
/* QL: * a1 -i o- start address or zero / new job's usp */
/* QL: * a3 -i o- pointer into job table where a0 is to go / jb_a5(a0) */
/* QL: mt_cj0 */
mt_cj0:
/* QL:         move.l  a0,(a3)         set up pointer in job table */
    move.l a0,(a3)
/* QL:         moveq   #-M25_jb_end,d3     discount header */
    moveq #(-M25_jb_end),d3
/* QL:         sub.l   d3,a0           set job base */
    sub.l d3,a0
/* QL:         add.l   d1,d3           form prog+data size */
    add.l d1,d3
/* QL:         lea     M25_jb_pc-M25_jb_end(a0),a3 */
    lea (M25_jb_pc-M25_jb_end)(a0),a3
/* QL:         move.l  a1,(a3)         was a start address given? */
    move.l a1,(a3)
/* QL:         bne.s   M25_startok         yes - accept it */
    bne.s M25_startok
/* QL:         move.l  a0,(a3)         no - use base of job */
    move.l a0,(a3)
/* QL: M25_startok */
M25_startok:
/* QL:         move.l  (a3),M25_jb_start-M25_jb_end(a0) copy start to saved pc */
    move.l (a3),(M25_jb_start-M25_jb_end)(a0)
/* QL:         subq.l  #M25_jb_pc-(M25_jb_a0+7*4),a3 */
.word 20875|((((M25_jb_pc-(M25_jb_a0+(7*4))))&7)<<9)
/* QL:         lea     -4(a0,d3.l),a1  job top less 4 will be user stack pointer */
    lea (-4)(a0,d3.l),a1
/* QL:         clr.l   (a1)            with two zero words on it */
    clr.l (a1)
/* QL:         move.l  a1,(a3)         set saved a7 (usp) */
    move.l a1,(a3)
/* QL:         move.l  a0,-(a3)        set job base in saved a6 */
    move.l a0,-(a3)
/* QL:         move.l  d3,-(a3)        set length of code+data in saved a5 */
    move.l d3,-(a3)
/* QL:         rts */
    rts 
/* QL:         end */
