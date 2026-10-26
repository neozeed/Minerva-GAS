/* ROM section mt_ipcom */
.balign 2,0
/* QL: * Transmit a command block containing: */
/* QL: *       a command (byte, 4 lsb are the command) */
/* QL: *       no of bytes of parameters (byte, 0..16) */
/* QL: *       amount of each byte to send (4 bytes) encoded: */
/* QL: *               x1=0 bits       00=4 bits       10=8 bits */
/* QL: *               1st parameter amount is bits 1-0 of the 4th of these bytes. */
/* QL: *       parameters (bytes) */
/* QL: *       amount of result to return, encoded as above in bits 1-0 */
/* QL: * ipcom will employ a linked list of user routines, based at M32_sx_ipcom, which */
/* QL: * is initially zero. ut_link and ut_unlk should be used in supervisor mode to */
/* QL: * attach and remove user code linkage blocks. */
/* QL: * The user routine linkage is in the typical form of two longwords. */
/* QL: * The first longword is the link to the next user routine (M32_zero if none). */
/* QL: * The second longword is the user code entry address. */
/* QL: * The address of the first of these is supplied to the user's code in a0. */
/* QL: * It is also given d0.l=command, d5.l=param lengths, d7.l=param count, */
/* QL: * a6=sysvars and a3 pointing to the parameter bytes and return code byte. */
/* QL: * Interrupts will have been already inhibitted. */
/* QL: * If it does not process the command, it may only destroy a1/d6 and should */
/* QL: * return normally. */
/* QL: * If it processes the command completely, it may destroy d0/d5-d7/a0-a1/a3 and */
/* QL: * must return two on from the normal return, e.g. addq.l #2,(sp). */
/* QL: * Any expected return value must have been put in d1. */
/* QL: * This game is all mainly to allow keyrow calls to be intercepted. */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- return parameter from call (undefined if none requested) */
/* QL: * a3 -i p- pointer to command block. (can now be odd. lwr) */
/* QL: reglist reg     d5-d6/a0-a1/a3 */
/* QL: mt_ipcom */
mt_ipcom:
/* QL:         movem.l reglist,-(sp) */
    movem.l d5-d6/a0-a1/a3,-(sp)
/* QL:         move    sr,-(sp)        save status register */
    move sr,-(sp)
/* QL:         or.w    #$700,sr        no interrupts */
    or.w #0x700,sr
/* QL:         moveq   #15,d0 */
    moveq #15,d0
/* QL:         and.b   (a3)+,d0        get the command (losing msbs, to be clean) */
    and.b (a3)+,d0
/* QL:         cmp.b   #M32_inso_cmd,d0 */
    cmp.b #(M32_inso_cmd&255),d0
/* QL:         bne.s   M32_soundok */
    bne.s M32_soundok
/* QL:         st      M32_sv_sound(a6)    ensure that M32_sv_sound is set when a beep starts */
    st M32_sv_sound(a6)
/* QL: M32_soundok */
M32_soundok:
/* QL:         move.b  (a3)+,d7        get the number of parameters */
    move.b (a3)+,d7
/* QL:         moveq   #4,d6 */
    moveq #4,d6
/* QL: M32_params */
M32_params:
/* QL:         lsl.l   #8,d5 */
    lsl.l #8,d5
/* QL:         move.b  (a3)+,d5        get param lengths, not requiring even address */
    move.b (a3)+,d5
/* QL:         subq.b  #1,d6 */
    subq.b #1,d6
/* QL:         bne.s   M32_params */
    bne.s M32_params
/* QL:         move.l  M32_sv_chtop(a6),a0 get system extension address */
    move.l M32_sv_chtop(a6),a0
/* QL:         lea     M32_sx_ipcom(a0),a0 get front end link address */
    lea M32_sx_ipcom(a0),a0
/* QL: M32_lpfront */
M32_lpfront:
/* QL:         move.l  (a0),d6 */
    move.l (a0),d6
/* QL:         beq.s   M32_fronted         M32_zero means there aren't any more */
    beq.s M32_fronted
/* QL:         move.l  d6,a0 */
    move.l d6,a0
/* QL:         move.l  4(a0),a1 */
    move.l 4(a0),a1
/* QL:         jsr     (a1)            call user's front end routine */
    jsr (a1)
/* QL:         bra.s   M32_lpfront */
    bra.s M32_lpfront
/* QL:         bra.s   M32_exit            user return if they processed the command */
    bra.s M32_exit
/* QL: M32_fronted */
M32_fronted:
/* QL:         jsr     ip_setad(pc)    set up IPC addresses */
    jsr ip_setad(pc)
/* QL:         moveq   #5*4,d1         space for six nibbles, but we baulk at five */
    moveq #(5*4),d1
/* QL: * Enter loop pushing the command nibble */
/* QL: M32_four */
M32_four:
/* QL:         lsl.b   #4,d0           lose top nibble and set 4 lsbs M32_zero */
    lsl.b #4,d0
