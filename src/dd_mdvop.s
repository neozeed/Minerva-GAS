/* ROM section dd_mdvop */
.balign 2,0
/* QL: * d0 -  o- error code */
/* QL: * a0 -ip - base of channel definition block */
/* QL: * a1 -i  - base of physical definition block */
/* QL: * a2 -  o- base of physical definition block */
/* QL: * a3 -i  - base of driver definition block (not used) */
/* QL: * d1-d7/a4 destroyed */
/* QL: dd_mdvop */
dd_mdvop:
/* QL:         move.l  a1,a2           slave uses a2 */
    move.l a1,a2
/* QL: * First we set the drive id for this drive */
/* QL:         moveq   #0,d1           get drive number */
    moveq #0,d1
/* QL:         move.b  M123_md_drivn(a2),d1 */
    move.b M123_md_drivn(a2),d1
/* QL:         moveq   #0,d6 */
    moveq #0,d6
/* QL:         move.b  M123_fs_drive(a0),d6 ... and drive id*4 */
    move.b M123_fs_drive(a0),d6
/* QL:         lsl.b   #2,d6 */
    lsl.b #2,d6
/* QL:         lea     M123_sv_mdrun(a6),a4 ... and put into table of ids */
    lea M123_sv_mdrun(a6),a4
/* QL:         move.b  d6,M123_sv_mddid-M123_sv_mdrun-1(a4,d1.w) */
    move.b d6,((M123_sv_mddid-M123_sv_mdrun)-1)(a4,d1.w)
/* QL:         lsl.b   #4-2,d6 */
    lsl.b #(4-2),d6
/* QL:         addq.b  #1<<M123_bt..file,d6 ready for M123_delete file blocks */
    addq.b #(1<<M123_bt..file),d6
/* QL: * Now check for drive running or any pending operations */
/* QL:         cmp.b   (a4),d1         is this one running? */
    cmp.b (a4),d1
/* QL:         beq.s   M123_read_dir */
    beq.s M123_read_dir
/* QL:         tst.b   M123_sv_mdsta-M123_sv_mdrun-1(a4,d1.w) is it waiting? */
    tst.b ((M123_sv_mdsta-M123_sv_mdrun)-1)(a4,d1.w)
/* QL:         bne.s   M123_read_dir */
    bne.s M123_read_dir
/* QL: * Now we get map if medium changed or first medium in drive */
/* QL:         move.b  #1,M123_md_estat(a2) set error flag!! */
    move.b #(1&255),M123_md_estat(a2)
/* QL:         jsr     md_slavn(pc) */
    jsr md_slavn(pc)
/* QL: M123_wait */
M123_wait:
/* QL:         tst.b   M123_md_estat(a2)    check status */
    tst.b M123_md_estat(a2)
/* QL:         bgt.s   M123_wait            not yet acted upon */
    bgt.s M123_wait
/* QL:         blt.s   M123_err_nf          oops */
    blt.s M123_err_nf
/* QL: M123_read_dir */
M123_read_dir:
/* QL:         lea     M123_fs_spare(a0),a4 use spare bit of channel */
    lea M123_fs_spare(a0),a4
/* QL:         moveq   #M123_fs.hdlen,d2    keep entry length in d2 (almost) permanently */
    moveq #M123_fs.hdlen,d2
/* QL:         move.l  d2,M123_fs_eblok(a0) minimum size directory can be */
    move.l d2,M123_fs_eblok(a0)
/* QL:         bsr.s   M123_read_ent        read an entry */
    bsr.s M123_read_ent
/* QL:         bne.s   M123_rts0 */
    bne.s M123_rts0
/* QL:         bsr.s   M123_setsize         set up proper next/end positions, d4=end */
    bsr.s M123_setsize
/* QL:         moveq   #0,d5           first M123_vacant slot */
    moveq #0,d5
/* QL:         cmp.b   #M123_io.dir,M123_fs_acces(a0) was this open directory? */
    cmp.b #(M123_io.dir&255),M123_fs_acces(a0)
/* QL:         bne.s   M123_nxt_file */
    bne.s M123_nxt_file
/* QL:         clr.w   M123_fs_fname(a0)    make name null for directory */
    clr.w M123_fs_fname(a0)
/* QL:         rts */
    rts 
