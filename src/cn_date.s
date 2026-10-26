/* ROM section cn_date */
.balign 2,0
/* QL: * d0 -  o- zero, CCR set (no errors possible) */
/* QL: * d1 -ip - date (numeric) */
/* QL: * a1 -i o- pointer to ri stack */
/* QL: M66_dot     equ     1961    (n.b. M66_dot+3 is a leap year) */
.equ M66_dot,1961
/* QL: reg_list reg    d1-d5/a0 */
/* QL: * String writing subroutines */
/* QL: wHHMM */
M66_whhmm:
/* QL:         swap    d2 */
    swap d2
/* QL:         moveq   #':',d1         colon first */
    moveq #58,d1
/* QL:         bsr.s   wX */
    bsr.s M66_wx
/* QL:         move.l  d2,d1 */
    move.l d2,d1
/* QL: M66_w99 */
M66_w99:
/* QL:         pea     M66_wlast */
    pea M66_wlast(pc)
/* QL: M66_wdigit */
M66_wdigit:
/* QL:         ext.l   d1 */
    ext.l d1
/* QL:         divu    #10,d1 */
    divu #10,d1
/* QL:         swap    d1 */
    swap d1
/* QL: M66_wlast */
M66_wlast:
/* QL:         add.b   #'0',d1 */
    add.b #(48&255),d1
/* QL:         bsr.s   wX */
    bsr.s M66_wx
/* QL:         swap    d1 */
    swap d1
/* QL:         rts */
    rts 
/* QL: wS */
M66_ws:
/* QL:         moveq   #' ',d1         write a space */
    moveq #32,d1
/* QL: wX */
M66_wx:
/* QL:         subq.l  #1,a1 */
    subq.l #1,a1
/* QL:         move.b  d1,0(a6,a1.l) */
    move.b d1,0(a6,a1.l)
/* QL:         rts */
    rts 
/* QL: wAAAS */
M66_waaas:
/* QL:         moveq   #M66_mt.inf,d0 */
    moveq #M66_mt.inf,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  M66_sv_mgtab(a0),a0 */
    move.l M66_sv_mgtab(a0),a0
/* QL:         add.w   0(a0,d3.w),a0 */
    add.w 0(a0,d3.w),a0
/* QL:         moveq   #3,d0 */
    moveq #3,d0
/* QL:         mulu    d0,d4 */
    mulu d0,d4
/* QL:         lea     3(a0,d4.w),a0 */
    lea 3(a0,d4.w),a0
/* QL:         moveq   #' ',d1         space after 3 chars */
    moveq #32,d1
/* QL: M66_loop */
M66_loop:
/* QL:         bsr.s   wX */
    bsr.s M66_wx
/* QL:         move.b  -(a0),d1        copy 3 chars into string */
    move.b -(a0),d1
/* QL:         dbra    d0,M66_loop         four chars in all */
    dbra d0,M66_loop
/* QL:         rts */
    rts 
/* QL: cn_date */
cn_date:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d1-d5/a0,-(sp)
/* QL:         bsr.s   M66_calend          reduce to components */
    bsr.s M66_calend
/* QL:         swap    d1 */
    swap d1
/* QL:         bsr.s   M66_w99             write secs into string */
    bsr.s M66_w99
/* QL:         bsr.s   wHHMM           write mins into string with a colon */
    bsr.s M66_whhmm
/* QL:         bsr.s   wHHMM           write hours into string with a colon */
    bsr.s M66_whhmm
/* QL:         bsr.s   wS              write space */
    bsr.s M66_ws
/* QL:         move.w  d3,d1 */
    move.w d3,d1
/* QL:         bsr.s   M66_w99             write day in month */
    bsr.s M66_w99
/* QL:         moveq   #M66_montab*2,d3 */
    moveq #(M66_montab*2),d3
/* QL:         bsr.s   wAAAS           get month into string with a space */
    bsr.s M66_waaas
/* QL:         bsr.s   wS              write space */
    bsr.s M66_ws
/* QL:         move.w  d5,d1 */
    move.w d5,d1
/* QL:         bsr.s   M66_wdigit */
    bsr.s M66_wdigit
/* QL:         bsr.s   M66_wdigit */
    bsr.s M66_wdigit
/* QL:         bsr.s   M66_w99             write the year */
    bsr.s M66_w99
/* QL:         moveq   #20,d1          total chars */
    moveq #20,d1
/* QL: M66_exit_ok */
M66_exit_ok:
/* QL:         subq.l  #2,a1 */
    subq.l #2,a1
/* QL:         move.w  d1,0(a6,a1.l)   set string length */
    move.w d1,0(a6,a1.l)
/* QL:         movem.l (sp)+,reg_list */
    movem.l (sp)+,d1-d5/a0
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: cn_day */
cn_day:
/* QL:         movem.l reg_list,-(sp) */
    movem.l d1-d5/a0,-(sp)
/* QL:         bsr.s   M66_calend */
    bsr.s M66_calend
/* QL:         swap    d4 */
    swap d4
/* QL:         moveq   #M66_daytab*2,d3 */
    moveq #(M66_daytab*2),d3
