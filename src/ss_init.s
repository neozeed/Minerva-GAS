/* ROM section ss_init */
.balign 2,0
/* QL: * A routine to initialise bt, jb and ch tables */
/* QL: M2_set_tab */
M2_set_tab:
/* QL:         addq.l  #8,a0           for job/chan tables, move over top+tag+max */
    addq.l #8,a0
/* QL: M2_set_tabb */
M2_set_tabb:
/* QL:         move.l  d3,(a0)+        set current table pointer */
    move.l d3,(a0)+
/* QL:         move.l  d3,(a0)+        ... and bottom */
    move.l d3,(a0)+
/* QL:         add.l   d0,d3           add length */
    add.l d0,d3
/* QL:         move.l  d3,(a0)         and put in top */
    move.l d3,(a0)
/* QL:         rts */
    rts 
/* QL: * Initialise system */
/* QL: * d5 -i  - reset type (only lsb used) */
/* QL: * a5 -i  - top of available ram */
/* QL: * a7 -i  - top of system stack */
/* QL: * Once all the system variables, etc., have been set up, job 0 is be set up and */
/* QL: * activated. This routine then drops out to go user mode in job 0. */
/* QL: ss_init */
ss_init:
/* QL:         lea     M2_non020,a3       what our return address on a 68008 should be */
    lea M2_non020(pc),a3
/* QL:         moveq   #M2_mt.inf,d0      this trap is up and working enough to set a6 */
    moveq #M2_mt.inf,d0
/* QL:         trap    #1 */
    trap #1
/* QL: * Now, have a quick look to see if we're on a 68020. This is not much of method */
/* QL: * for doing this, but at least it'll work, until we can decide on a proper trap */
/* QL: * method that'll allow us to determine what processor we're on. */
/* QL: M2_non020 */
M2_non020:
/* QL:         cmp.l   -4(sp),a3       check the return address on the stack */
    cmp.l (-4)(sp),a3
/* QL:         beq.s   M2_not020          like 68008, i guess we're an ordinary machine */
    beq.s M2_not020
/* QL:         moveq   #1,d0           bit 0 = cache on */
    moveq #1,d0
/* QL:         dc.l    $4e7b0002       move d0,cr2... or some such */
.balign 2,0
M2_dc_anchor_632:
.long 0x4e7b0002
/* QL: M2_not020 */
M2_not020:
/* QL:         move.l  a0,a6           set up pointer to system variables */
    move.l a0,a6
/* QL: M2_wipesv */
M2_wipesv:
/* QL:         clr.l   (a0)+           ensure sv area is clean */
    clr.l (a0)+
/* QL:         cmp.l   a0,a7 */
    cmp.l a0,a7
/* QL:         bgt.s   M2_wipesv */
    bgt.s M2_wipesv
/* QL: * Initialise the hardware (maybe this should be moved to earlier on?) */
/* QL:         lea     M2_pc_intr,a3 */
    lea M2_pc_intr,a3
/* QL:         assert  M2_pc_tctrl,M2_pc_ipcwr-1 */
/* original assertion: M2_pc_tctrl,M2_pc_ipcwr-1 */
/* QL:         move.w  #1,M2_pc_tctrl-M2_pc_intr(a3) set transmit mode and reset link */
    move.w #1,(M2_pc_tctrl-M2_pc_intr)(a3)
/* QL: M2_s.mctrl equ     1<<M2_pc..writ!1<<M2_pc..sclk init M2_pc_mctrl (why the write bit? lwr) */
.equ M2_s.mctrl,((1<<M2_pc..writ)|(1<<M2_pc..sclk))
/* QL: M2_s.intr  equ     M2_pc.intre!M2_pc.intrf!M2_pc.intrt!M2_pc.intri!M2_pc.intrg clear interrupts */
.equ M2_s.intr,((((M2_pc.intre|M2_pc.intrf)|M2_pc.intrt)|M2_pc.intri)|M2_pc.intrg)
/* QL:         assert  M2_pc_mctrl,M2_pc_intr-1 */
/* original assertion: M2_pc_mctrl,M2_pc_intr-1 */
/* QL:         move.w  #M2_s.mctrl<<8!M2_s.intr,d0 */
    move.w #((M2_s.mctrl<<8)|M2_s.intr),d0
