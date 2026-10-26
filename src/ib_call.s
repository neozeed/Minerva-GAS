/* ROM section ib_call */
.balign 2,0
/* QL: * In the case of a FN, 8(sp) holds the position in the expression wrt tkbas */
/* QL: * N.B. (lwr) This has been altered to continuously keep the NT pointers in the */
/* QL: * RT stack as offsets relative to nt_bas. The code could probably be improved! */
/* QL: ib_bproc */
ib_bproc:
/* QL:         moveq   #M148_x.bpr,d5 */
    moveq #M148_x.bpr,d5
/* QL: * d4 -i  - line number of GOSUB or name row PROC/FN */
/* QL: * d5 -i  - call type as above */
/* QL: * a2 -i  - nt entry for PROC, FN */
/* QL: * d0-d6/a0-a5 destroyed */
/* QL: ib_call */
ib_call:
/* QL:         jsr     bv_chrt(pc)     check enough room on the return table */
    jsr bv_chrt(pc)
/* QL:         moveq   #M148_rt.lentl,d1    set space for PROC/FN */
    moveq #M148_rt.lentl,d1
/* QL:         tst.b   d5 */
    tst.b d5
/* QL:         bne.s   M148_lenset */
    bne.s M148_lenset
/* QL:         moveq   #M148_rt.lentl-M148_rt.lenpr,d1 GOSUB requires less */
    moveq #(M148_rt.lentl-M148_rt.lenpr),d1
/* QL: M148_lenset */
M148_lenset:
/* QL:         add.l   d1,M148_bv_rtp(a6)   move up return table */
    add.l d1,M148_bv_rtp(a6)
/* QL:         move.l  M148_bv_rtp(a6),a1   top of return table */
    move.l M148_bv_rtp(a6),a1
/* QL:         move.b  M148_bv_stmnt(a6),-M148_rt.rsstm(a6,a1.l) statement to go back to */
    move.b M148_bv_stmnt(a6),(-M148_rt.rsstm)(a6,a1.l)
/* QL:         move.w  M148_bv_linum(a6),-M148_rt.rslno(a6,a1.l) linenumber to go back to */
    move.w M148_bv_linum(a6),(-M148_rt.rslno)(a6,a1.l)
/* QL:         assert  M148_bv_inlin,M148_bv_sing-1,M148_bv_index-2 */
/* original assertion: M148_bv_inlin,M148_bv_sing-1,M148_bv_index-2 */
/* QL:         move.l  M148_bv_inlin(a6),-M148_rt.rssta(a6,a1.l) inline, single flags,index var */
    move.l M148_bv_inlin(a6),(-M148_rt.rssta)(a6,a1.l)
/* QL:         move.b  d5,-M148_rt.rsrtt(a6,a1.l) type of routine */
    move.b d5,(-M148_rt.rsrtt)(a6,a1.l)
/* QL:         beq.s   M148_rts0            finished for GOSUB, go back to that code */
    beq.s M148_rts0
/* QL:         sf      M148_bv_inlin(a6)    not inline now (hmm... fudge kills fudge. lwr) */
    sf M148_bv_inlin(a6)
/* QL:         move.l  d4,d3           save name row */
    move.l d4,d3
/* QL:         bsr.s   M148_set_bltl        set base and top of locals */
    bsr.s M148_set_bltl
/* QL:         move.l  a5,-M148_rt.rsba(a6,a1.l) set base of args */
    move.l a5,(-M148_rt.rsba)(a6,a1.l)
/* QL:         move.b  1(a6,a2.l),-M148_rt.rsfnt(a6,a1.l) function type */
    move.b 1(a6,a2.l),(-M148_rt.rsfnt)(a6,a1.l)
/* QL:         sf      -M148_rt.rsswp(a6,a1.l) set not swapped */
    sf (-M148_rt.rsswp)(a6,a1.l)
/* QL:         move.w  4(a6,a2.l),-M148_rt.rsdfl(a6,a1.l) line number of def line */
    move.w 4(a6,a2.l),(-M148_rt.rsdfl)(a6,a1.l)
/* QL:         ble.l   M148_err_nf1         was a single liner (???) */
    ble.w M148_err_nf1
/* QL:         cmp.b   #M148_x.bf0,d5       this might be a FN with no args */
    cmp.b #(M148_x.bf0&255),d5
