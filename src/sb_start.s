/* ROM section sb_start */
.balign 2,0
/* QL: * Entry point for basic start up. */
/* QL: * a0 -i  - initial command channel, or zero */
/* QL: * a4 -i  - job 0 restart flags in lsb */
/* QL: * a5 -i  - total size of the basic area */
/* QL: * a6 -ip - bottom of the basic area */
/* QL: * a7 -i  - pointer to standard exec parameters (count/chans/length/text) */
/* QL: M139_setbv */
M139_setbv:
/* QL:         move.l  d1,-(a6) */
    move.l d1,-(a6)
/* QL:         dbra    d0,M139_setbv */
    dbra d0,M139_setbv
/* QL: M139_rts1 */
M139_rts1:
/* QL:         rts */
    rts 
/* QL: sb_start */
sb_start:
/* QL:         move.l  a5,d3 */
    move.l a5,d3
/* QL:         add.l   a6,d3 */
    add.l a6,d3
/* QL:         sub.l   sp,d3           remember stack offset for out-of-mem setup */
    sub.l sp,d3
/* QL:         assert  0,M139_bv_chang&3,M139_bv_endpt&3,M139_bv_end&3 */
/* original assertion: 0,M139_bv_chang&3,M139_bv_endpt&3,M139_bv_end&3 */
/* QL:         moveq   #M139_bv_end>>2,d2   size of bv area */
    moveq #(M139_bv_end>>2),d2
/* QL:         assert  M139_minss,M139_bv_end */
/* original assertion: M139_minss,M139_bv_end */
/* QL:         lsl.w   #2+1,d2 */
    lsl.w #(2+1),d2
/* QL:         cmp.l   d2,a5           have we been given enough space to start with? */
    cmp.l d2,a5
/* QL:         pea     bv_om(pc)       if anything goes wrong during startup, die! */
    pea bv_om(pc)
/* QL:         blt.s   M139_rts1            no - don't go on... */
    blt.s M139_rts1
/* QL:         pea     sb_unvr(pc)     get ready to enter superbasic universe */
    pea sb_unvr(pc)
/* QL: M139_parms   equ     2*4             we have two longwords on stack before params */
.equ M139_parms,(2*4)
/* QL:         lsr.w   #1,d2 */
    lsr.w #1,d2
/* QL:         add.w   d2,a6 */
    add.w d2,a6
/* QL:         moveq   #0,d1           top of bv area all zero */
    moveq #0,d1
/* QL:         moveq   #(M139_bv_end-M139_bv_endpt-4)>>2-1,d0 */
    moveq #((((M139_bv_end-M139_bv_endpt)-4)>>2)-1),d0
/* QL:         bsr.s   M139_setbv */
    bsr.s M139_setbv
/* QL:         move.w  a5,d1 */
    move.w a5,d1
/* QL:         move.l  d1,-(a6)        set ssbas to top of basic area */
    move.l d1,-(a6)
/* QL:         sub.w   d2,d1           and next bunch point to the minimum stack there */
    sub.w d2,d1
/* QL:         moveq   #(M139_bv_endpt-M139_bv_chang)>>2-1,d0 */
    moveq #(((M139_bv_endpt-M139_bv_chang)>>2)-1),d0
/* QL:         bsr.s   M139_setbv */
    bsr.s M139_setbv
/* QL:         move.l  d2,d1           last bunch point to top of bv area */
    move.l d2,d1
/* QL:         moveq   #M139_bv_chang>>2-1,d0 */
    moveq #((M139_bv_chang>>2)-1),d0
/* QL:         bsr.s   M139_setbv           (a6 back to normal now) */
    bsr.s M139_setbv
/* QL:         move.l  d3,M139_bv_sssav(a6) save out-of-memory as death for now */
    move.l d3,M139_bv_sssav(a6)
/* QL:         move.l  a0,M139_bv_comch(a6) save any input command channel */
    move.l a0,M139_bv_comch(a6)
/* QL: * In-line clause and auto/edit flags are off */
/* QL:         st      M139_bv_rand+2(a6)   preset random number */
    st (M139_bv_rand+2)(a6)
