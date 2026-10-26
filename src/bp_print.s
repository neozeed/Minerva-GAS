/* ROM section bp_print */
.balign 2,0
/* QL: bp_print */
bp_print:
/* QL:         tas     d7              set flag to say M40_print in progress */
    tas d7
/* QL: bp_input */
bp_input:
/* QL:         jsr     bv_chri(pc)     make space on ri stack, in case of int/fp */
    jsr bv_chri(pc)
/* QL:         bra.s   M40_restart */
    bra.s M40_restart
/* QL: M40_steparg */
M40_steparg:
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL:         move.l  (sp)+,a5 */
    move.l (sp)+,a5
/* QL:         add.l   a3,a5 */
    add.l a3,a5
/* QL:         tst.l   d0              any errors? */
    tst.l d0
/* QL:         bne.s   M40_rts0            yes - get out now */
    bne.s M40_rts0
/* QL:         cmp.l   a3,a5           end of args yet? */
    cmp.l a3,a5
/* QL:         bgt.s   M40_getarg          no - pick up next one */
    bgt.s M40_getarg
/* QL: M40_rts0 */
M40_rts0:
/* QL:         rts */
    rts 
/* QL: M40_sendnwl */
M40_sendnwl:
/* QL:         bsr.s   M40_nwlinle         no args between channels, insert a newline */
    bsr.s M40_nwlinle
/* QL: M40_restart */
M40_restart:
/* QL:         jsr     bp_chan(pc)     get channel */
    jsr bp_chan(pc)
/* QL:         bne.s   M40_rts0 */
    bne.s M40_rts0
/* QL:         moveq   #-128,d4        no pending ! seps (bit0 = 0) */
    moveq #(-128),d4
/* QL:         and.b   d4,d7 */
    and.b d4,d7
/* QL:         blt.s   M40_chkemp          if M40_print, wade in */
    blt.s M40_chkemp
/* QL:         bsr.l   M40_chenq           check for readonly */
    bsr.w M40_chenq
/* QL: M40_chkemp */
M40_chkemp:
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL: M40_nwlinle */
M40_nwlinle:
/* QL:         ble.l   M40_nwlin           no args after channel, finish with newline */
    ble.w M40_nwlin
/* QL:         tst.b   1(a6,a3.l) */
    tst.b 1(a6,a3.l)
/* QL:         bmi.s   M40_sendnwl         imediately following #<chan>, so newline here */
    bmi.s M40_sendnwl
/* QL: M40_getarg */
M40_getarg:
/* QL:         moveq   #-16,d5         no to<null> if bits 15..8 are set */
    moveq #(-16),d5
/* QL:         and.b   1(a6,a3.l),d5   get hash and seps */
    and.b 1(a6,a3.l),d5
/* QL:         bmi.s   M40_restart         allow embedded channel selection! */
    bmi.s M40_restart
/* QL:         sub.l   a3,a5 */
    sub.l a3,a5
/* QL:         subq.l  #8,a5 */
    subq.l #8,a5
/* QL:         move.l  a5,-(sp)        save remaining arg count * 8, after this one */
    move.l a5,-(sp)
/* QL:         sub.l   M40_bv_chbas(a6),a2 ch is above vv, so we must be careful */
    sub.l M40_bv_chbas(a6),a2
/* QL:         jsr     bp_arset(pc)    set up in case we need an array */
    jsr bp_arset(pc)
/* QL:         add.l   M40_bv_chbas(a6),a2 put ch pointer back straight */
    add.l M40_bv_chbas(a6),a2
/* QL:         clr.w   d2              make null arg look like a zero length string */
    clr.w d2
/* QL:         move.w  #$ff0f,d3       set up mask for null arguments */
    move.w #0xff0f,d3
/* QL:         and.w   d3,0(a6,a3.l)   lose seps */
    and.w d3,0(a6,a3.l)
/* QL:         beq.s   M40_picked1         null argument */
    beq.s M40_picked1
/* QL:         move.b  d7,d1           check if M40_print ... */
    move.b d7,d1
/* QL:         or.b    2(a6,a3.l),d1   ... or an expression */
    or.b 2(a6,a3.l),d1
/* QL:         blt.s   M40_pr_elt          if so, no funny to<null> allowed */
    blt.s M40_pr_elt
/* QL:         cmp.b   #M40_b.septo<<4,d5  is it to? */
    cmp.b #((M40_b.septo<<4)&255),d5
/* QL:         bne.s   M40_pr_elt          no, forget this bit */
    bne.s M40_pr_elt
