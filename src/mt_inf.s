/* ROM section mt_inf */
.balign 2,0
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- this job id */
/* QL: * d2 -  o- version number (ascii) */
/* QL: * a0 -  o- pointer to system variables */
/* QL: mt_inf */
mt_inf:
/* QL:         moveq   #-1,d1          current job number */
    moveq #(-1),d1
/* QL:         jsr     ss_jobx(pc)     sort it out */
    jsr ss_jobx(pc)
/* QL:         move.l  M24_sv_chtop(a6),a0 */
    move.l M24_sv_chtop(a6),a0
/* QL:         move.l  M24_sx_qdos(a0),d2  version number */
    move.l M24_sx_qdos(a0),d2
/* QL:         move.l  a6,a0           pointer to system variables */
    move.l a6,a0
/* QL:         jmp     ss_noer(pc) */
    jmp ss_noer(pc)
/* QL: * d0 -  o- system variables address */
/* QL: * a2 -ip - code to be called in supervisor mode */
/* QL: * Actually, any registers may be altered by the called code */
/* QL: * The code at (a2) is entered with d0 holding a copy of the system variables */
/* QL: * base address and all other registers as they were at the trap. */
/* QL: * It should do an "rte" when it has completed. */
/* QL: mt_extop */
mt_extop:
/* QL:         move.l  a6,d0           let the caller have a copy of the sysvars base */
    move.l a6,d0
/* QL:         movem.l (sp)+,d7/a5-a6  reload caller's registers */
    movem.l (sp)+,d7/a5-a6
/* QL:         jmp     (a2)            go do it */
    jmp (a2)
/* QL:         end */
