/* ROM section pf_nwlin */
.balign 2,0
/* QL: * Return is immediate for no line number (just a1 smashed) */
/* QL: * Return is +2 for line number ok */
/* QL: * d0 -  o- if lno present, +ve/0/-ve for line inserted/replaced/deleted */
/* QL: * d2 -  o- line number */
/* QL: * d5 -  o- iff 0.l, no change to program (delete non-exist or modify identical) */
/* QL: * d1/d6/a0-a2 destroyed */
/* QL: * Line replaced includes blank line with non-existing lno. */
/* QL: pf_nwlin */
pf_nwlin:
/* QL:         move.l  M137_bv_tkbas(a6),a1 start of new line */
    move.l M137_bv_tkbas(a6),a1
/* QL:         cmp.b   #M137_b.lno,0(a6,a1.l) is there a line number? */
    cmp.b #(M137_b.lno&255),0(a6,a1.l)
/* QL:         beq.s   M137_lnopres         yes, do edit, otherwise direct return */
    beq.s M137_lnopres
/* QL:         rts */
    rts 
/* QL: regon   reg     d1-d4/a4 */
/* QL: regoff  reg     d0/d2-d4/a4 */
/* QL: M137_lnopres */
M137_lnopres:
/* QL:         addq.l  #2,(sp)         set skip return, as we're editing */
    addq.l #2,(sp)
/* QL:         move.w  2(a6,a1.l),d2   get the line number */
    move.w 2(a6,a1.l),d2
/* QL:         move.l  M137_bv_tkp(a6),d3   end of new line */
    move.l M137_bv_tkp(a6),d3
/* QL:         sub.l   a1,d3           length of new line */
    sub.l a1,d3
/* QL:         subq.w  #6,d3           does user want to wipe out this line? */
    subq.w #6,d3
/* QL:         ble.s   M137_lenzero         yes, leave length as zero (or force it) */
    ble.s M137_lenzero
/* QL:         addq.w  #8,d3           otherwise, allow for pre-word */
    addq.w #8,d3
/* QL:         bpl.s   M137_lenok           backstop check on line length */
    bpl.s M137_lenok
/* QL: M137_lenzero */
M137_lenzero:
/* QL:         moveq   #0,d3           force it into a deletion */
    moveq #0,d3
/* QL: M137_lenok */
M137_lenok:
/* QL: * Doing this should protect against a lunatic bad file line that reads */
/* QL: * something like "1data 1,1,1,1....." with about 16000 ones, which will have */
/* QL: * been tokenised up to 2 or 4 times the line length! */
/* QL: * This is not perfect, but does offer a modicum of protection. */
/* QL:         moveq   #0,d1           preset for flag and msw zero */
    moveq #0,d1
/* QL:         movem.l regon,-(sp)     save some registers, flag at top of stack */
    movem.l d1-d4/a4,-(sp)
/* QL:         moveq   #0,d5           negated length of line being replaced/deleted */
    moveq #0,d5
/* QL:         move.l  d5,a2           adjustment for possible subsequent pre-word */
    move.l d5,a2
/* QL:         move.w  d2,d4           set line to search for */
    move.w d2,d4
/* QL:         jsr     ib_glin0(pc)    position to line (msw d1 was zero) */
    jsr ib_glin0(pc)
/* QL:         move.l  d0,a3           save pfbas for later */
    move.l d0,a3
/* QL:         exg     d2,d4           hold pfp in d4 and set d2 back to lno */
    exg d2,d4
/* QL:         exg     a1,a4           make a1 top of unaffected prog, put tkbas in a4 */
    exg a4,a1
/* QL:         add.l   d3,a4           move up to tkp plus two if insert */
    add.l d3,a4
/* QL:         ble.s   M137_oldrdy          ready now if we're at the top of the file */
    ble.s M137_oldrdy
/* QL:         cmp.w   4(a6,a1.l),d2   check the line number we've found */
    cmp.w 4(a6,a1.l),d2
/* QL:         bne.s   M137_oldrdy          if we have no match, we'll make it insert */
    bne.s M137_oldrdy
/* QL:         subq.l  #1,(sp)         adjust flag on top of stack to delete */
    subq.l #1,(sp)
/* QL:         move.w  d2,d6           whdel given d2=d6, and destroys just d0/a0 */
    move.w d2,d6
/* QL:         jsr     ib_whdel(pc)    tell when handler line is changing */
    jsr ib_whdel(pc)
/* QL:         move.w  0(a6,a1.l),a2   get pre-word, may be adjust for next pre-word */
    move.w 0(a6,a1.l),a2
