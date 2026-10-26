/* ROM section pa_mist */
.balign 2,0
/* QL: pa_mist */
pa_mist:
/* QL:         move.l  M131_bv_tkbas(a6),M131_bv_tkp(a6) reset token list */
    move.l M131_bv_tkbas(a6),M131_bv_tkp(a6)
/* QL:         move.l  M131_bv_bfbas(a6),a0 */
    move.l M131_bv_bfbas(a6),a0
/* QL:         jsr     pa_cdlno(pc)    tokenise the line number */
    jsr pa_cdlno(pc)
/* QL:         nop                     return + 0 - ignore if no line number */
    nop 
/* QL:         moveq   #M131_b.key,d4       return + 2 */
    moveq #M131_b.key,d4
/* QL:         moveq   #M131_b.mist,d5 */
    moveq #M131_b.mist,d5
/* QL:         jsr     pa_tok1(pc) */
    jsr pa_tok1(pc)
/* QL:         jsr     pa_text(pc) */
    jsr pa_text(pc)
/* QL:         nop                     return + 0 - ignore if no sensible text */
    nop 
/* QL:         moveq   #M131_b.sym,d4       return + 2 */
    moveq #M131_b.sym,d4
/* QL:         moveq   #M131_b.eol,d5 */
    moveq #M131_b.eol,d5
/* QL:         jsr     pa_tok1(pc) */
    jsr pa_tok1(pc)
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         rts */
    rts 
/* QL:         vect4000 pa_mist */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ pa$mist,(pa_mist-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
