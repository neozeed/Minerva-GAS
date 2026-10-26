/* ROM section gw_scale */
.balign 2,0
/* QL: gw_scale */
gw_scale:
/* QL:         assert  M178_sd_yorg,M178_sd_xorg-6,M178_sd_scal-12 */
/* original assertion: M178_sd_yorg,M178_sd_xorg-6,M178_sd_scal-12 */
/* QL:         lea     M178_sd_yorg(a0),a2 */
    lea M178_sd_yorg(a0),a2
/* QL:         moveq   #3*6,d0 */
    moveq #(3*6),d0
/* QL: M178_loop */
M178_loop:
/* QL:         move.b  (a1)+,(a2)+ */
    move.b (a1)+,(a2)+
/* QL:         subq.b  #1,d0 */
    subq.b #1,d0
/* QL:         bne.s   M178_loop */
    bne.s M178_loop
/* QL:         rts */
    rts 
/* QL:         end */