/* QL:         beq.s   M148_no_arg */
    beq.s M148_no_arg
/* QL:         move.l  a4,a0 */
    move.l a4,a0
/* QL:         jsr     ca_garg(pc)     get all the actual arguments */
    jsr ca_garg(pc)
/* QL:         move.l  M148_bv_rtp(a6),a1 */
    move.l M148_bv_rtp(a6),a1
/* QL:         bsr.s   M148_set_bltl        base and top of locals */
    bsr.s M148_set_bltl
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         bne.s   M148_clr_err */
    bne.s M148_clr_err
/* QL:         cmp.b   #M148_x.bfn,d5 */
    cmp.b #(M148_x.bfn&255),d5
/* QL:         beq.s   M148_ch_cbr */
    beq.s M148_ch_cbr
/* QL:         bsr.l   ib_cheos        PROCedure - check end of statement next */
    bsr.w ib_cheos
/* QL:         beq.s   M148_set_ok */
    beq.s M148_set_ok
/* QL: M148_clr_bp */
M148_clr_bp:
/* QL:         moveq   #M148_err.bp,d0 */
    moveq #M148_err.bp,d0
/* QL: M148_clr_err */
M148_clr_err:
/* QL:         moveq   #M148_rt.lentl,d1 */
    moveq #M148_rt.lentl,d1
/* QL:         sub.l   d1,M148_bv_rtp(a6)   take this call off the return stack */
    sub.l d1,M148_bv_rtp(a6)
/* QL:         bra.l   M148_clr_arg         clear any args found so far */
    bra.w M148_clr_arg
/* QL: M148_set_bltl */
M148_set_bltl:
/* QL:         move.l  M148_bv_ntp(a6),a5 */
    move.l M148_bv_ntp(a6),a5
/* QL:         sub.l   M148_bv_ntbas(a6),a5 */
    sub.l M148_bv_ntbas(a6),a5
/* QL:         move.l  a5,-M148_rt.rstl(a6,a1.l) set top of locals */
    move.l a5,(-M148_rt.rstl)(a6,a1.l)
/* QL:         move.l  a5,-M148_rt.rsbl(a6,a1.l) set base of locals */
    move.l a5,(-M148_rt.rsbl)(a6,a1.l)
/* QL: M148_rts0 */
M148_rts0:
/* QL:         rts */
    rts 
/* QL: M148_ch_cbr */
M148_ch_cbr:
/* QL:         cmp.w   #M148_w.cpar,d1      function - should be a close parenthesis here */
    cmp.w #M148_w.cpar,d1
/* QL:         bne.s   M148_clr_bp */
    bne.s M148_clr_bp
/* QL:         addq.l  #2,a0           skip it */
    addq.l #2,a0
/* QL:         move.l  a0,d1 */
    move.l a0,d1
/* QL:         sub.l   M148_bv_bfp+4(a6),d1 get wrt just above the buffer */
    sub.l (M148_bv_bfp+4)(a6),d1
/* QL:         move.l  d1,8(sp)        update pos for eval to continue from */
    move.l d1,8(sp)
/* QL: M148_set_ok */
M148_set_ok:
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL: M148_no_arg */
M148_no_arg:
/* QL:         st      -M148_rt.rsswp(a6,a1.l) set swapped flag */
    st (-M148_rt.rsswp)(a6,a1.l)
/* QL:         ; (if error following this then it's practically irrecoverable anyway) */
/* QL:         move.l  -M148_rt.rsba(a6,a1.l),a5 restore bottom of args */
    move.l (-M148_rt.rsba)(a6,a1.l),a5
/* QL:         tst.b   M148_bv_sing(a6)     if this is a single line command */
    tst.b M148_bv_sing(a6)
/* QL:         bsr.l   M148_qstbas          check if we have to start at the top again */
    bsr.w M148_qstbas
/* QL:         bne.l   M148_err_nf1         idiot's have lost the program */
    bne.w M148_err_nf1
/* QL:         bsr.l   M148_posdfl          go to the start of subroutine line */
    bsr.w M148_posdfl
/* QL:         bsr.l   M148_do_arg          do the formal arguments */
    bsr.w M148_do_arg
/* QL: M148_get_loc */
M148_get_loc:
/* QL:         bsr.s   M148_find_loc        find a local line */
    bsr.s M148_find_loc
