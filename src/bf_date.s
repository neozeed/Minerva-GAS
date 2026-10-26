/* ROM section bf_date */
.balign 2,0
/* QL: bf_date         ; -M142_mt.aclck */
bf_date:
/* QL:         moveq   #-2-M142_mt.aclck,d7 */
    moveq #((-2)-M142_mt.aclck),d7
/* QL: bf_days         ; $83 */
bf_days:
/* QL:         addq.b  #2,d7 */
    addq.b #2,d7
/* QL: bf_dates        ; $81 */
bf_dates:
/* QL:         tas     d7 */
    tas d7
/* QL: bp_adate        ; $01 */
bp_adate:
/* QL:         addq.b  #M142_mt.aclck-M142_mt.sclck,d7 */
.word 20487|((((M142_mt.aclck-M142_mt.sclck))&7)<<9)
/* QL: bp_sdate        ; $00 */
bp_sdate:
/* QL:         bsr.s   M142_bf_datex */
    bsr.s M142_bf_datex
/* QL:         bne.s   M142_rts0 */
    bne.s M142_rts0
/* QL:         moveq   #M142_mt.sclck,d0 */
    moveq #M142_mt.sclck,d0
/* QL:         add.b   d7,d0 */
    add.b d7,d0
/* QL:         beq.s   bf_fllin        bf_date */
    beq.s bf_fllin
/* QL:         bpl.s   M142_trap1           (bug in GC: bits 15..7 not ignored) */
    bpl.s M142_trap1
/* QL:         move.w  d7,a2 */
    move.w d7,a2
/* QL:         move.w  $EC-$81(a2),a2  fetch cn_day/cb_date from vector table */
    move.w (0xec-0x81)(a2),a2
/* QL:         moveq   #M142_t.str,d4       set return type */
    moveq #M142_t.str,d4
/* QL:         jsr     (a2)            do conversion required */
    jsr (a2)
/* QL: M142_putrip */
M142_putrip:
/* QL:         move.l  a1,M142_bv_rip(a6)   set stack pointer */
    move.l a1,M142_bv_rip(a6)
/* QL:         rts */
    rts 
/* QL: * Number of days preceeding each month in a non-leap year, less one. */
/* QL: M142_monoff  dc.w    -1,30,58,89,119,150,180,211,242,272,303,333 */
.balign 2,0
M142_monoff:
M142_dc_anchor_425:
.word ((-1))&65535
.word 30
.word 58
.word 89
.word 119
.word 150
.word 180
.word 211
.word 242
.word 272
.word 303
.word 333
/* QL: * Make this available for date function. */
/* QL: * It permits zero to four or six parameters and removes them from the ri stack. */
/* QL: * No parameters will read the clock. If parameters are given, they are seconds, */
/* QL: * minutes/second, hours/minutes/seconds, days/hours/minutes/seconds or */
/* QL: * a complete date specification of year/month/day/hours/minute/second. */
/* QL: * d1.l is the resultant seconds since the year dot. */
/* QL: * d0.l is a normal error code, or zero for success. */
/* QL: * d2-d4/d6/a0/a2 are all smashed. */
/* QL: * a1.l will be back to the original M142_bv_rip value. */
/* QL: * A reasonable amount of spare space will have been allocated on the ri stack. */
/* QL: M142_bf_datex */
M142_bf_datex:
/* QL:         jsr     bv_chri(pc)     make sure of a reasonable amount of space */
    jsr bv_chri(pc)
/* QL:         jsr     ca_gtlin(pc)    get parameters as long integers */
    jsr ca_gtlin(pc)
/* QL:         bne.s   M142_rts0            propagate any error */
    bne.s M142_rts0
/* QL:         moveq   #M142_mt.rclck,d0 */
    moveq #M142_mt.rclck,d0
/* QL:         asl.w   #2,d3 */
    asl.w #2,d3
/* QL:         bne.s   M142_parms */
    bne.s M142_parms
/* QL: M142_trap1 */
M142_trap1:
/* QL:         trap    #1 */
    trap #1
/* QL: M142_ok */
M142_ok:
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL: M142_tstrts */
M142_tstrts:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: M142_rts0 */
M142_rts0:
/* QL:         rts */
    rts 
/* QL: M142_parms */
M142_parms:
/* QL:         move.l  a1,d2 */
    move.l a1,d2
/* QL:         add.w   d3,a1 */
    add.w d3,a1
/* QL:         bsr.s   M142_putrip          reset the stack */
    bsr.s M142_putrip
/* QL:         move.l  0(a6,d2.l),d1   pick up first parameter */
    move.l 0(a6,d2.l),d1
/* QL:         subq.w  #2<<2,d3 */
    subq.w #(2<<2),d3
/* QL:         bcs.s   M142_ok              one parameter: just seconds */
    bcs.s M142_ok
/* QL:         beq.s   M142_mul60add        two parameters: minutes/seconds */
    beq.s M142_mul60add
