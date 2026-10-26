/* ROM section mt_trapv */
.balign 2,0
/* QL: * d1 -i o- job id (-1 = self) */
/* QL: * a0 -  o- base address of job */
/* QL: * a1 -i  - new pointer */
/* QL: mt_trapv */
mt_trapv:
/* QL:         jsr     ss_jobx(pc)     get current job pointer */
    jsr ss_jobx(pc)
/* QL:         sub.w   #M28_sv_trapo,a1    adjust trap vector */
    sub.w #M28_sv_trapo,a1
/* QL:         move.l  a1,M28_sv_trapv(a6) and set the system vector */
    move.l a1,M28_sv_trapv(a6)
/* QL:         move.l  a1,M28_jb_trapv(a0) ... and the per job vector */
    move.l a1,M28_jb_trapv(a0)
/* QL:         jmp     ss_noer(pc) */
    jmp ss_noer(pc)
/* QL:         end */
