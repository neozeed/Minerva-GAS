/* ROM section pa_chnam */
.balign 2,0
/* QL: * Note. The scan of the name table has been changed about, hopefully saving a */
/* QL: * considerable amount of time during load's. */
/* QL: * The basic technique being to try to match the length byte and the first */
/* QL: * character before even checking that there is a real, named, entry. */
/* QL: * d5 -i o- length of name in buffer (msb's clear) / no of name in table */
/* QL: * a2 -i o- pointer to keyword table / pointer to name table */
/* QL: * a3 -i  - pointer to start of buffered name to check for (rel a6) */
/* QL: * a6 -ip - area on which bv pointers are indexed */
/* QL: * d0-d3/d6/a0-a1 destroyed */
/* QL: regon   reg     d4/d7/a2-a3/a5 */
/* QL: regoff  reg     d4/d7/a0/a3/a5 */
/* QL: pa_chnam */
pa_chnam:
/* QL:         movem.l regon,-(sp)     save a few regs for later (a2->a0 below) */
    movem.l d4/d7/a2-a3/a5,-(sp)
/* QL:         lea     M136_scanner,a2 */
    lea M136_scanner(pc),a2
/* QL:         moveq   #M136_mt.extop,d0    increment non-sheduling mode */
    moveq #M136_mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         movem.l (sp)+,regoff    put kytab in a0 for now */
    movem.l (sp)+,d4/d7/a0/a3/a5
/* QL:         tst.b   d6 */
    tst.b d6
/* QL:         beq.s   M136_found           goody! we have M136_found the match */
    beq.s M136_found
/* QL:         move.l  a0,a2           set beginning of keyword table */
    move.l a0,a2
/* QL:         moveq   #0,d6           must start at zero, as remark follows remainder */
    moveq #0,d6
/* QL: M136_kyloop */
M136_kyloop:
/* QL:         addq.b  #1,d6 */
    addq.b #1,d6
/* QL:         cmp.b   (a2),d6         check against all keywords and pairs thereof */
    cmp.b (a2),d6
/* QL:         bgt.s   M136_newnam */
    bgt.s M136_newnam
/* QL:         move.l  a3,a0           set buffer start */
    move.l a3,a0
/* QL:         jsr     pa_kywrd(pc) */
    jsr pa_kywrd(pc)
/* QL:         bra.s   M136_kyloop          no match */
    bra.s M136_kyloop
/* QL:         rts                     illegal name, better tell user */
    rts 
/* QL: * Name not in table or keywords. Add it to table in first free slot */
/* QL: M136_newnam */
M136_newnam:
/* QL:         moveq   #4+8+12,d0      total stack depth at this point */
    moveq #((4+8)+12),d0
/* QL:         bsr.s   pa_chunr        check in case we're in an unravel */
    bsr.s pa_chunr
/* QL:         move.l  d5,d1 */
    move.l d5,d1
/* QL:         addq.l  #1,d1           space required is nchars plus one */
    addq.l #1,d1
/* QL:         jsr     bv_chnlx(pc)    check space in namelist */
    jsr bv_chnlx(pc)
/* QL:         exg     a2,a5 */
    exg a5,a2
/* QL:         jsr     ca_oldnt(pc)    get a spare/new name table entry built for us */
    jsr ca_oldnt(pc)
/* QL:         exg     a2,a5 */
    exg a5,a2
/* QL:         subq.l  #8,a2 */
    subq.l #8,a2
/* QL:         assert  M136_bv_nlbas,M136_bv_nlp-4 */
/* original assertion: M136_bv_nlbas,M136_bv_nlp-4 */
/* QL:         movem.l M136_bv_nlbas(a6),d2/a0 */
    movem.l M136_bv_nlbas(a6),d2/a0
/* QL:         neg.w   d2 */
    neg.w d2
/* QL:         add.w   a0,d2 */
    add.w a0,d2
/* QL:         move.b  d5,0(a6,a0.l)   put name length into namelist entry */
    move.b d5,0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL: M136_addchar */
M136_addchar:
/* QL:         move.b  0(a6,a3.l),0(a6,a0.l) put buffer char into namelist */
    move.b 0(a6,a3.l),0(a6,a0.l)
/* QL:         addq.l  #1,a3 */
    addq.l #1,a3
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         subq.b  #1,d5           one char gone */
    subq.b #1,d5
/* QL:         bne.s   M136_addchar */
    bne.s M136_addchar
/* QL:         move.w  d2,2(a6,a2.l)   put namelist offset into nametable entry */
    move.w d2,2(a6,a2.l)
/* QL:         move.l  a0,M136_bv_nlp(a6)   update running namelist pointer */
    move.l a0,M136_bv_nlp(a6)
/* QL:         jsr     bv_vtype(pc)    set up usage and variable type */
    jsr bv_vtype(pc)
/* QL: * Send back entry number in name table */
/* QL: M136_found */
M136_found:
/* QL:         move.l  a2,d5           get position in name table */
    move.l a2,d5
/* QL:         sub.l   M136_bv_ntbas(a6),d5 */
    sub.l M136_bv_ntbas(a6),d5
/* QL:         lsr.l   #3,d5           ..gives 0,1,2,3...etc */
    lsr.l #3,d5
/* QL:         addq.l  #2,(sp)         good exit */
    addq.l #2,(sp)
/* QL:         rts */
    rts 
/* QL: * Return to unvr if we are stuck in an unravel. */
/* QL: * d0 -i o- depth of stack to get back to unvr if we're stuck */
/* QL: pa_chunr */
pa_chunr:
/* QL:         tst.b   M136_bv_unrvl(a6)    is nt is stuck in an unravel? */
    tst.b M136_bv_unrvl(a6)