/* QL:         st      M139_bv_cont(a6)     turn continue flag on (ie. stop off) */
    st M139_bv_cont(a6)
/* QL: *        st      M139_bv_print(a6)    set print from prtok flag on */
/* QL: * surely the above is a waste of time? */
/* QL:         jsr     ib_clvv(pc)     hit anything else that a clear would set up */
    jsr ib_clvv(pc)
/* QL: * We now have tables set up enough to become an interpreter */
/* QL:         jsr     bv_namei(pc)    go fetch m/c names, leaves RAM top in a3 ... */
    jsr bv_namei(pc)
/* QL:         move.l  d4,d0           ... and job id in d4 */
    move.l d4,d0
/* QL:         beq.l   M139_ini_job0        if we're job zero, go start up now */
    beq.w M139_ini_job0
/* QL:         sub.l   a4,a4           access passed info relative to sp */
    sub.l a4,a4
/* QL:         move.w  M139_parms(sp),d5    get number of channels passed */
    move.w M139_parms(sp),d5
/* QL:         beq.s   M139_nochans         none - forget it */
    beq.s M139_nochans
/* QL:         moveq   #-1,d1 */
    moveq #(-1),d1
/* QL:         move.w  d5,d2           a counter (we assume it's positive!) */
    move.w d5,d2
/* QL: M139_copych */
M139_copych:
/* QL:         move.l  M139_parms+2(sp,a4.l),a0 */
    move.l (M139_parms+2)(sp,a4.l),a0
/* QL:         addq.l  #4,a4 */
    addq.l #4,a4
/* QL: M139_samech */
M139_samech:
/* QL:         addq.w  #1,d1           next channel to open */
    addq.w #1,d1
/* QL:         cmp.w   #2,d1           are we about to open #2? */
    cmp.w #2,d1
/* QL:         beq.s   M139_samech          yes - skip that */
    beq.s M139_samech
/* QL:         jsr     bp_chnew(pc) */
    jsr bp_chnew(pc)
/* QL:         subq.w  #1,d2           have we finished the channel list? */
    subq.w #1,d2
/* QL:         bgt.s   M139_copych          no - skip test for duplicating channel #0 */
    bgt.s M139_copych
/* QL:         tst.w   d1              have we opened channel #1 yet? */
    tst.w d1
/* QL:         beq.s   M139_samech          no - let it repeat the same id as #0 */
    beq.s M139_samech
/* QL: M139_nochans */
M139_nochans:
/* QL: * Build CMD$ as an initial variable */
/* QL:         moveq   #1+4,d1 */
    moveq #(1+4),d1
/* QL:         jsr     bv_chnlx(pc) */
    jsr bv_chnlx(pc)
/* QL:         jsr     bv_chnt(pc) */
    jsr bv_chnt(pc)
/* QL:         move.l  M139_bv_ntp(a6),a3 */
    move.l M139_bv_ntp(a6),a3
/* QL:         move.w  #$201,0(a6,a3.l) t.var<<8|t.str */
    move.w #0x201,0(a6,a3.l)
/* QL:         addq.l  #1+4,M139_bv_nlp(a6) */
    addq.l #(1+4),M139_bv_nlp(a6)
/* QL:         movem.l M139_bv_nlbas(a6),d3/a1 */
    movem.l M139_bv_nlbas(a6),d3/a1
/* QL:         lea     M139_cmds+1+4,a0 */
    lea ((M139_cmds+1)+4)(pc),a0
/* QL: M139_ncpy */
M139_ncpy:
/* QL:         subq.l  #1,a1 */
    subq.l #1,a1
/* QL:         move.b  (a0),0(a6,a1.l) copy in characters of CMD$'s name */
    move.b (a0),0(a6,a1.l)
/* QL:         tst.b   -(a0) */
    tst.b -(a0)
/* QL:         bne.s   M139_ncpy */
    bne.s M139_ncpy
/* QL:         sub.w   d3,a1 */
    sub.w d3,a1
