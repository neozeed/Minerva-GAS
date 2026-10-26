/* ROM section ib_next */
.balign 2,0
/* QL: * d6 - l - keeps name row safe, msb flags assignment made */
/* QL: * d4 -il - name row(i), arg for golin, gost(l) */
/* QL: * a4 -i o- program file */
/* QL: * a2 - l - loop description */
/* QL: M160_isfp */
M160_isfp:
/* QL:         jsr     bv_chri(pc)     check ri */
    jsr bv_chri(pc)
/* QL:         move.l  M160_bv_rip(a6),a1 */
    move.l M160_bv_rip(a6),a1
/* QL:         sub.w   #2*6,a1 */
    sub.w #(2*6),a1
/* QL:         move.l  M160_lp.sexp+2(a6,a2.l),2(a6,a1.l) put step onto ari stack */
    move.l (M160_lp.sexp+2)(a6,a2.l),2(a6,a1.l)
/* QL:         beq.s   M160_finx            zero mantissa */
    beq.s M160_finx
/* QL:         move.w  M160_lp.sexp(a6,a2.l),0(a6,a1.l) step exponent */
    move.w M160_lp.sexp(a6,a2.l),0(a6,a1.l)
/* QL:         move.w  M160_lp.iexp(a6,a2.l),6(a6,a1.l) put index onto ari stack */
    move.w M160_lp.iexp(a6,a2.l),6(a6,a1.l)
/* QL:         move.l  M160_lp.iexp+2(a6,a2.l),6+2(a6,a1.l) */
    move.l (M160_lp.iexp+2)(a6,a2.l),(6+2)(a6,a1.l)
/* QL:         jsr     ri_add(pc)      add step to index value */
    jsr ri_add(pc)
/* QL:         bne.s   M160_finx */
    bne.s M160_finx
/* QL:         jsr     ri_dup(pc)      copy result */
    jsr ri_dup(pc)
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.l  M160_lp.eexp+2(a6,a2.l),2(a6,a1.l) put end value onto ari stack */
    move.l (M160_lp.eexp+2)(a6,a2.l),2(a6,a1.l)
/* QL:         move.w  M160_lp.eexp(a6,a2.l),0(a6,a1.l) */
    move.w M160_lp.eexp(a6,a2.l),0(a6,a1.l)
/* QL:         jsr     ri_sub(pc) */
    jsr ri_sub(pc)
/* QL:         moveq   #13,d1          diff in exps (1e4) neccessary for equality */
    moveq #13,d1
/* QL:         add.w   0(a6,a1.l),d1   add the (index+step-endval) exponent */
    add.w 0(a6,a1.l),d1
/* QL:         cmp.w   M160_lp.sexp(a6,a2.l),d1 compare it with the step exponent */
    cmp.w M160_lp.sexp(a6,a2.l),d1
/* QL:         lea     M160_lp.eexp-6(a2),a0 if we're near end value, make it exact */
    lea (M160_lp.eexp-6)(a2),a0
/* QL:         ble.s   M160_cont            this is so close, use exact endval */
    ble.s M160_cont
/* QL:         move.l  a1,a0           the saved result is just above here */
    move.l a1,a0
/* QL:         tst.b   2(a6,a1.l)      look at top of mantissa */
    tst.b 2(a6,a1.l)
/* QL:         blt.s   M160_neg_0           negative */
    blt.s M160_neg_0
/* QL:         tst.b   M160_lp.sexp+2(a6,a2.l) pos, what about top of step? */
    tst.b (M160_lp.sexp+2)(a6,a2.l)
/* QL:         blt.s   M160_cont            negative, continue stepping */
    blt.s M160_cont
/* QL: M160_finx */
M160_finx:
/* QL:         bra.l   M160_fin1            M160_range exhausted */
    bra.w M160_fin1
/* QL: M160_neg_0 */
M160_neg_0:
/* QL:         tst.b   M160_lp.sexp+2(a6,a2.l) step sign? */
    tst.b (M160_lp.sexp+2)(a6,a2.l)
/* QL:         blt.s   M160_finx            end of M160_range */
    blt.s M160_finx
/* QL: M160_cont */
M160_cont:
/* QL:         move.w  6(a6,a0.l),M160_lp.iexp(a6,a2.l) update the index with new value */
    move.w 6(a6,a0.l),M160_lp.iexp(a6,a2.l)