/* QL:         beq.s   M136_rts0            no - that's ok */
    beq.s M136_rts0
/* QL:         add.l   d0,sp           lose stacked data and returns */
    add.l d0,sp
/* QL:         moveq   #1,d0           set codition codes postive for unvr */
    moveq #1,d0
/* QL: M136_rts0 */
M136_rts0:
/* QL:         rts */
    rts 
/* QL: M136_scanner */
M136_scanner:
/* QL:         assert  M136_bv_ntbas,M136_bv_ntp-4,M136_bv_nlbas-8 */
/* original assertion: M136_bv_ntbas,M136_bv_ntp-4,M136_bv_nlbas-8 */
/* QL:         movem.l M136_bv_ntbas(a6),d0/d6/a5 */
    movem.l M136_bv_ntbas(a6),d0/d6/a5
/* QL:         sub.l   d0,d6           nl size */
    sub.l d0,d6
/* QL:         lsr.l   #3,d6           nl count */
    lsr.l #3,d6
/* QL:         lea     2-8(a6,d0.l),a2 absolute nt base for first nl offset */
    lea (2-8)(a6,d0.l),a2
/* QL:         add.l   a6,a5           absolute nl base */
    add.l a6,a5
/* QL:         add.l   a6,a3           make buffer absolute */
    add.l a6,a3
/* QL:         move.b  (a3)+,d7        get first byte out just the once */
    move.b (a3)+,d7
/* QL:         moveq   #1,d1           just to improve spare entry test */
    moveq #1,d1
/* QL:         moveq   #-1-32,d3       mask to clear lower-case bit, ccr non-z */
    moveq #((-1)-32),d3
/* QL:         bra.s   M136_nment */
    bra.s M136_nment
/* QL: M136_nmloop */
M136_nmloop:
/* QL:         addq.l  #8,a2 */
    addq.l #8,a2
/* QL:         move.w  (a2),a0 */
    move.w (a2),a0
/* QL:         add.l   a5,a0 */
    add.l a5,a0
/* QL:         cmp.b   (a0)+,d5        match name length first, even if it's silly */
    cmp.b (a0)+,d5
/* QL:         dbeq    d6,M136_nmloop       gets through bulk of nt as quick as we can */
    dbeq d6,M136_nmloop
/* QL:         bne.s   M136_nmexit */
    bne.s M136_nmexit
/* QL:         move.b  (a0)+,d0 */
    move.b (a0)+,d0
/* QL:         eor.b   d7,d0 */
    eor.b d7,d0
/* QL:         and.b   d3,d0           does first char match? */
    and.b d3,d0
/* QL:         dbeq    d6,M136_nmloop       no, we're still whizzing along fast */
    dbeq d6,M136_nmloop
/* QL:         bne.s   M136_nmexit */
    bne.s M136_nmexit
/* QL: * Now it's time to settle into the rest of the tests. */
/* QL: * We have got past to this point quickly, and we now know the length is the */
/* QL: * same and the first byte is also matched. */
/* QL: * We skipped testing for spare/unnamed entries until now to make the scan fast! */
/* QL: * Assuming we will actually normally find a match, and the incidence of unnamed */
/* QL: * entries is low until we get to the top of the table, we should be doing quite */
/* QL: * a bit better on speed at this point. */
/* QL: * The name offset in duff cases will always be zero (spare) or -1 (unnamed), */
/* QL: * so we shouldn't have any problems using it. */
/* QL: * On a typical load, with not many extensions, 30% of the time was spent here! */
/* QL: * A further gain might be made by "cacheing" the most recent four, or maybe a */
/* QL: * few more, matched nt entry numbers, but this could get a bit complex, for */
/* QL: * what should now be a small gain in overall speed. */
/* QL:         tst.b   (a2)            did this entry have a real nl offset? */
    tst.b (a2)
/* QL:         bmi.s   M136_nment           negative offset, we wasted a tiny bit of time */
    bmi.s M136_nment
/* QL:         cmp.l   -2(a2),d1       is it an annoying "spare" entry? */
    cmp.l (-2)(a2),d1
/* QL:         bhi.s   M136_nment           unset sub-string, no less! (nb ccr not z!) */
    bhi.s M136_nment
/* QL:         move.l  a3,a1           copy buffer pointer */
    move.l a3,a1
/* QL:         move.w  d5,d4           set length */
    move.w d5,d4
/* QL:         subq.w  #1,d4           we've done one character */
    subq.w #1,d4
/* QL:         beq.s   M136_nmfnd           wow! it was just one char, so we're done */
    beq.s M136_nmfnd
/* QL:         subq.w  #1,d4           less one to compensate for dbne */
    subq.w #1,d4
/* QL: M136_nmchr */
M136_nmchr:
/* QL:         move.b  (a1)+,d2        get buffer char */
    move.b (a1)+,d2
/* QL:         move.b  (a0)+,d0        get table char */
    move.b (a0)+,d0
/* QL:         eor.b   d2,d0           look at differences */
    eor.b d2,d0
/* QL:         and.b   d3,d0           clear lc bit */
    and.b d3,d0
/* QL:         dbne    d4,M136_nmchr        loop round and try again if matched and more */
    dbne d4,M136_nmchr
/* QL: M136_nment */
M136_nment:
/* QL:         dbeq    d6,M136_nmloop       drop out if full match or none left */
    dbeq d6,M136_nmloop
/* QL: M136_nmfnd */
M136_nmfnd:
/* QL:         subq.l  #2,a2           back to base of matched entry */
    subq.l #2,a2
/* QL:         sub.l   a6,a2           make nt pointer relative */
    sub.l a6,a2
/* QL: M136_nmexit */
M136_nmexit:
/* QL:         sne     d6 */
    sne d6
/* QL:         rte */
    rte 
/* QL:         end */
