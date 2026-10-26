/* ROM section ca_stind */
.balign 2,0
/* QL: * d0 -  o- error code */
/* QL: * a0 -i o- expression pointer */
/* QL: * a1 -i o- ri stack pointer */
/* QL: * a5 -i o- name table entry top */
/* QL: * d1-d3/d5-d6/a3-a4 destroyed */
/* QL: ca_stind */
ca_stind:
/* QL:         cmp.b   #M95_t.str,-7(a6,a5.l) is it really a string already? */
    cmp.b #(M95_t.str&255),(-7)(a6,a5.l)
/* QL:         beq.s   M95_isstr */
    beq.s M95_isstr
/* QL:         jsr     ca_etos(pc) */
    jsr ca_etos(pc)
/* QL:         bne.s   M95_rts0 */
    bne.s M95_rts0
/* QL:         moveq   #M95_t.str,d0 */
    moveq #M95_t.str,d0
/* QL:         jsr     ca_cnvrt(pc)    ho hum... we'll even convert numbers! */
    jsr ca_cnvrt(pc)
/* QL: *       bne.s   M95_rts0            there's nothing that won't convert to string! */
/* QL: M95_isstr */
M95_isstr:
/* QL:         bsr.s   ca_ssind        get the indices */
    bsr.s ca_ssind
/* QL:         bne.s   M95_rts0            couldn't get indices */
    bne.s M95_rts0
/* QL:         move.l  a1,a4           maybe it's internal already */
    move.l a1,a4
/* QL:         move.b  -8(a6,a5.l),d3 */
    move.b (-8)(a6,a5.l),d3
/* QL:         subq.b  #M95_t.intern,d3 */
    subq.b #M95_t.intern,d3
/* QL:         beq.s   M95_ptrset          yep - all set for internal */
    beq.s M95_ptrset
/* QL:         move.l  -4(a6,a5.l),d2  string variable offset */
    move.l (-4)(a6,a5.l),d2
/* QL:         blt.s   M95_err_xp          ouch - unset variable */
    blt.s M95_err_xp
/* QL:         move.l  M95_bv_vvbas(a6),a4 */
    move.l M95_bv_vvbas(a6),a4
/* QL:         add.l   d2,a4 */
    add.l d2,a4
/* QL: M95_ptrset */
M95_ptrset:
/* QL:         move.w  0(a6,a4.l),d6   get length */
    move.w 0(a6,a4.l),d6
/* QL:         subq.w  #1,d5 */
    subq.w #1,d5
/* QL:         bcs.s   M95_ready           just want the length, i.e. x$(0) */
    bcs.s M95_ready
/* QL:         cmp.w   d1,d6 */
    cmp.w d1,d6
/* QL:         bcc.s   M95_lenset */
    bcc.s M95_lenset
/* QL:         move.w  d6,d1 */
    move.w d6,d1
/* QL: M95_lenset */
M95_lenset:
/* QL:         sub.w   d5,d1           get length of substring */
    sub.w d5,d1
/* QL:         bcs.s   M95_err_or */
    bcs.s M95_err_or
/* QL:         lea     2(a4,d5.w),a4   pointer to start */
    lea 2(a4,d5.w),a4
/* QL: M95_ready */
M95_ready:
/* QL:         moveq   #M95_t.intern,d2 */
    moveq #M95_t.intern,d2
/* QL:         move.b  d2,-8(a6,a5.l)  now definately internal */
    move.b d2,(-8)(a6,a5.l)
/* QL:         tst.b   d3 */
    tst.b d3
/* QL:         bne.s   M95_riset           variable is M95_ready */
    bne.s M95_riset
/* QL:         lea     2(a1,d6.w),a1 */
    lea 2(a1,d6.w),a1
/* QL:         assert  1,M95_t.intern */
/* original assertion: 1,M95_t.intern */
/* QL:         and.b   d6,d2 */
    and.b d6,d2
/* QL:         add.w   d2,a1           round up */
    add.w d2,a1