/* QL:         move.b  d0,(a3)+        clear any interrupts */
    move.b d0,(a3)+
/* QL: * That used to send a null to M2_pc_tdata (& maybe mc_ctrl=0), surely silly! */
/* QL: * Maybe this was in fact meant to give a break condition... need to check out! */
/* QL: * Even hermes doesn't yet notice a break on the line, though it could... */
/* QL:         move.w  d0,-(a3)        a3=mctrl, init mctrl and re-clear interrupts */
    move.w d0,-(a3)
/* QL:         move.b  #M2_pc.maskt!M2_pc.maski,M2_sv_pcint(a6)  set mask for no gap */
    move.b #((M2_pc.maskt|M2_pc.maski)&255),M2_sv_pcint(a6)
/* QL: * The IPC interrupt was useless. The IPC code did not implement its use for  */
/* QL: * signalling serial buffer full, as was intended. Up to 1.93, Minerva was */
/* QL: * totally ignoring it. now we have Hermes, it's back in 'cos the code works, */
/* QL: * signalling every eighth byte of serial input to keep us on our toes. */
/* QL:         jsr     md_desel(pc)            deselect microdrives */
    jsr md_desel(pc)
/* QL: * Now set up the resource tables and their pointers. */
/* QL: * We only assume that the size of memory available is a multiple of 512 bytes. */
/* QL:         move.l  a7,d3           start of tables is just above stack */
    move.l a7,d3
/* QL:         lea     M2_sv_btpnt(a6),a0 start filling at bt pointers */
    lea M2_sv_btpnt(a6),a0
/* QL:         move.l  a5,d0           slave blocks extend to top of ram */
    move.l a5,d0
/* QL:         sub.l   a6,d0           ... from base of system variables */
    sub.l a6,d0
/* QL:         lsr.l   #M2_sbb-M2_btb,d0     slave block table size */
    lsr.l #(M2_sbb-M2_btb),d0
/* QL:         bsr.s   M2_set_tabb */
    bsr.s M2_set_tabb
/* QL:         lsr.l   #1,d0           add half the space of slave blocks to */
    lsr.l #1,d0
/* QL:         add.l   d0,M2_sv_btpnt(a6) the initial pointer (a bit of a fudge...) */
    add.l d0,M2_sv_btpnt(a6)
/* QL:         move.l  d3,a3           save top of bt, bot of jt = the job 0 pointer */
    move.l d3,a3
/* QL:         lsr.l   #11+M2_btb-M2_sbb-1,d0 allow one job per 2k (2^11) of memory ... */
    lsr.l #(((11+M2_btb)-M2_sbb)-1),d0
/* QL:         addq.l  #8,d0           plus a bonus complement of eight */
    addq.l #8,d0
/* QL:         moveq   #120,d1         maximum number of jobs */
    moveq #120,d1
/* QL:         cmp.l   d1,d0 */
    cmp.l d1,d0
/* QL:         bls.s   M2_set_jtab */
    bls.s M2_set_jtab
/* QL:         move.l  d1,d0 */
    move.l d1,d0
/* QL: M2_set_jtab */
M2_set_jtab:
/* QL:         lsl.w   #M2_jtb,d0 */
    lsl.w #M2_jtb,d0
/* QL:         bsr.s   M2_set_tab */
    bsr.s M2_set_tab
/* QL:         mulu    #M2_cpj,d0         channels per job (but we will steal some...) */
    mulu #M2_cpj,d0
/* QL:         bsr.s   M2_set_tab */
    bsr.s M2_set_tab
/* QL:         subq.l  #1,d3           we must finish on a 512 byte boundary... */
    subq.l #1,d3
/* QL:         or.w    #M2_sbl-1,d3       ... so add a few channels to make certain */
    or.w #(M2_sbl-1),d3
