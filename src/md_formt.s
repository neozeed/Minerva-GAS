/* ROM section md_formt */
.balign 2,0
/* QL: * d0 -  o- error code */
/* QL: * d1 -i o- number of medium to format / number of sectors good */
/* QL: * d2 -i o- number of sectors found (includes dodgy ones...) */
/* QL: * a1 -i  - pointer to medium name */
/* QL: M78_err_iu */
M78_err_iu:
/* QL:         moveq   #M78_err.iu,d0 */
    moveq #M78_err.iu,d0
/* QL: M78_anrts */
M78_anrts:
/* QL:         rts */
    rts 
/* QL: md_formt */
md_formt:
/* QL:         tst.b   M78_sv_mdrun(a6)    is any drive running? */
    tst.b M78_sv_mdrun(a6)
/* QL:         bne.s   M78_err_iu          yes - say in use */
    bne.s M78_err_iu
/* QL:         move.l  d1,d7           save drive number */
    move.l d1,d7
/* QL:         move.l  a1,a4           save medium name */
    move.l a1,a4
/* QL:         moveq   #(M78_hp_end+M78_wsend+15)>>4,d1 */
    moveq #(((M78_hp_end+M78_wsend)+15)>>4),d1
/* QL:         asl.w   #4,d1           allocate workspace */
    asl.w #4,d1
/* QL:         jsr     mm_alchp(pc) */
    jsr mm_alchp(pc)
/* QL:         bne.s   M78_anrts */
    bne.s M78_anrts
/* QL:         lea     M78_hp_end(a0),a5   set base of workspace proper */
    lea M78_hp_end(a0),a5
/* QL: * Preset sector header */
/* QL: * We've gone back to writing sector 255, but we'll actually fail the format */
/* QL: * if we see it, or 254, after verify, as it means the tape's running too slow! */
/* QL:         move.l  a5,a0           set start of sector header */
    move.l a5,a0
/* QL:         subq.w  #1,(a0)+        flag ff, sector ff (use ff as format fail, lwr) */
    subq.w #1,(a0)+
/* QL:         moveq   #-M78_dvl,d3 */
    moveq #(-M78_dvl),d3
/* QL:         add.w   (a4)+,d3        get number of characters after mdvn_ */
    add.w (a4)+,d3
/* QL:         addq.l  #M78_dvl,a4         skip past device part */
    addq.l #M78_dvl,a4
/* QL:         moveq   #M78_nml-1,d1       copy/pad name chars */
    moveq #(M78_nml-1),d1
/* QL: M78_put_name */
M78_put_name:
/* QL:         moveq   #' ',d2         pad with blanks */
    moveq #32,d2
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         blt.s   M78_put_char */
    blt.s M78_put_char
/* QL:         move.b  (a4)+,d2        get character of name */
    move.b (a4)+,d2
/* QL: M78_put_char */
M78_put_char:
/* QL:         move.b  d2,(a0)+ */
    move.b d2,(a0)+
/* QL:         dbra    d1,M78_put_name */
    dbra d1,M78_put_name
/* QL:         move.w  M78_sv_rand(a6),(a0)+ and random number */
    move.w M78_sv_rand(a6),(a0)+
/* QL: * Preset format block */
/* QL:  wdcs M78_st_free 0 1 */
/* QL: wd setnum [m]<<8![l] */
/* QL: cs setnum (([m])+([l]))*([n])+$f0f */
/* QL: cs setnum ([cs]&255)<<8![cs]>>8&255 */
/* QL:         move.l  #[wd]<<16![cs],(a0)+ empty / block 0 / checksum */
    move.l #((64768<<16)|16),(a0)+
/* QL:         addq.l  #M78_bldata-M78_blpre-2,a0 preamble mainly zeroes */
.word 20616|(((((M78_bldata-M78_blpre)-2))&7)<<9)
/* QL:         subq.w  #1,(a0)+        finishing with 2 bytes of ones for sync */
    subq.w #1,(a0)+
/* QL:         move.w  #(M78_blend-M78_bldata)/2-1,d1 fill data and extra bytes */
    move.w #(((M78_blend-M78_bldata)/2)-1),d1
/* QL:  wdcs $aa $55 M78_bdl/2 */
/* QL: wd setnum [m]<<8![l] */
/* QL: cs setnum (([m])+([l]))*([n])+$f0f */
/* QL: cs setnum ([cs]&255)<<8![cs]>>8&255 */
/* QL: M78_fil_mem */
M78_fil_mem:
/* QL:         move.w  #[wd],(a0)+ */
    move.w #43605,(a0)+
