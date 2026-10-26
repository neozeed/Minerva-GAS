/* ROM section ib_golin */
.balign 2,0
/* QL: * If M147_bv_sing is set: */
/* QL: * d0 -  o- 0 */
/* QL: * a4 -  o- base of token list */
/* QL: * ccr-  o- zero */
/* QL: * If M147_bv_sing is clear: */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- M147_bv_lengt (applies to prior line, zero if a4=pfbas). msw preserved. */
/* QL: * d2 -  o- M147_bv_pfp */
/* QL: * d4 -ip - line number to go to */
/* QL: * a4 -i o- token within a line / M147_found line length change or end of program */
/* QL: * ccr-  o- zero if a4<d2, otherwise a stop is set up and ccr is positive */
/* QL: ib_golin */
ib_golin:
/* QL:         tst.b   M147_bv_sing(a6)     is this a command line other than goto? */
    tst.b M147_bv_sing(a6)
/* QL:         beq.s   M147_getlf */
    beq.s M147_getlf
/* QL:         move.l  M147_bv_tkbas(a6),a4 yes, so go to token base and return ok */
    move.l M147_bv_tkbas(a6),a4
/* QL: M147_ok_rts */
M147_ok_rts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M147_findlf */
M147_findlf:
/* QL:         bsr.s   ib_nxtk         get next token */
    bsr.s ib_nxtk
/* QL: M147_getlf */
M147_getlf:
/* QL:         cmp.w   #M147_w.eol,0(a6,a4.l) are we at end of line? */
    cmp.w #M147_w.eol,0(a6,a4.l)
/* QL:         bne.s   M147_findlf          not yet, so keep looking */
    bne.s M147_findlf
/* QL:         addq.l  #2,a4           space over lf */
    addq.l #2,a4
/* QL:         move.w  M147_bv_lengt(a6),d1 pick up this line length */
    move.w M147_bv_lengt(a6),d1
/* QL:         bsr.s   M147_glin1           postion to requested line */
    bsr.s M147_glin1
/* QL:         subq.w  #2,d1           left as +2 by routine */
    subq.w #2,d1
/* QL:         move.w  d1,M147_bv_lengt(a6) store the prior line length */
    move.w d1,M147_bv_lengt(a6)
/* QL:         cmp.l   a4,d2 */
    cmp.l a4,d2
/* QL:         bge.s   M147_ok_rts */
    bge.s M147_ok_rts
/* QL:         jmp     ib_steof(pc)    returns ccr for > 0 */
    jmp ib_steof(pc)
/* QL: * Moves a4 to point at next token in program file, or token list. */
/* QL: * This now ignores the top 3 bits of a token, as a token should only ever be */
/* QL: * one of $8x or $fx, with $8f currently undefined, so far! */
/* QL: * d0 -  o- 1st byte of next token */
/* QL: * d1 -  o- 1st word of next token */
/* QL: * a4 -i o- offset to tokenised code, moved across current token to next token */
/* QL: ib_nxtk */
ib_nxtk:
/* QL:         moveq   #31,d1          lose all but 5 lsb's of token */
    moveq #31,d1
/* QL:         and.b   0(a6,a4.l),d1   get token type */
    and.b 0(a6,a4.l),d1
/* QL:         move.b  M147_toktab(pc,d1.w),d1 get no of bytes token comprises */
    move.b M147_toktab(pc,d1.w),d1
/* QL:         bpl.s   M147_add_tok         strings are different */
    bpl.s M147_add_tok
/* QL:         neg.b   d1              no of bytes to add to no of chars */
    neg.b d1
/* QL:         add.w   2(a6,a4.l),d1   add no of chars */
    add.w 2(a6,a4.l),d1
/* QL:         bclr    #0,d1           make it even */
    bclr #0,d1
/* QL: M147_add_tok */
M147_add_tok:
/* QL:         add.l   d1,a4           move pointer along correct number of bytes */
    add.l d1,a4
/* QL:         move.w  0(a6,a4.l),d1   next token (word) */
    move.w 0(a6,a4.l),d1
/* QL:         move.l  d1,d0 */
    move.l d1,d0
/* QL:         lsr.w   #8,d0           next token (byte) */
    lsr.w #8,d0
/* QL:         rts */
    rts 