/* QL:         beq.s   M148_nx_loc */
    beq.s M148_nx_loc
/* QL:         tst.l   d0              was there an error? */
    tst.l d0
/* QL:         bne.s   M148_rts0            yes, get out */
    bne.s M148_rts0
/* QL:         addq.l  #4,sp           delete this return */
    addq.l #4,sp
/* QL:         jmp     ib_stimm(pc)    because we're going to start immediately */
    jmp ib_stimm(pc)
/* QL: M148_nx_loc */
M148_nx_loc:
/* QL:         bsr.s   M148_s2non           get next token */
    bsr.s M148_s2non
/* QL:         cmp.b   #M148_b.nam,d0       is it a name? */
    cmp.b #(M148_b.nam&255),d0
/* QL:         bne.s   M148_ch_sym          no, better check for significant symbols */
    bne.s M148_ch_sym
/* QL:         bsr.l   M148_mk_dum          make a dummy entry and bump top of locals */
    bsr.w M148_mk_dum
/* QL:         cmp.w   #M148_w.opar,d1      is this a dimensioned local? */
    cmp.w #M148_w.opar,d1
/* QL:         bne.s   M148_ch_sym          no, good, get next one */
    bne.s M148_ch_sym
/* QL:         addq.b  #M148_t.arr-M148_t.var,0(a6,a2.l) turn it into an array */
    addq.b #(M148_t.arr-M148_t.var),0(a6,a2.l)
/* QL:         jsr     ib_mkdim(pc)    and make all the dimension space in the VV */
    jsr ib_mkdim(pc)
/* QL:         bne.s   M148_rts2 */
    bne.s M148_rts2
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL: M148_ch_sym */
M148_ch_sym:
/* QL:         cmp.w   #M148_w.symcom,d1    is it a comma? */
    cmp.w #M148_w.symcom,d1
/* QL:         beq.s   M148_nx_loc          yes, ok */
    beq.s M148_nx_loc
/* QL:         bsr.l   ib_cheos        is it end of line then? */
    bsr.w ib_cheos
/* QL:         beq.s   M148_get_loc         yes, get another local line */
    beq.s M148_get_loc
/* QL:         moveq   #M148_err.bl,d0      anything else is wrong */
    moveq #M148_err.bl,d0
/* QL: M148_rts2 */
M148_rts2:
/* QL:         rts */
    rts 
/* QL: M148_err_ef */
M148_err_ef:
/* QL:         moveq   #M148_err.ef,d0 */
    moveq #M148_err.ef,d0
/* QL:         rts */
    rts 
/* QL: M148_find_loc */
M148_find_loc:
/* QL:         jsr     ib_nxst(pc)     get start of next statement */
    jsr ib_nxst(pc)
/* QL:         bne.s   M148_err_ef          no file left */
    bne.s M148_err_ef
/* QL:         bsr.s   M148_nxnon */
    bsr.s M148_nxnon
/* QL:         sub.w   #M148_w.rem,d1       ignore remarks */
    sub.w #M148_w.rem,d1
/* QL:         beq.s   M148_find_loc */
    beq.s M148_find_loc
/* QL:         addq.w  #M148_w.rem-M148_w.data,d1 ignore data statements too */
.word 20545|((((M148_w.rem-M148_w.data))&7)<<9)
/* QL:         beq.s   M148_find_loc */
    beq.s M148_find_loc
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         subq.w  #M148_w.loc-M148_w.data,d1 is it a LOCal? */
.word 20801|((((M148_w.loc-M148_w.data))&7)<<9)
/* QL:         rts */
    rts 
/* QL: M148_s2non */
M148_s2non:
/* QL:         jmp     ib_s2non(pc) */
    jmp ib_s2non(pc)
/* QL: M148_swapit */
M148_swapit:
/* QL:         addq.l  #8,a5           move on up the name table */
    addq.l #8,a5
/* QL: M148_swapnew */
M148_swapnew:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         move.w  2(a6,a4.l),d0   which name am I swapping with? */
    move.w 2(a6,a4.l),d0
/* QL:         lsl.l   #3,d0 */
    lsl.l #3,d0
/* QL:         move.l  M148_bv_ntbas(a6),a2 base of name table */
    move.l M148_bv_ntbas(a6),a2
/* QL:         add.l   d0,a2 */
    add.l d0,a2
