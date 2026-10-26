/* ROM section bp_chan */
.balign 2,0
/* QL: * Start up a new superbasic channel number. */
/* QL: * d0 -  o- 0 if ok or M44_err.ex if channel already open */
/* QL: * d1 -ip - channel number , 0 - n, n undecided and may exceed max so far */
/* QL: * a0 -ip - new channel id */
/* QL: * a2 -  o- sb channel location */
/* QL: * All other registers preserved */
/* QL: * If the channel was already open, nothing will have been changed */
/* QL: * If the channel table is extended, it is done with all $ff's */
/* QL: * If a good slot is found, the new id will be stored and the rest zero, except */
/* QL: * for filling in 80 as the line width. */
/* QL: M44_extend */
M44_extend:
/* QL:         movem.l d1-d2,-(sp)     save channo/? */
    movem.l d1-d2,-(sp)
/* QL:         moveq   #M44_ch.lench,d1    we need a whole extra slot */
    moveq #M44_ch.lench,d1
/* QL:         add.l   a2,d1 */
    add.l a2,d1
/* QL:         sub.l   M44_bv_chp(a6),d1   extra amount needed */
    sub.l M44_bv_chp(a6),d1
/* QL:         move.l  d1,-(sp)        save it */
    move.l d1,-(sp)
/* QL:         jsr     bv_chchx(pc)    make sure there's enough room */
    jsr bv_chchx(pc)
/* QL:         movem.l (sp)+,d0-d2     get back extra/channo/? */
    movem.l (sp)+,d0-d2
/* QL: M44_fill */
M44_fill:
/* QL:         move.l  M44_bv_chp(a6),a2   pick up current pointer */
    move.l M44_bv_chp(a6),a2
/* QL:         st      0(a6,a2.l)      wipe all new space to -1 (closed) */
    st 0(a6,a2.l)
/* QL:         addq.l  #1,M44_bv_chp(a6)   update by extra */
    addq.l #1,M44_bv_chp(a6)
/* QL:         subq.l  #1,d0 */
    subq.l #1,d0
/* QL:         bne.s   M44_fill */
    bne.s M44_fill
/* QL: bp_chnew */
bp_chnew:
/* QL:         move.l  a0,-(sp)        save new id */
    move.l a0,-(sp)
/* QL:         bsr.s   bp_chnid        where does channel id go? */
    bsr.s bp_chnid
/* QL:         move.l  (sp)+,a0        reload new id */
    move.l (sp)+,a0
/* QL:         beq.s   M44_err_ex          ouch, channel is already open */
    beq.s M44_err_ex
/* QL:         subx.b  d0,d0           is slot there? */
    subx.b d0,d0
/* QL:         bpl.s   M44_extend          no, so go make more room */
    bpl.s M44_extend
/* QL:         move.l  a0,M44_ch.id(a6,a2.l) insert the new channel id */
    move.l a0,M44_ch.id(a6,a2.l)
/* QL:         moveq   #M44_ch.lench-4,d0  less one long word per channel to be cleared */
    moveq #(M44_ch.lench-4),d0
/* QL:         add.l   d0,a2 */
    add.l d0,a2
/* QL: M44_clr_block */
M44_clr_block:
/* QL:         clr.l   0(a6,a2.l) */
    clr.l 0(a6,a2.l)
/* QL:         subq.l  #4,a2 */
    subq.l #4,a2
/* QL:         subq.l  #4,d0 */
    subq.l #4,d0
/* QL:         bne.s   M44_clr_block */
    bne.s M44_clr_block
/* QL:         move.w  #80,M44_ch.width(a6,a2.l) 80 character line */
    move.w #80,M44_ch.width(a6,a2.l)
/* QL: M44_ok_rts */
M44_ok_rts:
/* QL:         moveq   #0,d0           and no errors */
    moveq #0,d0
/* QL: M44_rts0 */
M44_rts0:
/* QL:         rts */
    rts 
/* QL: M44_err_ex */
M44_err_ex:
/* QL:         moveq   #M44_err.ex,d0      channel exists */
    moveq #M44_err.ex,d0
/* QL:         rts */
    rts 
