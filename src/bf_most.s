/* ROM section bf_most */
.balign 2,0
/* QL:         bf_ri   sin,cos,tan,cot,asin,acos,exp,ln,log10,sqrt */
/* QL: i       setnum  1 */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   M144_fn_trig */
bf_sin:
    bsr.s M144_fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
M144_dc_anchor_791:
.word ((ri_sin-M144_dc_anchor_791))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   M144_fn_trig */
bf_cos:
    bsr.s M144_fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
M144_dc_anchor_805:
.word ((ri_cos-M144_dc_anchor_805))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   M144_fn_trig */
bf_tan:
    bsr.s M144_fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
M144_dc_anchor_819:
.word ((ri_tan-M144_dc_anchor_819))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   M144_fn_trig */
bf_cot:
    bsr.s M144_fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
M144_dc_anchor_833:
.word ((ri_cot-M144_dc_anchor_833))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   M144_fn_trig */
bf_asin:
    bsr.s M144_fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
M144_dc_anchor_847:
.word ((ri_asin-M144_dc_anchor_847))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   M144_fn_trig */
bf_acos:
    bsr.s M144_fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
M144_dc_anchor_861:
.word ((ri_acos-M144_dc_anchor_861))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   M144_fn_trig */
bf_exp:
    bsr.s M144_fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
M144_dc_anchor_875:
.word ((ri_exp-M144_dc_anchor_875))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   M144_fn_trig */
bf_ln:
    bsr.s M144_fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
M144_dc_anchor_889:
.word ((ri_ln-M144_dc_anchor_889))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   M144_fn_trig */
bf_log10:
    bsr.s M144_fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
M144_dc_anchor_903:
.word ((ri_log10-M144_dc_anchor_903))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: lp      maclab */
/* QL: t       setstr  [.parm([i])] */
/* QL:         xdef    bf_[t] */
/* QL:         xref    ri_[t] */
/* QL: bf_[t]  bsr.s   M144_fn_trig */
bf_sqrt:
    bsr.s M144_fn_trig
/* QL:         dc.w    ri_[t]-* */
.balign 2,0
M144_dc_anchor_917:
.word ((ri_sqrt-M144_dc_anchor_917))&65535
/* QL: i       setnum  [i]+1 */
/* QL:         ifnum   [i] <= [.nparms] goto lp */
/* QL: bf_abs */
bf_abs:
/* QL:         bsr.s   M144_gtfp            get args */
    bsr.s M144_gtfp
/* QL:         jsr     ri_sss(pc)      rountine invented espesially for this */
    jsr ri_sss(pc)
/* QL:         bra.s   M144_fp_put1 */
    bra.s M144_fp_put1
/* QL: bf_pi */
bf_pi:
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         bne.s   M144_err_bp0         should be no parameters for pi */
    bne.s M144_err_bp0
/* QL:         bsr.s   M144_get_ri1         make space */
    bsr.s M144_get_ri1
/* QL:         moveq   #M144_ri.pi,d0 */
    moveq #M144_ri.pi,d0
/* QL:         bsr.s   M144_do_trig */
    bsr.s M144_do_trig
/* QL:         dc.w    ri_k_b-* */
.balign 2,0
M144_dc_anchor_943:
.word ((ri_k_b-M144_dc_anchor_943))&65535
/* QL: M144_err_bp0 */
M144_err_bp0:
/* QL:         moveq   #M144_err.bp,d0 */
    moveq #M144_err.bp,d0
/* QL:         rts */
    rts 
/* QL: bf_acot */
bf_acot:
/* QL:         moveq   #-1,d7 */
    moveq #(-1),d7
/* QL: bf_atan */
bf_atan:
/* QL:         bsr.s   M144_gtfp            get 1/2 args */
    bsr.s M144_gtfp
/* QL:         subq.w  #2,d3 */
    subq.w #2,d3
/* QL:         beq.s   M144_arggo */
    beq.s M144_arggo
/* QL:         addq.w  #1,d3 */
    addq.w #1,d3
/* QL:         bne.s   M144_err_bp0 */
    bne.s M144_err_bp0
/* QL:         jsr     ri_one(pc) */
    jsr ri_one(pc)