/* QL:         addq.l  #1,d3           (awkward to get this right in any other way) */
    addq.l #1,d3
/* QL:         move.l  d3,a4           set the top of the system vars */
    move.l d3,a4
/* QL:         move.l  d3,M2_sv_cheap(a6) set start of common heap */
    move.l d3,M2_sv_cheap(a6)
/* QL:         move.l  d3,M2_sv_free(a6)  set start of free memory (end of common heap) */
    move.l d3,M2_sv_free(a6)
/* QL:         sub.l   a6,d3           take away base of system vars */
    sub.l a6,d3
/* QL:         lsr.l   #M2_sbb-M2_btb,d3     and divide to give the amount of bt entries */
    lsr.l #(M2_sbb-M2_btb),d3
/* QL:         add.l   a7,d3           permanently occupied at base of table */
    add.l a7,d3
/* QL: * Holding onto d3/d5/a0/a3/a5-a6 and modifying a4/a7... */
/* QL: * ... we steal some channels so we can build ram versions of the linkage data */
/* QL: * Note: d1 is currently 120, i.e. the msw is zero */
/* QL:         lea     ss_list(pc),a2  clever table... see source for structure */
    lea ss_list(pc),a2
/* QL:         moveq   #7-1,d0         first is the mdv count, and make msw zero */
    moveq #(7-1),d0
/* QL:         bra.s   M2_getlen          jump in to get things going */
    bra.s M2_getlen
/* QL: M2_lp_link */
M2_lp_link:
/* QL:         move.b  d1,d0           is this sx/od/dd now? */
    move.b d1,d0
/* QL:         beq.s   M2_storeit         no, the direct address is all we want */
    beq.s M2_storeit
/* QL:         move.l  d4,a1           it's an indirect pointer */
    move.l d4,a1
/* QL:         add.b   d0,d0           is there any copying to do? */
    add.b d0,d0
/* QL:         bcs.s   M2_lp_addr         if not sx/mdv, no extra bits */
    bcs.s M2_lp_addr
/* QL:         clr.l   -(a4)           (must clear, as we have not zeroed this area) */
    clr.l -(a4)
/* QL:         clr.w   -(a4)           3 words reserved at end of sx/mdv entries */
    clr.w -(a4)
/* QL: M2_lp_copy */
M2_lp_copy:
/* QL:         move.w  -(a1),-(a4)     copy the top bit of the sx/mdv entries ... */
    move.w -(a1),-(a4)
/* QL:         bne.s   M2_lp_copy         ... until we hit a zero */
    bne.s M2_lp_copy
/* QL: M2_lp_addr */
M2_lp_addr:
/* QL:         move.w  -(a1),d4        get lsw (msw is zero) */
    move.w -(a1),d4
/* QL:         beq.s   M2_storeit         allow for zeroes in mdv list */
    beq.s M2_storeit
/* QL:         add.w   a1,d4           add offset, ensuring < 32k */
    add.w a1,d4
/* QL: M2_storeit */
M2_storeit:
/* QL:         move.l  d4,-(a4)        store relocated address */
    move.l d4,-(a4)
/* QL:         subq.b  #2,d0 */
    subq.b #2,d0
/* QL:         bpl.s   M2_lp_addr         do all entries */
    bpl.s M2_lp_addr
/* QL:         move.l  d2,-(a4)        set linkage word */
    move.l d2,-(a4)
/* QL:         move.l  a4,d2           next linkage */
    move.l a4,d2
/* QL: M2_nxt_ptr */
M2_nxt_ptr:
/* QL:         move.w  -(a2),d0        get next pointer */
    move.w -(a2),d0
/* QL:         move.l  a2,d4           clears msw for us */
    move.l a2,d4
/* QL:         add.w   d0,d4           this is the absolute address, maybe */
    add.w d0,d4
/* QL:         lsr.w   #1,d0           was the thing we picked up odd? */
    lsr.w #1,d0
