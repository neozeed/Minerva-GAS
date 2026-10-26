/* ROM section sd_curw */
.balign 2,0
/* QL: * d0   o error code */
/* QL: * a0 i p address of window control block */
/* QL: sd_curs */
sd_curs:
/* QL:         sf      -(sp)           flag -> 0 */
    sf -(sp)
/* QL:         tst.b   M114_sd_curf(a0)     check if visible */
    tst.b M114_sd_curf(a0)
/* QL:         bgt.s   M114_toggle */
    bgt.s M114_toggle
/* QL:         bra.s   M114_exit_set */
    bra.s M114_exit_set
/* QL: sd_cure */
sd_cure:
/* QL:         st      -(sp)           flag -> -1 */
    st -(sp)
/* QL:         tst.b   M114_sd_curf(a0)     check if already visible */
    tst.b M114_sd_curf(a0)
/* QL:         bgt.s   M114_exit_ok */
    bgt.s M114_exit_ok
/* QL:         jsr     sd_donl(pc)     issue newline if pending */
    jsr sd_donl(pc)
/* QL:         bra.s   M114_toggle */
    bra.s M114_toggle
/* QL: * d3 c   number of poll interrupts since last call */
/* QL: * d4   s scratch */
/* QL: * a0   s address of current window definition block */
/* QL: * a1   s address of system variables extension */
/* QL: * a6 c   base address of system variables */
/* QL: sd_sched */
sd_sched:
/* QL:         lea     M114_sv_fstat(a6),a0 */
    lea M114_sv_fstat(a6),a0
/* QL:         sub.w   d3,(a0)         decrement count */
    sub.w d3,(a0)
/* QL:         bcc.s   M114_rts0            if it's not gone nasty, leave it */
    bcc.s M114_rts0
/* QL:         move.l  M114_sv_chtop(a6),a1 this is where the sysvars extension lives */
    move.l M114_sv_chtop(a6),a1
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL:         move.b  M114_sx_fstat(a1),d4 */
    move.b M114_sx_fstat(a1),d4
/* QL:         lsr.b   #3,d4           use top 5 bits as flash rate (0,2,..,28,30) */
    lsr.b #3,d4
/* QL:         move.w  d4,(a0)         (flash rate odd iff underline cursor... so?) */
    move.w d4,(a0)
/* QL:         move.l  M114_sv_keyq(a6),d4  check if there are any queues */
    move.l M114_sv_keyq(a6),d4
/* QL:         beq.s   M114_rts0 */
    beq.s M114_rts0
/* QL:         move.l  d4,a0           put address in a0 */
    move.l d4,a0
/* QL:         lea     -M114_sd_end(a0),a0  point to start of block */
    lea (-M114_sd_end)(a0),a0
/* QL:         tst.b   M114_sd_curf(a0)     is cursor suppressed? */
    tst.b M114_sd_curf(a0)
/* QL:         beq.s   M114_rts0            yes - nothing to do */
    beq.s M114_rts0
/* QL: sd_curt */
sd_curt:
/* QL:         move.b  M114_sd_curf(a0),-(sp) */
    move.b M114_sd_curf(a0),-(sp)
/* QL:         beq.s   M114_exit_ok */
    beq.s M114_exit_ok
/* QL: M114_toggle */
M114_toggle:
/* QL:         jsr     sd_chchk(pc)    check if there is room for a character */
    jsr sd_chchk(pc)
/* QL:         bne.s   M114_exit */
    bne.s M114_exit
/* QL: regon   reg     d1-d3/a1 */
/* QL: regoff  reg     d0-d3/a1        (d0 just to discard space for colour masks) */
/* QL:         movem.l regon,-(sp) */
    movem.l d1-d3/a1,-(sp)
/* QL:         move.l  M114_sv_chtop(a6),a1 get sysvars extension */
    move.l M114_sv_chtop(a6),a1
/* QL:         move.b  M114_sx_fstat(a1),d1 */
    move.b M114_sx_fstat(a1),d1
/* QL:         jsr     cs_plain(pc) */
    jsr cs_plain(pc)
/* QL:         move.w  d2,-(sp) */
    move.w d2,-(sp)
/* QL:         move.w  d2,-(sp) */
    move.w d2,-(sp)
/* QL:         move.l  sp,a1 */
    move.l sp,a1
/* QL:         move.l  M114_sd_xmin(a0),d0  get top lhs of window */
    move.l M114_sd_xmin(a0),d0
/* QL:         add.l   M114_sd_xpos(a0),d0  add cursor position */
    add.l M114_sd_xpos(a0),d0
/* QL:         movem.w M114_sd_xinc(a0),d2/d3 set cursor size */
    movem.w M114_sd_xinc(a0),d2/d3
/* QL:         lsl.b   #4,d1 */
    lsl.b #4,d1
/* QL:         bpl.s   M114_curset */
    bpl.s M114_curset
/* QL:         add.w   d3,d0 */
    add.w d3,d0
/* QL:         lsr.w   #2,d3           make cursor occupy about 1/4 of charsize */
    lsr.w #2,d3
/* QL:         sub.w   d3,d0 */
    sub.w d3,d0
/* QL: M114_curset */
M114_curset:
/* QL:         move.w  d0,d1           split into two registers */
    move.w d0,d1
/* QL:         swap    d0 */
    swap d0
/* QL:         jsr     cs_over(pc) */
    jsr cs_over(pc)
/* QL:         movem.l (sp)+,regoff */
    movem.l (sp)+,d0-d3/a1
/* QL:         neg.b   (sp) */
    neg.b (sp)
/* QL: M114_exit_set */
M114_exit_set:
/* QL:         move.b  (sp),M114_sd_curf(a0)  set flag to new status */
    move.b (sp),M114_sd_curf(a0)
/* QL: M114_exit_ok */
M114_exit_ok:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M114_exit */
M114_exit:
/* QL:         addq.l  #2,sp */
    addq.l #2,sp
/* QL: M114_rts0 */
M114_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