/* QL:         and.w   8(a6,a3.l),d3   is it followed by a null argument? */
    and.w 8(a6,a3.l),d3
/* QL:         bne.s   M40_tonullw         no, but have a look for no arguments left  */
    bne.s M40_tonullw
/* QL:         move.w  8(a6,a3.l),d5   leapfrog to next seps/type (syntax->hash=0) */
    move.w 8(a6,a3.l),d5
/* QL: M40_tonullw */
M40_tonullw:
/* QL:         tst.l   (sp)            was there another argument at all? */
    tst.l (sp)
/* QL:         bne.s   M40_pr_elt          yes, so this is all OK */
    bne.s M40_pr_elt
/* QL:         clr.w   d5              show as to<null> and no separator */
    clr.w d5
/* QL: M40_pr_elt */
M40_pr_elt:
/* QL:         jsr     bp_arind(pc)    if need be, index any array element */
    jsr bp_arind(pc)
/* QL:         clr.w   d2              set length to zero as a starter */
    clr.w d2
/* QL:         move.b  d7,d1 */
    move.b d7,d1
/* QL:         bgt.l   M40_input           M40_input from non-edit cannot edit */
    bgt.w M40_input
/* QL:         or.b    2(a6,a3.l),d1   check for M40_print or expression */
    or.b 2(a6,a3.l),d1
/* QL:         bmi.s   M40_pickup          either needs value to be M40_picked up */
    bmi.s M40_pickup
/* QL:         tst.w   d5 */
    tst.w d5
/* QL:         bmi.s   M40_picked          skip unless we had to<null> on editable M40_input */
    bmi.s M40_picked
/* QL: M40_pickup */
M40_pickup:
/* QL:         move.l  4(a6,a3.l),d1 */
    move.l 4(a6,a3.l),d1
/* QL:         bpl.s   M40_valok           if value defined, all is OK */
    bpl.s M40_valok
/* QL:         tst.b   d7 */
    tst.b d7
/* QL:         beq.s   M40_picked          if M40_input to undefined, start with null string */
    beq.s M40_picked
/* QL:         move.l  M40_bv_bfbas(a6),a1 */
    move.l M40_bv_bfbas(a6),a1
/* QL:         move.b  #'*',0(a6,a1.l) if M40_print, make undefined be "*" */
    move.b #(42&255),0(a6,a1.l)
/* QL:         addq.w  #1,d2 */
    addq.w #1,d2
/* QL: M40_picked1 */
M40_picked1:
/* QL:         bra.s   M40_picked */
    bra.s M40_picked
/* QL: M40_valok */
M40_valok:
/* QL:         move.l  M40_bv_vvbas(a6),a1 */
    move.l M40_bv_vvbas(a6),a1
/* QL:         cmp.b   #M40_t.arr,0(a6,a3.l) only 1 dim (sub-)string arrays are left */
    cmp.b #(M40_t.arr&255),0(a6,a3.l)
/* QL:         bne.s   M40_picksimp */
    bne.s M40_picksimp
/* QL:         add.l   a1,d1 */
    add.l a1,d1
/* QL:         movem.l 0(a6,d1.l),d1-d2 get vv offset and possible substring length */
    movem.l 0(a6,d1.l),d1-d2
/* QL: M40_picksimp */
M40_picksimp:
/* QL:         add.l   d1,a1 */
    add.l d1,a1
/* QL:         bsr.s   M40_chktype */
    bsr.s M40_chktype
/* QL:         bcs.s   M40_intfp */
    bcs.s M40_intfp
/* QL:         bpl.s   M40_picked          =0, substring, length is ready */
    bpl.s M40_picked
/* QL:         move.w  0(a6,a1.l),d2   =1, string, get length */
    move.w 0(a6,a1.l),d2
/* QL:         addq.l  #2,a1           step past length */
    addq.l #2,a1
/* QL:         bra.s   M40_picked          do it */
    bra.s M40_picked
/* QL: M40_intfp */
M40_intfp:
/* QL:         movem.w 0(a6,a1.l),d0-d2 get integer or fp */
    movem.w 0(a6,a1.l),d0-d2
/* QL:         move.l  M40_bv_bfbas(a6),a0 M40_where to put string */
    move.l M40_bv_bfbas(a6),a0
/* QL:         bmi.s   M40_itod */
    bmi.s M40_itod
/* QL:         move.l  M40_bv_rip(a6),a1   use ri stack for int, fp */
    move.l M40_bv_rip(a6),a1
/* QL:         subq.l  #6,a1           will be reset next time so extra no matter */
    subq.l #6,a1
