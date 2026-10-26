/* ROM section ib_wscan */
.balign 2,0
/* QL: * d0 -  o- 0 M159_match found, -1 M159_match not found (n/a if d3 0) */
/* QL: * d1 - l - number of wvtab entries left to look at */
/* QL: * d2 - l - no of active wv entries left to look at */
/* QL: * d3 -i  - +ve look for M159_match on name row */
/* QL: *          -ve look for M159_match on endwhen lno */
/* QL: *            0 look for an M159_empty entry */
/* QL: * d4 -i  - name row, line number or irrelevent depending on d3 */
/* QL: * a2 -  o- entry in wv table */
/* QL: M159_empty */
M159_empty:
/* QL:         tst.b   d3              did we want an M159_empty slot? */
    tst.b d3
/* QL:         bne.s   M159_nx_add          no */
    bne.s M159_nx_add
/* QL:         rts */
    rts 
/* QL: M159_ewlno */
M159_ewlno:
/* QL:         cmp.w   M159_wv.ewlno(a6,a2.l),d4 does the endwhen lno M159_match? */
    cmp.w M159_wv.ewlno(a6,a2.l),d4
/* QL:         bne.s   ib_wscnx        no, try again */
    bne.s ib_wscnx
/* QL:         tst.w   M159_wv.rtlno(a6,a2.l) yes, is it in use? */
    tst.w M159_wv.rtlno(a6,a2.l)
/* QL:         blt.s   ib_wscnx        no, curses */
    blt.s ib_wscnx
/* QL: M159_match */
M159_match:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M159_no_match */
M159_no_match:
/* QL:         moveq   #-1,d0 */
    moveq #(-1),d0
/* QL:         rts */
    rts 
/* QL: M159_none_set */
M159_none_set:
/* QL:         tst.b   d3              no entries, do we care? */
    tst.b d3
/* QL:         bne.s   M159_no_match        no */
    bne.s M159_no_match
/* QL:         tst.b   M159_bv_wvbas(a6)    yes, are there any M159_empty ones? */
    tst.b M159_bv_wvbas(a6)
/* QL:         bmi.s   M159_expand          no, better make some then */
    bmi.s M159_expand
/* QL: M159_get_base */
M159_get_base:
/* QL:         move.l  M159_bv_vvbas(a6),a2 base of vv area */
    move.l M159_bv_vvbas(a6),a2
/* QL:         add.l   M159_bv_wvbas(a6),a2 add offset to get base of wv table */
    add.l M159_bv_wvbas(a6),a2
/* QL: M159_get_count */
M159_get_count:
/* QL:         moveq   #-M159_wv.len-4,d1   take off size and length of 1st entry */
    moveq #((-M159_wv.len)-4),d1
/* QL:         add.l   0(a6,a2.l),d1   size of table (not to be confused with */
    add.l 0(a6,a2.l),d1
/* QL:                 ;               the number of active when variable entries) */
/* QL:         lsr.l   #M159_wvshft,d1      d1 is now suitable for a "dbra" */
    lsr.l #M159_wvshft,d1
/* QL:         addq.l  #4,a2           position a2 at 1st entry */
    addq.l #4,a2
/* QL:         rts */
    rts 
/* QL: ib_wscan */
ib_wscan:
/* QL:         move.w  M159_bv_wvnum(a6),d2 number of wv entries */
    move.w M159_bv_wvnum(a6),d2
/* QL:         beq.s   M159_none_set        none */
    beq.s M159_none_set
/* QL:         bsr.s   M159_get_base        get base of table */
    bsr.s M159_get_base
/* QL: M159_nx_chk */
M159_nx_chk:
/* QL:         move.w  M159_wv.row(a6,a2.l),d0 get next name row */
    move.w M159_wv.row(a6,a2.l),d0
/* QL:         bmi.s   M159_empty           it's M159_empty */
    bmi.s M159_empty
/* QL:         tst.b   d3              what are we looking for */
    tst.b d3
/* QL:         blt.s   M159_ewlno           an endwhen line number */
    blt.s M159_ewlno
/* QL:         beq.s   M159_nx_add          an M159_empty slot */
    beq.s M159_nx_add
/* QL:         cmp.w   d0,d4           a name row, is it this one? */
    cmp.w d0,d4
