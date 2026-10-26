/* ROM section ib_sel */
.balign 2,0
/* QL: * d0 -  o- error code */
/* QL: * a4 -i o- program file pointer */
/* QL: * d0-d6/a0-a2 destroyed */
/* QL: * Locally: */
/* QL: * d3 - nest level */
/* QL: * d4 - name row */
/* QL: * d5 - variable type */
/* QL: * d6 - string length, fp exponent or integer value */
/* QL: * a1 - ri stack */
/* QL: * a2 - vv offset to string, fp mantissa or unused */
/* QL: ib_sel */
ib_sel:
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   #M156_w.on,d1 */
    cmp.w #M156_w.on,d1
/* QL:         bne.s   M156_nametok */
    bne.s M156_nametok
/* QL:         jsr     ib_s2non(pc)    don't need it */
    jsr ib_s2non(pc)
/* QL: M156_nametok */
M156_nametok:
/* QL:         move.l  0(a6,a4.l),d4   read name row, and keep msw as M156_w.nam */
    move.l 0(a6,a4.l),d4
/* QL:         jsr     ib_index(pc)    find its value (d0=offset, d1=use, d2=type) */
    jsr ib_index(pc)
/* QL:         bge.s   M156_valok           ok if the offset is >= 0 */
    bge.s M156_valok
/* QL: M156_err_xp */
M156_err_xp:
/* QL:         moveq   #M156_err.xp,d0 */
    moveq #M156_err.xp,d0
/* QL:         rts */
    rts 
/* QL: M156_valok */
M156_valok:
/* QL:         move.b  d2,d5           set variable type */
    move.b d2,d5
/* QL:         subq.b  #M156_t.arr,d1       we need to catch (sub)string arrays */
    subq.b #M156_t.arr,d1
/* QL:         bne.s   M156_simple          (too bad if it's some silly type) */
    bne.s M156_simple
/* QL:         move.w  6(a6,a2.l),d6   possible sub-string length */
    move.w 6(a6,a2.l),d6
/* QL:         assert  0,M156_t.str-1,M156_t.fp-2,M156_t.int-3 */
/* original assertion: 0,M156_t.str-1,M156_t.fp-2,M156_t.int-3 */
/* QL:         moveq   #M156_t.str,d3 */
    moveq #M156_t.str,d3
/* QL:         cmp.w   4(a6,a2.l),d3 */
    cmp.w 4(a6,a2.l),d3
/* QL:         bne.s   M156_err_xp          one dimension only */
    bne.s M156_err_xp
/* QL:         move.l  0(a6,a2.l),a2   get VV offset to data */
    move.l 0(a6,a2.l),a2
/* QL:         cmp.b   d3,d2 */
    cmp.b d3,d2
/* QL:         bhi.s   M156_err_xp          don't allow fp/int arrays (d2 now -1) */
    bhi.s M156_err_xp
/* QL:         bne.s   M156_all_set         substring is ready now */
    bne.s M156_all_set
/* QL:         move.l  a2,d0           save the offset            */
    move.l a2,d0
/* QL:         add.l   M156_bv_vvbas(a6),a2 need to pick up length of string */
    add.l M156_bv_vvbas(a6),a2
/* QL: M156_simple */
M156_simple:
/* QL:         movem.l -2(a6,a2.l),d6/a2 pick up length, exponent+mantissa or integer */
    movem.l (-2)(a6,a2.l),d6/a2
/* QL:         subq.b  #M156_t.fp,d2 */
    subq.b #M156_t.fp,d2
/* QL:         bcc.s   M156_all_set         ready except for string */
    bcc.s M156_all_set
/* QL:         move.l  d0,a2           put back just the offset */
    move.l d0,a2
/* QL:         addq.l  #2,a2           step past the length */
    addq.l #2,a2
/* QL: M156_all_set */
M156_all_set:
/* QL:         clr.w   d3              set nest level zero */
    clr.w d3
/* QL:         tst.b   M156_bv_inlin(a6)    are we already embedded? */
    tst.b M156_bv_inlin(a6)