/* QL:         bcc.s   M2_lp_link         loop till we hit an odd one */
    bcc.s M2_lp_link
/* QL:         move.l  d2,-(sp)        save linkage start */
    move.l d2,-(sp)
/* QL: M2_getlen */
M2_getlen:
/* QL:         moveq   #0,d2           final link is zero */
    moveq #0,d2
/* QL:         move.w  d0,d1           put count byte into register */
    move.w d0,d1
/* QL:         bne.s   M2_nxt_ptr         carry on building if not zero */
    bne.s M2_nxt_ptr
/* QL: * We actually end up here with d0, d1 and d2 zero. */
/* QL: * The stack now holds 5 longwords ready to set linkage pointers, the last one */
/* QL: * not important here, though it was just used to set up the sysvars extension. */
/* QL: * We've now stolen the top of the channel table, so say so... */
/* QL:         move.l  a4,(a0)         modify M2_sv_chtop(a6) to point at linkages */
    move.l a4,(a0)
/* QL: M2_fil_jbch */
M2_fil_jbch:
/* QL:         assert  M2_jtb,M2_ctb */
/* original assertion: M2_jtb,M2_ctb */
/* QL:         subq.l  #1<<M2_jtb,a4 */
    subq.l #(1<<M2_jtb),a4
/* QL:         st      (a4)            fill job and channel tables with -1 msb */
    st (a4)
/* QL:         cmp.l   a4,a3           down to job 0 */
    cmp.l a4,a3
/* QL:         bne.s   M2_fil_jbch */
    bne.s M2_fil_jbch
/* QL:         moveq   #(M2_res_code+M2_bas_allc)>>(M2_sbb-M2_btb),d1 */
    moveq #((M2_res_code+M2_bas_allc)>>(M2_sbb-M2_btb)),d1
/* QL:         sub.w   d1,a3           take off initial alloc */
    sub.w d1,a3
/* QL: M2_clrtop */
M2_clrtop:
/* QL:         clr.l   -(a4)           wipe area for basic and resident section */
    clr.l -(a4)
/* QL:         cmp.l   a4,a3 */
    cmp.l a4,a3
/* QL:         bne.s   M2_clrtop */
    bne.s M2_clrtop
/* QL:         moveq   #1,d2 */
    moveq #1,d2
/* QL: M2_fill_bt */
M2_fill_bt:
/* QL:         assert  M2_bt_stat,0 */
/* original assertion: M2_bt_stat,0 */
/* QL:         subq.l  #M2_bt_end,a4 */
    subq.l #M2_bt_end,a4
/* QL:         move.b  d2,(a4)         fill status byte with 1 for free slave blocks */
    move.b d2,(a4)
/* QL:         cmp.l   a4,d3 */
    cmp.l a4,d3
/* QL:         bne.s   M2_fill_bt */
    bne.s M2_fill_bt
/* QL: * Now fill in miscellaneous bits of the system variable area */
/* QL:         movem.l (sp)+,d3/a0-a3 grab the linkage pointers (d3 is not used) */
    movem.l (sp)+,d3/a0-a3
/* QL:         assert  M2_sv_plist,M2_sv_shlst-4,M2_sv_drlst-8,M2_sv_ddlst-12 */
/* original assertion: M2_sv_plist,M2_sv_shlst-4,M2_sv_drlst-8,M2_sv_ddlst-12 */
/* QL:         movem.l a0-a3,M2_sv_plist(a6) set the pointers */
    movem.l a0-a3,M2_sv_plist(a6)
/* QL: M2_clrbot */
M2_clrbot:
/* QL:         clr.l   -(a4)           wipe area for permanent tables */
    clr.l -(a4)
/* QL:         cmp.l   a4,a7 */
    cmp.l a4,a7
/* QL:         bne.s   M2_clrbot */
    bne.s M2_clrbot
/* QL:         addq.b  #1,M2_sv_netnr(a6) set net station number to 1 */
    addq.b #1,M2_sv_netnr(a6)