/* QL:         tst.b   M148_bv_uproc(a6) */
    tst.b M148_bv_uproc(a6)
/* QL:         bpl.s   M148_noup */
    bpl.s M148_noup
/* QL:         jsr     bv_upswp(pc) */
    jsr bv_upswp(pc)
/* QL: M148_noup */
M148_noup:
/* QL:         move.w  0(a6,a2.l),d0   swap first word (not the NL pointer) */
    move.w 0(a6,a2.l),d0
/* QL:         move.w  -8(a6,a5.l),0(a6,a2.l) */
    move.w (-8)(a6,a5.l),0(a6,a2.l)
/* QL:         move.w  d0,-8(a6,a5.l) */
    move.w d0,(-8)(a6,a5.l)
/* QL:         move.l  4(a6,a2.l),d0   and then second long word */
    move.l 4(a6,a2.l),d0
/* QL:         move.l  -4(a6,a5.l),4(a6,a2.l) */
    move.l (-4)(a6,a5.l),4(a6,a2.l)
/* QL:         move.l  d0,-4(a6,a5.l) */
    move.l d0,(-4)(a6,a5.l)
/* QL:         addq.l  #4,a4           and along the PF line */
    addq.l #4,a4
/* QL:         rts */
    rts 
/* QL: M148_mk_dum */
M148_mk_dum:
/* QL:         jsr     ca_newnt(pc)    get a new 0/0/noname/noval nt entry */
    jsr ca_newnt(pc)
/* QL:         move.l  M148_bv_rtp(a6),a1 */
    move.l M148_bv_rtp(a6),a1
/* QL:         addq.l  #8,-M148_rt.rstl(a6,a1.l) update top of locals, at least */
    addq.l #8,(-M148_rt.rstl)(a6,a1.l)
/* QL:         addq.b  #M148_t.var,-8(a6,a5.l) say it's a simple variable for now */
    addq.b #M148_t.var,(-8)(a6,a5.l)
/* QL:         bsr.s   M148_swapnew         now swap it */
    bsr.s M148_swapnew
/* QL:         jsr     bv_vtype(pc)    make it unset + original type for its name */
    jsr bv_vtype(pc)
/* QL:         addq.b  #M148_t.var,0(a6,a2.l) make extra formal or local into a simple var */
    addq.b #M148_t.var,0(a6,a2.l)
/* QL: M148_nxnon */
M148_nxnon:
/* QL:         jmp     ib_nxnon(pc) */
    jmp ib_nxnon(pc)
/* QL: ib_cheos */
ib_cheos:
/* QL:         cmp.w   #M148_w.eol,d1       end of line? */
    cmp.w #M148_w.eol,d1
/* QL:         beq.s   M148_rts1 */
    beq.s M148_rts1
/* QL:         cmp.w   #M148_w.colon,d1     colon? */
    cmp.w #M148_w.colon,d1
/* QL: M148_rts1 */
M148_rts1:
/* QL:         rts */
    rts 
/* QL: * Check the DEF PROC/FN line and swap the formal arguments for real ones */
/* QL: M148_do_arg */
M148_do_arg:
/* QL:         bsr.s   M148_nxnon           get the def token */
    bsr.s M148_nxnon
/* QL:         bsr.s   M148_s2non           get the PROC/FN token */
    bsr.s M148_s2non
/* QL:         bsr.s   M148_s2non           get the name */
    bsr.s M148_s2non
/* QL:         tst.w   d3 */
    tst.w d3
/* QL:         blt.s   M148_no_nmchk */
    blt.s M148_no_nmchk
/* QL:         cmp.w   2(a6,a4.l),d3   is it the one we think we're calling? */
    cmp.w 2(a6,a4.l),d3
/* QL:         bne.s   M148_err_nf4         you can't fool us */
    bne.s M148_err_nf4
/* QL: M148_no_nmchk */
M148_no_nmchk:
/* QL:         jsr     ib_s4non(pc) */
    jsr ib_s4non(pc)
/* QL:         cmp.w   #M148_w.opar,d1      is it a close parenthesis? */
    cmp.w #M148_w.opar,d1
/* QL:         beq.s   M148_get_arg         yes, good, get the arguments */
    beq.s M148_get_arg
/* QL:         bsr.s   ib_cheos        at end of statement? */
    bsr.s ib_cheos