/* QL:         beq.s   M159_match           yes, good */
    beq.s M159_match
/* QL: ib_wscnx */
ib_wscnx:
/* QL:         subq.w  #1,d2           decrement active wv entries left */
    subq.w #1,d2
/* QL:         beq.s   M159_no_match        none left */
    beq.s M159_no_match
/* QL: M159_nx_add */
M159_nx_add:
/* QL:         add.w   #M159_wv.len,a2      move to next entry */
    add.w #M159_wv.len,a2
/* QL:         dbra    d1,M159_nx_chk       (if there is one, that is) */
    dbra d1,M159_nx_chk
/* QL: M159_expand */
M159_expand:
/* QL:         moveq   #-1,d1          assume current table length is zero */
    moveq #(-1),d1
/* QL:         tst.b   M159_bv_wvbas(a6)    is there a table here? */
    tst.b M159_bv_wvbas(a6)
/* QL:         bmi.s   M159_get_new         no, we'll make a new one */
    bmi.s M159_get_new
/* QL:         bsr.s   M159_get_base        find how many entries already exist */
    bsr.s M159_get_base
/* QL: M159_get_new */
M159_get_new:
/* QL:         moveq   #20+1,d0        extend by 20 entries */
    moveq #(20+1),d0
/* QL:         add.l   d0,d1 */
    add.l d0,d1
/* QL:         lsl.l   #M159_wvshft,d1 */
    lsl.l #M159_wvshft,d1
/* QL:         addq.l  #4,d1           don't forget the length word */
    addq.l #4,d1
/* QL:         jsr     bv_alvv(pc)     get space for new table */
    jsr bv_alvv(pc)
/* QL:         move.l  d1,0(a6,a0.l)   store size of new table */
    move.l d1,0(a6,a0.l)
/* QL:         move.l  a0,-(sp)        save new table address */
    move.l a0,-(sp)
/* QL:         move.l  a0,a2 */
    move.l a0,a2
/* QL:         bsr.s   M159_get_count       work out how many entries the new table has */
    bsr.s M159_get_count
/* QL:         tst.b   M159_bv_wvbas(a6) */
    tst.b M159_bv_wvbas(a6)
/* QL:         bmi.s   M159_nocopy          this is the first allocation, so no copy */
    bmi.s M159_nocopy
/* QL:         subq.w  #1,d1           dbra for initialising new entries is ... */
    subq.w #1,d1
/* QL:         move.w  d1,-(sp)        ... (new table dbra - old table dbra - 1) */
    move.w d1,-(sp)
/* QL:         bsr.s   M159_get_base        get the old table stuff */
    bsr.s M159_get_base
/* QL:         sub.w   d1,(sp) */
    sub.w d1,(sp)
/* QL: M159_copynxt */
M159_copynxt:
/* QL:         moveq   #M159_wv.len/4-1,d0 */
    moveq #((M159_wv.len/4)-1),d0
/* QL: M159_copy4 */
M159_copy4:
/* QL:         move.l  0(a6,a2.l),4(a6,a0.l) copy the next long word */
    move.l 0(a6,a2.l),4(a6,a0.l)
/* QL: M159_copent */
M159_copent:
/* QL:         addq.l  #4,a2 */
    addq.l #4,a2
/* QL:         addq.l  #4,a0 */
    addq.l #4,a0
/* QL:         dbra    d0,M159_copy4 */
    dbra d0,M159_copy4
/* QL:         dbra    d1,M159_copynxt */
    dbra d1,M159_copynxt
/* QL:         move.w  (sp)+,d1        recover counter for clearing entries */
    move.w (sp)+,d1
/* QL:         lea     4(a0),a2        first entry to M159_clear */
    lea 4(a0),a2
/* QL: M159_nocopy */
M159_nocopy:
/* QL:         moveq   #M159_wv.len,d0 */
    moveq #M159_wv.len,d0
/* QL:         move.l  a2,-(sp)        save first of new, free entries */
    move.l a2,-(sp)
/* QL: M159_clear */
M159_clear:
/* QL:         st      M159_wv.row(a6,a2.l) M159_empty entries are negative */
    st M159_wv.row(a6,a2.l)
/* QL:         add.w   #M159_wv.len,a2 */
    add.w #M159_wv.len,a2
