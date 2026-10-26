/* ROM section ca_cnvrt */
.balign 2,0
/* QL: * Converts whatever is on top of name table to the requested type. */
/* QL: * The name table is assumed to be describing the value currently on the top */
/* QL: * of the a1 stack. */
/* QL: * Even there is an error, the type conversion will have been done, though the */
/* QL: * result on the RI stack may not be particularly useful. */
/* QL: * The basic buffer is no longer used (lwr). */
/* QL: * d0 -i o- type required / error code */
/* QL: * a1 -i o- stack pointer */
/* QL: * a5 -ip - top of NT stack */
/* QL: * ccr-  o- result of tst.l d0 */
/* QL: reglist reg     d1/d3/d7/a0 */
/* QL: ca_cnvrt */
ca_cnvrt:
/* QL:         move.l  d2,-(sp)        save only one reg, in hope of no conversion */
    move.l d2,-(sp)
/* QL:         moveq   #15,d2          minus the mask, if any */
    moveq #15,d2
/* QL:         and.l   d2,d0           make sure only lsb's set (see gtarg) */
    and.l d2,d0
/* QL:         and.b   -7(a6,a5.l),d2  get the current type of operand */
    and.b (-7)(a6,a5.l),d2
/* QL:         bne.s   M87_oldok           maybe this always happens? */
    bne.s M87_oldok
/* QL:         moveq   #M87_t.str,d2       don't be fooled by old type = substring */
    moveq #M87_t.str,d2
/* QL: M87_oldok */
M87_oldok:
/* QL:         move.b  d0,-7(a6,a5.l)  set new type immediately */
    move.b d0,(-7)(a6,a5.l)
/* QL:         sub.b   d2,d0           subtract old from new (d0.l=0) */
    sub.b d2,d0
/* QL:         beq.s   M87_cnv_ex          they match, so nothing further to do */
    beq.s M87_cnv_ex
/* QL:         movem.l reglist,-(sp) */
    movem.l d1/d3/d7/a0,-(sp)
/* QL:         subq.b  #M87_t.fp,d2        test old type */
    subq.b #M87_t.fp,d2
/* QL:         bmi.s   M87_stox            go do string to something */
    bmi.s M87_stox
/* QL:         beq.s   M87_ftox            go do floating point to something */
    beq.s M87_ftox
/* QL: * Required conversion in d0.b is now -2:str -1:fp or 1:log */
/* QL: *itox */
/* QL:         lsr.b   #1,d0           integer to something, find out what */
    lsr.b #1,d0
/* QL:         beq.s   M87_itol            int to log (d0.l=0) */
    beq.s M87_itol
/* QL:         bcc.s   M87_itos            int to string */
    bcc.s M87_itos
/* QL: *itof */
/* QL:        ;moveq   #6-2,d1         need 4 bytes extra */
/* QL:         bsr.s   M87_chkri */
    bsr.s M87_chkri
/* QL:         jsr     ri_float(pc)    int to fp -- can't fail */
    jsr ri_float(pc)
/* QL:         bra.s   M87_cnv_end */
    bra.s M87_cnv_end
/* QL: M87_itol */
M87_itol:
/* QL:         move.w  0(a6,a1.l),d1   int to log, just make non-zero into 1 */
    move.w 0(a6,a1.l),d1
/* QL: M87_set_log */
M87_set_log:
/* QL:         beq.s   M87_log_end */
    beq.s M87_log_end
/* QL:         moveq   #1,d1           non-zero becomes one */
    moveq #1,d1
/* QL: M87_log_end */
M87_log_end:
/* QL:         subq.b  #M87_t.log-M87_t.int,-7(a6,a5.l) change new type from M87_t.log to M87_t.int */
    subq.b #(M87_t.log-M87_t.int),(-7)(a6,a5.l)
/* QL: M87_put_wrd */
M87_put_wrd:
/* QL:         move.w  d1,0(a6,a1.l)   store string length, etc */
    move.w d1,0(a6,a1.l)
/* QL: M87_cnv_end */
M87_cnv_end:
/* QL:         move.l  a1,M87_bv_rip(a6)   always has been converted to something */
    move.l a1,M87_bv_rip(a6)
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1/d3/d7/a0
/* QL: M87_cnv_ex */
M87_cnv_ex:
/* QL:         move.l  (sp)+,d2 */
    move.l (sp)+,d2
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: * Required conversion in d0.b is now -1:str 1:int or 2:log  */
/* QL: M87_ftox */
M87_ftox:
/* QL:         asr.b   #2,d0           what are we converting fp to? */
    asr.b #2,d0
/* QL:         bmi.s   M87_ftos            string */
    bmi.s M87_ftos
/* QL:         bcs.s   M87_ftol            logical (d0.l=0) */
    bcs.s M87_ftol
/* QL: *ftoi */
/* QL:        ;moveq   #6,d1           nint needs to add .5 (fp) */
/* QL:         bsr.s   M87_chkri */
    bsr.s M87_chkri
/* QL:         jsr     ri_nint(pc)     integer, do it */
    jsr ri_nint(pc)
/* QL:         bra.s   M87_cnv_end */
    bra.s M87_cnv_end
/* QL: M87_stof */
M87_stof:
/* QL:         jsr     cn_dtof(pc)     convert it to fp */
    jsr cn_dtof(pc)
/* QL:         move.l  2(a6,a1.l),d2   pick up result mantissa, hopefully */
    move.l 2(a6,a1.l),d2
