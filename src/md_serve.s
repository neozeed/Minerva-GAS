/* ROM section md_serve */
.balign 2,0
/* QL: * Report on bad on changed medium */
/* QL: M80_err_fe */
M80_err_fe:
/* QL:         lea     M80_md_mname(a5),a1 */
    lea M80_md_mname(a5),a1
/* QL:         tst.b   (a1)            is there a name to M80_write */
    tst.b (a1)
/* QL:         beq.s   M80_err_exit */
    beq.s M80_err_exit
/* QL:         sub.l   a0,a0           M80_write message to channel 0 */
    sub.l a0,a0
/* QL:         moveq   #M80_med.len,d2 */
    moveq #M80_med.len,d2
/* QL:         jsr     ut_write(pc)    medium name */
    jsr ut_write(pc)
/* QL:         moveq   #M80_err.fe,d0 */
    moveq #M80_err.fe,d0
/* QL:         jsr     ut_err(pc)      error message */
    jsr ut_err(pc)
/* QL: M80_err_exit */
M80_err_exit:
/* QL:         bsr.s   M80_clear           M80_clear out all existing slave blocks */
    bsr.s M80_clear
/* QL:         st      M80_md_estat(a5)    set error flag */
    st M80_md_estat(a5)
/* QL:         bra.l   M80_desel */
    bra.w M80_desel
/* QL: * Clear out the slave blocks and pending operations for a drive */
/* QL: * d1/a1 destroyed */
/* QL: M80_clear */
M80_clear:
/* QL:         move.l  M80_sv_btbas(a6),a1 start at base of slave block tables */
    move.l M80_sv_btbas(a6),a1
/* QL: M80_bt_clear */
M80_bt_clear:
/* QL:         moveq   #-16+1<<M80_bt..file,d1 set up mask for drive id */
    moveq #((-16)+(1<<M80_bt..file)),d1
/* QL:         assert  0,M80_bt_stat */
/* original assertion: 0,M80_bt_stat */
/* QL:         and.b   (a1),d1         get drive id*16 and file flag bit */
    and.b (a1),d1
/* QL:         cmp.b   M80_sav_drv+4(sp),d1 is it this drive? */
    cmp.b (M80_sav_drv+4)(sp),d1
/* QL:         bne.s   M80_bt_next */
    bne.s M80_bt_next
/* QL:         move.b  #M80_bt.empty,(a1)  .. yes M80_clear it */
    move.b #(M80_bt.empty&255),(a1)
/* QL: M80_bt_next */
M80_bt_next:
/* QL:         addq.l  #M80_bt_end,a1      next slave block */
    addq.l #M80_bt_end,a1
/* QL:         cmp.l   M80_sv_bttop(a6),a1 ... is the last ? */
    cmp.l M80_sv_bttop(a6),a1
/* QL:         bne.s   M80_bt_clear */
    bne.s M80_bt_clear
/* QL:         lea     M80_md_pendg(a5),a1 now M80_clear out all pending operations */
    lea M80_md_pendg(a5),a1
/* QL:         moveq   #M80_maxsec*2/4-1,d1 */
    moveq #(((M80_maxsec*2)/4)-1),d1
/* QL: M80_pend_clr */
M80_pend_clr:
/* QL:         clr.l   (a1)+ */
    clr.l (a1)+
/* QL:         dbra    d1,M80_pend_clr */
    dbra d1,M80_pend_clr
/* QL:         rts */
    rts 
/* QL: * Serve a microdrive gap interrupt */
/* QL: * Stack frame data has been set up for us. */
/* QL: * d0-d7/a0-a5 destroyed */
/* QL: md_serve */
md_serve:
/* QL:         move.b  M80_sv_mdcnt(a6),d2 get run-up / run-down count */
    move.b M80_sv_mdcnt(a6),d2
/* QL:         bge.s   M80_ok_up */
    bge.s M80_ok_up
/* QL:         addq.b  #1,d2           run up a bit */
    addq.b #1,d2
/* QL: M80_ok_up */
M80_ok_up:
/* QL:         jsr     md_sectr(pc)    get sector header */
    jsr md_sectr(pc)
/* QL: M80_err_msg */
M80_err_msg:
/* QL:         bra.s   M80_err_fe          ret+0 unreadable */
    bra.s M80_err_fe
/* QL:         rts                     ret+2 not a sector header */
    rts 
