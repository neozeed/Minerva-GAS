/* ROM section dd_mdvcl */
.balign 2,0
/* QL: * d0 -  o- 0 */
/* QL: * d6 -  o- drive id * 16 + 1<<bt..file */
/* QL: * a0 -i  - channel definition */
/* QL: * a2 -  o- physical definition */
/* QL: * a3 -ip - directory driver linkage block (not used) */
/* QL: dd_mdvcl */
dd_mdvcl:
/* QL:         jsr     dd_mdvpd(pc)    sort out physdef stuff */
    jsr dd_mdvpd(pc)
/* QL:         bsr.s   dd_mdvlu        update length/date */
    bsr.s dd_mdvlu
/* QL:         subq.b  #1,M124_md_files(a2) one fewer files */
    subq.b #1,M124_md_files(a2)
/* QL:         jmp     io_relch(pc)    unlink and remove channel definition block */
    jmp io_relch(pc)
/* QL: * Update file header with data length and update date and copy it to directory. */
/* QL: * d0 -  o- error code */
/* QL: * a0 -ip - channel definition */
/* QL: * a2 -ip - physical definition */
/* QL: dd_mdvlu */
dd_mdvlu:
/* QL:         tst.b   M124_fs_updt(a0)     was file updated? */
    tst.b M124_fs_updt(a0)
/* QL:         bne.s   dd_mdvcd        yes - go update length and update date */
    bne.s dd_mdvcd
/* QL:         moveq   #0,d0           just to be consistent */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: reglist reg     d1-d3/a1/a3-a4 */
/* QL: dd_mdvcd */
dd_mdvcd:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d3/a1/a3-a4,-(sp)
/* QL:         assert  M124_fs_filnr,M124_fs_nblok-2,M124_fs_nbyte-4,M124_fs_eblok-6,M124_fs_ebyte-8 */
/* original assertion: M124_fs_filnr,M124_fs_nblok-2,M124_fs_nbyte-4,M124_fs_eblok-6,M124_fs_ebyte-8 */
/* QL:         lea     M124_fs_filnr(a0),a4 */
    lea M124_fs_filnr(a0),a4
/* QL:         move.w  (a4)+,-(sp)     save file no */
    move.w (a4)+,-(sp)
/* QL:         move.l  (a4)+,-(sp)     save current */
    move.l (a4)+,-(sp)
/* QL:         move.l  (a4),-(sp)      save end */
    move.l (a4),-(sp)
/* QL:         clr.l   -(a4)           set current to zero to address header */
    clr.l -(a4)
/* QL:         moveq   #M124_io.fstrg,d0 */
    moveq #M124_io.fstrg,d0
/* QL:         bsr.s   M124_rd_ent          get current image of file header */
    bsr.s M124_rd_ent
/* QL:         bne.s   M124_getout          couldn't read it! */
    bne.s M124_getout
/* QL:         tst.b   M124_fs_updt(a0)     was file really updated? (rename skips here) */
    tst.b M124_fs_updt(a0)
/* QL:         beq.s   M124_headok          no - don't actually change header */
    beq.s M124_headok
/* QL:         move.l  (sp),d0 */
    move.l (sp),d0
/* QL:         lsl.w   #16-M124_blkbits,d0  get file length */
    lsl.w #(16-M124_blkbits),d0
/* QL:         lsr.l   #16-M124_blkbits,d0  in true form */
    lsr.l #(16-M124_blkbits),d0
/* QL:         move.l  d0,M124_md_delen+M124_fs_spare(a0) set file length */
    move.l d0,(M124_md_delen+M124_fs_spare)(a0)
/* QL:         exg     a0,a1 */
    exg a1,a0
/* QL:         moveq   #M124_mt.rclck,d0    get a reading from the clock */
    moveq #M124_mt.rclck,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         exg     a0,a1 */
    exg a1,a0
/* QL:         move.l  d1,M124_md_deupd+M124_fs_spare(a0) set update date */
    move.l d1,(M124_md_deupd+M124_fs_spare)(a0)
/* QL:         clr.l   (a4)            reset position to header */
    clr.l (a4)
/* QL:         bsr.s   M124_wr_ent          write length and update date to file header */
    bsr.s M124_wr_ent
/* QL:         bne.s   M124_getout          yeuch! we're in trouble */
    bne.s M124_getout
/* QL: M124_headok */
M124_headok:
/* QL:         move.w  -(a4),d0        get file number */
    move.w -(a4),d0
/* QL:         clr.w   (a4)+           directory is file 0 */
    clr.w (a4)+
/* QL:         lsl.l   #M124_entbits,d0     and convert to directory position */
    lsl.l #M124_entbits,d0
/* QL:         lsl.l   #16-M124_blkbits,d0 */
    lsl.l #(16-M124_blkbits),d0
/* QL:         lsr.w   #16-M124_blkbits,d0 */
    lsr.w #(16-M124_blkbits),d0
/* QL:         move.l  d0,(a4)         set current to directory */
    move.l d0,(a4)
/* QL:         st      M124_fs_eblok+1(a0)  of great length!!! */
    st (M124_fs_eblok+1)(a0)
/* QL:         bsr.s   M124_wr_ent          write whole header to directory entry */
    bsr.s M124_wr_ent
/* QL:         bne.s   M124_getout */
    bne.s M124_getout
/* QL:         jsr     md_slave(pc) */
    jsr md_slave(pc)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M124_getout */
M124_getout:
/* QL:         sf      M124_fs_updt(a0)     we can clear the flag, i hope! (lwr) */
    sf M124_fs_updt(a0)
/* QL:         lea     M124_fs_eblok(a0),a4 */
    lea M124_fs_eblok(a0),a4
/* QL:         move.l  (sp)+,(a4)      restore end */
    move.l (sp)+,(a4)
/* QL:         move.l  (sp)+,-(a4)     restore current */
    move.l (sp)+,-(a4)
/* QL:         move.w  (sp)+,-(a4)     restore file no */
    move.w (sp)+,-(a4)
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d3/a1/a3-a4
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: * Write the length and update date */
/* QL: M124_wr_ent */
M124_wr_ent:
/* QL:         moveq   #M124_io.sstrg,d0    send header or directory entry */
    moveq #M124_io.sstrg,d0
/* QL: M124_rd_ent */
M124_rd_ent:
/* QL:         lea     M124_fs_spare(a0),a1 use spare in block */
    lea M124_fs_spare(a0),a1
/* QL:         moveq   #M124_fs.hdlen,d2 */
    moveq #M124_fs.hdlen,d2
/* QL:         jmp     dd_mdvrr(pc)    direct entry */
    jmp dd_mdvrr(pc)
/* QL:         end */