/* QL:         move.w  a1,2(a6,a3.l)   set namelist offset */
    move.w a1,2(a6,a3.l)
/* QL:         st      4(a6,a3.l)      just in case... */
    st 4(a6,a3.l)
/* QL:         addq.l  #8,M139_bv_ntp(a6) */
    addq.l #8,M139_bv_ntp(a6)
/* QL:         moveq   #2,d1 */
    moveq #2,d1
/* QL:         add.w   M139_parms+2(sp,a4.l),d1 get command length (we'll trust it's ok) */
    add.w (M139_parms+2)(sp,a4.l),d1
/* QL: * It would be a bit of a waste of code here to check the length out. */
/* QL: * We'll just put up with the fact that other than 0..32766 will cause problems, */
/* QL: * with -2 and -1, at least, possibly crashing the machine! */
/* QL:         jsr     bp_alvv(pc) */
    jsr bp_alvv(pc)
/* QL: M139_copycmd */
M139_copycmd:
/* QL:         move.b  M139_parms+2(sp,a4.l),0(a6,a0.l) */
    move.b (M139_parms+2)(sp,a4.l),0(a6,a0.l)
/* QL:         addq.l  #1,a4 */
    addq.l #1,a4
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         subq.l  #1,d1 */
    subq.l #1,d1
/* QL:         bne.s   M139_copycmd */
    bne.s M139_copycmd
/* QL:         tst.w   d5              did we get any channels passed in? */
    tst.w d5
/* QL:         bne.s   M139_rts2            yes - that's fine */
    bne.s M139_rts2
/* QL:         move.l  M139_bv_comch(a6),d4 did we get a command channel? */
    move.l M139_bv_comch(a6),d4
/* QL:         beq.l   M139_all_wind        no - we have no channels, go produce defaults */
    beq.w M139_all_wind
/* QL: M139_rts2 */
M139_rts2:
/* QL:         rts                     enter superbasic */
    rts 
/* QL: M139_plug_chk */
M139_plug_chk:
/* QL:         cmp.l   #$4afb0001,(a3) has it got the right id? */
    cmp.l #0x4afb0001,(a3)
/* QL:         bne.s   M139_plug_inc        ... no */
    bne.s M139_plug_inc
/* QL:         move.l  #$c000,a1       start from first conceivable slot */
    move.l #0xc000,a1
/* QL:         bra.s   M139_plug_ent */
    bra.s M139_plug_ent
/* QL: M139_plug_dup */
M139_plug_dup:
/* QL:         move.l  a3,a2 */
    move.l a3,a2
/* QL:         move.l  a1,a4 */
    move.l a1,a4
/* QL:         moveq   #128-1,d1       we'll check the first 512 bytes for a match */
    moveq #(128-1),d1
/* QL: M139_plug_cp */
M139_plug_cp:
/* QL:         cmp.l   (a4)+,(a2)+     does this still look like the same plug-in */
    cmp.l (a4)+,(a2)+
/* QL:         dbne    d1,M139_plug_cp      keep matching */
    dbne d1,M139_plug_cp
/* QL:         beq.s   M139_plug_inc        512 bytes the same! presumably the same plug-in */
    beq.s M139_plug_inc
/* QL:         exg     a1,a3 */
    exg a3,a1
/* QL:         bsr.s   M139_plug_inc        move to next possible slot */
    bsr.s M139_plug_inc
/* QL:         exg     a1,a3 */
    exg a3,a1
/* QL: M139_plug_ent */
M139_plug_ent:
/* QL:         cmp.l   a3,a1           are we back up to this one yet? */
    cmp.l a3,a1
/* QL:         bne.s   M139_plug_dup        no - keep checking for replicates */
    bne.s M139_plug_dup
/* QL: * The above attempts to avoid mapping in ROM's that appear more than once in */
/* QL: * the address space. */
/* QL: * This happens when address lines are not fully decoded and in cases like the */
/* QL: * Trump Card, which makes it's ROM at $10000 appear also at $c0000. */
/* QL: * Another point: the total ROM compared should be kept reasonably small, to */
/* QL: * avoid problems with ROM's that have their high addresses as hardware control. */
/* QL:         lsl.w   12(sp)          check if i2c is inhibiting this ROM */
    lsl.w 12(sp)