/* QL:         beq.s   M148_rts4            yes: fine, we just get out here */
    beq.s M148_rts4
/* QL: M148_err_nf4 */
M148_err_nf4:
/* QL:         addq.l  #4,sp           skip the return */
    addq.l #4,sp
/* QL: M148_err_nf1 */
M148_err_nf1:
/* QL:         moveq   #M148_err.nf,d0      must be a duff line */
    moveq #M148_err.nf,d0
/* QL: M148_rts4 */
M148_rts4:
/* QL:         rts */
    rts 
/* QL: M148_nxarg */
M148_nxarg:
/* QL:         cmp.w   #M148_w.cpar,d1      end of args yet? */
    cmp.w #M148_w.cpar,d1
/* QL:         beq.s   M148_rts4            yes, get out */
    beq.s M148_rts4
/* QL: M148_get_arg */
M148_get_arg:
/* QL:         addq.l  #2,a4           skip */
    addq.l #2,a4
/* QL: M148_get_arg1 */
M148_get_arg1:
/* QL:         bsr.s   M148_nxnon */
    bsr.s M148_nxnon
/* QL: M148_get_arg2 */
M148_get_arg2:
/* QL:         cmp.b   #M148_b.nam,d0       is this a name? */
    cmp.b #(M148_b.nam&255),d0
/* QL:         bne.s   M148_nxarg */
    bne.s M148_nxarg
/* QL:         move.l  M148_bv_ntbas(a6),d1 */
    move.l M148_bv_ntbas(a6),d1
/* QL:         add.l   -M148_rt.rsbl(a6,a1.l),d1 */
    add.l (-M148_rt.rsbl)(a6,a1.l),d1
/* QL:         cmp.l   d1,a5           is there a real arg to swap it with? */
    cmp.l d1,a5
/* QL:         bge.s   M148_argshort */
    bge.s M148_argshort
/* QL:         bsr.l   M148_swapit          yes - swap it */
    bsr.w M148_swapit
/* QL:         bra.s   M148_get_arg1        and look for the next one */
    bra.s M148_get_arg1
/* QL: * This happens when we have more formal than actual args */
/* QL: M148_argshort */
M148_argshort:
/* QL:         bsr.s   M148_mk_dum          make a dummy one, just like a local */
    bsr.s M148_mk_dum
/* QL:         addq.l  #8,-M148_rt.rsbl(a6,a1.l) update base of locals as well */
    addq.l #8,(-M148_rt.rsbl)(a6,a1.l)
/* QL:         bra.s   M148_get_arg2 */
    bra.s M148_get_arg2
/* QL: ib_ret */
ib_ret:
/* QL:         move.l  M148_bv_rtp(a6),a1   now then, top of return table */
    move.l M148_bv_rtp(a6),a1
/* QL:         cmp.l   M148_bv_rtbas(a6),a1 anything on stack? */
    cmp.l M148_bv_rtbas(a6),a1
/* QL:         ble.s   M148_err_nf1         not been called so can't return */
    ble.s M148_err_nf1
/* QL:         moveq   #M148_rt.lentl-M148_rt.lenpr,d1 ready to take GOSUB len off rt */
    moveq #(M148_rt.lentl-M148_rt.lenpr),d1
/* QL:         move.b  -M148_rt.rsrtt(a6,a1.l),d5 what have we here? */
    move.b (-M148_rt.rsrtt)(a6,a1.l),d5
/* QL:         beq.s   M148_gohome          it's a GOSUB, so we're done */
    beq.s M148_gohome
/* QL:         assert  0,M148_x.bpr-1,M148_x.bfn-2,M148_x.bf0-3 */
/* original assertion: 0,M148_x.bpr-1,M148_x.bfn-2,M148_x.bf0-3 */
/* QL:         lsr.b   #1,d5           is this a function? */
    lsr.b #1,d5
/* QL:         beq.s   M148_not_fn */
    beq.s M148_not_fn
/* QL:         move.b  -M148_rt.rsfnt(a6,a1.l),d0 if so, get function type */
    move.b (-M148_rt.rsfnt)(a6,a1.l),d0
/* QL:         move.l  a4,a0 */
    move.l a4,a0
/* QL:         jsr     ca_eval(pc) */
    jsr ca_eval(pc)
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         ble.s   M148_err_ev */
    ble.s M148_err_ev
