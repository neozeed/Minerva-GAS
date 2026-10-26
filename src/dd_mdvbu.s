/* ROM section dd_mdvbu */
.balign 2,0
/* QL: * d0 -  o- error return */
/* QL: * d3 -ip - action -ve send, 0 check, +ve fetch (10 = fetch line) */
/* QL: * d6 -ip - drive id * 16 + 1<<M127_bt..file */
/* QL: * d7 -i o- end of buffer (reduced by fline when terminator found) */
/* QL: * a0 -ip - pointer to channel definition */
/* QL: * a1 -i  - pointer to read/write buffer */
/* QL: * a2 -ip - pointer to physical definition */
/* QL: * d1-d2/d4-d5/a3-a5 destroyed */
/* QL: * Byte buffer/unbuffer code */
/* QL: dd_mdvbu */
dd_mdvbu:
/* QL:         tst.b   M127_md_estat(a2)    is it ok? */
    tst.b M127_md_estat(a2)
/* QL:         bmi     M127_err_fe */
    bmi M127_err_fe
/* QL:         assert  M127_fs_filnr,M127_fs_nblok-2 */
/* original assertion: M127_fs_filnr,M127_fs_nblok-2 */
/* QL:         move.l  M127_fs_filnr(a0),d5 fetch file number/block number reqd */
    move.l M127_fs_filnr(a0),d5
/* QL:         assert  M127_fs_nblok,M127_fs_nbyte-2 */
/* original assertion: M127_fs_nblok,M127_fs_nbyte-2 */
/* QL:         move.l  M127_fs_nblok(a0),d4 fetch block number/byte number */
    move.l M127_fs_nblok(a0),d4
/* QL:         assert  M127_fs_eblok,M127_fs_ebyte-2 */
/* original assertion: M127_fs_eblok,M127_fs_ebyte-2 */
/* QL:         cmp.l   M127_fs_eblok(a0),d4 compare against end of file */
    cmp.l M127_fs_eblok(a0),d4
/* QL:         bcs.s   M127_set_bk          not there yet, so all is ok */
    bcs.s M127_set_bk
/* QL:         bne.s   M127_err_ef          grim if the pointer is beyond end */
    bne.s M127_err_ef
/* QL:         tst.b   d3              is operation a write? */
    tst.b d3
/* QL:         bpl.s   M127_err_ef          no - can't extend the file with a test/read! */
    bpl.s M127_err_ef
/* QL:         tst.w   d4              is this new byte in a new block */
    tst.w d4
/* QL:         bne.s   M127_set_bk          no - just go pick up the block */
    bne.s M127_set_bk
/* QL:         cmp.l   a1,d7           is there actually anything to go in block? */
    cmp.l a1,d7
/* QL:         ble     M127_ok_rts          no so exit */
    ble M127_ok_rts
/* QL:         bsr     dd_mdvnb        find space for a new block */
    bsr dd_mdvnb
/* QL:         bsr     M127_new_sect        find new sector */
    bsr M127_new_sect
/* QL:         move.w  d0,M127_bt_sectr(a4) set sector number */
    move.w d0,M127_bt_sectr(a4)
/* QL:         addq.b  #1<<M127_bt..accs,(a4) and say it is a true buffer */
    addq.b #(1<<M127_bt..accs),(a4)
/* QL:         bra.s   M127_bk_found */
    bra.s M127_bk_found
/* QL: M127_err_ef */
M127_err_ef:
/* QL:         moveq   #M127_err.ef,d0      end of file */
    moveq #M127_err.ef,d0
/* QL: M127_rts0 */
M127_rts0:
/* QL:         rts */
    rts 
/* QL: M127_set_bk */
M127_set_bk:
/* QL:         bsr     M127_bk_find         get the block for this sector */
    bsr M127_bk_find
/* QL:         bne.s   M127_rts0            ... if block not there - give up */
    bne.s M127_rts0
/* QL:         tst.w   d4              is it the first byte in a block? */
    tst.w d4
/* QL:         bne.s   M127_bk_found        no - do not go through all that prefetch */
    bne.s M127_bk_found
/* QL:         addq.w  #1,d5           find the block for the next */
    addq.w #1,d5
/* QL:         moveq   #0,d2           and set up the block/byte address of next */
    moveq #0,d2
/* QL:         move.w  d5,d2 */
    move.w d5,d2
/* QL:         swap    d2 */
    swap d2
/* QL:         move.l  a4,-(sp)        save the block pointer */
    move.l a4,-(sp)