/* QL:         subq.w  #2<<2,d3 */
    subq.w #(2<<2),d3
/* QL:         bcs.s   M142_hms             three params: hours/minutes/seconds */
    bcs.s M142_hms
/* QL:         beq.s   M142_dhms            four params: days/hours/minutes/seconds */
    beq.s M142_dhms
/* QL:         moveq   #M142_err.bp,d0 */
    moveq #M142_err.bp,d0
/* QL:         subq.w  #2<<2,d3 */
    subq.w #(2<<2),d3
/* QL:         bne.s   M142_tstrts          if not 6 params then error */
    bne.s M142_tstrts
/* QL: * Make this bit available to bootup i2c date copy */
/* QL: * d0 -  o- zero */
/* QL: * d1 -i o- input year, output seconds since M142_dot */
/* QL: * d2 -  o- zero */
/* QL: * a1 -ip - pointer rel a6 to end of 20 bytes, 5 longs: mm,dd,hh,mm,ss */
/* QL: * a6 -ip - base for a1 */
/* QL: * d3/d4 and d6.lsb destroyed */
/* QL: bf_datez */
bf_datez:
/* QL:         moveq   #-16,d2 */
    moveq #(-16),d2
/* QL:         add.l   a1,d2           offset on stack to days */
    add.l a1,d2
/* QL:         move.b  d1,d6 */
    move.b d1,d6
/* QL:         sub.w   #M142_dot,d1         (year-M142_dot) */
    sub.w #M142_dot,d1
/* QL:         move.w  d1,d4 */
    move.w d1,d4
/* QL:         move.w  #365,d0 */
    move.w #365,d0
/* QL:         bsr.s   M142_muladd          ... * 365 + days ... */
    bsr.s M142_muladd
/* QL:         lsr.w   #2,d4 */
    lsr.w #2,d4
/* QL:         add.w   d4,d1           ... + (year-M142_dot) div 4 ... */
    add.w d4,d1
/* QL:         move.w  -18(a6,a1.l),d0 get month */
    move.w (-18)(a6,a1.l),d0
/* QL:         add.w   d0,d0 */
    add.w d0,d0
/* QL:         add.w   M142_monoff-2(pc,d0.w),d1 ... + offset(month-1) ... */
    add.w (M142_monoff-2)(pc,d0.w),d1
/* QL:         lsl.b   #8-2,d6         if it's a leap year */
    lsl.b #(8-2),d6
/* QL:         bne.s   M142_dhms */
    bne.s M142_dhms
/* QL:         subq.w  #3<<1,d0        and it's gone february */
    subq.w #(3<<1),d0
/* QL:         bcs.s   M142_dhms */
    bcs.s M142_dhms
/* QL:         addq.l  #1,d1           then ... + 1 ... (feb 29 not in offset table) */
    addq.l #1,d1
/* QL: M142_dhms */
M142_dhms:
/* QL:         moveq   #24,d0 */
    moveq #24,d0
/* QL:         bsr.s   M142_muladd          ... * 24 + hrs ... */
    bsr.s M142_muladd
/* QL: M142_hms */
M142_hms:
/* QL:         jsr     M142_mul60add        ... * 60 + mins ... */
    jsr M142_mul60add
/* QL: M142_ms */
M142_ms:
/* QL: *       bsr.s   M142_mul60add        ... * 60 + secs */
/* QL: *       bra.s   M142_ok */
/* QL: * Multiply and add subroutine */
/* QL: * Entry: */
/* QL: *       d0.w = w, 16 bit multiplier */
/* QL: *       d1.l = l, 32 bit multiplicand */
/* QL: *       d2.l = offset on ri stack to "p", the 32 bit addend */
/* QL: * Exit: */
/* QL: *       d0.l = 0 */
/* QL: *       d1.l = l*w+p */
/* QL: *       d2.l 4 added */
/* QL: *       d3.l smashed */
/* QL: M142_mul60add */
M142_mul60add:
/* QL:         moveq   #60,d0 */
    moveq #60,d0
/* QL: M142_muladd */
M142_muladd:
/* QL:         move.l  d1,d3 */
    move.l d1,d3
/* QL:         swap    d3 */
    swap d3
/* QL:         mulu    d0,d3 */
    mulu d0,d3
/* QL:         swap    d3              d3(msw) = l(msw) * w */
    swap d3
/* QL:         clr.w   d3              d3(lsw) = 0 */
    clr.w d3
/* QL:         mulu    d0,d1           d1 = l(lsw) * w */
    mulu d0,d1
/* QL:         add.l   d3,d1           d1 = l * w */
    add.l d3,d1
/* QL:         add.l   0(a6,d2.l),d1   add p */
    add.l 0(a6,d2.l),d1
/* QL:         addq.l  #4,d2           move on pointer */
    addq.l #4,d2
/* QL:         bra.s   M142_ok */
    bra.s M142_ok
/* QL:         end */
