/* ROM section bp_let */
.balign 2,0
/* QL: * d0 -  o- 0 (this routine doesn't believe in errors!) */
/* QL: * d5 -ip - low limit, if assigning to a substring of a simple string variable */
/* QL: * d6 -ip - high limit, ditto */
/* QL: * a1 -  o- RI stack pointer */
/* QL: * a2 -ip - VV area, if assigning to a substring of a simple string variable */
/* QL: * a3 -ip - pointer to NT entry */
/* QL: * d1-d2 destroyed */
/* QL: reg_let reg     d4/a0/a3-a5 */
/* QL: bp_let */
bp_let:
/* QL:         movem.l reg_let,-(sp) */
    movem.l d4/a0/a3-a5,-(sp)
/* QL:         moveq   #15,d0 */
    moveq #15,d0
/* QL:         and.b   1(a6,a3.l),d0   mask seps */
    and.b 1(a6,a3.l),d0
/* QL:         tst.b   M49_bv_uproc(a6)    is there a user trace procedure? */
    tst.b M49_bv_uproc(a6)
/* QL:         bpl.s   M49_noup */
    bpl.s M49_noup
/* QL:         jsr     bv_uplet(pc)    yes - go see to it */
    jsr bv_uplet(pc)
/* QL: M49_noup */
M49_noup:
/* QL:         bsr.s   M49_main */
    bsr.s M49_main
/* QL:         add.l   d1,a1 */
    add.l d1,a1
/* QL:         move.l  a1,M49_bv_rip(a6) */
    move.l a1,M49_bv_rip(a6)
/* QL:         movem.l (sp)+,reg_let */
    movem.l (sp)+,d4/a0/a3-a5
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * Assign a floating point to var or array */
/* QL: M49_let_fp */
M49_let_fp:
/* QL:         moveq   #6,d1           entry should be 6 bytes long */
    moveq #6,d1
/* QL:         bsr.s   M49_ch_off          get the space */
    bsr.s M49_ch_off
/* QL:         move.l  2(a6,a1.l),2(a6,a0.l) copy mantissa */
    move.l 2(a6,a1.l),2(a6,a0.l)
/* QL:         bra.s   M49_int_fp */
    bra.s M49_int_fp
/* QL: M49_main */
M49_main:
/* QL:         moveq   #2,d1           2 bytes needed for integer, and clear msw */
    moveq #2,d1
/* QL:         subq.b  #M49_t.fp,d0 */
    subq.b #M49_t.fp,d0
/* QL:         bmi.s   M49_let_str         assign to a string of some sort */
    bmi.s M49_let_str
/* QL:         beq.s   M49_let_fp          assign to floating point */
    beq.s M49_let_fp
/* QL:         bsr.s   M49_ch_off          check it has a value pointer */
    bsr.s M49_ch_off
/* QL: M49_int_fp */
M49_int_fp:
/* QL:         move.w  0(a6,a1.l),0(a6,a0.l) put 1st word into VV area */
    move.w 0(a6,a1.l),0(a6,a0.l)
/* QL: M49_ch_type */
M49_ch_type:
/* QL:         moveq   #M49_t.var,d0 */
    moveq #M49_t.var,d0
/* QL:         cmp.b   0(a6,a3.l),d0   look at variable type */
    cmp.b 0(a6,a3.l),d0
/* QL:         ble.s   M49_rts0            vt already set */
    ble.s M49_rts0
/* QL:         move.b  d0,0(a6,a3.l)   set variable type to simple var */
    move.b d0,0(a6,a3.l)
/* QL: M49_rts0 */
M49_rts0:
/* QL:         rts */
    rts 
/* QL: M49_ch_off */
M49_ch_off:
/* QL:         move.l  4(a6,a3.l),d4   current offset on VV table */
    move.l 4(a6,a3.l),d4
/* QL:         bpl.s   M49_get_pos         ..it's all right */
    bpl.s M49_get_pos