/* QL: M147_toktab  dc.b    2,2,4,4,2,2,2,4,4,2,4,-5,-5,4,2,2 $80..$8f */
M147_toktab:
M147_dc_anchor_1062:
.byte (2)&255
.byte (2)&255
.byte (4)&255
.byte (4)&255
.byte (2)&255
.byte (2)&255
.byte (2)&255
.byte (4)&255
.byte (4)&255
.byte (2)&255
.byte (4)&255
.byte ((-5))&255
.byte ((-5))&255
.byte (4)&255
.byte (2)&255
.byte (2)&255
/* QL:         dcb.b   16,6 $f0..$ff */
.rept 16
.byte 6
.endr
/* QL: * Entry to find a line starting from scratch. */
/* QL: * Same as later entry, but a4/d1 set up for going from start of program. */
/* QL: ib_glin0 */
ib_glin0:
/* QL:         move.l  M147_bv_pfbas(a6),a4 */
    move.l M147_bv_pfbas(a6),a4
/* QL:         clr.w   d1 */
    clr.w d1
/* QL: M147_glin1 */
M147_glin1:
/* QL:         addq.w  #2,d1 */
    addq.w #2,d1
/* QL: * Enter here with a4 at any PF line length change word or at top of program. */
/* QL: * The length in d1 must apply to the whole prior line and be two if at pfbas. */
/* QL: * The case of an empty program file will work fine, leaving d0=a4=d2 and d1=2. */
/* QL: * We go for a complex, but fast technique. Once we have established whether we */
/* QL: * are to go forward or back through the program, we try to insert an extra */
/* QL: * pre-word at the end we are headed for. If there is space for it, the scan */
/* QL: * loop gets down to 56 cycles. (This may be forced up to 60 by the QLs wait */
/* QL: * states). If no spare word is available (which we try hard elsewhere to ensure */
/* QL: * is not the case), we have to settle for an alternative loop of 68 cycles. */
/* QL: * This scan loop is used to move across increasing sets of lines, without */
/* QL: * checking the line numbers. Only after each progressively larger jump, do we */
/* QL: * check the line number. When we have got far enough, we are left with a known */
/* QL: * sequence of lines where the first is definately not the line to go to and the */
/* QL: * last is maybe the one (or is the top of the program). We then scan that final */
/* QL: * section to get the proper position. */
/* QL: * By calculating the performance of various choices of how to arrange the */
/* QL: * skip amount, the best algorithm turns out to be to just increment the skip */
/* QL: * by one each time. This gives reasonable performance for short overall travels */
/* QL: * and finishes up averaging 67% of the speed of the plain search over all */
/* QL: * movements from 1 to 1000 lines. */
/* QL: * Changing the step by a factor (e.g. 9/8) each time is definately NOT any */
/* QL: * better... its average performance is worse over all ranges. */
/* QL: * Also, attemping binary chop searches is pretty naff. */
/* QL: * What would be marvellous would be to have the program file sensibly organised */
/* QL: * with the line numbers and length change words held in a totally separate */
/* QL: * block, then we could really whizz to lines. The timing would be of the order */
/* QL: * of the log of the number of lines, instead of directly proportional to the */
/* QL: * distance travelled! Mind you, saying that doesn't make it too bad, maybe... */
/* QL: * if most jumps are short? */
/* QL: * Another good idea would be if an extra word at the end was a length change */
/* QL: * back to zero, so we could scan from either end. */
/* QL: * A thought: can the current length change words be operated on to make the */
/* QL: * same code execute in both directions? To go forward, we do add.w d1,a4 and */
/* QL: * add.w 0(a6,a4.l),d1 but to go back, if we first did add.w d1,a4 and neg.w d1, */
/* QL: * we would be steaming with the same code. Maybe if the code were more */
/* QL: * complex it would be worth considering. */
/* QL: * d0 -  o- pfbas */
/* QL: * d1 -i o- prior line length including pre-word (2 iff a4=pfbas) msw preserved */
/* QL: * d2 -  o- pfp */
/* QL: * d4 -ip - lno to look for, end at equal or first higher line */
/* QL: * a4 -i o- program file pointer to start of line (may be pfp if none) */
/* QL: * ccr-  o- result of final a4,d2 comparision, i.e. "le" if at end of program */
/* QL: ib_glin1 */
ib_glin1:
/* QL:         move.l  d3,-(sp)        we need one register extra */
    move.l d3,-(sp)
/* QL:         moveq   #0,d3           use it as skip counter */
    moveq #0,d3
/* QL:         bsr.s   M147_pickup          get fpbas/pfp and compare a4 with pfp */
    bsr.s M147_pickup
/* QL:         ble.s   M147_subtop          if at end of program, must see about going up */
    ble.s M147_subtop
/* QL:         cmp.w   4(a6,a4.l),d4   check the line we've started on */
    cmp.w 4(a6,a4.l),d4
/* QL:         bls.s   M147_subbing         if desired <= actual, need to look earlier */
    bls.s M147_subbing
/* QL:         cmp.l   M147_bv_pfp+4(a6),d2 is there a word spare at end? */
    cmp.l (M147_bv_pfp+4)(a6),d2