/* QL:                         ;       ret+4 ok */
/* QL:         assert  0,M80_mr.len&3 */
/* original assertion: 0,M80_mr.len&3 */
/* QL:         moveq   #M80_mr.len/4-1,d0 check the last bytes of the sector */
    moveq #((M80_mr.len/4)-1),d0
/* QL:         lea     M80_md_mname+M80_mr.len(a5),a2 against the stored name */
    lea (M80_md_mname+M80_mr.len)(a5),a2
/* QL: M80_chk_med */
M80_chk_med:
/* QL:         move.l  -(a2),d1 */
    move.l -(a2),d1
/* QL:         cmp.l   -(a1),d1 */
    cmp.l -(a1),d1
/* QL:         dbne    d0,M80_chk_med */
    dbne d0,M80_chk_med
/* QL:         beq.s   M80_same_med */
    beq.s M80_same_med
/* QL: * New medium in drive */
/* QL:         tst.b   M80_md_estat(a5)    a new medium is in - am I expecting it */
    tst.b M80_md_estat(a5)
/* QL:         ble.s   M80_err_msg         no - a problem */
    ble.s M80_err_msg
/* QL:         tst.b   M80_md_files(a5)    are there any files open? */
    tst.b M80_md_files(a5)
/* QL:         bne.s   M80_err_msg         yes - a disaster! */
    bne.s M80_err_msg
/* QL:         tst.b   d7              is it sector 0 ? */
    tst.b d7
/* QL:         bne.s   M80_anrts */
    bne.s M80_anrts
/* QL:         lea     M80_md_map(a5),a1   yes, read it in */
    lea M80_md_map(a5),a1
/* QL:         bsr.s   M80_go_read         doesn't return if no good */
    bsr.s M80_go_read
/* QL:         bsr.s   M80_clear           M80_clear out all existing slave blocks */
    bsr.s M80_clear
/* QL:         movem.l M80_hdr_mnm(sp),d0-d2 pick up medium name and random number */
    movem.l M80_hdr_mnm(sp),d0-d2
/* QL:         movem.l d0-d2,M80_md_mname(a5) put it all into physdef block */
    movem.l d0-d2,M80_md_mname(a5)
/* QL: M80_set_fnd */
M80_set_fnd:
/* QL:         sf      M80_md_estat(a5)    set medium name and map found */
    sf M80_md_estat(a5)
/* QL:         rts */
    rts 
/* QL: M80_same_med */
M80_same_med:
/* QL:         tst.b   M80_md_estat(a5)    medium is the same, was server checking it? */
    tst.b M80_md_estat(a5)
/* QL:         bgt.s   M80_set_fnd         yes, set medium found */
    bgt.s M80_set_fnd
/* QL:         add.w   d7,d7           set pointer to pending list */
    add.w d7,d7
/* QL:         bne.s   M80_not_map */
    bne.s M80_not_map
/* QL:         addq.b  #1,M80_md_fail(a5)  this is the map - update fail count */
    addq.b #1,M80_md_fail(a5)
/* QL:         cmp.b   #1+M80_maxfail,M80_md_fail(a5) */
    cmp.b #((1+M80_maxfail)&255),M80_md_fail(a5)
/* QL:         bgt.s   M80_err_msg */
    bgt.s M80_err_msg
/* QL: M80_not_map */
M80_not_map:
/* QL:         add.w   d7,a5 */
    add.w d7,a5
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         move.w  M80_md_pendg(a5),d1 get pending op */
    move.w M80_md_pendg(a5),d1
/* QL:         beq.l   M80_run_down */
    beq.w M80_run_down
/* QL:         tst.b   d2              was drive running down? */
    tst.b d2
/* QL:         ble.s   M80_ok_cnt */
    ble.s M80_ok_cnt
/* QL:         sf      d2              yes, M80_clear it */
    sf d2
/* QL: M80_ok_cnt */
M80_ok_cnt:
/* QL:         move.b  d2,M80_sv_mdcnt(a6) reset run_up M80_run_down */
    move.b d2,M80_sv_mdcnt(a6)
/* QL: * bug! patched by super GC - was addq.b */
/* QL:         addq.w  #2,d1           check for the two special cases (-1/-2) */
    addq.w #2,d1
/* QL:         bcc.s   M80_normal          it's not a special operation */
    bcc.s M80_normal
/* QL:         lea     M80_md_map(a5),a1   set base address of map */
    lea M80_md_map(a5),a1
/* QL:         beq.s   M80_ver_map         was -2 for M80_verify, so go do it */
    beq.s M80_ver_map
/* QL:         tst.b   d2              is it still running up? */
    tst.b d2
