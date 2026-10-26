/* ROM section sd_setfo */
.balign 2,0
/* QL: * a0 -i p- pointer to window block */
/* QL: * a1 -i o- address of new primary fount (<= 0 sets as default) */
/* QL: * a2 -i o- address of new secondary fount (<= 0 sets as default) */
/* QL: sd_setfo */
sd_setfo:
/* QL:         move.l  a3,-(sp) */
    move.l a3,-(sp)
/* QL:         move.l  M118_sv_chtop(a6),a3 */
    move.l M118_sv_chtop(a6),a3
/* QL:         move.l  a1,d0           check address of primary font */
    move.l a1,d0
/* QL:         bgt.s   M118_prim_ok */
    bgt.s M118_prim_ok
/* QL:         move.l  M118_sx_f0(a3),a1    use default fount */
    move.l M118_sx_f0(a3),a1
/* QL: M118_prim_ok */
M118_prim_ok:
/* QL:         move.l  a2,d0           check address of alternative fount */
    move.l a2,d0
/* QL:         bgt.s   M118_secd_ok */
    bgt.s M118_secd_ok
/* QL:         move.l  M118_sx_f1(a3),a2    use default fount */
    move.l M118_sx_f1(a3),a2
/* QL: M118_secd_ok */
M118_secd_ok:
/* QL:         move.l  (sp)+,a3 */
    move.l (sp)+,a3
/* QL:         movem.l a1-a2,M118_sd_font(a0) set it */
    movem.l a1-a2,M118_sd_font(a0)
/* QL:         moveq   #0,d0           never any error */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL:         end */