/* QL:         cmp.l   M127_fs_eblok(a0),d2 at end of file? */
    cmp.l M127_fs_eblok(a0),d2
/* QL:         bcc.s   M127_rst_pref        yes - do not prefetch */
    bcc.s M127_rst_pref
/* QL:         bsr     M127_bk_find1 */
    bsr M127_bk_find1
/* QL: M127_rst_pref */
M127_rst_pref:
/* QL:         move.l  (sp)+,a4        restore the block pointer */
    move.l (sp)+,a4
/* QL:         subq.w  #1,d5           restore the block number */
    subq.w #1,d5
/* QL: M127_bk_found */
M127_bk_found:
/* QL:         move.l  a4,M127_fs_cblok(a0) save pointer to this slave block */
    move.l a4,M127_fs_cblok(a0)
/* QL:         btst    #M127_bt..accs,(a4)  check contents of slave block */
    btst #M127_bt..accs,(a4)
/* QL:         beq     M127_err_ncs         not accessable, so slave to make it proper */
    beq M127_err_ncs
/* QL:         move.l  a4,d0           calculate address of next byte */
    move.l a4,d0
/* QL:         sub.l   M127_sv_btbas(a6),d0 table pointer - base address of table */
    sub.l M127_sv_btbas(a6),d0
/* QL:         lsl.l   #M127_blkbits-M127_btbits,d0 */
    lsl.l #(M127_blkbits-M127_btbits),d0
/* QL:         move.l  d0,a5 */
    move.l d0,a5
/* QL:         add.l   a6,a5           plus base of memory */
    add.l a6,a5
/* QL:         add.w   d4,a5           plus byte pointer */
    add.w d4,a5
/* QL:         tst.w   d3              what operation are we doing */
    tst.w d3
/* QL:         beq.s   M127_ok_rts          just a check, so we're done */
    beq.s M127_ok_rts
/* QL:         bmi.s   M127_put_byts        negative is a send */
    bmi.s M127_put_byts
/* QL:         moveq   #0,d0           clear top byte of d0.w for fetch terminator */
    moveq #0,d0
/* QL: M127_get_loop */
M127_get_loop:
/* QL:         cmp.l   a1,d7           end of string? */
    cmp.l a1,d7
/* QL:         ble.s   M127_com_exit        yes - go finish off */
    ble.s M127_com_exit
/* QL:         cmp.l   M127_fs_eblok(a0),d4 are we now at end of file? */
    cmp.l M127_fs_eblok(a0),d4
/* QL:         beq.s   M127_exit_eof */
    beq.s M127_exit_eof
/* QL:         move.b  (a5)+,d0        get a byte from the buffer */
    move.b (a5)+,d0
/* QL:         move.b  d0,(a1)+        and save it */
    move.b d0,(a1)+
/* QL:         cmp.w   d0,d3           is it the terminating character? */
    cmp.w d0,d3
/* QL:         beq.s   M127_termin          yes - go sort it */
    beq.s M127_termin
/* QL:         bsr.s   M127_move_ptr        update the pointers */
    bsr.s M127_move_ptr
/* QL:         bne.s   M127_get_loop        if buffer not emptied - carry on */
    bne.s M127_get_loop
/* QL:         bra.s   M127_com_exit        otherwise, go finish up this transfer */
    bra.s M127_com_exit
/* QL: M127_exit_eof */
M127_exit_eof:
/* QL:         moveq   #M127_err.ef,d0      end of file */
    moveq #M127_err.ef,d0
/* QL: M127_set_ptr */
M127_set_ptr:
/* QL:         move.l  d4,M127_fs_nblok(a0) set current block / byte pointer */
    move.l d4,M127_fs_nblok(a0)
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: M127_put_byts */
M127_put_byts:
/* QL:         cmp.l   a1,d7           end of string? */
    cmp.l a1,d7
/* QL:         ble.s   M127_put_exit */
    ble.s M127_put_exit
/* QL:         move.b  (a1)+,(a5)+     put a byte in the buffer */
    move.b (a1)+,(a5)+
/* QL:         bsr.s   M127_move_ptr        ... and update the pointers */
    bsr.s M127_move_ptr
/* QL:         bne.s   M127_put_byts        if buffer not full - continue */
    bne.s M127_put_byts
/* QL:         jsr     md_slave(pc)    buffer full - slave it */
    jsr md_slave(pc)
/* QL: M127_put_exit */
M127_put_exit:
/* QL:         st      M127_fs_updt(a0)     mark file updated */
    st M127_fs_updt(a0)
