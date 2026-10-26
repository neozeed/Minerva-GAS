/* ROM section io_fopen */
.balign 2,0
/* QL: * General file system open routine. Access key in d3 is 0..4. */
/* QL: * Routine used by M13_io.open trap (2) after non file devices have been checked. */
/* QL: * Also used for M13_io.delet trap with special value ($ff) in d3. */
/* QL: * d0 -  o- error flag */
/* QL: * d3 -ip - access key, or $ff for delete */
/* QL: * a0 -i o- pointer to name / pointer to definition block */
/* QL: * a2 -  o- address of driver */
/* QL: reglist reg     d1-d6/a3-a6 */
/* QL: io_fopen */
io_fopen:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d6/a3-a6,-(sp)
/* QL: * First find the driver */
/* QL: * (This moved to start by lwr - why allocate the channel when you haven't even */
/* QL: * got a driver, or a physical definition block, yet! Saves chp fragments too!) */
/* QL:         move.l  a0,a5           save the name pointer for later on */
    move.l a0,a5
/* QL:         jsr     io_fdriv(pc)    get all lookup's over with */
    jsr io_fdriv(pc)
/* QL:         bmi.s   M13_exit            that device was not found */
    bmi.s M13_exit
/* QL:         beq.s   M13_physok          zero means we already have physical defn ready */
    beq.s M13_physok
/* QL:         move.l  d5,d0           fdriv left the free slot in d5... or M13_err.no */
    move.l d5,d0
/* QL:         bmi.s   M13_exit */
    bmi.s M13_exit
/* QL:         lsl.l   #2,d0 */
    lsl.l #2,d0
/* QL:         add.l   d0,a4           ready to record new physdef */
    add.l d0,a4
/* QL:         move.b  d5,d4           note: new slot number moved to d4 */
    move.b d5,d4
/* QL:         move.b  d1,d5 */
    move.b d1,d5
/* QL:         move.l  M13_ch_dflen(a2),d1 get length of physical definition block */
    move.l M13_ch_dflen(a2),d1
/* QL:         jsr     mm_alchp(pc)    allocate space, now preserves registers */
    jsr mm_alchp(pc)
/* QL:         bne.s   M13_exit */
    bne.s M13_exit
/* QL:         move.l  a0,a1           set physdef address */
    move.l a0,a1
/* QL:         move.l  a2,M13_fs_drivr(a1) set driver */
    move.l a2,M13_fs_drivr(a1)
/* QL:         move.b  d5,M13_fs_drivn(a1) ... and drive number */
    move.b d5,M13_fs_drivn(a1)
/* QL:         move.l  a1,(a4)         put address in physdef list */
    move.l a1,(a4)
/* QL: M13_physok */
M13_physok:
/* QL: * Allocate file channel definition block */
/* QL:         moveq   #M13_fs_end>>1,d1 */
    moveq #(M13_fs_end>>1),d1
/* QL:         add.b   d1,d1 */
    add.b d1,d1
/* QL:         jsr     mm_alchp(pc) */
    jsr mm_alchp(pc)
/* QL:         bne.s   M13_exit */
    bne.s M13_exit
/* QL: * From now on, all pointers point to M13_fs_next within the block */
/* QL:         add.w   #M13_fs_next,a0 */
    add.w #M13_fs_next,a0
/* QL: * Link this definition block into list */
/* QL:         lea     M13_sv_fslst(a6),a3 (used to use ut_link, but we'd like to keep a1) */
    lea M13_sv_fslst(a6),a3
/* QL:         move.l  (a3),(a0)       put pointer to next in this item */
    move.l (a3),(a0)
/* QL:         move.l  a0,(a3)         and link it in */
    move.l a0,(a3)
/* QL: * Put drive id, access key and name into fs */
/* QL:         move.b  d4,M13_fs_drive-M13_fs_next(a0) drive id */
    move.b d4,(M13_fs_drive-M13_fs_next)(a0)
/* QL:         move.b  d3,M13_fs_acces-M13_fs_next(a0) access key */
    move.b d3,(M13_fs_acces-M13_fs_next)(a0)
