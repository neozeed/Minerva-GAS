/* ROM section bv_alvv */
.balign 2,0
/* QL: * d0 -  o- 0 */
/* QL: * d1 -ip - how much needed */
/* QL: * a0 -  o- address of piece of vv to use relative to a6 */
/* QL: * ccr-  o- z */
/* QL: * a1 -  o- ri pointer from M75_bv_rip(a6), useful at times */
/* QL: allist  reg     d1-d3/a2-a3 */
/* QL: bv_alvv */
bv_alvv:
/* QL:         movem.l allist,-(sp) */
    movem.l d1-d3/a2-a3,-(sp)
/* QL:         bsr.s   M75_alvv */
    bsr.s M75_alvv
/* QL:         bra.s   M75_pop */
    bra.s M75_pop
/* QL: * As above, but fast clear to zero of allocated area follows */
/* QL: bv_alvvz */
bv_alvvz:
/* QL:         movem.l allist,-(sp) */
    movem.l d1-d3/a2-a3,-(sp)
/* QL:         bsr.s   M75_alvv */
    bsr.s M75_alvv
/* QL:         subq.l  #8,0(a6,a0.l)   was this just an eight byte allocation? */
    subq.l #8,0(a6,a0.l)
/* QL:         beq.s   M75_pop             yes, alloc has cleared 2nd word for us */
    beq.s M75_pop
/* QL:         jsr     mm_clrr(pc)     use fast clear for longer areas */
    jsr mm_clrr(pc)
/* QL: M75_pop */
M75_pop:
/* QL:         movem.l (sp)+,allist */
    movem.l (sp)+,d1-d3/a2-a3
/* QL:         move.l  M75_bv_rip(a6),a1   quite useful to set a1 for some callers */
    move.l M75_bv_rip(a6),a1
/* QL:         rts */
    rts 
/* QL: M75_fail */
M75_fail:
/* QL:         move.l  d1,a3           save space we're asking for */
    move.l d1,a3
/* QL:         jsr     bv_chvvx(pc)    no space within table, add to top */
    jsr bv_chvvx(pc)
/* QL:         move.l  a3,d1           restore what we asked for */
    move.l a3,d1
/* QL:         move.l  M75_bv_vvp(a6),a0   get current top of vv area */
    move.l M75_bv_vvp(a6),a0
/* QL:         add.l   d1,M75_bv_vvp(a6)   expand the area by the amount asked for */
    add.l d1,M75_bv_vvp(a6)
/* QL:         bsr.s   M75_lnkfr           link in added amount */
    bsr.s M75_lnkfr
/* QL:         move.l  a3,d1           restore what we asked for again */
    move.l a3,d1
/* QL: M75_alvv */
M75_alvv:
/* QL:         moveq   #M75_mt.alloc,d0    look for a free space (rounded to * 8 by this) */
    moveq #M75_mt.alloc,d0
/* QL:         move.w  #M75_bv_vvfre,a0    pointer to pointer to first free space */
    move.w #M75_bv_vvfre,a0
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  d0,d2           found one? */
    move.l d0,d2
/* QL:         bne.s   M75_fail */
    bne.s M75_fail
/* QL:         rts */
    rts 
/* QL: * d0 -ip - possible error code */
/* QL: * d1 -i  - length of space to free */
/* QL: * a0 -i  - start of space to free */
/* QL: * ccr-  o- result of testing d0.l */
/* QL: frlist  reg     d0/d2-d3/a1-a3 */
/* QL: bv_frvv */
bv_frvv:
/* QL:         addq.l  #7,d1 */
    addq.l #7,d1
/* QL:         asr.l   #3,d1 */
    asr.l #3,d1
/* QL:         asl.l   #3,d1           round up to nearest multiple of 8 */
    asl.l #3,d1
/* QL:         ble.s   M75_end_0           just in case there's nothing to free */
    ble.s M75_end_0
/* QL: M75_lnkfr */
M75_lnkfr:
/* QL:         movem.l frlist,-(sp) */
    movem.l d0/d2-d3/a1-a3,-(sp)
/* QL:         moveq   #M75_mt.lnkfr,d0 */
    moveq #M75_mt.lnkfr,d0
/* QL:         move.w  #M75_bv_vvfre,a1 */
    move.w #M75_bv_vvfre,a1
/* QL:         trap    #1 */
    trap #1
/* QL:         movem.l (sp)+,frlist */
    movem.l (sp)+,d0/d2-d3/a1-a3
/* QL: M75_end_0 */
M75_end_0:
/* QL:         tst.l   d0              let caller know the state of their error flag */
    tst.l d0
/* QL:         rts */
    rts 
/* QL:         end */