/* QL:         assert  M2_sv_ardel,M2_sv_arfrq-2 */
/* original assertion: M2_sv_ardel,M2_sv_arfrq-2 */
/* QL:         move.l  #30<<16+2,M2_sv_ardel(a6) auto repeat delay = 600 ms */
    move.l #((30<<16)+2),M2_sv_ardel(a6)
/* QL:         ;                 M2_sv_arfrq 1/auto repeat frequency = 40ms */
/* QL:         addq.b  #3,M2_sv_cqch+1(a6) initially, old ctrl/c to change queues */
    addq.b #3,(M2_sv_cqch+1)(a6)
/* QL:         move.w  #M2_sv.ident,M2_sv_ident(a6) ident (tacky way sv's were to be found) */
    move.w #M2_sv.ident,M2_sv_ident(a6)
/* QL: ;        move.l  a5,M2_sv_ramt(a6)  set real top of ram */
/* QL:         assert  M2_res_code,0 */
/* original assertion: M2_res_code,0 */
/* QL: ;       lea     -M2_res_code(a5),a0 find top of working ram */
/* QL: ;       moveq   #M2_bas_allc>>(M2_sbb-M2_btb),d1 */
/* QL:         asl.l   #M2_sbb-M2_btb,d1 */
    asl.l #(M2_sbb-M2_btb),d1
/* QL:         move.l  a5,a0           find top of working ram */
    move.l a5,a0
/* QL:         assert  M2_sv_respr,M2_sv_ramt-4 */
/* original assertion: M2_sv_respr,M2_sv_ramt-4 */
/* QL: ;        move.l  a0,M2_sv_respr(a6) store as base of resident area */
/* QL:         movem.l a0/a5,M2_sv_respr(a6) store as base of resident area an top of ram */
    movem.l a0/a5,M2_sv_respr(a6)
/* QL:         move.l  a0,M2_sv_trnsp(a6) & transient base & it's basic's top */
    move.l a0,M2_sv_trnsp(a6)
/* QL:         sub.w   d1,a0           leave initial basic allocation */
    sub.w d1,a0
/* QL:         move.l  a0,M2_sv_basic(a6) and this is basic job defn block */
    move.l a0,M2_sv_basic(a6)
/* QL:         lea     M2_jb_end(a0),a1 */
    lea M2_jb_end(a0),a1
/* QL: M2_clrbas */
M2_clrbas:
/* QL:         clr.l   -(a1)           wipe job 0 header */
    clr.l -(a1)
/* QL:         cmp.l   a1,a0 */
    cmp.l a1,a0
/* QL:         blt.s   M2_clrbas */
    blt.s M2_clrbas
/* QL:         jsr     ss_jtag(pc)     make the tag tick, and a3 = job 0 jobtab ptr */
    jsr ss_jtag(pc)
/* QL:         lea     sb_start(pc),a1 */
    lea sb_start(pc),a1
/* QL:         ; a0 = header, a1 = start, a3 = jobtab ptr, d1 = overall size, so ... */
/* QL:         jsr     mt_cj0(pc)      set up the job 0 header */
    jsr mt_cj0(pc)
/* QL:         move.b  d5,-(a3)        tacky, but set lsb of saved a4 to reset flags */
    move.b d5,-(a3)
/* QL:         move.b  #32,M2_jb_princ-M2_jb_end(a0) activate job 0 */
    move.b #(32&255),(M2_jb_princ-M2_jb_end)(a0)
/* QL:         moveq   #M2_mt.cntry,d0 */
    moveq #M2_mt.cntry,d0
/* QL:         moveq   #0,d1           translation off */
    moveq #0,d1
/* QL: *       moveq   #1,d2           default messages (still 1 from above) */
/* QL:         trap    #1 */
    trap #1
/* QL:         move.w  #9600,d1        set rs232 9600 baud */
    move.w #9600,d1
/* QL:         moveq   #M2_mt.baud,d0 */
    moveq #M2_mt.baud,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         jmp     ss_rj0(pc)      this will start up basic */
    jmp ss_rj0(pc)
/* QL:         end */
