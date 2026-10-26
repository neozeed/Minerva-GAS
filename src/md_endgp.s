/* ROM section md_endgp */
.balign 2,0
/* QL: * a3 -ip - address of microdrive control register */
/* QL: * d0-d1 destroyed */
/* QL: * return+0 on error, return+2 ok */
/* QL: md_endgp */
md_endgp:
/* QL:         moveq   #0,d1           wait for up to 64k loops of 7.73us (.5secs) */
    moveq #0,d1
/* QL: M77_wait_gap ; 58 cycles in loop */
M77_wait_gap:
/* QL:         subq.w  #1,d1         8 decrement wait counter */
    subq.w #1,d1
/* QL:         beq.s   M77_exit      18/12 ... timeout? */
    beq.s M77_exit
/* QL:         btst    #M77_pc..gap,(a3) 20 is there a gap yet? */
    btst #M77_pc..gap,(a3)
/* QL:         beq.s   M77_wait_gap  18/12 */
    beq.s M77_wait_gap
/* QL: * Gap found - now wait for it to go away (for a reasonable time). */
/* QL:         moveq   #0,d1           wait for up to 64k cycles of 8.8us (.6secs) */
    moveq #0,d1
/* QL: M77_wait_sig ; 66 cycles while signal is low */
M77_wait_sig:
/* QL:         subq.w  #1,d1         8 decrement wait counter */
    subq.w #1,d1
/* QL:         beq.s   M77_exit      18/12 ... timeout? */
    beq.s M77_exit
/* QL:         moveq   #24-1,d0      8 need signal for 24 loops of 6.67us (160us) */
    moveq #(24-1),d0
/* QL: M77_chek_sig ; 50 cycles per loop while signal is low */
M77_chek_sig:
/* QL:         btst    #M77_pc..gap,(a3) 20 is there a signal? */
    btst #M77_pc..gap,(a3)
/* QL:         bne.s   M77_wait_sig   18/12 ... if not reset debounce counter */
    bne.s M77_wait_sig
/* QL:         dbra    d0,M77_chek_sig 18/26 */
    dbra d0,M77_chek_sig
/* QL: * If the above accepts the gap signal is over, the btst in the loop will have */
/* QL: * been seen zero a total of 24 times, thus an end of gap will be accepted if it */
/* QL: * has a duration of just 23*50 cycles. i.e. 153.3us will do. */
/* QL:         moveq   #M77_pc.read,d1   8 set up pll reset byte */
    moveq #M77_pc.read,d1
/* QL:         move.b  d1,(a3)      12 ... reset pll */
    move.b d1,(a3)
/* QL:         delay   25              wait >2 bit times for zero to clock through */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL:  ifnum [us] < 311 goto qdbra */
/* QL: qdbra maclab 21 to 309 step 2 us */
/* QL:  moveq #([us]*15-50)/36,d0 six byte sequence */
    moveq #(((25*15)-50)/36),d0
/* QL:  dbra d0,* */
    dbra d0,.
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         move.b  d1,(a3)      12 ... reset controller electronics */
    move.b d1,(a3)
/* QL:         addq.l  #2,(sp)      40 return ok */
    addq.l #2,(sp)
/* QL: M77_exit */
M77_exit:
/* QL:         rts                  32 */
    rts 
/* QL: * On return, the total elapsed time from the end of the gap signal should be */
/* QL: * close to 197us. */
/* QL:         end */