/* QL:         dbra    d1,M78_fil_mem */
    dbra d1,M78_fil_mem
/* QL:         move.w  #[cs],M78_blcs(a5) */
    move.w #14,M78_blcs(a5)
/* QL: * Now start the format */
/* QL:         move.w  d7,d1           restore drive number */
    move.w d7,d1
/* QL:         lea     M78_pc_mctrl,a3     set address of microdrive control register */
    lea M78_pc_mctrl,a3
/* QL:         moveq   #M78_pc.mdvmd,d0    set microdrive mode */
    moveq #M78_pc.mdvmd,d0
/* QL:         jsr     ss_wser(pc)     and wait for RS232 to complete */
    jsr ss_wser(pc)
/* QL:         move    sr,-(sp)        save current interrupt level */
    move sr,-(sp)
/* QL:         or.w    #$0700,sr       disable interrupts */
    or.w #0x0700,sr
/* QL:         jsr     md_selec(pc)    select drive */
    jsr md_selec(pc)
/* QL:         delay   500000          wait half a second */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL:  ifnum [us] < 4177923 goto swap8 */
/* QL: swap8 maclab 0.229 to 4.162 step 0.033 seconds */
/* QL:  moveq #([us]*15+245720)/491520,d0 eight byte coarse sequence */
    moveq #(((500000*15)+245720)/491520),d0
/* QL:  swap d0 */
    swap d0
/* QL:  subq.l #8,d0 */
    subq.l #8,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         move.b  #M78_pc.erase,(a3)  erase on */
    move.b #(M78_pc.erase&255),(a3)
/* QL: M78_write_lp */
M78_write_lp:
/* QL:         move.l  a5,a1           08    reset pointer */
    move.l a5,a1
/* QL:         moveq   #M78_shend-M78_shbeg-1,d1 08  write sector header */
    moveq #((M78_shend-M78_shbeg)-1),d1
/* QL:         delay   (2840-85)       gap allows for jsr and final wait */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL: wsubw maclab 313 to 27193 step 3 us */
/* QL:  move.w #([us]*15-46)/52,d0 eight byte fine sequence */
    move.w #((((2840-85)*15)-46)/52),d0
/* QL:  subq.w #1,d0 */
    subq.w #1,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         jsr     md_wblok(pc) */
    jsr md_wblok(pc)
/* QL:         move.w  #M78_blend-M78_blbeg-1,d1 16 write specially long block */
    move.w #((M78_blend-M78_blbeg)-1),d1
/* QL:         delay   (2840-80)       gap allows for jsr and final wait */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL:  ifnum [us] < 227195 goto wsubw */
/* QL: wsubw maclab 313 to 27193 step 3 us */
/* QL:  move.w #([us]*15-46)/52,d0 eight byte fine sequence */
    move.w #((((2840-80)*15)-46)/52),d0
/* QL:  subq.w #1,d0 */
    subq.w #1,d0
/* QL:  bcc.s *-2 */
    bcc.s (.-2)
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         jsr     md_wblok(pc) */
    jsr md_wblok(pc)
/* QL:         subq.b  #1,M78_sno-M78_map(a1)  24+16 next sector number */
    subq.b #1,(M78_sno-M78_map)(a1)
/* QL:         bcc.s   M78_write_lp        12/18 last sector is 0 */
    bcc.s M78_write_lp
/* QL:         move.b  #M78_pc.read,(a3)   erase off */
    move.b #(M78_pc.read&255),(a3)
/* QL: * Now verify */
/* QL:         clr.l   -(sp)           clear counts of sectors */
    clr.l -(sp)
/* QL:         moveq   #-1,d5          two counts of 255 (reduced by one by lwr) */
    moveq #(-1),d5
/* QL: M78_ver_loop */
M78_ver_loop:
/* QL:         subq.b  #1,d5 */
    subq.b #1,d5
/* QL:         bcs.s   M78_err_fmt1 */
    bcs.s M78_err_fmt1
/* QL:         move.l  a5,a1 */
    move.l a5,a1
/* QL:         jsr     md_sectr(pc)    find sector */
    jsr md_sectr(pc)