/* QL:         move.l  6+2(a6,a0.l),M160_lp.iexp+2(a6,a2.l) */
    move.l (6+2)(a6,a0.l),(M160_lp.iexp+2)(a6,a2.l)
/* QL:         bra.s   M160_assign */
    bra.s M160_assign
/* QL: ib_next */
ib_next:
/* QL:         bsr.l   ib_gtlpl */
    bsr.w ib_gtlpl
/* QL:         beq.s   ib_loop */
    beq.s ib_loop
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: M160_rts0 */
M160_rts0:
/* QL:         rts */
    rts 
/* QL: * Set psuedo end for inline consrtucts */
/* QL: ib_psend */
ib_psend:
/* QL:         move.b  #127,M160_bv_stmnt(a6) highly unlikely statement number */
    move.b #(127&255),M160_bv_stmnt(a6)
/* QL:         move.w  M160_bv_index(a6),d4 last inline index name spotted */
    move.w M160_bv_index(a6),d4
/* QL:         bsr.l   M160_gtind           get everything else from gtlpl */
    bsr.w M160_gtind
/* QL:         bne.s   M160_rts0 */
    bne.s M160_rts0
/* QL: * Machinery for NEXT */
/* QL: ib_loop */
ib_loop:
/* QL:         moveq   #0,d6           clear msb of d6 as flag for no assignment yet */
    moveq #0,d6
/* QL:         move.w  d4,d6           save name row */
    move.w d4,d6
/* QL:         subq.b  #M160_t.rep,d1       is this a REP loop? */
    subq.b #M160_t.rep,d1
/* QL:         beq.s   M160_simple_0        yes */
    beq.s M160_simple_0
/* QL:         subq.b  #M160_t.fp,d2        what type are we doing? */
    subq.b #M160_t.fp,d2
/* QL:         bgt.s   M160_isint */
    bgt.s M160_isint
/* QL:         beq.l   M160_isfp */
    beq.w M160_isfp
/* QL:         move.b  M160_lp.sexp+2(a6,a2.l),d0 */
    move.b (M160_lp.sexp+2)(a6,a2.l),d0
/* QL:         beq.s   M160_fin1            step zero, so finish */
    beq.s M160_fin1
/* QL:         spl     d3 */
    spl d3
/* QL:         tst.b   M160_lp.iexp+1(a6,a2.l) */
    tst.b (M160_lp.iexp+1)(a6,a2.l)
/* QL:         beq.s   M160_fin1            someone's made it a null, i'll stop here */
    beq.s M160_fin1
/* QL:         move.b  M160_lp.iexp+2(a6,a2.l),d1 */
    move.b (M160_lp.iexp+2)(a6,a2.l),d1
/* QL:         add.b   d0,d1 */
    add.b d0,d1
/* QL:         bvs.s   M160_fin1            went over top, forget it */
    bvs.s M160_fin1
/* QL:         cmp.b   M160_lp.eexp+2(a6,a2.l),d1 */
    cmp.b (M160_lp.eexp+2)(a6,a2.l),d1
/* QL:         beq.s   M160_usestr */
    beq.s M160_usestr
/* QL:         sgt     d0 */
    sgt d0
/* QL:         eor.b   d0,d3 */
    eor.b d0,d3
/* QL:         beq.s   M160_fin1 */
    beq.s M160_fin1
/* QL: M160_usestr */
M160_usestr:
/* QL:         move.b  d1,M160_lp.iexp+2(a6,a2.l) */
    move.b d1,(M160_lp.iexp+2)(a6,a2.l)
/* QL:         bra.s   M160_assign */
    bra.s M160_assign
/* QL: M160_useint */
M160_useint:
/* QL:         move.w  d1,M160_lp.iexp(a6,a2.l) */
    move.w d1,M160_lp.iexp(a6,a2.l)
/* QL: M160_assign */
M160_assign:
/* QL:         bset    #31,d6          set flag for assignment made */
    bset #31,d6
/* QL: M160_simple_0 */
M160_simple_0:
/* QL:         sf      d3 */
    sf d3
/* QL:         bra.s   M160_simple */
    bra.s M160_simple
/* QL: M160_isint */
M160_isint:
/* QL:         move.w  M160_lp.sexp(a6,a2.l),d0 */
    move.w M160_lp.sexp(a6,a2.l),d0