/* QL:         move.b  d6,(a4)         set drive id and file bit */
    move.b d6,(a4)
/* QL:         addq.b  #M127_bt.updt-1<<M127_bt..file,(a4) and mark record updated */
    addq.b #(M127_bt.updt-(1<<M127_bt..file)),(a4)
/* QL:         bsr.s   M127_set_pend        set pending op to write */
    bsr.s M127_set_pend
/* QL:         cmp.l   M127_fs_eblok(a0),d4 is this a new end of file? */
    cmp.l M127_fs_eblok(a0),d4
/* QL:         bcs.s   M127_com_exit */
    bcs.s M127_com_exit
/* QL:         move.l  d4,M127_fs_eblok(a0) ... yes - update eof */
    move.l d4,M127_fs_eblok(a0)
/* QL: M127_com_exit */
M127_com_exit:
/* QL:         bsr.s   M127_set_ptr         store current position */
    bsr.s M127_set_ptr
/* QL:         cmp.l   a1,d7           are there any more bytes to transfer? */
    cmp.l a1,d7
/* QL:         bne     dd_mdvbu        ... yes - go back to the start */
    bne dd_mdvbu
/* QL:         cmp.w   #256,d3         were we looking for a terminator? */
    cmp.w #256,d3
/* QL:         bcc.s   M127_ok_rts          no - fine */
    bcc.s M127_ok_rts
/* QL:         moveq   #M127_err.bo,d0      at end of caller's buffer with no terminator */
    moveq #M127_err.bo,d0
/* QL:         rts */
    rts 
/* QL: M127_termin */
M127_termin:
/* QL:         bsr.s   M127_move_ptr        update the pointers for terminator */
    bsr.s M127_move_ptr
/* QL:         bsr.s   M127_set_ptr         store current position */
    bsr.s M127_set_ptr
/* QL:         move.l  a1,d7           set end pointer */
    move.l a1,d7
/* QL: M127_ok_rts */
M127_ok_rts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: M127_move_ptr */
M127_move_ptr:
/* QL:         addq.w  #1,d4           add 1 to byte pointer */
    addq.w #1,d4
/* QL:         btst    #M127_blkbits,d4     is it off end of block */
    btst #M127_blkbits,d4
/* QL:         beq.s   M127_exit_ptr        ... no */
    beq.s M127_exit_ptr
/* QL:         addq.w  #1,d5           add 1 to block */
    addq.w #1,d5
/* QL:         add.l   #1<<16-1<<M127_blkbits,d4 add 1 to block, take block size off byte */
    add.l #((1<<16)-(1<<M127_blkbits)),d4
/* QL: M127_exit_ptr */
M127_exit_ptr:
/* QL:         tst.w   d4              set status to z if new block required */
    tst.w d4
/* QL:         rts */
    rts 
/* QL: * Routine to initiate slaving */
/* QL: M127_set_pend */
M127_set_pend:
/* QL:         move.l  a4,d1           set slave block number */
    move.l a4,d1
/* QL:         sub.l   M127_sv_btbas(a6),d1 */
    sub.l M127_sv_btbas(a6),d1
/* QL:         lsr.l   #M127_btbits,d1 */
    lsr.l #M127_btbits,d1
/* QL:         add.w   M127_bt_sectr(a4),a2 set up pending operation */
    add.w M127_bt_sectr(a4),a2
/* QL:         move.w  d1,M127_md_pendg(a2) */
    move.w d1,M127_md_pendg(a2)
/* QL:         sub.w   M127_bt_sectr(a4),a2 restore physical address */
    sub.w M127_bt_sectr(a4),a2
/* QL:         sf      M127_md_fail(a2)     clear fail flag */
    sf M127_md_fail(a2)
/* QL:         rts */
    rts 
/* QL: * Routine to find the slave block for a sector */
/* QL: * d0 -  o- M127_err.nc if not found (block fetching may have been started)  */
/* QL: * d5 -ip - file (msw) and block (lsw) */
/* QL: * d6 -ip - physdef drive id * 16 + 1<<M127_bt..file (lsb) */
/* QL: * a4 -  o- bt pointer */
/* QL: * a3/a5 destroyed, also d1/d2 if err return */
/* QL: M127_bk_find */
M127_bk_find:
/* QL:         move.l  M127_fs_cblok(a0),a4 get pointer to current block */
    move.l M127_fs_cblok(a0),a4
