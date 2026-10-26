/* ROM section io_serio */
.balign 2,0
/* QL: tabent  macro   t */
/* QL: M17_off */
M17_off:
/* QL:         tabent  M17_io_pend */
/* QL:         dc.b    (([t])-M17_io_pend)&$7fffffff */
M17_dc_anchor_210:
.byte (((M17_io_pend-M17_io_pend)&0x7fffffff))&255
/* QL:         tabent  M17_io_fbyte */
/* QL:         dc.b    (([t])-M17_io_pend)&$7fffffff */
M17_dc_anchor_214:
.byte (((M17_io_fbyte-M17_io_pend)&0x7fffffff))&255
/* QL:         tabent  M17_io_fline */
/* QL:         dc.b    (([t])-M17_io_pend)&$7fffffff */
M17_dc_anchor_218:
.byte (((M17_io_fline-M17_io_pend)&0x7fffffff))&255
/* QL:         tabent  M17_io_fstrg */
/* QL:         dc.b    (([t])-M17_io_pend)&$7fffffff */
M17_dc_anchor_222:
.byte (((M17_io_fstrg-M17_io_pend)&0x7fffffff))&255
/* QL:         tabent  M17_err_bp ; M17_io.edlin */
/* QL:         dc.b    (([t])-M17_io_pend)&$7fffffff */
M17_dc_anchor_226:
.byte (((M17_err_bp-M17_io_pend)&0x7fffffff))&255
/* QL:         tabent  M17_io_sbyte */
/* QL:         dc.b    (([t])-M17_io_pend)&$7fffffff */
M17_dc_anchor_230:
.byte (((M17_io_sbyte-M17_io_pend)&0x7fffffff))&255
/* QL:         tabent  M17_err_bp */
/* QL:         dc.b    (([t])-M17_io_pend)&$7fffffff */
M17_dc_anchor_234:
.byte (((M17_err_bp-M17_io_pend)&0x7fffffff))&255
/* QL:         tabent  M17_io_sstrg */
/* QL:         dc.b    (([t])-M17_io_pend)&$7fffffff */
M17_dc_anchor_238:
.byte (((M17_io_sstrg-M17_io_pend)&0x7fffffff))&255
/* QL:         tabent  M17_fs_heads */
/* QL:         dc.b    (([t])-M17_io_pend)&$7fffffff */
M17_dc_anchor_242:
.byte (((M17_fs_heads-M17_io_pend)&0x7fffffff))&255
/* QL:         tabent  M17_fs_headr */
/* QL:         dc.b    (([t])-M17_io_pend)&$7fffffff */
M17_dc_anchor_246:
.byte (((M17_fs_headr-M17_io_pend)&0x7fffffff))&255
/* QL:         tabent  M17_io_fstrg */
/* QL:         dc.b    (([t])-M17_io_pend)&$7fffffff */
M17_dc_anchor_250:
.byte (((M17_io_fstrg-M17_io_pend)&0x7fffffff))&255
/* QL:         tabent  M17_io_sstrg */
/* QL:         dc.b    (([t])-M17_io_pend)&$7fffffff */
M17_dc_anchor_254:
.byte (((M17_io_sstrg-M17_io_pend)&0x7fffffff))&255
/* QL: io_serio */
io_serio:
/* QL:         addq.l  #1,(sp)         set flag for old serio call */
    addq.l #1,(sp)
/* QL: io_relio */
io_relio:
/* QL:         move.l  (sp),a4         get a copy of return address ready */
    move.l (sp),a4
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL:         move.w  d2,d4           io.xxx calls use word buffer lengths */
    move.w d2,d4
/* QL:         move.l  d1,d5           set copy of d1 */
    move.l d1,d5
/* QL:         subq.w  #M17_io.sstrg+1,d0 */
    subq.w #(M17_io.sstrg+1),d0
/* QL:         bcs.s   M17_action          key in io.xxx range, go do it */
    bcs.s M17_action
/* QL:         move.l  d2,d4           fs.xxx calls use longword buffer lengths */
    move.l d2,d4
/* QL:         sub.w   #M17_fs.save-M17_io.sstrg,d0 */
    sub.w #(M17_fs.save-M17_io.sstrg),d0
/* QL:         addq.w  #M17_fs.save-M17_fs.heads+1,d0 */
.word 20544|(((((M17_fs.save-M17_fs.heads)+1))&7)<<9)
/* QL:         bcs.s   M17_action          key in fs.xxx range, go do it */
    bcs.s M17_action
/* QL:         moveq   #6-M17_io.sstrg-1,d0 force report of bad parameter */
    moveq #((6-M17_io.sstrg)-1),d0
/* QL: M17_action */
M17_action:
/* QL:         addq.w  #M17_io.sstrg+1,d0 */
    addq.w #(M17_io.sstrg+1),d0