/* QL:         move.l  M148_bv_rtp(a6),a1 */
    move.l M148_bv_rtp(a6),a1
/* QL: M148_not_fn */
M148_not_fn:
/* QL:         bsr.s   M148_undo_ret */
    bsr.s M148_undo_ret
/* QL:         moveq   #M148_rt.lentl,d1    PROCs and FNs have an extra lump */
    moveq #M148_rt.lentl,d1
/* QL: M148_gohome */
M148_gohome:
/* QL:         sub.l   d1,M148_bv_rtp(a6)   take len off rt */
    sub.l d1,M148_bv_rtp(a6)
/* QL:         move.l  -M148_rt.rssta(a6,a1.l),M148_bv_inlin(a6) restore inline, single, index */
    move.l (-M148_rt.rssta)(a6,a1.l),M148_bv_inlin(a6)
/* QL:         move.w  -M148_rt.rslno(a6,a1.l),d4 linenumber to go back to */
    move.w (-M148_rt.rslno)(a6,a1.l),d4
/* QL:         bsr.s   M148_restart         go to it */
    bsr.s M148_restart
/* QL:         move.l  -M148_rt.rssta(a6,a1.l),M148_bv_inlin(a6) restore inline, single, index */
    move.l (-M148_rt.rssta)(a6,a1.l),M148_bv_inlin(a6)
/* QL:         move.b  -M148_rt.rsstm(a6,a1.l),d4 restore statement */
    move.b (-M148_rt.rsstm)(a6,a1.l),d4
/* QL:         jsr     ib_gost(pc)     and go */
    jsr ib_gost(pc)
/* QL:         sf      M148_bv_unrvl(a6)    turn off the unravel flag */
    sf M148_bv_unrvl(a6)
/* QL:         tst.b   d5              is this a function? */
    tst.b d5
/* QL:         beq.s   M148_okrts           no - we're done */
    beq.s M148_okrts
/* QL:         move.l  M148_bv_ntp(a6),a5   should be entry that goes with ri stack */
    move.l M148_bv_ntp(a6),a5
/* QL:         assert  M148_x.bfn>>1,M148_x.bf0>>1,M148_t.intern */
/* original assertion: M148_x.bfn>>1,M148_x.bf0>>1,M148_t.intern */
/* QL:         move.b  d5,-8(a6,a5.l)  mark it as internal */
    move.b d5,(-8)(a6,a5.l)
/* QL:         addq.l  #8,sp           definately don't want to go back to start */
    addq.l #8,sp
/* QL:         move.l  (sp)+,a0        restore position in expression */
    move.l (sp)+,a0
/* QL:         add.l   M148_bv_bfp+4(a6),a0 wrt a6 */
    add.l (M148_bv_bfp+4)(a6),a0
/* QL:         move.l  M148_bv_rip(a6),a1   restore arithmetic stack pointer */
    move.l M148_bv_rip(a6),a1
/* QL: M148_okrts */
M148_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M148_err_ev */
M148_err_ev:
/* QL:         blt.s   M148_rts6 */
    blt.s M148_rts6
/* QL:         moveq   #M148_err.xp,d0 */
    moveq #M148_err.xp,d0
/* QL: M148_rts6 */
M148_rts6:
/* QL:         rts */
    rts 
/* QL: M148_qstbas */
M148_qstbas:
/* QL:         beq.s   M148_rts6            at eof? */
    beq.s M148_rts6
/* QL:         jmp     ib_stbas(pc)    yes, have to start at the top again */
    jmp ib_stbas(pc)
/* QL: M148_posdflq */
M148_posdflq:
/* QL:         bsr.s   M148_qstbas          check if we have to start at the top again */
    bsr.s M148_qstbas
/* QL: M148_posdfl */
M148_posdfl:
/* QL:         move.w  -M148_rt.rsdfl(a6,a1.l),d4 line number of def line */
    move.w (-M148_rt.rsdfl)(a6,a1.l),d4
/* QL:         add.l   M148_bv_ntbas(a6),a5 */
    add.l M148_bv_ntbas(a6),a5
/* QL: M148_restart */
M148_restart:
/* QL:         jsr     ib_golin(pc) */
    jsr ib_golin(pc)
/* QL:         jmp     ib_stnxl(pc) */
    jmp ib_stnxl(pc)
