/* ROM section bp_poke */
.balign 2,0
/* QL: bp_pokel */
bp_pokel:
/* QL:         addq.b  #2,d7           four bytes per value */
    addq.b #2,d7
/* QL: bp_pokew */
bp_pokew:
/* QL:         addq.b  #1,d7           two bytes per value */
    addq.b #1,d7
/* QL: bp_poke */
bp_poke:
/* QL:         pea     M41_pkent           entry to loop */
    pea M41_pkent(pc)
/* QL: * Set up address for peek/poke operations. No return on error. */
/* QL: * There are five variations, so far, on the address specification: */
/* QL: *    name       spec            type            value */
/* QL: *  absolute   address         absolute        address */
/* QL: *  sysvars    !;offset        absolute        sysvars+offset */
/* QL: *  sysvect    !vector;offset  absolute        sysvars(vector).l+offset */
/* QL: *  a6rel      \;offset        rel a6          offset */
/* QL: *  a6vect     \vector;offset  rel a6          0(a6,vector).l+offset */
/* QL: * So far, only the "!"'s are checked explicitly. */
/* QL: * d0 -  o- 0 */
/* QL: * d3 -  o- number of remaining parameters (ccr set to this) */
/* QL: * d5 -  o- all zero except ls 4 bits */
/* QL: * d6 -  o- lsb request type: <= 0 a6 relative or >0 for absolute */
/* QL: * a1 -  o- ri stack pointer to four before first additional longword arguments */
/* QL: * a3 -i  - base of args */
/* QL: * a5 -i o- top of args / absolute address or a6 relative offset */
/* QL: * d1-d2/d4/a0 destroyed */
/* QL: bp_pepo */
bp_pepo:
/* QL:         moveq   #2-1,d6         scan for up to two null args */
    moveq #(2-1),d6
/* QL:         move.b  1(a6,a3.l),d4   get first delimiter */
    move.b 1(a6,a3.l),d4
/* QL: M41_nulls */
M41_nulls:
/* QL:         moveq   #15,d5 */
    moveq #15,d5
/* QL:         and.b   1(a6,a3.l),d5   is argument null? */
    and.b 1(a6,a3.l),d5
/* QL:         bne.s   M41_notnull */
    bne.s M41_notnull
/* QL:         addq.l  #8,a3           move over one argument */
    addq.l #8,a3
/* QL:         dbra    d6,M41_nulls        only go for 0, 1 or 2 null params! */
    dbra d6,M41_nulls
/* QL: M41_notnull */
M41_notnull:
/* QL: * d6.l=1(no M41_nulls),0(one null),$ffff(two M41_nulls) */
/* QL:         jsr     ca_gtlin(pc)    get arguments (will be happy with a3>a5 even!) */
    jsr ca_gtlin(pc)
/* QL:         bne.s   M41_pop             no return if parameters no good */
    bne.s M41_pop
/* QL:         move.l  0(a6,a1.l),a5 */
    move.l 0(a6,a1.l),a5
/* QL:         sub.l   a0,a0 */
    sub.l a0,a0
/* QL:         lsl.b   #2,d4           check for 1st parameter null and delimiter '!' */
    lsl.b #2,d4
/* QL:         bne.s   M41_notsysv */
    bne.s M41_notsysv
/* QL:         moveq   #M41_mt.inf,d0 */
    moveq #M41_mt.inf,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         lsr.b   #7,d6 */
    lsr.b #7,d6
/* QL: M41_notsysv */
M41_notsysv:
/* QL:         tst.b   d6 */
    tst.b d6
/* QL:         bne.s   M41_goback */
    bne.s M41_goback
/* QL:         addq.l  #4,a1           skip vector */
    addq.l #4,a1
/* QL:         move.l  a1,M41_bv_rip(a6)   lose it */
    move.l a1,M41_bv_rip(a6)
/* QL:         subq.w  #1,d3           discount that one */
    subq.w #1,d3
/* QL:         move.l  0(a6,a1.l),d2   get offset */
    move.l 0(a6,a1.l),d2
/* QL:         exg     d2,a5           swap them over */
    exg d2,a5
/* QL:         bclr    d6,d2           we won't quibble with an odd vector address */
    bclr d6,d2
/* QL:         tst.b   d4 */
    tst.b d4
/* QL:         bne.s   M41_isbas */
    bne.s M41_isbas
/* QL:         add.l   0(a0,d2.l),a5   add sysvars vector to offset */
    add.l 0(a0,d2.l),a5
/* QL:         moveq   #1,d6 */
    moveq #1,d6
/* QL:         bra.s   M41_gota5 */
    bra.s M41_gota5
/* QL: M41_isbas */
M41_isbas:
/* QL:         add.l   0(a6,d2.l),a5   add basic vector to offset */
    add.l 0(a6,d2.l),a5
/* QL: M41_goback */
M41_goback:
/* QL:         add.l   a0,a5           if direct sysvars, add base to offset */
    add.l a0,a5
/* QL: M41_gota5 */
M41_gota5:
/* QL:         subq.w  #1,d3 */
    subq.w #1,d3
/* QL:         bge.s   M41_rts0 */
    bge.s M41_rts0
/* QL:         moveq   #M41_err.bp,d0 */
    moveq #M41_err.bp,d0
/* QL: M41_pop */
M41_pop:
/* QL:         addq.l  #4,sp */
    addq.l #4,sp
/* QL: M41_rts0 */
M41_rts0:
/* QL:         rts */
    rts 
/* QL: * Actual code for poke's */
/* QL: M41_pkarg */
M41_pkarg:
/* QL:         addq.l  #4-1,a1 */
.word 20617|((((4-1))&7)<<9)
/* QL:         sub.w   d7,a1 */
    sub.w d7,a1
/* QL:         move.w  d7,d1 */
    move.w d7,d1
/* QL: M41_pklp */
M41_pklp:
/* QL:         tst.b   d6 */
    tst.b d6
/* QL:         bgt.s   M41_abs */
    bgt.s M41_abs
/* QL:         move.b  4(a6,a1.l),0(a6,a5.l) poke rel a6 */
    move.b 4(a6,a1.l),0(a6,a5.l)
/* QL:         addq.l  #1,a5 */
    addq.l #1,a5
/* QL:         bra.s   M41_bdone */
    bra.s M41_bdone
/* QL: M41_abs */
M41_abs:
/* QL:         move.b  4(a6,a1.l),(a5)+ copy bytes one at a time */
    move.b 4(a6,a1.l),(a5)+
/* QL: M41_bdone */
M41_bdone:
/* QL:         addq.l  #1,a1 */
    addq.l #1,a1
/* QL:         dbra    d1,M41_pklp */
    dbra d1,M41_pklp
/* QL: M41_pkent */
M41_pkent:
/* QL:         dbra    d3,M41_pkarg        any values left to do? */
    dbra d3,M41_pkarg
/* QL:         rts */
    rts 
/* QL:         end */
