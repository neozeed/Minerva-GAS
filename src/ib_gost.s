/* ROM section ib_gost */
.balign 2,0
/* QL: * d0 -  o- 0 */
/* QL: * d4 -ip - statement no on this line to go to */
/* QL: * a4 -i o- program file (may not move if already there) */
/* QL: * ccr always z */
/* QL: M151_goeos */
M151_goeos:
/* QL:         addq.l  #2,a4           skip over colon etc */
    addq.l #2,a4
/* QL:         addq.b  #1,M151_bv_stmnt(a6) and increment satement number */
    addq.b #1,M151_bv_stmnt(a6)
/* QL: ib_gost */
ib_gost:
/* QL:         cmp.b   M151_bv_stmnt(a6),d4 are we there? */
    cmp.b M151_bv_stmnt(a6),d4
/* QL:         ble.s   M151_okrts */
    ble.s M151_okrts
/* QL:         bsr.s   ib_eos          find the end of current statement */
    bsr.s ib_eos
/* QL:         bge.s   M151_goeos           not yet */
    bge.s M151_goeos
/* QL:         bra.s   M151_okrts           end of line */
    bra.s M151_okrts
/* QL: * a4 -i o- pf pointer - doesn't change iff already at eol */
/* QL: * d0 - lo- 0 if statement is not on a new line, 1 new pf line, -1 end of single */
/* QL: * ccr z if there is a next statement, +ve if off end of pf, -ve end of single */
/* QL: * (d1.l was zeroed only on a valid new line being started - preserved now) */
/* QL: ib_nxst */
ib_nxst:
/* QL:         bsr.s   ib_eos          get end of this statement */
    bsr.s ib_eos
/* QL:         blt.s   M151_atlf            found line feed */
    blt.s M151_atlf
/* QL:         addq.l  #2,a4           skip colon/then/else */
    addq.l #2,a4
/* QL:         addq.b  #1,M151_bv_stmnt(a6) increment statement on line */
    addq.b #1,M151_bv_stmnt(a6)
/* QL: M151_okrts */
M151_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M151_atlf */
M151_atlf:
/* QL:         tst.b   M151_bv_sing(a6) */
    tst.b M151_bv_sing(a6)
/* QL:         bne.s   M151_rts0 */
    bne.s M151_rts0
/* QL:         addq.l  #8,a4           skip line feed, len change and line number */
    addq.l #8,a4
/* QL:         cmp.l   M151_bv_pfp(a6),a4   gone past end of file? */
    cmp.l M151_bv_pfp(a6),a4
/* QL:         bgt.l   ib_steof        returns >0 */
    bgt.w ib_steof
/* QL:         move.w  -6(a6,a4.l),d0  read change to current length */
    move.w (-6)(a6,a4.l),d0
/* QL:         add.w   d0,M151_bv_lengt(a6) change it */
    add.w d0,M151_bv_lengt(a6)
/* QL:         move.w  -2(a6,a4.l),M151_bv_linum(a6) update line number */
    move.w (-2)(a6,a4.l),M151_bv_linum(a6)
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL:         move.b  d0,M151_bv_stmnt(a6) and initialise statement on line */
    move.b d0,M151_bv_stmnt(a6)
/* QL: *       moveq   #0,d1           dunno what this was for? preserve d1 now */
/* QL:         cmp.b   d0,d0 */
    cmp.b d0,d0
/* QL: M151_rts0 */
M151_rts0:
/* QL:         rts */
    rts 
/* QL: * Moves a4, the pointer to the program file while basic is running, to the */
/* QL: * end of the current statement. Very critical to speed of superbasic. */
/* QL: * a4 -i o- pointer to program file (may not move if already at eol) */
/* QL: * d0 -  o- -1 if end of line found */
/* QL: *           0 if colon found */
/* QL: *           1 if then found */
/* QL: *           2 if else found */
/* QL: * Was ---> d1 - l - token <--- now d1 is preserved ... a problem? */
/* QL: * Note. The test for fp below could be changed to something like: */
/* QL: *       moveq   #31,d0  or      moveq   #-32,d0 */
/* QL: *       and.b   ...             or.b    ... */
/* QL: * with the branch left out, and 16 bytes more in the jump table. */
/* QL: * There is a trade off though, as there are lots of fp's in a program, and the */
/* QL: * way it is means they save on one branch taken, as opposed to the table */
/* QL: * lookup and jump, versus the cost to the rest being just an un-taken branch. */
/* QL: * A quick look at timing means that this code should be changed if programs */
/* QL: * tend to have a ratio of fp:other less than 4:9, i.e. less than 4/13th's of */
/* QL: * symbols scanned are fp. Unfortunately, this is not wildly off the sort of */
/* QL: * ratio one gets. In the absence of heavy benchmarking the code stays as it is. */
/* QL: * Update! as I have now included the possibility of tokenised short and long */
/* QL: * integers, the above no longer applies, so the code has been changed! */
/* QL: * We now ignore the top 3 bits of a token, as we should never find a token with */
/* QL: * any value other than $8x or $fx, and even $8f is really undefined (so far!).  */
/* QL: * N.B. jumps to M151_sym and M151_key repectively have M151_b.colon and M151_b.else in d0 */
/* QL: M151_sym */
M151_sym:
/* QL: M151_x       equ     M151_sym-M151_b.colon */
.equ M151_x,(M151_sym-M151_b.colon)
/* QL:         sub.b   1(a6,a4.l),d0 */
    sub.b 1(a6,a4.l),d0
