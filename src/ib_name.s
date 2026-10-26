/* ROM section ib_name */
.balign 2,0
/* QL: * a4 -i o- pf pointer */
/* QL: ib_name */
ib_name:
/* QL:         jsr     ib_nxnon(pc)    get a non-space */
    jsr ib_nxnon(pc)
/* QL:         cmp.b   #M158_b.nam,d0 */
    cmp.b #(M158_b.nam&255),d0
/* QL:         bne.s   M158_err_ni          not a name, wrong! */
    bne.s M158_err_ni
/* QL: ib_name1 */
ib_name1:
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL:         move.w  2(a6,a4.l),d4   get name number */
    move.w 2(a6,a4.l),d4
/* QL:         jsr     ib_s4non(pc)    get next non-space ready for checking */
    jsr ib_s4non(pc)
/* QL:         jsr     ib_fname(pc)    don't mess up d4 'cos later bits need it */
    jsr ib_fname(pc)
/* QL:         move.b  0(a6,a2.l),d0   read name type */
    move.b 0(a6,a2.l),d0
/* QL:         subq.b  #M158_t.arr,d0       is name an array? */
    subq.b #M158_t.arr,d0
/* QL:         beq.l   ib_array        yes, go do it */
    beq.w ib_array
/* QL:         subq.b  #M158_t.bpr-M158_t.arr,d0 is name a basic procedure? */
.word 20736|((((M158_t.bpr-M158_t.arr))&7)<<9)
/* QL:         beq.l   ib_bproc        yes, go do it */
    beq.w ib_bproc
/* QL:         subq.b  #M158_t.mcp-M158_t.bpr,d0 is name an m/c procedure then? */
.word 20736|((((M158_t.mcp-M158_t.bpr))&7)<<9)
/* QL:         bne.l   ib_let          no, assume it's a variable then, let does rest */
    bne.w ib_let
/* QL:         jmp     ib_proc(pc)     go do the m/c proc */
    jmp ib_proc(pc)
/* QL: M158_err_ni */
M158_err_ni:
/* QL:         moveq   #M158_err.ni,d0 */
    moveq #M158_err.ni,d0
/* QL:         rts */
    rts 
/* QL:         end */
