/* ROM section io_fdriv */
.balign 2,0
/* QL: * Note: this routine now imposes the following two constraints on directory */
/* QL: * device driver names, failing which, they will always result in err.nf. */
/* QL: * Firstly, they must be longer than one character (and less than 32768!). The */
/* QL: * exclusion of zero length names is needed as nfs_use in tk2 "hides" it's */
/* QL: * dd entry as a zero length name when it is not in use. */
/* QL: * Secondly, they must have bit 5 clear in all bytes. This excludes lowercase */
/* QL: * 'a' to 'z', uppercase ' ' to '«', digits and various other characters. */
/* QL: * When matching, the caller's characters have bit 5 cleared before the */
/* QL: * comparison, so the net result is a case insensitive match, but with various */
/* QL: * other characters treated as matching. A digit in the range '1' to '8' after */
/* QL: * the first character of the caller's name will invariably be expected to mark */
/* QL: * the exact end of the dd name part, and must be followed by an underscore. */
/* QL: * This syntax does allow in a few obscurities, but so far nobody has tried to */
/* QL: * produce a driver whose name contains anything but uppercase 'a' to 'z'. */
/* QL: * The original code had various bugs, including the fact that if one driver on */
/* QL: * the list was preceeded by one with a shorter name, it was never found! */
/* QL: * The above bug detected by Tony Tebby, when he got the network driver in front */
/* QL: * of another driver starting with an 'n' */
/* QL: * d0 -  o- negative error code */
/* QL: * d1 -  o- drive number */
/* QL: * d4 -  o- physical definition slot number */
/* QL: * d5 -  o- first vacant physical slot number */
/* QL: * a0 -ip - pointer to name */
/* QL: * a1 -  o- contents of physical definition slot */
/* QL: * a2 -  o- pointer to driver */
/* QL: * a4 -  o- address of physical definition slot */
/* QL: * Condition codes on return define the results: */
/* QL: * n: M12_err.nf no driver found (d0 = M12_err.nf, other regs above undefined) */
/* QL: * z: existing physical definition found (d0=0, d5 undefined, rest as above) */
/* QL: * ~n&~z: no physical definition yet present and: */
/* QL: *    d5=M12_err.no if there is no free space for one (d0=0, d1/a2 set, rest undef) */
/* QL: *    d5=vacant slot number (d0=0, d1/a2 set, a4 is slot 0 address!, rest undef) */
/* QL: M12_err_nf */
M12_err_nf:
/* QL:         moveq   #M12_err.nf,d0 */
    moveq #M12_err.nf,d0
/* QL:         rts */
    rts 
/* QL: io_fdriv */
io_fdriv:
/* QL:         moveq   #'_',d0         the requisit underscore and zero to msw */
    moveq #95,d0
/* QL:         moveq   #1,d4           driver name must be at least one char */
    moveq #1,d4
/* QL: * nb. nfs_use in tk2 hides as zero length name! so nobody else can. (lwr) */
/* QL: M12_under */
M12_under:
/* QL:         addq.w  #1,d4           don't bother with 1st char, as that can't work */
    addq.w #1,d4
/* QL:         cmp.w   (a0),d4         check offset against length of their name */
    cmp.w (a0),d4
/* QL:         bge.s   M12_err_nf          we've run out of name */
    bge.s M12_err_nf
/* QL:         cmp.b   2(a0,d4.w),d0   have we found an underscore? */
    cmp.b 2(a0,d4.w),d0
/* QL:         bne.s   M12_under           no - carry on looking */
    bne.s M12_under
/* QL:         subq.w  #1,d4           this is now the char count of the dd name */
    subq.w #1,d4
/* QL:         moveq   #'8',d1         dd name must be followed by a digit '1' to '8' */
    moveq #56,d1
/* QL:         sub.b   2(a0,d4.w),d1   should be 7 to 0 for char '1' to '8' */
    sub.b 2(a0,d4.w),d1
