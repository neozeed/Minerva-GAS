/* ROM section bp_data */
.balign 2,0
/* QL: * d0 -  o- 0 found, M52_err.ef if not found, ccr set */
/* QL: * a0 -  o- where data item is found, else preserved */
/* QL: * d1-d4 destroyed (d5 now preserved, d3-d4 could be saved easily) */
/* QL: bp_data */
bp_data:
/* QL:         assert  M52_bv_linum,M52_bv_lengt-2,M52_bv_stmnt-4,M52_bv_cont-5,M52_bv_inlin-6,M52_bv_sing-7 */
/* original assertion: M52_bv_linum,M52_bv_lengt-2,M52_bv_stmnt-4,M52_bv_cont-5,M52_bv_inlin-6,M52_bv_sing-7 */
/* QL:         movem.l M52_bv_linum(a6),d1-d2 get context (index doesn't need saving) */
    movem.l M52_bv_linum(a6),d1-d2
/* QL:         moveq   #M52_err.ef,d0      in case we hit eof */
    moveq #M52_err.ef,d0
/* QL:         movem.l d0-d2/a4,-(sp)  save error code, context and program pointer */
    movem.l d0-d2/a4,-(sp)
/* QL:         jsr     ib_stbas(pc)    always look from top of prog */
    jsr ib_stbas(pc)
/* QL:         bne.s   M52_restore         no file there! */
    bne.s M52_restore
/* QL:         assert  M52_bv_dalno,M52_bv_dastm-2,M52_bv_daitm-3 */
/* original assertion: M52_bv_dalno,M52_bv_dastm-2,M52_bv_daitm-3 */
/* QL:         move.l  M52_bv_dalno(a6),d4 current data position */
    move.l M52_bv_dalno(a6),d4
/* QL:         swap    d4              data line number */
    swap d4
/* QL:         jsr     ib_golin(pc) */
    jsr ib_golin(pc)
/* QL:         bne.s   M52_restore         no line left in file */
    bne.s M52_restore
/* QL:         jsr     ib_stnxi(pc) */
    jsr ib_stnxi(pc)
/* QL:         rol.l   #8,d4           current data statement */
    rol.l #8,d4
/* QL:         jsr     ib_gost(pc) */
    jsr ib_gost(pc)
/* QL:         rol.l   #8,d4           data item to find */
    rol.l #8,d4
/* QL:         bra.s   M52_find_ent        (d4 shouldn't be zero, but no matter if it is!) */
    bra.s M52_find_ent
/* QL: M52_nx_item */
M52_nx_item:
/* QL:         subq.l  #2,a4           unskip the data or comma */
    subq.l #2,a4
/* QL:         jsr     ib_nxcom(pc)    get the next proper comma */
    jsr ib_nxcom(pc)
/* QL:         bne.s   M52_at_item         more items available */
    bne.s M52_at_item
/* QL: M52_find_dat */
M52_find_dat:
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL:         jsr     ib_nxst(pc)     get start of next statement */
    jsr ib_nxst(pc)
/* QL:         bne.s   M52_restore         aargh, we've run out */
    bne.s M52_restore
/* QL: M52_find_ent */
M52_find_ent:
/* QL:         jsr     ib_nxnon(pc) */
    jsr ib_nxnon(pc)
/* QL:         cmp.w   #M52_w.data,d1 */
    cmp.w #M52_w.data,d1
/* QL:         bne.s   M52_find_dat        not a data line */
    bne.s M52_find_dat
/* QL:         tst.l   d4 */
    tst.l d4
/* QL:         bne.s   M52_at_item */
    bne.s M52_at_item
/* QL:         move.l  M52_bv_linum(a6),d4 get new data line number */
    move.l M52_bv_linum(a6),d4
/* QL:         assert  0,1&M52_bv_stmnt */
/* original assertion: 0,1&M52_bv_stmnt */
/* QL:         move.w  M52_bv_stmnt(a6),d4 ditto statement */
    move.w M52_bv_stmnt(a6),d4
/* QL:         move.b  #1,d4           first item */
    move.b #(1&255),d4
/* QL:         move.l  d4,M52_bv_dalno(a6) set new data position */
    move.l d4,M52_bv_dalno(a6)
/* QL: M52_at_item */
M52_at_item:
/* QL:         jsr     ib_s2non(pc)    skip data or comma */
    jsr ib_s2non(pc)
/* QL:         subq.b  #1,d4           got there yet? */
    subq.b #1,d4
/* QL:         bne.s   M52_nx_item         no, keep going */
    bne.s M52_nx_item
/* QL:         move.l  a4,a0           this is where to read value from */
    move.l a4,a0
/* QL:         clr.l   (sp)            all ok, ccr zero */
    clr.l (sp)
/* QL: M52_restore */
M52_restore:
/* QL:         movem.l (sp)+,d0-d2/a4 */
    movem.l (sp)+,d0-d2/a4
/* QL:         movem.l d1-d2,M52_bv_linum(a6) */
    movem.l d1-d2,M52_bv_linum(a6)
/* QL:         rts */
    rts 
/* QL:         end */