/* QL:         beq.s   M160_fin1            step zero, so we're M160_done */
    beq.s M160_fin1
/* QL:         spl     d3              remember it's sign */
    spl d3
/* QL:         move.w  M160_lp.iexp(a6,a2.l),d1 */
    move.w M160_lp.iexp(a6,a2.l),d1
/* QL:         add.w   d0,d1 */
    add.w d0,d1
/* QL:         bvs.s   M160_fin1            went over the top, so must be finished! */
    bvs.s M160_fin1
/* QL:         cmp.w   M160_lp.eexp(a6,a2.l),d1 */
    cmp.w M160_lp.eexp(a6,a2.l),d1
/* QL:         beq.s   M160_useint          exact match, use it */
    beq.s M160_useint
/* QL:         sgt     d0 */
    sgt d0
/* QL:         eor.b   d0,d3           ok, so was inc +ve and we're gt, or the reverse */
    eor.b d0,d3
/* QL:         bne.s   M160_useint          yes - straight end of M160_range */
    bne.s M160_useint
/* QL: M160_fin1 */
M160_fin1:
/* QL:         moveq   #1,d3 */
    moveq #1,d3
/* QL: M160_simple */
M160_simple:
/* QL:         bsr.s   M160_ch_lplin */
    bsr.s M160_ch_lplin
/* QL:         bne.s   M160_exit */
    bne.s M160_exit
/* QL:         tst.b   M160_bv_inlin(a6)    in-line for? */
    tst.b M160_bv_inlin(a6)
/* QL:         ble.s   M160_offinl          no, turn it off */
    ble.s M160_offinl
/* QL:         cmp.b   #127,M160_bv_stmnt(a6) real end or pseudo end? */
    cmp.b #(127&255),M160_bv_stmnt(a6)
/* QL:         bne.s   M160_leaveinl */
    bne.s M160_leaveinl
/* QL: M160_offinl */
M160_offinl:
/* QL:         sf      M160_bv_inlin(a6)    turn inline flag off */
    sf M160_bv_inlin(a6)
/* QL: M160_leaveinl */
M160_leaveinl:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M160_exit */
M160_exit:
/* QL:         move.l  d6,d4           has a var. been assigned to? */
    move.l d6,d4
/* QL:         bpl.s   M160_back            no, go M160_back */
    bpl.s M160_back
/* QL:         tst.w   M160_bv_wvnum(a6)    are there any when vars. to check? */
    tst.w M160_bv_wvnum(a6)
/* QL:         beq.s   M160_back            no */
    beq.s M160_back
/* QL:         jmp     ib_wtest(pc)    if when var. cond. satisfied, act */
    jmp ib_wtest(pc)
/* QL: * Check loop line is all it is supposed to be */
/* QL: * a2 -i  - loop index entry */
/* QL: * d3 -i  - 0 if just check wanted, non-0 if M160_next frange required */
/* QL: * d6 -i o- name row */
/* QL: M160_ch_lplin */
M160_ch_lplin:
/* QL:         move.b  M160_bv_stmnt(a6),-(sp) save statement */
    move.b M160_bv_stmnt(a6),-(sp)
/* QL:         move.l  M160_bv_linum(a6),-(sp) save line num, length */
    move.l M160_bv_linum(a6),-(sp)
/* QL:         move.l  a4,-(sp) */
    move.l a4,-(sp)
/* QL:         move.w  M160_lp.sl(a6,a2.l),d4 start line of loop */
    move.w M160_lp.sl(a6,a2.l),d4
/* QL:         jsr     ib_golin(pc)    set prog file pointer to FOR */
    jsr ib_golin(pc)
/* QL:         bne.s   M160_rest_nf */
    bne.s M160_rest_nf
/* QL:         jsr     ib_stnxi(pc)    start the M160_next line off not changing i/l */
    jsr ib_stnxi(pc)
/* QL:         move.b  M160_lp.ss(a6,a2.l),d4 read start statement */
    move.b M160_lp.ss(a6,a2.l),d4
/* QL:         jsr     ib_gost(pc)     go to statement */
    jsr ib_gost(pc)
/* QL:         jsr     ib_nxnon(pc)    look at first thing on it */
    jsr ib_nxnon(pc)