/* QL:         move.l  a4,d0           is it set? */
    move.l a4,d0
/* QL:         bne.s   M127_bk_find1        yes - start here */
    bne.s M127_bk_find1
/* QL:         move.l  M127_sv_btbas(a6),a4 start at base of tables */
    move.l M127_sv_btbas(a6),a4
/* QL: M127_bk_find1 */
M127_bk_find1:
/* QL:         move.l  M127_sv_bttop(a6),a5 first marker is top of table */
    move.l M127_sv_bttop(a6),a5
/* QL: M127_bk_markr */
M127_bk_markr:
/* QL:         move.l  a4,a3           keep copy of start */
    move.l a4,a3
/* QL: M127_bk_check */
M127_bk_check:
/* QL:         cmp.l   M127_bt_filnr(a4),d5 is it the right file/block */
    cmp.l M127_bt_filnr(a4),d5
/* QL:         bne.s   M127_bk_next         ... no */
    bne.s M127_bk_next
/* QL:         moveq   #-16+1<<M127_bt..file,d0 set mask of drive id and file bit */
    moveq #((-16)+(1<<M127_bt..file)),d0
/* QL:         and.b   (a4),d0         get drive id and file bit */
    and.b (a4),d0
/* QL:         cmp.b   d0,d6           is it the right drive */
    cmp.b d0,d6
/* QL:         bne.s   M127_bk_next         ... no */
    bne.s M127_bk_next
/* QL:         cmp.b   (a4),d6         check if this block is in use */
    cmp.b (a4),d6
/* QL:         bne.s   M127_ok_rts          yes - this is what we want */
    bne.s M127_ok_rts
/* QL: M127_bk_next */
M127_bk_next:
/* QL:         addq.l  #M127_bt_end,a4      move to next entry in slave block tables */
    addq.l #M127_bt_end,a4
/* QL:         cmp.l   a5,a4           have we hit a marker? */
    cmp.l a5,a4
/* QL:         bne.s   M127_bk_check        no - look at next entry */
    bne.s M127_bk_check
/* QL:         move.l  a3,a5           set the marker to where started this pass */
    move.l a3,a5
/* QL:         move.l  M127_sv_btbas(a6),a4 restart at bottom of table */
    move.l M127_sv_btbas(a6),a4
/* QL:         cmp.l   a3,a4           is that where we started? */
    cmp.l a3,a4
/* QL:         bne.s   M127_bk_markr        no, so carry on with bottom section of table */
    bne.s M127_bk_markr
/* QL: * Sector is not in slave blocks */
/* QL:         bsr     M127_fnd_sect        ... find the sector + allocate a new block */
    bsr M127_fnd_sect
/* QL:         move.w  d0,M127_bt_sectr(a4) ... set the sector number */
    move.w d0,M127_bt_sectr(a4)
/* QL:         addq.b  #1<<M127_bt..rdvr,(a4) tell md to read it */
    addq.b #(1<<M127_bt..rdvr),(a4)
/* QL:         bsr.s   M127_set_pend        set pending */
    bsr.s M127_set_pend
/* QL: M127_err_ncs */
M127_err_ncs:
/* QL:         jmp     md_slave(pc)    sets d0=M127_err.nc */
    jmp md_slave(pc)
/* QL: * Routine to allocate a new sector */
/* QL: M127_intrlace equ    12 */
.equ M127_intrlace,12
/* QL: M127_run_down equ    8 */
.equ M127_run_down,8
/* QL: M127_new_sect */
M127_new_sect:
/* QL:         bsr.s   M127_ini_fsec        get file nr/block nr in d2.w */
    bsr.s M127_ini_fsec
/* QL:         subq.b  #1,d2           find previous block */
    subq.b #1,d2
/* QL:         bcc.s   M127_look_fil        was it allocate first block? */
    bcc.s M127_look_fil
/* QL:         moveq   #-2*(M127_intrlace+M127_run_down),d0 set start position for search */
    moveq #((-2)*(M127_intrlace+M127_run_down)),d0
/* QL:         add.w   M127_md_lsect(a2),d0 last sector allocated - interlace etc. */
    add.w M127_md_lsect(a2),d0
/* QL:         bra.s   M127_look_nsec */
    bra.s M127_look_nsec
/* QL: M127_look_fil */
M127_look_fil:
/* QL:         bsr.s   M127_look_sec        look for sector */
    bsr.s M127_look_sec
