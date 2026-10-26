/* ROM section bv_names */
.balign 2,0
/* QL: * Compact or copy machine code proedures and functions */
/* QL: * This is used at startup of a new copy of basic, to acquire M73_names from it's */
/* QL: * interpreting ancestor, the ROM or even elsewhere. */
/* QL: * In the interest of making the process fairly simple, though we could be */
/* QL: * terribly subtle, we get space for the whole of the nt and nl, then compact it */
/* QL: * as we copy it across. We could go to the bother of doing two scans, the first */
/* QL: * just to establish the size, but it seems a bit pedantic, as the extra space */
/* QL: * can be imediately released to the central area, and it won't be vast usually. */
/* QL: * d0 -o  - 0 */
/* QL: * d4 -  o- current job id */
/* QL: * a1 -i  - if not zero, -ve will force rom M73_names or positive some other set! */
/* QL: * a3 -  o- ram top address (wanted by job 0, and we happen to have it handy) */
/* QL: * d1-d3/a0-a2 destroyed */
/* QL: bv_namei */
bv_namei:
/* QL:         lea     M73_interp,a2       turn ourselves into an interpreter */
    lea M73_interp(pc),a2
/* QL:         moveq   #M73_mt.extop,d0 */
    moveq #M73_mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  M73_sv_ramt(a0),-(sp) save ram top */
    move.l M73_sv_ramt(a0),-(sp)
/* QL:         jsr     bv_chbfx(pc)    set buffer up right away (small one! 128 bytes) */
    jsr bv_chbfx(pc)
/* QL:         tst.l   d4 */
    tst.l d4
/* QL:         lea     bp_init0(pc),a2 */
    lea bp_init0(pc),a2
/* QL:         beq.s   M73_init            job 0 always uses rom m/c */
    beq.s M73_init
/* QL:         move.l  a1,d1 */
    move.l a1,d1
/* QL:         beq.s   M73_jobscan */
    beq.s M73_jobscan
/* QL:         bmi.s   M73_init            if table is given as positive, use it! */
    bmi.s M73_init
/* QL:         lea     bp_init(pc),a2 */
    lea bp_init(pc),a2
/* QL: M73_init */
M73_init:
/* QL:         jsr     (a2)            initialise rom m/c procedures and functions */
    jsr (a2)
/* QL:         bra.s   M73_donew */
    bra.s M73_donew
/* QL: M73_retry */
M73_retry:
/* QL:         sub.l   a2,d1           revert to required space */
    sub.l a2,d1
/* QL:         jsr     bv_chnlx(pc)    allocate the space, and try again */
    jsr bv_chnlx(pc)
/* QL: M73_jobscan */
M73_jobscan:
/* QL:         lea     M73_jobfind,a2 */
    lea M73_jobfind(pc),a2
/* QL:         moveq   #M73_mt.extop,d0 */
    moveq #M73_mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         tst.l   d2              check if we copied the tables OK */
    tst.l d2
/* QL:         bpl.s   M73_retry           not copied, so go increase our space */
    bpl.s M73_retry
/* QL:         bra.s   M73_donew           OK, we've done it, so continue to finish off */
    bra.s M73_donew
/* QL: * This is used by the NEW, etc commands to compact the local tables. */
/* QL: * d0-d3/a0-a2 destroyed */
/* QL: bv_names */
bv_names:
/* QL:         move.l  a3,-(sp)        just to agree with namei */
    move.l a3,-(sp)
/* QL:         assert  M73_bv_ntbas,M73_bv_ntp-4,M73_bv_nlbas-8 */
/* original assertion: M73_bv_ntbas,M73_bv_ntp-4,M73_bv_nlbas-8 */
/* QL:         movem.l M73_bv_ntbas(a6),d1-d2/a3 start at bottom of name table, up to top */
    movem.l M73_bv_ntbas(a6),d1-d2/a3
/* QL:         sub.l   d1,d2           total size of nt */
    sub.l d1,d2
/* QL:         moveq   #3,d3           bit to test for m/c (msbs zero) */
    moveq #3,d3
/* QL: M73_nx_mc */
M73_nx_mc:
/* QL:         addq.l  #8,d1 */
    addq.l #8,d1
/* QL:         subq.l  #8,d2           was there nothing but mc? */
    subq.l #8,d2
/* QL:         bcs.s   M73_donew           yes - all done */
    bcs.s M73_donew
/* QL:         btst    d3,-8(a6,d1.l)  are we still on mc procs & fns */
    btst d3,(-8)(a6,d1.l)
/* QL:         bne.s   M73_nx_mc           yes - keep looking */
    bne.s M73_nx_mc
/* QL: * We musn't confuse people when moving M73_names, so do it in supervisor mode */
/* QL:         lea     M73_names,a2 */
    lea M73_names(pc),a2