/* QL:         bne.s   M156_entry           yes, leave it as is */
    bne.s M156_entry
/* QL:         jsr     ib_chinl(pc)    is this now an in-line clause? */
    jsr ib_chinl(pc)
/* QL:         blt.s   M156_entry           no, get on with it */
    blt.s M156_entry
/* QL:         st      M156_bv_inlin(a6)    only set to -1 if not already set */
    st M156_bv_inlin(a6)
/* QL:         bra.s   M156_entry */
    bra.s M156_entry
/* QL: * find an ON (or =) for a SELect, or drop out at END SELect, etc. */
/* QL: M156_skipto */
M156_skipto:
/* QL:         jsr     ib_nxcom(pc)    skip over "TO expr", looking for a comma */
    jsr ib_nxcom(pc)
/* QL: M156_nextrnge */
M156_nextrnge:
/* QL:         cmp.w   #M156_w.symcom,0(a6,a4.l) is token a comma? */
    cmp.w #M156_w.symcom,0(a6,a4.l)
/* QL:         beq.s   M156_onrng           yes, then the list carries on */
    beq.s M156_onrng
/* QL:         moveq   #-1,d3          reset count of nested sels */
    moveq #(-1),d3
/* QL: M156_add1 */
M156_add1:
/* QL:         addq.w  #1,d3 */
    addq.w #1,d3
/* QL: M156_nxstat */
M156_nxstat:
/* QL:         jsr     ib_fchk(pc)     find next statement and check it */
    jsr ib_fchk(pc)
/* QL:         bne.s   M156_chklev          not starting with a keyword */
    bne.s M156_chklev
/* QL:         subq.b  #M156_b.end,d1       is it END? */
    subq.b #M156_b.end,d1
/* QL:         beq.s   M156_do_end */
    beq.s M156_do_end
/* QL:         subq.b  #M156_w.sel-M156_w.end,d1 is it SELect? */
.word 20737|((((M156_w.sel-M156_w.end))&7)<<9)
/* QL:         beq.s   M156_do_sel */
    beq.s M156_do_sel
/* QL:         assert  1<<4,M156_w.on-M156_w.sel */
/* original assertion: 1<<4,M156_w.on-M156_w.sel */
/* QL:         roxl.b  #4,d1           is it ON? */
    roxl.b #4,d1
/* QL:         bne.s   M156_nxstat */
    bne.s M156_nxstat
/* QL:         jsr     ib_s2non(pc)    skip the ON and get the next thing */
    jsr ib_s2non(pc)
/* QL:         cmp.l   0(a6,a4.l),d4   is it a name, and the same name? */
    cmp.l 0(a6,a4.l),d4
/* QL:         bne.s   M156_nxstat */
    bne.s M156_nxstat
/* QL: M156_entry */
M156_entry:
/* QL:         addq.l  #4,a4           move over name, now we may find '=' */
    addq.l #4,a4
/* QL:         ;                       (this could still be ON <expr> GO) */
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL: M156_chklev */
M156_chklev:
/* QL:         tst.w   d3              is count equal to zero */
    tst.w d3
/* QL:         bne.s   M156_nxstat          carry on if nested */
    bne.s M156_nxstat
/* QL: M156_chkeq */
M156_chkeq:
/* QL:         cmp.w   #M156_w.equal,d1     is first, or after "{SEL} ON <name>", an = ? */
    cmp.w #M156_w.equal,d1
/* QL:         bne.s   M156_nxstat          no */
    bne.s M156_nxstat
/* QL: * check on range against value */
/* QL: M156_onrng */
M156_onrng:
/* QL:         jsr     ib_s2non(pc)    skip token and look for range */
    jsr ib_s2non(pc)
/* QL:         cmp.w   #M156_w.rmndr,d1     REMAINDER ? */
    cmp.w #M156_w.rmndr,d1
/* QL:         beq.s   M156_okrts */
    beq.s M156_okrts