/* QL:         sub.l   d1,d5 */
    sub.l d1,d5
/* QL:         sub.l   a2,d5           negated disappearing line size */
    sub.l a2,d5
/* QL:         sub.w   d5,a1           step on to next, source of rest of prog */
    sub.w d5,a1
/* QL: M137_oldrdy */
M137_oldrdy:
/* QL:         move.w  d1,d6           hold onto prior line size */
    move.w d1,d6
/* QL:         move.l  M137_bv_pfp+4(a6),d0 get next area address */
    move.l (M137_bv_pfp+4)(a6),d0
/* QL:         sub.l   d4,d0           space available above pfp */
    sub.l d4,d0
/* QL:         sub.l   a1,d4           size of program above affected line */
    sub.l a1,d4
/* QL:         move.l  a1,a0           destination may be same as source! */
    move.l a1,a0
/* QL:         add.l   d3,d5           prog file size change */
    add.l d3,d5
/* QL:         beq.s   M137_nomove          no size change needed, so no move at all! */
    beq.s M137_nomove
/* QL: * d3 length of line to be inserted, including a pre-word that isn't there! */
/* QL: * d4 size of program above affected line */
/* QL: * d5 -ve drop space, +ve add space */
/* QL: * d6 length of line before source area, including pre-word (2=none) */
/* QL: * a0/a1 point at pre-word of first line to be moved (or even = M137_bv_pfp) */
/* QL: * a2 basic adjust for next pre-word (as if for a delete, so far) */
/* QL: * a3 pfbas */
/* QL: * a4 tkp, +2 if new line present */
/* QL:         add.l   d5,a0           actual destination */
    add.l d5,a0
/* QL:         cmp.l   d5,d0           what do we want? */
    cmp.l d5,d0
/* QL:         bgt.s   M137_spcok           always try to keep one extra word (fast golin) */
    bgt.s M137_spcok
/* QL:         move.l  a0,d1           copy new end of line address */
    move.l a0,d1
/* QL:         sub.l   a3,d1           space up to and including new line */
    sub.l a3,d1
/* QL:         asr.l   #4,d1           6.25% of that */
    asr.l #4,d1
/* QL:         addx.l  d5,d1           add in essential space, rounding up halves */
    addx.l d5,d1
/* QL: * We always get d1>d5, as even the very first line must be at least ten bytes. */
/* QL:         jsr     bv_chpfx(pc)    get extra program file space */
    jsr bv_chpfx(pc)
/* QL: M137_spcok */
M137_spcok:
/* QL:         move.l  d4,d1           program size above affected area */
    move.l d4,d1
/* QL:         beq.s   M137_modpfp          ahah! nothing to move */
    beq.s M137_modpfp
/* QL: * As we are going to move some program, there is obviously a pre-word there. */
/* QL: * We can now update it to its correct value. */
/* QL: * What it has is a "this-prior" value, and we have either changed its prior */
/* QL: * line length with a modify, or we have inserted a totally new line. */
/* QL:         move.w  d3,d0           do we have a new line?  */
    move.w d3,d0
/* QL:         beq.s   M137_doadjust        if not, the adjustment is ready */
    beq.s M137_doadjust
/* QL:         sub.w   d6,d0           not the overall prior, it's the new line */
    sub.w d6,d0
/* QL: M137_doadjust */
M137_doadjust:
/* QL:         sub.w   a2,d0           incorporate the matched pre-word, if any */
    sub.w a2,d0
/* QL:         sub.w   d0,0(a6,a1.l)   adjust the pre-word we're about to move */
    sub.w d0,0(a6,a1.l)
/* QL:         jsr     mm_mrtor(pc)    get the heavy mob to move the program */
    jsr mm_mrtor(pc)
/* QL: M137_modpfp */
M137_modpfp:
/* QL:         add.l   d5,M137_bv_pfp(a6)   adjust pfp to new value */
    add.l d5,M137_bv_pfp(a6)
/* QL:         add.l   d5,a1           adjust old source to be where it went */
    add.l d5,a1
/* QL:         bra.s   M137_qinsert         now go see if we have anything to insert */
    bra.s M137_qinsert
/* QL: * no movement required (d5.l=0), so we consider if the prog has changed */
/* QL: M137_nomove */
M137_nomove:
/* QL:         move.w  d3,d5           get new line size */
    move.w d3,d5
/* QL:         beq.s   M137_endline         deletion of non-extant line, so no change */
    beq.s M137_endline
/* QL: * as we are modifying an identical length line, we know a0=a1 */
/* QL:         move.l  a4,a2 */
    move.l a4,a2
