/* ROM section bp_misc */
.balign 2,0
/* QL: * report{#chan}{,errno} */
/* QL: M39_repit */
M39_repit:
/* QL:         bne.s   M39_err_bp */
    bne.s M39_err_bp
/* QL:         move.l  d1,d0 */
    move.l d1,d0
/* QL:         jsr     ut_err(pc) */
    jsr ut_err(pc)
/* QL:         bra.s   M39_okrts */
    bra.s M39_okrts
/* QL: bp_repot */
bp_repot:
/* QL:         moveq   #0,d1           if no channel, then use console */
    moveq #0,d1
/* QL:         jsr     bp_chand(pc) */
    jsr bp_chand(pc)
/* QL:         bsr.s   M39_gtlin */
    bsr.s M39_gtlin
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bcc.s   M39_repit */
    bcc.s M39_repit
/* QL:         assert  M39_bv_error,M39_bv_erlin-4 */
/* original assertion: M39_bv_error,M39_bv_erlin-4 */
/* QL:         movem.l M39_bv_error(a6),d0/d3 get error number and line */
    movem.l M39_bv_error(a6),d0/d3
/* QL:         move.b  M39_bv_erstm(a6),d3 put in statement */
    move.b M39_bv_erstm(a6),d3
/* QL:         jsr     ib_errep(pc)    write out the error */
    jsr ib_errep(pc)
/* QL: M39_okrts */
M39_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL: * MODE p1{,p2} sets the display mode */
/* QL: bp_mode */
bp_mode:
/* QL:         jsr     ca_gtint(pc) */
    jsr ca_gtint(pc)
/* QL:         bne.s   M39_rts0 */
    bne.s M39_rts0
/* QL:         movem.w 0(a6,a1.l),d1-d2 */
    movem.w 0(a6,a1.l),d1-d2
/* QL:         subq.w  #2,d3 */
    subq.w #2,d3
/* QL:         beq.s   M39_set_it */
    beq.s M39_set_it
/* QL:         addq.w  #1,d3 */
    addq.w #1,d3
/* QL:         bne.s   M39_err_bp */
    bne.s M39_err_bp
/* QL:         moveq   #-1,d2          no change to monitor/tv byte */
    moveq #(-1),d2
/* QL:         and.w   #256+8,d1       only check bits corresponding to 8 or 256 */
    and.w #(256+8),d1
/* QL:         beq.s   M39_set_it          512,4,etc - byte is zero */
    beq.s M39_set_it
/* QL:         moveq   #8,d1           256,8,264 - byte is 08h */
    moveq #8,d1
/* QL: M39_set_it */
M39_set_it:
/* QL:         moveq   #M39_mt.dmode,d0    set mode */
    moveq #M39_mt.dmode,d0
/* QL:         bra.s   M39_trap1 */
    bra.s M39_trap1
/* QL: * NET number sets the network station number (1..127) */
/* QL: bp_net */
bp_net:
/* QL:         jsr     ca_gtin1(pc)    one integer */
    jsr ca_gtin1(pc)
/* QL:         bne.s   M39_rts0 */
    bne.s M39_rts0
/* QL:         move.b  d1,d3           get argument */
    move.b d1,d3
/* QL:         ble.s   M39_err_bp */
    ble.s M39_err_bp
/* QL:         assert  0,M39_mt.inf */
/* original assertion: 0,M39_mt.inf */
/* QL:         trap    #1 */
    trap #1
/* QL:         move.b  d3,M39_sv_netnr(a0) */
    move.b d3,M39_sv_netnr(a0)
/* QL:         rts */
    rts 
