/* ROM section dd_mdvio */
.balign 2,0
/* QL: * d0 -i o- operation / error return */
/* QL: * d1 -i o- i/o M122_byte */
/* QL: * a0 -ip - channel definition */
/* QL: * a1 -i o- read/write buffer */
/* QL: * a2 -  o- physical definition */
/* QL: * d3/a3 destroyed */
/* QL: * A routine version of mdvio for mdvop and mdvcl */
/* QL: dd_mdvrr */
dd_mdvrr:
/* QL:         movem.l d0/d2/d4-d7/a4-a5,-(sp) */
    movem.l d0/d2/d4-d7/a4-a5,-(sp)
/* QL: M122_mdvrr */
M122_mdvrr:
/* QL:         movem.l (sp),d0/d2      restore call parameters */
    movem.l (sp),d0/d2
/* QL:         moveq   #0,d3           treat all calls as initial entry */
    moveq #0,d3
/* QL:         bsr.s   dd_mdvio */
    bsr.s dd_mdvio
/* QL:         addq.l  #-M122_err.nc,d0     if M122_err.nc do again */
.word 20608|((((-M122_err.nc))&7)<<9)
/* QL:         beq.s   M122_mdvrr */
    beq.s M122_mdvrr
/* QL:         subq.l  #-M122_err.nc,d0 */
.word 20864|((((-M122_err.nc))&7)<<9)
/* QL:         addq.l  #4,sp           discard saved op */
    addq.l #4,sp
/* QL:         movem.l (sp)+,d2/d4-d7/a4-a5 */
    movem.l (sp)+,d2/d4-d7/a4-a5
/* QL:         rts */
    rts 
/* QL: M122_fetch */
M122_fetch:
/* QL:         moveq   #0,d3           assume pending */
    moveq #0,d3
/* QL:         addq.b  #M122_io.edlin,d0 */
    addq.b #M122_io.edlin,d0
/* QL:         beq.s   M122_byte */
    beq.s M122_byte
/* QL:         move.w  #1<<8,d3        assume read (normal) */
    move.w #(1<<8),d3
/* QL:         subq.b  #M122_io.fline,d0 */
    subq.b #M122_io.fline,d0
/* QL:         bne.s   M122_byte_str */
    bne.s M122_byte_str
/* QL:         moveq   #10,d3          read to newline */
    moveq #10,d3
/* QL: M122_str */
M122_str:
/* QL:         add.l   a1,d7           find original start of buffer */
    add.l a1,d7
/* QL:         move.l  d7,-(sp)        and M122_save it */
    move.l d7,-(sp)
/* QL:         add.l   d2,d7           find original end of buffer */
    add.l d2,d7
/* QL:         jsr     dd_mdvbu(pc) */
    jsr dd_mdvbu(pc)
/* QL:         move.l  a1,d1           end address of part done */
    move.l a1,d1
/* QL:         sub.l   (sp)+,d1        total bytes so far transfered */
    sub.l (sp)+,d1
/* QL:         rts */
    rts 
/* QL: M122_err_ro */
M122_err_ro:
/* QL:         moveq   #M122_err.ro,d0      write on read only device */
    moveq #M122_err.ro,d0
/* QL:         rts */
    rts 
/* QL: M122_go_ser */
M122_go_ser:
/* QL:         moveq   #0,d7           initialise end pointer */
    moveq #0,d7
/* QL:         tst.l   d3              is it reentry? */
    tst.l d3
/* QL:         beq.s   M122_ser_op */
    beq.s M122_ser_op
/* QL:         sub.l   d1,d7           yes - some bytes have already been moved */
    sub.l d1,d7
/* QL: M122_ser_op */
M122_ser_op:
/* QL:         addq.b  #M122_io.sstrg-M122_io.edlin,d0 M122_check operation */
.word 20480|((((M122_io.sstrg-M122_io.edlin))&7)<<9)
/* QL:         beq.s   M122_err_bp */
    beq.s M122_err_bp
