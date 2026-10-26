/* ROM section mt_dmode */
.balign 2,0
/* QL: * This performs two disparate functions. The one sets either 256 or 512 */
/* QL: * pixel mode. The other tells any software that is interested whether a */
/* QL: * monitor or tv is in use. In the latter case, a distinction between a */
/* QL: * 525 line and 625 TV is made. The initialisation code will select the */
/* QL: * correct sort of TV. Selecting 525 lines on a European ROM may not */
/* QL: * produce useful results.  */
/* QL: * The enhanced set of options now available needs to operate on up to six bits */
/* QL: * of information. These are the 4/8 colour and visible states of each of two */
/* QL: * screens (4 bits), which screen is currently displayed and which screen is */
/* QL: * the current default for this job. They may all be read, en mass, but there */
/* QL: * is a need to be able to selectively set them, which means 12+ bits! */
/* QL: * In order to maintain compatibility, even with people who send the wrong */
/* QL: * parameters, the new options have bits 7/6 of d1.b differring. Also for */
/* QL: * compatibility, old style calls clear the msbs of d1.l even though it is */
/* QL: * contrary to the documentation. */
/* QL: * The primary needs are to be able to change the default screen and make it */
/* QL: * blank or visible. Being able to force which screen is on display is rather */
/* QL: * undesirable for too many programs to try doing simultaneously! */
/* QL: * With these in mind, we define the options available from d1 bits as follows: */
/* QL: *       0       visible/blank on other screen */
/* QL: *       1       visible/blank on default screen M31_mc..blnk */
/* QL: *       2       mode4/mode8 on other screen */
/* QL: *       3       mode4/mode8 on default screen   M31_mc..m256 */
/* QL: *       4       display scr0/scr1 */
/* QL: *       5       default scr0/scr1 (n.b. takes effect before all other options) */
/* QL: *       6       clear - use d1.w. set - use d1.b (same as d1.w msb all ones). */
/* QL: *       7       opposite to bit six, i.e. 7/6 = 0/1 or 1/0 always */
/* QL: *       8-15    ignored if bit 6 set. otherwise ... */
/* QL: *       8-13    associated with bits 0-5 (clear=toggle, set=absolute) */
/* QL: *       14      clear - force M31_redraw of other screen */
/* QL: *       15      clear - force M31_redraw of default screen */
/* QL: * If bits 6 and "x" + 8 are clear, use bit "x" to force absolute selection. */
/* QL: * Otherwise, toggle settings as per bit "x". ("x" = 0..5) */
/* QL: * If bits 6 and "x" are clear, invoke that screen redraw. ("x" = 14..15) */
/* QL: * The original -1/0/8 options are equivalent to $40 (or -128), $7780 and $7788. */
/* QL: * The "default screen" is initially inherited from the parent job. */
/* QL: * It is the screen on which newly opened con/scr channels will appear. */
/* QL: * It is also the screen affected/reported on by d1.b = 0/8/-1. */
/* QL: * A change to this takes effect before the rest of the above is looked at. */
/* QL: * It then remains changed for the job, until the job does another change to it. */
/* QL: * The "mode4/mode8" selection in this extended system does not operate the */
/* QL: * same as the basic d1.b = 0/8 options. It only changes the physical display */
/* QL: * mode. Redrawing of the windows is independant. It is also not forced by d2.b */
/* QL: * being positive, except on d1 = 0/8/-1 calls. */
/* QL: * The "displayed screen" is the one currently on display. */
/* QL: * The system variable "M31_sv_mcsta" records the selection that is on display. */
/* QL: * A new system extension variable, "M31_sx_dspm", records what is really going on. */
/* QL: * It holds the following bits: */
/* QL: *       bit     0       1 */
/* QL: *       0       visible blank   scr0 */
/* QL: *       1       visible blank   scr1            M31_mc..blnk */
/* QL: *       2       mode4   mode8   scr0 */
/* QL: *       3       mode4   mode8   scr1            M31_mc..m256 */
/* QL: *       4                       reserved */
/* QL: *       5                       reserved */
/* QL: *       6                       will always be zero */
/* QL: *       7       scr0    scr1    display         M31_mc..scrn */
/* QL: * The least significant bit of the M31_jb_rela6 variable in a jobs header is where */
/* QL: * its "default screen" is recorded. 0=scr0, 1=scr1. */
/* QL: * The returned value in d1.b for the extended calls is as follows: */
/* QL: *       bit     0       1 */
/* QL: *       0       visible blank   other */
/* QL: *       1       visible blank   default         M31_mc..blnk */
/* QL: *       2       mode4   mode8   other */
/* QL: *       3       mode4   mode8   default         M31_mc..m256 */
/* QL: *       4       scr0    scr1    display */
/* QL: *       5       scr0    scr1    default */
/* QL: *       6                       ??? */
/* QL: *       7       single  dual    available       M31_mc..scrn */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -i o- mode key (-1 read, 0 set 512, 8 set 256) */
/* QL: * d2 -i o- tv key   (-1 read, 0 set monitor, 1 set tv/625, 2 set tv/525) */
/* QL: * a6 -ip - base of system variables */
/* QL: reg_on1 reg    d1-d2            put on after lsb's are set */
/* QL: reglist reg    d1-d5/a0-a5      restore most registers (even a4 now!) */
/* QL: mt_dmode */
mt_dmode:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d5/a0-a5,-(sp)
/* QL:         jsr     ip_dspm(pc)     leaves a4 pointing at sysvar extension */
    jsr ip_dspm(pc)