/* QL:         dbra    d1,M159_clear */
    dbra d1,M159_clear
/* QL:         move.l  M159_bv_wvbas(a6),d1 get offset of old table */
    move.l M159_bv_wvbas(a6),d1
/* QL:         blt.s   M159_nofrvv          wasn't one */
    blt.s M159_nofrvv
/* QL:         move.l  M159_bv_vvbas(a6),a0 */
    move.l M159_bv_vvbas(a6),a0
/* QL:         add.l   d1,a0           start of old table */
    add.l d1,a0
/* QL:         move.l  0(a6,a0.l),d1   length of old table */
    move.l 0(a6,a0.l),d1
/* QL:         jsr     bv_frvv(pc)     free it */
    jsr bv_frvv(pc)
/* QL: M159_nofrvv */
M159_nofrvv:
/* QL:         move.l  (sp)+,a2        first unset entry */
    move.l (sp)+,a2
/* QL:         move.l  (sp)+,d1 */
    move.l (sp)+,d1
/* QL:         sub.l   M159_bv_vvbas(a6),d1 new offset */
    sub.l M159_bv_vvbas(a6),d1
/* QL:         move.l  d1,M159_bv_wvbas(a6) store it */
    move.l d1,M159_bv_wvbas(a6)
/* QL:         rts */
    rts 
/* QL: * Tests if an assignment just made to the variable indicated by its */
/* QL: * name row (token value in program file) satisfies some of the current */
/* QL: * when variable conditions, and,if so, resets the parser to take  */
/* QL: * appropriate action. */
/* QL: * d0     o error return */
/* QL: * d4 i s   name row of variable just assigned to */
/* QL: * a4 i   o parser pointer to program file */
/* QL: * Note: apart from a4, any register may be smashed */
/* QL: ib_wtest */
ib_wtest:
/* QL:         moveq   #1,d3           look for it */
    moveq #1,d3
/* QL:         bsr     ib_wscan */
    bsr ib_wscan
/* QL:         bra.s   M159_chk_cond */
    bra.s M159_chk_cond
/* QL: M159_nx_load */
M159_nx_load:
/* QL:         movem.w (sp)+,d1-d2/d4 */
    movem.w (sp)+,d1-d2/d4
/* QL: M159_nx_scan */
M159_nx_scan:
/* QL:         moveq   #1,d3 */
    moveq #1,d3
/* QL:         bsr     ib_wscnx        look for another */
    bsr ib_wscnx
/* QL: M159_chk_cond */
M159_chk_cond:
/* QL:         bne.s   M159_okrts           not found */
    bne.s M159_okrts
/* QL:         tst.b   M159_wv.rtlno(a6,a2.l) musn't be already in use */
    tst.b M159_wv.rtlno(a6,a2.l)
/* QL:         bpl.s   M159_nx_scan         it is */
    bpl.s M159_nx_scan
/* QL:         move.w  M159_bv_linum(a6),M159_wv.rtlno(a6,a2.l) */
    move.w M159_bv_linum(a6),M159_wv.rtlno(a6,a2.l)
/* QL:         move.b  M159_bv_stmnt(a6),M159_wv.rtstm(a6,a2.l) */
    move.b M159_bv_stmnt(a6),M159_wv.rtstm(a6,a2.l)
/* QL:         move.b  M159_bv_inlin(a6),M159_wv.rtinl(a6,a2.l) */
    move.b M159_bv_inlin(a6),M159_wv.rtinl(a6,a2.l)
/* QL:         move.w  M159_bv_index(a6),M159_wv.rtind(a6,a2.l) */
    move.w M159_bv_index(a6),M159_wv.rtind(a6,a2.l)
/* QL:         movem.w d1-d2/d4,-(sp) */
    movem.w d1-d2/d4,-(sp)
/* QL:         assert  M159_wv.wlno,M159_wv.wstm-2 */
/* original assertion: M159_wv.wlno,M159_wv.wstm-2 */
/* QL:         move.l  M159_wv.wlno(a6,a2.l),d4 get when line/statement number */
    move.l M159_wv.wlno(a6,a2.l),d4
/* QL:         tst.b   M159_bv_sing(a6)     is this a command line */
    tst.b M159_bv_sing(a6)
