/* ROM section ss_job */
.balign 2,0
/* QL: * Check if a particular job exists */
/* QL: * Must only be called from trap level */
/* QL: * It does not return if job does not exist */
/* QL: * d0  r  set on abnormal M6_exit */
/* QL: * d1 cr  job number to be checked */
/* QL: * a0  r  address of header */
/* QL: ss_jobx */
ss_jobx:
/* QL:         tst.w   d1              is it current job? */
    tst.w d1
/* QL:         bge.s   M6_test_job */
    bge.s M6_test_job
/* QL: * ss_joby finds the current job id (d1), and base address (a0) */
/* QL: * d1  r  current job id */
/* QL: * a0  r  base of current job */
/* QL: ss_joby */
ss_joby:
/* QL:         move.l  M6_sv_jbpnt(a6),a0 get current job table pointer */
    move.l M6_sv_jbpnt(a6),a0
/* QL:         move.w  a0,d1 */
    move.w a0,d1
/* QL:         move.l  (a0),a0         ... then pointer to job */
    move.l (a0),a0
/* QL:         sub.w   M6_sv_jbbas+2(a6),d1 calculate job number ... pointer -  base */
    sub.w (M6_sv_jbbas+2)(a6),d1
/* QL:         lsr.w   #2,d1           div by 4 */
    lsr.w #2,d1
/* QL:         M6_swap    d1 */
    swap d1
/* QL:         move.w  M6_jb_tag(a0),d1   ... and tag in top end */
    move.w M6_jb_tag(a0),d1
/* QL:         M6_swap    d1 */
    swap d1
/* QL: M6_exit */
M6_exit:
/* QL:         rts */
    rts 
/* QL: M6_test_job */
M6_test_job:
/* QL:         bsr.s   ss_joba */
    bsr.s ss_joba
/* QL:         beq.s   M6_exit */
    beq.s M6_exit
/* QL:         moveq   #M6_err.nj,d0 */
    moveq #M6_err.nj,d0
/* QL:         addq.l  #4,sp           ... remove return address from stack */
    addq.l #4,sp
/* QL:         jmp     ss_rte(pc)     ... return direct to trap */
    jmp ss_rte(pc)
/* QL: * ss_joba finds the address of a job (condition codes zero if ok) */
/* QL: * d1 c p job id */
/* QL: * a0  r  base address of job */
/* QL: ss_joba */
ss_joba:
/* QL:         cmp.w   M6_sv_jbmax(a6),d1 is it in range? */
    cmp.w M6_sv_jbmax(a6),d1
/* QL:         bhi.s   M6_exit */
    bhi.s M6_exit
/* QL:         move.w  d1,a0           find address of job entry */
    move.w d1,a0
/* QL:         add.w   a0,a0           ... it is job number * 4 */
    add.w a0,a0
/* QL:         add.w   a0,a0 */
    add.w a0,a0
/* QL:         add.l   M6_sv_jbbas(a6),a0 ... + base of table */
    add.l M6_sv_jbbas(a6),a0
/* QL:         tst.b   (a0)            ... is it in table? */
    tst.b (a0)
/* QL:         blt.s   M6_exit */
    blt.s M6_exit
/* QL:         move.l  (a0),a0         set address of job header */
    move.l (a0),a0
/* QL:         M6_swap    d1              move tag to bottom word */
    swap d1
/* QL:         cmp.w   M6_jb_tag(a0),d1   is this the same? */
    cmp.w M6_jb_tag(a0),d1
/* QL:         bne.s   M6_exit            ... oops */
    bne.s M6_exit
/* QL:         M6_swap    d1 */
    swap d1
/* QL:         cmp.b   d1,d1           set condition codes to 0 */
    cmp.b d1,d1
/* QL:         rts */
    rts 
/* QL: * ss_jobc finds the current job id (d0), and base address (a3) */
/* QL: * d0  r  current job id */
/* QL: * a3  r  base of current job */
/* QL: ss_jobc */
ss_jobc:
/* QL:         bsr.s   M6_swap */
    bsr.s M6_swap
/* QL:         bsr.s   ss_joby */
    bsr.s ss_joby
/* QL: M6_swap */
M6_swap:
/* QL:         exg     a3,a0 */
    exg a0,a3
/* QL:         exg     d0,d1 */
    exg d0,d1
/* QL:         rts */
    rts 
/* QL:         end */