/* QL:         movem.l (sp)+,reg_on1 */
    movem.l (sp)+,d1-d2
/* QL:         jsr     ss_jobc(pc)     find current job */
    jsr ss_jobc(pc)
/* QL:         move.w  d1,d3           working copy of d1.w */
    move.w d1,d3
/* QL:         moveq   #64,d0          this will give the new equivalent of -1 */
    moveq #64,d0
/* QL:         add.b   d1,d1           is it old style call? */
    add.b d1,d1
/* QL:         svs     d1              no - set mask as $ff ... */
    svs d1
/* QL:         bvs.s   M31_d1new           ... and we are ready for next bit */
    bvs.s M31_d1new
/* QL:         bcs.s   M31_oldflag         carry means it was the -1 option */
    bcs.s M31_oldflag
/* QL:         moveq   #M31_bm,d0 */
    moveq #M31_bm,d0
/* QL:         and.b   d3,d0           keep old 0/8 bit */
    and.b d3,d0
/* QL:         add.w   #(255-M31_bs-M31_bm)<<8+128,d0 make new equivalent */
    add.w #((((255-M31_bs)-M31_bm)<<8)+128),d0
/* QL: M31_oldflag */
M31_oldflag:
/* QL:         move.w  d0,d3           use prepared equivalent call */
    move.w d0,d3
/* QL:         moveq   #M31_bm,d1          clear msbs, for compatibility */
    moveq #M31_bm,d1
/* QL: ;       addq.b  #M31_bm,d1          only want to return the m256 bit */
/* QL: M31_d1new */
M31_d1new:
/* QL:         moveq   #$3f,d4 */
    moveq #0x3f,d4
/* QL:         and.b   d3,d4           copy d1.b, but ensure 2 msb's are clear */
    and.b d3,d4
/* QL:         ror.w   #8,d3           fetch down d1.w (msb) */
    ror.w #8,d3
/* QL:         bmi.s   M31_setdef          if d1.b was negative, "default" is ready */
    bmi.s M31_setdef
/* QL:         st      d3              set all the d1.w (msb) */
    st d3
/* QL: M31_setdef */
M31_setdef:
/* QL: * In the following, the bits floating about are labelled as follows: */
/* QL: * d - dual screens available */
/* QL: * j - job default screen */
/* QL: * c - currently displayed screen */
/* QL: *       M31_redraw  mode8   blank */
/* QL: *       s       m       b       - screen 1 */
/* QL: *       s       m       b       - screen 0 */
/* QL: *       r       l       a       - job default screen */
/* QL: *       r       l       a       - job other screen */
/* QL:         moveq   #-1-$70,d5      1111111110001111 */
    moveq #((-1)-0x70),d5
/* QL:         and.b   M31_sx_dspm(a4),d5  11111111c000mmbb */
    and.b M31_sx_dspm(a4),d5
/* QL:         bset    #0,M31_jb_rela6(a3) test current job default screen and set scr1 */
    bset #0,M31_jb_rela6(a3)
/* QL:         sne     d0              ????????jjjjjjjj remember old state */
    sne d0
/* QL:         and.b   d3,d0           keep "default" as per msb, then flip lsb... */
    and.b d3,d0