/* QL:         bsr.s   wAAAS           move day into string and pad with a space */
    bsr.s M66_waaas
/* QL:         moveq   #3,d1           string length excludes the trailing space */
    moveq #3,d1
/* QL:         bra.s   M66_exit_ok */
    bra.s M66_exit_ok
/* QL: * Calendar subroutine */
/* QL: * Call with d1.l = time in seconds since 00:00:00 on 1st jan in year M66_dot */
/* QL: * Returns with: */
/* QL: * d0 = 7 */
/* QL: * d1.msw = second */
/* QL: * d2.msw = minute */
/* QL: * d2.lsw = hour */
/* QL: * d3.lsw = day of month (1..31) */
/* QL: * d4.msw = day of week (0..6) */
/* QL: * d4.lsw = month (0..11) */
/* QL: * d5.lsw = year.w */
/* QL: M66_calend */
M66_calend:
/* QL:         lsr.l   #1,d1           adjust so we can divide properly (X preserved) */
    lsr.l #1,d1
/* QL:         divu    #12*60*60,d1    d1.lsw = days since M66_dot, d1.msw*2+X=sec in day */
    divu #((12*60)*60),d1
/* QL:         moveq   #0,d3 */
    moveq #0,d3
/* QL:         move.w  d1,d3           d3 = days since M66_dot */
    move.w d1,d3
/* QL:         clr.w   d1 */
    clr.w d1
/* QL:         swap    d1 */
    swap d1
/* QL:         addx.l  d1,d1           d1 = second in day */
    addx.l d1,d1
/* QL:         moveq   #60,d0 */
    moveq #60,d0
/* QL:         divu    d0,d1           d1.msw = second */
    divu d0,d1
/* QL:         moveq   #0,d2 */
    moveq #0,d2
/* QL:         move.w  d1,d2 */
    move.w d1,d2
/* QL:         divu    d0,d2           d2.msw = minute, d2.lsw = hour */
    divu d0,d2
/* QL:         move.l  d3,d4           duplicate days since M66_dot */
    move.l d3,d4
/* QL:         divu    #7,d4           d4.msw = day of week */
    divu #7,d4
/* QL:         divu    #3*365+366,d3   d3.msw fyp days, d3.lsw = fyps since t0 */
    divu #((3*365)+366),d3
/* QL:         move.w  d3,d5           d5.lsw = sets of four years since M66_dot */
    move.w d3,d5
/* QL:         clr.w   d3 */
    clr.w d3
/* QL:         swap    d3              d3 = day of four year period */
    swap d3
/* QL:         divu    #365,d3         d3.msw = day of year, d3.lsw = year of fyp */
    divu #365,d3
/* QL:         moveq   #31+28,d0       d0 = jan+feb (non-leap) */
    moveq #(31+28),d0
/* QL:         subq.w  #3,d3           check for year in period >= 3 */
    subq.w #3,d3
/* QL:         blt.s   M66_notleap */
    blt.s M66_notleap
/* QL:         beq.s   M66_not4th          if it's the final odd day 0 / year 4 */
    beq.s M66_not4th
/* QL:         move.l  #365<<16,d3     make it right */
    move.l #(365<<16),d3
/* QL: M66_not4th */
M66_not4th:
/* QL:         moveq   #31+29,d0       d0 = jan+feb(leap) */
    moveq #(31+29),d0
/* QL: M66_notleap */
M66_notleap:
/* QL:         asl.w   #2,d5 */
    asl.w #2,d5
/* QL:         add.w   d3,d5 */
    add.w d3,d5
/* QL:         add.w   #M66_dot+3,d5       d5.lsw = year */
    add.w #(M66_dot+3),d5
/* QL:         clr.w   d3 */
    clr.w d3
/* QL:         swap    d3              d1 = day in year */
    swap d3
/* QL:         sub.w   d0,d3 */
    sub.w d0,d3
/* QL:         blt.s   M66_notjf           if day >= jan+feb (month >= march) then */
    blt.s M66_notjf
/* QL:         moveq   #31+30,d0       make feb look like a 30 day month */
    moveq #(31+30),d0
/* QL: M66_notjf */
M66_notjf:
/* QL:         add.w   d0,d3 */
    add.w d0,d3
/* QL: * Pattern now goes like: 31,30,31,30,31,30,31,31,30,31,30,31 */
/* QL:         moveq   #7,d0           d0 = months in cycle */
    moveq #7,d0
/* QL:         mulu    d0,d3 */
    mulu d0,d3
/* QL:         addq.w  #3,d3 */
    addq.w #3,d3
/* QL:         divu    #7*30+4,d3      d3 = (day * d0 + d0 div 2) / (days in cycle) */
    divu #((7*30)+4),d3
/* QL:         move.w  d3,d4           d4.msw = day of week, d4.lsw = month in year */
    move.w d3,d4
/* QL:         clr.w   d3 */
    clr.w d3
/* QL:         swap    d3 */
    swap d3
/* QL:         divu    d0,d3           day in month = remainder div d0 */
    divu d0,d3
/* QL:         addq.w  #1,d3           plus one */
    addq.w #1,d3
/* QL:         rts */
    rts 
/* QL:         end */