/* QL: * d0 -  o- 0 */
/* QL: * d1 -ip - space required from VV area */
/* QL: * d4 -  o- VV offset of new space */
/* QL: * a0 -  o- rel a6 address of new space */
/* QL: * a1 -  o- RI stack pointer (a bonus!) */
/* QL: * a3 -ip - NT entry to receive space */
/* QL: bp_alvv */
bp_alvv:
/* QL:         jsr     bv_alvv(pc)     get the required space & set a1=M49_bv_rip(a6) */
    jsr bv_alvv(pc)
/* QL:         move.l  a0,d4 */
    move.l a0,d4
/* QL:         sub.l   M49_bv_vvbas(a6),d4 get the offset */
    sub.l M49_bv_vvbas(a6),d4
/* QL:         move.l  d4,4(a6,a3.l)   and fill it in */
    move.l d4,4(a6,a3.l)
/* QL:         rts */
    rts 
/* QL: M49_cht_get */
M49_cht_get:
/* QL:         bsr.s   M49_ch_type */
    bsr.s M49_ch_type
/* QL: * Get positions of assignee & assignor */
/* QL: * a0 -  o- VV position of destination string */
/* QL: * a1 -  o- RI pointer of source string */
/* QL: * d4 -i  - offset of array values on VV */
/* QL: M49_get_pos */
M49_get_pos:
/* QL:         move.l  M49_bv_vvbas(a6),a0 */
    move.l M49_bv_vvbas(a6),a0
/* QL:         add.l   d4,a0 */
    add.l d4,a0
/* QL:         move.l  M49_bv_rip(a6),a1 */
    move.l M49_bv_rip(a6),a1
/* QL:         rts */
    rts 
/* QL: * Assign a string to something */
/* QL: M49_let_str */
M49_let_str:
/* QL:         move.l  M49_bv_rip(a6),a1 */
    move.l M49_bv_rip(a6),a1
/* QL: * We rather assume that the given string length is sensible! */
/* QL:         move.w  0(a6,a1.l),d1   length of string to be assigned */
    move.w 0(a6,a1.l),d1
/* QL:         cmp.b   #M49_t.arr,0(a6,a3.l) is this an array? */
    cmp.b #(M49_t.arr&255),0(a6,a3.l)
/* QL:         bne.s   M49_str_var         no - go for string varible */
    bne.s M49_str_var
/* QL:         move.l  4(a6,a3.l),a0   get descriptor offset */
    move.l 4(a6,a3.l),a0
/* QL:         add.l   M49_bv_vvbas(a6),a0 */
    add.l M49_bv_vvbas(a6),a0
/* QL:         move.w  6(a6,a0.l),d2   max length to replace */
    move.w 6(a6,a0.l),d2
/* QL:         move.l  0(a6,a0.l),d4   where to start replacement */
    move.l 0(a6,a0.l),d4
/* QL:         bsr.s   M49_set_par         get max copy and blank fill */
    bsr.s M49_set_par
/* QL:         bsr.s   M49_get_pos         get source and destination bases */
    bsr.s M49_get_pos
/* QL:         addq.b  #M49_t.fp,d0 */
    addq.b #M49_t.fp,d0
/* QL:         beq.s   M49_str_ret         no length if a substring of a string array */
    beq.s M49_str_ret
/* QL: * There was a strange anomaly here... for some reason there was an extra */
/* QL: * comparison of the copy length with the source length... it did nothing, but */
/* QL: * it looked as if it was meant to compare against the current length of the */
/* QL: * destination, then cause it to only expand in length. Wierd! */
/* QL: * Another thing it could have been an attempt at acheiving may have been to */
/* QL: * only blank fill to the extent of old length, which might make some sense, if */
/* QL: * string arrays were initially set to blanks... unfortunately, we now come up */
/* QL: * against compatability again. It would speed things up no end if we could */
/* QL: * scrap the blank filling, but I guess we're stuck with it! */
/* QL:         bra.s   M49_put_len         go duplicate copy length */
    bra.s M49_put_len
/* QL: M49_str_norm */
M49_str_norm:
/* QL:         addq.l  #1,d1 */
    addq.l #1,d1
/* QL:         bclr    #0,d1           round up assign length to even */
    bclr #0,d1
/* QL:         move.w  0(a6,a0.l),d0   get length of current string */
    move.w 0(a6,a0.l),d0