/* QL: * a1 -i o- top of return table */
/* QL: M148_undo_ret */
M148_undo_ret:
/* QL:         cmp.l   M148_bv_pfbas(a6),a4 */
    cmp.l M148_bv_pfbas(a6),a4
/* QL:         ble.s   M148_set_strt */
    ble.s M148_set_strt
/* QL:         cmp.l   M148_bv_pfp(a6),a4 */
    cmp.l M148_bv_pfp(a6),a4
/* QL:         blt.s   M148_get_lin */
    blt.s M148_get_lin
/* QL: M148_set_strt */
M148_set_strt:
/* QL:         jsr     ib_stbas(pc)    set to top of PF & all the other bits */
    jsr ib_stbas(pc)
/* QL: M148_get_lin */
M148_get_lin:
/* QL:         move.b  -M148_rt.rsswp(a6,a1.l),d0 have the args been swapped? */
    move.b (-M148_rt.rsswp)(a6,a1.l),d0
/* QL:         beq.s   M148_clr_arg         no, err must have occurred during garg */
    beq.s M148_clr_arg
/* QL:         move.l  -M148_rt.rsbl(a6,a1.l),a5 base of locals */
    move.l (-M148_rt.rsbl)(a6,a1.l),a5
/* QL:         bsr.s   M148_posdfl          go to def line */
    bsr.s M148_posdfl
/* QL: M148_get_loc1 */
M148_get_loc1:
/* QL:         bsr.l   M148_find_loc        find a LOCal statement */
    bsr.w M148_find_loc
/* QL:         bne.s   M148_end_loc         isn't one */
    bne.s M148_end_loc
/* QL: M148_nx_loc1 */
M148_nx_loc1:
/* QL:         jsr     ib_nxnam(pc)    get next local name */
    jsr ib_nxnam(pc)
/* QL:         beq.s   M148_get_loc1        loop if end of statement */
    beq.s M148_get_loc1
/* QL:         bsr.l   M148_swapit          and swap it back */
    bsr.w M148_swapit
/* QL:         subq.l  #4,a4           else nxnam doesn't work on dimensioned local */
    subq.l #4,a4
/* QL:         bra.s   M148_nx_loc1 */
    bra.s M148_nx_loc1
/* QL: M148_end_loc */
M148_end_loc:
/* QL:         moveq   #-1,d3          we don't want to check the name */
    moveq #(-1),d3
/* QL:         move.l  -M148_rt.rsba(a6,a1.l),a5 base of args */
    move.l (-M148_rt.rsba)(a6,a1.l),a5
/* QL:         tst.b   d0              end of file? */
    tst.b d0
/* QL:         bsr.s   M148_posdflq         go back to def line, from top if at eof */
    bsr.s M148_posdflq
/* QL:         bsr.l   M148_do_arg          do the argument swapping again */
    bsr.w M148_do_arg
/* QL: * Now free the arguments */
/* QL: M148_clr_arg */
M148_clr_arg:
/* QL:         move.l  M148_bv_ntbas(a6),a5 */
    move.l M148_bv_ntbas(a6),a5
/* QL:         move.l  a5,a3 */
    move.l a5,a3
/* QL:         add.l   -M148_rt.rsba(a6,a1.l),a3 base of args to free */
    add.l (-M148_rt.rsba)(a6,a1.l),a3
/* QL:         add.l   -M148_rt.rstl(a6,a1.l),a5 top of args to free */
    add.l (-M148_rt.rstl)(a6,a1.l),a5
/* QL:         jmp     ca_carg(pc)     clear all the args (local as well) */
    jmp ca_carg(pc)
/* QL: M148_rts8 */
M148_rts8:
/* QL:         rts */
    rts 
/* QL: * d1 -i  - depth of stack that needs to be copied to top of stack */
/* QL: * a4 -i  - */
/* QL: * d0/a0-a1/a3/a5 destroyed */
/* QL: ib_unret */
ib_unret:
/* QL:         subq.l  #8,sp           68020 compatible */
    subq.l #8,sp
/* QL:         movem.l a6/sp,(sp)      get a snapshot of a6/sp */
    movem.l a6/sp,(sp)
/* QL:         movem.l (sp),d2-d3      get back snapshotted a6/sp */
    movem.l (sp),d2-d3