/* QL:         bcs.s   M139_plug_inc        it is, so skip (works ok with duplicates) */
    bcs.s M139_plug_inc
/* QL:         lea     8(a3),a1        write message from plug-in */
    lea 8(a3),a1
/* QL:         jsr     ut_mtext(pc) */
    jsr ut_mtext(pc)
/* QL:         move.w  4(a3),d0        get basic procedures from plug-in */
    move.w 4(a3),d0
/* QL:         beq.s   M139_plug_exe */
    beq.s M139_plug_exe
/* QL:         lea     0(a3,d0.w),a1   set the base address of procedure list */
    lea 0(a3,d0.w),a1
/* QL:         jsr     bp_init(pc)     set up the procedures */
    jsr bp_init(pc)
/* QL: M139_plug_exe */
M139_plug_exe:
/* QL:         move.w  6(a3),d0        execute plug-in initialisation */
    move.w 6(a3),d0
/* QL:         beq.s   M139_plug_inc */
    beq.s M139_plug_inc
/* QL:         jsr     0(a3,d0.w) */
    jsr 0(a3,d0.w)
/* QL: M139_plug_inc */
M139_plug_inc:
/* QL:         add.w   #$4000,a3       move on to next */
    add.w #0x4000,a3
/* QL:         cmp.l   #$18000,a3      is it end of low bits? (TK2!) */
    cmp.l #0x18000,a3
/* QL:         bne.s   M139_plug_meg */
    bne.s M139_plug_meg
/* QL:         move.l  8(sp),a3        set a3 to RAM top */
    move.l 8(sp),a3
/* QL: M139_plug_meg */
M139_plug_meg:
/* QL:         move.l  0,d0            pick up value from locn 0 */
    move.l 0,d0
/* QL:         rts */
    rts 
/* QL: M139_ini_job0 */
M139_ini_job0:
/* QL:         move.l  a4,-(sp)        save restart flags and clear ROM inhibits */
    move.l a4,-(sp)
/* QL:         move.l  a3,-(sp)        save RAM top address ... */
    move.l a3,-(sp)
/* QL:         move.l  a3,-(sp)        ... twice, to simplify ROM replication check */
    move.l a3,-(sp)
/* QL:         bsr.l   M139_ini_disp */
    bsr.w M139_ini_disp
/* QL: * Look for plug-ins */
/* QL:         btst    #1,11(sp)       have we been told not to scan ROM's? */
    btst #1,11(sp)
/* QL:         bne.s   M139_plug_out        yes - skip the ROM scan */
    bne.s M139_plug_out
/* QL:         move.l  #$c000,a3       first check ROM cartridge, etc */
    move.l #0xc000,a3
/* QL: M139_plug_on */
M139_plug_on:
/* QL:         bsr.s   M139_plug_chk */
    bsr.s M139_plug_chk
/* QL:         cmp.l   #$100000,a3 */
    cmp.l #0x100000,a3
/* QL:         bcs.s   M139_plug_on         always scan first megabyte */
    bcs.s M139_plug_on
/* QL:         cmp.l   (a3),d0         does it now look like we're wrapping? */
    cmp.l (a3),d0
/* QL:         bne.s   M139_plug_on         no - keep going */
    bne.s M139_plug_on
/* QL: M139_plug_out */
M139_plug_out:
/* QL:         assert  0,M139_plug_on+2+12-M139_plug_out */
/* original assertion: 0,M139_plug_on+2+12-M139_plug_out */
/* QL: * Above is all rearranged to cope with the horrendous MCS interface, which */
/* QL: * does the ROM check for itself, and then discards its own return address, adds */
/* QL: * twelve to the top of the stack and returns.... arghhhhh....!!!! */
/* QL:         addq.l  #8,sp           discard the RAM top addresses */
    addq.l #8,sp
/* QL:         moveq   #$0010,d3       f1-f4 bit, timeout and key count!!! */
    moveq #0x0010,d3
