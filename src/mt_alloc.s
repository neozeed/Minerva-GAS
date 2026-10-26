/* ROM section mt_alloc */
.balign 2,0
/* QL: * d0 -  o- error code */
/* QL: * d1 -i o- space to be allocated / actual space allocated */
/* QL: * a0 -i o- rel a6 pointer to free space pointer / rel a6 base of area allocated */
/* QL: * a6 -ip - base address */
/* QL: * d2-d3/a1-a2 destroyed */
/* QL: mt_alloc */
mt_alloc:
/* QL:         add.l   8(sp),a0        make a0 absolute */
    add.l 8(sp),a0
/* QL:         jsr     mm_alloc(pc) */
    jsr mm_alloc(pc)
/* QL:         sub.l   8(sp),a0        make a0 relative */
    sub.l 8(sp),a0
/* QL:         bra.s   M30_rte1 */
    bra.s M30_rte1
/* QL: * d1 -i  - length of space to be freed */
/* QL: * a0 -i  - rel a6 base of new area to be freed */
/* QL: * a1 -i  - rel a6 pointer to pointer to free space */
/* QL: * a6 -ip - base address */
/* QL: * d2/a2-a2 destroyed */
/* QL: mt_lnkfr */
mt_lnkfr:
/* QL:         add.l   8(sp),a0        make a0 absolute */
    add.l 8(sp),a0
/* QL:         add.l   8(sp),a1        make a1 absolute */
    add.l 8(sp),a1
/* QL:         jsr     mm_lnkfr(pc) */
    jsr mm_lnkfr(pc)
/* QL: M30_rte1 */
M30_rte1:
/* QL:         jmp     ss_rte(pc) */
    jmp ss_rte(pc)
/* QL: * d0 -  o- error code */
/* QL: * d1 -i o- bytes required / bytes allocated */
/* QL: * d2 -i  - owner job id (-1 for self) */
/* QL: * a0 -  o- address of area allocated, after the heap header */
/* QL: M30_dropres */
M30_dropres:
/* QL:         jsr     mm_retrn(pc)    give back failed job 0 respr */
    jsr mm_retrn(pc)
/* QL:         move.l  d7,d1           restore size */
    move.l d7,d1
/* QL: M30_mychp */
M30_mychp:
/* QL:         moveq   #-1,d2          allocate to self */
    moveq #(-1),d2
/* QL: mt_alchp */
mt_alchp:
/* QL:         moveq   #M30_err.bp,d0      could we be in for a shock? */
    moveq #M30_err.bp,d0
/* QL:         move.l  d1,d7           save requested length */
    move.l d1,d7
/* QL:         bmi.s   M30_rte1            if negative, this is silly! */
    bmi.s M30_rte1
/* QL:         bne.s   M30_sensible */
    bne.s M30_sensible
/* QL:         moveq   #8,d7           zero's pretty lunatic too... make it minimum */
    moveq #8,d7
/* QL: M30_sensible */
M30_sensible:
/* QL:         move.l  d2,d1           put job number in expected hole */
    move.l d2,d1
/* QL:         jsr     ss_jobx(pc)     does job exist? */
    jsr ss_jobx(pc)
/* QL:         exg     d1,d7           get back length and save job number for later */
    exg d1,d7
/* QL:         moveq   #M30_hp_end,d2      include space for heap header */
    moveq #M30_hp_end,d2
/* QL:         add.l   d2,d1 */
    add.l d2,d1
/* QL:         jsr     mm_alchp(pc)    allocate space */
    jsr mm_alchp(pc)
/* QL:         bne.s   M30_rte1 */
    bne.s M30_rte1
/* QL:         addq.l  #M30_hp_drivr,a0 */
    addq.l #M30_hp_drivr,a0
/* QL:         move.l  M30_sv_chtop(a6),(a0)+ set 'driver' (mm_rechp ptr is at this + $c) */
    move.l M30_sv_chtop(a6),(a0)+
/* QL:         assert  M30_hp_drivr,M30_hp_owner-4 */
/* original assertion: M30_hp_drivr,M30_hp_owner-4 */
/* QL:         move.l  d7,(a0)         set owner (flag address already cleared) */
    move.l d7,(a0)
/* QL:         addq.l  #M30_hp_end-M30_hp_owner,a0 move past heap header header */
.word 20616|((((M30_hp_end-M30_hp_owner))&7)<<9)
/* QL:         bra.s   M30_noer */
    bra.s M30_noer