/* QL:         movem.w d0-d2,0(a6,a1.l) put on ri stack */
    movem.w d0-d2,0(a6,a1.l)
/* QL:         jsr     cn_ftod(pc)     =2, fp, convert float to string */
    jsr cn_ftod(pc)
/* QL:         bra.s   M40_numlen          and write out a number */
    bra.s M40_numlen
/* QL: M40_itod */
M40_itod:
/* QL:         jsr     cn_0tod(pc)     =3, integer, convert integer to string */
    jsr cn_0tod(pc)
/* QL: M40_numlen */
M40_numlen:
/* QL:         move.l  M40_ch.id(a6,a2.l),a0 reload channel id */
    move.l M40_ch.id(a6,a2.l),a0
/* QL:         move.l  M40_bv_bfbas(a6),a1 start of ascii number */
    move.l M40_bv_bfbas(a6),a1
/* QL:         move.w  d1,d2           length of ascii number */
    move.w d1,d2
/* QL: M40_picked */
M40_picked:
/* QL:         lsr.b   #1,d4           can I M40_print arg straight away? */
    lsr.b #1,d4
/* QL:         bcc.s   M40_addlen          yes, so do it */
    bcc.s M40_addlen
/* QL:         move.l  a1,d3 */
    move.l a1,d3
/* QL:         bsr.l   M40_excl_do         action a pending ! operation */
    bsr.w M40_excl_do
/* QL:         move.l  d3,a1 */
    move.l d3,a1
/* QL: M40_addlen */
M40_addlen:
/* QL:         tst.w   0(a6,a3.l) */
    tst.w 0(a6,a3.l)
/* QL:         beq.s   M40_end_arh         null argument requires nothing more */
    beq.s M40_end_arh
/* QL:         tst.b   d7 */
    tst.b d7
/* QL:         blt.s   M40_print           if M40_print - go M40_print it */
    blt.s M40_print
/* QL:         tst.b   2(a6,a3.l) */
    tst.b 2(a6,a3.l)
/* QL:         bpl.s   M40_input           non-expression is to be M40_input */
    bpl.s M40_input
/* QL:         tst.b   d7 */
    tst.b d7
/* QL:         bgt.s   M40_end_arh         ignore expressions on non-edit M40_input */
    bgt.s M40_end_arh
/* QL: M40_print */
M40_print:
/* QL:         add.w   d2,M40_ch.chpos(a6,a2.l) update the running cursor */
    add.w d2,M40_ch.chpos(a6,a2.l)
/* QL:         bsr.l   M40_sstrg */
    bsr.w M40_sstrg
/* QL: M40_end_arh */
M40_end_arh:
/* QL:         bra.l   M40_end_arg */
    bra.w M40_end_arg
/* QL: M40_chktype */
M40_chktype:
/* QL:         move.b  1(a6,a3.l),d3 */
    move.b 1(a6,a3.l),d3
/* QL:         rol.b   #7,d3 */
    rol.b #7,d3
/* QL:         rts */
    rts 
/* QL: M40_input */
M40_input:
/* QL:         jsr     bp_rdchk(pc) */
    jsr bp_rdchk(pc)
/* QL:         bne.s   M40_end_arh         can't read into this, so get out */
    bne.s M40_end_arh
/* QL:         sub.l   M40_bv_chbas(a6),a2 keep ch entry as offset for now */
    sub.l M40_bv_chbas(a6),a2
/* QL:         move.w  d2,a4           save length and extend it to long */
    move.w d2,a4
/* QL:         move.l  a4,d1           space required in buffer */
    move.l a4,d1
/* QL:         bsr.s   M40_chktype         have we just done a number */
    bsr.s M40_chktype
/* QL:         bcs.s   M40_inpnow          yes - initial text is already in basic buffer */
    bcs.s M40_inpnow
/* QL:         sub.l   a3,a1           offset */
    sub.l a3,a1
/* QL:         sub.l   M40_bv_ntbas(a6),a3 offset */
    sub.l M40_bv_ntbas(a6),a3
/* QL:         jsr     bv_chbfx(pc)    ensure buffer has space for current string */
    jsr bv_chbfx(pc)
/* QL:         add.l   M40_bv_ntbas(a6),a3 proper */
    add.l M40_bv_ntbas(a6),a3
/* QL:         add.l   a3,a1           proper */
    add.l a3,a1
/* QL:         move.l  a4,d1           put back length */
    move.l a4,d1
/* QL:         move.l  a0,a4           save channel id */
    move.l a0,a4
/* QL:         move.l  M40_bv_bfbas(a6),a0 trundle it off to the basic bf area */
    move.l M40_bv_bfbas(a6),a0