/* QL:         and.l   (sp),d3         test that flag */
    and.l (sp),d3
/* QL:         bne.s   M139_go_key          not zero - initial tiny wait for f1-f4 */
    bne.s M139_go_key
/* QL: * Find the mode */
/* QL: M139_read_key */
M139_read_key:
/* QL:         move.w  #$210,d3        normaly hang about for around 10 secs */
    move.w #0x210,d3
/* QL: M139_go_key */
M139_go_key:
/* QL:         moveq   #M139_io.fbyte,d0 */
    moveq #M139_io.fbyte,d0
/* QL:         trap    #3 */
    trap #3
/* QL:         addq.l  #-M139_err.nc,d0     check if timed out */
.word 20608|((((-M139_err.nc))&7)<<9)
/* QL:         beq.s   M139_set_mde1        yes, just use what we started with */
    beq.s M139_set_mde1
/* QL:         addq.b  #8,d1           f5 key = $f8 */
    addq.b #8,d1
/* QL:         add.b   d1,d3           check if {ctrl+}{shift+}f1-f4 (d3.lsb = $10) */
    add.b d1,d3
/* QL:         bcc.s   M139_read_key        not f1-f4, read again */
    bcc.s M139_read_key
/* QL:         roxl.b  #5,d3           set quick reset bit and dual to extend */
    roxl.b #5,d3
/* QL:         ror.b   #3,d3           slide TV/128k/ROM/quick bits down */
    ror.b #3,d3
/* QL:         roxr.b  #1,d3           slip in the dual bit */
    roxr.b #1,d3
/* QL:         moveq   #$40000>>16,d1  start getting 128k mask ready */
    moveq #(0x40000>>16),d1
/* QL:         bset    d1,d3           flag byte now: dual/0/0/f1-f4/TV/128k/ROM/quick */
    bset d1,d3
/* QL:         and.b   d3,d1           isolate 128k bit */
    and.b d3,d1
/* QL:         swap    d1              put it up in msw, now $40000 if 128k requested */
    swap d1
/* QL:         move.b  d3,d1           d1.l now ready for re-reset call */
    move.b d3,d1
/* QL:         move.l  (sp),d3         get top of stack */
    move.l (sp),d3
/* QL:         move.l  d1,(sp)         replace top of stack */
    move.l d1,(sp)
/* QL:         eor.b   d1,d3           check which bits differ */
    eor.b d1,d3
/* QL:         and.b   #%10000110,d3   do dualscreen, 128k and romscan bits agree? */
    and.b #(0b10000110&255),d3
/* QL: M139_set_mde1 */
M139_set_mde1:
/* QL:         beq.s   M139_set_mode        yes - we're happy to leave that as it is */
    beq.s M139_set_mode
/* QL:         jmp     390             no - go to magic reset location with d1.l set */
    jmp 390
/* QL: M139_get_mode */
M139_get_mode:
/* QL:         moveq   #-1,d2 */
    moveq #(-1),d2
/* QL:         moveq   #-1,d1 */
    moveq #(-1),d1
/* QL:         moveq   #M139_mt.dmode,d0 */
    moveq #M139_mt.dmode,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         lea     M139_mon_def,a1      address of first monitor mode window definition */
    lea M139_mon_def(pc),a1
/* QL:         tst.b   d2 */
    tst.b d2
/* QL:         beq.s   M139_rts3 */
    beq.s M139_rts3
/* QL:         lea     M139_tv_def,a1       address of first TV mode window definition */
    lea M139_tv_def(pc),a1
/* QL: M139_rts3 */
M139_rts3:
/* QL:         rts */
    rts 
/* QL: * No channels at all were passed. Do standard ones. */
/* QL: M139_all_wind */
M139_all_wind:
/* QL:         bsr.s   M139_get_mode        sets up definition pointer for us */
    bsr.s M139_get_mode
/* QL: M139_ini_wind */
M139_ini_wind:
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL:         bsr.s   M139_def_wind        open window #0 */
    bsr.s M139_def_wind
