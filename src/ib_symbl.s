/* ROM section ib_symbl */
.balign 2,0
/* QL: ib_on */
ib_on:
/* QL:         jsr     ib_nxnon(pc)    get a non-space */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   #M155_w.nam,d1       is it a name? */
    cmp.w #M155_w.nam,d1
/* QL:         bne.s   M155_ongo            no, it's not an "ON var =" then */
    bne.s M155_ongo
/* QL:         move.l  a4,d3           remember where we are */
    move.l a4,d3
/* QL:         jsr     ib_s4non(pc)    step past name and get next non-space */
    jsr ib_s4non(pc)
/* QL:         cmp.w   #M155_w.equal,d1     is this really an "ON var =" line? */
    cmp.w #M155_w.equal,d1
/* QL:         beq.s   M155_fends           yes, last on exhausted, find the end_sel */
    beq.s M155_fends
/* QL:         move.l  d3,a4           go back to name, it's part of an "ON <expr> go" */
    move.l d3,a4
/* QL: M155_ongo */
M155_ongo:
/* QL:         jmp     ib_ongo(pc)     go there */
    jmp ib_ongo(pc)
/* QL: * a4 -i o- program file pointer */
/* QL: * d0 -  o- return code */
/* QL: * d1 -i  - 1st word of token */
/* QL: ib_symbl */
ib_symbl:
/* QL:         cmp.w   #M155_w.equal,d1     if statement doesn't start with "=", ignore it */
    cmp.w #M155_w.equal,d1
/* QL:         bne.s   M155_okrts */
    bne.s M155_okrts
/* QL:         addq.l  #2,a4           M155_skip the "=" */
    addq.l #2,a4
/* QL: M155_fends */
M155_fends:
/* QL:         moveq   #-1,d3          nest count */
    moveq #(-1),d3
/* QL: M155_add1 */
M155_add1:
/* QL:         addq.w  #1,d3 */
    addq.w #1,d3
/* QL: M155_nxstat */
M155_nxstat:
/* QL:         bsr.s   ib_fchk         find next statement and check it */
    bsr.s ib_fchk
/* QL:         bne.s   M155_nxstat          not starting with a keyword */
    bne.s M155_nxstat
/* QL:         addq.l  #2,a4 */
    addq.l #2,a4
/* QL:         subq.b  #M155_b.sel,d1       SELect? */
    subq.b #M155_b.sel,d1
/* QL:         beq.s   M155_do_sel */
    beq.s M155_do_sel
/* QL:         addq.b  #M155_b.sel-M155_b.end,d1 END? */
.word 20481|((((M155_b.sel-M155_b.end))&7)<<9)
/* QL:         bne.s   M155_nxstat */
    bne.s M155_nxstat
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   #M155_w.sel,d1       END SEL? */
    cmp.w #M155_w.sel,d1
/* QL:         bne.s   M155_nxstat */
    bne.s M155_nxstat
/* QL:         dbra    d3,M155_nxstat       reduce level and carry on if still nested */
    dbra d3,M155_nxstat
/* QL: M155_okrts */
M155_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M155_do_sel */
M155_do_sel:
/* QL:         tst.b   M155_bv_inlin(a6)    are we already doing an in-line ? */
    tst.b M155_bv_inlin(a6)
/* QL:         bne.s   M155_add1            yes, inc nest count */
    bne.s M155_add1
/* QL:         jsr     ib_chinl(pc)    is it an in-line select */
    jsr ib_chinl(pc)
/* QL:         blt.s   M155_add1            no, inc nest count */
    blt.s M155_add1
/* QL: M155_skip */
M155_skip:
/* QL:         jsr     ib_eos(pc)      get end of statement */
    jsr ib_eos(pc)
/* QL:         blt.s   M155_nxstat          got there */
    blt.s M155_nxstat
/* QL:         addq.l  #2,a4           move over token */
    addq.l #2,a4
/* QL:         bra.s   M155_skip            and have another go */
    bra.s M155_skip
/* QL: * Skip return and set d0=0 if at end of possibles */
/* QL: * Otherwise set ccr z iff line starts with a keyword */
/* QL: ib_fchk */
ib_fchk:
/* QL:         jsr     ib_nxst(pc) */
    jsr ib_nxst(pc)
/* QL:         bne.s   M155_lf              end of file or end of single line */
    bne.s M155_lf
/* QL:         tst.b   d0              (from nxst) is this a new line? */
    tst.b d0
/* QL:         beq.s   M155_keytst          ..no */
    beq.s M155_keytst
/* QL:         tst.b   M155_bv_inlin(a6)    is the sel an in-line clause? */
    tst.b M155_bv_inlin(a6)
/* QL:         beq.s   M155_keytst          ..no */
    beq.s M155_keytst
/* QL: * New line and in-line clause, so finish what we've got and put PF in */
/* QL: * the right place to continue execution */
/* QL:         subq.l  #8,a4           back over line number,length & line feed */
    subq.l #8,a4
/* QL:         move.w  2(a6,a4.l),d0   take off length or it gets added twice */
    move.w 2(a6,a4.l),d0
/* QL:         sub.w   d0,M155_bv_lengt(a6) and the whole thing blows up */
    sub.w d0,M155_bv_lengt(a6)
/* QL: M155_lf */
M155_lf:
/* QL:         tst.b   M155_bv_inlin(a6) */
    tst.b M155_bv_inlin(a6)
/* QL:         bgt.s   M155_end_1           don't turn off flag if for/rep */
    bgt.s M155_end_1
/* QL:         sf      M155_bv_inlin(a6)    turn off the flag if sel/if */
    sf M155_bv_inlin(a6)
/* QL: M155_end_1 */
M155_end_1:
/* QL:         addq.l  #4,sp           discard return */
    addq.l #4,sp
/* QL:         bra.s   M155_okrts */
    bra.s M155_okrts
/* QL: M155_keytst */
M155_keytst:
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL:         cmp.b   #M155_b.key,d0       is it a keyword? */
    cmp.b #(M155_b.key&255),d0
/* QL:         rts */
    rts 
/* QL:         end */