/* QL:         sub.l   d2,d3           this is the stack a6 offset */
    sub.l d2,d3
/* QL:         addq.l  #4,d3           we won't touch the out-of-memory return */
    addq.l #4,d3
/* QL:         sub.l   M148_bv_ssbas(a6),d3 this is the distance to get to top (-ve) */
    sub.l M148_bv_ssbas(a6),d3
/* QL:         sub.l   d3,sp           so put stack pointer up there */
    sub.l d3,sp
/* QL:         add.l   d1,d3           this is the distance to copy from */
    add.l d1,d3
/* QL: M148_copystk */
M148_copystk:
/* QL:         move.w  6(sp,d3.l),-(sp) copy requested stack depth up to top */
    move.w 6(sp,d3.l),-(sp)
/* QL:         subq.w  #2,d1 */
    subq.w #2,d1
/* QL:         bne.s   M148_copystk */
    bne.s M148_copystk
/* QL:         clr.l   M148_bv_sssav(a6)    this can't be valid anymore! lwr */
    clr.l M148_bv_sssav(a6)
/* QL: *        sf      M148_bv_comln(a6)    neither can this! lwr (new system though...) */
/* QL:         sf      M148_bv_unrvl(a6)    turn off the unravel flag */
    sf M148_bv_unrvl(a6)
/* QL:         st      M148_bv_sing(a6)     set single line on (really? lwr) */
    st M148_bv_sing(a6)
/* QL:         move.l  M148_bv_chbas(a6),a0 base of channels */
    move.l M148_bv_chbas(a6),a0
/* QL:         move.l  0(a6,a0.l),a0   actual console channel id */
    move.l 0(a6,a0.l),a0
/* QL:         moveq   #M148_err.pf,d0 */
    moveq #M148_err.pf,d0
/* QL:         jsr     ut_err(pc)      tell user we're clearing out */
    jsr ut_err(pc)
/* QL: M148_nxt_un */
M148_nxt_un:
/* QL:         move.l  M148_bv_rtp(a6),a1   now then, top of return table */
    move.l M148_bv_rtp(a6),a1
/* QL:         cmp.l   M148_bv_rtbas(a6),a1 anything on stack? */
    cmp.l M148_bv_rtbas(a6),a1
/* QL:         ble.s   M148_rts8 */
    ble.s M148_rts8
/* QL:         move.b  -M148_rt.rsrtt(a6,a1.l),d5 */
    move.b (-M148_rt.rsrtt)(a6,a1.l),d5
/* QL:         beq.s   M148_gosub_0         yes, and it's a GOSUB */
    beq.s M148_gosub_0
/* QL:         bsr.l   M148_undo_ret        unravel the return */
    bsr.w M148_undo_ret
/* QL:         sub.w   #M148_rt.lenpr,a1 */
    sub.w #M148_rt.lenpr,a1
/* QL: M148_gosub_0 */
M148_gosub_0:
/* QL:         subq.l  #M148_rt.lentl-M148_rt.lenpr,a1 */
.word 20873|((((M148_rt.lentl-M148_rt.lenpr))&7)<<9)
/* QL:         move.l  a1,M148_bv_rtp(a6)   set the return stack pointer down a level */
    move.l a1,M148_bv_rtp(a6)
/* QL:         subq.b  #M148_x.bfn,d5 */
    subq.b #M148_x.bfn,d5
/* QL:         blt.s   M148_nxt_un          GOSUB or PROCedure, do next */
    blt.s M148_nxt_un
/* QL:         move.l  M148_bv_ntp(a6),a5 */
    move.l M148_bv_ntp(a6),a5
/* QL:         subq.l  #8,a5           function, remove return value entry */
    subq.l #8,a5
/* QL: M148_nxt_exp */
M148_nxt_exp:
/* QL:         moveq   #0,d2           unravel entries down to 1st non-internal */
    moveq #0,d2
/* QL:         jsr     ca_undo(pc) */
    jsr ca_undo(pc)
/* QL:         bne.s   M148_nxt_exp */
    bne.s M148_nxt_exp
/* QL:         move.l  a5,M148_bv_ntp(a6)   reset the name table pointer */
    move.l a5,M148_bv_ntp(a6)
/* QL:         bra.s   M148_nxt_un */
    bra.s M148_nxt_un
/* QL:         end */