/* QL:         beq.s   M147_slowfwd         no, so we won't do our very fast scan */
    beq.s M147_slowfwd
/* QL:         move.w  #32767,0(a6,d2.l) set a pre-word that will block forward scan */
    move.w #32767,0(a6,d2.l)
/* QL:         ; we now go by dead reckoning, and can reload d0/d2 at the end */
/* QL: M147_fastfwd */
M147_fastfwd:
/* QL:         move.w  d3,d0 */
    move.w d3,d0
/* QL: M147_fflp */
M147_fflp:
/* QL:         add.w   0(a6,a4.l),d1   fastest skip lines */
    add.w 0(a6,a4.l),d1
/* QL:         add.w   d1,a4 */
    add.w d1,a4
/* QL:         dbmi    d0,M147_fflp */
    dbmi d0,M147_fflp
/* QL:         bmi.s   M147_ffsent          if -ve line length, we hit the sentinel */
    bmi.s M147_ffsent
/* QL:         cmp.l   d2,a4 */
    cmp.l d2,a4
/* QL:         bge.s   M147_backlp          we may be at top, so don't compare */
    bge.s M147_backlp
/* QL:         addq.w  #1,d3           skip more next time */
    addq.w #1,d3
/* QL:         cmp.w   4(a6,a4.l),d4 */
    cmp.w 4(a6,a4.l),d4
/* QL:         bhi.s   M147_fastfwd         if still not there, skip further */
    bhi.s M147_fastfwd
/* QL: M147_backtest */
M147_backtest:
/* QL:         beq.s   M147_found           if equal, we can skip out */
    beq.s M147_found
/* QL: * Now, we have skipped lines forward and M147_found a line number greater than the */
/* QL: * request. Now look back, recalling that we have definately got an earlier line */
/* QL: * with a line number that is definately less than the request */
/* QL: M147_backlp */
M147_backlp:
/* QL:         sub.w   d1,a4 */
    sub.w d1,a4
/* QL:         sub.w   0(a6,a4.l),d1 */
    sub.w 0(a6,a4.l),d1
/* QL:         cmp.w   4(a6,a4.l),d4 */
    cmp.w 4(a6,a4.l),d4
/* QL:         blo.s   M147_backlp */
    blo.s M147_backlp
/* QL:         beq.s   M147_found           actually on the right line, so get out */
    beq.s M147_found
/* QL: M147_bump */
M147_bump:
/* QL:         add.w   0(a6,a4.l),d1   we went one too far */
    add.w 0(a6,a4.l),d1
/* QL:         add.w   d1,a4 */
    add.w d1,a4
/* QL: M147_found */
M147_found:
/* QL:         move.l  (sp)+,d3        restore saved register */
    move.l (sp)+,d3
/* QL: M147_pickup */
M147_pickup:
/* QL:         assert  M147_bv_pfbas,M147_bv_pfp-4 */
/* original assertion: M147_bv_pfbas,M147_bv_pfp-4 */
/* QL:         movem.l M147_bv_pfbas(a6),d0/d2 get ptrs to bottom and top of program text */
    movem.l M147_bv_pfbas(a6),d0/d2
/* QL:         cmp.l   a4,d2           leave ccr as 'le' if at end of program */
    cmp.l a4,d2
/* QL:         rts */
    rts 
/* QL: * Overran and hit the top sentinel, must go back over that first */
/* QL: M147_ffsent */
M147_ffsent:
/* QL:         sub.w   d1,a4           bring a4 back to pfp */
    sub.w d1,a4
/* QL:         sub.w   #32767,d1       we know what our sentinel was */
    sub.w #32767,d1
/* QL:         bra.s   M147_backlp          do backward scan */
    bra.s M147_backlp
/* QL: M147_slowfwd */
M147_slowfwd:
/* QL:         move.w  d3,d0 */
    move.w d3,d0
/* QL: M147_sflp */
M147_sflp:
/* QL:         add.w   0(a6,a4.l),d1 */
    add.w 0(a6,a4.l),d1
/* QL:         add.w   d1,a4 */
    add.w d1,a4
/* QL:         cmp.l   d2,a4 */
    cmp.l d2,a4
/* QL:         dbge    d0,M147_sflp */
    dbge d0,M147_sflp
/* QL:         bge.s   M147_backlp          we may be at top, so don't compare */
    bge.s M147_backlp
/* QL:         addq.w  #1,d3           skipping more next time */
    addq.w #1,d3
/* QL:         cmp.w   4(a6,a4.l),d4 */
    cmp.w 4(a6,a4.l),d4
/* QL:         bhi.s   M147_slowfwd         if still not there, skip further */
    bhi.s M147_slowfwd