/* QL:         pea     M139_def_next        open #1 and #2, then return */
    pea M139_def_next(pc)
/* QL: M139_def_next */
M139_def_next:
/* QL:         addq.w  #1,d4           then do next # */
    addq.w #1,d4
/* QL:         add.w   #M139_wdef_len,a1    step on pointer */
    add.w #M139_wdef_len,a1
/* QL: M139_def_wind */
M139_def_wind:
/* QL:         jsr     ut_con(pc)      open a console */
    jsr ut_con(pc)
/* QL:         move.w  d4,d1 */
    move.w d4,d1
/* QL:         jmp     bp_chnew(pc)    and set up the basic channel */
    jmp bp_chnew(pc)
/* QL: * Maybe have a go at allowing TV windows but monitor mode, one day... or use */
/* QL: * both spare bits (6..5) as TV mode? (That even might get NTSC going!) */
/* QL: M139_set_mode */
M139_set_mode:
/* QL:         assert  1,M139_tvmode */
/* original assertion: 1,M139_tvmode */
/* QL:         moveq   #8,d1 */
    moveq #8,d1
/* QL:         and.l   (sp)+,d1        last use of restart flags, set display type */
    and.l (sp)+,d1
/* QL:         move.w  d1,d2 */
    move.w d1,d2
/* QL:         lsr.b   #3,d2           set monitor/TV mode */
    lsr.b #3,d2
/* QL:         moveq   #M139_mt.dmode,d0    n.b. nice... all channels have black paper */
    moveq #M139_mt.dmode,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         bsr.s   M139_get_mode        sets up definition pointer for us */
    bsr.s M139_get_mode
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL:         bsr.s   M139_mov_wind        put #0 in proper place */
    bsr.s M139_mov_wind
/* QL:         bsr.s   M139_mov_next        put #1 in proper place */
    bsr.s M139_mov_next
/* QL:         bsr.s   M139_mov_next        put #2 in proper place */
    bsr.s M139_mov_next
/* QL: * Look for a M139_boot file */
/* QL:         moveq   #-3*M139_boot_len,d4 */
    moveq #((-3)*M139_boot_len),d4
/* QL: M139_getboot */
M139_getboot:
/* QL:         addq.w  #M139_boot_len,d4    'mdv1_boot' string on 2nd try */
.word 20548|(((M139_boot_len)&7)<<9)
/* QL:         beq.s   M139_rts4            no M139_boot file, so go enter superbasic */
    beq.s M139_rts4
/* QL:         moveq   #M139_io.open,d0     try to open a M139_boot file */
    moveq #M139_io.open,d0
/* QL:         moveq   #-1,d1 */
    moveq #(-1),d1
/* QL:         moveq   #M139_io.share,d3 */
    moveq #M139_io.share,d3
/* QL:         lea     M139_boot+2*M139_boot_len(pc,d4.w),a0 try plain 'M139_boot' string first time */
    lea (M139_boot+(2*M139_boot_len))(pc,d4.w),a0
/* QL:         trap    #2 */
    trap #2
/* QL:         tst.l   d0              did the file open ok? */
    tst.l d0
/* QL:         bne.s   M139_getboot         no - try next one */
    bne.s M139_getboot
/* QL:         move.l  a0,M139_bv_comch(a6) set command channel */
    move.l a0,M139_bv_comch(a6)
/* QL: M139_rts4 */
M139_rts4:
/* QL:         rts                     enter superbasic */
    rts 
/* QL: M139_mov_next */
M139_mov_next:
/* QL:         addq.w  #1,d4           do next # */
    addq.w #1,d4
/* QL:         add.w   #M139_wdef_len,a1    step on pointer */
    add.w #M139_wdef_len,a1
/* QL: M139_mov_wind */
M139_mov_wind:
/* QL:         bsr.s   M139_chnid           select channel */
    bsr.s M139_chnid
/* QL: M139_wrdef */
M139_wrdef:
/* QL:         jmp     ut_wrdef(pc)    return via window redefinition */
    jmp ut_wrdef(pc)