/* QL: * Now look for next suitable blank hole */
/* QL: M127_look_nsec */
M127_look_nsec:
/* QL:         sub.w   #2*M127_intrlace,d0  leave some blank sectors */
    sub.w #(2*M127_intrlace),d0
/* QL:         bge.s   M127_look_fd         if a sector in file look for fd */
    bge.s M127_look_fd
/* QL: * The we have got to the lowest sector - so find the highest */
/* QL:         move.w  #M127_maxsec*2,d1    look from top but one sector */
    move.w #(M127_maxsec*2),d1
/* QL: M127_look_top */
M127_look_top:
/* QL:         subq.w  #2,d1 */
    subq.w #2,d1
/* QL:         cmp.b   #M127_badsec,M127_md_map(a2,d1.w) is this totally bad? */
    cmp.b #(M127_badsec&255),M127_md_map(a2,d1.w)
/* QL:         beq.s   M127_look_top */
    beq.s M127_look_top
/* QL:         add.w   d1,d0           set next sector to search */
    add.w d1,d0
/* QL: * Look for empty sector */
/* QL: M127_look_fd */
M127_look_fd:
/* QL:         move.w  d0,-(sp)        save sector */
    move.w d0,-(sp)
/* QL: M127_loop_fd */
M127_loop_fd:
/* QL:         subq.w  #2,d0           on one */
    subq.w #2,d0
/* QL:         bpl.s   M127_chk_fd          beyond 0? */
    bpl.s M127_chk_fd
/* QL:         move.w  #M127_maxsec*2-2,d0 */
    move.w #((M127_maxsec*2)-2),d0
/* QL: M127_chk_fd */
M127_chk_fd:
/* QL:         cmp.b   #M127_vacant,M127_md_map(a2,d0.w) M127_vacant? */
    cmp.b #(M127_vacant&255),M127_md_map(a2,d0.w)
/* QL:         beq.s   M127_set_sect */
    beq.s M127_set_sect
/* QL:         cmp.w   (sp),d0         checked all? */
    cmp.w (sp),d0
/* QL:         bne.s   M127_loop_fd */
    bne.s M127_loop_fd
/* QL:         addq.l  #2+4,sp         remove sector and return address */
    addq.l #(2+4),sp
/* QL:         moveq   #M127_err.df,d0      drive full */
    moveq #M127_err.df,d0
/* QL:         rts */
    rts 
/* QL: M127_set_sect */
M127_set_sect:
/* QL:         addq.b  #1,d2           restore block number */
    addq.b #1,d2
/* QL:         move.w  d2,M127_md_map(a2,d0.w) set file/block number */
    move.w d2,M127_md_map(a2,d0.w)
/* QL:         move.w  d0,M127_md_lsect(a2) and save last sector allocated */
    move.w d0,M127_md_lsect(a2)
/* QL:         move.w  #-1,M127_md_pendg(a2) set map modified */
    move.w #(-1),M127_md_pendg(a2)
/* QL:         addq.l  #2,sp           remove sector from stack */
    addq.l #2,sp
/* QL:         rts */
    rts 
/* QL: * Set up top of map in d0, file/block in microdrive map form in d2 */
/* QL: M127_ini_fsec */
M127_ini_fsec:
/* QL:         move.w  #M127_maxsec*2,d0    start looking one down from top */
    move.w #(M127_maxsec*2),d0
/* QL:         move.l  d5,d2           00ff00bb d5.l = file/block */
    move.l d5,d2
/* QL:         lsr.l   #8,d2           0000ff00 */
    lsr.l #8,d2
/* QL:         move.b  d5,d2           0000ffbb d2.w = file/block */
    move.b d5,d2
/* QL:         rts */
    rts 
/* QL: * General look for sector */
/* QL: M127_isit_sec */
M127_isit_sec:
/* QL:         cmp.w   M127_md_map(a2,d0.w),d2 the right one? */
    cmp.w M127_md_map(a2,d0.w),d2
/* QL:         beq.s   M127_rts1 */
    beq.s M127_rts1
/* QL: M127_look_sec */
M127_look_sec:
/* QL:         subq.w  #2,d0           move down a sector */
    subq.w #2,d0
/* QL:         bpl.s   M127_isit_sec */
    bpl.s M127_isit_sec
/* QL:         addq.l  #4+4,sp         drop 2 levels of call! */
    addq.l #(4+4),sp
/* QL: M127_err_fe */
M127_err_fe:
/* QL:         moveq   #M127_err.fe,d0      file system error */
    moveq #M127_err.fe,d0
/* QL: M127_rts1 */
M127_rts1:
/* QL:         rts */
    rts 