/* QL:         bmi.s   M122_fetch */
    bmi.s M122_fetch
/* QL:         cmp.b   #M122_io.share,M122_fs_acces(a0) is write permitted? */
    cmp.b #(M122_io.share&255),M122_fs_acces(a0)
/* QL:         beq.s   M122_err_ro */
    beq.s M122_err_ro
/* QL:         moveq   #-1,d3          a write operation */
    moveq #(-1),d3
/* QL:         subq.b  #M122_io.sbyte+1-M122_io.edlin,d0 which type of write? */
.word 20736|(((((M122_io.sbyte+1)-M122_io.edlin))&7)<<9)
/* QL:         beq.s   M122_err_bp */
    beq.s M122_err_bp
/* QL: M122_byte_str */
M122_byte_str:
/* QL:         bcc.s   M122_str */
    bcc.s M122_str
/* QL: M122_byte */
M122_byte:
/* QL:         move.l  sp,d7           pointer to end of buffer on stack */
    move.l sp,d7
/* QL:         move.l  d1,-(sp)        put whole of d1 onto stack */
    move.l d1,-(sp)
/* QL:         lea     3(sp),a1        and point to the lsb */
    lea 3(sp),a1
/* QL:         jsr     dd_mdvbu(pc) */
    jsr dd_mdvbu(pc)
/* QL:         move.l  (sp)+,d1        replace only lsb of d1 with result */
    move.l (sp)+,d1
/* QL:         rts */
    rts 
/* QL: * d6 -  o- drive id * 16 + 1<<bt.file, ready for slave block stuff */
/* QL: * a0 -ip - channel definition */
/* QL: * a2 -  o- physical definition */
/* QL: dd_mdvpd */
dd_mdvpd:
/* QL:         moveq   #0,d6           get drive id */
    moveq #0,d6
/* QL:         move.b  M122_fs_drive(a0),d6 */
    move.b M122_fs_drive(a0),d6
/* QL:         lsl.b   #2,d6           make an address */
    lsl.b #2,d6
/* QL:         lea     M122_sv_fsdef(a6),a2 get pointer to physical definition */
    lea M122_sv_fsdef(a6),a2
/* QL:         move.l  0(a2,d6.w),a2 */
    move.l 0(a2,d6.w),a2
/* QL:         lsl.b   #4-2,d6         into bits 7-4 ready for slave blocks */
    lsl.b #(4-2),d6
/* QL:         addq.l  #1<<M122_bt..file,d6 and set file bit */
    addq.l #(1<<M122_bt..file),d6
/* QL:         rts */
    rts 
/* QL: * Driver entry point for input/output */
/* QL: * d0 -i o- operation / error return */
/* QL: * d1 -i o- bytes transferred so far or i/o M122_byte */
/* QL: * d2 -i  - buffer maximum length */
/* QL: * a0 -ip - channel definition */
/* QL: * a1 -i o- read/write buffer */
/* QL: * a2 -  o- physical definition */
/* QL: * d4-d7/a3-a5 destroyed */
/* QL: dd_mdvio */
dd_mdvio:
/* QL:         bsr.s   dd_mdvpd        get id and address of physical definition */
    bsr.s dd_mdvpd
/* QL: * Sort out operation */
/* QL:         cmp.b   #M122_fs.check,d0    M122_check if it is a file operation */
    cmp.b #(M122_fs.check&255),d0
/* QL:         bcc.s   M122_fileio */
    bcc.s M122_fileio
/* QL:         ext.l   d1              normal io calls use word counters only */
    ext.l d1
/* QL:         ext.l   d2 */
    ext.l d2
/* QL: M122_serio */
M122_serio:
/* QL:         subq.b  #M122_io.sstrg,d0    is operation in range? */
    subq.b #M122_io.sstrg,d0
/* QL:         bls.s   M122_go_ser          yes - putter on up above */
    bls.s M122_go_ser
/* QL: M122_err_bp */
M122_err_bp:
/* QL:         moveq   #M122_err.bp,d0 */
    moveq #M122_err.bp,d0