/* QL:         bmi.s   M80_anrts */
    bmi.s M80_anrts
/* QL:         move.w  #M80_mapfile<<8+0,-(sp) map file, block 0 */
    move.w #((M80_mapfile<<8)+0),-(sp)
/* QL:         jsr     md_write(pc) */
    jsr md_write(pc)
/* QL:         addq.l  #2,sp */
    addq.l #2,sp
/* QL:         moveq   #-2,d1          now M80_verify */
    moveq #(-2),d1
/* QL:         bra.s   M80_set_spc */
    bra.s M80_set_spc
/* QL: M80_go_read */
M80_go_read:
/* QL:         jsr     md_read(pc) */
    jsr md_read(pc)
/* QL:         addq.l  #4,sp           ret+0, bad, and drop return address */
    addq.l #4,sp
/* QL: M80_anrts */
M80_anrts:
/* QL:         rts                     ret+2, ok */
    rts 
/* QL: M80_ver_map */
M80_ver_map:
/* QL:         jsr     md_verin(pc)    M80_verify */
    jsr md_verin(pc)
/* QL:         bra.s   M80_bad_map         ret+0 bad */
    bra.s M80_bad_map
/* QL:                         ;       ret+2 ok */
/* QL:         moveq   #0,d1           ok no more special ops */
    moveq #0,d1
/* QL:         bra.s   M80_set_spc */
    bra.s M80_set_spc
/* QL: M80_bad_map */
M80_bad_map:
/* QL:         moveq   #-1,d1          M80_write it again */
    moveq #(-1),d1
/* QL: M80_set_spc */
M80_set_spc:
/* QL:         move.w  d1,M80_md_pendg(a5) set special op */
    move.w d1,M80_md_pendg(a5)
/* QL:         rts */
    rts 
/* QL: M80_normal */
M80_normal:
/* QL:         subq.w  #2,d1 */
    subq.w #2,d1
/* QL:         lsl.l   #M80_btbits,d1      convert to slave block pointer */
    lsl.l #M80_btbits,d1
/* QL:         move.l  M80_sv_btbas(a6),a4 */
    move.l M80_sv_btbas(a6),a4
/* QL: * bug corected by super GC - was add.w! */
/* QL:         add.l   d1,a4 */
    add.l d1,a4
/* QL:         move.l  a4,M80_sav_btp(sp)  and save it */
    move.l a4,M80_sav_btp(sp)
/* QL:         lsl.l   #M80_blkbits-M80_btbits,d1 set address of buffer */
    lsl.l #(M80_blkbits-M80_btbits),d1
/* QL:         lea     0(a6,d1.l),a1   now we have buffer pointer */
    lea 0(a6,d1.l),a1
/* QL:         move.b  (a4),d1 */
    move.b (a4),d1
/* QL:         assert  M80_bt..accs,M80_bt..wreq-1 */
/* original assertion: M80_bt..accs,M80_bt..wreq-1 */
/* QL:         lsl.b   #8-M80_bt..wreq,d1 */
    lsl.b #(8-M80_bt..wreq),d1
/* QL:         bcs.s   M80_write           M80_write required */
    bcs.s M80_write
/* QL:         bmi.s   M80_verify          M80_verify required */
    bmi.s M80_verify
/* QL:         bsr.s   M80_go_read         doesn't return if no good */
    bsr.s M80_go_read
/* QL:         bra.s   M80_read_ok */
    bra.s M80_read_ok
/* QL: M80_verify */
M80_verify:
/* QL:         jsr     md_verin(pc) */
    jsr md_verin(pc)
/* QL:         bra.s   M80_bad_veri        ret+0 bad */
    bra.s M80_bad_veri
/* QL:                         ;       ret+2 ok */
/* QL: M80_read_ok */
M80_read_ok:
/* QL:         clr.w   M80_md_pendg(a5)    M80_clear pending op */
    clr.w M80_md_pendg(a5)
/* QL:         move.l  M80_sav_pdf(sp),a1 */
    move.l M80_sav_pdf(sp),a1
/* QL:         sf      M80_md_fail(a1)     successful - M80_clear fail flag */
    sf M80_md_fail(a1)
/* QL:         moveq   #M80_bt.true,d0     true copy */
    moveq #M80_bt.true,d0
/* QL:         bra.s   M80_set_stat */
    bra.s M80_set_stat
/* QL: M80_bad_veri */
M80_bad_veri:
/* QL:         moveq   #M80_bt.updt,d0     M80_verify failed - M80_write again */
    moveq #M80_bt.updt,d0