/* QL:         subq.l  #6-2,d7         extra space for fp result */
.word 20871|((((6-2))&7)<<9)
/* QL:         bsr.s   M87_adjri           set ri stack pointer */
    bsr.s M87_adjri
/* QL:         move.l  d2,2(a6,a1.l)   store fp result mantissa */
    move.l d2,2(a6,a1.l)
/* QL:         cmp.b   #M87_t.log,-7(a6,a5.l) were we actually after a logical? */
    cmp.b #(M87_t.log&255),(-7)(a6,a5.l)
/* QL:         bne.s   M87_put_wrd         no - that's it then */
    bne.s M87_put_wrd
/* QL: M87_ftol */
M87_ftol:
/* QL:         move.l  2(a6,a1.l),d1   get and test mantissa */
    move.l 2(a6,a1.l),d1
/* QL:         addq.l  #6-2,a1         discard float, keep int */
.word 20617|((((6-2))&7)<<9)
/* QL:         bra.s   M87_set_log */
    bra.s M87_set_log
/* QL: M87_chkri */
M87_chkri:
/* QL:         moveq   #4*6-2,d1       this is the worst case space needed */
    moveq #((4*6)-2),d1
/* QL:         jsr     bv_chrix(pc)    check ri stack */
    jsr bv_chrix(pc)
/* QL:         move.l  M87_bv_rip(a6),a1   reload pointer */
    move.l M87_bv_rip(a6),a1
/* QL:         rts */
    rts 
/* QL: * Required conversion in d0.b is now 1:fp 2:int or 3:log  */
/* QL: M87_stox */
M87_stox:
/* QL:        ;moveq   #4*6-2,d1       we may need 4 fp's less the string length */
/* QL:         bsr.s   M87_chkri */
    bsr.s M87_chkri
/* QL:         addq.l  #2,a1           discard string length */
    addq.l #2,a1
/* QL:         move.l  a1,a0           pointer to start of string */
    move.l a1,a0
/* QL:         moveq   #0,d7 */
    moveq #0,d7
/* QL:         move.w  -2(a6,a1.l),d7  get length */
    move.w (-2)(a6,a1.l),d7
/* QL:         add.l   a1,d7           pointer to end of string */
    add.l a1,d7
/* QL:         cmp.b   #M87_t.int,-7(a6,a5.l) are we after a straight integer? */
    cmp.b #(M87_t.int&255),(-7)(a6,a5.l)
/* QL:         bne.s   M87_stof            float (or logical) */
    bne.s M87_stof
/* QL: *stoi */
/* QL:         jsr     cn_dtoi(pc)     convert integer */
    jsr cn_dtoi(pc)
/* QL:         bsr.s   M87_adjri           set ri stack pointer and copy integer */
    bsr.s M87_adjri
/* QL: M87_put_wd1 */
M87_put_wd1:
/* QL:         bra.s   M87_put_wrd */
    bra.s M87_put_wrd
/* QL: M87_itos */
M87_itos:
/* QL:        ;moveq   #2+6-2,d1       extra space needed */
/* QL:         bsr.s   M87_chkri */
    bsr.s M87_chkri
/* QL:         lea     -(2+6-2)(a1),a0 where string will go */
    lea (-((2+6)-2))(a1),a0
/* QL:         jsr     cn_itod(pc)     do conversion -- can't fail */
    jsr cn_itod(pc)
/* QL: M87_stkst */
M87_stkst:
/* QL:         move.w  d1,d2           copy length */
    move.w d1,d2
/* QL:         lsr.w   #1,d2           odd length? */
    lsr.w #1,d2
/* QL:         bcc.s   M87_stent           no - that's ok */
    bcc.s M87_stent
/* QL:         addq.l  #1,a0           yes - allow for final pad byte */
    addq.l #1,a0
/* QL: M87_stmov */
M87_stmov:
/* QL:         subq.l  #2,a0 */
    subq.l #2,a0
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  0(a6,a0.l),0(a6,a1.l) shuffle string chars up stack */
    move.w 0(a6,a0.l),0(a6,a1.l)
/* QL: M87_stent */
M87_stent:
/* QL:         dbra    d2,M87_stmov */
    dbra d2,M87_stmov
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         bra.s   M87_put_wd1 */
    bra.s M87_put_wd1
/* QL: M87_ftos */
M87_ftos:
/* QL:        ;moveq   #2+14-6,d1      extra needed */
/* QL:         bsr.s   M87_chkri */
    bsr.s M87_chkri
/* QL:         lea     -(2+14-6)(a1),a0 where string will go */
    lea (-((2+14)-6))(a1),a0
/* QL:         jsr     cn_ftod(pc)     do the conversion -- can't fail */
    jsr cn_ftod(pc)
/* QL:         bra.s   M87_stkst           put string on stack */
    bra.s M87_stkst
/* QL: M87_adjri */
M87_adjri:
/* QL:         move.w  0(a6,a1.l),d1   pick up result int or exponent (hopefully) */
    move.w 0(a6,a1.l),d1
/* QL:         move.l  d7,a1           put end of string into ri pointer */
    move.l d7,a1
/* QL:         or.w    #-2,d7          get odd=-1/even=-2 */
    or.w #(-2),d7
/* QL:         add.w   d7,a1           adjust ri pointer even with space for integer */
    add.w d7,a1
/* QL:         rts */
    rts 
/* QL:         vect4000 ca_cnvrt */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ ca$cnvrt,(ca_cnvrt-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