/* QL:         rts */
    rts 
/* QL: M122_fileio */
M122_fileio:
/* QL:         cmp.b   #M122_fs.check+M122_fop_top-M122_fop_tab-1,d0 is it out of range? */
    cmp.b #((((M122_fs.check+M122_fop_top)-M122_fop_tab)-1)&255),d0
/* QL:         bhi.s   M122_err_bp */
    bhi.s M122_err_bp
/* QL:         move.b  M122_fop_tab-M122_fs.check(pc,d0.w),d0 branch to file operation */
    move.b (M122_fop_tab-M122_fs.check)(pc,d0.w),d0
/* QL:         add.w   d0,d0 */
    add.w d0,d0
/* QL:         jmp     M122_fop_jmp(pc,d0.w) */
.word 0x4efb
.word 0|((M122_fop_jmp-.)&255)
/* QL: M122_fop_jmp */
M122_fop_jmp:
/* QL: M122_load */
M122_load:
/* QL: * N.B. This is a bit wierd, to say the least! */
/* QL: * If the length requested is less than 4096, the current file position is used, */
/* QL: * d2 bytes are read from there and the buffer address can be odd. */
/* QL: * However, if the length is greater than or equal to 4096, the scatter M122_load */
/* QL: * totally ignores the current file postion and d2 then reads the whole file. */
/* QL: * The latter even used to crash if the buffer address was odd. */
/* QL:         moveq   #M122_io.fstrg,d0    M122_load is M122_fetch string */
    moveq #M122_io.fstrg,d0
/* QL:         cmp.l   #4096,d2        is file not very huge? */
    cmp.l #4096,d2
/* QL:         blt.s   M122_serio           ... yes - serial M122_load */
    blt.s M122_serio
/* QL:         move.w  a1,d4 */
    move.w a1,d4
/* QL:         asr.b   #1,d4 */
    asr.b #1,d4
/* QL:         bcs.s   M122_serio           serial if address is odd (lwr) */
    bcs.s M122_serio
/* QL:         bsr.s   M122_flush           ensure all blocks are on medium */
    bsr.s M122_flush
/* QL:         bne.s   M122_rts0 */
    bne.s M122_rts0
/* QL:         jmp     dd_mdvsc(pc)    M122_load is scatter */
    jmp dd_mdvsc(pc)
/* QL: M122_save */
M122_save:
/* QL:         moveq   #M122_io.sstrg,d0    M122_save is send string */
    moveq #M122_io.sstrg,d0
/* QL:         bra.s   M122_serio */
    bra.s M122_serio
/* QL: * Read and set header calls are assumed to complete in one operation */
/* QL: * as the header is all in one block */
/* QL: M122_heads */
M122_heads:
/* QL:         moveq   #M122_io.sstrg,d0 to set header - send string */
    moveq #M122_io.sstrg,d0
/* QL:         moveq   #M122_md_denam,d2    of 14 bytes (up to, not including, name length) */
    moveq #M122_md_denam,d2
/* QL: M122_head */
M122_head:
/* QL:         assert  M122_fs_nblok,M122_fs_nbyte-2 */
/* original assertion: M122_fs_nblok,M122_fs_nbyte-2 */
/* QL:         clr.l   M122_fs_nblok(a0)    read from / write to 0 */
    clr.l M122_fs_nblok(a0)
/* QL:         bsr.s   M122_serio           serially */
    bsr.s M122_serio
/* QL:         moveq   #M122_fs.hdlen,d4 */
    moveq #M122_fs.hdlen,d4
/* QL:         move.w  d4,M122_fs_nbyte(a0) reset pointer to start of file */
    move.w d4,M122_fs_nbyte(a0)
/* QL: M122_rts0 */
M122_rts0:
/* QL:         rts */
    rts 
/* QL: M122_headr */
M122_headr:
/* QL:         moveq   #M122_io.fstrg,d0    to read header - read string (no length limit!) */
    moveq #M122_io.fstrg,d0