/* QL:         bsr.s   M156_eval            read lower or only limit */
    bsr.s M156_eval
/* QL:         cmp.w   #M156_w.keyto,0(a6,a4.l) */
    cmp.w #M156_w.keyto,0(a6,a4.l)
/* QL:         beq.s   M156_do_to */
    beq.s M156_do_to
/* QL:         sf      d1 */
    sf d1
/* QL:         moveq   #3,d0           (string comparison type is ==) */
    moveq #3,d0
/* QL:         bsr.s   M156_docmp           check for a1==a2 */
    bsr.s M156_docmp
/* QL: M156_qgood */
M156_qgood:
/* QL:         bne.s   M156_nextrnge */
    bne.s M156_nextrnge
/* QL: M156_okrts */
M156_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M156_do_sel */
M156_do_sel:
/* QL:         tst.b   M156_bv_inlin(a6)    are we in-line already? */
    tst.b M156_bv_inlin(a6)
/* QL:         bne.s   M156_add1            yes, inc nest count, else skip over whole line */
    bne.s M156_add1
/* QL:         jsr     ib_chinl(pc)    select in-line? */
    jsr ib_chinl(pc)
/* QL:         bne.s   M156_add1            no, inc nest count */
    bne.s M156_add1
/* QL: M156_loop */
M156_loop:
/* QL:         addq.l  #2,a4           move over the token */
    addq.l #2,a4
/* QL:         jsr     ib_eos(pc)      get end of statement */
    jsr ib_eos(pc)
/* QL:         bge.s   M156_loop            if not end of line, try again */
    bge.s M156_loop
/* QL:         bra.s   M156_nxstat */
    bra.s M156_nxstat
/* QL: M156_do_end */
M156_do_end:
/* QL:         jsr     ib_s2non(pc)    step past end */
    jsr ib_s2non(pc)
/* QL:         cmp.w   #M156_w.sel,d1       END SELect? */
    cmp.w #M156_w.sel,d1
/* QL:         bne.s   M156_nxstat */
    bne.s M156_nxstat
/* QL:         dbra    d3,M156_nxstat       yes, drop a level and continue if still nested */
    dbra d3,M156_nxstat
/* QL:         bra.s   M156_okrts           found an END SELect or nothing */
    bra.s M156_okrts
/* QL: M156_do_to */
M156_do_to:
/* QL:         moveq   #1,d1 */
    moveq #1,d1
/* QL:         bsr.s   M156_docmp2          check for a2>=a1 */
    bsr.s M156_docmp2
/* QL:         bne.l   M156_skipto          failed first part of range */
    bne.w M156_skipto
/* QL:         addq.l  #2,a4           skip to */
    addq.l #2,a4
/* QL:         bsr.s   M156_eval            get upper limit */
    bsr.s M156_eval
/* QL:         st      d1 */
    st d1
/* QL:         bsr.s   M156_docmp2          check for a2<=a1 */
    bsr.s M156_docmp2
/* QL:         bra.s   M156_qgood */
    bra.s M156_qgood
/* QL: M156_eval */
M156_eval:
/* QL:         move.l  a4,a0 */
    move.l a4,a0
/* QL:         move.l  a2,-(sp) */
    move.l a2,-(sp)
/* QL:         move.b  d5,d0 */
    move.b d5,d0
/* QL:         jsr     ca_eval(pc)     read limit */
    jsr ca_eval(pc)
/* QL:         move.l  (sp)+,a2 */
    move.l (sp)+,a2
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         bgt.s   M156_rts1 */
    bgt.s M156_rts1
/* QL:         addq.l  #4,sp           give up if there's any problem in M156_eval */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: M156_docmp2 */
M156_docmp2:
/* QL:         moveq   #2,d0           (string comparison type is <= or >=) */
    moveq #2,d0
/* QL: M156_docmp */
M156_docmp:
/* QL:         cmp.b   #M156_t.fp,d5        which type are we doing? */
    cmp.b #(M156_t.fp&255),d5
/* QL:         beq.s   M156_comfp */
    beq.s M156_comfp