/* QL:         jsr     mm_mrtor(pc)    using fast copy (purely 'cos of code saving) */
    jsr mm_mrtor(pc)
/* QL:         move.l  a4,a0           restore channel id */
    move.l a4,a0
/* QL: M40_inpnow */
M40_inpnow:
/* QL:         move.w  d1,d3           initial cursor at end of string */
    move.w d1,d3
/* QL:         add.l   M40_bv_bfbas(a6),d1 */
    add.l M40_bv_bfbas(a6),d1
/* QL:         move.l  d1,M40_bv_bfp(a6)   set buffer top */
    move.l d1,M40_bv_bfp(a6)
/* QL:         move.b  d7,d0           whether user can edit this M40_input */
    move.b d7,d0
/* QL:         sub.l   M40_bv_ntbas(a6),a3 keep arg offset */
    sub.l M40_bv_ntbas(a6),a3
/* QL:         bsr.l   bp_rdbuf        read a line */
    bsr.w bp_rdbuf
/* QL:         add.l   M40_bv_ntbas(a6),a3 reset arg */
    add.l M40_bv_ntbas(a6),a3
/* QL:         bne.s   M40_rderrd0 */
    bne.s M40_rderrd0
/* QL:         subq.l  #1,a1           discard the terminator */
    subq.l #1,a1
/* QL:         assert  -1,M40_err.nc */
/* original assertion: -1,M40_err.nc */
/* QL:         moveq   #-1,d3 */
    moveq #(-1),d3
/* QL:         cmp.b   #27,0(a6,a1.l)  was it terminated by an esc? */
    cmp.b #(27&255),0(a6,a1.l)
/* QL:         beq.s   M40_rderrd3         yes - give back a "not complete" error */
    beq.s M40_rderrd3
/* QL:         move.w  d7,-(sp) */
    move.w d7,-(sp)
/* QL:         move.l  a1,d7           save end of buffer */
    move.l a1,d7
/* QL:         moveq   #M40_sd.pcol,d0     remove the line feed from the screen */
    moveq #M40_sd.pcol,d0
/* QL:         trap    #3 */
    trap #3
/* QL:         moveq   #M40_sd.ncol,d0 */
    moveq #M40_sd.ncol,d0
/* QL:         trap    #3 */
    trap #3
/* QL:         move.l  M40_bv_bfbas(a6),a4 source in a4 */
    move.l M40_bv_bfbas(a6),a4
/* QL:         bsr.s   M40_chktype */
    bsr.s M40_chktype
/* QL:         bcc.s   M40_putss */
    bcc.s M40_putss
/* QL:         exg     a0,a4           save channel and get source in a0 */
    exg a4,a0
/* QL:         move.l  M40_bv_rip(a6),a1   get ri pointer */
    move.l M40_bv_rip(a6),a1
/* QL:         bmi.s   M40_dtoi */
    bmi.s M40_dtoi
/* QL:         jsr     cn_dtof(pc) */
    jsr cn_dtof(pc)
/* QL:         bra.s   M40_chkri */
    bra.s M40_chkri
/* QL: M40_putss */
M40_putss:
/* QL:         sub.w   a4,d7           data length read */
    sub.w a4,d7
/* QL:         move.w  d7,d1 */
    move.w d7,d1
/* QL:         jsr     ca_putss(pc) */
    jsr ca_putss(pc)
/* QL:         bra.s   M40_ritovv */
    bra.s M40_ritovv
/* QL: M40_dtoi */
M40_dtoi:
/* QL:         jsr     cn_dtoi(pc) */
    jsr cn_dtoi(pc)
/* QL: M40_chkri */
M40_chkri:
/* QL:         move.l  a4,a0           restore channel */
    move.l a4,a0
/* QL:         bne.s   M40_restd7 */
    bne.s M40_restd7
/* QL:         move.l  a1,M40_bv_rip(a6) */
    move.l a1,M40_bv_rip(a6)
/* QL: M40_ritovv */
M40_ritovv:
/* QL:         jsr     bp_let(pc) */
    jsr bp_let(pc)
/* QL: M40_restd7 */
M40_restd7:
/* QL:         move.w  (sp)+,d7        reload d7 */
    move.w (sp)+,d7
/* QL: M40_rderrd0 */
M40_rderrd0:
/* QL:         move.l  d0,d3 */
    move.l d0,d3
/* QL:         beq.s   M40_resta2 */
    beq.s M40_resta2
/* QL:         moveq   #M40_sd.curs,d0     suppress the cursor */
    moveq #M40_sd.curs,d0
