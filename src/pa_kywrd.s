/* ROM section pa_kywrd */
.balign 2,0
/* QL: * d6 -ip - keyword number */
/* QL: * a0 -i o- pointer to buffer */
/* QL: * a2 -ip - pointer to kytab */
/* QL: * a6 -ip - pointer to basic area */
/* QL: * d0-d3/a1 destroyed */
/* QL: * The keyword specified is checked, including verifying that it, or it plus */
/* QL: * some valid "follow on" keyword, ends at a non-alphanumeric. */
/* QL: * A direct return will indicate that the keyword did not match. a0 is garbage. */
/* QL: * A return + 2 will have moved a0 to the end of the matched keyword. */
/* QL: pa_kywrd */
pa_kywrd:
/* QL:         moveq   #0,d0           haven't set saved buffer position yet */
    moveq #0,d0
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         move.b  0(a2,d6.w),d3   get offset in keytable */
    move.b 0(a2,d6.w),d3
/* QL:         lea     0(a2,d3.w),a1   point at pre-byte of keyword */
    lea 0(a2,d3.w),a1
/* QL:         move.b  (a1)+,d3        and read it */
    move.b (a1)+,d3
/* QL:         ror.l   #4,d3           length in lsw, follow on count in msb's */
    ror.l #4,d3
/* QL: M132_inner */
M132_inner:
/* QL:         subq.w  #1,d3           subtract one from length */
    subq.w #1,d3
/* QL:         bcs.s   M132_keyend          end of keyword */
    bcs.s M132_keyend
/* QL:         move.b  (a1)+,d1        get next keychar */
    move.b (a1)+,d1
/* QL:         addq.l  #1,a0           step on buffer */
    addq.l #1,a0
/* QL: M132_inent */
M132_inent:
/* QL:         move.b  -1(a6,a0.l),d2  get next buffer character */
    move.b (-1)(a6,a0.l),d2
/* QL:         eor.b   d1,d2 */
    eor.b d1,d2
/* QL:         and.b   #-1-32,d2       ignore case */
    and.b #(((-1)-32)&255),d2
/* QL:         beq.s   M132_inner           match, repeat */
    beq.s M132_inner
/* QL:         lsl.b   #2,d1           nomatch, can we M132_skip this char? */
    lsl.b #2,d1
/* QL:         bmi.s   M132_skip            yes - start skipping (n.b. z not set) */
    bmi.s M132_skip
/* QL: * Failed match on an uppercase letter in the keyword */
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         beq.s   M132_rts0            error on d6 keyword, just return */
    beq.s M132_rts0
/* QL: M132_prebyte */
M132_prebyte:
/* QL:         clr.w   d3              clear char counter */
    clr.w d3
/* QL:         rol.l   #4,d3           bring in follow on count */
    rol.l #4,d3
/* QL:         subq.b  #1,d3           check follow on count */
    subq.b #1,d3
/* QL:         bcs.s   M132_rts0            matched d6+alphanum, but no valid follow on */
    bcs.s M132_rts0
/* QL:         move.l  d0,a0           move buffer pointer back to mark */
    move.l d0,a0
/* QL:         move.w  d3,d2           start to form next follow on pointer */
    move.w d3,d2
/* QL:         add.w   d6,d2           now have the offset */
    add.w d6,d2
/* QL:         ror.l   #4,d3           tuck away follow on count */
    ror.l #4,d3
/* QL:         move.b  1(a2,d2.w),d3   get the offset byte */
    move.b 1(a2,d2.w),d3
/* QL:         lea     0(a2,d3.w),a1   absolute pointer to next follow on M132_prebyte */
    lea 0(a2,d3.w),a1
/* QL:         move.b  (a1)+,d3        read next M132_prebyte */
    move.b (a1)+,d3
/* QL:         lsr.b   #4,d3           just keep the length */
    lsr.b #4,d3
/* QL:         bra.s   M132_inner */
    bra.s M132_inner
/* QL: M132_sklp */
M132_sklp:
/* QL:         move.b  (a1)+,d1        get next keychar */
    move.b (a1)+,d1
/* QL:         btst    #5,d1           check for lower case */
    btst #5,d1
/* QL: M132_skip */
M132_skip:
/* QL:         dbeq    d3,M132_sklp         n.b. when we come in here, z is clear */
    dbeq d3,M132_sklp
/* QL:         beq.s   M132_inent           reenter main loop if lowercase again */
    beq.s M132_inent
/* QL:         subq.l  #1,a0           end of the keyword, put back buffer */
    subq.l #1,a0
/* QL: M132_keyend */
M132_keyend:
/* QL:         jsr     pa_alfnm(pc)    check next buffer char */
    jsr pa_alfnm(pc)
/* QL:         bhi.s   M132_endhere         following not alphanumeric: must be keyword */
    bhi.s M132_endhere
/* QL:         tst.l   d0              was that the d6 keyword matched? */
    tst.l d0
/* QL:         bne.s   M132_rts0            no - d6 + follow + a/n = no match  */
    bne.s M132_rts0
/* QL:         move.l  a0,d0           may be a follow on, mark buffer position */
    move.l a0,d0
/* QL:         bra.s   M132_prebyte */
    bra.s M132_prebyte
/* QL: M132_endhere */
M132_endhere:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         beq.s   M132_goodexit        that was the end of the d6 keyword, so ok. */
    beq.s M132_goodexit
/* QL:         move.l  d0,a0           put the buffer pointer back where we want it */
    move.l d0,a0
/* QL: M132_goodexit */
M132_goodexit:
/* QL:         addq.l  #2,(sp) */
    addq.l #2,(sp)
/* QL: M132_rts0 */
M132_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