/* QL: M123_empty */
M123_empty:
/* QL:         tst.l   d5              is this the first M123_vacant slot */
    tst.l d5
/* QL:         bne.s   M123_nxt_file        no - leave it alone */
    bne.s M123_nxt_file
/* QL:         move.l  d7,d5           yes - save M123_vacant slot */
    move.l d7,d5
/* QL: M123_nxt_file */
M123_nxt_file:
/* QL:         move.l  M123_fs_nblok(a0),d7 pick up current location */
    move.l M123_fs_nblok(a0),d7
/* QL:         cmp.l   d4,d7           are we at the end? */
    cmp.l d4,d7
/* QL:         beq.s   M123_file_new        yes - must be a new file */
    beq.s M123_file_new
/* QL:         bsr.s   M123_read_ent        read next directory entry */
    bsr.s M123_read_ent
/* QL:         bne.s   M123_rts0 */
    bne.s M123_rts0
/* QL:         assert  0,M123_md_delen */
/* original assertion: 0,M123_md_delen */
/* QL:         tst.l   (a4)            M123_vacant? */
    tst.l (a4)
/* QL:         beq.s   M123_empty */
    beq.s M123_empty
/* QL:         move.l  a6,-(sp) */
    move.l a6,-(sp)
/* QL:         lea     M123_fs_fname,a6    base address for ut_cstr versus a0 */
    lea M123_fs_fname,a6
/* QL:         lea     M123_md_denam-M123_fs_fname(a4),a1 a1 relative to a6 */
    lea (M123_md_denam-M123_fs_fname)(a4),a1
/* QL:         moveq   #1,d0 */
    moveq #1,d0
/* QL:         jsr     ut_cstr(pc)     compare */
    jsr ut_cstr(pc)
/* QL:         move.l  (sp)+,a6 */
    move.l (sp)+,a6
/* QL:         bne.s   M123_nxt_file        are the names equal? */
    bne.s M123_nxt_file
/* QL: * File found... put back pointer, so we can update if needed */
/* QL:         bsr.s   M123_setentry        reposition file and calculate file no, d0.l=0 */
    bsr.s M123_setentry
/* QL:         assert  0,M123_io.old,M123_io.share-1,M123_io.new-2,M123_io.overw-3 */
/* original assertion: 0,M123_io.old,M123_io.share-1,M123_io.new-2,M123_io.overw-3 */
/* QL:         move.b  M123_fs_acces(a0),d0 get access mode */
    move.b M123_fs_acces(a0),d0
/* QL:         subq.b  #M123_io.new,d0 */
    subq.b #M123_io.new,d0
/* QL:         beq.s   M123_err_ex */
    beq.s M123_err_ex
/* QL:         bpl.s   M123_overw           n.b. d0.w = 1, for truncation in overwrite */
    bpl.s M123_overw
/* QL:         bcc.s   M123_delete          M123_delete was $ff-2 as opposed to old/share */
    bcc.s M123_delete
/* QL: * File found, all OK */
/* QL:         move.w  d5,M123_fs_filnr(a0) set file number */
    move.w d5,M123_fs_filnr(a0)
/* QL: M123_setsize */
M123_setsize:
/* QL:         move.l  (a4),d4         get length */
    move.l (a4),d4
/* QL:         lsl.l   #16-M123_blkbits,d4  convert to block/byte format */
    lsl.l #(16-M123_blkbits),d4
/* QL:         lsr.w   #16-M123_blkbits,d4 */
    lsr.w #(16-M123_blkbits),d4
/* QL:         assert  M123_fs_nblok,M123_fs_nbyte-2 */
/* original assertion: M123_fs_nblok,M123_fs_nbyte-2 */
/* QL:         move.l  d2,M123_fs_nblok(a0) current file pointer */
    move.l d2,M123_fs_nblok(a0)
/* QL:         assert  M123_fs_eblok,M123_fs_ebyte-2 */
/* original assertion: M123_fs_eblok,M123_fs_ebyte-2 */
/* QL:         move.l  d4,M123_fs_eblok(a0) set length */
    move.l d4,M123_fs_eblok(a0)
/* QL: M123_ok_rts */
M123_ok_rts:
/* QL:         moveq   #0,d0           no errors */
    moveq #0,d0
/* QL: M123_rts0 */
M123_rts0:
/* QL:         rts */
    rts 