/* QL:         move.b  M17_off(pc,d0.w),d0 */
    move.b M17_off(pc,d0.w),d0
/* QL:         jsr     M17_io_pend(pc,d0.w) call code to do the work */
    jsr M17_io_pend(pc,d0.w)
/* QL:         moveq   #3*4-1,d4 */
    moveq #((3*4)-1),d4
/* QL:         add.l   (sp)+,d4        get ready for return */
    add.l (sp)+,d4
/* QL:         btst    #0,d4           check call type */
    btst #0,d4
/* QL:         bne.s   M17_tstret          relio: returns up a level after setting ccr */
    bne.s M17_tstret
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         move.l  d4,a4 */
    move.l d4,a4
/* QL:         jmp     (a4)            serio: return to word past the addresses */
    jmp (a4)
/* QL: M17_io_pend */
M17_io_pend:
/* QL: *       moveq   #0,d0           test routine is the first element */
/* QL:         bsr.s   M17_vectest         set up test routine address */
    bsr.s M17_vectest
/* QL:         bra.s   M17_callit          go do it */
    bra.s M17_callit
/* QL: M17_fs_heads */
M17_fs_heads:
/* QL:         moveq   #15,d4          fixed buffer length of 15 */
    moveq #15,d4
/* QL:         tst.w   d5 */
    tst.w d5
/* QL:         beq.s   M17_heads1          if nothing done yet, go send the $ff prefix */
    beq.s M17_heads1
/* QL: M17_io_sstrg */
M17_io_sstrg:
/* QL:         bsr.s   M17_vecsend         set routine address for sending bytes */
    bsr.s M17_vecsend
/* QL: M17_sslp */
M17_sslp:
/* QL:         cmp.l   d4,d5           check count sent against buffer length */
    cmp.l d4,d5
/* QL:         bcc.s   M17_setd1_ok        if we have finished, get out */
    bcc.s M17_setd1_ok
/* QL:         move.b  (a1),d1         get a byte from the buffer */
    move.b (a1),d1
/* QL:         bsr.s   M17_callit          call the send routine */
    bsr.s M17_callit
/* QL:         bne.s   M17_setd1           on error, return d1/a1 updated by count sent */
    bne.s M17_setd1
/* QL:         addq.l  #1,a1           move past the byte */
    addq.l #1,a1
/* QL: M17_ssadd1 */
M17_ssadd1:
/* QL:         addq.l  #1,d5           count what we've done so far */
    addq.l #1,d5
/* QL:         bra.s   M17_sslp            go see if more to send */
    bra.s M17_sslp
/* QL: M17_heads1 */
M17_heads1:
/* QL:         st      d1              prefix byte for file header is $ff */
    st d1
/* QL:         bsr.s   M17_io_sbyte        send that */
    bsr.s M17_io_sbyte
/* QL:         bne.s   M17_setd1           on error, return with no bytes sent */
    bne.s M17_setd1
/* QL:         bra.s   M17_ssadd1          continue as per send string */
    bra.s M17_ssadd1
/* QL: M17_err_bp */
M17_err_bp:
/* QL:         moveq   #M17_err.bp,d0      report error for bad key or bad header prefix */
    moveq #M17_err.bp,d0
/* QL:         rts */
    rts 
/* QL: M17_vecsend */
M17_vecsend:
/* QL:         moveq   #2*2,d0         send M17_vector is offset by two elements */
    moveq #(2*2),d0
/* QL: M17_vector */
M17_vector:
/* QL:         add.w   d0,a4           address for relio, needs another add for serio */
    add.w d0,a4
/* QL: M17_vectest */
M17_vectest:
/* QL:         exg     a4,d0 */
    exg a4,d0
/* QL:         btst    #0,d0           test lsb of address register */
    btst #0,d0
/* QL:         exg     a4,d0 */
    exg a4,d0
/* QL:         beq.s   M17_vecrel          if zero, go do relative M17_vector */
    beq.s M17_vecrel
/* QL:         move.l  -1(a4,d0.w),a4  pick up serio's absolute M17_vector */
    move.l (-1)(a4,d0.w),a4
/* QL:         rts */
    rts 
/* QL: M17_vecrel */
M17_vecrel:
/* QL:         add.w   (a4),a4         add relio's relative M17_vector to get absolute */
    add.w (a4),a4
/* QL:         rts */
    rts 
/* QL: M17_io_sbyte */
M17_io_sbyte:
/* QL:         bsr.s   M17_vecsend         set up send routine address */
    bsr.s M17_vecsend
/* QL:         bra.s   M17_callit          go do it */
    bra.s M17_callit
/* QL: M17_io_fbyte */
M17_io_fbyte:
/* QL:         bsr.s   M17_vecfetch        set up fetch routine address */
    bsr.s M17_vecfetch