/* QL:         beq.s   M159_golin           no, ok */
    beq.s M159_golin
/* QL:         jsr     ib_stbas(pc)    yes, find the top */
    jsr ib_stbas(pc)
/* QL: M159_golin */
M159_golin:
/* QL:         bsr.s   M159_goto            go to it */
    bsr.s M159_goto
/* QL:         bne.s   M159_pop_6 */
    bne.s M159_pop_6
/* QL:         jsr     ib_nxnon(pc)    get the when */
    jsr ib_nxnon(pc)
/* QL:         lea     2(a4),a0        skip it */
    lea 2(a4),a0
/* QL:         sub.l   M159_bv_vvbas(a6),a2 */
    sub.l M159_bv_vvbas(a6),a2
/* QL:         move.l  a2,-(sp) */
    move.l a2,-(sp)
/* QL:         jsr     ca_evalc(pc)    and evaluate the condition */
    jsr ca_evalc(pc)
/* QL:         move.l  (sp)+,a2 */
    move.l (sp)+,a2
/* QL:         add.l   M159_bv_vvbas(a6),a2 restore wv entry */
    add.l M159_bv_vvbas(a6),a2
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         ble.s   M159_pop_6           failed */
    ble.s M159_pop_6
/* QL:         addq.l  #2,M159_bv_rip(a6) */
    addq.l #2,M159_bv_rip(a6)
/* QL:         tst.w   0(a6,a1.l)      true or false? */
    tst.w 0(a6,a1.l)
/* QL:         bne.s   M159_gotit           true! we've got work to do */
    bne.s M159_gotit
/* QL:         bsr.s   ib_ewret        return to here */
    bsr.s ib_ewret
/* QL:         beq.s   M159_nx_load */
    beq.s M159_nx_load
/* QL: M159_pop_6 */
M159_pop_6:
/* QL:         addq.l  #6,sp */
    addq.l #6,sp
/* QL:         rts */
    rts 
/* QL: M159_gotit */
M159_gotit:
/* QL:         addq.l  #6,sp */
    addq.l #6,sp
/* QL:         move.b  M159_wv.inlin(a6,a2.l),M159_bv_inlin(a6) */
    move.b M159_wv.inlin(a6,a2.l),M159_bv_inlin(a6)
/* QL: M159_okrts */
M159_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: ib_ewret */
ib_ewret:
/* QL:         assert  M159_wv.rtlno,M159_wv.rtstm-2 */
/* original assertion: M159_wv.rtlno,M159_wv.rtstm-2 */
/* QL:         move.l  M159_wv.rtlno(a6,a2.l),d4 return line/statement number */
    move.l M159_wv.rtlno(a6,a2.l),d4
/* QL:         st      M159_wv.rtlno(a6,a2.l) mark as no longer in use */
    st M159_wv.rtlno(a6,a2.l)
/* QL:         move.b  M159_wv.rtinl(a6,a2.l),M159_bv_inlin(a6) */
    move.b M159_wv.rtinl(a6,a2.l),M159_bv_inlin(a6)
/* QL:         move.w  M159_wv.rtind(a6,a2.l),M159_bv_index(a6) */
    move.w M159_wv.rtind(a6,a2.l),M159_bv_index(a6)
/* QL: M159_goto */
M159_goto:
/* QL:         swap    d4              line number to lsw, save statement in msb */
    swap d4
/* QL:         tst.w   d4 */
    tst.w d4
/* QL:         seq     M159_bv_sing(a6)     command line? */
    seq M159_bv_sing(a6)
/* QL:         jsr     ib_golin(pc)    go to it */
    jsr ib_golin(pc)
/* QL:         bne.s   M159_err_nf */
    bne.s M159_err_nf
/* QL:         jsr     ib_stnxi(pc)    start it off */
    jsr ib_stnxi(pc)
/* QL:         rol.l   #8,d4           fetch out statement from msb */
    rol.l #8,d4
/* QL:         jmp     ib_gost(pc)     go to it */
    jmp ib_gost(pc)
/* QL: M159_err_nf */
M159_err_nf:
/* QL:         moveq   #M159_err.nf,d0 */
    moveq #M159_err.nf,d0
/* QL:         rts */
    rts 
/* QL:         end */
