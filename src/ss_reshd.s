/* ROM section ss_reshd */
.balign 2,0
/* QL: * Break (ctrl/space) handling moved here to avoid having it inside interrupt */
/* QL: * service code! Also, ctrl/alt/space breaks all other interpreters. */
/* QL: * The usage of job priorities has been enhanced somewhat. They now behave as: */
/* QL: *       -128..-1        background tasks (see below) */
/* QL: *       0               job is inactive */
/* QL: *       1-127           major active jobs, as before */
/* QL: * Background tasks are split into sixteen levels, according to their top */
/* QL: * nibble, within each of which the low nibble now gives the priority increment. */
/* QL: * Tasks of a given level are never given time unless no major job and no tasks */
/* QL: * at a higher level want time. */
/* QL: * Re-scheduling entry point */
/* QL: ss_reshd */
ss_reshd:
/* QL:         move.l  M10_sv_jbpnt(a6),a5 find address of base of job */
    move.l M10_sv_jbpnt(a6),a5
/* QL:         move.l  (a5),a5 */
    move.l (a5),a5
/* QL:         move.l  (sp)+,d7        the real value of d7 */
    move.l (sp)+,d7
/* QL:         movem.l d0-d7/a0-a4,M10_jb_d0(a5) save most of the registers */
    movem.l d0-d7/a0-a4,M10_jb_d0(a5)
/* QL:         add.w   #M10_jb_a0+5*4,a5 */
    add.w #(M10_jb_a0+(5*4)),a5
/* QL:         assert  M10_jb_a0+8*4,M10_jb_sr,M10_jb_pc-2 */
/* original assertion: M10_jb_a0+8*4,M10_jb_sr,M10_jb_pc-2 */
/* QL:         move.l  (sp)+,(a5)+     saved a5 */
    move.l (sp)+,(a5)+
/* QL:         move.l  (sp)+,(a5)+     saved a6 */
    move.l (sp)+,(a5)+
/* QL:         move    usp,a0 */
    move usp,a0
/* QL:         move.l  a0,(a5)+        user stack pointer (a7) */
    move.l a0,(a5)+
/* QL:         move.w  (sp)+,(a5)+     status register */
    move.w (sp)+,(a5)+
/* QL:         move.l  (sp)+,(a5)      program counter */
    move.l (sp)+,(a5)
/* QL:         tst.b   M10_jb_prior-M10_jb_pc(a5) reduce priority */
    tst.b (M10_jb_prior-M10_jb_pc)(a5)
/* QL:         beq.s   ss_dljob        if it is already zero - don't bother */
    beq.s ss_dljob
/* QL:         move.b  #1,M10_jb_prior-M10_jb_pc(a5) */
    move.b #(1&255),(M10_jb_prior-M10_jb_pc)(a5)
/* QL: * Entry when a job has been deleted by man_djob = main scheduler loop */
/* QL: ss_dljob */
ss_dljob:
/* QL:         lea     M10_sv_pollm(a6),a0 */
    lea M10_sv_pollm(a6),a0
/* QL:         move.w  (a0),d3         fetch number of missing polls */
    move.w (a0),d3
/* QL:         sub.w   d3,(a0)         and reset */
    sub.w d3,(a0)
/* QL:         assert  M10_sv_rand,M10_sv_pollm-2 */
/* original assertion: M10_sv_rand,M10_sv_pollm-2 */
/* QL:         addq.w  #1,-(a0)        update random number */
    addq.w #1,-(a0)
/* QL: * Now execute all tasks to be done by the scheduler/ioss */
/* QL:         moveq   #M10_sv_shlst-M10_sv_i2lst,d4 set offset of sched list from int 2 list */
    moveq #(M10_sv_shlst-M10_sv_i2lst),d4
/* QL:         jsr     ss_tlist(pc)    go do them (sets d1.l=0) */
    jsr ss_tlist(pc)
/* QL: * Look for next job to execute */
/* QL: * d0 -  o- address of job entry with highest priority (if d1.b is not zero) */
/* QL: * d1 -i o- 0/priority of job d0 or zero if no one can run */
/* QL: * d3 -i  - number of polled interrupts since last go */
/* QL: * a6 -  i- base address of system variables */
/* QL: * d2 priority of this job */
/* QL: * d4 priority increment */
/* QL: * d5 temporary */
/* QL: * d6 break events, bit 31 = ctrl/space and bit 0 = ctrl/alt/space */
/* QL: * d7 max job * 4, complemented as we swap marker */
/* QL: * a0 address of job */
/* QL: * a1 address of hold flag */
/* QL: * a2 address of job entry */
/* QL: * a3 address of marker job entry */
/* QL: * a4 address of system extension block */
/* QL: *       moveq   #0,d1           highest priority starts as zero = no job yet */
/* QL:         assert  M10_sv_jbmax+2,M10_sv_jbpnt,M10_sv_jbbas-4 */
/* original assertion: M10_sv_jbmax+2,M10_sv_jbpnt,M10_sv_jbbas-4 */
/* QL:         movem.l M10_sv_jbpnt-4(a6),d7/a2-a3 max job, current job and base of table */
    movem.l (M10_sv_jbpnt-4)(a6),d7/a2-a3
