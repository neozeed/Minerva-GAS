/* ROM section mm_mvjob */
.balign 2,0
/* QL: * d0 -  o- 0 & ccr=z */
/* QL: * d1 -i o- distance basic is wanted to move up. this will be rounded down. */
/* QL: * d3 -  o- copy of d1 */
/* QL: * a0 -  o- pointer to new base of job 0 */
/* QL: * a1 -  o- pointer to old base of job 0 */
/* QL: * a5 -ip - pointer to trap level stack */
/* QL: * a6 -ip - pointer to system variables */
/* QL: * a3 destroyed */
/* QL: mm_mubas */
mm_mubas:
/* QL:         jsr     mm_retop(pc)    return space (new basic pointer in a0) */
    jsr mm_retop(pc)
/* QL:         bra.s   M55_domove */
    bra.s M55_domove
/* QL: * d0 -  o- error code -> ccr (if not zero, registers d1-d3/a0-a3 are undefined) */
/* QL: * d1 -i o- distance basic is wanted to move down. this will be rounded up. */
/* QL: * d3 -  o- copy of d1 */
/* QL: * a0 -  o- pointer to new base of job 0 */
/* QL: * a1 -  o- pointer to old base of job 0 */
/* QL: * a5 -ip - pointer to trap level stack */
/* QL: * a6 -ip - pointer to system variables */
/* QL: * d2/a2-a3 destroyed */
/* QL: mm_mdbas */
mm_mdbas:
/* QL:         jsr     mm_altop(pc)    allocate space (new basic pointer in a0) */
    jsr mm_altop(pc)
/* QL:         bne.s   M55_rts0 */
    bne.s M55_rts0
/* QL: M55_domove */
M55_domove:
/* QL:         move.l  d1,d3           hold onto d1 */
    move.l d1,d3
/* QL:         move.l  M55_sv_trnsp(a6),d1 top of basic */
    move.l M55_sv_trnsp(a6),d1
/* QL:         move.l  M55_sv_jbbas(a6),a3 fetch pointer to job 0 entry in job table */
    move.l M55_sv_jbbas(a6),a3
/* QL:         sub.l   (a3),d1         number of bytes to move */
    sub.l (a3),d1
/* QL: * d0 -  o- 0 (and ccr=z) */
/* QL: * d1 -i o- size of area to be moved / value from d3 */
/* QL: * d3 -ip - value to return in d1 */
/* QL: * a0 -ip - new position of job */
/* QL: * a1 -  o- old position of job */
/* QL: * a3 -i  - pointer to job table entry for job to be moved */
/* QL: mm_mvjob */
mm_mvjob:
/* QL:         move.l  (a3),a1         get old position of job */
    move.l (a3),a1
/* QL:         move.l  a0,(a3)         set new position of job */
    move.l a0,(a3)
/* QL:         jsr     mm_move(pc)     move it */
    jsr mm_move(pc)
/* QL:         move.l  a1,d0 */
    move.l a1,d0
/* QL:         sub.l   a0,d0           distance travelled */
    sub.l a0,d0
/* QL:         sub.l   d0,M55_jb_a0+6*4(a0) update stored a6 */
    sub.l d0,(M55_jb_a0+(6*4))(a0)
/* QL:         sub.l   d0,M55_jb_a0+7*4(a0) update stored usp */
    sub.l d0,(M55_jb_a0+(7*4))(a0)
/* QL: * Check if this is called from job that is itself moving!!!! */
/* QL: * If so, we have to modify a6 which is somewhere on the stack!!! */
/* QL:         cmp.l   M55_sv_jbpnt(a6),a3 is it the current job moving? */
    cmp.l M55_sv_jbpnt(a6),a3
/* QL:         bne.s   M55_stk_ok */
    bne.s M55_stk_ok
/* QL:         sub.l   d0,8(a5)        update a6 on the stack */
    sub.l d0,8(a5)
/* QL:         move    usp,a3          move the stack pointer as well */
    move usp,a3
/* QL:         sub.l   d0,a3 */
    sub.l d0,a3
/* QL:         move    a3,usp */
    move a3,usp
/* QL: M55_stk_ok */
M55_stk_ok:
/* QL:         move.l  d3,d1           set return value */
    move.l d3,d1
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M55_rts0 */
M55_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