/* QL: * CALL address(,long)...: longwords put into d1-d7/a0-a5, then "jsr address" */
/* QL: bp_call */
bp_call:
/* QL: * We could force there to be enough zeroes on the stack to complete the call */
/* QL: * parameters with all zeroes. There have to be at most 13 longwords of zero to */
/* QL: * cope with the worst case. We would have to push the whole lot, to make it */
/* QL: * easier in the case that the caller might even give to many parameters. */
/* QL: * However, as CALL gets replaced so often, maybe it's not worth the trouble. */
/* QL: * There is another bonus - call code may be happier with the extra stack space. */
/* QL: * Minimum cost is 22 bytes, and some time, plus switching to sup mode. */
/* QL: * Given the latter two considerations, maybe we'll just forget it! */
/* QL: *        jsr     bv_chri(pc)     this ensure 60 bytes, more than we need */
/* QL: *        moveq   #13*4,d1 */
/* QL: *        sub.l   d1,M39_bv_rip(a6)   push extra longwords */
/* QL: *        move.l  M39_bv_rip(a6),a0 */
/* QL: *        jsr     mm_clrr(pc)     set the extras to zero */
/* QL:         bsr.s   M39_gtlin           get long integers */
    bsr.s M39_gtlin
/* QL:         asl.l   #2,d3           remove the parameters from stack */
    asl.l #2,d3
/* QL:         ble.s   M39_err_bp          if none (or too many!) give up */
    ble.s M39_err_bp
/* QL: *        moveq   #13*4,d0        lose our extra longwords */
/* QL: *        add.l   d0,d3 */
/* QL:         add.l   d3,M39_bv_rip(a6) */
    add.l d3,M39_bv_rip(a6)
/* QL:         move.l  d1,-(sp)        set up address */
    move.l d1,-(sp)
/* QL:         movem.l 4(a6,a1.l),d1-d7/a0-a5 set up registers */
    movem.l 4(a6,a1.l),d1-d7/a0-a5
/* QL: M39_err_bp */
M39_err_bp:
/* QL:         moveq   #M39_err.bp,d0 */
    moveq #M39_err.bp,d0
/* QL: M39_rts0 */
M39_rts0:
/* QL:         rts */
    rts 
/* QL: M39_gtlin */
M39_gtlin:
/* QL:         jsr     ca_gtlin(pc) */
    jsr ca_gtlin(pc)
/* QL:         movem.l 0(a6,a1.l),d1-d2 enough for some */
    movem.l 0(a6,a1.l),d1-d2
/* QL:         beq.s   M39_rts0 */
    beq.s M39_rts0
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: * RANDOMISE{delimiter}{value}: initialises the random number generator. */
/* QL: * Two flavours are now supported. The old one is used if the lsb of M39_bv_rand is */
/* QL: * set to one. The new (better!) one uses an lsb of zero, and is invoked by a */
/* QL: * null first argument. */
/* QL: bp_rande */
bp_rande:
/* QL:         moveq   #7,d5 */
    moveq #7,d5
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         beq.s   M39_rndnorm         no parameters, don't set new scheme */
    beq.s M39_rndnorm
/* QL:         and.b   1(a6,a3.l),d5   otherwise null 1st parameter is new scheme */
    and.b 1(a6,a3.l),d5
/* QL:         bne.s   M39_rndnorm */
    bne.s M39_rndnorm
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL: M39_rndnorm */
M39_rndnorm:
/* QL:         bsr.s   M39_gtlin           get a seed */
    bsr.s M39_gtlin
/* QL:         subq.w  #1,d3           was there one parameter? */
    subq.w #1,d3
/* QL:         beq.s   M39_get_rand        just one, use it as seed */
    beq.s M39_get_rand
/* QL:         bcc.s   M39_err_bp          no parameters uses clock, nowt else allowed */
    bcc.s M39_err_bp
/* QL:         moveq   #M39_mt.rclck,d0    get time */
    moveq #M39_mt.rclck,d0
/* QL:         trap    #1 */
    trap #1
/* QL: M39_get_rand */
M39_get_rand:
/* QL:         tst.b   d5 */
    tst.b d5
/* QL:         bne.s   M39_rndgrot */
    bne.s M39_rndgrot
/* QL:         add.l   d1,d1           new scheme keeps 31 given bits, plus clear lsb */
    add.l d1,d1
/* QL: M39_rndput */
M39_rndput:
/* QL:         move.l  d1,M39_bv_rand(a6)  put seed and flag into location */
    move.l d1,M39_bv_rand(a6)
/* QL:         rts */
    rts 
