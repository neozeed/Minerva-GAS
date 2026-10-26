/* ROM section dd_mdvsc */
.balign 2,0
/* QL: * lwr's notes: */
/* QL: * This scatter load always reads the whole file, ignoring any current position */
/* QL: * and requested length, plus it crashes if the buffer address supplied is odd. */
/* QL: * Also, the caller has probably just read the header and therefore the first */
/* QL: * two blocks will usually already be available in slave blocks. It seems stupid */
/* QL: * that a load reads them twice! */
/* QL: * A better system all round would be for the normal serial io.fstrg to do any */
/* QL: * slave blocks that are already available, then using this to load the rest, */
/* QL: * the bulk of which would be direct reads to the user's buffer area, exceptions */
/* QL: * being any odd bytes in the first and last blocks. */
/* QL: * Finally, I wonder if anyone would notice if the supplied start/length were */
/* QL: * used, particularly as they are already used if the requested length is less */
/* QL: * than the magic number 4096 (actually, the size that requires about one */
/* QL: * revolution of the tape, given the standard interleave), when the i/o routine */
/* QL: * doesn't even come here! */
/* QL: * P.S. Wouldn't it be even nicer if the mdv stuff kept track of roughly which */
/* QL: * sector on the tape it was at? */
/* QL: * d0 -  o- error code */
/* QL: * d2 -i  - requested length (not used!) */
/* QL: * d6 -i  - drive id * 16 + 1<<M125_bt..file */
/* QL: * a0 -ip - channel definition */
/* QL: * a1 -i o- user buffer */
/* QL: * a2 -ip - physical definition */
/* QL: * d1-d7/a3-a5 destroyed */
/* QL: * Locally: */
/* QL: * d0-d4/d6 used by md routines */
/* QL: * d5 pointer to bit in file map */
/* QL: * d7 current block number / address rel to a1 */
/* QL: * a3 microdrive control register */
/* QL: * a4 slave block (set by dd_mdvnb) */
/* QL: * a5 file map etc. */
/* QL: reglist reg     a0-a2/a4 */
/* QL: dd_mdvsc */
dd_mdvsc:
/* QL:         jsr     dd_mdvnb(pc)    find a slave block */
    jsr dd_mdvnb(pc)
/* QL:         subq.l  #M125_bt_end,M125_sv_btpnt(a6) and free it straight after use */
    subq.l #M125_bt_end,M125_sv_btpnt(a6)
/* QL: * Note. The above causes scans for free blocks to find this block straight off. */
/* QL: * As memory allocation is not allowed when interrupted code in in supervisor */
/* QL: * mode, we'll not lose it. */
/* QL:         move.l  a4,d5           calculate address of slave block */
    move.l a4,d5
/* QL:         sub.l   M125_sv_btbas(a6),d5 ... take away base of tables */
    sub.l M125_sv_btbas(a6),d5
/* QL:         lsl.l   #M125_blkbits-M125_btbits,d5 divided by M125_bt_end, multiplied by block size */
    lsl.l #(M125_blkbits-M125_btbits),d5
/* QL:         move.l  d5,a4 */
    move.l d5,a4
/* QL:         add.l   a6,a4           plus base of memory */
    add.l a6,a4
/* QL:         jsr     md_slave(pc)    start drive and d0 = M125_err.nc */
    jsr md_slave(pc)
/* QL:         lea     M125_pc_mctrl,a3 */
    lea M125_pc_mctrl,a3
/* QL:         and.b   #$ff-M125_pc.maskg,M125_sv_pcint(a6) stop server killing drive */
    and.b #((0xff-M125_pc.maskg)&255),M125_sv_pcint(a6)
/* QL:         move.b  M125_sv_pcint(a6),M125_pc_intr-M125_pc_mctrl(a3) */
    move.b M125_sv_pcint(a6),(M125_pc_intr-M125_pc_mctrl)(a3)
