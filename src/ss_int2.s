/* ROM section ss_int2 */
.balign 2,0
/* QL: regsone reg     d7/a5-a6        a data reg, a5, and base of sys_var */
/* QL: regstwo reg     d0-d6/a0-a4     the rest */
/* QL: M5_gpint */
M5_gpint:
/* QL: *       moveq   #0,d3           already set for us */
/* QL:         move.b  M5_sv_mdrun(a6),d3 get number of drive running */
    move.b M5_sv_mdrun(a6),d3
/* QL:         beq.s   M5_no_op */
    beq.s M5_no_op
/* QL:         lea     M5_sv_mddid(a6),a5 */
    lea M5_sv_mddid(a6),a5
/* QL:         sf      M5_sv_mdsta-M5_sv_mddid-1(a5,d3.w) clear service request */
    sf ((M5_sv_mdsta-M5_sv_mddid)-1)(a5,d3.w)
/* QL:         move.b  -1(a5,d3.w),d3  get drive id*4 */
    move.b (-1)(a5,d3.w),d3
/* QL:         move.l  M5_sv_fsdef-M5_sv_mddid(a5,d3.w),a5 ...hence address of definition */
    move.l (M5_sv_fsdef-M5_sv_mddid)(a5,d3.w),a5
/* QL:         lsl.b   #4-2,d3         drive id * 16 */
    lsl.b #(4-2),d3
/* QL:         addq.b  #1<<M5_bt..file,d3 + compare for file blocks */
    addq.b #(1<<M5_bt..file),d3
/* QL:         movem.l d0-d3/a4-a5,-(sp) set up stack frame (d0-d2 & d3.msw = buff) */
    movem.l d0-d3/a4-a5,-(sp)
/* QL:         move.l  sp,a1           and point to it */
    move.l sp,a1
/* QL:         jsr     md_serve(pc) */
    jsr md_serve(pc)
/* QL:         add.w   #6*4,sp         remove sector, drive id, a4 and a5 from stack */
    add.w #(6*4),sp
/* QL: M5_no_op */
M5_no_op:
/* QL:         moveq   #-1-M5_pc.maskg-M5_pc.intrg,d7 */
    moveq #(((-1)-M5_pc.maskg)-M5_pc.intrg),d7
/* QL:         and.b   M5_sv_pcint(a6),d7 temporarily mask gap interrupt */
    and.b M5_sv_pcint(a6),d7
/* QL:         addq.b  #M5_pc.intrg,d7    clear this interrupt */
    addq.b #M5_pc.intrg,d7
/* QL:         move.b  d7,M5_pc_intr-M5_pc_mctrl(a3) */
    move.b d7,(M5_pc_intr-M5_pc_mctrl)(a3)
/* QL:         clr.b   d7              next reset the gap mask to normal */
    clr.b d7
/* QL:         bra.s   M5_clearint        generate an interrupt if gap is already there */
    bra.s M5_clearint
/* QL: ss_intrd */
ss_intrd:
/* QL: * Non-redirected traps come here... maybe we can get away with just this. */
/* QL: ss_int2 */
ss_int2:
/* QL:         movem.l regsone,-(sp) */
    movem.l d7/a5-a6,-(sp)
/* QL:         move.l  a7,d7 */
    move.l a7,d7
/* QL:         and.w   #$8000,d7 */
    and.w #0x8000,d7
/* QL:         move.l  d7,a6           do not assume there is only one screen */
    move.l d7,a6
/* QL:         movem.l regstwo,-(sp) */
    movem.l d0-d6/a0-a4,-(sp)
/* QL:         lea     M5_pc_mctrl,a3 */
    lea M5_pc_mctrl,a3
/* QL:         assert  M5_pc_mctrl,M5_pc_intr-1 */
/* original assertion: M5_pc_mctrl,M5_pc_intr-1 */
/* QL:         move.w  (a3),d7         fetch the interrupt register to lsb (tigeftig) */
    move.w (a3),d7
/* QL:         assert  1<<4,M5_pc.intre,M5_pc.intrf<<1 */
/* original assertion: 1<<4,M5_pc.intre,M5_pc.intrf<<1 */
/* QL:         lsl.b   #4,d7           check for external or frame interrupts */
    lsl.b #4,d7
/* QL:         bcs.s   M5_exint */
    bcs.s M5_exint
/* QL:         bmi.s   M5_frint */
    bmi.s M5_frint
/* QL:         moveq   #0,d3           no missing polls is common-ish */
    moveq #0,d3
/* QL:         assert  1<<2,M5_pc.intrt,M5_pc.intri<<1 */
/* original assertion: 1<<2,M5_pc.intrt,M5_pc.intri<<1 */
/* QL:         lsl.b   #2,d7           check for transmit, interface & gap interrupts */
    lsl.b #2,d7
/* QL:         bcs.s   M5_txint */
    bcs.s M5_txint