/* QL: M123_err_nf */
M123_err_nf:
/* QL:         moveq   #M123_err.nf,d0 */
    moveq #M123_err.nf,d0
/* QL:         rts */
    rts 
/* QL: * Reposition directory and calculate file number */
/* QL: M123_setentry */
M123_setentry:
/* QL:         move.l  d7,d5           make it the current entry */
    move.l d7,d5
/* QL:         move.l  d7,M123_fs_nblok(a0) backspace the directory pointer */
    move.l d7,M123_fs_nblok(a0)
/* QL:         lsl.w   #16-M123_blkbits,d5  move byte up by block */
    lsl.w #(16-M123_blkbits),d5
/* QL:         lsr.l   #16-M123_blkbits,d5  move then both back down */
    lsr.l #(16-M123_blkbits),d5
/* QL:         lsr.l   #M123_entbits,d5     divide by entry size, to give file number */
    lsr.l #M123_entbits,d5
/* QL:         bra.s   M123_ok_rts          make sure d0 is zero */
    bra.s M123_ok_rts
/* QL: * Read a directory entry */
/* QL: M123_read_ent */
M123_read_ent:
/* QL:         moveq   #M123_io.fstrg,d0    read string */
    moveq #M123_io.fstrg,d0
/* QL: M123_rdwr_ent */
M123_rdwr_ent:
/* QL:         move.l  a4,a1 */
    move.l a4,a1
/* QL:         jmp     dd_mdvrr(pc) */
    jmp dd_mdvrr(pc)
/* QL: M123_err_ex */
M123_err_ex:
/* QL:         moveq   #M123_err.ex,d0 */
    moveq #M123_err.ex,d0
/* QL:         rts */
    rts 
/* QL: * Delete an existing file */
/* QL: M123_delete */
M123_delete:
/* QL:         clr.w   M123_md_denam(a4)    name is null */
    clr.w M123_md_denam(a4)
/* QL:         clr.l   (a4)            clear length */
    clr.l (a4)
/* QL:         bsr.s   M123_wr_ent */
    bsr.s M123_wr_ent
/* QL:         bne.s   M123_rts0 */
    bne.s M123_rts0
/* QL: * Overwrite an existing file (and truncate for M123_delete) */
/* QL: M123_overw */
M123_overw:
/* QL:         ; d0.w = 0 for truncation to nothing for a M123_delete */
/* QL:         ; d0.w = 1 to leave header alone, for now, when overwriting */
/* QL:         bsr.s   M123_dotrunc         perform the truncation */
    bsr.s M123_dotrunc
/* QL:         moveq   #M123_fs.hdlen,d7    overwrite is starting with 1st block retained */
    moveq #M123_fs.hdlen,d7
/* QL:         bra.s   M123_initit          go fill it in, if it's ovewrite */
    bra.s M123_initit
/* QL: * File not found (or M123_delete/overwrite has been done) */
/* QL: M123_file_new */
M123_file_new:
/* QL:         move.l  d5,d7           have we got a spare entry? */
    move.l d5,d7
/* QL:         bne.s   M123_entryset        yes - use it */
    bne.s M123_entryset
/* QL:         move.l  d4,d7           no - put it at eof */
    move.l d4,d7
/* QL: M123_entryset */
M123_entryset:
/* QL:         bsr.s   M123_setentry        reposition file and calculate file number */
    bsr.s M123_setentry
/* QL:         moveq   #0,d7           starting without any blocks in file */
    moveq #0,d7
/* QL: M123_initit */
M123_initit:
/* QL:         cmp.b   #M123_io.new,M123_fs_acces(a0) check access mode */
    cmp.b #(M123_io.new&255),M123_fs_acces(a0)
/* QL:         bcs.s   M123_err_nf          old/share is no good */
    bcs.s M123_err_nf
/* QL:         blt.s   M123_ok_rts          M123_delete is finished (or wasn't even found) */
    blt.s M123_ok_rts
/* QL: * Set up file header and directory entry */
/* QL:         lea     0(a4,d2.w),a1 */
    lea 0(a4,d2.w),a1
/* QL: M123_clearit */
M123_clearit:
/* QL:         clr.l   -(a1)           clear out whole entry */
    clr.l -(a1)
/* QL:         cmp.l   a1,a4 */
    cmp.l a1,a4