/* QL: * We'll get on with sommat else for a moment ... */
/* QL:         assert  M125_fs_eblok,M125_fs_ebyte-2 */
/* original assertion: M125_fs_eblok,M125_fs_ebyte-2 */
/* QL:         move.l  M125_fs_eblok(a0),d2 get last block/byte */
    move.l M125_fs_eblok(a0),d2
/* QL:         assert  M125_fs_nblok,M125_fs_nbyte-2 */
/* original assertion: M125_fs_nblok,M125_fs_nbyte-2 */
/* QL:         move.l  d2,M125_fs_nblok(a0) set current block/byte (always to eof) */
    move.l d2,M125_fs_nblok(a0)
/* QL:         subq.l  #1,d2 */
    subq.l #1,d2
/* QL:         and.w   #M125_blksize-1,d2 */
    and.w #(M125_blksize-1),d2
/* QL:         addq.w  #1,d2           convert to: last active block / byte 1-M125_blksize */
    addq.w #1,d2
/* QL:         assert  M125_bitmap+M125_maplen/8,M125_remain,M125_lstblok-1,M125_lstbyte-2 */
/* original assertion: M125_bitmap+M125_maplen/8,M125_remain,M125_lstblok-1,M125_lstbyte-2 */
/* QL:         lea     M125_remain(a0),a5 */
    lea M125_remain(a0),a5
/* QL:         move.l  d2,(a5) save it */
    move.l d2,(a5)
/* QL:         swap    d2              get last active block number */
    swap d2
/* QL:         move.b  d2,(a5)         put extra block counter */
    move.b d2,(a5)
/* QL:         moveq   #M125_maplen/8/4-1,d5 */
    moveq #(((M125_maplen/8)/4)-1),d5
/* QL: M125_lop_fmap */
M125_lop_fmap:
/* QL:         clr.l   -(a5)           clear M125_bitmap of file map */
    clr.l -(a5)
/* QL:         dbra    d5,M125_lop_fmap */
    dbra d5,M125_lop_fmap
/* QL:         moveq   #7,d5 */
    moveq #7,d5
/* QL:         and.b   d2,d5           remember odd bits */
    and.b d2,d5
/* QL:         lsr.w   #3,d2           for every complete 8 blocks */
    lsr.w #3,d2
/* QL:         bra.s   M125_smap_dbr */
    bra.s M125_smap_dbr
/* QL: M125_smap_lop */
M125_smap_lop:
/* QL:         st      (a5)+           set M125_bitmap bits for those blocks not yet read */
    st (a5)+
/* QL: M125_smap_dbr */
M125_smap_dbr:
/* QL:         dbra    d2,M125_smap_lop */
    dbra d2,M125_smap_lop
/* QL:         addq.b  #2,d2           make d2 = $ff01 */
    addq.b #2,d2
/* QL:         rol.w   d5,d2 */
    rol.w d5,d2
/* QL:         move.b  d2,(a5)         set M125_bitmap bits for last 1..8 blocks of file */
    move.b d2,(a5)
/* QL: * Is the right drive running now? */
/* QL:         cmp.b   M125_sv_mdrun(a6),d1 is the right drive running? */
    cmp.b M125_sv_mdrun(a6),d1
/* QL:         bne     M125_ena_gap         no - we'll have to wait */
    bne M125_ena_gap
/* QL: * Now start reading all the blocks of the file */
/* QL:         movem.l reglist,-(sp) */
    movem.l a0-a2/a4,-(sp)
/* QL: * We have seen sector zero - see if we have a failure to read file */
/* QL: M125_inc_fail */
M125_inc_fail:
/* QL:         addq.b  #1,M125_md_fail(a2) */
    addq.b #1,M125_md_fail(a2)
/* QL:         cmp.b   #2+M125_maxfail,M125_md_fail(a2) full rotations to give up after */
    cmp.b #((2+M125_maxfail)&255),M125_md_fail(a2)
/* QL:         bge.s   M125_err_fe */
    bge.s M125_err_fe