/* QL:         bra.s   M80_set_stat */
    bra.s M80_set_stat
/* QL: M80_write */
M80_write:
/* QL:         tst.b   d2              is drive still running up */
    tst.b d2
/* QL:         bmi.s   M80_anrts */
    bmi.s M80_anrts
/* QL:         move.w  M80_md_map(a5),-(sp) put file / block on stack */
    move.w M80_md_map(a5),-(sp)
/* QL:         jsr     md_write(pc) */
    jsr md_write(pc)
/* QL:         addq.l  #2,sp */
    addq.l #2,sp
/* QL:         moveq   #M80_bt.aver,d0     now M80_verify */
    moveq #M80_bt.aver,d0
/* QL: M80_set_stat */
M80_set_stat:
/* QL:         movem.l M80_sav_drv-3(sp),d6/a4 restore drive*16+1 and slave block pointer */
    movem.l (M80_sav_drv-3)(sp),d6/a4
/* QL:         or.b    d0,d6           add the status */
    or.b d0,d6
/* QL:         move.b  d6,(a4) */
    move.b d6,(a4)
/* QL:         moveq   #M80_rundown-2,d2   check for M80_run_down after one sector */
    moveq #(M80_rundown-2),d2
/* QL: * Not a pending operation - check whether to run down */
/* QL: M80_run_down */
M80_run_down:
/* QL:         tst.b   d2 */
    tst.b d2
/* QL:         bmi.s   M80_set_cnt         still running up */
    bmi.s M80_set_cnt
/* QL:         addq.b  #1,d2 */
    addq.b #1,d2
/* QL:         cmp.b   #1+M80_rundown,d2   do not check every time */
    cmp.b #((1+M80_rundown)&255),d2
/* QL:         blt.s   M80_set_cnt */
    blt.s M80_set_cnt
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         moveq   #256-M80_maxsec,d0  check all sectors */
    moveq #(256-M80_maxsec),d0
/* QL:         move.l  M80_sav_pdf(sp),a5 */
    move.l M80_sav_pdf(sp),a5
/* QL:         lea     M80_md_pendg(a5),a5 */
    lea M80_md_pendg(a5),a5
/* QL: M80_chk_pend */
M80_chk_pend:
/* QL:         tst.w   (a5)+           pending op here? */
    tst.w (a5)+
/* QL:         bne.s   M80_set_cnt         yes, go do it */
    bne.s M80_set_cnt
/* QL:         addq.b  #1,d0 */
    addq.b #1,d0
/* QL:         bne.s   M80_chk_pend */
    bne.s M80_chk_pend
/* QL: M80_desel */
M80_desel:
/* QL:         jsr     md_desel(pc)    deselect this drive */
    jsr md_desel(pc)
/* QL:         lea     M80_sv_mdsta(a6),a5 */
    lea M80_sv_mdsta(a6),a5
/* QL:         moveq   #M80_maxdriv+1,d1   look to see if another drive is waiting */
    moveq #(M80_maxdriv+1),d1
/* QL: M80_look_next */
M80_look_next:
/* QL:         subq.b  #1,d1 */
    subq.b #1,d1
/* QL:         move.b  d1,M80_sv_mdrun(a6) say which drive is running */
    move.b d1,M80_sv_mdrun(a6)
/* QL:         beq.s   M80_quiet */
    beq.s M80_quiet
/* QL:         tst.b   -1(a5,d1.w) */
    tst.b (-1)(a5,d1.w)
/* QL:         beq.s   M80_look_next */
    beq.s M80_look_next
/* QL:         jsr     md_selec(pc)    select it */
    jsr md_selec(pc)
/* QL:         moveq   #-M80_runup,d2      run up */
    moveq #(-M80_runup),d2
/* QL: M80_set_cnt */
M80_set_cnt:
/* QL:         move.b  d2,M80_sv_mdcnt(a6) reset run_up M80_run_down */
    move.b d2,M80_sv_mdcnt(a6)
/* QL:         rts */
    rts 
/* QL: M80_quiet */
M80_quiet:
/* QL:         and.b   #$ff-M80_pc.maskg,M80_sv_pcint(a6) mask the gap interrupt */
    and.b #((0xff-M80_pc.maskg)&255),M80_sv_pcint(a6)
/* QL:         jmp     ss_rser(pc)     and re-enable serial output */
    jmp ss_rser(pc)
/* QL:         end */