/* QL:         bsr.s   M40_trap3 */
    bsr.s M40_trap3
/* QL: M40_rderrd3 */
M40_rderrd3:
/* QL:         move.l  d3,d0 */
    move.l d3,d0
/* QL: M40_resta2 */
M40_resta2:
/* QL:         add.l   M40_bv_chbas(a6),a2 reset a2 */
    add.l M40_bv_chbas(a6),a2
/* QL: M40_end_arg */
M40_end_arg:
/* QL:         bsr.s   M40_sepmost         if no error, action null and !,\ separators */
    bsr.s M40_sepmost
/* QL:         bne.s   M40_droparr         if any error, go clean up any array */
    bne.s M40_droparr
/* QL:         jsr     bp_arnxt(pc)    scan any array elements */
    jsr bp_arnxt(pc)
/* QL:         bgt.l   M40_pr_elt          there were some left, so loop */
    bgt.w M40_pr_elt
/* QL: M40_droparr */
M40_droparr:
/* QL:         jsr     bp_arend(pc)    discard any array index block */
    jsr bp_arend(pc)
/* QL:         bne.s   M40_notto           some error about */
    bne.s M40_notto
/* QL:         tst.w   d5              look at our to<null> flag */
    tst.w d5
/* QL:         bmi.s   M40_notonul         if we haven't been using to<null>, no prob */
    bmi.s M40_notonul
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL:         subq.l  #8,(sp)         get rid of the <null> (possible overrun is OK) */
    subq.l #8,(sp)
/* QL: M40_notonul */
M40_notonul:
/* QL:         cmp.b   #M40_b.septo<<4,d5  are we on for a to? */
    cmp.b #((M40_b.septo<<4)&255),d5
/* QL:         bne.s   M40_notto           no - skip this */
    bne.s M40_notto
/* QL:         subq.l  #8,(sp)         using up another argument */
    subq.l #8,(sp)
/* QL:         bsr.s   M40_septo           action the to */
    bsr.s M40_septo
/* QL: M40_notto */
M40_notto:
/* QL:         bra.l   M40_steparg         go back up to the top */
    bra.w M40_steparg
/* QL: M40_oddsep */
M40_oddsep:
/* QL:         subq.b  #M40_b.back>>1,d0 */
    subq.b #(M40_b.back>>1),d0
/* QL:         bne.s   M40_okrts5 */
    bne.s M40_okrts5
/* QL: M40_nwlin */
M40_nwlin:
/* QL:         tst.b   d7              is this M40_input only? */
    tst.b d7
/* QL:         bgt.s   M40_okrts5 */
    bgt.s M40_okrts5
/* QL:         moveq   #10,d1 */
    moveq #10,d1
/* QL:         clr.w   M40_ch.chpos(a6,a2.l) */
    clr.w M40_ch.chpos(a6,a2.l)
/* QL: M40_print_1 */
M40_print_1:
/* QL:         moveq   #M40_io.sbyte,d0 */
    moveq #M40_io.sbyte,d0
/* QL: M40_trap3 */
M40_trap3:
/* QL:         move.l  d3,-(sp)        save d3 */
    move.l d3,-(sp)
/* QL:         moveq   #-1,d3          infinite timeout */
    moveq #(-1),d3
/* QL:         trap    #3 */
    trap #3
/* QL:         move.l  (sp)+,d3        restore d3 */
    move.l (sp)+,d3
/* QL:         bra.s   M40_tstrts */
    bra.s M40_tstrts
/* QL: M40_excl_do */
M40_excl_do:
/* QL:         swap    d4              arg preceded by an ! */
    swap d4
/* QL:         cmp.w   d2,d4           how much room is there left on the line? */
    cmp.w d2,d4
/* QL: M40_nwlinlt */
M40_nwlinlt:
/* QL:         ble.s   M40_nwlin           not enough, so do a new line */
    ble.s M40_nwlin
/* QL: M40_prints */
M40_prints:
/* QL:         tst.b   d7 */
    tst.b d7
/* QL:         bgt.s   M40_okrts5          if M40_input from read only, write nothing */
    bgt.s M40_okrts5
/* QL:         moveq   #' ',d1 */
    moveq #32,d1
/* QL:         addq.w  #1,M40_ch.chpos(a6,a2.l) one more character */
    addq.w #1,M40_ch.chpos(a6,a2.l)
/* QL:         bra.s   M40_print_1 */
    bra.s M40_print_1
/* QL: M40_sepmost */
M40_sepmost:
/* QL:         move.l  d0,d4           has an error occurred? (also set d4.bit0=0) */
    move.l d0,d4