/* QL: M125_rep_enab */
M125_rep_enab:
/* QL:         and.w   #$f8ff,sr       enable interrupts to allow in ext or poll */
    and.w #0xf8ff,sr
/* QL:         or.w    #$0700,sr       disable them again so i can have the whole ql */
    or.w #0x0700,sr
/* QL: M125_rep_noen ; come here after actually reading a sector - no time for interrupts! */
M125_rep_noen:
/* QL:         move.l  (sp),a0         restore a0 */
    move.l (sp),a0
/* QL:         lea     M125_hdrbuf(a0),a1   put the sector header somewhere safe */
    lea M125_hdrbuf(a0),a1
/* QL:         jsr     md_sectr(pc)    get sector header */
    jsr md_sectr(pc)
/* QL:         bra.s   M125_err_fe          ... oops                ret+0 */
    bra.s M125_err_fe
/* QL:         bra.s   M125_rep_enab        ... not a header        ret+2 */
    bra.s M125_rep_enab
/* QL:                                 ; good return           ret+4 */
/* QL:         movem.l (sp),reglist    restore the addresses */
    movem.l (sp),a0-a2/a4
/* QL:         move.w  d7,d5 */
    move.w d7,d5
/* QL:         beq.s   M125_inc_fail        ok if not the sector 0 map */
    beq.s M125_inc_fail
/* QL:         add.w   d5,d5 */
    add.w d5,d5
/* QL:         move.b  M125_md_map(a2,d5.w),d0 get file number from sector map */
    move.b M125_md_map(a2,d5.w),d0
/* QL:         cmp.b   M125_fs_filnr+1(a0),d0 check it's the one we want */
    cmp.b (M125_fs_filnr+1)(a0),d0
/* QL:         bne.s   M125_rep_enab */
    bne.s M125_rep_enab
/* QL:         move.b  M125_md_map+1(a2,d5.w),d7 replace sector with the block number */
    move.b (M125_md_map+1)(a2,d5.w),d7
/* QL:         moveq   #7,d5           convert it to point to the file map */
    moveq #7,d5
/* QL:         and.b   d7,d5 */
    and.b d7,d5
/* QL:         ror.l   #3,d7 */
    ror.l #3,d7
/* QL:         btst    d5,M125_bitmap(a0,d7.w) do we need this block? */
    btst d5,M125_bitmap(a0,d7.w)
/* QL:         beq.s   M125_rep_enab */
    beq.s M125_rep_enab
/* QL:         move.l  a4,a1           put sector read into slave block */
    move.l a4,a1
/* QL:         jsr     md_read(pc)     read it (a5 preserved, as it happens) */
    jsr md_read(pc)
/* QL: M125_go_noen */
M125_go_noen:
/* QL:         bra.s   M125_rep_noen        get next sector quick!  ret+0 */
    bra.s M125_rep_noen
/* QL:                                 ; good return           ret+2 */
/* QL:         movem.l (sp),reglist    restore addresses */
    movem.l (sp),a0-a2/a4
/* QL: * Maybe we should make a final check that d1=file/d2=block here? */
/* QL: * That would be just in case we had managed to hiccup past the record, or */
/* QL: * more importantly, the record had been erroneously recorded! E.g. the map was */
/* QL: * not the right one! (lwr) */
/* QL:         bclr    d5,M125_bitmap(a0,d7.w) mark sector found */
    bclr d5,M125_bitmap(a0,d7.w)
/* QL:         rol.l   #3,d7           restore block number */
    rol.l #3,d7
/* QL:         move.w  #M125_blksize,d0     full block normally */
    move.w #M125_blksize,d0
/* QL:         cmp.b   M125_lstblok(a0),d7  is it the last file block? */
    cmp.b M125_lstblok(a0),d7
/* QL:         bne.s   M125_not_last        no - copy to end of it */
    bne.s M125_not_last
/* QL:         move.w  M125_lstbyte(a0),d0  get the number of bytes in last block */
    move.w M125_lstbyte(a0),d0