/* QL:         bsr.s   M95_putrip          update ri pointer to drop old stack copy now */
    bsr.s M95_putrip
/* QL: M95_riset */
M95_riset:
/* QL:         addq.w  #1,d5           were we doing length only */
    addq.w #1,d5
/* QL:         bcc.l   ca_putss        no - go put substring on stack */
    bcc.w ca_putss
/* QL: * N.B. putss never needs any space if the string was already internal, and its */
/* QL: * move is non-destructive, so it'll always work ok. */
/* QL: * Note: we evaluated a zero index and removed it, so ri must have space for int */
/* QL:         addq.b  #M95_t.int-M95_t.str,-7(a6,a5.l) now it becomes an integer! */
    addq.b #(M95_t.int-M95_t.str),(-7)(a6,a5.l)
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  d6,0(a6,a1.l) */
    move.w d6,0(a6,a1.l)
/* QL: M95_putrip */
M95_putrip:
/* QL:         move.l  a1,M95_bv_rip(a6) */
    move.l a1,M95_bv_rip(a6)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M95_rts0 */
M95_rts0:
/* QL:         rts */
    rts 
/* QL: M95_err_or */
M95_err_or:
/* QL:         moveq   #M95_err.or,d0 */
    moveq #M95_err.or,d0
/* QL:         rts */
    rts 
/* QL: M95_err_xp */
M95_err_xp:
/* QL:         moveq   #M95_err.xp,d0 */
    moveq #M95_err.xp,d0
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code */
/* QL: * d1 -  o- as d6, except default is still left as -1 */
/* QL: * d5 -  o- lower index (1..32767 or 0) (msw preserved) */
/* QL: * d6 -  o- upper index found (no check, except d5=0->d6=0) (msw preserved) */
/* QL: * a0 -i o- expression pointer */
/* QL: * a1 -i o- ri pointer */
/* QL: * d2-d3/a3-a4 destroyed */
/* QL: * Enhanced to accept "a$='x':a$=a$(2to 1)", i.e. null slice at end. */
/* QL: * Also now sensibly accepts a$(to ...) as defaulting to a$(1to ...). */
/* QL: * For the moment, we only baulk at a$(32768to{ 32767})! */
/* QL: ca_ssind */
ca_ssind:
/* QL:         subq.l  #2,a0           we like to start early... */
    subq.l #2,a0
/* QL:         jsr     ca_range(pc)    go get subscript range */
    jsr ca_range(pc)
/* QL:         bne.s   M95_rts0 */
    bne.s M95_rts0
/* QL:         move.w  d1,d6 */
    move.w d1,d6
/* QL:         bpl.s   M95_topok */
    bpl.s M95_topok
/* QL:         lsr.w   #1,d6           change defaulted end (-1) to max (32767) */
    lsr.w #1,d6
/* QL: M95_topok */
M95_topok:
/* QL:         cmp.w   d5,d6 */
    cmp.w d5,d6
/* QL:         beq.s   M95_rangeok         allows through special cases of (0) or (0to 0) */
    beq.s M95_rangeok
/* QL:         tst.w   d5 */
    tst.w d5
/* QL:         beq.s   M95_err_or          if zero gets here, it's no good, mixed len/char */
    beq.s M95_err_or
/* QL:         bgt.s   M95_rangeok         start > 0 is good */
    bgt.s M95_rangeok
/* QL:         addq.w  #2,d5           if defalted start (-1), change it to 1 */
    addq.w #2,d5
/* QL: M95_rangeok */
M95_rangeok:
/* QL:         cmp.w   #M95_w.cpar,0(a6,a0.l) we rather hope this is a close parenthesis */
    cmp.w #M95_w.cpar,0(a6,a0.l)
/* QL:         bne.s   M95_err_xp */
    bne.s M95_err_xp
/* QL:         addq.l  #2,a0           we can move over close bracket now */
    addq.l #2,a0
/* QL:         rts */
    rts 
/* QL:         end */