/* QL: M17_callit */
M17_callit:
/* QL:         movem.l d4-d5/a1/a4,-(sp) save our registers */
    movem.l d4-d5/a1/a4,-(sp)
/* QL:         jsr     (a4)            call the test/fetch/send routine */
    jsr (a4)
/* QL:         movem.l (sp)+,d4-d5/a1/a4 restore our registers */
    movem.l (sp)+,d4-d5/a1/a4
/* QL: M17_tstret */
M17_tstret:
/* QL:         tst.l   d0              ensure set ccr before returning */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: M17_vecfetch */
M17_vecfetch:
/* QL:         moveq   #2,d0           fetch routing is offset by one element */
    moveq #2,d0
/* QL:         bra.s   M17_vector          go set up the fetch routine address */
    bra.s M17_vector
/* QL: M17_fs_headr */
M17_fs_headr:
/* QL:         moveq   #15,d4          fix header read buffer size as 15 */
    moveq #15,d4
/* QL:         tst.w   d5 */
    tst.w d5
/* QL:         beq.s   M17_headr1          if nothing yet read, go check the prefix byte */
    beq.s M17_headr1
/* QL: M17_io_fstrg */
M17_io_fstrg:
/* QL:         bsr.s   M17_vecfetch        set up the fetch routine address */
    bsr.s M17_vecfetch
/* QL:         bra.s   M17_fslp            enter the loop */
    bra.s M17_fslp
/* QL: M17_fsnxt */
M17_fsnxt:
/* QL:         bsr.s   M17_callit          call the fetch routine */
    bsr.s M17_callit
/* QL:         bne.s   M17_setd1           on error, return updated d1/a1 */
    bne.s M17_setd1
/* QL:         move.b  d1,(a1)+        store byte read and update buffer pointer */
    move.b d1,(a1)+
/* QL: M17_fsadd1 */
M17_fsadd1:
/* QL:         addq.l  #1,d5           count it */
    addq.l #1,d5
/* QL: M17_fslp */
M17_fslp:
/* QL:         cmp.l   d4,d5           check count against buffer size */
    cmp.l d4,d5
/* QL:         bcs.s   M17_fsnxt           if not yet full, keep fetching */
    bcs.s M17_fsnxt
/* QL: M17_setd1_ok */
M17_setd1_ok:
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL: M17_setd1 */
M17_setd1:
/* QL:         move.l  d5,d1           copy our count, or return byte, to d1 */
    move.l d5,d1
/* QL:         bra.s   M17_tstret          set ccr before returning */
    bra.s M17_tstret
/* QL: M17_headr1 */
M17_headr1:
/* QL:         bsr.s   M17_io_pend         see if there is a byte available yet */
    bsr.s M17_io_pend
/* QL:         bne.s   M17_setd1           if not, or there's a problem, return updated */
    bne.s M17_setd1
/* QL:         not.b   d1              check the value of the waiting byte */
    not.b d1
/* QL:         bne.s   M17_err_bp          error if it isn't $ff */
    bne.s M17_err_bp
/* QL:         move.l  4(sp),a4        restore a4, as we need a new routine now */
    move.l 4(sp),a4
/* QL:         bsr.s   M17_io_fbyte        fetch the $ff byte, and throw it away */
    bsr.s M17_io_fbyte
/* QL:         bra.s   M17_fsadd1          continue as per fetch string for the rest */
    bra.s M17_fsadd1
/* QL: M17_io_fline */
M17_io_fline:
/* QL:         bsr.s   M17_vecfetch        set up the fetch routine address */
    bsr.s M17_vecfetch
/* QL: M17_fllp */
M17_fllp:
/* QL:         moveq   #M17_err.bo,d0      error if the buffer fills up with no line feed */
    moveq #M17_err.bo,d0
/* QL:         cmp.l   d4,d5           check count against buffer length */
    cmp.l d4,d5
/* QL:         bcc.s   M17_setd1           full up and no line feed, return updated d1/a1 */
    bcc.s M17_setd1
/* QL:         bsr.s   M17_callit          call the fetch routine */
    bsr.s M17_callit
/* QL:         bne.s   M17_setd1           on error, return with updated d1/a1 */
    bne.s M17_setd1
/* QL:         move.b  d1,(a1)+        store fetched byte and update pointer */
    move.b d1,(a1)+
/* QL:         addq.l  #1,d5           count it */
    addq.l #1,d5
/* QL:         cmp.b   #10,d1          was it a line feed? */
    cmp.b #(10&255),d1
/* QL:         bne.s   M17_fllp            no, keep fetching bytes */
    bne.s M17_fllp
/* QL:         bra.s   M17_setd1           successful fetch line, go return updated d1/a1 */
    bra.s M17_setd1
/* QL:         end */