/* QL: * d0 -  o- 0 */
/* QL: * a0 -i  - base of area to be freed, after heap header */
/* QL: mt_rechp */
mt_rechp:
/* QL:         lea     -M30_hp_end(a0),a0  backspace pointer to true start of entry */
    lea (-M30_hp_end)(a0),a0
/* QL:         jsr     mm_rechp(pc) */
    jsr mm_rechp(pc)
/* QL:         bra.s   M30_noer */
    bra.s M30_noer
/* QL: * d0 -  o- error code */
/* QL: * d1 -i o- number of bytes required, rounded up to a multiple of 16 */
/* QL: * a0 -  o- base address of area allocated */
/* QL: * d2-d3/a1-a3 destroyed (except when d1 is zero) */
/* QL: mt_alres */
mt_alres:
/* QL:         move.l  M30_sv_respr(a6),a0 */
    move.l M30_sv_respr(a6),a0
/* QL:         move.l  d1,d7           any space to be allocated? */
    move.l d1,d7
/* QL:         ble.s   M30_noer            no, just tell caller where respr starts */
    ble.s M30_noer
/* QL:         bsr.s   M30_basptr */
    bsr.s M30_basptr
/* QL:         cmp.l   M30_sv_jbbas(a6),a3 who's actually asking for the memory? */
    cmp.l M30_sv_jbbas(a6),a3
/* QL:         bne.s   M30_mychp           if not job 0, get the space from the chp */
    bne.s M30_mychp
/* QL:         jsr     mm_altrn(pc)    allocate area, temporarily in transient area */
    jsr mm_altrn(pc)
/* QL:         bne.s   M30_rte2            no space - too bad */
    bne.s M30_rte2
/* QL:         move.l  M30_sv_respr(a6),a1 */
    move.l M30_sv_respr(a6),a1
/* QL:         sub.l   d1,a1 */
    sub.l d1,a1
/* QL:         cmp.l   a0,a1           have we got the space right at the top? */
    cmp.l a0,a1
/* QL:         bgt.s   M30_dropres         no - throw it away, then try chp */
    bgt.s M30_dropres
/* QL:         bne.s   M30_noer            if even higher, assume extra memory linked in! */
    bne.s M30_noer
/* QL:         move.l  a0,M30_sv_respr(a6) set bottom of resident proc area */
    move.l a0,M30_sv_respr(a6)
/* QL: M30_noer */
M30_noer:
/* QL:         jmp     ss_noer(pc) */
    jmp ss_noer(pc)
/* QL: * N.B. This functional M30_mt.reres version always succeeds! I can't think of any */
/* QL: * reason why it should fail. If the transient area is empty, sb moves up to */
/* QL: * the top of memory. If the transient area is not empty, extra space goes to */
/* QL: * it. If any extensions are present, the system crashes... but we knew that! */
/* QL: * As previous incarnations never worked, I suspect it might be an idea to */
/* QL: * allow the caller to specify (in d1.l) how much to release. */
/* QL: * d0 -  o- 0 */
/* QL: * d1-d3/a0-a3 destroyed */
/* QL: mt_reres */
mt_reres:
/* QL:         assert  M30_sv_respr,M30_sv_ramt-4 */
/* original assertion: M30_sv_respr,M30_sv_ramt-4 */
/* QL:         movem.l M30_sv_respr(a6),a0-a1 */
    movem.l M30_sv_respr(a6),a0-a1
/* QL:         move.l  a1,d7 */
    move.l a1,d7
/* QL:         sub.l   a0,d7           size of resident area */
    sub.l a0,d7
/* QL:         beq.s   M30_noer            if nothing there, forget it! */
    beq.s M30_noer
/* QL:         move.l  a1,M30_sv_respr(a6) junk resident area */
    move.l a1,M30_sv_respr(a6)
/* QL:         move.l  d7,(a0)         make resident area look like a transient slot */
    move.l d7,(a0)
/* QL: M30_retrn */
M30_retrn:
/* QL:         jsr     mm_retrn(pc)    return space to transient area */
    jsr mm_retrn(pc)
/* QL: M30_endreb */
M30_endreb:
/* QL:         move.l  d7,d1 */
    move.l d7,d1
/* QL:         bra.s   M30_noer */
    bra.s M30_noer
