/* ROM section dd_mdvrn */
.balign 2,0
/* QL: * A problem child, this rename call... we have the rename string with the */
/* QL: * "mdvn_" still on the front. This means it's not convenient for ut_cstr. */
/* QL: * I don't think we're able to mess with the name in our channel, as multitask */
/* QL: * operation could screw up. (Well, it can anyway... as we change the name, */
/* QL: * conceivably someone else can change it simultaneously). Also, there's no */
/* QL: * guarantee we could mess with the user's copy, it could even be ROM! */
/* QL: * There are two reasonable courses of action one can take: */
/* QL: * Firstly, we could try nesting down a level, and doing an open.new on the */
/* QL: * user's filename. If it works, we then exchange the names and close the silly */
/* QL: * one. This could be enhanced by a special access code, maybe? Doubtfull. */
/* QL: * Secondly, one could M126_scan the directory here, but keep shuffling the name read */
/* QL: * in to prepend the "mdvn_". This sounds pretty tacky, but it looks like the */
/* QL: * way we'll have to do it. It's only an error check, after all. */
/* QL: * The update date is no longer altered by a rename, per se. */
/* QL: * d0 -  o- error code */
/* QL: * a0 -ip - channel definition */
/* QL: * a1 -i  - requested new name, with byte count word prefix */
/* QL: * a2 -ip - physical definition */
/* QL: * a3 -i  - driver definition */
/* QL: * d1-d3/d5/d7/a4 destroyed */
/* QL: dd_mdvrn */
dd_mdvrn:
/* QL:         assert  M126_fs_filnr,M126_fs_nblok-2,M126_fs_nbyte-4,M126_fs_eblok-6,M126_fs_ebyte-8 */
/* original assertion: M126_fs_filnr,M126_fs_nblok-2,M126_fs_nbyte-4,M126_fs_eblok-6,M126_fs_ebyte-8 */
/* QL:         lea     M126_fs_filnr(a0),a4 */
    lea M126_fs_filnr(a0),a4
/* QL:         move.w  (a4),-(sp)      save file number */
    move.w (a4),-(sp)
/* QL:         clr.w   (a4)+           file number zero is the directory */
    clr.w (a4)+
/* QL:         move.l  (a4),-(sp)      save current position */
    move.l (a4),-(sp)
/* QL:         clr.l   (a4)+           current position zero */
    clr.l (a4)+
/* QL:         move.l  (a4),-(sp)      save end position */
    move.l (a4),-(sp)
/* QL:         moveq   #M126_fs.hdlen,d2    we want the length of the directory */
    moveq #M126_fs.hdlen,d2
/* QL:         move.l  d2,(a4)         just say the directory is a single entry */
    move.l d2,(a4)
/* QL:         lea     M126_ch_end+M126_ch_drnam(a3),a3 */
    lea (M126_ch_end+M126_ch_drnam)(a3),a3
/* QL:         move.w  (a3),d5 */
    move.w (a3),d5
/* QL:         addq.w  #2,d5 */
    addq.w #2,d5
/* QL:         movem.l d5/a0-a1/a6,-(sp) keep extra and caller's new name + cstr regs */
    movem.l d5/a0-a1/a6,-(sp)
/* QL: * The stack is now loaded up with lots of goodies, start verifying name. */
/* QL:         moveq   #M126_err.bn,d0 */
    moveq #M126_err.bn,d0
/* QL:         sub.w   (a1)+,d5        is their name too short ... */
    sub.w (a1)+,d5
/* QL:         add.w   #M126_fs.nmlen,d5    ... or too long? */
    add.w #M126_fs.nmlen,d5
/* QL:         bcc.s   M126_done            (note, we don't allow null name length) */
    bcc.s M126_done
/* QL:         move.w  (a3)+,d5 */
    move.w (a3)+,d5
/* QL: M126_nloop */
M126_nloop:
/* QL:         moveq   #-1-32,d1 */
    moveq #((-1)-32),d1
/* QL:         and.b   (a1)+,d1 */
    and.b (a1)+,d1
/* QL:         cmp.b   (a3)+,d1 */
    cmp.b (a3)+,d1
/* QL:         bne.s   M126_done            prefix didn't match our driver name */
    bne.s M126_done