/* QL:         bne.s   M40_rts5            yes - get out straight away */
    bne.s M40_rts5
/* QL:         moveq   #M40_err.nc,d0 */
    moveq #M40_err.nc,d0
/* QL:         tst.b   M40_bv_brk(a6)      has a "break" keypress happened? */
    tst.b M40_bv_brk(a6)
/* QL:         bpl.s   M40_tstrts          yes - stop here */
    bpl.s M40_tstrts
/* QL:         move.b  d5,d0 */
    move.b d5,d0
/* QL:         beq.s   M40_nwlin           treat no separator same as backslash */
    beq.s M40_nwlin
/* QL:         assert  1,M40_b.sepcom,M40_b.back&1,(M40_b.excl-1)&1 */
/* original assertion: 1,M40_b.sepcom,M40_b.back&1,(M40_b.excl-1)&1 */
/* QL:         lsr.b   #5,d0 */
    lsr.b #5,d0
/* QL:         beq.s   M40_comma */
    beq.s M40_comma
/* QL:         bcs.s   M40_oddsep */
    bcs.s M40_oddsep
/* QL:         subq.b  #M40_b.excl>>1,d0 */
    subq.b #(M40_b.excl>>1),d0
/* QL:         bne.s   M40_okrts5          get out if not exclamation mark */
    bne.s M40_okrts5
/* QL:         bsr.s   M40_where           do nothing now but get space left */
    bsr.s M40_where
/* QL:         sub.w   d1,d3 */
    sub.w d1,d3
/* QL:         move.w  d3,d4 */
    move.w d3,d4
/* QL:         swap    d4              save space left in msw */
    swap d4
/* QL:         tst.w   d1              check for beginning of a line */
    tst.w d1
/* QL:         sne     d4              if not at start of line, flag pending ! */
    sne d4
/* QL: M40_okrts5 */
M40_okrts5:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M40_rts5 */
M40_rts5:
/* QL:         rts */
    rts 
/* QL: M40_comma */
M40_comma:
/* QL:         bsr.s   M40_where           M40_where am i */
    bsr.s M40_where
/* QL:         moveq   #-8,d2 */
    moveq #(-8),d2
/* QL:         and.w   d1,d2           round down to multiple of eight */
    and.w d1,d2
/* QL:         addq.w  #8,d2           move on eight to M40_where we want to finish */
    addq.w #8,d2
/* QL:         subq.w  #8,d3           remainder must be >=8 as well */
    subq.w #8,d3
/* QL:         bra.s   M40_tab_to */
    bra.s M40_tab_to
/* QL: M40_sstrg */
M40_sstrg:
/* QL:         moveq   #M40_io.sstrg,d0    write out a string */
    moveq #M40_io.sstrg,d0
/* QL: M40_trap43 */
M40_trap43:
/* QL:         trap    #4 */
    trap #4
/* QL:         bra.s   M40_trap3 */
    bra.s M40_trap3
/* QL: M40_septo */
M40_septo:
/* QL:         addq.l  #8,a3           step past current arg */
    addq.l #8,a3
/* QL:         move.l  a3,a5           set upper limit */
    move.l a3,a5
/* QL:         blt.s   M40_gtin1           force error if there were no arguments left! */
    blt.s M40_gtin1
/* QL: *       tst.b   1(a6,a3.l) */
/* QL: *       bmi.s   M40_gtin1           force error if to #<arg> - may use this later */
/* QL:         addq.l  #8,a5           pretend there's only one arg */
    addq.l #8,a5
/* QL: M40_gtin1 */
M40_gtin1:
/* QL:         jsr     ca_gtin1(pc) */
    jsr ca_gtin1(pc)
/* QL:         bne.s   M40_rts5 */
    bne.s M40_rts5
/* QL:         move.w  d1,d2           M40_where they want to go to */
    move.w d1,d2
/* QL:         addq.l  #2,M40_bv_rip(a6) */
    addq.l #2,M40_bv_rip(a6)
/* QL:         bsr.s   M40_where           M40_where we are now */
    bsr.s M40_where
/* QL: M40_tab_to */
M40_tab_to:
/* QL:         cmp.w   d2,d3           what's left on line? */
    cmp.w d2,d3
/* QL:         blt.s   M40_nwlinlt         not enough, so get out */
    blt.s M40_nwlinlt
/* QL:         sub.w   d1,d2           M40_print at least one, up to this many spaces */
    sub.w d1,d2
/* QL: M40_re_spac */
M40_re_spac:
/* QL:         bsr.s   M40_prints */
    bsr.s M40_prints