/* QL:         subq.b  #8,d1           now -1 to -8 for char '1' to '8' */
    subq.b #8,d1
/* QL:         bcc.s   M12_err_nf          wasn't '1' to '8' - can't use this name! */
    bcc.s M12_err_nf
/* QL:         neg.b   d1              make it into a proper drive number 1 to 8 */
    neg.b d1
/* QL:         lea     M12_sv_ddlst(a6),a2 get start of directory driver list */
    lea M12_sv_ddlst(a6),a2
/* QL: M12_nxt_driv */
M12_nxt_driv:
/* QL:         assert  0,M12_ch_next */
/* original assertion: 0,M12_ch_next */
/* QL:         move.l  (a2),d5         check for a next driver */
    move.l (a2),d5
/* QL:         beq.s   M12_err_nf          none left - not found */
    beq.s M12_err_nf
/* QL:         move.l  d5,a2 */
    move.l d5,a2
/* QL:         move.w  M12_ch_drnam(a2),d0 this is the length of this dd name */
    move.w M12_ch_drnam(a2),d0
/* QL:         cmp.w   d0,d4           must match caller's number of characters */
    cmp.w d0,d4
/* QL:         bne.s   M12_nxt_driv        name not right length, so skip it */
    bne.s M12_nxt_driv
/* QL: M12_nxt_char */
M12_nxt_char:
/* QL:         moveq   #-1-1<<5,d5     force upper case */
    moveq #((-1)-(1<<5)),d5
/* QL:         and.b   2-1(a0,d0.w),d5 next character */
    and.b (2-1)(a0,d0.w),d5
/* QL:         cmp.b   2-1+M12_ch_drnam(a2,d0.w),d5 is it the same */
    cmp.b ((2-1)+M12_ch_drnam)(a2,d0.w),d5
/* QL:         bne.s   M12_nxt_driv        no - try next driver */
    bne.s M12_nxt_driv
/* QL:         subq.w  #1,d0           check next character if any left */
    subq.w #1,d0
/* QL:         bne.s   M12_nxt_char */
    bne.s M12_nxt_char
/* QL: * Note: we have d0.l = 0 from this point on, ready for ok return */
/* QL: * We now know the drive type (pointed to by a2) and the number (d1) */
/* QL:         moveq   #16-1,d4        check list of sixteen drives */
    moveq #(16-1),d4
/* QL:         moveq   #M12_err.no,d5      no hole yet */
    moveq #M12_err.no,d5
/* QL:         lea     M12_sv_fsdef+16*4(a6),a4 get address of top end of list */
    lea (M12_sv_fsdef+(16*4))(a6),a4
/* QL: M12_chk_driv */
M12_chk_driv:
/* QL:         tst.l   -(a4)           address of physical definition */
    tst.l -(a4)
/* QL:         beq.s   M12_set_hole */
    beq.s M12_set_hole
/* QL:         move.l  (a4),a1 */
    move.l (a4),a1
/* QL:         cmp.b   M12_fs_drivn(a1),d1 compare drive number */
    cmp.b M12_fs_drivn(a1),d1
/* QL:         bne.s   M12_end_driv */
    bne.s M12_end_driv
/* QL:         cmp.l   M12_fs_drivr(a1),a2 compare driver */
    cmp.l M12_fs_drivr(a1),a2
/* QL:         bne.s   M12_end_driv        all ok, everything is ready and slot found */
    bne.s M12_end_driv
/* QL:         rts */
    rts 
/* QL: M12_set_hole */
M12_set_hole:
/* QL:         move.l  d4,d5           save slot of hole */
    move.l d4,d5
/* QL: M12_end_driv */
M12_end_driv:
/* QL:         subq.l  #1,d4 */
    subq.l #1,d4
/* QL:         bpl.s   M12_chk_driv */
    bpl.s M12_chk_driv
/* QL:         moveq   #1,d4           say we didn't find an existing slot */
    moveq #1,d4
/* QL:         rts */
    rts 
/* QL:         end */
