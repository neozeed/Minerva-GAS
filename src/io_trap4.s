/* ROM section io_trap4 */
.balign 2,0
/* QL: io_trap4 */
io_trap4:
/* QL:         movem.l d7/a5-a6,-(sp)  save standard registers */
    movem.l d7/a5-a6,-(sp)
/* QL:         move.l  sp,d7 */
    move.l sp,d7
/* QL:         and.w   #$8000,d7 */
    and.w #0x8000,d7
/* QL:         move.l  d7,a6           do not assume there is only one screen */
    move.l d7,a6
/* QL:         move.l  M20_sv_jbpnt(a6),a5 get pointer to job */
    move.l M20_sv_jbpnt(a6),a5
/* QL:         move.l  (a5),a5 */
    move.l (a5),a5
/* QL:         tas     M20_jb_rela6(a5)    set msb of flag */
    tas M20_jb_rela6(a5)
/* QL:         jmp     ss_rte(pc) */
    jmp ss_rte(pc)
/* QL:         end */