/* QL:         addq.l  #1,d0 */
    addq.l #1,d0
/* QL:         bclr    #0,d0           rounded up to even */
    bclr #0,d0
/* QL:         move.l  d0,d2 */
    move.l d0,d2
/* QL:         eor.l   d1,d0           any chance that old & new space is the same? */
    eor.l d1,d0
/* QL:         lsr.l   #3,d0           (we know VV space is in multiples of eight) */
    lsr.l #3,d0
/* QL:         beq.s   M49_fill_str        VV space is right mult of 8, so leave it */
    beq.s M49_fill_str
/* QL:         addq.l  #2,d2           total amount to free, a0 already set */
    addq.l #2,d2
/* QL:         exg     d2,d1           save d1, and set amount to release */
    exg d2,d1
/* QL:         jsr     bv_frvv(pc) */
    jsr bv_frvv(pc)
/* QL:         move.l  d2,d1           restore d1 */
    move.l d2,d1
/* QL: M49_crt_str */
M49_crt_str:
/* QL:         addq.l  #2,d1           entry must be length of string + 2 */
    addq.l #2,d1
/* QL:         bsr.s   bp_alvv         allocation will round up any odd byte */
    bsr.s bp_alvv
/* QL: M49_fill_str */
M49_fill_str:
/* QL:         bsr.s   M49_cht_get         check out variable type and get a0,a1 */
    bsr.s M49_cht_get
/* QL:         moveq   #0,d2           nothing to blankfill on a0 */
    moveq #0,d2
/* QL:         move.w  0(a6,a1.l),d1   get source length again */
    move.w 0(a6,a1.l),d1
/* QL: M49_put_len */
M49_put_len:
/* QL:         move.w  d1,0(a6,a0.l)   set destination length */
    move.w d1,0(a6,a0.l)
/* QL: M49_str_len */
M49_str_len:
/* QL:         addq.l  #2,a0           pos to start replacing at */
    addq.l #2,a0
/* QL: M49_str_ret */
M49_str_ret:
/* QL:         move.w  0(a6,a1.l),d0   get length (we know msw is zero) */
    move.w 0(a6,a1.l),d0
/* QL:         addq.l  #2,a1           move a1 past length word */
    addq.l #2,a1
/* QL:         add.l   a1,d0           set to end of text */
    add.l a1,d0
/* QL:         bra.s   M49_s_copy          do the copy */
    bra.s M49_s_copy
/* QL: * Check copy length fits into space */
/* QL: * d1 -i o- new chars available / number to copy from RI stack to VV area */
/* QL: * d2 -i o- space available / amount of VV area to blankfill after copy */
/* QL: M49_set_par */
M49_set_par:
/* QL:         sub.w   d1,d2           will new chars fit into old space? */
    sub.w d1,d2
/* QL:         bhi.s   M49_rts1            yes - fine */
    bhi.s M49_rts1
/* QL:         add.w   d2,d1           set amount to copy */
    add.w d2,d1
/* QL:         moveq   #0,d2           and blank fill nothing */
    moveq #0,d2
/* QL: M49_rts1 */
M49_rts1:
/* QL:         rts */
    rts 
/* QL: M49_str_var */
M49_str_var:
/* QL:         addq.b  #M49_t.fp,d0        string or sub-string */
    addq.b #M49_t.fp,d0
/* QL:         beq.s   M49_let_sst         ..substring (only allowed direct from let) */
    beq.s M49_let_sst
/* QL:         move.l  4(a6,a3.l),d4   current offset on VV */
    move.l 4(a6,a3.l),d4
/* QL:         blt.s   M49_crt_str         ..isn't one, have to make one */
    blt.s M49_crt_str
/* QL:         move.l  M49_bv_vvbas(a6),a0 */
    move.l M49_bv_vvbas(a6),a0
/* QL:         add.l   d4,a0 */
    add.l d4,a0