/* QL: M144_arggo */
M144_arggo:
/* QL:         tst.l   d7 */
    tst.l d7
/* QL:         bpl.s   M144_istan */
    bpl.s M144_istan
/* QL:         jsr     ri_swap(pc) */
    jsr ri_swap(pc)
/* QL: M144_istan */
M144_istan:
/* QL:         bsr.s   M144_do_trig */
    bsr.s M144_do_trig
/* QL:         dc.w    ri_arg-* */
.balign 2,0
M144_dc_anchor_983:
.word ((ri_arg-M144_dc_anchor_983))&65535
/* QL: M144_gtfp */
M144_gtfp:
/* QL:         jsr     ca_gtfp(pc)     get all args as floating point */
    jsr ca_gtfp(pc)
/* QL:         bne.s   M144_popifne */
    bne.s M144_popifne
/* QL: M144_get_ri1 */
M144_get_ri1:
/* QL:         bra.l   M144_get_ri0         ensure we have space on stack */
    bra.w M144_get_ri0
/* QL: M144_deg_rad */
M144_deg_rad:
/* QL:         jsr     ca_gtfp1(pc)    get just one argument */
    jsr ca_gtfp1(pc)
/* QL:         bne.s   M144_popifne */
    bne.s M144_popifne
/* QL:         bsr.s   M144_get_ri1         and get just a little bit more space */
    bsr.s M144_get_ri1
/* QL:         moveq   #M144_ri.pi180,d0 */
    moveq #M144_ri.pi180,d0
/* QL:         jsr     ri_k_b(pc) */
    jsr ri_k_b(pc)
/* QL:         bra.s   M144_do_trig */
    bra.s M144_do_trig
/* QL: bf_deg */
bf_deg:
/* QL:         bsr.s   M144_deg_rad */
    bsr.s M144_deg_rad
/* QL:         dc.w    ri_div-*        divide by pi/180 */
.balign 2,0
M144_dc_anchor_1015:
.word ((ri_div-M144_dc_anchor_1015))&65535
/* QL: bf_rad */
bf_rad:
/* QL:         bsr.s   M144_deg_rad */
    bsr.s M144_deg_rad
/* QL:         dc.w    ri_mult-*       multiply by pi/180 */
.balign 2,0
M144_dc_anchor_1023:
.word ((ri_mult-M144_dc_anchor_1023))&65535
/* QL: M144_fn_trig */
M144_fn_trig:
/* QL:         jsr     ca_gtfp1(pc)    get one and only one fp arg */
    jsr ca_gtfp1(pc)
/* QL: M144_popifne */
M144_popifne:
/* QL:         bne.s   M144_pop_4a */
    bne.s M144_pop_4a
/* QL:         bsr.s   M144_get_ri1         make sure there's enough room */
    bsr.s M144_get_ri1
/* QL: M144_do_trig */
M144_do_trig:
/* QL:         move.l  (sp)+,a4 */
    move.l (sp)+,a4
/* QL:         add.w   (a4),a4 */
    add.w (a4),a4
/* QL:         jsr     (a4)            do the trig function */
    jsr (a4)
/* QL: M144_fp_put1 */
M144_fp_put1:
/* QL:         bra.s   M144_fp_put0 */
    bra.s M144_fp_put0
/* QL: * Random number generator */
/* QL: M144_rndold */
M144_rndold:
/* QL: * old scheme when lsb of M144_bv_rand is set. we use: */
/* QL: *       x'=a*x mod 2^32, a=89*2^2-1, period 2^30 */
/* QL:         mulu    #355,d5 */
    mulu #355,d5
/* QL:         mulu    #355,d6 */
    mulu #355,d6
/* QL:         swap    d6 */
    swap d6
/* QL:         clr.w   d6 */
    clr.w d6
/* QL:         bra.s   M144_rndadd */
    bra.s M144_rndadd
/* QL: bf_rnd */
bf_rnd:
/* QL:         move.l  M144_bv_rand(a6),d5  get random number */
    move.l M144_bv_rand(a6),d5
/* QL:         move.l  d5,d6           save it */
    move.l d5,d6
/* QL:         swap    d6 */
    swap d6
/* QL:         btst    d7,d5 */
    btst d7,d5