/* QL:         sub.w   #M160_w.for,d1       is it a FOR */
    sub.w #M160_w.for,d1
/* QL:         assert  2,M160_w.rep-M160_w.for */
/* original assertion: 2,M160_w.rep-M160_w.for */
/* QL:         roxr.w  #2,d1           or a REP? */
    roxr.w #2,d1
/* QL:         bne.s   M160_rest_nf */
    bne.s M160_rest_nf
/* QL:         addq.l  #2,a4 */
    addq.l #2,a4
/* QL:         move.l  a4,a5 */
    move.l a4,a5
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   2(a6,a4.l),d6   does the name match? */
    cmp.w 2(a6,a4.l),d6
/* QL:         bne.s   M160_rest_nf */
    bne.s M160_rest_nf
/* QL:         tst.b   d3 */
    tst.b d3
/* QL:         bne.s   M160_do_range */
    bne.s M160_do_range
/* QL: M160_end_ch */
M160_end_ch:
/* QL:         add.w   #4+4+2,sp */
    add.w #((4+4)+2),sp
/* QL:         rts */
    rts 
/* QL: M160_rest_nf */
M160_rest_nf:
/* QL:         moveq   #M160_err.nf,d0 */
    moveq #M160_err.nf,d0
/* QL:         bra.s   M160_rest_ch */
    bra.s M160_rest_ch
/* QL: M160_do_range */
M160_do_range:
/* QL:         move.l  a5,a4 */
    move.l a5,a4
/* QL:         add.w   M160_lp.chpos(a6,a2.l),a4 add previous char pos to pf pointer */
    add.w M160_lp.chpos(a6,a2.l),a4
/* QL:         move.w  d6,d4           need this for forange */
    move.w d6,d4
/* QL:         bsr.s   ib_frnge */
    bsr.s ib_frnge
/* QL:         beq.s   M160_end_ch          good M160_range */
    beq.s M160_end_ch
/* QL:         blt.s   M160_rest_ch         error in M160_range line */
    blt.s M160_rest_ch
/* QL:         moveq   #0,d0           exhausted all ranges */
    moveq #0,d0
/* QL: M160_rest_ch */
M160_rest_ch:
/* QL:         move.l  (sp)+,a4 */
    move.l (sp)+,a4
/* QL:         move.l  (sp)+,M160_bv_linum(a6) restore line number, length */
    move.l (sp)+,M160_bv_linum(a6)
/* QL:         move.b  (sp)+,M160_bv_stmnt(a6) restore which statement */
    move.b (sp)+,M160_bv_stmnt(a6)
/* QL: M160_back */
M160_back:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: * a2 -i  - beginning of index description */
/* QL: * d0 -  o- -ve error in exp */
/* QL: *            0 good M160_range found */
/* QL: *           +1 for line exhausted */
/* QL: * N.B. Unlike previously, this doesn't zap the value in a variable when it */
/* QL: * finds a M160_range that is already exhausted. It acheives this by putting the */
/* QL: * start value into the step slot first, then only copying it across to its */
/* QL: * proper place when it has established that the M160_range is not exhausted. */
/* QL: ib_frnge */
ib_frnge:
/* QL:         move.l  a4,-(sp)        save current pf position */
    move.l a4,-(sp)
/* QL:         move.w  0(a6,a4.l),d1 */
    move.w 0(a6,a4.l),d1
/* QL:         jsr     ib_cheos(pc)    line feed or colon M160_next? */
    jsr ib_cheos(pc)
/* QL:         bne.s   M160_chk_rng */
    bne.s M160_chk_rng
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL:         bra.s   M160_pop_4 */
    bra.s M160_pop_4
/* QL: M160_chk_rng */
M160_chk_rng:
/* QL:         cmp.w   #M160_w.equal,d1 */
    cmp.w #M160_w.equal,d1
/* QL:         beq.s   M160_read_rng */
    beq.s M160_read_rng
/* QL:         cmp.w   #M160_w.symcom,d1 */
    cmp.w #M160_w.symcom,d1
/* QL:         bne.s   M160_pop4_or */
    bne.s M160_pop4_or
/* QL: M160_read_rng */
M160_read_rng:
/* QL:         move.w  d4,d6           keep name row safe */
    move.w d4,d6
