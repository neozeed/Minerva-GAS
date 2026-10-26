/* ROM section sd_entry */
.balign 2,0
/* QL: * d0 cr  control parameter / M111_error flag */
/* QL: * a3   s scratch (except for sbyte and M111_extop keys) */
/* QL: * ...... any others used by called routines */
/* QL: reglist reg     d0-d2   need to save when adjusting the cursor */
/* QL: sd_entry */
sd_entry:
/* QL:         pea     M111_exit            normally we just test d0 on return */
    pea M111_exit(pc)
/* QL:         tst.b   M111_sd_curf(a0)     check if cursor is visible */
    tst.b M111_sd_curf(a0)
/* QL:         ble.s   M111_branch          no - then that's it */
    ble.s M111_branch
/* QL:         addq.l  #M111_rest-M111_exit,(sp) we want to check the cursor on return */
.word 20631|((((M111_rest-M111_exit))&7)<<9)
/* QL:         movem.l reglist,-(sp)   save call parameters */
    movem.l d0-d2,-(sp)
/* QL:         jsr     sd_curt(pc)     hide cursor */
    jsr sd_curt(pc)
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d0-d2
/* QL: M111_branch */
M111_branch:
/* QL:         subq.b  #M111_io.sbyte,d0    check if write a character */
    subq.b #M111_io.sbyte,d0
/* QL:         bne.s   M111_range           no - go do all the others */
    bne.s M111_range
/* QL: * This used to be the sd_wchar routine. */
/* QL: * Having it in here makes it a little quicker, as we cut out the long jumping, */
/* QL: * we know no one else uses it and we can see it doesn't care about d0 on entry. */
/* QL: * d0   s                    x position */
/* QL: * d1 c s character          y position */
/* QL: * d2   s                    character */
/* QL: * d3   s                    attributes */
/* QL: * a0 c   address of control block */
/* QL: * a1   s                    colour masks */
/* QL: * a2   s                    pointer to fount */
/* QL: * a3   s                    pointer to fount */
/* QL:         jsr     sd_chchk(pc)    check if room for character */
    jsr sd_chchk(pc)
/* QL:         bne.s   M111_anrts */
    bne.s M111_anrts
/* QL:         move.b  d1,d2           put character in position required */
    move.b d1,d2
/* QL:         move.l  M111_sd_xmin(a0),d0  get position of M111_top lhs */
    move.l M111_sd_xmin(a0),d0
/* QL:         add.l   M111_sd_xpos(a0),d0  ... then cursor position */
    add.l M111_sd_xpos(a0),d0
/* QL:         move.w  d0,d1           ... and put them in the right position */
    move.w d0,d1
/* QL:         swap    d0 */
    swap d0
/* QL:         move.b  M111_sd_cattr(a0),d3 set attributes */
    move.b M111_sd_cattr(a0),d3
/* QL:         lea     M111_sd_smask(a0),a1 ... colours */
    lea M111_sd_smask(a0),a1
/* QL:         movem.l M111_sd_font(a0),a2/a3 ... and font */
    movem.l M111_sd_font(a0),a2/a3
/* QL:         pea     sd_ncol(pc)     move to next column on return */
    pea sd_ncol(pc)
/* QL:         jmp     cs_char(pc)     go do the character */
    jmp cs_char(pc)
/* QL: * Rest of the code for other sd entries */
/* QL: M111_range */
M111_range:
/* QL:         subq.b  #M111_sd.extop-M111_io.sbyte,d0 is it an extended operation? */
.word 20736|((((M111_sd.extop-M111_io.sbyte))&7)<<9)
/* QL:         beq.s   M111_extop           yes - go do it */
    beq.s M111_extop
/* QL:         cmp.b   #(M111_top-M111_bot)/2,d0 is it in our table? */
    cmp.b #(((M111_top-M111_bot)/2)&255),d0
/* QL:         bhi.s   M111_error           no - that's bad */
    bhi.s M111_error
/* QL:         add.b   d0,d0           d0 addresses words */
    add.b d0,d0
/* QL:         move.w  M111_bot-2(pc,d0.w),a3 load entry offset */
    move.w (M111_bot-2)(pc,d0.w),a3
/* QL:         lsr.b   #1,d0           restore d0 */
    lsr.b #1,d0
/* QL:         add.b   #M111_sd.extop,d0    ... */
    add.b #(M111_sd.extop&255),d0