/* QL:         bne.s   M144_rndold */
    bne.s M144_rndold
/* QL: * new scheme when lsb of M144_bv_rand is clear. with x=bv_rnd/2, we use: */
/* QL: *       x'=a*x+b mod 2^31 a=2^16+1 b=12517 period 2^31 */
/* QL: * the funny number for b is 32768*(3-sqrt(5))/2, which makes the lsw jump */
/* QL: * around in a fairly interesting way. */
/* QL:         move.w  #12517*2,d6 */
    move.w #(12517*2),d6
/* QL: M144_rndadd */
M144_rndadd:
/* QL:         add.l   d6,d5           add together */
    add.l d6,d5
/* QL:         move.l  d5,M144_bv_rand(a6)  ... save it */
    move.l d5,M144_bv_rand(a6)
/* QL:         jsr     ca_gtint(pc)    how many arguments? */
    jsr ca_gtint(pc)
/* QL:         bne.s   M144_rts2 */
    bne.s M144_rts2
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         beq.s   M144_rand_1          ... one */
    beq.s M144_rand_1
/* QL:         bgt.s   M144_rand_2          ... two */
    bgt.s M144_rand_2
/* QL:         bsr.s   M144_get_ri1         none - make space for one argument */
    bsr.s M144_get_ri1
/* QL:         move.l  d5,d1           and mantissa */
    move.l d5,d1
/* QL:         lsr.l   #1,d1           make positive */
    lsr.l #1,d1
/* QL:         move.w  #$0800,d0       set exponent */
    move.w #0x0800,d0
/* QL:         bsr.s   M144_do_trig */
    bsr.s M144_do_trig
/* QL:         dc.w    ri_renrm-*      return fp */
.balign 2,0
M144_dc_anchor_1108:
.word ((ri_renrm-M144_dc_anchor_1108))&65535
/* QL: M144_rand_2 */
M144_rand_2:
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bne.s   M144_err_bp1 */
    bne.s M144_err_bp1
/* QL:         move.w  0(a6,a1.l),d3   get base of range */
    move.w 0(a6,a1.l),d3
/* QL:         addq.l  #2,a1           lose extra integer on stack */
    addq.l #2,a1
/* QL: M144_rand_1 */
M144_rand_1:
/* QL:         move.w  0(a6,a1.l),d2   get top of range */
    move.w 0(a6,a1.l),d2
/* QL:         sub.w   d3,d2           less base */
    sub.w d3,d2
/* QL:         blt.s   M144_err_bp1         oops, no good if top<base */
    blt.s M144_err_bp1
/* QL:         addq.w  #1,d2           add one for total number of possible returns */
    addq.w #1,d2
/* QL:         beq.s   M144_rndtop          cope with range -32768to 32767!!! */
    beq.s M144_rndtop
/* QL:         swap    d5              use most significant end */
    swap d5
/* QL:         mulu    d2,d5           multiply */
    mulu d2,d5
/* QL: M144_rndtop */
M144_rndtop:
/* QL:         swap    d5              result is in top half */
    swap d5
/* QL:         add.w   d3,d5           ... plus base */
    add.w d3,d5
/* QL: M144_put_int */
M144_put_int:
/* QL:         move.w  d5,0(a6,a1.l)   set result */
    move.w d5,0(a6,a1.l)
/* QL:         moveq   #M144_t.int,d4       result is integer */
    moveq #M144_t.int,d4
/* QL: M144_put_ok */
M144_put_ok:
/* QL:         moveq   #0,d0           if here then good return */
    moveq #0,d0
/* QL: M144_put_rip */
M144_put_rip:
/* QL:         move.l  a1,M144_bv_rip(a6)   all results on stack */
    move.l a1,M144_bv_rip(a6)
/* QL: M144_rts2 */
M144_rts2:
/* QL:         rts */
    rts 
/* QL: * d0 -  o- 0 (no return on error) */
/* QL: * d1 -  o- long integer parameter */
/* QL: * d3 -  o- 0 */
/* QL: * a1 -  o- M144_bv_rip, parameter removed */
/* QL: * d2 destroyed */
/* QL: M144_gtli1 */
M144_gtli1:
/* QL:         jsr     ca_gtli1(pc)    get a long integer (returned in d1) */
    jsr ca_gtli1(pc)
