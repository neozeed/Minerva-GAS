/* ROM section sd_fresh */
.balign 2,0
/* QL: * a5 -i p- base address of screen to be refreshed */
/* QL: * d0-d3/a0-a1/a3-a4 destroyed */
/* QL: sd_fresh */
sd_fresh:
/* QL:         move.l  a5,a1 */
    move.l a5,a1
/* QL:         move.w  #M110_ra_ssize/4-1,d0 ... long words */
    move.w #((M110_ra_ssize/4)-1),d0
/* QL: M110_cls */
M110_cls:
/* QL:         clr.l   (a1)+ */
    clr.l (a1)+
/* QL:         dbra    d0,M110_cls */
    dbra d0,M110_cls
/* QL: * Now go through all windows open, resetting and clearing them */
/* QL:         move.l  M110_sv_chbas(a6),a4 start address of channel tables */
    move.l M110_sv_chbas(a6),a4
/* QL: M110_chn_loop */
M110_chn_loop:
/* QL:         move.l  (a4)+,d0        next channel */
    move.l (a4)+,d0
/* QL:         blt.s   M110_next_chn        ... does it exist? */
    blt.s M110_next_chn
/* QL:         move.l  d0,a0           set address of channel definition block */
    move.l d0,a0
/* QL:         move.l  M110_sv_chtop(a6),a3 sysvar extension */
    move.l M110_sv_chtop(a6),a3
/* QL:         lea     M110_sx_con(a3),a3   linkage area for con driver */
    lea M110_sx_con(a3),a3
/* QL:         cmp.l   M110_ch_drivr(a0),a3 is it a window? */
    cmp.l M110_ch_drivr(a0),a3
/* QL:         bne.s   M110_next_chn        ... no */
    bne.s M110_next_chn
/* QL: ;       cmp.l   M110_sd_scrb(a0),a5  is this the screen we are doing? */
/* QL: ; above is proper, but pander to qptr on it's dummy window... next 4 instrns */
/* QL:         moveq   #M110_ra_bot>>16,d0  treat zero screen base in qptr dummy as scr0 */
    moveq #(M110_ra_bot>>16),d0
/* QL:         swap    d0 */
    swap d0
/* QL:         or.l    M110_sd_scrb(a0),d0  get this channel's screen base */
    or.l M110_sd_scrb(a0),d0
/* QL:         cmp.l   d0,a5           is this the screen we are doing? */
    cmp.l d0,a5
/* QL:         bne.s   M110_next_chn        ... no */
    bne.s M110_next_chn
/* QL:         bsr.s   sd_modes        set up info for this mode */
    bsr.s sd_modes
/* QL:         tst.b   (a1)            if cursor is not suppressed ... */
    tst.b (a1)
/* QL:         sne     (a1)            ... make it invisible */
    sne (a1)
/* QL:         move.w  M110_sd_borwd(a0),-(sp) save border as we have to re-make it */
    move.w M110_sd_borwd(a0),-(sp)
/* QL:         clr.w   d2              in case it is transparent */
    clr.w d2
/* QL:         jsr     sd_bordn(pc)    and remove old border */
    jsr sd_bordn(pc)
/* QL:         jsr     sd_clear(pc)    clear all of window */
    jsr sd_clear(pc)
/* QL:         move.b  (a3),d1         set border colour */
    move.b (a3),d1
/* QL:         move.w  (sp)+,d2        ... and width */
    move.w (sp)+,d2
/* QL:         jsr     sd_bordr(pc) */
    jsr sd_bordr(pc)
/* QL: M110_next_chn */
M110_next_chn:
/* QL:         cmp.l   M110_sv_chtop(a6),a4 end of channel list? */
    cmp.l M110_sv_chtop(a6),a4
/* QL:         blt.s   M110_chn_loop */
    blt.s M110_chn_loop
/* QL:         rts */
    rts 
/* QL: * Routine for setting mode dependent info */
/* QL: * d0 -  o- ms3b -1, lsb = 0 for mode 4, 1<<M110_sd..dbwd ($40) for mode 8, ccr set */
/* QL: * a0 -ip - channel definition */
/* QL: * a1 -  o- M110_sd_curf(a0) */
/* QL: * a3 -  o- M110_sd_bcolr(a0) */
/* QL: * d1 destroyed */
/* QL: sd_modes */
sd_modes:
/* QL:         lea     M110_sd_pmask(a0),a1 set up addresses of colour masks and bytes */
    lea M110_sd_pmask(a0),a1
/* QL:         assert  M110_sd_pmask,M110_sd_smask-4,M110_sd_imask-8,M110_sd_cattr-12,M110_sd_curf-13 */
/* original assertion: M110_sd_pmask,M110_sd_smask-4,M110_sd_imask-8,M110_sd_cattr-12,M110_sd_curf-13 */
/* QL:         lea     M110_sd_pcolr(a0),a3 */
    lea M110_sd_pcolr(a0),a3
/* QL:         assert  M110_sd_pcolr,M110_sd_scolr-1,M110_sd_icolr-2,M110_sd_bcolr-3 */
/* original assertion: M110_sd_pcolr,M110_sd_scolr-1,M110_sd_icolr-2,M110_sd_bcolr-3 */
/* QL:         moveq   #3-1,d0         recreate three of them */
    moveq #(3-1),d0
/* QL: M110_col_loop */
M110_col_loop:
/* QL:         move.b  (a3)+,d1        get colour byte */
    move.b (a3)+,d1
/* QL:         jsr     cs_color(pc)    set colour mask */
    jsr cs_color(pc)
/* QL:         addq.l  #4,a1           next mask */
    addq.l #4,a1
/* QL:         dbra    d0,M110_col_loop */
    dbra d0,M110_col_loop
/* QL:         assert  M110_sd_xinc,M110_sd_yinc-2 */
/* original assertion: M110_sd_xinc,M110_sd_yinc-2 */
/* QL:         move.l  #6<<16!10,M110_sd_xinc(a0) default x/y increments */
    move.l #((6<<16)|10),M110_sd_xinc(a0)
/* QL:         moveq   #1<<M110_mc..m256,d0 */
    moveq #(1<<M110_mc..m256),d0
/* QL:         and.b   M110_sv_mcsta(a6),d0 */
    and.b M110_sv_mcsta(a6),d0
/* QL:         lsl.b   #M110_sd..dbwd-M110_mc..m256,d0 */
    lsl.b #(M110_sd..dbwd-M110_mc..m256),d0
/* QL:         move.b  d0,(a1)+        set M110_sd_cattr, point to M110_sd_curf */
    move.b d0,(a1)+
/* QL:         beq.s   M110_rts0            512 - all done */
    beq.s M110_rts0
/* QL:         lsl     M110_sd_xinc(a0)     256 - double the x increment */
    lsl M110_sd_xinc(a0)
/* QL: M110_rts0 */
M110_rts0:
/* QL:         rts */
    rts 
/* QL:         end */