/* QL: * The criterion applied for the M30_albas/M30_rebas calls has to be a bit finicky. */
/* QL: * The "grabber" technique for limiting the amount of memory taken up by a job */
/* QL: * involves the pretty dirty trick of allocating the space to job zero, letting */
/* QL: * the job get under way, then releasing the space. */
/* QL: * Unhappily, all the slave blocks get cleaned out in the process! */
/* QL: * There is, unfortunately, no other way to acheive the desired effect, as the */
/* QL: * job may acquire its space from both the common heap and the transient area, */
/* QL: * and job 0 is the only area that can shuffle about to accomodate both. */
/* QL: * ccr-  o- non-zero iff caller is a multibasic job */
/* QL: * a1 -  o- job table entry address of current job */
/* QL: * a2 -  o- header address of current job */
/* QL: M30_basptr */
M30_basptr:
/* QL:         move.l  M30_sv_jbpnt(a6),a3 get current job entry pointer */
    move.l M30_sv_jbpnt(a6),a3
/* QL:         move.l  (a3),a1         get current job's header address */
    move.l (a3),a1
/* QL:         cmp.l   M30_sv_jbbas(a6),a3 is this really job 0? */
    cmp.l M30_sv_jbbas(a6),a3
/* QL:         beq.s   M30_rts0            yes - return ccr = z */
    beq.s M30_rts0
/* QL:         btst    #M30_bv..int,M30_jb_rela6(a1) only multibasic tasks return non-zero ccr */
    btst #M30_bv..int,M30_jb_rela6(a1)
/* QL: M30_rts0 */
M30_rts0:
/* QL:         rts */
    rts 
/* QL: * d1 -i o- space to be taken off top of interpreter job / actual space removed */
/* QL: * a6 -i o- base address */
/* QL: * a7 -i o- user stack pointer */
/* QL: * d0/d2-d3/a0-a3 destroyed */
/* QL: mt_rebas */
mt_rebas:
/* QL:         move.l  d1,d7           hold on to space being released */
    move.l d1,d7
/* QL:         beq.s   M30_rte2            do nothing if space released is zero */
    beq.s M30_rte2
/* QL:         bsr.s   M30_basptr */
    bsr.s M30_basptr
/* QL:         bne.s   M30_rebas           caller is a multibasic task - go handle it */
    bne.s M30_rebas
/* QL:         lea     M30_sv_trnsp(a6),a2 */
    lea M30_sv_trnsp(a6),a2
/* QL:         move.l  (a2),a0 */
    move.l (a2),a0
/* QL:         sub.l   d1,a0           new top of job 0 */
    sub.l d1,a0
/* QL:         move.l  d1,(a0)         make tail end look like an in-use trn bit */
    move.l d1,(a0)
/* QL:         move.l  a0,(a2)         now trn moves down */
    move.l a0,(a2)
/* QL: M30_retrn1 */
M30_retrn1:
/* QL:         bra.s   M30_retrn           release the spare bit (it might coalesce) */
    bra.s M30_retrn
/* QL: M30_rebas */
M30_rebas:
/* QL:         move.l  a1,a0 */
    move.l a1,a0
/* QL:         add.l   (a1),a0         current top of job */
    add.l (a1),a0
/* QL:         sub.l   d1,a0           new top of job */
    sub.l d1,a0
/* QL:         move.l  d1,(a0)         make tail end look like an in-use trn bit */
    move.l d1,(a0)
/* QL:         sub.l   d1,(a1)         now we're shorter */
    sub.l d1,(a1)
/* QL:         jsr     mm_retrn(pc)    release it */
    jsr mm_retrn(pc)
/* QL:         bsr.s   M30_basptr */
    bsr.s M30_basptr
/* QL:         move.l  (a1),d1         get our new length */
    move.l (a1),d1
/* QL:         jsr     mm_whtrn(pc)    is there somewhere else we could go? */
    jsr mm_whtrn(pc)
/* QL:         beq.s   M30_endreb          no - leave that as it is */
    beq.s M30_endreb
/* QL:         jsr     mm_gotrn(pc)    yes - take it */
    jsr mm_gotrn(pc)
/* QL:         bra.s   M30_moveme          go move there */
    bra.s M30_moveme
/* QL: * d1 -i o- space to be added to top of interpreter job / actual space added */
/* QL: * a6 -i o- base address */
/* QL: * a7 -i o- user stack pointer */
/* QL: * d0/d2-d3/a0-a3 destroyed */
/* QL: mt_albas */
mt_albas:
/* QL:         bsr.s   M30_basptr */
    bsr.s M30_basptr