/* QL:         addq.l  #4,a1           remove from RI stack */
    addq.l #4,a1
/* QL:         beq.s   M144_rts2 */
    beq.s M144_rts2
/* QL: M144_pop_4a */
M144_pop_4a:
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: bf_int */
bf_int:
/* QL:         bsr.s   M144_gtli1           get as a long integer */
    bsr.s M144_gtli1
/* QL: M144_pushlin0 */
M144_pushlin0:
/* QL:         jsr     ri_fllin(pc) */
    jsr ri_fllin(pc)
/* QL: M144_fp_put0 */
M144_fp_put0:
/* QL:         moveq   #M144_t.fp,d4        result is floating point */
    moveq #M144_t.fp,d4
/* QL:         bra.s   M144_put_rip */
    bra.s M144_put_rip
/* QL: bf_peekl */
bf_peekl:
/* QL:         moveq   #%10111-1,d7    peek a longword */
    moveq #(0b10111-1),d7
/* QL: bf_peekw */
bf_peekw:
/* QL:         addq.b  #1,d7           peek a word */
    addq.b #1,d7
/* QL: bf_peek */
bf_peek:
/* QL:         jsr     bp_pepo(pc)     get address, same code as poke routines */
    jsr bp_pepo(pc)
/* QL:         addq.l  #4,a1           adjust RI pointer */
    addq.l #4,a1
/* QL:         beq.s   M144_pkent           should be no params remaining */
    beq.s M144_pkent
/* QL: M144_err_bp1 */
M144_err_bp1:
/* QL:         moveq   #M144_err.bp,d0 */
    moveq #M144_err.bp,d0
/* QL: M144_rts3 */
M144_rts3:
/* QL:         rts */
    rts 
/* QL: M144_peeklp */
M144_peeklp:
/* QL:         rol.l   #8,d5 */
    rol.l #8,d5
/* QL: M144_pkent */
M144_pkent:
/* QL:         tst.b   d6 */
    tst.b d6
/* QL:         bgt.s   M144_absbn */
    bgt.s M144_absbn
/* QL:         move.b  0(a6,a5.l),d5 */
    move.b 0(a6,a5.l),d5
/* QL:         addq.l  #1,a5 */
    addq.l #1,a5
/* QL:         bra.s   M144_gotbn */
    bra.s M144_gotbn
/* QL: M144_absbn */
M144_absbn:
/* QL:         move.b  (a5)+,d5        no address constraint */
    move.b (a5)+,d5
/* QL: M144_gotbn */
M144_gotbn:
/* QL:         lsr.b   #1,d7           roll out a bit */
    lsr.b #1,d7
/* QL:         bcs.s   M144_peeklp          loop while one bits come out */
    bcs.s M144_peeklp
/* QL:         beq.s   M144_pushint0        if now zero, it wasn't peek_l */
    beq.s M144_pushint0
/* QL:         move.l  d5,d1 */
    move.l d5,d1
/* QL:         ext.l   d5 */
    ext.l d5
/* QL:         cmp.l   d5,d1           does it fit in an integer? */
    cmp.l d5,d1
/* QL:         bne.s   M144_pushlin0        no - make it into a float */
    bne.s M144_pushlin0
/* QL:         bra.s   M144_pushint0 */
    bra.s M144_pushint0
/* QL: bf_respr */
bf_respr:
/* QL:         bsr.s   M144_gtli1           get space required into d1 */
    bsr.s M144_gtli1
/* QL:         move.l  a1,a5 */
    move.l a1,a5
/* QL:         moveq   #M144_mt.alres,d0    allocate space in resident area (or chp!) */
    moveq #M144_mt.alres,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         bne.s   M144_rts3 */
    bne.s M144_rts3
/* QL:         move.l  a5,a1 */
    move.l a5,a1
/* QL: M144_reta0 */
M144_reta0:
/* QL:         move.l  a0,d1 */
    move.l a0,d1
/* QL: M144_pushlin1 */
M144_pushlin1:
/* QL:         bra.s   M144_pushlin0 */
    bra.s M144_pushlin0