/* QL:         lsl.l   #4,d0           move up single nibble leaving lsb M32_zero */
    lsl.l #4,d0
/* QL:         subq.b  #4,d1           are we full up yet? */
    subq.b #4,d1
/* QL: M32_check */
M32_check:
/* QL:         bgt.s   M32_zero            still space for a byte, so carry on */
    bgt.s M32_zero
/* QL:         bsr.s   M32_flush           write what we have so far */
    bsr.s M32_flush
/* QL:         moveq   #5*4,d1         set counter for more */
    moveq #(5*4),d1
/* QL: M32_zero */
M32_zero:
/* QL:         move.b  (a3)+,d0        always get next byte */
    move.b (a3)+,d0
/* QL:         subq.b  #1,d7 */
    subq.b #1,d7
/* QL:         bge.s   M32_send_par */
    bge.s M32_send_par
/* QL:         move.b  d0,d7 */
    move.b d0,d7
/* QL:         st      d0              0..2 nibbles to be read back */
    st d0
/* QL:         rol.b   #7,d7           last byte is the return requirements */
    rol.b #7,d7
/* QL:         bmi.s   M32_nonein          get nothing */
    bmi.s M32_nonein
/* QL:         bcc.s   M32_nibin */
    bcc.s M32_nibin
/* QL:         lsl.l   #4,d0 */
    lsl.l #4,d0
/* QL:         subq.b  #4,d1 */
    subq.b #4,d1
/* QL: M32_nibin */
M32_nibin:
/* QL:         lsl.l   #4,d0 */
    lsl.l #4,d0
/* QL:         subq.b  #4,d1 */
    subq.b #4,d1
/* QL: M32_nonein */
M32_nonein:
/* QL:         bsr.s   M32_flush */
    bsr.s M32_flush
/* QL:         lsr.l   #7,d1           fetch down final read byte */
    lsr.l #7,d1
/* QL:         moveq   #15,d0          ready for nibble */
    moveq #15,d0
/* QL:         asr.b   #1,d7 */
    asr.b #1,d7
/* QL:         bmi.s   M32_clrint          there was no return, leave d1 as junk! */
    bmi.s M32_clrint
/* QL:         bcc.s   M32_andit */
    bcc.s M32_andit
/* QL:         st      d0 */
    st d0
/* QL: M32_andit */
M32_andit:
/* QL:         and.l   d0,d1 */
    and.l d0,d1
/* QL: * We will clear the interrupt we've caused merely by talking to the IPC */
/* QL: M32_clrint */
M32_clrint:
/* QL:         moveq   #M32_pc.intri,d7    clear IPC interrupt */
    moveq #M32_pc.intri,d7
/* QL:         or.b    M32_sv_pcint(a6),d7 */
    or.b M32_sv_pcint(a6),d7
/* QL:         move.b  d7,M32_pc_intr-M32_pc_ipcrd(a0) a0 set by setad */
    move.b d7,(M32_pc_intr-M32_pc_ipcrd)(a0)
/* QL: M32_exit */
M32_exit:
/* QL:         move    (sp)+,sr        reinstate interrupts */
    move (sp)+,sr
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d5-d6/a0-a1/a3
/* QL:         jmp     ss_noer(pc) */
    jmp ss_noer(pc)
/* QL: M32_send_par */
M32_send_par:
/* QL:         ror.l   #2,d5           rotate approriate bit pair to 2 msbs */
    ror.l #2,d5
/* QL:         btst    #30,d5          M32_check for x1 */
    btst #30,d5
/* QL:         bne.s   M32_zero            if bit 0 was set, send nothing */
    bne.s M32_zero
/* QL:         bpl.s   M32_four            if bit 1 was clear, just send nibble */
    bpl.s M32_four
/* QL:         lsl.l   #8,d0           put up whole byte and make lsb M32_zero */
    lsl.l #8,d0
/* QL:         subq.b  #8,d1           count two nibbles */
    subq.b #8,d1
/* QL:         bra.s   M32_check           M32_check how we're doing */
    bra.s M32_check
/* QL: M32_flush */
M32_flush:
/* QL:         addq.b  #4,d1           form number of bits not in use */
    addq.b #4,d1
/* QL:         lsl.l   d1,d0           shuffle active nibbles up to top */
    lsl.l d1,d0
/* QL:         or.l    d0,d1           put send nibbles into msb's */
    or.l d0,d1
/* QL:         lsr.b   #1,d1           make it into unused nibbles * 2 */
    lsr.b #1,d1
/* QL:         sub.b   #6*2,d1         calculate negated active nibble count * 2 */
    sub.b #((6*2)&255),d1
/* QL:         bne.l   ip_rdwr         if non-M32_zero (always?) go do it */
    bne.w ip_rdwr
/* QL:         rts */
    rts 
/* QL:         end */