/* QL: * Determines whether or not next parameter is a channel number and, if so, */
/* QL: * returns the channel id, else returns default */
/* QL: * d0 - lo- error return */
/* QL: * d1 -i o- channel number (set to M44_c.defex if entry at bp_chan) */
/* QL: * a0 -  o- channel id if one exists */
/* QL: * a2 -  o- position of channel block if channel exists */
/* QL: * a3 -i o- next parameter (o=i if no chan given, o=i+8 else) */
/* QL: * a5 -ilo- top parameter(i,o) parameter to convert(l) */
/* QL: * All other registers preserved */
/* QL: regsav  reg     d2-d3/a5 */
/* QL: bp_chan */
bp_chan:
/* QL:         moveq   #M44_c.defex,d1     standard default for most things */
    moveq #M44_c.defex,d1
/* QL: bp_chand */
bp_chand:
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         ble.s   bp_chnid */
    ble.s bp_chnid
/* QL:         tst.b   1(a6,a3.l)      check hash flag */
    tst.b 1(a6,a3.l)
/* QL:         bpl.s   bp_chnid        not set, so this isn't a channel */
    bpl.s bp_chnid
/* QL:         movem.l regsav,-(sp) */
    movem.l d2-d3/a5,-(sp)
/* QL:         lea     8(a3),a5 */
    lea 8(a3),a5
/* QL:         jsr     ca_gtin1(pc)    get a single integer */
    jsr ca_gtin1(pc)
/* QL:         move.l  a5,a3 */
    move.l a5,a3
/* QL:         movem.l (sp)+,regsav */
    movem.l (sp)+,d2-d3/a5
/* QL:         bne.s   M44_rts0 */
    bne.s M44_rts0
/* QL:         addq.l  #2,M44_bv_rip(a6) */
    addq.l #2,M44_bv_rip(a6)
/* QL:         moveq   #M44_err.bp,d0      don't like negative channels! (lwr added) */
    moveq #M44_err.bp,d0
/* QL:         tst.w   d1 */
    tst.w d1
/* QL:         bmi.s   M44_rts0 */
    bmi.s M44_rts0
/* QL: * Look up a channel number, return location and, if open, the ID */
/* QL: * d1 -ip - channel number required */
/* QL: * d0 -  o- 0 or M44_err.no */
/* QL: * a0 -i o- if d0=0, the channel id, otherwise input value preserved */
/* QL: * a2 -  o- sb channel location (if d0=M44_err.no and x=0, this is above table) */
/* QL: * x  -  o- if d0=M44_err.no, 0: need more space or 1: closed slot found */
/* QL: * All other registers preserved */
/* QL: bp_chnid */
bp_chnid:
/* QL:         moveq   #M44_ch.lench,d0    chan length */
    moveq #M44_ch.lench,d0
/* QL:         mulu    d1,d0 */
    mulu d1,d0
/* QL:         add.l   M44_bv_chbas(a6),d0 add base of channels */
    add.l M44_bv_chbas(a6),d0
/* QL:         move.l  d0,a2           save the position */
    move.l d0,a2
/* QL:         sub.l   M44_bv_chp(a6),d0   does it exist? */
    sub.l M44_bv_chp(a6),d0
/* QL:         bcc.s   M44_err_no          note: x=1 iff slot is available */
    bcc.s M44_err_no
/* QL:         move.l  M44_ch.id(a6,a2.l),d0 actual id wants to be sent back */
    move.l M44_ch.id(a6,a2.l),d0
/* QL:         bmi.s   M44_err_no          negative id means it's closed */
    bmi.s M44_err_no
/* QL:         move.l  d0,a0           and the id */
    move.l d0,a0
/* QL:         bra.s   M44_ok_rts */
    bra.s M44_ok_rts
/* QL: M44_err_no */
M44_err_no:
/* QL:         moveq   #M44_err.no,d0 */
    moveq #M44_err.no,d0
/* QL:         rts */
    rts 
/* QL:         vect4000 bp_chan,bp_chand,bp_chnew,bp_chnid */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ bp$chan,(bp_chan-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ bp$chand,(bp_chand-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ bp$chnew,(bp_chnew-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ bp$chnid,(bp_chnid-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