/* QL:         lea     M13_fs_fname-M13_fs_next(a0),a4 */
    lea (M13_fs_fname-M13_fs_next)(a0),a4
/* QL:         move.w  (a5)+,d0        get name length */
    move.w (a5)+,d0
/* QL:         move.w  M13_ch_drnam(a2),d2 ... and drive name length */
    move.w M13_ch_drnam(a2),d2
/* QL:         addq.w  #2,d2           ... skipping over n_ */
    addq.w #2,d2
/* QL:         add.w   d2,a5           move pointer on */
    add.w d2,a5
/* QL:         sub.w   d2,d0           ... and reduce length of name */
    sub.w d2,d0
/* QL:         move.w  d0,(a4)+        put name length in block */
    move.w d0,(a4)+
/* QL:         cmp.w   #M13_fs.nmlen,d0 */
    cmp.w #M13_fs.nmlen,d0
/* QL:         bls.s   M13_end_name        we allow 0..fs.name, anything else is trash */
    bls.s M13_end_name
/* QL:         moveq   #M13_err.bn,d5      negative or too long is a bad name */
    moveq #M13_err.bn,d5
/* QL: M13_err_d5 */
M13_err_d5:
/* QL:         bsr.s   M13_relch           unlink and release definition block */
    bsr.s M13_relch
/* QL:         move.l  d5,d0           set error key */
    move.l d5,d0
/* QL: M13_exit */
M13_exit:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d6/a3-a6
/* QL:         rts */
    rts 
/* QL: io_relch */
io_relch:
/* QL:         add.w   #M13_fs_next,a0     point to link in block */
    add.w #M13_fs_next,a0
/* QL: M13_relch */
M13_relch:
/* QL:         lea     M13_sv_fslst(a6),a1 unlink definition block from list */
    lea M13_sv_fslst(a6),a1
/* QL:         jsr     ut_unlnk(pc) */
    jsr ut_unlnk(pc)
/* QL:         sub.w   #M13_fs_next,a0     reset to base of block */
    sub.w #M13_fs_next,a0
/* QL:         jmp     mm_rechp(pc)    free definition block */
    jmp mm_rechp(pc)
/* QL: M13_mov_name */
M13_mov_name:
/* QL:         move.b  (a5)+,(a4)+     copy the file name part into the channel */
    move.b (a5)+,(a4)+
/* QL: M13_end_name */
M13_end_name:
/* QL:         dbra    d0,M13_mov_name */
    dbra d0,M13_mov_name
/* QL: * Now we check if there is already a file open with the same name */
/* QL:         move.l  a1,a5           save pointer to definition block */
    move.l a1,a5
/* QL:         move.l  a0,a1           start at next block in list */
    move.l a0,a1
/* QL: M13_next_dup */
M13_next_dup:
/* QL:         move.l  (a1),a1         next block */
    move.l (a1),a1
/* QL:         move.l  a1,d0 */
    move.l a1,d0
/* QL:         beq.s   M13_end_dup         end of list */
    beq.s M13_end_dup
/* QL:         cmp.b   M13_fs_drive-M13_fs_next(a1),d4 is this same drive */
    cmp.b (M13_fs_drive-M13_fs_next)(a1),d4
/* QL:         bne.s   M13_next_dup */
    bne.s M13_next_dup
/* QL:         moveq   #1,d0           comparison type 1 */
    moveq #1,d0
/* QL:         moveq   #M13_fs_fname-M13_fs_next,d5 */
    moveq #(M13_fs_fname-M13_fs_next),d5
/* QL:         exg     d5,a6           offset of name in block */
    exg d5,a6
/* QL:         jsr     ut_cstr(pc)     compare names */
    jsr ut_cstr(pc)
/* QL:         exg     d5,a6           restore system variables base */
    exg d5,a6
/* QL:         bne.s   M13_next_dup        no match - try next */
    bne.s M13_next_dup
/* QL: * A matching file name has been found - check for access conflict */
/* QL:         moveq   #M13_err.ex,d5 */
    moveq #M13_err.ex,d5
/* QL:         moveq   #M13_io.new,d0 */
    moveq #M13_io.new,d0