/* QL:         move.l  a1,-(sp)        M122_save header pointer */
    move.l a1,-(sp)
/* QL:         bsr.s   M122_head */
    bsr.s M122_head
/* QL:         move.l  (sp)+,a2 */
    move.l (sp)+,a2
/* QL:         sub.l   d4,(a2)         (N.B. caller buffer must be even addr!!!) */
    sub.l d4,(a2)
/* QL:         rts */
    rts 
/* QL: M122_test_bof */
M122_test_bof:
/* QL:         sub.l   d2,d1           take away header length */
    sub.l d2,d1
/* QL:         bge.s   M122_set_nblk */
    bge.s M122_set_nblk
/* QL: M122_set_bof */
M122_set_bof:
/* QL:         moveq   #0,d1           show caller new position */
    moveq #0,d1
/* QL:         move.l  d2,d0           reset to beginning of file */
    move.l d2,d0
/* QL: M122_set_nblk */
M122_set_nblk:
/* QL:         move.l  d0,M122_fs_nblok(a0) */
    move.l d0,M122_fs_nblok(a0)
/* QL: M122_set_iop */
M122_set_iop:
/* QL:         moveq   #M122_io.pend,d0 */
    moveq #M122_io.pend,d0
/* QL:         bra.s   M122_serio */
    bra.s M122_serio
/* QL: M122_posab */
M122_posab:
/* QL:         moveq   #M122_fs.hdlen,d2    get length of header */
    moveq #M122_fs.hdlen,d2
/* QL:         add.l   d2,d1           set actual file pointer */
    add.l d2,d1
/* QL: M122_test_ovf */
M122_test_ovf:
/* QL:         bvc.s   M122_test_eof        ok if it didn't overflow */
    bvc.s M122_test_eof
/* QL:         roxr.l  #1,d1           otherwise this'll set an extreme value */
    roxr.l #1,d1
/* QL: M122_test_eof */
M122_test_eof:
/* QL:         move.l  d1,d0           preserve address */
    move.l d1,d0
/* QL:         bmi.s   M122_set_bof         negative then force to bottom */
    bmi.s M122_set_bof
/* QL:         asl.l   #6,d0           and put new M122_byte address in appropriate form */
    asl.l #6,d0
/* QL:         bvs.s   M122_set_eof         if huge, set eof */
    bvs.s M122_set_eof
/* QL:         add.l   d0,d0 */
    add.l d0,d0
/* QL:         lsr.w   #7,d0 */
    lsr.w #7,d0
/* QL:         cmp.l   M122_fs_eblok(a0),d0 is it beyond end of file? */
    cmp.l M122_fs_eblok(a0),d0
/* QL:         bls.s   M122_test_bof */
    bls.s M122_test_bof
/* QL: M122_set_eof */
M122_set_eof:
/* QL:         assert  M122_fs_eblok,M122_fs_ebyte-2 */
/* original assertion: M122_fs_eblok,M122_fs_ebyte-2 */
/* QL:         move.l  M122_fs_eblok(a0),d0 yes - set pointer to end of file */
    move.l M122_fs_eblok(a0),d0
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         bra.s   M122_con_byte */
    bra.s M122_con_byte
/* QL: M122_posre */
M122_posre:
/* QL:         tst.l   d3              do not move pointer if it is re-entry */
    tst.l d3
/* QL:         bne.s   M122_set_iop */
    bne.s M122_set_iop
/* QL:         moveq   #M122_fs.hdlen,d2    get length of header */
    moveq #M122_fs.hdlen,d2
/* QL:         assert  M122_fs_nblok,M122_fs_nbyte-2 */
/* original assertion: M122_fs_nblok,M122_fs_nbyte-2 */
/* QL:         move.l  M122_fs_nblok(a0),d0 get current pointer */
    move.l M122_fs_nblok(a0),d0