/* QL:         lsl.w   #2,d7           highest job number * 4 */
    lsl.w #2,d7
/* QL:         move.l  M10_sv_chtop(a6),a4 get sysext address */
    move.l M10_sv_chtop(a6),a4
/* QL:         moveq   #3<<M10_sx..brk,d6 */
    moveq #(3<<M10_sx..brk),d6
/* QL:         and.b   M10_sx_event(a4),d6 get both break events (ctrl/{alt/}space) */
    and.b M10_sx_event(a4),d6
/* QL:         eor.b   d6,M10_sx_event(a4) invert events we have picked up */
    eor.b d6,M10_sx_event(a4)
/* QL:         ror.l   #M10_sx..brk+1,d6   M10_sx..brk to bit 31, M10_sx..brk+1 to bit 0 */
    ror.l #(M10_sx..brk+1),d6
/* QL: M10_chk_end */
M10_chk_end:
/* QL:         cmp.l   a2,a3           are we at the marker? */
    cmp.l a2,a3
/* QL:         beq.s   M10_chk_stp         yes - go see it that was the full loop */
    beq.s M10_chk_stp
/* QL:         move.l  -(a2),d2        is this entry vacant? */
    move.l -(a2),d2
/* QL:         blt.s   M10_chk_end         yes - see if end of scan */
    blt.s M10_chk_end
/* QL:         move.l  d2,a0           get address of job */
    move.l d2,a0
/* QL:         move.w  #$7000,d4       positive princ's get msb $70 */
    move.w #0x7000,d4
/* QL:         assert  M10_jb_stat-1,M10_jb_princ */
/* original assertion: M10_jb_stat-1,M10_jb_princ */
/* QL:         lea     M10_jb_stat-1(a0),a1 */
    lea (M10_jb_stat-1)(a0),a1
/* QL:         move.b  (a1)+,d4        check if this job is active */
    move.b (a1)+,d4
/* QL:         beq.s   M10_chk_end */
    beq.s M10_chk_end
/* QL:         bpl.s   M10_pri_ok */
    bpl.s M10_pri_ok
/* QL:         lsl.w   #4,d4 */
    lsl.w #4,d4
/* QL:         lsr.b   #4,d4           turn -ve princ into 16 absolute low levels */
    lsr.b #4,d4
/* QL: M10_pri_ok */
M10_pri_ok:
/* QL:         btst    #M10_bv..int,M10_jb_rela6(a0) is this an interpreter? */
    btst #M10_bv..int,M10_jb_rela6(a0)
/* QL:         beq.s   M10_brk_off         no - break events don't apply */
    beq.s M10_brk_off
/* QL:         moveq   #M10_jb_end+M10_bv_brk-$7f,d2 job 0 offset of break flag less a bit */
    moveq #((M10_jb_end+M10_bv_brk)-0x7f),d2
/* QL:         cmp.l   M10_sv_jbbas(a6),a2 is this job 0? */
    cmp.l M10_sv_jbbas(a6),a2
/* QL:         seq     d5              job 0 - test bit 7, others - test bit 0 */
    seq d5
/* QL:         beq.s   M10_set_brk */
    beq.s M10_set_brk
/* QL:         add.w   M10_jb_end+2(a0),d2 others have extra offset */
    add.w (M10_jb_end+2)(a0),d2
/* QL: M10_set_brk */
M10_set_brk:
/* QL:         btst    d5,d6           are we processing the appropriate break event? */
    btst d5,d6
/* QL:         beq.s   M10_brk_off         no - forget it */
    beq.s M10_brk_off
/* QL:         sf      $7f(a0,d2.w) set break flag */
    sf 0x7f(a0,d2.w)
/* QL:         move.w  (a1),d2         get status */
    move.w (a1),d2
/* QL:         beq.s   M10_susp_ok         if not suspended, let it carry on */
    beq.s M10_susp_ok
/* QL:         addq.w  #1,d2           is it waiting on another job (wait -2) */
    addq.w #1,d2
/* QL:         bge.s   M10_clr_stat        anything but that, release it */
    bge.s M10_clr_stat
/* QL: M10_brk_off */
M10_brk_off:
/* QL:         move.w  (a1),d2         check if this job is suspended */
    move.w (a1),d2
