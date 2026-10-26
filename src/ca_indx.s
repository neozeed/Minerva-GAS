/* ROM section ca_indx */
.balign 2,0
/* QL: * General usage: */
/* QL: * d0 to d3 scratch / used by ca_evali */
/* QL: * d4 index counter */
/* QL: * d5 start index given */
/* QL: * d6 possibly reduced new number of dimensions */
/* QL: * a0 pointer to tokenised buffer */
/* QL: * a1 pointer to arithmetic stack */
/* QL: * a3 base of / running pointer to descriptor */
/* QL: * a4 vv offset to data */
/* QL: * a5 current pointer to name table */
/* QL: * a6 base of basic variables */
/* QL: * Get slice range */
/* QL: * d0 -  o- error code (ccr set) */
/* QL: * d1 -  o- second index in lsw, -1 for defaulted. msw preserved. */
/* QL: * d5 -  o- first index in lsw, -1 for defaulted. msw zero. */
/* QL: * a0 -i o- pointer to token before first index to check / at token stopped on */
/* QL: * a1 -  o- pointer to arithmetic stack */
/* QL: * a5 -ip - pointer to some nt entry */
/* QL: * d2-d3/a3-a4 destroyed */
/* QL: ca_range */
ca_range:
/* QL:         sub.l   M94_bv_ntbas(a6),a5 protect nt pointer against movement */
    sub.l M94_bv_ntbas(a6),a5
/* QL:         move.l  a5,-(sp) */
    move.l a5,-(sp)
/* QL:         moveq   #-1,d5          flag first index */
    moveq #(-1),d5
/* QL: M94_rng_ind */
M94_rng_ind:
/* QL:         addq.l  #2,a0           move to next token */
    addq.l #2,a0
/* QL:         jsr     ca_evali(pc)    fetch value of next index */
    jsr ca_evali(pc)
/* QL:         beq.s   M94_rng_def         go set set default flag value */
    beq.s M94_rng_def
/* QL:         bmi.s   M94_rng_exit        die if index was bad */
    bmi.s M94_rng_exit
/* QL:         moveq   #M94_err.or,d0 */
    moveq #M94_err.or,d0
/* QL:         addq.l  #2,M94_bv_rip(a6)   drop supplied value from stack */
    addq.l #2,M94_bv_rip(a6)
/* QL:         move.w  0(a6,a1.l),d1   get supplied value */
    move.w 0(a6,a1.l),d1
/* QL:         addq.l  #2,a1 */
    addq.l #2,a1
/* QL:         bmi.s   M94_rng_exit        no good if negative (ccr is right) */
    bmi.s M94_rng_exit
/* QL:         bra.s   M94_rng_nxt */
    bra.s M94_rng_nxt
/* QL: M94_rng_def */
M94_rng_def:
/* QL:         moveq   #-1,d1          use -ve to flag omitted index */
    moveq #(-1),d1
/* QL: M94_rng_nxt */
M94_rng_nxt:
/* QL:         tst.l   d5 */
    tst.l d5
/* QL:         bpl.s   M94_rng_out         if 2nd time though, both indices are ready */
    bpl.s M94_rng_out
/* QL:         moveq   #0,d5           ready for 2nd pass */
    moveq #0,d5
/* QL:         move.w  d1,d5           save 1st index */
    move.w d1,d5
/* QL:         cmp.w   #M94_w.septo,0(a6,a0.l) check for 'to' */
    cmp.w #M94_w.septo,0(a6,a0.l)
/* QL:         beq.s   M94_rng_ind         if so, go get 2nd index */
    beq.s M94_rng_ind
/* QL:         moveq   #M94_err.xp,d0 */
    moveq #M94_err.xp,d0
/* QL:         tst.w   d5 */
    tst.w d5
/* QL:         bmi.s   M94_rng_exit        error if we didn't get any index (ccr is right) */
    bmi.s M94_rng_exit
/* QL: M94_rng_out */
M94_rng_out:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M94_rng_exit */
M94_rng_exit:
/* QL:         move.l  (sp)+,a5 */
    move.l (sp)+,a5
/* QL:         add.l   M94_bv_ntbas(a6),a5 */
    add.l M94_bv_ntbas(a6),a5
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code (ccr set) */
/* QL: * a0 -i o- token list pointer (ends up after close paren, if all ok) */
/* QL: * a1 -  o- pointer to arithmetic stack */
/* QL: * a5 -ip - pointer to top of nt entry being processed (with valid vv pointer) */
/* QL: * d1-d6/a3-a4 destroyed */
/* QL: ca_indx */
ca_indx:
/* QL:         and.b   #15,-7(a6,a5.l) mask any separator */
    and.b #(15&255),(-7)(a6,a5.l)
/* QL:         bsr.s   M94_get_ptrs */
    bsr.s M94_get_ptrs
