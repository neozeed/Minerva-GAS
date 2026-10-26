/* ROM section bp_beep */
.balign 2,0
/* QL: bp_beep */
bp_beep:
/* QL:         st      -(sp)           set for no reply */
    st -(sp)
/* QL:         subq.l  #1+1+4,sp       no parms on kill, so length word can be garbage */
    subq.l #((1+1)+4),sp
/* QL:         move.w  #M45_kiso_cmd<<8!0,(sp) kill sound, no parameter bytes */
    move.w #((M45_kiso_cmd<<8)|0),(sp)
/* QL:         move.l  a3,d7 */
    move.l a3,d7
/* QL:         sub.l   a5,d7           - 8 * parameter count */
    sub.l a5,d7
/* QL:         beq.s   M45_gotrap          none - kill any beeping */
    beq.s M45_gotrap
/* QL:         moveq   #M45_parmcnt*2,d1 */
    moveq #(M45_parmcnt*2),d1
/* QL:         jsr     bv_chrix(pc)    make sure of adequate space on ri stack */
    jsr bv_chrix(pc)
/* QL:         asr.l   #3,d7           - parameter count */
    asr.l #3,d7
/* QL:         moveq   #M45_err.bp,d0      set d0 for possible error return */
    moveq #M45_err.bp,d0
/* QL:         addq.l  #M45_parmcnt,d7     count of parameters being defaulted */
    addq.l #M45_parmcnt,d7
/* QL:         bcc.s   M45_exit            too many parameters is invalid */
    bcc.s M45_exit
/* QL:         moveq   #%01001111,d2   reject 1, 3 or 4 parameters as invalid */
    moveq #0b01001111,d2
/* QL:         btst    d7,d2 */
    btst d7,d2
/* QL:         beq.s   M45_exit            reject bad parameter count */
    beq.s M45_exit
/* QL:         add.l   d7,d7 */
    add.l d7,d7
/* QL:         sub.l   d7,M45_bv_rip(a6)   register space on stack for defaults */
    sub.l d7,M45_bv_rip(a6)
/* QL:         jsr     ca_gtint(pc)    get non-defaulted parameters */
    jsr ca_gtint(pc)
/* QL:         bne.s   M45_exit */
    bne.s M45_exit
/* QL:         lea     M45_parmcnt*2(a1),a0 end of parameter area */
    lea (M45_parmcnt*2)(a1),a0
/* QL:         add.w   d3,a1 */
    add.w d3,a1
/* QL:         add.w   d3,a1           step over the non-defaulted parameters */
    add.w d3,a1
/* QL:         subq.b  #2,d3           were there just two parameters? */
    subq.b #2,d3
/* QL:         bne.s   M45_chk_def         no - only pitch_2 defaults to pitch */
    bne.s M45_chk_def
/* QL:         move.w  2-M45_parmcnt*2(a6,a0.l),d1 pick up pitch */
    move.w (2-(M45_parmcnt*2))(a6,a0.l),d1
/* QL: M45_def_lp */
M45_def_lp:
/* QL:         move.w  d1,0(a6,a1.l)   set default */
    move.w d1,0(a6,a1.l)
/* QL:         addq.l  #2,a1           step on */
    addq.l #2,a1
/* QL: M45_chk_def */
M45_chk_def:
/* QL:         moveq   #0,d1           rest default to zero */
    moveq #0,d1
/* QL:         cmp.l   a1,a0           any more to default? */
    cmp.l a1,a0
/* QL:         bne.s   M45_def_lp          yes - keep going */
    bne.s M45_def_lp
/* QL:         movem.w -M45_parmcnt*2(a6,a0.l),d3-d6/a1-a4 pick them all up */
    movem.w ((-M45_parmcnt)*2)(a6,a0.l),d3-d6/a1-a4
/* QL:         move.w  d3,d7           slot duration into order */
    move.w d3,d7
/* QL:         addq.b  #1,d4           pitch needs one added */
    addq.b #1,d4
/* QL:         addq.b  #1,d5           pitch_2 needs one added */
    addq.b #1,d5
/* QL:         ror.w   #8,d6           interval word needs bytes reversed */
    ror.w #8,d6
/* QL:         ror.w   #8,d7           duration word needs bytes reversed */
    ror.w #8,d7
/* QL:         exg     a3,a4           random and fuzzy need swapping over */
    exg a4,a3
/* QL:         addq.l  #1+1+4,sp       discard the kill command.b/count.b/length.l */
    addq.l #((1+1)+4),sp
/* QL:         movem.w d4-d7/a1-a4,-(sp) put on the beep init parameters */
    movem.w d4-d7/a1-a4,-(sp)
/* QL:         move.l  #%00010001000100011010101010011001,-(sp) put on the lengths */
    move.l #0b00010001000100011010101010011001,-(sp)
/* QL:                 ;  4 - 4 - 4 - 4 - 8 8 8 8 8 - 8 - */
/* QL:                 ;  fuz rnd wrp gry dur grx pt2 pt1 */
/* QL:         move.w  #M45_inso_cmd<<8+M45_parmcnt*2,-(sp) put on the command/count */
    move.w #((M45_inso_cmd<<8)+(M45_parmcnt*2)),-(sp)
/* QL: M45_gotrap */
M45_gotrap:
/* QL:         lea     bf_ipcom(pc),a2 execute command on stack in supervisor mode */
    lea bf_ipcom(pc),a2
/* QL:         moveq   #M45_mt.extop,d0 */
    moveq #M45_mt.extop,d0
/* QL:         trap    #1              protected against basic moving */
    trap #1
/* QL: M45_exit */
M45_exit:
/* QL:         assert  16,M45_parmcnt*2 */
/* original assertion: 16,M45_parmcnt*2 */
/* QL:         ; Note: parameter count was either zero or sixteen */
/* QL:         moveq   #-32+1+1+4+2,d1 */
    moveq #(((((-32)+1)+1)+4)+2),d1
/* QL:         or.w    (sp),d1         get 16/0 bit to form overall length less 32  */
    or.w (sp),d1
/* QL:         lea     32(sp,d1.w),sp  discard the entire command */
    lea 32(sp,d1.w),sp
/* QL:         rts */
    rts 
/* QL:         end */