/* QL:         bne.s   M30_albas           caller is a multibasic task - go handle it */
    bne.s M30_albas
/* QL:         jsr     mm_mdbas(pc)    move down job 0 */
    jsr mm_mdbas(pc)
/* QL: M30_rte2 */
M30_rte2:
/* QL:         jmp     ss_rte(pc) */
    jmp ss_rte(pc)
/* QL: * rats. our attempt to expand the current job's area didn't work! */
/* QL: M30_givein */
M30_givein:
/* QL:         move.l  d1,d7           remember the extra required */
    move.l d1,d7
/* QL:         add.l   (a1),d1         add old length to extra required */
    add.l (a1),d1
/* QL:         jsr     mm_altrn(pc) */
    jsr mm_altrn(pc)
/* QL:         bne.s   M30_rte2            ouch! no memory */
    bne.s M30_rte2
/* QL: M30_moveme */
M30_moveme:
/* QL:         bsr.s   M30_basptr */
    bsr.s M30_basptr
/* QL:         move.l  (a1),d1         fetch old length */
    move.l (a1),d1
/* QL:         move.l  (a0),d3         we want to patch back in the new length */
    move.l (a0),d3
/* QL:         jsr     mm_mvjob(pc)    move the job */
    jsr mm_mvjob(pc)
/* QL:         move.l  d3,(a0)         put correct length back */
    move.l d3,(a0)
/* QL:         move.l  a1,a0           release old position */
    move.l a1,a0
/* QL:         bra.s   M30_retrn1 */
    bra.s M30_retrn1
/* QL: * We look here for preceeding and following free areas that we can incorporate. */
/* QL: * The simpler techniques were fairly awful. */
/* QL: * It will be clever to shuffle other basics to make space! */
/* QL: * We have to round up d1 same as altrn would... */
/* QL: * This should all be proper routines in the mm library. */
/* QL: M30_albas */
M30_albas:
/* QL:         subq.l  #1,d1 */
    subq.l #1,d1
/* QL:         or.b    #16-1,d1 */
    or.b #((16-1)&255),d1
/* QL:         addq.l  #1,d1 */
    addq.l #1,d1
/* QL:         ble.s   M30_rte2            get out if silly request */
    ble.s M30_rte2
/* QL:         move.l  (a1),d0 */
    move.l (a1),d0
/* QL:         add.l   a1,d0           top edge of current area */
    add.l a1,d0
/* QL:         moveq   #0,d2           start by showing no following spare space */
    moveq #0,d2
/* QL:         lea     M30_sv_trnfr-M30_hp_next(a6),a0 */
    lea (M30_sv_trnfr-M30_hp_next)(a6),a0
/* QL:         sub.l   a2,a2           remember not to count trnfr as a free space! */
    sub.l a2,a2
/* QL: M30_scntrn */
M30_scntrn:
/* QL:         move.l  a2,d7 */
    move.l a2,d7
/* QL:         move.l  a0,a2 */
    move.l a0,a2
/* QL:         move.l  M30_hp_next(a0),d3 */
    move.l M30_hp_next(a0),d3
/* QL:         beq.s   M30_scnex           end of free list, so no space above us */
    beq.s M30_scnex
/* QL:         add.l   d3,a0 */
    add.l d3,a0
/* QL:         cmp.l   d0,a0 */
    cmp.l d0,a0
/* QL:         bcs.s   M30_scntrn          carry on until we reach our top edge */
    bcs.s M30_scntrn
/* QL:         bne.s   M30_scnex */
    bne.s M30_scnex
/* QL:         move.l  (a0),d2         if exactly on top edge, remember size as useful */
    move.l (a0),d2
/* QL: M30_scnex */
M30_scnex:
/* QL: * We've found any free transient space around us. */
/* QL:         sub.l   d1,d2           how does the space above look? */
    sub.l d1,d2
/* QL:         beq.s   M30_stealit         exact fit - go take the whole space above */
    beq.s M30_stealit
/* QL:         bpl.s   M30_split           more than enough room above - take some */
    bpl.s M30_split
/* QL:         move.l  d7,d3           do we have a preceeding space? */
    move.l d7,d3
/* QL:         beq.s   M30_givein          no - can't fit job in same patch */
    beq.s M30_givein
/* QL:         move.l  (a2),d3         size of preceeding piece */
    move.l (a2),d3
/* QL:         add.l   a2,d3           end of preceeding bit */
    add.l a2,d3