/* QL:         move.l  a3,d6           a3 running input, d6 running output */
    move.l a3,d6
/* QL:         move.l  M94_d_vvptr(a6,a3.l),a4 get vv pointer to data */
    move.l M94_d_vvptr(a6,a3.l),a4
/* QL:         subq.l  #2,a0           back up to start loop easy */
    subq.l #2,a0
/* QL: M94_nxt_indx */
M94_nxt_indx:
/* QL:         sub.l   a3,d6 */
    sub.l a3,d6
/* QL:         sub.l   M94_bv_vvbas(a6),a3 ensure we're protected against movement */
    sub.l M94_bv_vvbas(a6),a3
/* QL:         move.l  a4,-(sp) */
    move.l a4,-(sp)
/* QL:         move.l  a3,-(sp) */
    move.l a3,-(sp)
/* QL:         bsr.s   ca_range */
    bsr.s ca_range
/* QL:         move.l  (sp)+,a3 */
    move.l (sp)+,a3
/* QL:         move.l  (sp)+,a4 */
    move.l (sp)+,a4
/* QL:         bne.s   M94_rts0 */
    bne.s M94_rts0
/* QL:         add.l   M94_bv_vvbas(a6),a3 restore our pointers */
    add.l M94_bv_vvbas(a6),a3
/* QL:         add.l   a3,d6 */
    add.l a3,d6
/* QL:         subq.w  #1,d4           there should have been an index left */
    subq.w #1,d4
/* QL:         blt.s   M94_err_or          if not, we've got too many dimensions spec'd */
    blt.s M94_err_or
/* QL:         bne.s   M94_def_1st         no worries if not on last dimension */
    bne.s M94_def_1st
/* QL:         assert  0,M94_t.str-1,M94_t.fp-2,M94_t.int-3 */
/* original assertion: 0,M94_t.str-1,M94_t.fp-2,M94_t.int-3 */
/* QL:         move.b  -7(a6,a5.l),d2 */
    move.b (-7)(a6,a5.l),d2
/* QL:         asr.b   #1,d2 */
    asr.b #1,d2
/* QL:         bne.s   M94_def_1st         only worry if last dim of non-numeric array */
    bne.s M94_def_1st
/* QL:         bcc.s   M94_is_char         already character array, so just byte index */
    bcc.s M94_is_char
/* QL:         move.w  d5,d2 */
    move.w d5,d2
/* QL:         or.w    d1,d2           are both indices zero? ('0' or '0to 0' allowed) */
    or.w d1,d2
/* QL:         beq.s   M94_str_int         yes: string lengths convert to integer array */
    beq.s M94_str_int
/* QL:         addq.l  #2,a4           push vv data base offset over integer length */
    addq.l #2,a4
/* QL:         clr.b   -7(a6,a5.l)     change type to character */
    clr.b (-7)(a6,a5.l)
/* QL: M94_is_char */
M94_is_char:
/* QL:         st      d0              set a flag for byte slicing */
    st d0
/* QL:         subq.w  #1,d5           put index down to proper value */
    subq.w #1,d5
/* QL:         bcs.s   M94_err_or          shouldn't have zero start index here! */
    bcs.s M94_err_or
/* QL: M94_def_1st */
M94_def_1st:
/* QL:         tst.w   d5              start defaulted? (-1 or -2) */
    tst.w d5
/* QL:         bpl.s   M94_ok_lo */
    bpl.s M94_ok_lo
/* QL:         clr.w   d5              default 0 start (effectively 1 for byte data) */
    clr.w d5
/* QL: M94_ok_lo */
M94_ok_lo:
/* QL:         move.w  d5,d3 */
    move.w d5,d3
/* QL:         assert  M94_d_max,M94_d_step-2 */
/* original assertion: M94_d_max,M94_d_step-2 */
/* QL:         move.l  M94_d_max(a6,a3.l),d2 pick up max dim and increment */
    move.l M94_d_max(a6,a3.l),d2
/* QL:         addq.l  #M94_d.adim,a3      move on */
    addq.l #M94_d.adim,a3
/* QL:         mulu    d2,d3           multiply by increment */
    mulu d2,d3
/* QL:         cmp.b   #M94_t.fp,-7(a6,a5.l) check type of array */
    cmp.b #(M94_t.fp&255),(-7)(a6,a5.l)
/* QL:         blt.s   M94_addbas          string */
    blt.s M94_addbas
/* QL:         bgt.s   M94_double          integer */
    bgt.s M94_double
/* QL:         add.l   d3,d3           float */
    add.l d3,d3
/* QL:         add.l   d3,a4           x 6 bytes for floating points */
    add.l d3,a4
/* QL: M94_double */
M94_double:
/* QL:         add.l   d3,a4           x 2 bytes for integers */
    add.l d3,a4