/* QL: M122_con_byte */
M122_con_byte:
/* QL:         lsl.w   #7,d0           ... in M122_byte address form */
    lsl.w #7,d0
/* QL:         lsr.l   #7,d0 */
    lsr.l #7,d0
/* QL:         add.l   d0,d1           add it to adjustment */
    add.l d0,d1
/* QL:         bra.s   M122_test_ovf */
    bra.s M122_test_ovf
/* QL: M122_fop_tab */
M122_fop_tab:
/* QL:         dc.b    (M122_check-M122_fop_jmp)/2 */
M122_dc_anchor_811:
.byte (((M122_check-M122_fop_jmp)/2))&255
/* QL:         dc.b    (M122_flush-M122_fop_jmp)/2 */
M122_dc_anchor_814:
.byte (((M122_flush-M122_fop_jmp)/2))&255
/* QL:         dc.b    (M122_posab-M122_fop_jmp)/2 */
M122_dc_anchor_817:
.byte (((M122_posab-M122_fop_jmp)/2))&255
/* QL:         dc.b    (M122_posre-M122_fop_jmp)/2 */
M122_dc_anchor_820:
.byte (((M122_posre-M122_fop_jmp)/2))&255
/* QL:         dc.b    (M122_err_bp-M122_fop_jmp)/2 */
M122_dc_anchor_823:
.byte (((M122_err_bp-M122_fop_jmp)/2))&255
/* QL:         dc.b    (M122_mdinf-M122_fop_jmp)/2 */
M122_dc_anchor_826:
.byte (((M122_mdinf-M122_fop_jmp)/2))&255
/* QL:         dc.b    (M122_heads-M122_fop_jmp)/2 */
M122_dc_anchor_829:
.byte (((M122_heads-M122_fop_jmp)/2))&255
/* QL:         dc.b    (M122_headr-M122_fop_jmp)/2 */
M122_dc_anchor_832:
.byte (((M122_headr-M122_fop_jmp)/2))&255
/* QL:         dc.b    (M122_load-M122_fop_jmp)/2 */
M122_dc_anchor_835:
.byte (((M122_load-M122_fop_jmp)/2))&255
/* QL:         dc.b    (M122_save-M122_fop_jmp)/2 */
M122_dc_anchor_838:
.byte (((M122_save-M122_fop_jmp)/2))&255
/* QL:         dc.b    (M122_renam-M122_fop_jmp)/2 */
M122_dc_anchor_841:
.byte (((M122_renam-M122_fop_jmp)/2))&255
/* QL:         dc.b    (M122_trunc-M122_fop_jmp)/2 */
M122_dc_anchor_844:
.byte (((M122_trunc-M122_fop_jmp)/2))&255
/* QL: M122_fop_top */
M122_fop_top:
/* QL:         ds.w    0 */
.balign 2,0
/* QL: M122_check */
M122_check:
/* QL:         moveq   #M122_bt.true,d4     M122_check all blocks are true copies */
    moveq #M122_bt.true,d4
/* QL:         moveq   #-1,d5          nc if not true */
    moveq #(-1),d5
/* QL:         bra.s   M122_cf_com */
    bra.s M122_cf_com
/* QL: M122_flush */
M122_flush:
/* QL:         moveq   #M122_bt.actn,d4     M122_check if any action pending */
    moveq #M122_bt.actn,d4
/* QL:         moveq   #0,d5           nc if true */
    moveq #0,d5
/* QL: M122_cf_com */
M122_cf_com:
/* QL:         jsr     dd_mdvlu(pc)    make sure length and update are set */
    jsr dd_mdvlu(pc)
/* QL:         bne.s   M122_rts1            ouch - it didn't work */
    bne.s M122_rts1
/* QL:         move.w  M122_fs_filnr(a0),d2 get file number */
    move.w M122_fs_filnr(a0),d2
/* QL:         move.l  M122_sv_bttop(a6),a4 scan through slave blocks */
    move.l M122_sv_bttop(a6),a4