/* QL:         subq.w  #1,d2 */
    subq.w #1,d2
/* QL:         bgt.s   M40_re_spac */
    bgt.s M40_re_spac
/* QL: M40_tstrts */
M40_tstrts:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: * Note: we only ever do this the once (per channel) */
/* QL: M40_flagro */
M40_flagro:
/* QL:         addq.b  #1,d7           M40_input $00->$01, M40_print $80->$81 */
    addq.b #1,d7
/* QL: M40_where */
M40_where:
/* QL:         assert  M40_ch.chpos,M40_ch.width-2 */
/* original assertion: M40_ch.chpos,M40_ch.width-2 */
/* QL:         movem.w M40_ch.chpos(a6,a2.l),d1/d3 */
    movem.w M40_ch.chpos(a6,a2.l),d1/d3
/* QL:         rol.b   #8,d7           have we set bit 0 yet? */
    rol.b #8,d7
/* QL:         bcs.s   M40_okrts5          yes - then we know it's a read only channel */
    bcs.s M40_okrts5
/* QL: M40_chenq */
M40_chenq:
/* QL:         moveq   #M40_sd.chenq,d0 */
    moveq #M40_sd.chenq,d0
/* QL:         move.l  M40_bv_bfbas(a6),a1 */
    move.l M40_bv_bfbas(a6),a1
/* QL:         bsr.s   M40_trap43          if it's read only, we'll get an error */
    bsr.s M40_trap43
/* QL:         bne.s   M40_flagro          so go flag it */
    bne.s M40_flagro
/* QL:         move.w  4(a6,a1.l),d1   position of cursor */
    move.w 4(a6,a1.l),d1
/* QL:         move.w  0(a6,a1.l),d3   length of line */
    move.w 0(a6,a1.l),d3
/* QL:         rts */
    rts 
/* QL: * Fetches string to or edits string in basic buffer. Routine that is used by */
/* QL: * basic to M40_input command or program lines from the keyboard or other devices. */
/* QL: * d0 -i o- zero if M40_input may be editted, output error code */
/* QL: * d3 -i o- lsw cursor position (msw preserved) */
/* QL: * a0 -ip - M40_where to read from */
/* QL: * a1 -  o- M40_where buffer has been filled to */
/* QL: * d1-d2 destroyed */
/* QL: bp_rdbuf */
bp_rdbuf:
/* QL:         move.l  d0,-(sp)        save edit or not */
    move.l d0,-(sp)
/* QL:         bne.s   M40_goedit          can't edit, so leave out write */
    bne.s M40_goedit
/* QL:         bsr.s   M40_params          get parameters for the operation */
    bsr.s M40_params
/* QL:         move.w  d3,d2           use cursor position for initial display */
    move.w d3,d2
/* QL: M40_sendit */
M40_sendit:
/* QL:         bsr.s   M40_sstrg */
    bsr.s M40_sstrg
/* QL: M40_goedit */
M40_goedit:
/* QL:         bsr.s   M40_params          get parameters (again) */
    bsr.s M40_params
/* QL:         add.w   d1,a1           set up current position */
    add.w d1,a1
/* QL:         moveq   #M40_io.edlin,d0    set to edit a line */
    moveq #M40_io.edlin,d0
/* QL:         tst.l   (sp)            allow edit? */
    tst.l (sp)
/* QL:         beq.s   M40_trp_set */
    beq.s M40_trp_set
/* QL:         moveq   #M40_io.fline,d0    no, fetch a line */
    moveq #M40_io.fline,d0
/* QL:         sub.w   d1,d2           or rather, a continuation of same!! */
    sub.w d1,d2
/* QL: M40_trp_set */
M40_trp_set:
/* QL:         bsr.s   M40_trap43 */
    bsr.s M40_trap43
/* QL:         moveq   #M40_err.bo,d2 */
    moveq #M40_err.bo,d2
/* QL:         cmp.l   d0,d2 */
    cmp.l d0,d2
/* QL:         beq.s   M40_edmore          extend buffer if it overflows */
    beq.s M40_edmore
/* QL:         tst.l   (sp)+           check and discard saved edit flag */
    tst.l (sp)+
/* QL:         bne.s   M40_positit         we weren't editing, so no device check */
    bne.s M40_positit
/* QL:         moveq   #M40_err.bp,d2 */
    moveq #M40_err.bp,d2
/* QL:         sub.l   d0,d2 */
    sub.l d0,d2
/* QL:         beq.s   M40_edbpro */
    beq.s M40_edbpro