/* QL:         subq.w  #1,d5 */
    subq.w #1,d5
/* QL:         bne.s   M126_nloop */
    bne.s M126_nloop
/* QL:         moveq   #'0',d1 */
    moveq #48,d1
/* QL:         add.b   M126_fs_drivn(a2),d1 */
    add.b M126_fs_drivn(a2),d1
/* QL:         sub.b   (a1)+,d1        must match drive number */
    sub.b (a1)+,d1
/* QL:         bne.s   M126_done */
    bne.s M126_done
/* QL:         cmp.b   #'_',(a1)       must match underscore */
    cmp.b #(95&255),(a1)
/* QL:         bne.s   M126_done */
    bne.s M126_done
/* QL: * That's the easy checks over with. Now we must M126_scan the directory. */
/* QL:         bsr.s   M126_rd_ent */
    bsr.s M126_rd_ent
/* QL:         bne.s   M126_done */
    bne.s M126_done
/* QL:         move.l  M126_fs_spare(a0),d7 */
    move.l M126_fs_spare(a0),d7
/* QL:         lsl.l   #16-M126_blkbits,d7 */
    lsl.l #(16-M126_blkbits),d7
/* QL:         lsr.w   #16-M126_blkbits,d7 */
    lsr.w #(16-M126_blkbits),d7
/* QL:         move.l  d7,(a4)         set true end of directory */
    move.l d7,(a4)
/* QL:         subq.l  #4,a4           point at current location */
    subq.l #4,a4
/* QL: M126_scan */
M126_scan:
/* QL:         moveq   #M126_md_denam,d2    skip a bit */
    moveq #M126_md_denam,d2
/* QL:         add.l   d2,(a4) */
    add.l d2,(a4)
/* QL:         moveq   #2,d2           read name length */
    moveq #2,d2
/* QL:         bsr.s   M126_rd_ent */
    bsr.s M126_rd_ent
/* QL:         bne.s   M126_done */
    bne.s M126_done
/* QL:         movem.l (sp),d5/a0/a3 */
    movem.l (sp),d5/a0/a3
/* QL:         add.w   d5,-(a1)        add extra to file name length */
    add.w d5,-(a1)
/* QL:         move.w  (a1)+,d1 */
    move.w (a1)+,d1
/* QL:         cmp.w   (a3)+,d1        it must now match caller's length */
    cmp.w (a3)+,d1
/* QL:         bne.s   M126_tweak           (don't need to be so precise, compare fails) */
    bne.s M126_tweak
/* QL: M126_fillup */
M126_fillup:
/* QL:         move.b  (a3)+,(a1)+     copy prefix from caller's buffer */
    move.b (a3)+,(a1)+
/* QL:         subq.b  #1,d5 */
    subq.b #1,d5
/* QL:         bne.s   M126_fillup */
    bne.s M126_fillup
/* QL: M126_tweak */
M126_tweak:
/* QL:         moveq   #M126_fs.hdlen-2-M126_md_denam,d2 read rest of entry */
    moveq #((M126_fs.hdlen-2)-M126_md_denam),d2
/* QL:         bsr.s   M126_rd_more */
    bsr.s M126_rd_more
/* QL:         bne.s   M126_done */
    bne.s M126_done
/* QL:         movem.l (sp),d5/a0-a1 */
    movem.l (sp),d5/a0-a1
/* QL:         moveq   #1,d0           comparison type */
    moveq #1,d0
/* QL:         sub.l   a6,a6           base register */
    sub.l a6,a6
/* QL:         lea     M126_fs_spare(a0),a0 */
    lea M126_fs_spare(a0),a0
/* QL:         jsr     ut_cstr(pc) */
    jsr ut_cstr(pc)
/* QL:         movem.l (sp),d5/a0/a3/a6 */
    movem.l (sp),d5/a0/a3/a6
/* QL:         beq.s   M126_err_ex */
    beq.s M126_err_ex
/* QL:         cmp.l   (a4),d7 */
    cmp.l (a4),d7
/* QL:         bne.s   M126_scan */
    bne.s M126_scan
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         bra.s   M126_done */
    bra.s M126_done
/* QL: * Routines to read/write data */
/* QL: M126_rd_ent */
M126_rd_ent:
/* QL:         lea     M126_fs_spare(a0),a1 */
    lea M126_fs_spare(a0),a1
