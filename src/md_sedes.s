/* ROM section md_sedes */
.balign 2,0
/* QL: * d1 -i  - drive to select (call for select only) */
/* QL: * a3 -ip - address of microdrive control register */
/* QL: * d0/d2 destroyed */
/* QL:         assert  M79_pc.selec,1<<M79_pc..sclk+1<<M79_pc..sel */
/* original assertion: M79_pc.selec,1<<M79_pc..sclk+1<<M79_pc..sel */
/* QL:         assert  M79_pc.desel,1<<M79_pc..sclk */
/* original assertion: M79_pc.desel,1<<M79_pc..sclk */
/* QL: md_selec */
md_selec:
/* QL:         moveq   #M79_pc.selec,d2    clock in select bit first */
    moveq #M79_pc.selec,d2
/* QL:         subq.w  #1,d1           and clock it through n times */
    subq.w #1,d1
/* QL:         bra.s   M79_clk_1st */
    bra.s M79_clk_1st
/* QL: md_desel */
md_desel:
/* QL:         moveq   #8-1,d1         deselect all */
    moveq #(8-1),d1
/* QL: M79_clk_loop */
M79_clk_loop:
/* QL:         moveq   #M79_pc.desel,d2    clock in deselect bit */
    moveq #M79_pc.desel,d2
/* QL: M79_clk_1st */
M79_clk_1st:
/* QL:         move.b  d2,(a3)         clock high */
    move.b d2,(a3)
/* QL:         delay   18              wait */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL: rotate maclab 5 to 19 us inclusive  */
/* QL:  moveq #([us]*15-38)/4,d0 four byte sequence */
    moveq #(((18*15)-38)/4),d0
/* QL:  ror.l d0,d0 */
    ror.l d0,d0
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         bclr    #M79_pc..sclk,d2    clock low */
    bclr #M79_pc..sclk,d2
/* QL:         move.b  d2,(a3)         clocks into first drive */
    move.b d2,(a3)
/* QL:         delay   18              wait */
/* QL:  ifnum [us] < 5 goto us_[us] */
/* QL:  ifnum [us] < 20 goto rotate */
/* QL: rotate maclab 5 to 19 us inclusive  */
/* QL:  moveq #([us]*15-38)/4,d0 four byte sequence */
    moveq #(((18*15)-38)/4),d0
/* QL:  ror.l d0,d0 */
    ror.l d0,d0
/* QL:  goto us_0 */
/* QL: us_0 maclab */
/* QL:         dbra    d1,M79_clk_loop */
    dbra d1,M79_clk_loop
/* QL:         rts */
    rts 
/* QL:         vect4000 md_desel,md_selec */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ md$desel,(md_desel-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ md$selec,(md_selec-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