/* QL: M78_err_fmt1 */
M78_err_fmt1:
/* QL:         bra.s   M78_err_fmt2        no signal */
    bra.s M78_err_fmt2
/* QL:         bra.s   M78_ver_loop        not a sector header */
    bra.s M78_ver_loop
/* QL:         jsr     md_veril(pc)    verify long block */
    jsr md_veril(pc)
/* QL:         bra.s   M78_ver_loop        bad block */
    bra.s M78_ver_loop
/* QL:         add.w   d7,d7           address of entry in M78_map */
    add.w d7,d7
/* QL:         addq.b  #1,0(a1,d7.w)   check sector flag */
    addq.b #1,0(a1,d7.w)
/* QL:         blt.s   M78_err_fmt2        horrid if we've already seen it twice! lwr */
    blt.s M78_err_fmt2
/* QL:         subq.b  #2,0(a1,d7.w)   decrement sector flag */
    subq.b #2,0(a1,d7.w)
/* QL:         move.l  d7,d2           is this sector 0? (and clear msw of d2) */
    move.l d7,d2
/* QL:         bne.s   M78_ver_loop        no - carry on */
    bne.s M78_ver_loop
/* QL:         lsr.w   #8,d5           was this first time round? */
    lsr.w #8,d5
/* QL:         bne.s   M78_ver_loop        once round again */
    bne.s M78_ver_loop
/* QL: * All sectors verified up to twice - check the M78_map (a1 is pointing at it) */
/* QL: * Blot out sectors on either side of a bad sector. Pretend 256 is bad (lwr) */
/* QL:         add.w   #M78_bdl-4,a1       point to entries 254 and 255 of M78_map */
    add.w #(M78_bdl-4),a1
/* QL:         tst.l   (a1)+           did we see either of sectors 254 or 255? */
    tst.l (a1)+
/* QL:         bne.s   M78_err_fmt2        if so, the tape's running disastrously slow! */
    bne.s M78_err_fmt2
/* QL: M78_chk_bad */
M78_chk_bad:
/* QL:         swap    d7              roll the previous flag */
    swap d7
/* QL:         move.w  -(a1),d7        is this a bad sector? */
    move.w -(a1),d7
/* QL:         asr.w   #1,d7           remember it as $ffxx if it's ok, $00xx if bad */
    asr.w #1,d7
/* QL:         and.l   d7,(a1)         zap neigbours of un-seen sectors */
    and.l d7,(a1)
/* QL:         subq.b  #1,d5 */
    subq.b #1,d5
/* QL:         bne.s   M78_chk_bad         test all sectors (note extra 2 bytes on M78_map) */
    bne.s M78_chk_bad
/* QL: * Now convert to proper flags and count them up */
/* QL: M78_chk_loop */
M78_chk_loop:
/* QL:         subq.b  #1,(a1)         make bad sector ff, dodgy fe, good fd */
    subq.b #1,(a1)
/* QL:         bcs.s   M78_chk_end         bad */
    bcs.s M78_chk_end
/* QL:         moveq   #1,d7 */
    moveq #1,d7
/* QL:         and.b   (a1),d7         which is it? (good:d1=1, dodgy:d1=0) */
    and.b (a1),d7
/* QL:         add.w   d7,(sp)         good, increment count of good sectors */
    add.w d7,(sp)
/* QL:         move.b  d5,d2           save highest sector number */
    move.b d5,d2
/* QL: M78_chk_end */
M78_chk_end:
/* QL:         addq.l  #2,a1           move to next entry in M78_map */
    addq.l #2,a1
/* QL:         addq.b  #1,d5 */
    addq.b #1,d5
/* QL:         bne.s   M78_chk_loop        beyond 255? */
    bne.s M78_chk_loop
/* QL:         addq.l  #1,d2           total sectors = highest + 1 */
    addq.l #1,d2
/* QL:         add.l   d2,(sp)         we made sure msw was zero earlier */
    add.l d2,(sp)
/* QL:         cmp.w   #200,(sp)       how many good blocks? */
    cmp.w #200,(sp)
/* QL:         blt.s   M78_err_fmt2        fail if less than 200 */
    blt.s M78_err_fmt2
/* QL: * Check for number of good sectors = total number of sectors, as this implies */
/* QL: * the splice hasn't been seen! (Or by shear coincidence, was just after sector */
/* QL: * zero, which is just about the worst place it could be!) */
/* QL:         cmp.w   (sp),d2         check it */
    cmp.w (sp),d2