/* QL: M126_rd_more */
M126_rd_more:
/* QL:         moveq   #M126_io.fstrg,d0 */
    moveq #M126_io.fstrg,d0
/* QL: M126_mdvrr */
M126_mdvrr:
/* QL:         jmp     dd_mdvrr(pc) */
    jmp dd_mdvrr(pc)
/* QL: * We get here once we have decided what to do. Restore the file header first. */
/* QL: M126_err_ex */
M126_err_ex:
/* QL:         moveq   #M126_err.ex,d0 */
    moveq #M126_err.ex,d0
/* QL: M126_done */
M126_done:
/* QL:         movem.l (sp)+,d5/a0/a1/a6 */
    movem.l (sp)+,d5/a0/a1/a6
/* QL:         move.l  (sp)+,4(a4) */
    move.l (sp)+,4(a4)
/* QL:         move.l  (sp)+,(a4) */
    move.l (sp)+,(a4)
/* QL:         move.w  (sp)+,-2(a4) */
    move.w (sp)+,(-2)(a4)
/* QL:         tst.l   d0              did we ok the rename? */
    tst.l d0
/* QL:         bne.s   M126_rts0            no - return the error */
    bne.s M126_rts0
/* QL: * We're going to (try to) change the name. It's convenient to put it in the */
/* QL: * channel first, as we then only need a single write to send it out. */
/* QL: * This also means we can pad out the entry with nulls, like it should be. */
/* QL: * The drawback is that we might then find we can't write the file! Ho hum. lwr. */
/* QL:         lea     M126_fs_fname+2+M126_fs.nmlen(a0),a3 */
    lea ((M126_fs_fname+2)+M126_fs.nmlen)(a0),a3
/* QL:         moveq   #M126_fs.nmlen/2,d0 */
    moveq #(M126_fs.nmlen/2),d0
/* QL: M126_zap */
M126_zap:
/* QL:         clr.w   -(a3)           wipe out the old name */
    clr.w -(a3)
/* QL:         dbra    d0,M126_zap */
    dbra d0,M126_zap
/* QL:         move.w  (a1)+,d0        get new length */
    move.w (a1)+,d0
/* QL:         sub.w   d5,d0           correct length */
    sub.w d5,d0
/* QL:         add.w   d5,a1           skip drive bit */
    add.w d5,a1
/* QL:         move.w  d0,(a3)+        store the new name length */
    move.w d0,(a3)+
/* QL: M126_newnam */
M126_newnam:
/* QL:         move.b  (a1)+,(a3)+     put the new name in the channel */
    move.b (a1)+,(a3)+
/* QL:         subq.w  #1,d0 */
    subq.w #1,d0
/* QL:         bne.s   M126_newnam */
    bne.s M126_newnam
/* QL: * Now write it to the file header. we will presrve the file update state. */
/* QL:         move.b  M126_fs_updt(a0),d5  save update flag */
    move.b M126_fs_updt(a0),d5
/* QL:         move.l  (a4),d7         pick current back up */
    move.l (a4),d7
/* QL:         lea     M126_fs_fname(a0),a1 */
    lea M126_fs_fname(a0),a1
/* QL:         moveq   #M126_md_denam,d2 */
    moveq #M126_md_denam,d2
/* QL:         move.l  d2,(a4)         that's the bit we'll alter */
    move.l d2,(a4)
/* QL:         moveq   #2+M126_fs.nmlen,d2 */
    moveq #(2+M126_fs.nmlen),d2
/* QL:         moveq   #M126_io.sstrg,d0 */
    moveq #M126_io.sstrg,d0
/* QL:         bsr.s   M126_mdvrr */
    bsr.s M126_mdvrr
/* QL:         move.l  d7,(a4)         reset current location */
    move.l d7,(a4)
/* QL:         move.b  d5,M126_fs_updt(a0)  restore update flag */
    move.b d5,M126_fs_updt(a0)
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         bne.s   M126_rts0            ouch! that's not nice! channel already changed! */
    bne.s M126_rts0
/* QL:         jmp     dd_mdvcd(pc)    this will copy it to the directory */
    jmp dd_mdvcd(pc)
/* QL: M126_rts0 */
M126_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
