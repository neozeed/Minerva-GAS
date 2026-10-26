/* ROM section md_slave */
.balign 2,0
/* QL: * d0 -  o- M81_err.nc, as it's typical for callers to be about to wait */
/* QL: * a2 -ip - pointer to physical definition */
/* QL: * a3 -  o- pointer to microdrive control register */
/* QL: * d1-d2 destroyed */
/* QL: md_slave */
md_slave:
/* QL:         sf      M81_md_estat(a2)    clear error status */
    sf M81_md_estat(a2)
/* QL: md_slavn */
md_slavn:
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         move.b  M81_md_drivn(a2),d1 get drive number */
    move.b M81_md_drivn(a2),d1
/* QL:         lea     M81_sv_mdrun(a6),a3 get pointer to status */
    lea M81_sv_mdrun(a6),a3
/* QL:         st      M81_sv_mdsta-M81_sv_mdrun-1(a3,d1.w) set status */
    st ((M81_sv_mdsta-M81_sv_mdrun)-1)(a3,d1.w)
/* QL:         tst.b   (a3)            is a drive running? */
    tst.b (a3)
/* QL:         bne.s   M81_exit */
    bne.s M81_exit
/* QL:         moveq   #M81_pc.mdvmd,d0    select microdrive */
    moveq #M81_pc.mdvmd,d0
/* QL:         jsr     ss_wser(pc)     and wait for serial port to finish */
    jsr ss_wser(pc)
/* QL:         move.b  d1,(a3)         start up this drive */
    move.b d1,(a3)
/* QL:         move.b  #-6,M81_sv_mdcnt(a6) set run-up */
    move.b #((-6)&255),M81_sv_mdcnt(a6)
/* QL:         lea     M81_pc_mctrl,a3     set up a3 */
    lea M81_pc_mctrl,a3
/* QL:         jsr     md_selec(pc)    select drive */
    jsr md_selec(pc)
/* QL:         or.b    #M81_pc.maskg,M81_sv_pcint(a6) enable gap interrupts */
    or.b #(M81_pc.maskg&255),M81_sv_pcint(a6)
/* QL:         move.b  M81_sv_pcint(a6),M81_pc_intr-M81_pc_mctrl(a3) (not strictly necessary) */
    move.b M81_sv_pcint(a6),(M81_pc_intr-M81_pc_mctrl)(a3)
/* QL: M81_exit */
M81_exit:
/* QL:         moveq   #M81_err.nc,d0      implication is we're going to wait for sommat */
    moveq #M81_err.nc,d0
/* QL:         rts */
    rts 
/* QL:         end */
