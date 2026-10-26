/* ROM section mt_rclck */
.balign 2,0
/* QL: * d0 -i o- trap value of d0 / 0 */
/* QL: * d1 -i o- time to set or increment / current time */
/* QL: * d2/a0 destroyed */
/* QL: mt_rclck */
mt_rclck:
/* QL: mt_sclck */
mt_sclck:
/* QL: mt_aclck */
mt_aclck:
/* QL:         bsr.s   M34_clock           read the M34_clock */
    bsr.s M34_clock
/* QL:         assert  $13,M34_mt.rclck,M34_mt.sclck-1,M34_mt.aclck-2 */
/* original assertion: $13,M34_mt.rclck,M34_mt.sclck-1,M34_mt.aclck-2 */
/* QL:         asl.b   #6,d0           type of adjustment required? */
    asl.b #6,d0
/* QL:         bpl.s   M34_adjset          M34_adjust or set */
    bpl.s M34_adjset
/* QL:         move.l  d2,d1           read */
    move.l d2,d1
/* QL: M34_exit */
M34_exit:
/* QL:         jmp     ss_noer(pc) */
    jmp ss_noer(pc)
/* QL: M34_adjset */
M34_adjset:
/* QL:         beq.s   M34_set_ck          set */
    beq.s M34_set_ck
/* QL: M34_adjust */
M34_adjust:
/* QL:         cmp.l   (a0),d2         wait for second to tick over */
    cmp.l (a0),d2
/* QL:         beq.s   M34_adjust */
    beq.s M34_adjust
/* QL:         bsr.s   M34_ck_read         read it again until stable */
    bsr.s M34_ck_read
/* QL:         add.l   d2,d1 */
    add.l d2,d1
/* QL: M34_set_ck */
M34_set_ck:
/* QL:         sf      (a0)+           clear M34_clock */
    sf (a0)+
/* QL:         moveq   #%11110111-256,d0 start incrementing at ms byte */
    moveq #(0b11110111-256),d0
/* QL: M34_set_byte */
M34_set_byte:
/* QL:         rol.b   #1,d0 */
    rol.b #1,d0
/* QL:         rol.l   #8,d1 */
    rol.l #8,d1
/* QL:         moveq   #0,d2           can't dbra on byte - have to use word */
    moveq #0,d2
/* QL:         move.b  d1,d2           take ls byte of set value */
    move.b d1,d2
/* QL:         bra.s   M34_end_inc */
    bra.s M34_end_inc
/* QL: M34_inc_byte */
M34_inc_byte:
/* QL:         move.b  d0,(a0)         increment specified byte */
    move.b d0,(a0)
/* QL: M34_end_inc */
M34_end_inc:
/* QL:         dbra    d2,M34_inc_byte     count increments */
    dbra d2,M34_inc_byte
/* QL:         ror.b   #2,d0           next byte flag */
    ror.b #2,d0
/* QL:         bmi.s   M34_set_byte        if not just done %11111101, carry on */
    bmi.s M34_set_byte
/* QL:         bra.s   M34_exit */
    bra.s M34_exit
/* QL: * d2 -  o- stable reading fom M34_clock */
/* QL: * a0 destroyed */
/* QL: M34_clock */
M34_clock:
/* QL:         lea     M34_pc_clock,a0     fetch M34_clock address */
    lea M34_pc_clock,a0
/* QL: M34_ck_read */
M34_ck_read:
/* QL:         move.l  (a0),d2         fetch time */
    move.l (a0),d2
/* QL:         cmp.l   (a0),d2         has it changed? */
    cmp.l (a0),d2
/* QL:         bne.s   M34_ck_read         takes 12 cycles = 1.6 u seconds */
    bne.s M34_ck_read
/* QL:         rts */
    rts 
/* QL:         end */
