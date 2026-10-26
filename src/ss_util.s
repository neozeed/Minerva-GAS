/* ROM section ss_util */
.balign 2,0
/* QL: * ss_jtag establishes a new job slot. a4 is left pointing at sv_jbmax. It is */
/* QL: * called from mt_cjob and ss_init(for job 0). */
/* QL: * ss_tag establishes a new channel/job slot. It requires a4 to have been set */
/* QL: * to point at sv_xxbas, and it leaves with it pointing at sv_xxmax. */
/* QL: * It is only called from io_trap2 for a channel open: i.e. the "xx"'s are "ch". */
/* QL: * Both routines should be called with a negative error code in d0.l. */
/* QL: * On return, the flags are set from d0, which will be the supplied error */
/* QL: * code on failure, or will now contain the new job/channel id. This is now */
/* QL: * always positive, as tag values are prevented from exceeding $7fff. */
/* QL: * d0 i o +ve new id for the table or -ve error if table full */
/* QL: * a3   r pointer to slot found */
/* QL: * a4(i)r input as M8_sv_chbas at ss_tag. returns pointing at sv_xxmax. */
/* QL: * a6 ip  system variables, for jtag entry. */
/* QL:         assert  M8_sv_chtag-M8_sv_jbtag,M8_sv_chmax-M8_sv_jbmax, M8_sv_chbas-M8_sv_jbbas,M8_sv_chtop-M8_sv_jbtop */
/* original assertion: M8_sv_chtag-M8_sv_jbtag,M8_sv_chmax-M8_sv_jbmax, M8_sv_chbas-M8_sv_jbbas,M8_sv_chtop-M8_sv_jbtop */
/* QL: ss_jtag */
ss_jtag:
/* QL:         lea     M8_sv_jbbas(a6),a4 */
    lea M8_sv_jbbas(a6),a4
/* QL: ss_tag */
ss_tag:
/* QL:         move.l  d0,-(sp)        save poss error code */
    move.l d0,-(sp)
/* QL:         move.l  (a4)+,a3        get base of table */
    move.l (a4)+,a3
/* QL:         assert  M8_sv_jbtop,M8_sv_jbbas+4 */
/* original assertion: M8_sv_jbtop,M8_sv_jbbas+4 */
/* QL: M8_tag_loop */
M8_tag_loop:
/* QL:         cmp.l   (a4),a3         is this the end of the table? */
    cmp.l (a4),a3
/* QL:         bcc.s   M8_tag_ret         yes - go return d0 as the supplied err.xx */
    bcc.s M8_tag_ret
/* QL:         tst.l   (a3)+           is this a spare entry? */
    tst.l (a3)+
/* QL:         bpl.s   M8_tag_loop        no - carry on going */
    bpl.s M8_tag_loop
/* QL: M8_tag_this */
M8_tag_this:
/* QL:         subq.l  #4,a3           back up to the entry that was spare */
    subq.l #4,a3
/* QL:         move.l  a3,d0           copy address of entry */
    move.l a3,d0
/* QL:         sub.l   -(a4),d0        subtract base of table */
    sub.l -(a4),d0
/* QL:         lsr.w   #2,d0           divide by entry size gives job/channel number */
    lsr.w #2,d0
/* QL:         move.l  d0,(sp)         move this onto stack, setting lsw for return */
    move.l d0,(sp)
/* QL:         subq.l  #M8_sv_jbbas-M8_sv_jbtag,a4 */
.word 20876|((((M8_sv_jbbas-M8_sv_jbtag))&7)<<9)
/* QL:         move.w  (a4),(sp)       copy the tag on stack, setting msw for return */
    move.w (a4),(sp)
/* QL:         addq.w  #1,(a4)+        update the tag */
    addq.w #1,(a4)+
/* QL:         bpl.s   M8_tag_ok          not wrapping round, so it's ok for next time */
    bpl.s M8_tag_ok
/* QL:         lsr.w   -2(a4)          cheap... $8000 -> $4000, wrap last half of tags */
    lsr.w (-2)(a4)
/* QL: M8_tag_ok */
M8_tag_ok:
/* QL:         assert  M8_sv_jbmax,M8_sv_jbtag+2 */
/* original assertion: M8_sv_jbmax,M8_sv_jbtag+2 */
/* QL:         cmp.w   (a4),d0         have we ever got this high before? */
    cmp.w (a4),d0
/* QL:         bcs.s   M8_tag_ret         yes - leave it alone */
    bcs.s M8_tag_ret
/* QL:         move.w  d0,(a4)         no - better record this job/channel number */
    move.w d0,(a4)
/* QL: M8_tag_ret */
M8_tag_ret:
/* QL:         move.l  (sp)+,d0        reload d0 with original err or new id */
    move.l (sp)+,d0
/* QL:         rts                     return negative on error */
    rts 
/* QL:         end */