/* QL: M39_rndgrot */
M39_rndgrot:
/* QL:         move.l  d1,d2           make both ends significant */
    move.l d1,d2
/* QL:         swap    d1              this wastes a lot of randomisation bits */
    swap d1
/* QL:         add.l   d2,d1           tacky... but can't change it now! */
    add.l d2,d1
/* QL:         bset    d0,d1 */
    bset d0,d1
/* QL:         bra.s   M39_rndput */
    bra.s M39_rndput
/* QL: * BAUD rate: sets the baud rate for the serial ports */
/* QL: bp_baud */
bp_baud:
/* QL:         jsr     ca_gtin1(pc)    get the baud rate to d1 */
    jsr ca_gtin1(pc)
/* QL:         bne.s   M39_rts0 */
    bne.s M39_rts0
/* QL:         moveq   #M39_mt.baud,d0 */
    moveq #M39_mt.baud,d0
/* QL: M39_trap1 */
M39_trap1:
/* QL:         trap    #1              go try to set it */
    trap #1
/* QL:         rts */
    rts 
/* QL: * specify translation modes */
/* QL: * this basic command has the format : */
/* QL: *       tra  arg1{,arg2}        or      tra  ,arg2 */
/* QL: * where arg1 controls the serial i/o translation tables: */
/* QL: *       <= -2   turn on translation */
/* QL: *       = -1    no change */
/* QL: *       = 0     turn off translation */
/* QL: *       = 1     set default i/o tables and turn it on */
/* QL: *       = other set user defined i/o tables and turn it on */
/* QL: * and arg2 controls the message table: */
/* QL: *       <= 0    no change */
/* QL: *       = 1     set default system messages */
/* QL: *       = other set user defined messages */
/* QL: * both user tables must be specified by an even address, at which the first */
/* QL: * word is $4afb. */
/* QL: * the translation tables then contain two words, giving the offset to the */
/* QL: * input and output translation tables. these may be given as zero to turn */
/* QL: * each off, or should point at a 256 byte direct translate list. only 128 */
/* QL: * bytes are needed if only 7-bit data is being used. */
/* QL: * the message table continues with a count of the number of messages in the */
/* QL: * table and then their offsets. each message must be on an even address, */
/* QL: * prefixed by its character count word. */
/* QL: bp_tra */
bp_tra:
/* QL:         move.l  a5,d5 */
    move.l a5,d5
/* QL:         sub.l   a3,d5 */
    sub.l a3,d5
/* QL:         ble.s   M39_err_bp          no parameters, we don't like */
    ble.s M39_err_bp
/* QL:         asr.l   #3,d5 */
    asr.l #3,d5
/* QL:         subq.l  #2,d5 */
    subq.l #2,d5
/* QL:         bgt.s   M39_err_bp          1 (d5=-1) or 2 (d5=0) parameters we like */
    bgt.s M39_err_bp
/* QL:         moveq   #15,d1 */
    moveq #15,d1
/* QL:         and.b   1(a6,a3.l),d1 */
    and.b 1(a6,a3.l),d1
/* QL:         bne.s   M39_getem */
    bne.s M39_getem
/* QL:         addq.l  #8,a3           skip omitted 1st param */
    addq.l #8,a3
/* QL: M39_getem */
M39_getem:
/* QL:         bsr.s   M39_gtlin           get arguments */
    bsr.s M39_gtlin
/* QL:         moveq   #M39_mt.cntry,d0    set up trap code */
    moveq #M39_mt.cntry,d0
/* QL:         subq.w  #2,d3           how many ? */
    subq.w #2,d3
/* QL:         beq.s   M39_trap1           two - all must be ready */
    beq.s M39_trap1
/* QL:         moveq   #-1,d2          maybe just 1st param */
    moveq #(-1),d2
/* QL:         cmp.w   d3,d5           did we have 1st param null? */
    cmp.w d3,d5
/* QL:         beq.s   M39_trap1           no - we're there */
    beq.s M39_trap1
/* QL:         exg     d1,d2           swap 'em over */
    exg d1,d2
/* QL:         bra.s   M39_trap1           go to it */
    bra.s M39_trap1
/* QL:         end */