/* QL:         beq.s   M78_err_fmt2        fail format if no bad 'uns */
    beq.s M78_err_fmt2
/* QL: * Write M78_map sector */
/* QL:         moveq   #M78_st_free-256,d1 */
    moveq #(M78_st_free-256),d1
/* QL:         lea     M78_map(a5),a1      reset to start of M78_map */
    lea M78_map(a5),a1
/* QL:         cmp.b   (a1),d1         is sector zero good? */
    cmp.b (a1),d1
/* QL:         bne.s   M78_err_fmt2        no - that's a disaster */
    bne.s M78_err_fmt2
/* QL:         subq.b  #M78_st_free-M78_st_map,(a1) set sector zero to special file */
    subq.b #(M78_st_free-M78_st_map),(a1)
/* QL:         subq.b  #8,d2           leave a little bit of space before directory */
    subq.b #8,d2
/* QL:         add.w   d2,d2           address table in words */
    add.w d2,d2
/* QL: M78_chk_free */
M78_chk_free:
/* QL:         subq.w  #2,d2           down one */
    subq.w #2,d2
/* QL:         cmp.b   0(a1,d2.w),d1   vacant ? */
    cmp.b 0(a1,d2.w),d1
/* QL:         bne.s   M78_chk_free */
    bne.s M78_chk_free
/* QL:         clr.b   0(a1,d2.w)      set file 0 */
    clr.b 0(a1,d2.w)
/* QL:         move.w  d2,M78_bdl-2(a1)    and say where it is (sector 255 slot) */
    move.w d2,(M78_bdl-2)(a1)
/* QL:         lsl.w   #8-1,d2         tuck directory sector number into msb */
    lsl.w #(8-1),d2
/* QL: M78_putit */
M78_putit:
/* QL:         jsr     md_fsect(pc)    find the sector */
    jsr md_fsect(pc)
/* QL: M78_err_fmt2 */
M78_err_fmt2:
/* QL:         bra.s   M78_err_fmt3 */
    bra.s M78_err_fmt3
/* QL:         lea     M78_map(a5),a1      reset to start of buffer */
    lea M78_map(a5),a1
/* QL:         move.w  (a1),-(sp)      first word holds file/block (dir = 0/0) */
    move.w (a1),-(sp)
/* QL:         jsr     md_write(pc) */
    jsr md_write(pc)
/* QL:         addq.l  #2,sp */
    addq.l #2,sp
/* QL:         moveq   #0,d7           good return */
    moveq #0,d7
/* QL:         lsr.w   #8,d2           have we written the directory yet? */
    lsr.w #8,d2
/* QL:         beq.s   M78_desel           yes - all done */
    beq.s M78_desel
/* QL: * Write empty directory */
/* QL: M78_clr_dir */
M78_clr_dir:
/* QL:         clr.l   -(a1)           clear directory (we should have time for this) */
    clr.l -(a1)
/* QL:         addq.b  #256*4/M78_bdl,d7 */
    addq.b #((256*4)/M78_bdl),d7
/* QL:         bne.s   M78_clr_dir */
    bne.s M78_clr_dir
/* QL:         moveq   #64,d1 */
    moveq #64,d1
/* QL:         move.l  d1,(a1)         set length */
    move.l d1,(a1)
/* QL:         bra.s   M78_putit           write directory */
    bra.s M78_putit
/* QL: M78_err_fmt3 */
M78_err_fmt3:
/* QL:         moveq   #M78_err.ff,d7      format failed */
    moveq #M78_err.ff,d7
/* QL: M78_desel */
M78_desel:
/* QL:         jsr     md_desel(pc)    deselect drive */
    jsr md_desel(pc)
/* QL:         lea     -M78_hp_end(a5),a0  return space used */
    lea (-M78_hp_end)(a5),a0
/* QL:         jsr     mm_rechp(pc) */
    jsr mm_rechp(pc)
/* QL:         jsr     ss_rser(pc)     re-enable rs232 */
    jsr ss_rser(pc)
/* QL:         movem.w (sp)+,d1-d2     get good/total sector counts */
    movem.w (sp)+,d1-d2
/* QL:         move    (sp)+,sr        reinstate interrupts */
    move (sp)+,sr
/* QL:         move.l  d7,d0           set error return */
    move.l d7,d0
/* QL:         rts */
    rts 
/* QL:         end */