/* QL:         bne.s   M123_clearit */
    bne.s M123_clearit
/* QL:         move.l  d2,(a4)         set length of file */
    move.l d2,(a4)
/* QL:         lea     M123_md_denam(a4),a1 */
    lea M123_md_denam(a4),a1
/* QL:         lea     M123_fs_fname(a0),a3 */
    lea M123_fs_fname(a0),a3
/* QL:         move.w  (a3),d0 */
    move.w (a3),d0
/* QL:         addq.w  #2-1,d0         move name and length thereof */
.word 20544|((((2-1))&7)<<9)
/* QL: M123_move_nam */
M123_move_nam:
/* QL:         move.b  (a3)+,(a1)+ */
    move.b (a3)+,(a1)+
/* QL:         dbra    d0,M123_move_nam */
    dbra d0,M123_move_nam
/* QL:         bsr.s   M123_wr_ent          write directory entry */
    bsr.s M123_wr_ent
/* QL:         bne.s   M123_rts0 */
    bne.s M123_rts0
/* QL: * Update length of directory, maybe */
/* QL:         move.l  M123_fs_eblok(a0),d0 get end of directory */
    move.l M123_fs_eblok(a0),d0
/* QL:         cmp.l   d4,d0           has this extended the directory */
    cmp.l d4,d0
/* QL:         beq.s   M123_dlen_ok         no - that's ok */
    beq.s M123_dlen_ok
/* QL:         lsl.w   #16-M123_blkbits,d0 */
    lsl.w #(16-M123_blkbits),d0
/* QL:         lsr.l   #16-M123_blkbits,d0  calculate new length */
    lsr.l #(16-M123_blkbits),d0
/* QL:         move.l  d0,(a4) */
    move.l d0,(a4)
/* QL:         moveq   #4,d2 */
    moveq #4,d2
/* QL:         bsr.s   M123_wr_nb0          write 4 byte length to start of the directory */
    bsr.s M123_wr_nb0
/* QL:         bne.s   M123_rts0 */
    bne.s M123_rts0
/* QL:         moveq   #M123_fs.hdlen,d2    put back normal entry length */
    moveq #M123_fs.hdlen,d2
/* QL:         move.l  d2,(a4)         set file length to header length again */
    move.l d2,(a4)
/* QL: M123_dlen_ok */
M123_dlen_ok:
/* QL:         move.w  d5,M123_fs_filnr(a0) finally get to writing the file itself */
    move.w d5,M123_fs_filnr(a0)
/* QL:         move.l  d7,M123_fs_eblok(a0) overwrite held a block, rest didn't have any */
    move.l d7,M123_fs_eblok(a0)
/* QL: M123_wr_nb0 */
M123_wr_nb0:
/* QL:         clr.l   M123_fs_nblok(a0)    start at beginning of file */
    clr.l M123_fs_nblok(a0)
/* QL: M123_wr_ent */
M123_wr_ent:
/* QL:         moveq   #M123_io.sstrg,d0    send string */
    moveq #M123_io.sstrg,d0
/* QL:         bra.s   M123_rdwr_ent */
    bra.s M123_rdwr_ent
/* QL: * d0 -ip - .w lowest block number to be discarded (i.e. 0 = whole file) */
/* QL: * d5 -ip - file number to truncate */
/* QL: * d6 -ip - drive id * 16 + 1<<M123_bt..file */
/* QL: * d3/a3 destroyed */
/* QL: M123_dotrunc */
M123_dotrunc:
/* QL:         moveq   #256-M123_maxsec,d3  scan through all sectors in map */
    moveq #(256-M123_maxsec),d3
/* QL:         lea     M123_md_map+2*M123_maxsec(a2),a3 */
    lea (M123_md_map+(2*M123_maxsec))(a2),a3
/* QL: M123_del_loop */
M123_del_loop:
/* QL:         cmp.b   (a3),d5         is this the file to be truncated? */
    cmp.b (a3),d5
/* QL:         bne.s   M123_del_next */
    bne.s M123_del_next
/* QL:         cmp.b   1(a3),d0        is it a block to be discarded? */
    cmp.b 1(a3),d0
/* QL:         bhi.s   M123_del_next        no - leave it */
    bhi.s M123_del_next
/* QL:         move.w  #M123_vacant<<8,(a3) set M123_vacant */
    move.w #(M123_vacant<<8),(a3)