/* QL:         bra.s   M147_backtest        go start backward scan, unless we're there */
    bra.s M147_backtest
/* QL: M147_subtop */
M147_subtop:
/* QL:         cmp.l   d0,d2 */
    cmp.l d0,d2
/* QL:         beq.s   M147_found           get out on empty file, as we don't like it much */
    beq.s M147_found
/* QL:         sub.w   d1,a4 */
    sub.w d1,a4
/* QL:         sub.w   0(a6,a4.l),d1   back up over last line in program */
    sub.w 0(a6,a4.l),d1
/* QL:         cmp.w   4(a6,a4.l),d4   look at it */
    cmp.w 4(a6,a4.l),d4
/* QL:         bhi.s   M147_bump            go out if the top is where to be */
    bhi.s M147_bump
/* QL: M147_subbing */
M147_subbing:
/* QL:         beq.s   M147_found           what luck, we're at the right line already! */
    beq.s M147_found
/* QL:         cmp.l   d0,a4           are we actually at the start */
    cmp.l d0,a4
/* QL:         ble.s   M147_found           yes, don't bother ourselves, this is it */
    ble.s M147_found
/* QL:         cmp.l   M147_bv_pfbas-4(a6),d0 is there a word spare at start */
    cmp.l (M147_bv_pfbas-4)(a6),d0
/* QL:         beq.s   M147_slowback        no, can't do a fast backward search */
    beq.s M147_slowback
/* QL:         move.w  #8,-2(a6,d0.l)  set a pre-word that'll block backward scan */
    move.w #8,(-2)(a6,d0.l)
/* QL: M147_fastback */
M147_fastback:
/* QL:         move.w  d3,d2 */
    move.w d3,d2
/* QL: M147_fblp */
M147_fblp:
/* QL:         sub.w   d1,a4 */
    sub.w d1,a4
/* QL:         sub.w   0(a6,a4.l),d1 */
    sub.w 0(a6,a4.l),d1
/* QL:         dbmi    d2,M147_fblp */
    dbmi d2,M147_fblp
/* QL:         bmi.s   M147_fbsent          we ran off into the sentinel */
    bmi.s M147_fbsent
/* QL:         addq.w  #1,d3           skip more next time */
    addq.w #1,d3
/* QL:         cmp.w   4(a6,a4.l),d4 */
    cmp.w 4(a6,a4.l),d4
/* QL:         blo.s   M147_fastback        if not there yet, increase backward steps */
    blo.s M147_fastback
/* QL: M147_fwdtest */
M147_fwdtest:
/* QL:         beq.s   M147_found   */
    beq.s M147_found
/* QL: * Now to scan forward */
/* QL: M147_fwdlp */
M147_fwdlp:
/* QL:         add.w   0(a6,a4.l),d1 */
    add.w 0(a6,a4.l),d1
/* QL:         add.w   d1,a4 */
    add.w d1,a4
/* QL: M147_fwdcmp */
M147_fwdcmp:
/* QL:         cmp.w   4(a6,a4.l),d4 */
    cmp.w 4(a6,a4.l),d4
/* QL:         bhi.s   M147_fwdlp           go forward until we get the right place */
    bhi.s M147_fwdlp
/* QL:         bra.s   M147_found   */
    bra.s M147_found
/* QL: M147_fbsent */
M147_fbsent:
/* QL:         addq.w  #8,d1           we know what our sentinel was (pf not corrupt?) */
    addq.w #8,d1
/* QL:         add.w   d1,a4           now at pfbas */
    add.w d1,a4
/* QL:         bra.s   M147_fwdcmp          go forward from here */
    bra.s M147_fwdcmp
/* QL: M147_slowback */
M147_slowback:
/* QL:         move.w  d3,d2 */
    move.w d3,d2
/* QL: M147_sblp */
M147_sblp:
/* QL:         sub.w   d1,a4 */
    sub.w d1,a4
/* QL:         sub.w   0(a6,a4.l),d1 */
    sub.w 0(a6,a4.l),d1
/* QL:         cmp.l   d0,a4 */
    cmp.l d0,a4
/* QL:         dble    d2,M147_sblp */
    dble d2,M147_sblp
/* QL:         ble.s   M147_fwdcmp          we ran onto the front, so go to fwd compare */
    ble.s M147_fwdcmp
/* QL:         addq.w  #1,d3           increase skip next time */
    addq.w #1,d3
/* QL:         cmp.w   4(a6,a4.l),d4 */
    cmp.w 4(a6,a4.l),d4
/* QL:         blo.s   M147_slowback        increase backward steps */
    blo.s M147_slowback
/* QL:         bra.s   M147_fwdtest */
    bra.s M147_fwdtest
/* QL:         end */