/* QL:         bsr.l   ib_index        pick up info first time in */
    bsr.w ib_index
/* QL:         bsr.l   M160_getexpr         get the first expression */
    bsr.w M160_getexpr
/* QL:         cmp.w   #M160_w.keyto,0(a6,a4.l) is it a TO ? */
    cmp.w #M160_w.keyto,0(a6,a4.l)
/* QL:         beq.s   M160_range           yes, otherwise single value, set defaults */
    beq.s M160_range
/* QL:         move.w  d0,M160_lp.eexp(a6,a2.l) len, exp or val of the index value */
    move.w d0,M160_lp.eexp(a6,a2.l)
/* QL:         move.l  d1,M160_lp.eexp+2(a6,a2.l) mantissa/chars of the index value */
    move.l d1,(M160_lp.eexp+2)(a6,a2.l)
/* QL:         clr.w   M160_lp.sexp(a6,a2.l) use a step of zero */
    clr.w M160_lp.sexp(a6,a2.l)
/* QL:         clr.l   M160_lp.sexp+2(a6,a2.l) */
    clr.l (M160_lp.sexp+2)(a6,a2.l)
/* QL:         move.l  (sp)+,d2 */
    move.l (sp)+,d2
/* QL:         move.w  d0,M160_lp.iexp(a6,a2.l) copy index value exponent */
    move.w d0,M160_lp.iexp(a6,a2.l)
/* QL:         move.l  d1,M160_lp.iexp+2(a6,a2.l) and mantissa */
    move.l d1,(M160_lp.iexp+2)(a6,a2.l)
/* QL:         sub.l   a4,d2 */
    sub.l a4,d2
/* QL:         sub.w   d2,M160_lp.chpos(a6,a2.l) initial character position */
    sub.w d2,M160_lp.chpos(a6,a2.l)
/* QL:         bra.l   M160_done */
    bra.w M160_done
/* QL: M160_range */
M160_range:
/* QL:         move.w  d0,M160_lp.sexp(a6,a2.l) len, exp or val of the index value */
    move.w d0,M160_lp.sexp(a6,a2.l)
/* QL:         move.l  d1,M160_lp.sexp+2(a6,a2.l) mantissa/chars of the index value */
    move.l d1,(M160_lp.sexp+2)(a6,a2.l)
/* QL:         addq.b  #M160_t.fp,d2        what was the type? */
    addq.b #M160_t.fp,d2
/* QL:         bcc.s   M160_do_to           not string, so we're happy */
    bcc.s M160_do_to
/* QL:         subq.w  #1,d0           is it a single char? */
    subq.w #1,d0
/* QL:         beq.s   M160_do_to           yes - we understand how to do that */
    beq.s M160_do_to
/* QL: M160_pop4_or */
M160_pop4_or:
/* QL:         moveq   #M160_err.or,d0 */
    moveq #M160_err.or,d0
/* QL: M160_pop_4 */
M160_pop_4:
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: M160_do_to */
M160_do_to:
/* QL:         bsr.l   M160_getexpr         get the to value */
    bsr.w M160_getexpr
/* QL:         move.w  d0,M160_lp.eexp(a6,a2.l) and copy it into the descriptor */
    move.w d0,M160_lp.eexp(a6,a2.l)
/* QL:         move.l  d1,M160_lp.eexp+2(a6,a2.l) */
    move.l d1,(M160_lp.eexp+2)(a6,a2.l)
/* QL:         addq.b  #M160_t.fp,d2        once again, was it a string? */
    addq.b #M160_t.fp,d2
/* QL:         bcc.s   M160_dostep */
    bcc.s M160_dostep
/* QL:         subq.w  #1,d0 */
    subq.w #1,d0
/* QL:         bne.s   M160_pop4_or */
    bne.s M160_pop4_or
/* QL: M160_dostep */
M160_dostep:
/* QL:         moveq   #1,d1           constructing default step of one */
    moveq #1,d1
/* QL:         moveq   #1,d0           step int 1 or strlen */
    moveq #1,d0
/* QL:         subq.b  #M160_t.fp,d2 */
    subq.b #M160_t.fp,d2
/* QL:         bgt.s   M160_gostep */
    bgt.s M160_gostep
/* QL:         blt.s   M160_dorot */
    blt.s M160_dorot