/* QL: M94_addbas */
M94_addbas:
/* QL:         add.l   d3,a4           add to vv data base offset */
    add.l d3,a4
/* QL:         swap    d2              bring down max dim */
    swap d2
/* QL:         cmp.w   d2,d5           start must be positive and le dimension */
    cmp.w d2,d5
/* QL:         bhi.s   M94_err_or */
    bhi.s M94_err_or
/* QL:         tst.w   d1 */
    tst.w d1
/* QL:         bmi.s   M94_max_2nd         default 2nd index, make it max */
    bmi.s M94_max_2nd
/* QL:         cmp.w   d1,d2 */
    cmp.w d1,d2
/* QL:         bcc.s   M94_top_ok          ok if not greater than current dimension */
    bcc.s M94_top_ok
/* QL:         tst.b   d0              are we slicing last dimension of byte data? */
    tst.b d0
/* QL:         bne.s   M94_max_2nd         yes - we allow top>dim (consistent with strvar) */
    bne.s M94_max_2nd
/* QL: M94_err_or */
M94_err_or:
/* QL:         moveq   #M94_err.or,d0 */
    moveq #M94_err.or,d0
/* QL: M94_rts0 */
M94_rts0:
/* QL:         rts */
    rts 
/* QL: M94_get_ptrs */
M94_get_ptrs:
/* QL:         move.l  -4(a6,a5.l),a3  fetch pointer to descriptor */
    move.l (-4)(a6,a5.l),a3
/* QL:         add.l   M94_bv_vvbas(a6),a3 make absolute */
    add.l M94_bv_vvbas(a6),a3
/* QL:         move.w  M94_d_dims(a6,a3.l),d4 fetch number of dimensions */
    move.w M94_d_dims(a6,a3.l),d4
/* QL:         rts */
    rts 
/* QL: * String slice has picked out lengths, which become an integer array */
/* QL: * Note that the ultimate element size is now 2, so all increments need halving  */
/* QL: M94_str_int */
M94_str_int:
/* QL:         addq.b  #M94_t.int-M94_t.str,-7(a6,a5.l) change type to integer */
    addq.b #(M94_t.int-M94_t.str),(-7)(a6,a5.l)
/* QL:         bsr.s   M94_get_ptrs        reload a3 with start of descriptor */
    bsr.s M94_get_ptrs
/* QL:         clr.w   d4              put remaining dims back to zero */
    clr.w d4
/* QL: M94_halveit */
M94_halveit:
/* QL:         cmp.l   d6,a3           have we got anything left to do? */
    cmp.l d6,a3
/* QL:         beq.s   M94_skip_dim        no, the last dim vanishes */
    beq.s M94_skip_dim
/* QL:         lsr     M94_d_step(a6,a3.l) halve the increment, 'cos string is now integer */
    lsr M94_d_step(a6,a3.l)
/* QL:         addq.l  #M94_d.adim,a3      move along to next dimension */
    addq.l #M94_d.adim,a3
/* QL:         bra.s   M94_halveit */
    bra.s M94_halveit
/* QL: M94_top_ok */
M94_top_ok:
/* QL:         move.w  d1,d2           replace dim with new value */
    move.w d1,d2
/* QL: M94_max_2nd */
M94_max_2nd:
/* QL:         sub.w   d5,d2 */
    sub.w d5,d2
/* QL:         bcs.s   M94_err_or          can't allow it to go negative! */
    bcs.s M94_err_or
/* QL:         bne.s   M94_put_dim         gotta keep non-zero dimension */
    bne.s M94_put_dim
/* QL:         tst.b   d0              are we slicing last dimension of byte data? */
    tst.b d0
/* QL:         beq.s   M94_skip_dim        we allow null sub-strings, but don't lose dim! */
    beq.s M94_skip_dim
/* QL: M94_put_dim */
M94_put_dim:
/* QL:         swap    d2 */
    swap d2
/* QL:         assert  M94_d_max,M94_d_step-2 */
/* original assertion: M94_d_max,M94_d_step-2 */
/* QL:         move.l  d2,M94_d_max(a6,d6.l) save new dimension and increment */
    move.l d2,M94_d_max(a6,d6.l)
/* QL:         addq.l  #M94_d.adim,d6 */
    addq.l #M94_d.adim,d6
/* QL: M94_skip_dim */
M94_skip_dim:
/* QL:         move.w  0(a6,a0.l),d0   look at delimiter */
    move.w 0(a6,a0.l),d0
/* QL:         cmp.w   #M94_w.sepcom,d0     is it a comma? */
    cmp.w #M94_w.sepcom,d0
/* QL:         beq.l   M94_nxt_indx        yes - continue getting slices/subscripts */
    beq.w M94_nxt_indx
