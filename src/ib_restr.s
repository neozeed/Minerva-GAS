/* ROM section ib_restr */
.balign 2,0
/* QL: ib_restr */
ib_restr:
/* QL:         move.l  a4,a0 */
    move.l a4,a0
/* QL:         jsr     ca_evali(pc) */
    jsr ca_evali(pc)
/* QL:         move.l  a0,a4 */
    move.l a0,a4
/* QL:         blt.s   M157_rts0 */
    blt.s M157_rts0
/* QL:         beq.s   M157_set_stm */
    beq.s M157_set_stm
/* QL:         addq.l  #2,M157_bv_rip(a6) */
    addq.l #2,M157_bv_rip(a6)
/* QL:         move.w  0(a6,a1.l),d0   pick up actual line number */
    move.w 0(a6,a1.l),d0
/* QL: M157_set_stm */
M157_set_stm:
/* QL:         move.w  d0,M157_bv_dalno(a6) set new data linumber */
    move.w d0,M157_bv_dalno(a6)
/* QL:         assert  1,1&M157_bv_daitm,M157_bv_daitm-M157_bv_dastm */
/* original assertion: 1,1&M157_bv_daitm,M157_bv_daitm-M157_bv_dastm */
/* QL:         move.w  #1<<8!1,M157_bv_dastm(a6) 1st statement/item */
    move.w #((1<<8)|1),M157_bv_dastm(a6)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M157_rts0 */
M157_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