/* QL: M122_cf_loop */
M122_cf_loop:
/* QL:         cmp.l   M122_sv_btbas(a6),a4 done bottom yet? */
    cmp.l M122_sv_btbas(a6),a4
/* QL:         beq.s   M122_rts1 */
    beq.s M122_rts1
/* QL:         subq.l  #M122_bt_end,a4      next block */
    subq.l #M122_bt_end,a4
/* QL:         moveq   #-16+1<<M122_bt..file,d3 M122_check drive number, file block bit */
    moveq #((-16)+(1<<M122_bt..file)),d3
/* QL:         assert  0,M122_bt_stat */
/* original assertion: 0,M122_bt_stat */
/* QL:         and.b   (a4),d3 */
    and.b (a4),d3
/* QL:         cmp.b   d6,d3 */
    cmp.b d6,d3
/* QL:         bne.s   M122_cf_loop         not the right drive */
    bne.s M122_cf_loop
/* QL:         cmp.w   M122_bt_filnr(a4),d2 */
    cmp.w M122_bt_filnr(a4),d2
/* QL:         bne.s   M122_cf_loop         not the right file */
    bne.s M122_cf_loop
/* QL:         move.b  (a4),d0         M122_check the status bits (the right way round) */
    move.b (a4),d0
/* QL:         eor.b   d5,d0 */
    eor.b d5,d0
/* QL:         and.b   d4,d0 */
    and.b d4,d0
/* QL:         beq.s   M122_cf_loop */
    beq.s M122_cf_loop
/* QL:         jmp     md_slave(pc)    sets d0=M122_err.nc for us */
    jmp md_slave(pc)
/* QL: M122_renam */
M122_renam:
/* QL:         jmp     dd_mdvrn(pc) */
    jmp dd_mdvrn(pc)
/* QL: M122_trunc */
M122_trunc:
/* QL:         jmp     dd_mdvtr(pc) */
    jmp dd_mdvtr(pc)
/* QL: M122_mdinf */
M122_mdinf:
/* QL:         lea     M122_md_mname(a2),a3 copy name (nb user buffer may now be odd! lwr) */
    lea M122_md_mname(a2),a3
/* QL:         moveq   #10,d1 */
    moveq #10,d1
/* QL: M122_copyinf */
M122_copyinf:
/* QL:         move.b  (a3)+,(a1)+ */
    move.b (a3)+,(a1)+
/* QL:         subq.b  #1,d1 */
    subq.b #1,d1
/* QL:         bne.s   M122_copyinf */
    bne.s M122_copyinf
/* QL:         move.w  #M122_maxsec*2-2,d0  search for good (and M122_vacant sectors) */
    move.w #((M122_maxsec*2)-2),d0
/* QL:         moveq   #1,d2           include sector 0 in good count */
    moveq #1,d2
/* QL: M122_inf_loop */
M122_inf_loop:
/* QL:         cmp.b   #M122_vacant,M122_md_map(a2,d0.w) is it M122_vacant? */
    cmp.b #(M122_vacant&255),M122_md_map(a2,d0.w)
/* QL:         bhi.s   M122_inf_next        bad */
    bhi.s M122_inf_next
/* QL:         bne.s   M122_inf_good        in use */
    bne.s M122_inf_good
/* QL:         addq.w  #1,d1           M122_vacant */
    addq.w #1,d1
/* QL: M122_inf_good */
M122_inf_good:
/* QL:         addq.w  #1,d2           good */
    addq.w #1,d2
/* QL: M122_inf_next */
M122_inf_next:
/* QL:         subq.w  #2,d0           take next sector */
    subq.w #2,d0
/* QL:         bne.s   M122_inf_loop        (N.B. d0.l = 0 at end) */
    bne.s M122_inf_loop
/* QL:         swap    d1              put both the return args in d1 */
    swap d1
/* QL:         move.w  d2,d1 */
    move.w d2,d1
/* QL: M122_rts1 */
M122_rts1:
/* QL:         rts */
    rts 
/* QL:         end */