/* QL:         eor.b   d4,d0           ??????????j????? new default screen */
    eor.b d4,d0
/* QL:         lsl.b   #3,d0           ?????????????000 carry set if scr1 is right */
    lsl.b #3,d0
/* QL:         bcs.s   M31_jbd1            if it was one, skip swaps and flag clearing */
    bcs.s M31_jbd1
/* QL:         bclr    d0,M31_jb_rela6(a3) job default screen is now scr0 */
    bclr d0,M31_jb_rela6(a3)
/* QL:         bsr.s   M31_munge           go swap bits */
    bsr.s M31_munge
/* QL: M31_jbd1 */
M31_jbd1:
/* QL:         moveq   #5,d0           j bit no */
    moveq #5,d0
/* QL:         bset    d0,d3           keep new j */
    bset d0,d3
/* QL:         bclr    d0,d4           don't toggle new j */
    bclr d0,d4
/* QL:         add.w   d5,d5           111111jc000llaa0 */
    add.w d5,d5
/* QL:         asl.b   #3,d5           111111jcllaa0000 */
    asl.b #3,d5
/* QL:         asr.w   #4,d5           1111111111jcllaa */
    asr.w #4,d5
/* QL:         and.b   d3,d5           keep "default" as per msb, then flip lsb... */
    and.b d3,d5
/* QL:         eor.b   d4,d5           11111111rrjcllaa */
    eor.b d4,d5
/* QL:         moveq   #-64,d4         1111111111000000 */
    moveq #(-64),d4
/* QL:         or.b    d5,d4           1111111111jcllaa */
    or.b d5,d4
/* QL:         rol.w   #8,d4           11jcllaa11111111 */
    rol.w #8,d4
/* QL:         add.w   a6,d4           d1jcllaa11111111 */
    add.w a6,d4
/* QL:         ror.w   #8,d4           11111111d1jcllaa */
    ror.w #8,d4
/* QL:         tst.b   d2 */
    tst.b d2
/* QL:         blt.s   M31_no_tvchg        jump if no tv change. */
    blt.s M31_no_tvchg
/* QL:         move.b  d2,M31_sv_tvmod(a6) set tv mode system variable */
    move.b d2,M31_sv_tvmod(a6)
/* QL:         moveq   #$7f,d0         in case we want a M31_redraw ... */
    moveq #0x7f,d0
/* QL:         or.b    d1,d0           ... new style call will set d0.b = $ff */
    or.b d1,d0
/* QL:         and.b   d0,d5           argh, if old and d2.b >= 0, must force M31_redraw */
    and.b d0,d5
/* QL: M31_no_tvchg */
M31_no_tvchg:
/* QL:         and.b   d4,d1           use mask old/extended return value */
    and.b d4,d1
/* QL:         move.b  M31_sv_tvmod(a6),d2 pick tv mode back up */
    move.b M31_sv_tvmod(a6),d2
/* QL:         movem.l reg_on1,-(sp)   d1.b and d2.b are now ready for return */
    movem.l d1-d2,-(sp)
/* QL:         rol.b   #3,d5           11111111cllaarrj */
    rol.b #3,d5
/* QL:         asr.b   #1,d5           11111111ccllaarr */
    asr.b #1,d5
/* QL:         bcs.s   M31_njd0            if j set, we have d5 right */
    bcs.s M31_njd0
/* QL:         bsr.s   M31_munge           11111110c0mmbbss */
    bsr.s M31_munge
/* QL: M31_njd0 */
M31_njd0:
/* QL:         move.l  #M31_ra_bot,a5 */
    move.l #M31_ra_bot,a5
/* QL:         asr.b   #1,d5           1111111?cc?mmbbs */
    asr.b #1,d5
/* QL:         bsr.s   M31_redraw          check/do M31_redraw of screen 0 */
    bsr.s M31_redraw
/* QL:         sub.w   #-M31_ra_ssize,a5   point to base of second screen */
    sub.w #(-M31_ra_ssize),a5
/* QL:         asr.b   #1,d5           ????????ccc?mmbb */
    asr.b #1,d5
/* QL:         btst    #M31_mc..scrn,d4    are there really two screens? */
    btst #M31_mc..scrn,d4
/* QL:         beq.s   M31_rddone          no - then we're done */
    beq.s M31_rddone