/* QL:         moveq   #M73_mt.extop,d0    increment non-sheduling mode (d0.l=0) */
    moveq #M73_mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL: M73_donew */
M73_donew:
/* QL:         move.l  (sp)+,a3        get back saved a3 for M73_names or ramtop for namei */
    move.l (sp)+,a3
/* QL:         jmp     bv_new(pc) */
    jmp bv_new(pc)
/* QL: * Set up stuff for job handling */
/* QL: M73_info */
M73_info:
/* QL:         moveq   #M73_mt.inf,d0      get system M73_info */
    moveq #M73_mt.inf,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  d1,d4           save own job id */
    move.l d1,d4
/* QL:         moveq   #64+M73_bv..int,d1  flag number and initial buffer request */
    moveq #(64+M73_bv..int),d1
/* QL:         assert  M73_sv_jbpnt,M73_sv_jbbas-4 */
/* original assertion: M73_sv_jbpnt,M73_sv_jbbas-4 */
/* QL:         movem.l M73_sv_jbpnt(a0),a2/a3 get jbpnt and jbbas */
    movem.l M73_sv_jbpnt(a0),a2/a3
/* QL:         move.l  (a2),a2         get pointer to header of current job */
    move.l (a2),a2
/* QL:         rts */
    rts 
/* QL: * Entry point for turning job into an interpreter */
/* QL: M73_interp */
M73_interp:
/* QL:         bsr.s   M73_info            get M73_info */
    bsr.s M73_info
/* QL:         clr.l   M73_jb_start(a2)    we can't be re-activated! */
    clr.l M73_jb_start(a2)
/* QL:         bset    d1,M73_jb_rela6(a2) set interpreter flag */
    bset d1,M73_jb_rela6(a2)
/* QL:         rte */
    rte 
/* QL: * Entry point to supervisor mode code scanning for interpreter ancestor */
/* QL: M73_jobfind */
M73_jobfind:
/* QL:         bsr.s   M73_info            set a2 = job header, a3 = jbbas */
    bsr.s M73_info
/* QL: M73_ancest */
M73_ancest:
/* QL:         move.w  M73_jb_owner+2(a2),d0 get owner job number (tag MUST match!) */
    move.w (M73_jb_owner+2)(a2),d0
/* QL:         lsl.w   #2,d0 */
    lsl.w #2,d0
/* QL:         move.l  0(a3,d0.w),a2   get owner header address */
    move.l 0(a3,d0.w),a2
/* QL:         beq.s   M73_j0ok            job 0 keeps its table at job base */
    beq.s M73_j0ok
/* QL:         btst    d1,M73_jb_rela6(a2) is this an interpreting ancestor? */
    btst d1,M73_jb_rela6(a2)
/* QL:         beq.s   M73_ancest          no - keep looking */
    beq.s M73_ancest
/* QL:         add.w   M73_jb_end+2(a2),a2 an interpreter must show where its tables are! */
    add.w (M73_jb_end+2)(a2),a2
/* QL: M73_j0ok */
M73_j0ok:
/* QL:         lea     M73_jb_end(a2),a0   point to tables */
    lea M73_jb_end(a2),a0
/* QL: * We have found an ancestor who is an interpreter... now copy their m/c stuff. */
/* QL:         assert  M73_bv_ntbas,M73_bv_ntp-4,M73_bv_nlbas-8,M73_bv_nlp-12 */
/* original assertion: M73_bv_ntbas,M73_bv_ntp-4,M73_bv_nlbas-8,M73_bv_nlp-12 */
/* QL:         lea     M73_bv_ntbas(a6),a1 */
    lea M73_bv_ntbas(a6),a1
/* QL:         move.l  (a1)+,a2 */
    move.l (a1)+,a2
/* QL:         move.l  a2,(a1)+ */
    move.l a2,(a1)+
/* QL:         move.l  a2,(a1)+ */
    move.l a2,(a1)+
/* QL:         move.l  a2,(a1)+        reset our existing tables */
    move.l a2,(a1)+
/* QL:         movem.l M73_bv_ntbas(a0),d0/d2-d3/a3 */
    movem.l M73_bv_ntbas(a0),d0/d2-d3/a3
/* QL:         sub.l   d3,a3           size of their name list */
    sub.l d3,a3
/* QL:         sub.l   d0,d2           size of their name table */
    sub.l d0,d2
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL:         add.l   a3,d1           total space in their name table + name list */
    add.l a3,d1
/* QL:         add.l   a2,d1           our new offset to top of name list */
    add.l a2,d1
/* QL:         cmp.l   (a1),d1         will it fit in below our nlp+4 */
    cmp.l (a1),d1
/* QL:         bhi.s   M73_rte0            no - go back and M73_retry (d2 >= 0) */
    bhi.s M73_rte0
/* QL: * We have a succesful check on space, so now copy their tables. */
/* QL:         move.l  d1,-(a1)        set nlp */
    move.l d1,-(a1)