/* QL: M125_not_last */
M125_not_last:
/* QL:         lsl.w   #M125_blkbits-1,d7 */
    lsl.w #(M125_blkbits-1),d7
/* QL:         add.l   d7,d7           is it the first file block? */
    add.l d7,d7
/* QL:         lea     -M125_md_deend(a1,d7.l),a5 where to put data normally */
    lea (-M125_md_deend)(a1,d7.l),a5
/* QL:         bne.s   M125_not_frst */
    bne.s M125_not_frst
/* QL:         moveq   #M125_md_deend,d1    yes - move on past the file header */
    moveq #M125_md_deend,d1
/* QL:         add.l   d1,a4 */
    add.l d1,a4
/* QL:         add.l   d1,a5 */
    add.l d1,a5
/* QL:         sub.w   d1,d0           copy fewer bytes */
    sub.w d1,d0
/* QL: M125_not_frst */
M125_not_frst:
/* QL:         ror.l   #2,d0           long words, and save odd byte count */
    ror.l #2,d0
/* QL:         bcc.s   M125_unbf_dbr        carry means there is an odd word to do */
    bcc.s M125_unbf_dbr
/* QL:         move.w  (a4)+,(a5)+     if so, do it */
    move.w (a4)+,(a5)+
/* QL:         bra.s   M125_unbf_dbr */
    bra.s M125_unbf_dbr
/* QL: M125_err_fe */
M125_err_fe:
/* QL:         moveq   #M125_err.fe,d0      ... we've bombed out */
    moveq #M125_err.fe,d0
/* QL:         bra.s   M125_done */
    bra.s M125_done
/* QL: M125_unbf_lop */
M125_unbf_lop:
/* QL:         move.l  (a4)+,(a5)+     move a long word */
    move.l (a4)+,(a5)+
/* QL: M125_unbf_dbr */
M125_unbf_dbr:
/* QL:         dbra    d0,M125_unbf_lop */
    dbra d0,M125_unbf_lop
/* QL:         add.l   d0,d0           see if there's an odd byte to go */
    add.l d0,d0
/* QL:         bpl.s   M125_notabyte */
    bpl.s M125_notabyte
/* QL:         move.b  (a4)+,(a5)+     if so, do it */
    move.b (a4)+,(a5)+
/* QL: M125_notabyte */
M125_notabyte:
/* QL:         subq.b  #1,M125_remain(a0)   are there any more to do? */
    subq.b #1,M125_remain(a0)
/* QL:         bcc.s   M125_go_noen         not finished yet */
    bcc.s M125_go_noen
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M125_done */
M125_done:
/* QL:         movem.l (sp)+,reglist   remove addresses from stack */
    movem.l (sp)+,a0-a2/a4
/* QL:         sf      M125_md_fail(a2)     clear failure flag */
    sf M125_md_fail(a2)
/* QL:         move.l  M125_fs_eblok(a0),d7 get pointer to end */
    move.l M125_fs_eblok(a0),d7
/* QL:         move.l  d7,M125_fs_nblok(a0) make it the current postion */
    move.l d7,M125_fs_nblok(a0)
/* QL:         lsl.w   #16-M125_blkbits,d7 */
    lsl.w #(16-M125_blkbits),d7
/* QL:         lsr.l   #16-M125_blkbits,d7 */
    lsr.l #(16-M125_blkbits),d7
/* QL:         lea     -M125_md_deend(a1,d7.l),a1 adjust caller's register properly */
    lea (-M125_md_deend)(a1,d7.l),a1
/* QL: M125_ena_gap */
M125_ena_gap:
/* QL:         or.b    #M125_pc.maskg,M125_sv_pcint(a6) re-enable gaps to let server run down */
    or.b #(M125_pc.maskg&255),M125_sv_pcint(a6)
/* QL:         and.w   #$f8ff,sr       re-enable interrupts */
    and.w #0xf8ff,sr
/* QL:         rts */
    rts 
/* QL:         end */