/* QL:         bsr.s   M31_redraw          check/do M31_redraw of screen 1 */
    bsr.s M31_redraw
/* QL: M31_rddone */
M31_rddone:
/* QL:         moveq   #-1-$70,d0      1111111110001111 */
    moveq #((-1)-0x70),d0
/* QL:         and.b   d5,d0           ????????c000mmbb */
    and.b d5,d0
/* QL:         move.b  d0,M31_sx_dspm(a4)  save new state */
    move.b d0,M31_sx_dspm(a4)
/* QL:         bmi.s   M31_isscr1 */
    bmi.s M31_isscr1
/* QL:         add.b   d5,d5           ????????000mmbb0 */
    add.b d5,d5
/* QL: M31_isscr1 */
M31_isscr1:
/* QL:         bsr.s   M31_setmc           set M31_sv_mcsta */
    bsr.s M31_setmc
/* QL:         move.b  d0,M31_mc_stat      yipee! finally, we set the display hardware! */
    move.b d0,M31_mc_stat
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d5/a0-a5
/* QL:         jmp     ss_noer(pc) */
    jmp ss_noer(pc)
/* QL: * This routine swaps bit pairs 5/4, 3/2 and 1/0 in d5. bits 8 and 6 are */
/* QL: * cleared and the rest (f-9 and 7) are copied unchanged. d0 is zapped. */
/* QL: * The comments show the original bit numbers, z=zero and w=one. */
/* QL: M31_munge */
M31_munge:
/* QL:         moveq   #$15,d0         zzzzzzzzzzzwzwzw */
    moveq #0x15,d0
/* QL:         and.b   d5,d0           zzzzzzzzzzz4z2z0 */
    and.b d5,d0
/* QL:         add.b   d0,d0           zzzzzzzzzz4z2z0z */
    add.b d0,d0
/* QL:         asr.b   #1,d5           fedcba9877654321 */
    asr.b #1,d5
/* QL:         and.w   #$fe95,d5       fdecba9z7zz5z3z1 */
    and.w #0xfe95,d5
/* QL:         or.b    d0,d5           fedcba9z7z452301 */
    or.b d0,d5
/* QL:         rts */
    rts 
/* QL: * check / M31_redraw of a screen */
/* QL: M31_redraw */
M31_redraw:
/* QL:         bcs.s   M31_ret             if inhibit flag was set, no M31_redraw wanted */
    bcs.s M31_ret
/* QL:         ; this bit is to see if it's nice to blank screen while redrawing */
/* QL:         ext.w   d5 */
    ext.w d5
/* QL:         add.w   a5,d5 */
    add.w a5,d5
/* QL:         bmi.s   M31_noblnk          skip if not the visible screen */
    bmi.s M31_noblnk
/* QL:         move.b  #M31_bb,M31_mc_stat */
    move.b #(M31_bb&255),M31_mc_stat
/* QL: M31_noblnk */
M31_noblnk:
/* QL:         ; end of that fringle. cost: 18 bytes */
/* QL:         bsr.s   M31_setmc           set up for utilities being called */
    bsr.s M31_setmc
/* QL:         jmp     sd_fresh(pc)    go do total M31_redraw of a screen */
    jmp sd_fresh(pc)
/* QL: * This sets the hardware bits in M31_sv_mcsta as needed by other routines */
/* QL: M31_setmc */
M31_setmc:
/* QL:         moveq   #M31_bs+M31_bm+M31_bb-256,d0 */
    moveq #(((M31_bs+M31_bm)+M31_bb)-256),d0
/* QL:         and.b   d5,d0 */
    and.b d5,d0
/* QL:         moveq   #1<<1,d1 */
    moveq #(1<<1),d1
/* QL:         and.b   M31_sv_tvmod(a6),d1 treat tvmod bit 1 set as ntsc (2,3,6,7,...) */
    and.b M31_sv_tvmod(a6),d1
/* QL:         lsl.b   #M31_mc..ntsc-1,d1 */
    lsl.b #(M31_mc..ntsc-1),d1
/* QL:         or.b    d1,d0 */
    or.b d1,d0
/* QL:         move.b  d0,M31_sv_mcsta(a6) */
    move.b d0,M31_sv_mcsta(a6)
/* QL: M31_ret */
M31_ret:
/* QL:         rts */
    rts 
/* QL:         end */