/* QL:         move.w  #$801,d0        fp exp */
    move.w #0x801,d0
/* QL:         moveq   #$40,d1         fp mant (soon) */
    moveq #0x40,d1
/* QL: M160_dorot */
M160_dorot:
/* QL:         ror.l   #8,d1           position chr$(1) or fp mant $40000000 */
    ror.l #8,d1
/* QL: M160_gostep */
M160_gostep:
/* QL:         cmp.w   #M160_w.step,0(a6,a4.l) is M160_next token step ? */
    cmp.w #M160_w.step,0(a6,a4.l)
/* QL:         bne.s   M160_setstep         nope, use what we just constructed */
    bne.s M160_setstep
/* QL:         addq.b  #M160_t.fp,d2 */
    addq.b #M160_t.fp,d2
/* QL:         bsr.l   M160_getexpr */
    bsr.w M160_getexpr
/* QL:         tst.b   d2              last time, is is a string? */
    tst.b d2
/* QL:         bpl.s   M160_setstep */
    bpl.s M160_setstep
/* QL:         cmp.w   #1,d0 */
    cmp.w #1,d0
/* QL:         bne.s   M160_pop4_or */
    bne.s M160_pop4_or
/* QL: M160_setstep */
M160_setstep:
/* QL:         move.l  (sp)+,d3        take off previous pf pos */
    move.l (sp)+,d3
/* QL:         sub.l   a4,d3           current pf position */
    sub.l a4,d3
/* QL:         sub.w   d3,M160_lp.chpos(a6,a2.l) and add the difference to prev ch pos */
    sub.w d3,M160_lp.chpos(a6,a2.l)
/* QL:         tst.b   d2              which type are we doing? */
    tst.b d2
/* QL:         bgt.s   M160_strtint */
    bgt.s M160_strtint
/* QL:         beq.s   M160_strtfp */
    beq.s M160_strtfp
/* QL:         move.l  d1,d2 */
    move.l d1,d2
/* QL:         rol.l   #8,d2 */
    rol.l #8,d2
/* QL:         tst.b   d2 */
    tst.b d2
/* QL:         beq.s   M160_swap6           step zero is good */
    beq.s M160_swap6
/* QL:         spl     d3 */
    spl d3
/* QL:         move.b  M160_lp.sexp+2(a6,a2.l),d2 */
    move.b (M160_lp.sexp+2)(a6,a2.l),d2
/* QL:         cmp.b   M160_lp.eexp+2(a6,a2.l),d2 */
    cmp.b (M160_lp.eexp+2)(a6,a2.l),d2
/* QL: M160_fpset */
M160_fpset:
/* QL:         bne.s   M160_strint */
    bne.s M160_strint
/* QL: M160_swap6 */
M160_swap6:
/* QL:         move.l  M160_lp.sexp+2(a6,a2.l),M160_lp.iexp+2(a6,a2.l) */
    move.l (M160_lp.sexp+2)(a6,a2.l),(M160_lp.iexp+2)(a6,a2.l)
/* QL:         move.l  d1,M160_lp.sexp+2(a6,a2.l) */
    move.l d1,(M160_lp.sexp+2)(a6,a2.l)
/* QL: M160_swap2 */
M160_swap2:
/* QL:         move.w  M160_lp.sexp(a6,a2.l),M160_lp.iexp(a6,a2.l) */
    move.w M160_lp.sexp(a6,a2.l),M160_lp.iexp(a6,a2.l)
/* QL:         move.w  d0,M160_lp.sexp(a6,a2.l) */
    move.w d0,M160_lp.sexp(a6,a2.l)
/* QL: M160_done */
M160_done:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M160_strtint */
M160_strtint:
/* QL:         tst.w   d0 */
    tst.w d0
/* QL:         beq.s   M160_swap2            step zero is good */
    beq.s M160_swap2
/* QL:         spl     d3 */
    spl d3
/* QL:         move.w  M160_lp.sexp(a6,a2.l),d2 */
    move.w M160_lp.sexp(a6,a2.l),d2
/* QL:         cmp.w   M160_lp.eexp(a6,a2.l),d2 */
    cmp.w M160_lp.eexp(a6,a2.l),d2
/* QL:         beq.s   M160_swap2 */
    beq.s M160_swap2
/* QL: M160_strint */
M160_strint:
/* QL:         slt     d2 */
    slt d2