/* QL: bf_beepg */
bf_beepg:
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         bne.s   M144_err_bp1         should be no parameters for beeping */
    bne.s M144_err_bp1
/* QL:         moveq   #M144_mt.inf,d0 */
    moveq #M144_mt.inf,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         moveq   #1,d5           mask out all but lsb */
    moveq #1,d5
/* QL:         and.b   M144_sv_sound(a0),d5 is it happenning? */
    and.b M144_sv_sound(a0),d5
/* QL: M144_gtpshint */
M144_gtpshint:
/* QL:         bsr.l   M144_get_ri0         reserve space */
    bsr.w M144_get_ri0
/* QL: M144_pushint0 */
M144_pushint0:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         bra.s   M144_put_int */
    bra.s M144_put_int
/* QL: bf_eof */
bf_eof:
/* QL:         cmp.l   a3,a5           is there a parameter? */
    cmp.l a3,a5
/* QL:         bne.s   M144_eof_chan */
    bne.s M144_eof_chan
/* QL:         jsr     bp_data(pc)     no, so get next data item */
    jsr bp_data(pc)
/* QL:         bra.s   M144_set_eof */
    bra.s M144_set_eof
/* QL: M144_eof_chan */
M144_eof_chan:
/* QL:         bsr.s   M144_chan            check for channel */
    bsr.s M144_chan
/* QL:         bne.s   M144_rts3            error, return same */
    bne.s M144_rts3
/* QL:         moveq   #M144_io.pend,d0     test channel */
    moveq #M144_io.pend,d0
/* QL:         clr.w   d3              immediate return */
    clr.w d3
/* QL:         trap    #3 */
    trap #3
/* QL: M144_set_eof */
M144_set_eof:
/* QL:         clr.w   d5              set false */
    clr.w d5
/* QL:         moveq   #-M144_err.ef,d4     check eof */
    moveq #(-M144_err.ef),d4
/* QL:         add.l   d0,d4 */
    add.l d0,d4
/* QL:         subq.l  #1,d4           is it eof? */
    subq.l #1,d4
/* QL:         addx.b  d5,d5           (only zero less one will set x) */
    addx.b d5,d5
/* QL:         bra.s   M144_gtpshint */
    bra.s M144_gtpshint
/* QL: bf_vers */
bf_vers:
/* QL:         bsr.l   M144_opt_int */
    bsr.w M144_opt_int
/* QL:         moveq   #M144_mt.inf,d0 */
    moveq #M144_mt.inf,d0
/* QL:         trap    #1              get OS stuff */
    trap #1
/* QL:         addq.w  #2,d7 */
    addq.w #2,d7
/* QL:         beq.s   M144_reta0           -2: system variables address */
    beq.s M144_reta0
/* QL:         bcs.s   M144_pushlin1        -1: current job number */
    bcs.s M144_pushlin1
/* QL:         subq.w  #2+1,d7 */
    subq.w #(2+1),d7
/* QL:         bcs.s   M144_vertop          0: normal version */
    bcs.s M144_vertop
/* QL:         bne.s   M144_err_bp2 */
    bne.s M144_err_bp2
/* QL:         subq.l  #6,a1 */
    subq.l #6,a1
/* QL:         move.l  d2,2(a6,a1.l)   1: QDOS OS version */
    move.l d2,2(a6,a1.l)
/* QL:         moveq   #4,d4 */
    moveq #4,d4
/* QL:         bra.s   M144_len_put */
    bra.s M144_len_put
/* QL: M144_chan */
M144_chan:
/* QL:         moveq   #0,d1           default to command screen */
    moveq #0,d1
/* QL:         jmp     bp_chand(pc)    get #n */
    jmp bp_chand(pc)
/* QL: M144_vertop */
M144_vertop:
/* QL:         moveq   #M144_sx_basic,d7 */
    moveq #M144_sx_basic,d7
/* QL:         move.l  M144_sv_chtop(a0),a0 */
    move.l M144_sv_chtop(a0),a0
/* QL:         add.l   d7,a0 */
    add.l d7,a0
/* QL:         move.w  (a0),d7 */
    move.w (a0),d7
