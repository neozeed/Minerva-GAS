/* ROM section ss_tlist */
.balign 2,0
/* QL: * d1 -  o- 0 */
/* QL: * d3 -ip - count of missing poll interrupts */
/* QL: * d4 -i  - offset from M9_sv_i2lst (0, 4 or 8 for i2lst, plist or shlst) */
/* QL: * a0 -  o- 0 */
/* QL: * a6 -ip - base of sytem variables */
/* QL: * d0/d2/d5-d6/a1-a5 destroyed */
/* QL: ss_tlist */
ss_tlist:
/* QL:         move.l  M9_sv_i2lst(a6,d4.w),a0 get base entry of linked list */
    move.l M9_sv_i2lst(a6,d4.w),a0
/* QL:         assert  (M9_sv_i2lst-M9_sv_i2lst)*2,M9_sv_lxint */
/* original assertion: (M9_sv_i2lst-M9_sv_i2lst)*2,M9_sv_lxint */
/* QL:         assert  (M9_sv_plist-M9_sv_i2lst)*2,M9_sv_lpoll */
/* original assertion: (M9_sv_plist-M9_sv_i2lst)*2,M9_sv_lpoll */
/* QL:         assert  (M9_sv_shlst-M9_sv_i2lst)*2,M9_sv_lschd */
/* original assertion: (M9_sv_shlst-M9_sv_i2lst)*2,M9_sv_lschd */
/* QL:         add.b   d4,d4 */
    add.b d4,d4
/* QL:         neg.l   d4              convert to device drive definition offset */
    neg.l d4
/* QL:         movem.l d3-d4/a6,-(sp)  save stuff */
    movem.l d3-d4/a6,-(sp)
/* QL:         bra.s   M9_enter */
    bra.s M9_enter
/* QL: M9_loop */
M9_loop:
/* QL:         moveq   #127,d3         making it a positive byte (why? lwr) */
    moveq #127,d3
/* QL:         and.b   d2,d3           set up for positive byte missing polls */
    and.b d2,d3
/* QL:         add.l   a0,a3           set base of driver definition block */
    add.l a0,a3
/* QL:         move.l  4(a0),a0        start address is one long word on from link */
    move.l 4(a0),a0
/* QL:         jsr     (a0)            call the entry point */
    jsr (a0)
/* QL:         move.l  (sp)+,a0        restore pointer */
    move.l (sp)+,a0
/* QL:         move.l  (a0),a0         take next */
    move.l (a0),a0
/* QL: M9_enter */
M9_enter:
/* QL:         movem.l (sp),d2/a3/a6   set registers ready */
    movem.l (sp),d2/a3/a6
/* QL:         move.l  a0,-(sp)        save base address of task */
    move.l a0,-(sp)
/* QL:         bne.s   M9_loop            next pointer */
    bne.s M9_loop
/* QL:         movem.l (sp)+,d1/d3-d4/a6 restore d3 properly, d1=0 */
    movem.l (sp)+,d1/d3-d4/a6
/* QL:         rts */
    rts 
/* QL:         end */
