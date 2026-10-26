/* ROM section bf_keyrw */
.balign 2,0
/* QL: bf_keyrw */
bf_keyrw:
/* QL:         jsr     ca_gtin1(pc)    get integer params */
    jsr ca_gtin1(pc)
/* QL:         bne.s   M143_rts0            propagate any error */
    bne.s M143_rts0
/* QL:         move.w  #2,-(sp)        8 bit result */
    move.w #2,-(sp)
/* QL:         move.b  d1,(sp)         the parameter */
    move.b d1,(sp)
/* QL:         clr.l   -(sp)           4 bits long */
    clr.l -(sp)
/* QL:         move.w  #M143_kbdr_cmd<<8!1,-(sp) read kbd matrix command + 1 param */
    move.w #((M143_kbdr_cmd<<8)|1),-(sp)
/* QL: M143_frame   equ     1+1+4+1+1 */
.equ M143_frame,((((1+1)+4)+1)+1)
/* QL:         lea     M143_keyrw,a2 */
    lea M143_keyrw(pc),a2
/* QL:         moveq   #M143_mt.extop,d0 */
    moveq #M143_mt.extop,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         addq.l  #M143_frame,sp       release local stack space */
    addq.l #M143_frame,sp
/* QL:         move.w  d1,0(a6,a1.l)   put result on arithmetic stack */
    move.w d1,0(a6,a1.l)
/* QL:         moveq   #3,d4           result type is integer */
    moveq #3,d4
/* QL: M143_rts0 */
M143_rts0:
/* QL:         rts */
    rts 
/* QL: M143_keyrw */
M143_keyrw:
/* QL:         move.l  d0,a2           system variables base address */
    move.l d0,a2
/* QL:         move.l  M143_sv_keyq(a2),a2  get current keyboard queue */
    move.l M143_sv_keyq(a2),a2
/* QL:         move.l  M143_q_nxtout(a2),M143_q_nextin(a2) remove all characters from queue */
    move.l M143_q_nxtout(a2),M143_q_nextin(a2)
/* QL: * Entry point to execute ipcom on user stack - called via M143_mt.extop */
/* QL: bf_ipcom */
bf_ipcom:
/* QL:         moveq   #M143_mt.ipcom,d0 */
    moveq #M143_mt.ipcom,d0
/* QL:         move.l  usp,a3          command on user stack */
    move.l usp,a3
/* QL:         trap    #1 */
    trap #1
/* QL:         rte */
    rte 
/* QL:         end */