/* QL: * Find a sector for existing block */
/* QL: M127_fnd_sect */
M127_fnd_sect:
/* QL:         bsr.s   M127_ini_fsec        initialise */
    bsr.s M127_ini_fsec
/* QL:         bsr.s   M127_look_sec        ... and look (nb. failure drops 2 levels!) */
    bsr.s M127_look_sec
/* QL: * Drop into mdvnb */
/* QL: * The algorithm to allocate a new slave block (first version - very simple) */
/* QL: * the BT table is scanned, starting from btpnt (the latest allocated entry), */
/* QL: * looking for 4 lsb's of status showing empty or true copy. The first such is */
/* QL: * set as the latest allocated and generally marked up as empty. */
/* QL: * The entry that btpnt initially pointed to is never considered as available. */
/* QL: * A normal return is only made if a block has been acquired. */
/* QL: * If no block is found, the return address is discarded, d0 is set to M127_err.nc, */
/* QL: * d1 is destroyed, a4=btbas and a5=btpnt. */
/* QL: * d1 -  o- 0 */
/* QL: * d5 -ip - file (msw) and block (lsw) */
/* QL: * d6 -ip - physdef drive id * 16 + 1<<M127_bt..file (lsb) */
/* QL: * a4 -  o- pointer to acquired slave block table entry */
/* QL: * a5 destroyed (may be old btpnt or bttop) */
/* QL: dd_mdvnb */
dd_mdvnb:
/* QL:         move.l  M127_sv_btpnt(a6),a4 start looking 1 after last block allocated */
    move.l M127_sv_btpnt(a6),a4
/* QL:         move.l  M127_sv_bttop(a6),a5 set marker = top */
    move.l M127_sv_bttop(a6),a5
/* QL:         bra.s   M127_new_next */
    bra.s M127_new_next
/* QL: M127_new_stat */
M127_new_stat:
/* QL:         moveq   #15,d1 */
    moveq #15,d1
/* QL:         and.b   (a4),d1         look at status */
    and.b (a4),d1
/* QL:         subq.b  #M127_bt.empty,d1    is it empty? */
    subq.b #M127_bt.empty,d1
/* QL:         beq.s   M127_new_fnd         ... yes */
    beq.s M127_new_fnd
/* QL:         subq.b  #M127_bt.true-M127_bt.empty,d1 is it true copy */
.word 20737|((((M127_bt.true-M127_bt.empty))&7)<<9)
/* QL:         beq.s   M127_new_fnd         ... yes */
    beq.s M127_new_fnd
/* QL: M127_new_next */
M127_new_next:
/* QL:         addq.l  #M127_bt_end,a4      look at next slave block */
    addq.l #M127_bt_end,a4
/* QL: M127_newbtbas */
M127_newbtbas:
/* QL:         cmp.l   a5,a4           has this hit out marker? */
    cmp.l a5,a4
/* QL:         bne.s   M127_new_stat        no - keep going */
    bne.s M127_new_stat
/* QL:         move.l  M127_sv_btpnt(a6),a5 make the marker into last block allocated */
    move.l M127_sv_btpnt(a6),a5
/* QL:         cmp.l   a4,a5           was that where we were anyway? */
    cmp.l a4,a5
/* QL:         move.l  M127_sv_btbas(a6),a4 no - start again at bottom of table */
    move.l M127_sv_btbas(a6),a4
/* QL:         bne.s   M127_newbtbas        no - we can carry on, if bas<>pnt that is */
    bne.s M127_newbtbas
/* QL: M127_nonewbt */
M127_nonewbt:
/* QL:         addq.l  #4,sp           remove return address */
    addq.l #4,sp
/* QL:         moveq   #M127_err.nc,d0      not complete */
    moveq #M127_err.nc,d0
/* QL:         rts */
    rts 
/* QL: M127_new_fnd */
M127_new_fnd:
/* QL:         move.l  a4,M127_sv_btpnt(a6) reset pointer to last block allocated */
    move.l a4,M127_sv_btpnt(a6)
/* QL:         move.l  a4,M127_fs_cblok(a0) and set pointer to current block */
    move.l a4,M127_fs_cblok(a0)
/* QL:         move.b  d6,(a4)         mark new block with drive number, empty */
    move.b d6,(a4)
/* QL:         move.l  d5,M127_bt_filnr(a4) set file and block number */
    move.l d5,M127_bt_filnr(a4)
/* QL:         rts */
    rts 
/* QL:         end */