/* QL:         eor.b   d2,d3 */
    eor.b d2,d3
/* QL:         bpl.s   M160_swap6 */
    bpl.s M160_swap6
/* QL: M160_next */
M160_next:
/* QL:         bra.l   ib_frnge */
    bra.w ib_frnge
/* QL: M160_strtfp */
M160_strtfp:
/* QL:         tst.l   d1 */
    tst.l d1
/* QL:         beq.s   M160_swap6           step zero is good */
    beq.s M160_swap6
/* QL:         move.l  d1,-(sp)        save stuff for a moment */
    move.l d1,-(sp)
/* QL:         move.w  d0,-(sp) */
    move.w d0,-(sp)
/* QL:         jsr     bv_chri(pc)     make sure we've got some space */
    jsr bv_chri(pc)
/* QL:         move.l  M160_bv_rip(a6),a1 */
    move.l M160_bv_rip(a6),a1
/* QL:         moveq   #12,d0 */
    moveq #12,d0
/* QL:         add.l   d0,a2 */
    add.l d0,a2
/* QL: M160_pushfp */
M160_pushfp:
/* QL:         subq.l  #4,a2           put initial, then end, value on stack */
    subq.l #4,a2
/* QL:         subq.l  #4,a1 */
    subq.l #4,a1
/* QL:         move.l  M160_lp.eexp(a6,a2.l),0(a6,a1.l) */
    move.l M160_lp.eexp(a6,a2.l),0(a6,a1.l)
/* QL:         subq.w  #4,d0 */
    subq.w #4,d0
/* QL:         bne.s   M160_pushfp */
    bne.s M160_pushfp
/* QL:         jsr     ri_cmp(pc)      compare them */
    jsr ri_cmp(pc)
/* QL:         move.w  (sp)+,d0 */
    move.w (sp)+,d0
/* QL:         move.l  (sp)+,d1 */
    move.l (sp)+,d1
/* QL:         spl     d3 */
    spl d3
/* QL:         move.b  2(a6,a1.l),d2 */
    move.b 2(a6,a1.l),d2
/* QL:         bra.s   M160_fpset */
    bra.s M160_fpset
/* QL: * Evaluate one of x, y or z from "for var = x to y step z" */
/* QL: * d2 = var type, d6 = name row, a4 = program  */
/* QL: M160_pop_8 */
M160_pop_8:
/* QL:         addq.l  #8,sp */
    addq.l #8,sp
/* QL:         rts */
    rts 
/* QL: M160_getexpr */
M160_getexpr:
/* QL:         addq.l  #2,a4           skip the token we just matched */
    addq.l #2,a4
/* QL:         move.l  a4,a0           beg of expression */
    move.l a4,a0
/* QL:         move.b  d2,d0 */
    move.b d2,d0
/* QL:         jsr     ca_eval(pc)     evaluate it */
    jsr ca_eval(pc)
/* QL:         move.l  a0,a4           points to 1st non-expression token */
    move.l a0,a4
/* QL:         ble.s   M160_pop_8 */
    ble.s M160_pop_8
/* QL:         bsr.s   M160_ib_indx1        get beg of loop description */
    bsr.s M160_ib_indx1
/* QL:         move.w  0(a6,a1.l),d0   len, exp or val of the index value */
    move.w 0(a6,a1.l),d0
/* QL:         bsr.s   M160_formoff         make up a nice adjuster for ri stack */
    bsr.s M160_formoff
/* QL:         add.l   d1,M160_bv_rip(a6) */
    add.l d1,M160_bv_rip(a6)
/* QL:         move.l  2(a6,a1.l),d1   mantissa/chars of the index value */
    move.l 2(a6,a1.l),d1
/* QL:         rts */
    rts 
/* QL: M160_formoff */
M160_formoff:
/* QL:         moveq   #2,d1 */
    moveq #2,d1
/* QL:         subq.b  #M160_t.fp,d2        what is it's type? */
    subq.b #M160_t.fp,d2
/* QL:         bgt.s   M160_rts1            integer, we're ready */
    bgt.s M160_rts1
/* QL:         beq.s   M160_form4p          fp, a bit more to drop */
    beq.s M160_form4p
/* QL:         move.w  d0,d1           copy the length */
    move.w d0,d1