/* QL:         bsr.s   M144_room_str        get space, and verify length is sensible */
    bsr.s M144_room_str
/* QL:         add.l   d1,a0 */
    add.l d1,a0
/* QL: M144_vercop */
M144_vercop:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  -(a0),0(a6,a1.l) version letters */
    move.w -(a0),0(a6,a1.l)
/* QL:         subq.w  #2,d1 */
    subq.w #2,d1
/* QL:         bne.s   M144_vercop */
    bne.s M144_vercop
/* QL:         bra.s   M144_len_put */
    bra.s M144_len_put
/* QL: bp_pause ; sad, but there's no sensible way to avoid this misnomer-ish entry */
bp_pause:
/* QL:         moveq   #-1,d7          infinite wait */
    moveq #(-1),d7
/* QL: bf_inkes */
bf_inkes:
/* QL:         bsr.s   M144_chan            check for channel */
    bsr.s M144_chan
/* QL:         bne.s   M144_noinkch         the channel's no good */
    bne.s M144_noinkch
/* QL:         bsr.s   M144_opt_int         get an optional integer */
    bsr.s M144_opt_int
/* QL:         move.w  d7,d3           set timeout */
    move.w d7,d3
/* QL:         move.l  a1,a4           save a1 */
    move.l a1,a4
/* QL:         moveq   #M144_io.fbyte,d0 */
    moveq #M144_io.fbyte,d0
/* QL:         trap    #3 */
    trap #3
/* QL:         move.l  a4,a1 */
    move.l a4,a1
/* QL:         moveq   #0,d4           ready for null string */
    moveq #0,d4
/* QL:         addq.l  #-M144_err.nc,d0 */
.word 20608|((((-M144_err.nc))&7)<<9)
/* QL:         beq.s   M144_len_push        if not complete - return null string */
    beq.s M144_len_push
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         subq.l  #-M144_err.nc,d0 */
.word 20864|((((-M144_err.nc))&7)<<9)
/* QL: M144_gotchrs */
M144_gotchrs:
/* QL:         bne.s   M144_noinkch */
    bne.s M144_noinkch
/* QL:         move.b  d1,0(a6,a1.l)   set return character */
    move.b d1,0(a6,a1.l)
/* QL:         moveq   #1,d4           string length 1 */
    moveq #1,d4
/* QL: M144_len_push */
M144_len_push:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL: M144_len_put */
M144_len_put:
/* QL:         move.w  d4,0(a6,a1.l)   (re)place the length */
    move.w d4,0(a6,a1.l)
/* QL:         moveq   #M144_t.str,d4       set type string */
    moveq #M144_t.str,d4
/* QL:         bra.l   M144_put_ok */
    bra.w M144_put_ok
/* QL: M144_noinkch */
M144_noinkch:
/* QL:         tst.l   d7              0 = inkey$/chr$, -1 = pause */
    tst.l d7
/* QL:         bpl.s   M144_rts5 */
    bpl.s M144_rts5
/* QL:         moveq   #0,d0           cancel error if pause (compatibility!) */
    moveq #0,d0
/* QL: M144_rts5 */
M144_rts5:
/* QL:         rts */
    rts 
/* QL: M144_err_bp2 */
M144_err_bp2:
/* QL:         moveq   #M144_err.bp,d0 */
    moveq #M144_err.bp,d0
/* QL:         rts */
    rts 
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- 60 */
/* QL: * a1 -  o- RI stack pointer */
/* QL: * d2 destroyed */
/* QL: M144_get_ri0 */
M144_get_ri0:
/* QL:         moveq   #10*6,d1        same as in bv_chri */
    moveq #(10*6),d1
/* QL: M144_chrix */
M144_chrix:
/* QL:         move.l  d1,a1 */
    move.l d1,a1
/* QL:         jsr     bv_chrix(pc) */
    jsr bv_chrix(pc)
/* QL:         move.l  a1,d1 */
    move.l a1,d1
/* QL:         move.l  M144_bv_rip(a6),a1 */
    move.l M144_bv_rip(a6),a1
/* QL:         rts */
    rts 