/* QL:         beq.s   M10_susp_ok         no - go process priority */
    beq.s M10_susp_ok
/* QL:         blt.s   M10_chk_end         it's waiting permanently */
    blt.s M10_chk_end
/* QL:         sub.w   d3,(a1)         tick its clock */
    sub.w d3,(a1)
/* QL:         bgt.s   M10_chk_end         not timed out yet, keep it waiting */
    bgt.s M10_chk_end
/* QL: M10_clr_stat */
M10_clr_stat:
/* QL:         clr.w   (a1)            clear suspension */
    clr.w (a1)
/* QL:         move.l  M10_jb_hold(a0),d2  is this job held on something? */
    move.l M10_jb_hold(a0),d2
/* QL:         beq.s   M10_susp_ok */
    beq.s M10_susp_ok
/* QL:         move.l  d2,a1 */
    move.l d2,a1
/* QL:         sf      (a1)            yes - clear hold flag */
    sf (a1)
/* QL: M10_susp_ok */
M10_susp_ok:
/* QL:         move.b  M10_jb_prior(a0),d2 get current priority */
    move.b M10_jb_prior(a0),d2
/* QL:         bne.s   M10_add_prio */
    bne.s M10_add_prio
/* QL:         move.b  #1,d4           if first time round - just move up one */
    move.b #(1&255),d4
/* QL: M10_add_prio */
M10_add_prio:
/* QL:         add.b   d2,d4           add increment */
    add.b d2,d4
/* QL:         scs     d2              has it overflowed? */
    scs d2
/* QL:         or.b    d2,d4           yes - set it to max */
    or.b d2,d4
/* QL:         move.b  d4,M10_jb_prior(a0) save new priority */
    move.b d4,M10_jb_prior(a0)
/* QL:         cmp.w   d4,d1           is this greater than highest so far */
    cmp.w d4,d1
/* QL:         bcc.s   M10_chk_end */
    bcc.s M10_chk_end
/* QL:         move.w  d4,d1 */
    move.w d4,d1
/* QL:         move.l  a2,d0           yes - save it */
    move.l a2,d0
/* QL: M10_chk_end2 */
M10_chk_end2:
/* QL:         bra.s   M10_chk_end */
    bra.s M10_chk_end
/* QL: M10_chk_stp */
M10_chk_stp:
/* QL: * Either: a2=a3=bottom of table and d7<>0, or: a2=a3=current job and d7=0 */
/* QL:         lea     4(a3,d7.w),a2   address after highest job */
    lea 4(a3,d7.w),a2
/* QL:         move.l  M10_sv_jbpnt(a6),a3 stop when we've looked at current job */
    move.l M10_sv_jbpnt(a6),a3
/* QL:         not.w   d7              was this the full loop over? */
    not.w d7
/* QL:         bmi.s   M10_chk_end2        no - do rest of scan */
    bmi.s M10_chk_end2
/* QL:         tst.w   d1              check if any job found (priority non-zero) */
    tst.w d1
/* QL:         beq.l   ss_dljob        if not - do (poll)/io operations again */
    beq.w ss_dljob
/* QL:         move.l  d0,M10_sv_jbpnt(a6) set current job table entry */
    move.l d0,M10_sv_jbpnt(a6)
/* QL: * Entry point from ss_init to start up job zero */
/* QL: * super GC requires a0 to be used here! */
/* QL: ss_rj0 */
ss_rj0:
/* QL:         move.l  M10_sv_jbpnt(a6),a0 find address of job in table */
    move.l M10_sv_jbpnt(a6),a0
/* QL:         move.l  (a0),a0         thus base of job */
    move.l (a0),a0
/* QL:         move.l  M10_jb_trapv(a0),M10_sv_trapv(a6) redirect traps */
    move.l M10_jb_trapv(a0),M10_sv_trapv(a6)
/* QL:         add.w   #M10_jb_pc,a0 */
    add.w #M10_jb_pc,a0
/* QL:         move.l  (a0),-(sp)      put the program counter on */
    move.l (a0),-(sp)
/* QL:         move.w  -(a0),-(sp)     and status register */
    move.w -(a0),-(sp)
/* QL:         move.l  -(a0),a1 */
    move.l -(a0),a1
/* QL:         move    a1,usp          restore user stack pointer */
    move a1,usp
/* QL:         assert  M10_jb_d0+8*4,M10_jb_a0 */
/* original assertion: M10_jb_d0+8*4,M10_jb_a0 */
/* QL:         movem.l M10_jb_d0-M10_jb_a0-7*4(a0),d0-d7/a0-a6 and all other registers */
    movem.l ((M10_jb_d0-M10_jb_a0)-(7*4))(a0),d0-d7/a0-a6
/* QL:         rte                     and go! */
    rte 
/* QL:         end */