/* QL: M137_cmplp */
M137_cmplp:
/* QL:         subq.l  #2,a0 */
    subq.l #2,a0
/* QL:         subq.l  #2,a2 */
    subq.l #2,a2
/* QL:         subq.w  #2,d5 */
    subq.w #2,d5
/* QL:         beq.s   M137_dupline         all was unchanged, so get out */
    beq.s M137_dupline
/* QL:         move.w  -2(a6,a2.l),d1 */
    move.w (-2)(a6,a2.l),d1
/* QL:         cmp.w   0(a6,a0.l),d1   compare word from token list to prog file */
    cmp.w 0(a6,a0.l),d1
/* QL:         beq.s   M137_cmplp */
    beq.s M137_cmplp
/* QL:         move.l  a1,a0           put back to top, copy some unchanged stuff */
    move.l a1,a0
/* QL: M137_qinsert */
M137_qinsert:
/* QL:         move.w  d3,d0           is there anything to put in? */
    move.w d3,d0
/* QL:         beq.s   M137_endline         no, we're completely done */
    beq.s M137_endline
/* QL:         sub.w   d6,d0           this will be the line's offset word */
    sub.w d6,d0
/* QL: M137_copylp */
M137_copylp:
/* QL:         subq.l  #2,a0           don't use mrtor, as this will be quicker */
    subq.l #2,a0
/* QL:         subq.l  #2,a4 */
    subq.l #2,a4
/* QL:         move.w  -2(a6,a4.l),0(a6,a0.l) copy word from token list to prog file */
    move.w (-2)(a6,a4.l),0(a6,a0.l)
/* QL:         subq.w  #2,d3           start of line - 2 yet? */
    subq.w #2,d3
/* QL:         bne.s   M137_copylp          no, keep copying */
    bne.s M137_copylp
/* QL: * Actually just copied rubbish word into offset, but it saves hassle... */
/* QL:         move.w  d0,0(a6,a0.l)   correct offset */
    move.w d0,0(a6,a0.l)
/* QL: M137_dupline */
M137_dupline:
/* QL:         addq.l  #1,(sp)         change flag to show modify or insert */
    addq.l #1,(sp)
/* QL: * d4 size of program above affected line */
/* QL: * d5 flag, 0.l if no change to program (delete non-exist or modify identical) */
/* QL: * d6 length of line before a0 */
/* QL: * a0 new line inserted/replaced or the one after a deleted line */
/* QL: * a1 program above affected area (same as a0 on a delete) */
/* QL: * a3 pfbas */
/* QL: M137_endline */
M137_endline:
/* QL:         tst.b   M137_bv_arrow(a6)    what do they want to do now? */
    tst.b M137_bv_arrow(a6)
/* QL:         beq.s   M137_nwlend          no change */
    beq.s M137_nwlend
/* QL:         bgt.s   M137_down_arr        move to next line */
    bgt.s M137_down_arr
/* QL:         cmp.l   a0,a3           are we at the start? */
    cmp.l a0,a3
/* QL:         bge.s   M137_dropoff         yes, get out */
    bge.s M137_dropoff
/* QL:         move.l  a0,a1 */
    move.l a0,a1
/* QL:         sub.w   d6,a1           point back to prior line */
    sub.w d6,a1
/* QL: M137_setedlin */
M137_setedlin:
/* QL:         move.w  4(a6,a1.l),M137_bv_edlin(a6) */
    move.w 4(a6,a1.l),M137_bv_edlin(a6)
/* QL: M137_setauto */
M137_setauto:
/* QL:         sne     M137_bv_auto(a6)     automatically edit the next line */
    sne M137_bv_auto(a6)
/* QL: M137_nwlend */
M137_nwlend:
/* QL:         st      M137_bv_edit(a6)     tell npass we've changed the program */
    st M137_bv_edit(a6)
/* QL:         movem.l (sp)+,regoff    restore registers */
    movem.l (sp)+,d0/d2-d4/a4
/* QL:         rts */
    rts 
/* QL: M137_down_arr */
M137_down_arr:
/* QL:         tst.l   d4              was there something up there */
    tst.l d4
/* QL:         bne.s   M137_setedlin        then we can edit it */
    bne.s M137_setedlin
/* QL: M137_dropoff */
M137_dropoff:
/* QL:         clr.w   M137_bv_edinc(a6)    make sure auto properly off */
    clr.w M137_bv_edinc(a6)
/* QL:         bra.s   M137_setauto */
    bra.s M137_setauto
/* QL:         vect4000 pf_nwlin */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ pf$nwlin,(pf_nwlin-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