/* QL: * d0 -  o- 0 (no return on error) */
/* QL: * d1 -  o- total length including length word and possible padding byte */
/* QL: * d4 -  o- copy of d7 */
/* QL: * d7 -ip - length of string required */
/* QL: * a1 -  o- RI stack pointer */
/* QL: * d2 destroyed */
/* QL: M144_room_str */
M144_room_str:
/* QL:         move.w  d7,d4           copy length */
    move.w d7,d4
/* QL:         move.l  d7,d1 */
    move.l d7,d1
/* QL:         addq.w  #3,d1 */
    addq.w #3,d1
/* QL:         bcs.s   M144_bp_pop          reject string length $FFFD..$FFFF */
    bcs.s M144_bp_pop
/* QL:         bclr    #0,d1 */
    bclr #0,d1
/* QL:         bpl.s   M144_chrix           accept string length 0..32764 */
    bpl.s M144_chrix
/* QL: M144_bp_pop */
M144_bp_pop:
/* QL:         moveq   #M144_err.bp,d0 */
    moveq #M144_err.bp,d0
/* QL: M144_pop_4b */
M144_pop_4b:
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: bf_chrs */
bf_chrs:
/* QL:         bsr.s   M144_get_ri0         gotta get space, as we will need 2 bytes extra */
    bsr.s M144_get_ri0
/* QL:         jsr     ca_gtin1(pc)    get one integer (value in d1) */
    jsr ca_gtin1(pc)
/* QL:         bra.s   M144_gotchrs         store char, if no error */
    bra.s M144_gotchrs
/* QL: * Skip one parameter, and expect an optional, single, integer (default d7) */
/* QL: * Same as M144_opt_int below, except: */
/* QL: * a3 -i o- base of args / 8 added */
/* QL: M144_opt_2nd */
M144_opt_2nd:
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL: * Reserve 60 bytes on stack, get an optional, single, integer (default d7) */
/* QL: * d0 -  o- 0 (no return on error) */
/* QL: * d3 -  o- 0 if integer parameter was used, else -1 */
/* QL: * d7 -i o- default / same, or lsw from present parameter */
/* QL: * a3 -ip - base of args */
/* QL: * a1 -  o- RI stack pointer (optional integer removed, M144_bv_rip same) */
/* QL: * a5 -ip - top of args */
/* QL: * d1-d2 destroyed */
/* QL: M144_opt_int */
M144_opt_int:
/* QL:         bsr.s   M144_get_ri0         check for room on ri */
    bsr.s M144_get_ri0
/* QL:         jsr     ca_gtint(pc) */
    jsr ca_gtint(pc)
/* QL:         bne.s   M144_pop_4b */
    bne.s M144_pop_4b
/* QL:         subq.l  #1,d3 */
    subq.l #1,d3
/* QL:         blt.s   M144_rts5            no arg, leave default alone */
    blt.s M144_rts5
/* QL:         bne.s   M144_bp_pop          more than one arg, error */
    bne.s M144_bp_pop
/* QL:         move.w  0(a6,a1.l),d7 */
    move.w 0(a6,a1.l),d7
/* QL: M144_popword */
M144_popword:
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL:         bra.l   M144_put_rip */
    bra.w M144_put_rip
/* QL: bf_fills */
bf_fills:
/* QL:         subq.l  #8,a5           leave off the second parameter for now */
    subq.l #8,a5
/* QL:         bsr.s   M144_code_1          this ensures there are two parameters */
    bsr.s M144_code_1
/* QL:         subq.w  #1,d3           how long was the string? */
    subq.w #1,d3
/* QL:         bgt.s   M144_got_pair        >=2, use first 2 */
    bgt.s M144_got_pair
/* QL:         blt.s   M144_err_bp2         null string is no good */
    blt.s M144_err_bp2
/* QL:         move.w  d5,-(sp) */
    move.w d5,-(sp)
/* QL:         move.b  (sp)+,d5        duplicate a single character */
    move.b (sp)+,d5
/* QL: M144_got_pair */
M144_got_pair:
/* QL:         addq.l  #8,a5           re-include the second parameter */
    addq.l #8,a5
/* QL:         bsr.s   M144_opt_2nd         get the required length (must be there now) */
    bsr.s M144_opt_2nd
/* QL:         bsr.s   M144_room_str        make room for string */
    bsr.s M144_room_str