/* QL: M139_boot    dc.w    4,'M139_boot' */
.balign 2,0
M139_boot:
M139_dc_anchor_1111:
.word 4
.byte 98,111,111,116
.balign 2,0
/* QL: M139_mdv1_   dc.w    9,'mdv1_boot' */
.balign 2,0
M139_mdv1_:
M139_dc_anchor_1118:
.word 9
.byte 109,100,118,49,95,98,111,111,116
.balign 2,0
/* QL: M139_boot_len equ M139_mdv1_-M139_boot */
.equ M139_boot_len,(M139_mdv1_-M139_boot)
/* QL: M139_ini_disp */
M139_ini_disp:
/* QL:         lea     M139_ini_def,a1 */
    lea M139_ini_def(pc),a1
/* QL:         bsr.s   M139_ini_wind        open channels #0, #1 and #2 */
    bsr.s M139_ini_wind
/* QL:         assert  0,M139_mt.inf */
/* original assertion: 0,M139_mt.inf */
/* QL: *       moveq   #M139_mt.inf,d0 */
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  d2,-(sp)        store qdos version number */
    move.l d2,-(sp)
/* QL:         move.l  #10<<24!10<<16!'  ',-(sp) nl,nl,sp,sp */
    move.l #(((10<<24)|(10<<16))|8224),-(sp)
/* QL:         jsr     ii_clock(pc)    get i2c clock if it's there */
    jsr ii_clock(pc)
/* QL: ;       moveq   #M139_mt.rclck,d0 */
/* QL: ;       trap    #1 */
/* QL:         move.l  sp,a1 */
    move.l sp,a1
/* QL:         sub.w   #2+34-8,sp */
    sub.w #((2+34)-8),sp
/* QL:         sub.l   a6,a1 */
    sub.l a6,a1
/* QL:         jsr     cn_date(pc) */
    jsr cn_date(pc)
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL:         jsr     cn_day(pc) */
    jsr cn_day(pc)
/* QL:         moveq   #10,d3 */
    moveq #10,d3
/* QL:         move.b  d3,7(sp) */
    move.b d3,7(sp)
/* QL:         move.b  d3,19(sp) */
    move.b d3,19(sp)
/* QL:         move.l  #34<<16!'K ',(sp) */
    move.l #((34<<16)|19232),(sp)
/* QL: * We now have, word prefixed, "K day\yyyy mmm dd\hh:mm:ss\\  vern" */
/* QL:         moveq   #2,d4 */
    moveq #2,d4
/* QL:         bsr.s   M139_chnid */
    bsr.s M139_chnid
/* QL:         moveq   #M139_err.bt,d0      put M139_boot message in #2, redefine then select #1 */
    moveq #M139_err.bt,d0
/* QL:         bsr.s   M139_err_mov */
    bsr.s M139_err_mov
/* QL:         move.l  2+34+4(sp),d1 */
    move.l ((2+34)+4)(sp),d1
/* QL:         lsl.l   #16-10,d1 */
    lsl.l #(16-10),d1
/* QL:         swap    d1 */
    swap d1
/* QL:         sub.w   #128,d1         don't count ROM, etc */
    sub.w #128,d1
/* QL:         jsr     ut_mint(pc)     print RAM size to #1 */
    jsr ut_mint(pc)
/* QL:         move.l  sp,a1           set buffer pointer */
    move.l sp,a1
/* QL:         jsr     ut_mtext(pc)    print rest of line #1 */
    jsr ut_mtext(pc)
/* QL:         add.w   (sp)+,sp        discard it all */
    add.w (sp)+,sp
/* QL:         moveq   #M139_err.cp,d0      final copyright in #1, redefine then select #0 */
    moveq #M139_err.cp,d0
/* QL: M139_err_mov */
M139_err_mov:
/* QL:         jsr     ut_err(pc)      print message */
    jsr ut_err(pc)
/* QL:         lea     M139_ini_def,a1      put back defn block pointer as for #0 */
    lea M139_ini_def(pc),a1
/* QL:         bsr.s   M139_wrdef           redefine same as #0 */
    bsr.s M139_wrdef