/* QL:         blt.s   M156_comstr */
    blt.s M156_comstr
/* QL: * right... integer select, do it! */
/* QL:         addq.l  #2,M156_bv_rip(a6)   discard integer */
    addq.l #2,M156_bv_rip(a6)
/* QL:         cmp.w   0(a6,a1.l),d6   check against on variable value */
    cmp.w 0(a6,a1.l),d6
/* QL:         beq.s   M156_rts1            equal is always good */
    beq.s M156_rts1
/* QL:         slt     d3              set flag */
    slt d3
/* QL:         subq.b  #1,d1           were we looking for equality? */
    subq.b #1,d1
/* QL:         bcs.s   M156_rts1            yes - then this is no good */
    bcs.s M156_rts1
/* QL: M156_eorb */
M156_eorb:
/* QL:         eor.b   d3,d1           this establishes the sign bit as what we want */
    eor.b d3,d1
/* QL:         asr.b   #7,d1           so this is the answer! */
    asr.b #7,d1
/* QL: M156_rts1 */
M156_rts1:
/* QL:         rts */
    rts 
/* QL: M156_comfp */
M156_comfp:
/* QL:         move.b  d1,d3           save comparison type */
    move.b d1,d3
/* QL:         moveq   #6,d1 */
    moveq #6,d1
/* QL:         jsr     bv_chrix(pc)    gotta make sure of space */
    jsr bv_chrix(pc)
/* QL:         move.l  M156_bv_rip(a6),a1   reload pointer */
    move.l M156_bv_rip(a6),a1
/* QL:         addq.l  #6,M156_bv_rip(a6)   discard comparand from M156_bv_rip */
    addq.l #6,M156_bv_rip(a6)
/* QL:         subq.l  #6,a1           make space for our comparison */
    subq.l #6,a1
/* QL:         move.l  a2,2(a6,a1.l)   copy mantissa */
    move.l a2,2(a6,a1.l)
/* QL:         move.w  d6,0(a6,a1.l)   copy exponent */
    move.w d6,0(a6,a1.l)
/* QL:         jsr     ri_cmp(pc)      calculate comparison (this is nice, saves d3) */
    jsr ri_cmp(pc)
/* QL:         neg.b   d3              check comparison type */
    neg.b d3
/* QL:         bne.s   M156_frel            not zero means we want to test <= and >= */
    bne.s M156_frel
/* QL:         tst.b   0(a6,a1.l)      msb exponent is 0 if == true, otherwise 8 */
    tst.b 0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: M156_frel */
M156_frel:
/* QL:         move.b  2(a6,a1.l),d1   get msb mantissa which will be $80, 0 or $40 */
    move.b 2(a6,a1.l),d1
/* QL:         bne.s   M156_eorb            if not zero, we go to eor signs for answer */
    bne.s M156_eorb
/* QL:         rts                     if zero, this is an exact =, which is fine */
    rts 
/* QL: M156_comstr */
M156_comstr:
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.w  0(a6,a1.l),d2 */
    move.w 0(a6,a1.l),d2
/* QL:         addq.l  #3,d2 */
    addq.l #3,d2
/* QL:         bclr    #0,d2 */
    bclr #0,d2
/* QL:         add.l   d2,M156_bv_rip(a6)   discard string on RI stack */
    add.l d2,M156_bv_rip(a6)
/* QL:         move.l  a2,a0 */
    move.l a2,a0
/* QL:         add.l   M156_bv_vvbas(a6),a0 */
    add.l M156_bv_vvbas(a6),a0
/* QL:         move.w  d6,d2 */
    move.w d6,d2
/* QL:         jsr     ut_csstr(pc) */
    jsr ut_csstr(pc)
/* QL:         beq.s   M156_rts1            equal is always great */
    beq.s M156_rts1
/* QL:         cmp.b   d0,d1           otherwise compare it to comparison type */
    cmp.b d0,d1
/* QL:         rts */
    rts 
/* QL:         end  */