/* QL:         subq.l  #4,d1           is it a bit too long? */
    subq.l #4,d1
/* QL:         bcs.s   M160_formrnd         no, so go round it */
    bcs.s M160_formrnd
/* QL:         sub.w   d1,d0           truncate to max. four */
    sub.w d1,d0
/* QL: M160_formrnd */
M160_formrnd:
/* QL:         addq.l  #3,d1           incorporate length and one for rounding */
    addq.l #3,d1
/* QL:         bclr    #0,d1           round to even */
    bclr #0,d1
/* QL: M160_form4p */
M160_form4p:
/* QL:         addq.l  #4,d1 */
    addq.l #4,d1
/* QL: M160_rts1 */
M160_rts1:
/* QL:         rts */
    rts 
/* QL: * d0 -  o- found(0) or not (o) */
/* QL: * d1 -  o- 1st byte of nt description */
/* QL: * d2 -  o- 2nd byte of nt description */
/* QL: * d4 -  o- name row */
/* QL: * a2 -  o- pointer to loop description */
/* QL: * a4 -i o- program file */
/* QL: ib_gtlpl */
ib_gtlpl:
/* QL:         jsr     ib_nxnon(pc)    get non-space */
    jsr ib_nxnon(pc)
/* QL:         move.w  2(a6,a4.l),d4   read name */
    move.w 2(a6,a4.l),d4
/* QL:         addq.l  #4,a4 */
    addq.l #4,a4
/* QL: M160_gtind */
M160_gtind:
/* QL:         bsr.s   ib_index        get offset on vv of loop description */
    bsr.s ib_index
/* QL:         moveq   #M160_t.for,d0 */
    moveq #M160_t.for,d0
/* QL:         sub.b   d1,d0           is it a FOR */
    sub.b d1,d0
/* QL:         assert  1,M160_t.for-M160_t.rep */
/* original assertion: 1,M160_t.for-M160_t.rep */
/* QL:         lsr.b   #1,d0           or a REP? */
    lsr.b #1,d0
/* QL:         beq.s   M160_rts2 */
    beq.s M160_rts2
/* QL:         moveq   #M160_err.nf,d0 */
    moveq #M160_err.nf,d0
/* QL: M160_rts2 */
M160_rts2:
/* QL:         rts */
    rts 
/* QL: * d0 -  o- vv offset from vvbas */
/* QL: * d1 -  o- 1st byte of name description (name type) */
/* QL: * d2 -  o- 4 lsbs of 2nd byte (variable type) */
/* QL: * d4 -ip - name row */
/* QL: * a2 -  o- beg of vv desc */
/* QL: M160_ib_indx1 */
M160_ib_indx1:
/* QL:         move.w  d6,d4           put_str in eval uses d4 in strings */
    move.w d6,d4
/* QL: ib_index */
ib_index:
/* QL:         bsr.s   ib_fname */
    bsr.s ib_fname
/* QL:         move.b  0(a6,a2.l),d1   name type */
    move.b 0(a6,a2.l),d1
/* QL:         moveq   #15,d2 */
    moveq #15,d2
/* QL:         and.b   1(a6,a2.l),d2   variable type */
    and.b 1(a6,a2.l),d2
/* QL:         move.l  4(a6,a2.l),d0   get value offset */
    move.l 4(a6,a2.l),d0
/* QL:         move.l  M160_bv_vvbas(a6),a2 base of var tab */
    move.l M160_bv_vvbas(a6),a2
/* QL:         add.l   d0,a2           move to beginning of index description */
    add.l d0,a2
/* QL:         rts */
    rts 
/* QL: * d0 -  o- name offset */
/* QL: * d4 -ip - name row */
/* QL: * a2 -  o- beg of name table data */
/* QL: ib_fname */
ib_fname:
/* QL:         moveq   #0,d0           (being cautious, don't expect msw 0. lwr) */
    moveq #0,d0
/* QL:         move.w  d4,d0 */
    move.w d4,d0
/* QL:         lsl.l   #3,d0           offset of name entry */
    lsl.l #3,d0
/* QL:         move.l  M160_bv_ntbas(a6),a2 */
    move.l M160_bv_ntbas(a6),a2
/* QL:         add.l   d0,a2           point at name entry */
    add.l d0,a2
/* QL:         rts */
    rts 
/* QL:         end */