/* QL:         clr.w   M123_md_pendg-M123_md_map(a3) clear any pending operations */
    clr.w (M123_md_pendg-M123_md_map)(a3)
/* QL: M123_del_next */
M123_del_next:
/* QL:         subq.l  #2,a3 */
    subq.l #2,a3
/* QL:         addq.b  #1,d3           next sector */
    addq.b #1,d3
/* QL:         bne.s   M123_del_loop */
    bne.s M123_del_loop
/* QL: * Now get rid of any slave blocks for this */
/* QL:         move.l  M123_sv_btbas(a6),a3 get address of base of tables */
    move.l M123_sv_btbas(a6),a3
/* QL: M123_rem_loop */
M123_rem_loop:
/* QL:         cmp.w   M123_bt_filnr(a3),d5 the file number must match (1st, as it's quick) */
    cmp.w M123_bt_filnr(a3),d5
/* QL:         bne.s   M123_rem_next */
    bne.s M123_rem_next
/* QL:         moveq   #-16+1<<M123_bt..file,d3 mask out all but drive id and file flag */
    moveq #((-16)+(1<<M123_bt..file)),d3
/* QL:         assert  0,M123_bt_stat */
/* original assertion: 0,M123_bt_stat */
/* QL:         and.b   (a3),d3 */
    and.b (a3),d3
/* QL:         cmp.b   d3,d6           the drive, of course, must match */
    cmp.b d3,d6
/* QL:         bne.s   M123_rem_next */
    bne.s M123_rem_next
/* QL:         cmp.w   M123_bt_block(a3),d0 finally, the block must be one being discarded */
    cmp.w M123_bt_block(a3),d0
/* QL:         bhi.s   M123_rem_next */
    bhi.s M123_rem_next
/* QL:         move.b  #M123_bt.empty,(a3)  kill it */
    move.b #(M123_bt.empty&255),(a3)
/* QL: M123_rem_next */
M123_rem_next:
/* QL:         addq.l  #M123_bt_end,a3      next slave block */
    addq.l #M123_bt_end,a3
/* QL:         cmp.l   M123_sv_bttop(a6),a3 last ? */
    cmp.l M123_sv_bttop(a6),a3
/* QL:         bne.s   M123_rem_loop */
    bne.s M123_rem_loop
/* QL:         move.w  #-1,M123_md_pendg(a2) set write map key */
    move.w #(-1),M123_md_pendg(a2)
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code */
/* QL: * d6 -i  - drive id * 16 + 1<<M123_bt..file */
/* QL: * a0 -ip - channel definition */
/* QL: * a2 -ip - physical definition */
/* QL: * d1-d3/a1/a3-a4 destroyed */
/* QL: dd_mdvtr */
dd_mdvtr:
/* QL:         cmp.b   #M123_io.share,M123_fs_acces(a0) is the file opened for writing? */
    cmp.b #(M123_io.share&255),M123_fs_acces(a0)
/* QL:         beq.s   M123_err_ro */
    beq.s M123_err_ro
/* QL:         move.w  M123_fs_filnr(a0),d5 pick up file number */
    move.w M123_fs_filnr(a0),d5
/* QL:         move.l  M123_fs_nblok(a0),d0 + nbyte get current position */
    move.l M123_fs_nblok(a0),d0
/* QL:         move.l  d0,M123_fs_eblok(a0) + ebyte stuff it into the end position */
    move.l d0,M123_fs_eblok(a0)
/* QL:         subq.l  #1,d0           if byte number is zero, decrement block number */
    subq.l #1,d0
/* QL:         swap    d0 */
    swap d0
/* QL:         addq.w  #2,d0           discard all blocks >= d0.w */
    addq.w #2,d0
/* QL:         st      M123_fs_updt(a0)     show file updated */
    st M123_fs_updt(a0)
/* QL:         bsr.s   M123_dotrunc         get rid of map entries and slave blocks */
    bsr.s M123_dotrunc
/* QL:         jmp     dd_mdvlu(pc)    will set d0=0 for us */
    jmp dd_mdvlu(pc)
/* QL: M123_err_ro */
M123_err_ro:
/* QL:         moveq   #M123_err.ro,d0 */
    moveq #M123_err.ro,d0
/* QL:         rts */
    rts 
/* QL:         end */
