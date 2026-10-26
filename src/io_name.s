/* ROM section io_name */
.balign 2,0
/* QL: * d0 -  o- error code */
/* QL: * a0 -ip - pointer to name, prefixed with word character count */
/* QL: * a3 -ip - pointer to result parameter block */
/* QL: * d1-d3/a1-a2 destroyed (in fact, d3 is preserved, but documentation says not!) */
/* QL: reglist reg d4/d7/a0/a3-a4 */
/* QL: io_name */
io_name:
/* QL:         move.l  (sp)+,a2        basic return address taken off stack */
    move.l (sp)+,a2
/* QL:         movem.l reglist,-(sp)   save useful registers */
    movem.l d4/d7/a0/a3-a4,-(sp)
/* QL:         lea     6(a2),a4        find start of description */
    lea 6(a2),a4
/* QL:         moveq   #0,d7           set up end of string address */
    moveq #0,d7
/* QL:         move.w  (a0)+,d7        M14_fetch string length */
    move.w (a0)+,d7
/* QL:         add.l   a0,d7           add start address of string */
    add.l a0,d7
/* QL:         move.w  (a4)+,d2        find number of characters in name */
    move.w (a4)+,d2
/* QL:         moveq   #1,d4 */
    moveq #1,d4
/* QL:         and.b   d2,d4           remember if length is odd */
    and.b d2,d4
/* QL:         moveq   #M14_err.nf,d0      ready for name not recognised */
    moveq #M14_err.nf,d0
/* QL: M14_name_lp */
M14_name_lp:
/* QL:         bsr.s   M14_fetch           get next character */
    bsr.s M14_fetch
/* QL:         cmp.b   (a4)+,d1        how about it */
    cmp.b (a4)+,d1
/* QL:         bne.s   M14_exit */
    bne.s M14_exit
/* QL:         subq.w  #1,d2 */
    subq.w #1,d2
/* QL:         bne.s   M14_name_lp */
    bne.s M14_name_lp
/* QL:         add.w   d4,a4           round up to get word boundry */
    add.w d4,a4
/* QL:         move.w  (a4)+,d4        set up number of options */
    move.w (a4)+,d4
/* QL:         bra.s   M14_end_opt */
    bra.s M14_end_opt
/* QL: M14_chk_opt */
M14_chk_opt:
/* QL:         move.b  (a4)+,d1        check next option type */
    move.b (a4)+,d1
/* QL:         beq.s   M14_char_lst */
    beq.s M14_char_lst
/* QL:         blt.s   M14_no_sep */
    blt.s M14_no_sep
/* QL: M14_sep */
M14_sep:
/* QL:         bsr.s   M14_fetch           M14_fetch next character */
    bsr.s M14_fetch
/* QL:         cmp.b   (a4)+,d1        is the right separator? */
    cmp.b (a4)+,d1
/* QL:         beq.s   M14_read_val */
    beq.s M14_read_val
/* QL:         subq.l  #1,a0           reset name pointer */
    subq.l #1,a0
/* QL:         move.w  (a4)+,(a3)+     put default on */
    move.w (a4)+,(a3)+
/* QL:         bra.s   M14_end_opt */
    bra.s M14_end_opt
/* QL: M14_no_sep */
M14_no_sep:
/* QL:         addq.l  #1,a4           move definition pointer on */
    addq.l #1,a4
/* QL: M14_read_val */
M14_read_val:
/* QL:         move.w  (a4)+,(a3)+     put default in result */
    move.w (a4)+,(a3)+
/* QL:         move.l  a6,-(sp)        save base register */
    move.l a6,-(sp)
/* QL:         sub.l   a6,a6           dtoi is double register addressed */
    sub.l a6,a6
/* QL:         move.l  a3,a1           succesful dtoi will overwrite default */
    move.l a3,a1
/* QL:         jsr     cn_dtoi(pc)     M14_fetch integer */
    jsr cn_dtoi(pc)
/* QL:         move.l  (sp)+,a6 */
    move.l (sp)+,a6
/* QL:         bra.s   M14_end_opt */
    bra.s M14_end_opt
/* QL: M14_char_lst */
M14_char_lst:
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.b  (a4)+,d2        M14_fetch number of possible characters */
    move.b (a4)+,d2
/* QL:         add.w   d2,a4           goto end of list */
    add.w d2,a4
/* QL:         move.l  a4,-(sp)        save it! */
    move.l a4,-(sp)
/* QL:         moveq   #1,d1 */
    moveq #1,d1
/* QL:         and.b   d2,d1 */
    and.b d2,d1
/* QL:         add.l   d1,(sp)         round saved pointer up to even */
    add.l d1,(sp)
/* QL:         bsr.s   M14_fetch           get character */
    bsr.s M14_fetch
/* QL: M14_char_lop */
M14_char_lop:
/* QL:         cmp.b   -(a4),d1        check this character */
    cmp.b -(a4),d1
/* QL:         beq.s   M14_char_fnd */
    beq.s M14_char_fnd
/* QL:         sub.w   #1,d2           decrement counter (character number) */
    sub.w #1,d2
/* QL:         bne.s   M14_char_lop */
    bne.s M14_char_lop
/* QL:         subq.l  #1,a0 */
    subq.l #1,a0
/* QL: M14_char_fnd */
M14_char_fnd:
/* QL:         move.w  d2,(a3)+        put character value in result */
    move.w d2,(a3)+
/* QL:         move.l  (sp)+,a4        point to next bit of definition */
    move.l (sp)+,a4
/* QL: M14_end_opt */
M14_end_opt:
/* QL:         dbra    d4,M14_chk_opt      look at next option */
    dbra d4,M14_chk_opt
/* QL:         addq.l  #2,a2           move return address by two */
    addq.l #2,a2
/* QL:         moveq   #M14_err.bn,d0      bad parameter(s) */
    moveq #M14_err.bn,d0
/* QL:         cmp.l   a0,d7           should now be pointing at end */
    cmp.l a0,d7
/* QL:         bne.s   M14_exit */
    bne.s M14_exit
/* QL:         addq.l  #2,a2           move return address by a further two */
    addq.l #2,a2
/* QL:         moveq   #0,d0           wow! all ok */
    moveq #0,d0
/* QL: M14_exit */
M14_exit:
/* QL:         movem.l (sp)+,reglist   restore all registers */
    movem.l (sp)+,d4/d7/a0/a3-a4
/* QL:         jmp     (a2) */
    jmp (a2)
/* QL: M14_fetch */
M14_fetch:
/* QL:         cmp.l   d7,a0           check if off end of buffer */
    cmp.l d7,a0
/* QL:         scs     d1              set $ff if still in buffer, 0 otherwise */
    scs d1
/* QL:         and.b   (a0)+,d1        M14_fetch next character (0 iff off buffer) */
    and.b (a0)+,d1
/* QL:         cmp.b   #'_'+1,d1       is it outside TTY set */
    cmp.b #((95+1)&255),d1
/* QL:         blt.s   M14_rts0            .. no */
    blt.s M14_rts0
/* QL:         sub.b   #' ',d1 */
    sub.b #(32&255),d1
/* QL: M14_rts0 */
M14_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