/* QL: M144_fillit */
M144_fillit:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  d5,0(a6,a1.l)   copy 2 chars */
    move.w d5,0(a6,a1.l)
/* QL:         subq.w  #2,d1           repeat filling string */
    subq.w #2,d1
/* QL:         bne.s   M144_fillit */
    bne.s M144_fillit
/* QL:         bra.s   M144_len_put         go put length */
    bra.s M144_len_put
/* QL: * Get a single string (d3=len, d5=0/1/2 chars), leave one word on the stack */
/* QL: M144_code_1 */
M144_code_1:
/* QL:         jsr     ca_gtst1(pc)    get a string */
    jsr ca_gtst1(pc)
/* QL:         bne.s   M144_pop_4b */
    bne.s M144_pop_4b
/* QL:         move.w  d1,d3           get length (returned in d1) */
    move.w d1,d3
/* QL:         move.w  2(a6,a1.l),d5   get first characters */
    move.w 2(a6,a1.l),d5
/* QL:         add.l   d3,a1 */
    add.l d3,a1
/* QL:         btst    d0,d3 */
    btst d0,d3
/* QL:         beq.s   M144_popword */
    beq.s M144_popword
/* QL:         addq.l  #1,a1 */
    addq.l #1,a1
/* QL:         bra.s   M144_popword */
    bra.s M144_popword
/* QL: bf_len */
bf_len:
/* QL:         bsr.s   M144_code_1 */
    bsr.s M144_code_1
/* QL: M144_c_null */
M144_c_null:
/* QL:         move.w  d3,d5 */
    move.w d3,d5
/* QL:         bra.s   M144_pushint1 */
    bra.s M144_pushint1
/* QL: bf_code */
bf_code:
/* QL:         bsr.s   M144_code_1 */
    bsr.s M144_code_1
/* QL:         tst.w   d3 */
    tst.w d3
/* QL:         beq.s   M144_c_null          code('') is zero */
    beq.s M144_c_null
/* QL:         lsr.w   #8,d5           just first character is the value */
    lsr.w #8,d5
/* QL:         bra.s   M144_pushint1 */
    bra.s M144_pushint1
/* QL: * Get the maximum size of a given dimension n of an array a (x=dimn(a{,n})) */
/* QL: bf_dimn */
bf_dimn:
/* QL:         moveq   #1,d7           default first dimension */
    moveq #1,d7
/* QL:         bsr.s   M144_opt_2nd         get optional dimension parameter */
    bsr.s M144_opt_2nd
/* QL:         clr.w   d5              if all else fails, return zero */
    clr.w d5
/* QL:         moveq   #M144_t.arr,d1       if it's not an array, i'm not interested */
    moveq #M144_t.arr,d1
/* QL:         sub.b   -8(a6,a3.l),d1  what sort was the first argument? */
    sub.b (-8)(a6,a3.l),d1
/* QL:         bne.s   M144_pushint1        not an array, so say zero, regardless */
    bne.s M144_pushint1
/* QL:         move.l  4-8(a6,a3.l),d1 offset of array descriptor */
    move.l (4-8)(a6,a3.l),d1
/* QL:         bmi.s   M144_pushint1        say zero if not set! (better than error?) */
    bmi.s M144_pushint1
/* QL:         add.l   M144_bv_vvbas(a6),d1 */
    add.l M144_bv_vvbas(a6),d1
/* QL:         cmp.w   4(a6,d1.l),d7   check number of dimensions */
    cmp.w 4(a6,d1.l),d7
/* QL:         bhi.s   M144_pushint1        too many */
    bhi.s M144_pushint1
/* QL:         lsl.w   #2,d7           which one? */
    lsl.w #2,d7
/* QL:         beq.s   M144_pushint1        hmmm... there isn't a zero dimension */
    beq.s M144_pushint1
/* QL:         add.w   d7,d1 */
    add.w d7,d1
/* QL:         move.w  2(a6,d1.l),d5   get max size */
    move.w 2(a6,d1.l),d5
/* QL: M144_pushint1 */
M144_pushint1:
/* QL:         bra.l   M144_pushint0 */
    bra.w M144_pushint0
/* QL:         end */