/* QL:         bmi.s   M5_inint */
    bmi.s M5_inint
/* QL:         bne.s   M5_gpint */
    bne.s M5_gpint
/* QL:         bra.s   M5_nonred          no bits set! used for non-redirected traps! */
    bra.s M5_nonred
/* QL: M5_exint */
M5_exint:
/* QL:         moveq   #M5_sv_i2lst-M5_sv_i2lst,d4 set offset of int 2 list from int 2 list */
    moveq #(M5_sv_i2lst-M5_sv_i2lst),d4
/* QL:         jsr     ss_tlist(pc)    do all external interrupt tasks */
    jsr ss_tlist(pc)
/* QL:         moveq   #M5_pc.intre,d7    clear external */
    moveq #M5_pc.intre,d7
/* QL: M5_clearint */
M5_clearint:
/* QL:         or.b    M5_sv_pcint(a6),d7 get current interrupt mask */
    or.b M5_sv_pcint(a6),d7
/* QL:         move.b  d7,M5_pc_intr */
    move.b d7,M5_pc_intr
/* QL:         movem.l (sp)+,regstwo */
    movem.l (sp)+,d0-d6/a0-a4
/* QL: M5_one_rte */
M5_one_rte:
/* QL:         movem.l (sp)+,regsone */
    movem.l (sp)+,d7/a5-a6
/* QL:         rte */
    rte 
/* QL: ss_noer */
ss_noer:
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL: ss_rte */
ss_rte:
/* QL:         tst.w   M5_sv_pollm(a6)    check for missing polls */
    tst.w M5_sv_pollm(a6)
/* QL:         beq.s   M5_one_rte         none - return now */
    beq.s M5_one_rte
/* QL: M5_is_sup */
M5_is_sup:
/* QL:         moveq   #1<<5,d7 */
    moveq #(1<<5),d7
/* QL:         and.b   12(sp),d7       check if called from supervisor state */
    and.b 12(sp),d7
/* QL:         bne.s   M5_one_rte         yes - direct return */
    bne.s M5_one_rte
/* QL:         jmp     ss_reshd(pc)    reenter scheduler */
    jmp ss_reshd(pc)
/* QL: * Serial port transmit interrupt */
/* QL: M5_txint */
M5_txint:
/* QL: *       moveq   #0,d3           no missing polls already set */
/* QL:         st      d4              not called from scheduler */
    st d4
/* QL:         jsr     ip_txqo(pc)     send any rs232 */
    jsr ip_txqo(pc)
/* QL:         moveq   #M5_pc.intrt,d7    clear this interrupt */
    moveq #M5_pc.intrt,d7
/* QL:         bra.s   M5_clearint */
    bra.s M5_clearint
/* QL: * Interface interrupt, serial data available */
/* QL: M5_inint */
M5_inint:
/* QL: *       moveq   #0,d3           no missing polls alredy set */
/* QL:         jsr     ip_ipcr(pc)     read status and handle anything it says */
    jsr ip_ipcr(pc)
/* QL:         moveq   #M5_pc.intri,d7    clear this interrupt */
    moveq #M5_pc.intri,d7
/* QL:         bra.s   M5_clearint */
    bra.s M5_clearint
/* QL: * Frame interrupt, 50Hz (or 60Hz USA) */
/* QL: M5_frint */
M5_frint:
/* QL:         addq.w  #1,M5_sv_pollm(a6) increment count of poll interupts */
    addq.w #1,M5_sv_pollm(a6)
/* QL:         bvc.s   M5_do_poll         ... ok? */
    bvc.s M5_do_poll
/* QL:         subq.w  #1,M5_sv_pollm(a6) ... no reset it (slightly unsafe!) */
    subq.w #1,M5_sv_pollm(a6)
/* QL: M5_do_poll */
M5_do_poll:
/* QL:         moveq   #1,d3           just one poll since last time!! */
    moveq #1,d3
/* QL:         moveq   #M5_sv_plist-M5_sv_i2lst,d4 set offset of poll list from int 2 list */
    moveq #(M5_sv_plist-M5_sv_i2lst),d4
/* QL:         jsr     ss_tlist(pc)    scan the list */
    jsr ss_tlist(pc)
/* QL:         moveq   #M5_pc.intrf,d7    set to clear frame interrupt */
    moveq #M5_pc.intrf,d7
/* QL:         or.b    M5_sv_pcint(a6),d7 fetch interrupt register value */
    or.b M5_sv_pcint(a6),d7
/* QL:         move.b  d7,M5_pc_intr      and clear it */
    move.b d7,M5_pc_intr
/* QL: M5_nonred */
M5_nonred:
/* QL:         movem.l (sp)+,regstwo */
    movem.l (sp)+,d0-d6/a0-a4
/* QL:         bra.s   M5_is_sup          go see if we were in supervisor mode */
    bra.s M5_is_sup
/* QL:         end */