/* QL:         subq.l  #M40_err.bp-M40_err.ro,d2 a pity, but drivers may say bp or ro */
.word 20866|((((M40_err.bp-M40_err.ro))&7)<<9)
/* QL:         beq.s   M40_edbpro */
    beq.s M40_edbpro
/* QL: M40_positit */
M40_positit:
/* QL:         move.l  a1,M40_bv_bfp(a6)   save M40_where we've got to */
    move.l a1,M40_bv_bfp(a6)
/* QL:         bra.s   M40_tstrts */
    bra.s M40_tstrts
/* QL: M40_edmore */
M40_edmore:
/* QL:         bsr.s   M40_positit         record M40_where we got to */
    bsr.s M40_positit
/* QL:         swap    d1              cursor into lsw */
    swap d1
/* QL:         move.w  d1,d3           save current cursor position */
    move.w d1,d3
/* QL:         moveq   #128-8,d1       want more bytes (will round up as 192 extra) */
    moveq #(128-8),d1
/* QL:         jsr     bv_chbfx(pc)    ask for it */
    jsr bv_chbfx(pc)
/* QL:         bra.s   M40_goedit */
    bra.s M40_goedit
/* QL: M40_edbpro */
M40_edbpro:
/* QL: * We only get here from reading a command channel line. */
/* QL: * If we were editing a "bad line", the cursor position may have been non-zero. */
/* QL: * If so, we've already sent the chars up to the cursor. */
/* QL: * To make that tidy, we need to send the rest, plus a linefeed. */
/* QL: * As it happens, the linefeed from the parser is still in the buffer! */
/* QL: * If the buffer is empty, we're OK already. */
/* QL:         move.l  d0,-(sp)        if edlin gives M40_err.bp/ro, try without edit */
    move.l d0,-(sp)
/* QL:         bsr.s   M40_params */
    bsr.s M40_params
/* QL:         move.w  d1,d2 */
    move.w d1,d2
/* QL:         beq.s   M40_goedit          nothing in buffer, so nothing pre-sent */
    beq.s M40_goedit
/* QL:         move.l  a1,M40_bv_bfp(a6)   lose contents of buffer now */
    move.l a1,M40_bv_bfp(a6)
/* QL:         add.w   d3,a1           move past what we've sent */
    add.w d3,a1
/* QL:         sub.w   d3,d2           count that off */
    sub.w d3,d2
/* QL:         addq.w  #1,d2           include the linefeed */
    addq.w #1,d2
/* QL:         clr.w   d3              forget the cursor now */
    clr.w d3
/* QL:         bra.s   M40_sendit          go start business */
    bra.s M40_sendit
/* QL: M40_params */
M40_params:
/* QL:         assert  M40_bv_bfbas,M40_bv_bfp-4 */
/* original assertion: M40_bv_bfbas,M40_bv_bfp-4 */
/* QL:         movem.l M40_bv_bfbas(a6),d0-d2 buffer base, top and next pointer */
    movem.l M40_bv_bfbas(a6),d0-d2
/* QL:         move.w  #$7eff,a1       an arbitrary maximum */
    move.w #0x7eff,a1
/* QL:         exg     a1,d0 */
    exg a1,d0
/* QL:         sub.l   a1,d1           length of buffer so far */
    sub.l a1,d1
/* QL:         sub.l   a1,d2           maximum length of buffer */
    sub.l a1,d2
/* QL:         cmp.l   d2,d0           is the current buffer size reasonable? */
    cmp.l d2,d0
/* QL:         bcc.s   M40_max_ok */
    bcc.s M40_max_ok
/* QL:         move.l  d0,d2           no - truncate it */
    move.l d0,d2
/* QL: M40_max_ok */
M40_max_ok:
/* QL:         cmp.l   d1,d2           is the current number of characters now OK? */
    cmp.l d1,d2
/* QL:         bcc.s   M40_off_ok */
    bcc.s M40_off_ok
/* QL:         moveq   #0,d1           no - discard them - probably a duff file read */
    moveq #0,d1
/* QL: M40_off_ok */
M40_off_ok:
/* QL:         cmp.w   d3,d1           does the cursor make some sense? */
    cmp.w d3,d1
/* QL:         bcc.s   M40_cur_ok */
    bcc.s M40_cur_ok
/* QL:         clr.w   d3              no - discard it */
    clr.w d3
/* QL: M40_cur_ok */
M40_cur_ok:
/* QL:         swap    d1 */
    swap d1
/* QL:         move.w  d3,d1           put cursor in msw */
    move.w d3,d1
/* QL:         swap    d1 */
    swap d1
/* QL:         rts */
    rts 
/* QL:         end */