/* QL:         subq.w  #1,d4 */
    subq.w #1,d4
/* QL: M139_chnid */
M139_chnid:
/* QL:         move.w  d4,d1 */
    move.w d4,d1
/* QL:         jmp     bp_chnid(pc)    select next channel */
    jmp bp_chnid(pc)
/* QL: * Three sets of three window definitions: initial, monitor and TV */
/* QL: * NB. TK2 now searches for these window definitions, looking for the $ff010207 */
/* QL: * for window #1 in mon_def. It expects M139_tv_def to follow, and all the defs to */
/* QL: * be in this order. No way can it use M139_ini_def, but it doesn't want it... */
/* QL: M139_mon_def */
M139_mon_def:
/* QL:         dc.w    $0000,$0004,512,050,000,206     green on black, no border */
.balign 2,0
M139_dc_anchor_1214:
.word 0x0000
.word 0x0004
.word 512
.word 50
.word 0
.word 206
/* QL:         dc.w    $ff01,$0207,256,202,256,000     white on red, grey border */
.balign 2,0
M139_dc_anchor_1223:
.word 0xff01
.word 0x0207
.word 256
.word 202
.word 256
.word 0
/* QL:         dc.w    $ff01,$0702,256,202,000,000     red on white, grey border */
.balign 2,0
M139_dc_anchor_1232:
.word 0xff01
.word 0x0702
.word 256
.word 202
.word 0
.word 0
/* QL: M139_tv_def */
M139_tv_def:
/* QL:         dc.w    $0000,$0007,M139_tv_wid,M139_h_0,M139_x_n,M139_y_0  white on black, no border */
.balign 2,0
M139_dc_anchor_1243:
.word 0x0000
.word 0x0007
.word M139_tv_wid
.word M139_h_0
.word M139_x_n
.word M139_y_0
/* QL:         dc.w    $0000,$0207,M139_tv_wid,M139_h_n,M139_x_n,M139_y_n  white on red, no border */
.balign 2,0
M139_dc_anchor_1252:
.word 0x0000
.word 0x0207
.word M139_tv_wid
.word M139_h_n
.word M139_x_n
.word M139_y_n
/* QL:         dc.w    $0000,$0107,M139_tv_wid,M139_h_n,M139_x_n,M139_y_n  white on blue, no border */
.balign 2,0
M139_dc_anchor_1261:
.word 0x0000
.word 0x0107
.word M139_tv_wid
.word M139_h_n
.word M139_x_n
.word M139_y_n
/* QL: M139_ini_def */
M139_ini_def:
/* QL:         dc.w    $0000,$0004,M139_tv_wid,M139_y_c-M139_y_n,M139_x_n,M139_y_n green on black, no border */
.balign 2,0
M139_dc_anchor_1272:
.word 0x0000
.word 0x0004
.word M139_tv_wid
.word ((M139_y_c-M139_y_n))&65535
.word M139_x_n
.word M139_y_n
/* QL:         dc.w    $3802,$1006,M139_w_c,M139_h_c,M139_x_c,M139_y_c     white on dk red dk grey border */
.balign 2,0
M139_dc_anchor_1281:
.word 0x3802
.word 0x1006
.word M139_w_c
.word M139_h_c
.word M139_x_c
.word M139_y_c
/* QL:         dc.w    $ff01,$0206,M139_w_b,M139_h_b,M139_x_b,M139_y_b     white on red, grey border */
.balign 2,0
M139_dc_anchor_1290:
.word 0xff01
.word 0x0206
.word M139_w_b
.word M139_h_b
.word M139_x_b
.word M139_y_b
/* QL: M139_wdef_len equ (M139_tv_def-M139_mon_def)/3 */
.equ M139_wdef_len,((M139_tv_def-M139_mon_def)/3)
/* QL: M139_cmds    dc.w    4,'CMD$' */
.balign 2,0
M139_cmds:
M139_dc_anchor_1302:
.word 4
.byte 67,77,68,36
.balign 2,0
/* QL:         vect4000 sb_start */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ sb$start,(sb_start-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