/* QL:         cmp.w   #M94_w.cpar,d0      is it our close parenthesis? */
    cmp.w #M94_w.cpar,d0
/* QL:         beq.s   M94_desc_rdy        yes - that's nice */
    beq.s M94_desc_rdy
/* QL: M94_err_xp */
M94_err_xp:
/* QL:         moveq   #M94_err.xp,d0      didn't find the closing parenthesis */
    moveq #M94_err.xp,d0
/* QL:         rts */
    rts 
/* QL: * We've finished scanning the program code and got all our dimensions now */
/* QL: M94_tail_cpy */
M94_tail_cpy:
/* QL:         assert  M94_d_max,M94_d_step-2 */
/* original assertion: M94_d_max,M94_d_step-2 */
/* QL:         move.l  M94_d_max(a6,a3.l),M94_d_max(a6,d6.l) */
    move.l M94_d_max(a6,a3.l),M94_d_max(a6,d6.l)
/* QL:         addq.l  #M94_d.adim,d6 */
    addq.l #M94_d.adim,d6
/* QL:         addq.l  #M94_d.adim,a3 */
    addq.l #M94_d.adim,a3
/* QL: M94_desc_rdy */
M94_desc_rdy:
/* QL:         dbra    d4,M94_tail_cpy     copy down any remaining dim/inc pairs */
    dbra d4,M94_tail_cpy
/* QL:         bsr.s   M94_get_ptrs        reload a3 and d4 */
    bsr.s M94_get_ptrs
/* QL:         addq.l  #2,a0           move over matched close parenthesis */
    addq.l #2,a0
/* QL:         sub.l   a3,d6           total space occupied by repeated part */
    sub.l a3,d6
/* QL:         move.l  d6,d1           saved for possible allocate */
    move.l d6,d1
/* QL:         lsr.l   #M94_d..adim,d6     are we reducing to a simple variable? */
    lsr.l #M94_d..adim,d6
/* QL:         bne.s   M94_keep_arr        skip if not all dimensions have vanished */
    bne.s M94_keep_arr
/* QL: * $$$$$ Note. This may cause problems later if proc tries to free it $$$$$$$$ */
/* QL:         subq.b  #M94_t.arr-M94_t.var,-8(a6,a5.l) set name type to simple variable */
    subq.b #(M94_t.arr-M94_t.var),(-8)(a6,a5.l)
/* QL:         bra.s   M94_ind_free        go free the descriptor */
    bra.s M94_ind_free
/* QL: M94_keep_arr */
M94_keep_arr:
/* QL:         move.l  a4,M94_d_vvptr(a6,a3.l) set vv offset */
    move.l a4,M94_d_vvptr(a6,a3.l)
/* QL:         cmp.w   d4,d6           are we actually keeping everything? */
    cmp.w d4,d6
/* QL:         beq.s   M94_okrts           yes - so we've finished! */
    beq.s M94_okrts
/* QL: * Create new descriptor first (they're only small and it makes copying easy) */
/* QL:         move.w  d6,M94_d_dims(a6,a3.l) set new dimension count */
    move.w d6,M94_d_dims(a6,a3.l)
/* QL:         addq.l  #M94_d.base,d1      total length of new desc */
    addq.l #M94_d.base,d1
/* QL:         move.l  a0,a4           save a0 */
    move.l a0,a4
/* QL:         jsr     bv_alvv(pc)     allocate the space (resets a1 from M94_bv_rip(a6)) */
    jsr bv_alvv(pc)
/* QL:         exg     a1,a3           swap ri and old descriptor pointers */
    exg a3,a1
/* QL:         jsr     mm_mrtor(pc)    copy shortened descriptor to new area */
    jsr mm_mrtor(pc)
/* QL:         exg     a1,a3           swap back ri and old descriptor pointers */
    exg a3,a1
/* QL:         exg     a0,a4           restore a0 and set a4 to new area pointer */
    exg a4,a0
/* QL:         sub.l   M94_bv_vvbas(a6),a4 prepare new offset */
    sub.l M94_bv_vvbas(a6),a4
/* QL: M94_ind_free */
M94_ind_free:
/* QL:         move.l  a4,-4(a6,a5.l)  fill in changed vv offset */
    move.l a4,(-4)(a6,a5.l)
/* QL:         moveq   #M94_d.adim,d1 */
    moveq #M94_d.adim,d1
/* QL:         mulu    d4,d1 */
    mulu d4,d1
/* QL:         addq.l  #M94_d.base,d1      total length of original descriptor */
    addq.l #M94_d.base,d1
/* QL:         exg     a0,a3 */
    exg a3,a0
/* QL:         jsr     bv_frvv(pc)     free old descriptor */
    jsr bv_frvv(pc)
/* QL:         exg     a0,a3 */
    exg a3,a0
/* QL: M94_okrts */
M94_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL:         end */