/* QL:         sub.b   M13_fs_acces-M13_fs_next(a0),d0 is open 'new'? */
    sub.b (M13_fs_acces-M13_fs_next)(a0),d0
/* QL:         beq.s   M13_err_d5          ... yes and so error - exists */
    beq.s M13_err_d5
/* QL:         moveq   #M13_err.iu,d5 */
    moveq #M13_err.iu,d5
/* QL:         subq.b  #M13_io.new-M13_io.share,d0 is open 'share'? */
.word 20736|((((M13_io.new-M13_io.share))&7)<<9)
/* QL:         bne.s   M13_err_d5          ... no and so error - in use */
    bne.s M13_err_d5
/* QL:         cmp.b   #M13_io.share,M13_fs_acces-M13_fs_next(a1) is other channel 'share'? */
    cmp.b #(M13_io.share&255),(M13_fs_acces-M13_fs_next)(a1)
/* QL: M13_err_d5n */
M13_err_d5n:
/* QL:         bne.s   M13_err_d5          ... no and so error - in use */
    bne.s M13_err_d5
/* QL: * file is already open - so we can copy block to save directory seach */
/* QL:         move.w  M13_fs_filnr-M13_fs_next(a1),M13_fs_filnr-M13_fs_next(a0) */
    move.w (M13_fs_filnr-M13_fs_next)(a1),(M13_fs_filnr-M13_fs_next)(a0)
/* QL:         assert  M13_fs_eblok,M13_fs_ebyte-2 */
/* original assertion: M13_fs_eblok,M13_fs_ebyte-2 */
/* QL:         move.l  M13_fs_eblok-M13_fs_next(a1),M13_fs_eblok-M13_fs_next(a0) */
    move.l (M13_fs_eblok-M13_fs_next)(a1),(M13_fs_eblok-M13_fs_next)(a0)
/* QL:         move.w  #M13_fs.hdlen,M13_fs_nbyte-M13_fs_next(a0) set initial byte pointer */
    move.w #M13_fs.hdlen,(M13_fs_nbyte-M13_fs_next)(a0)
/* QL: M13_end_dup */
M13_end_dup:
/* QL:         move.l  a5,a1           restore pointer to definition block */
    move.l a5,a1
/* QL:         tst.w   M13_fs_filnr-M13_fs_next(a0) has a duplicate file been found */
    tst.w (M13_fs_filnr-M13_fs_next)(a0)
/* QL:         bne.s   M13_exit_ok         yes - all done */
    bne.s M13_exit_ok
/* QL: * Device dependent open */
/* QL:         movem.l a0-a2,-(sp)     save pointers */
    movem.l a0-a2,-(sp)
/* QL:         sub.w   #M13_fs_next,a0     reset a0 so driver will understand it */
    sub.w #M13_fs_next,a0
/* QL:         lea     -M13_sv_lio(a2),a3  get base of driver definition */
    lea (-M13_sv_lio)(a2),a3
/* QL:         move.l  M13_ch_open(a2),a4  ... and open entry address */
    move.l M13_ch_open(a2),a4
/* QL:         jsr     (a4)            ... go */
    jsr (a4)
/* QL:         movem.l (sp)+,a0-a2     (driver can even scrud a0 now...) */
    movem.l (sp)+,a0-a2
/* QL:         move.l  d0,d5           was there an error? */
    move.l d0,d5
/* QL:         bne.s   M13_err_d5n         yes - free block, report error */
    bne.s M13_err_d5n
/* QL:         tst.b   M13_fs_acces-M13_fs_next(a0) was this delete? */
    tst.b (M13_fs_acces-M13_fs_next)(a0)
/* QL:         blt.s   M13_err_d5n         yes - free block, no error */
    blt.s M13_err_d5n
/* QL: * In this version we do not release space taken by physical definition */
/* QL: * Update count of files open on drive */
/* QL: M13_exit_ok */
M13_exit_ok:
/* QL:         sub.w   #M13_fs_next,a0     restore a0 */
    sub.w #M13_fs_next,a0
/* QL:         addq.b  #1,M13_fs_files(a1) ... one more file is open */
    addq.b #1,M13_fs_files(a1)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         bra.l   M13_exit */
    bra.w M13_exit
/* QL:         end */