/* QL:         jmp     M111_bot(pc,a3.w)    call appropriate subroutine */
.word 0x4efb
.word 45056|((M111_bot-.)&255)
/* QL: M111_extop */
M111_extop:
/* QL:         moveq   #M111_sd.extop,d0    put d0 back, just in case it's wanted */
    moveq #M111_sd.extop,d0
/* QL:         jmp     (a2)            extended operation */
    jmp (a2)
/* QL: M111_cure */
M111_cure:
/* QL:         movem.l reglist,-(sp)   save ds */
    movem.l d0-d2,-(sp)
/* QL:         jsr     sd_cure(pc)     make cursor visible */
    jsr sd_cure(pc)
/* QL:         movem.l (sp)+,reglist   restore ds */
    movem.l (sp)+,d0-d2
/* QL: M111_exit */
M111_exit:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: M111_anrts */
M111_anrts:
/* QL:         rts */
    rts 
/* QL: M111_rest */
M111_rest:
/* QL:         tst.b   M111_sd_curf(a0)     has cursor been made invisible now? */
    tst.b M111_sd_curf(a0)
/* QL:         bge.s   M111_exit            yes - leave it off */
    bge.s M111_exit
/* QL:         tst.l   d0              was there an M111_error? */
    tst.l d0
/* QL:         beq.s   M111_cure            no - go enable the cursor */
    beq.s M111_cure
/* QL:         rts                     yes - leave the cursor as is */
    rts 
/* QL: M111_error */
M111_error:
/* QL:         addq.l  #4,sp           forget the call ... */
    addq.l #4,sp
/* QL:         moveq   #M111_err.bp,d0      ... as we're setting an M111_error code */
    moveq #M111_err.bp,d0
/* QL:         rts */
    rts 
/* QL: * Set up the vector table for the sd/gw routines */
/* QL: t       macro */
/* QL: M111_bot */
M111_bot:
/* QL:  t                   sd_pxenq sd_chenq sd_bordr sd_wdef  sd_cure  sd_curs  ;0f */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_421:
.word ((sd_pxenq-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_432:
.word ((sd_chenq-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_443:
.word ((sd_bordr-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_454:
.word ((sd_wdef-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_465:
.word ((sd_cure-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_476:
.word ((sd_curs-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  t sd_pos   sd_tab   sd_nl    sd_pcol  sd_ncol  sd_prow  sd_nrow  sd_pixp  ;17 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_490:
.word ((sd_pos-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_501:
.word ((sd_tab-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_512:
.word ((sd_nl-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_523:
.word ((sd_pcol-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_534:
.word ((sd_ncol-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_545:
.word ((sd_prow-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_556:
.word ((sd_nrow-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_567:
.word ((sd_pixp-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  t sd_scrol sd_scrol sd_scrol sd_pan   M111_error    M111_error    sd_pan   sd_pan   ;1f */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_581:
.word ((sd_scrol-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_592:
.word ((sd_scrol-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_603:
.word ((sd_scrol-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_614:
.word ((sd_pan-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_624:
.word ((M111_error-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_634:
.word ((M111_error-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_645:
.word ((sd_pan-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_656:
.word ((sd_pan-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  t sd_clear sd_clrxx sd_clrxx sd_clrxx sd_clrxx sd_setfo sd_recol sd_setco ;27 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_670:
.word ((sd_clear-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_681:
.word ((sd_clrxx-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_692:
.word ((sd_clrxx-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_703:
.word ((sd_clrxx-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_714:
.word ((sd_clrxx-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_725:
.word ((sd_setfo-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_736:
.word ((sd_recol-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_747:
.word ((sd_setco-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  t sd_setco sd_setco sd_setfl sd_setul sd_setmd sd_setsz sd_fill  sd_donl  ;2f */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_761:
.word ((sd_setco-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_772:
.word ((sd_setco-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_783:
.word ((sd_setfl-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_794:
.word ((sd_setul-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_805:
.word ((sd_setmd-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_816:
.word ((sd_setsz-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_827:
.word ((sd_fill-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_838:
.word ((sd_donl-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  t gw_fig   gw_fig   gw_fig   gw_fig   gw_scale gw_flood gw_gcur           ;36 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_852:
.word ((gw_fig-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_863:
.word ((gw_fig-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_874:
.word ((gw_fig-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_885:
.word ((gw_fig-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_896:
.word ((gw_scale-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_907:
.word ((gw_flood-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {M111_error} goto dcit */
/* QL:         xref    [p] */
/* QL: dcit    maclab */
/* QL:         dc.w    [p]-M111_bot */
.balign 2,0
M111_dc_anchor_918:
.word ((gw_gcur-M111_bot))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: M111_top */
M111_top:
/* QL:         end */