/* QL:         sub.l   a3,d1 */
    sub.l a3,d1
/* QL:         move.l  d1,-(a1)        set nlbas */
    move.l d1,-(a1)
/* QL:         move.l  d1,-(a1)        set ntp */
    move.l d1,-(a1)
/* QL:         add.l   a0,d3           where their name list starts */
    add.l a0,d3
/* QL:         add.l   d0,a0           where their name table starts */
    add.l d0,a0
/* QL:         add.l   a6,a2           absolute base of our name table as destination */
    add.l a6,a2
/* QL:         move.l  a2,a3 */
    move.l a2,a3
/* QL:         add.l   d2,a3           absolute base of our name list as destination */
    add.l d2,a3
/* QL:         move.l  a3,d0           copy it for offset calculation */
    move.l a3,d0
/* QL:         bra.s   M73_nx_nt */
    bra.s M73_nx_nt
/* QL: * Note that d2.l < 0 when we have copied tables here  */
/* QL: M73_nx_end */
M73_nx_end:
/* QL:         sub.l   a6,a2           make new nt top relative */
    sub.l a6,a2
/* QL:         sub.l   a6,a3           make new nl top relative */
    sub.l a6,a3
/* QL:         move.l  a2,M73_bv_ntp(a6)   reset the top nt pointer */
    move.l a2,M73_bv_ntp(a6)
/* QL:         move.l  a3,M73_bv_nlp(a6)   reset the top namelist pointer */
    move.l a3,M73_bv_nlp(a6)
/* QL: M73_rte0 */
M73_rte0:
/* QL:         rte */
    rte 
/* QL: * Entry point for supervisor mode code for our own name table/list compaction */
/* QL: M73_names */
M73_names:
/* QL:         lea     -8(a6,d1.l),a0  this the first non-mc */
    lea (-8)(a6,d1.l),a0
/* QL:         move.l  a0,a2           two copies, one to scan and one to move */
    move.l a0,a2
/* QL:         add.l   a6,a3           make name list base absolute */
    add.l a6,a3
/* QL:         move.l  a3,d0           save destination name list base */
    move.l a3,d0
/* QL:         add.w   -6(a0),a3       set address of the last m/c name */
    add.w (-6)(a0),a3
/* QL:         move.b  (a3)+,d3        get it's length */
    move.b (a3)+,d3
/* QL:         add.w   d3,a3           any further m/c M73_names move down to here */
    add.w d3,a3
/* QL:         move.l  d0,d3           duplicate as source base, so we can share code */
    move.l d0,d3
/* QL: * d0 - absolute base of destination name list */
/* QL: * d1 - temporary (name length counter) */
/* QL: * d2 - remaining nt entry length */
/* QL: * d3 - absolute base of source name list */
/* QL: * a0 - absolute nt pointer */
/* QL: * a1 - temporary (old nl name pointer) */
/* QL: * a2 - absolute destination to copy nt entries down to */
/* QL: * a3 - absolute pointer to new name list */
/* QL: M73_nx_add */
M73_nx_add:
/* QL:         addq.l  #8,a0           step to next nt entry */
    addq.l #8,a0
/* QL: M73_nx_nt */
M73_nx_nt:
/* QL:         subq.l  #8,d2           have we finished yet? */
    subq.l #8,d2
/* QL:         bcs.s   M73_nx_end          yes - go finish off */
    bcs.s M73_nx_end
/* QL: M73_look */
M73_look:
/* QL:         btst    #3,(a0)         is this entry a mc proc/fn */
    btst #3,(a0)
/* QL:         beq.s   M73_nx_add          no - keep looking */
    beq.s M73_nx_add
/* QL:         move.w  (a0)+,(a2)+     move first word of nt entry down */
    move.w (a0)+,(a2)+
/* QL:         move.w  (a0)+,a1        get the old name list offset */
    move.w (a0)+,a1
/* QL:         add.l   d3,a1           this is where the name comes from */
    add.l d3,a1
/* QL:         move.w  a3,(a2) */
    move.w a3,(a2)
/* QL:         sub.w   d0,(a2)+        put in the new name list offset */
    sub.w d0,(a2)+
/* QL:         move.l  (a0)+,(a2)+     copy the other longword of the nt entry */
    move.l (a0)+,(a2)+
/* QL:         move.b  (a1),d1         get the name length */
    move.b (a1),d1
/* QL: M73_copy_nl */
M73_copy_nl:
/* QL:         move.b  (a1)+,(a3)+     copy a char */
    move.b (a1)+,(a3)+
/* QL:         subq.b  #1,d1 */
    subq.b #1,d1
/* QL:         bcc.s   M73_copy_nl         until they're all gone */
    bcc.s M73_copy_nl
/* QL:         bra.s   M73_nx_nt */
    bra.s M73_nx_nt
/* QL:         end */