/* QL:         beq.s   M151_col */
    beq.s M151_col
/* QL:         addq.b  #M151_b.eol-M151_b.colon,d0 */
.word 20480|((((M151_b.eol-M151_b.colon))&7)<<9)
/* QL:         bne.s   M151_wrd */
    bne.s M151_wrd
/* QL:         subq.l  #2,d0           line feed -> -1 */
    subq.l #2,d0
/* QL: M151_thn */
M151_thn:
/* QL:         subq.l  #1,d0           then -> 1 */
    subq.l #1,d0
/* QL: M151_els */
M151_els:
/* QL:         addq.l  #2,d0           else -> 2 */
    addq.l #2,d0
/* QL: M151_col */
M151_col:
/* QL:         rts                     : -> 0 */
    rts 
/* QL: M151_key */
M151_key:
/* QL:         assert  M151_key-M151_b.else-M151_x,0 */
/* original assertion: M151_key-M151_b.else-M151_x,0 */
/* QL:         sub.b   1(a6,a4.l),d0 */
    sub.b 1(a6,a4.l),d0
/* QL:         beq.s   M151_els */
    beq.s M151_els
/* QL:         addq.b  #M151_b.then-M151_b.else,d0 */
.word 20480|((((M151_b.then-M151_b.else))&7)<<9)
/* QL:         beq.s   M151_thn */
    beq.s M151_thn
/* QL: M151_wrd */
M151_wrd:
/* QL:         addq.l  #2,a4 */
    addq.l #2,a4
/* QL: ib_eos */
ib_eos:
/* QL:         moveq   #31,d0 */
    moveq #31,d0
/* QL:         and.b   0(a6,a4.l),d0   get token type */
    and.b 0(a6,a4.l),d0
/* QL:         move.b  M151_tokv(pc,d0.w),d0 */
    move.b M151_tokv(pc,d0.w),d0
/* QL:         jmp     M151_x(pc,d0.w) */
.word 0x4efb
.word 0|((M151_x-.)&255)
/* QL: M151_flt */
M151_flt:
/* QL:         addq.l  #6,a4 */
    addq.l #6,a4
/* QL:         bra.s   ib_eos */
    bra.s ib_eos
/* QL: M151_lng */
M151_lng:
/* QL:         addq.l  #4,a4 */
    addq.l #4,a4
/* QL:         bra.s   ib_eos */
    bra.s ib_eos
/* QL: M151_txt */
M151_txt:
/* QL:         moveq   #2+2+1,d0       token word, char count and one to round up */
    moveq #((2+2)+1),d0
/* QL:         add.w   2(a6,a4.l),d0   add length */
    add.w 2(a6,a4.l),d0
/* QL:         bclr    #0,d0           round down */
    bclr #0,d0
/* QL:         add.w   d0,a4           (M151_txt should not be > 32767-6*2, think about it) */
    add.w d0,a4
/* QL:         bra.s   ib_eos          enter loop */
    bra.s ib_eos
/* QL: M151_tokv */
M151_tokv:
/* QL:         dc.b    M151_wrd-M151_x,M151_key-M151_x,M151_lng-M151_x,M151_lng-M151_x,M151_sym-M151_x,M151_wrd-M151_x,M151_wrd-M151_x,M151_lng-M151_x */
M151_dc_anchor_1150:
.byte ((M151_wrd-M151_x))&255
.byte ((M151_key-M151_x))&255
.byte ((M151_lng-M151_x))&255
.byte ((M151_lng-M151_x))&255
.byte ((M151_sym-M151_x))&255
.byte ((M151_wrd-M151_x))&255
.byte ((M151_wrd-M151_x))&255
.byte ((M151_lng-M151_x))&255
/* QL:         dc.b    M151_lng-M151_x,M151_wrd-M151_x,M151_lng-M151_x,M151_txt-M151_x,M151_txt-M151_x,M151_lng-M151_x,M151_wrd-M151_x,M151_wrd-M151_x */
M151_dc_anchor_1160:
.byte ((M151_lng-M151_x))&255
.byte ((M151_wrd-M151_x))&255
.byte ((M151_lng-M151_x))&255
.byte ((M151_txt-M151_x))&255
.byte ((M151_txt-M151_x))&255
.byte ((M151_lng-M151_x))&255
.byte ((M151_wrd-M151_x))&255
.byte ((M151_wrd-M151_x))&255
/* QL:         dcb.b   16,M151_flt-M151_x */
.rept 16
.byte (M151_flt-M151_x)
.endr
/* QL:         end */
