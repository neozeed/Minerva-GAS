/* ROM section mm_altrn */
.balign 2,0
/* QL: * Find an adequate transient area space */
/* QL: * ccr-  o- z if no adequate space was found (a2 destroyed) */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -i o- space required, rounded up to a multiple of sixteen */
/* QL: * a2 -  o- pointer to pointer to adequate space found */
/* QL: * d3 -  o- 0 */
/* QL: * d0/d2-d3/a0-a1 destroyed */
/* QL: mm_whtrn */
mm_whtrn:
/* QL:         lea     M60_sv_trnfr(a6),a0 get first link pointer */
    lea M60_sv_trnfr(a6),a0
/* QL:         moveq   #16-1,d2        allocate in multiples of sixteen */
    moveq #(16-1),d2
/* QL:         moveq   #0,d0           scan all of free space */
    moveq #0,d0
/* QL:         jsr     mm_scafr(pc) */
    jsr mm_scafr(pc)
/* QL:         tst.l   d2              check if adequate space found */
    tst.l d2
/* QL:         rts */
    rts 
/* QL: M60_pop_rts */
M60_pop_rts:
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: * Not M60_enough space found */
/* QL: M60_no_room */
M60_no_room:
/* QL:         move.l  d1,-(sp)        save required length */
    move.l d1,-(sp)
/* QL:         assert  M60_sv_trnsp,M60_sv_trnfr-4 */
/* original assertion: M60_sv_trnsp,M60_sv_trnfr-4 */
/* QL:         assert  4,M60_hp_next */
/* original assertion: 4,M60_hp_next */
/* QL:         lea     M60_sv_trnfr-M60_hp_next(a6),a1 */
    lea (M60_sv_trnfr-M60_hp_next)(a6),a1
/* QL:         add.l   M60_hp_next(a1),a1  first free in transient prog area */
    add.l M60_hp_next(a1),a1
/* QL:         cmp.l   M60_sv_trnsp(a6),a1 is this equal to bottom of area? */
    cmp.l M60_sv_trnsp(a6),a1
/* QL:         bne.s   M60_lenok */
    bne.s M60_lenok
/* QL:         sub.l   M60_hp_len(a1),d1   yes - reduce length required to be allocated */
    sub.l M60_hp_len(a1),d1
/* QL: M60_lenok */
M60_lenok:
/* QL:         jsr     mm_mdbas(pc)    ask job 0 to move down */
    jsr mm_mdbas(pc)
/* QL:         bne.s   M60_pop_rts         out of memory? */
    bne.s M60_pop_rts
/* QL:         lea     M60_sv_trnsp(a6),a1 */
    lea M60_sv_trnsp(a6),a1
/* QL:         sub.l   d1,(a1)         update bottom of transient prog area */
    sub.l d1,(a1)
/* QL:         move.l  (a1)+,a0        this is the freed up area now */
    move.l (a1)+,a0
/* QL:         assert  M60_sv_trnsp,M60_sv_trnfr-4 */
/* original assertion: M60_sv_trnsp,M60_sv_trnfr-4 */
/* QL:         jsr     mm_lnkf0(pc)    link in new space */
    jsr mm_lnkf0(pc)
/* QL:         move.l  (sp)+,d1        restore length required */
    move.l (sp)+,d1
/* QL: * Allocate a new transient space */
/* QL: * d0 -  o- error code (set to out of memory) */
/* QL: * d1 -i o- space required, rounded up to a multiple of sixteen */
/* QL: * a0 -  o- pointer to space allocated */
/* QL: * d2-d3/a1-a2 destroyed */
/* QL: mm_altrn */
mm_altrn:
/* QL:         bsr.s   mm_whtrn */
    bsr.s mm_whtrn
/* QL:         beq.s   M60_no_room */
    beq.s M60_no_room
/* QL: * Allocate whole or part of a trn space */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -ip - space required, a multiple of sixteen */
/* QL: * a0 -  o- pointer to space allocated */
/* QL: * a2 -ip - pointer to pointer to area to be used */
/* QL: mm_gotrn */
mm_gotrn:
/* QL:         move.l  a2,a0           get pointer to space */
    move.l a2,a0
/* QL:         add.l   M60_hp_next(a2),a0  absolute */
    add.l M60_hp_next(a2),a0
/* QL:         move.l  M60_hp_len(a0),d0   and length of this */
    move.l M60_hp_len(a0),d0
/* QL:         sub.l   d1,d0           check whether space is exact fit */
    sub.l d1,d0
/* QL:         bgt.s   M60_enough */
    bgt.s M60_enough
/* QL:         move.l  M60_hp_next(a0),d0  get next link pointer */
    move.l M60_hp_next(a0),d0
/* QL:         beq.s   M60_set_next        is it last? */
    beq.s M60_set_next
/* QL:         add.l   a0,d0           no - adjust it */
    add.l a0,d0
/* QL:         sub.l   a2,d0 */
    sub.l a2,d0
/* QL: M60_set_next */
M60_set_next:
/* QL:         move.l  d0,M60_hp_next(a2)  link past */
    move.l d0,M60_hp_next(a2)
/* QL:         bra.s   M60_ok_rts */
    bra.s M60_ok_rts
/* QL: * We don't bother extending over odd scraps here, because the transient area */
/* QL: * is never going to have a vast number of fragments. */
/* QL: M60_enough */
M60_enough:
/* QL:         move.l  d0,(a0)         shorten free block */
    move.l d0,(a0)
/* QL:         add.l   d0,a0           move pointer to new area */
    add.l d0,a0
/* QL:         move.l  d1,(a0)         set new length */
    move.l d1,(a0)
/* QL: M60_ok_rts */
M60_ok_rts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL:         end */