/* QL: * This is it! We must not screw up rep/for string variable, which has max len */
/* QL: * of 4 chars. If assigning to such, truncate anything longer than four chars. */
/* QL: * An alternative would be to scrap their rep/for status... */
/* QL: * While we're doing this, we can get the spinoff of quick assigns to others. */
/* QL:         assert  0,M49_t.var-2,M49_t.arr-3,M49_t.rep-6,M49_t.for-7 */
/* original assertion: 0,M49_t.var-2,M49_t.arr-3,M49_t.rep-6,M49_t.for-7 */
/* QL:         moveq   #4,d0 */
    moveq #4,d0
/* QL:         cmp.b   0(a6,a3.l),d0   is this string a rep/for index? */
    cmp.b 0(a6,a3.l),d0
/* QL:         bgt.s   M49_str_norm        no - go do normal strings */
    bgt.s M49_str_norm
/* QL:         cmp.w   d1,d0           what's the source string length then? */
    cmp.w d1,d0
/* QL:         bcs.s   M49_truncit         bother... longer than four */
    bcs.s M49_truncit
/* QL:         move.w  d1,d0           use short strings as they come */
    move.w d1,d0
/* QL: M49_truncit */
M49_truncit:
/* QL:         move.w  d0,0(a6,a0.l)   set variable length */
    move.w d0,0(a6,a0.l)
/* QL:         move.l  2(a6,a1.l),2(a6,a0.l) copy 4 bytes regardless */
    move.l 2(a6,a1.l),2(a6,a0.l)
/* QL:         addq.l  #3,d1 */
    addq.l #3,d1
/* QL:         bclr    #0,d1           round up for the space to release on RI stack */
    bclr #0,d1
/* QL:         rts */
    rts 
/* QL: * Assign a string to a substring of a string variable */
/* QL: M49_let_sst */
M49_let_sst:
/* QL:         addq.b  #M49_t.str,1(a6,a3.l) reset type to string (it was zero before) */
    addq.b #M49_t.str,1(a6,a3.l)
/* QL:         move.w  d5,a0 */
    move.w d5,a0
/* QL:         subq.l  #1,a0           offset to first char to replace */
    subq.l #1,a0
/* QL:         move.w  d6,d2 */
    move.w d6,d2
/* QL:         sub.w   a0,d2           destination space available */
    sub.w a0,d2
/* QL:         add.l   a2,a0 */
    add.l a2,a0
/* QL:         bsr.s   M49_set_par         gives d1,d2 */
    bsr.s M49_set_par
/* QL:         bra.s   M49_str_len         go copy after stepping past length */
    bra.s M49_str_len
/* QL: * Copy string characters */
/* QL: * d0 -  i- offset to end of text of RI stack string */
/* QL: * d1 -i o- no of chars to copy from RI stack to VV area / addend for a1 */
/* QL: * d2 -i  - no of chars on VV area to blank fill */
/* QL: * a0 -i o- VV pos to copy to */
/* QL: * a1 -i o- RI pointer to source string, string removed except for d1 */
/* QL: M49_copy_lp */
M49_copy_lp:
/* QL:         move.b  0(a6,a1.l),0(a6,a0.l) copy a character */
    move.b 0(a6,a1.l),0(a6,a0.l)
/* QL:         addq.l  #1,a0           step VV */
    addq.l #1,a0
/* QL:         addq.l  #1,a1           step RI */
    addq.l #1,a1
/* QL: M49_s_copy */
M49_s_copy:
/* QL:         dbra    d1,M49_copy_lp */
    dbra d1,M49_copy_lp
/* QL:         moveq   #' ',d1 */
    moveq #32,d1
/* QL:         bra.s   M49_b_fill */
    bra.s M49_b_fill
/* QL: M49_fill_lp */
M49_fill_lp:
/* QL:         move.b  d1,0(a6,a0.l)   blank one character */
    move.b d1,0(a6,a0.l)
/* QL:         addq.l  #1,a0           step VV */
    addq.l #1,a0
/* QL: M49_b_fill */
M49_b_fill:
/* QL:         dbra    d2,M49_fill_lp */
    dbra d2,M49_fill_lp
/* QL:         move.l  d0,a1           replace with end of text */
    move.l d0,a1
/* QL:         moveq   #1,d1 */
    moveq #1,d1
/* QL:         and.b   d0,d1           chars (0/1) left before end of string */
    and.b d0,d1
/* QL:         rts */
    rts 
/* QL:         end */