/* QL:         cmp.l   d3,a1           is it the immediately preceeding area? */
    cmp.l d3,a1
/* QL:         bne.s   M30_givein          no - once again, this patch is too small */
    bne.s M30_givein
/* QL:         sub.l   a2,d3           ok, so keep this length */
    sub.l a2,d3
/* QL:         add.l   d2,d3           count off how much more we needed */
    add.l d2,d3
/* QL:         bmi.s   M30_givein          still not enough, so give up completely */
    bmi.s M30_givein
/* QL: * With space before, and maybe the space after, we have enough room. */
/* QL:         add.l   d1,d2           put back size of space above */
    add.l d1,d2
/* QL:         beq.s   M30_joined          if there was a useful space above ... */
    beq.s M30_joined
/* QL:         bsr.s   M30_unlink          ... M30_unlink free space at a0 pointed to from a2 */
    bsr.s M30_unlink
/* QL: M30_joined */
M30_joined:
/* QL:         move.l  a2,a0           now point at preceeding free space */
    move.l a2,a0
/* QL:         move.l  d3,(a0)         put leftover length, do we have an exact fit? */
    move.l d3,(a0)
/* QL:         bne.s   M30_prevset         no - that's done */
    bne.s M30_prevset
/* QL:         move.l  d7,a2           we have to go back one more to M30_unlink this */
    move.l d7,a2
/* QL:         bsr.s   M30_unlink          M30_unlink free space at a0 pointed to from a2 */
    bsr.s M30_unlink
/* QL: M30_prevset */
M30_prevset:
/* QL:         add.l   d3,a0           new position */
    add.l d3,a0
/* QL:         move.l  d1,d3           we want this back */
    move.l d1,d3
/* QL:         move.l  (a1),d1         current size */
    move.l (a1),d1
/* QL:         jsr     mm_mvjob(pc)    move the job to its new position */
    jsr mm_mvjob(pc)
/* QL:         bra.s   M30_doneit          that's all folks! */
    bra.s M30_doneit
/* QL: M30_unlink */
M30_unlink:
/* QL:         move.l  M30_hp_next(a0),d2  get forward link */
    move.l M30_hp_next(a0),d2
/* QL:         beq.s   M30_putit           if there's nothing beyond, just say that */
    beq.s M30_putit
/* QL:         add.l   a0,d2 */
    add.l a0,d2
/* QL:         sub.l   a2,d2 */
    sub.l a2,d2
/* QL: M30_putit */
M30_putit:
/* QL:         move.l  d2,M30_hp_next(a2) */
    move.l d2,M30_hp_next(a2)
/* QL:         rts */
    rts 
/* QL: * We need to M30_split the area, 'cos it's bigger than we want... */
/* QL: * Note that we avoid moving ourselves about the place if we don't have to. */
/* QL: M30_split */
M30_split:
/* QL:         move.l  M30_hp_next(a0),d0  get forward link */
    move.l M30_hp_next(a0),d0
/* QL:         beq.s   M30_nosub           if it's zero, leave it */
    beq.s M30_nosub
/* QL:         sub.l   d1,d0           otherwise we get closer, so want a shorter link */
    sub.l d1,d0
/* QL: M30_nosub */
M30_nosub:
/* QL:         add.l   d1,a0           this is where the remainder goes */
    add.l d1,a0
/* QL:         move.l  d2,(a0)+        set it's length */
    move.l d2,(a0)+
/* QL:         move.l  d0,(a0)+        set it's link */
    move.l d0,(a0)+
/* QL:         clr.l   (a0)            and make it owned by job 0 */
    clr.l (a0)
/* QL:         add.l   d1,M30_hp_next(a2)  finally, move prior link forward */
    add.l d1,M30_hp_next(a2)
/* QL:         bra.s   M30_samepos */
    bra.s M30_samepos
/* QL: * By amazing coincidence, the space was just the size we wanted. take it! */
/* QL: M30_stealit */
M30_stealit:
/* QL:         bsr.s   M30_unlink          M30_unlink free space at a0 pointed to from a2 */
    bsr.s M30_unlink
/* QL: M30_samepos */
M30_samepos:
/* QL:         move.l  a1,a0           we haven't actually moved... */
    move.l a1,a0
/* QL: M30_doneit */
M30_doneit:
/* QL:         add.l   d1,(a0)         say we've got bigger */
    add.l d1,(a0)
/* QL:         jmp     ss_noer(pc)     done! */
    jmp ss_noer(pc)
/* QL:         end */
