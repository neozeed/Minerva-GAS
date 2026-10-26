/* ROM section ss_base */
.balign 2,0
/* QL: M0_ss_base ; this is (and must be) really zero */
M0_ss_base:
/* QL: ******************************************************************************* */
/* QL: * Exception vectors - longwords */
/* QL: * We will cause an illegal instruction exception to occur, and stay occuring, */
/* QL: * should location 0 or 2 be jumped to. */
/* QL: * We use $4c02, an instruction that is illegal based on its first word, and */
/* QL: * one which at least makes the ssp point to ram. */
/* QL: * Note we don't use "a" or "f" line instructions, as people may be using them! */
/* QL: * Also note that extending this to setting the top byte of the initial pc has */
/* QL: * been tried, but found to be somewhat awkward, as the ms byte of the pc has */
/* QL: * to be cleared at some point. A good solution would probably be to route the */
/* QL: * vector to "ipc jmp ss_ramt" in here, where we don't mind absolute jumps. */
/* QL: M0_k.issp  equ     $4c024c02       initial ssp - no longer used as such */
.equ M0_k.issp,0x4c024c02
/* QL: l vec.l M0_k.issp ss_ramt  ; 00  0 initial SSP     08  2 initial PC */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_278:
.long 1275218946
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_290:
.long ss_ramt
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: l vec.l M0_l.berr t.aerr   ; 08  2 bus error       0c  3 address error */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_305:
.long (M0_l.berr-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_320:
.long (((M0_aerr>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: l vec.l t.ill  t.div0   ; 10  4 illegal instrn  14  5 divide by zero */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_337:
.long (((M0_ill>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_352:
.long (((M0_div0>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: l vec.l t.chk  t.trapv  ; 18  6 CHK instruction 1c  7 TRAPV instruction */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_369:
.long (((M0_chk>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_384:
.long (((M0_trapv>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: l vec.l M0_l.q020 t.trace  ; 20  8 M0_priv violation  24  9 M0_trace */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_399:
.long (M0_l.q020-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_414:
.long (((M0_trace>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: l vec.l t.ill  t.ill    ; 28 10 opcode 1010     2c 11 opcode 1010 emulation */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_431:
.long (((M0_ill>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_446:
.long (((M0_ill>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: ******************************************************************************* */
/* QL: * code for trap #0 calls */
/* QL:         dcb.b   M0_ss_base+$5e-4-*,-1 */
.space (((M0_ss_base+0x5e)-4)-.),255
/* QL: M0_l.trap0 */
M0_l.trap0:
/* QL:         bset    #5,(sp)         set s bit to stay in supervisor mode */
    bset #5,(sp)
/* QL: M0_l.rte1 */
M0_l.rte1:
/* QL:         rte     ; expected just here by painter! */
    rte 
/* QL: ******************************************************************************* */
/* QL: * exception vectors continued */
/* QL: * autovectors: */
/* QL: l vec.l M0_l.rte1 M0_l.rte1                   ; spurious interrupt & level 1 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_476:
.long (M0_l.rte1-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_489:
.long (M0_l.rte1-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: l vec.l ss_int2                         ; level 2 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_503:
.long ss_int2
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: l vec.l M0_l.rte1 M0_l.rte1 M0_l.rte1 M0_l.rte1     ; level 3-6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_518:
.long (M0_l.rte1-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_531:
.long (M0_l.rte1-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_544:
.long (M0_l.rte1-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_557:
.long (M0_l.rte1-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: l vec.l t.int7                          ; level 7 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_574:
.long (((M0_int7>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: * trap calls: */
/* QL: l vec.l M0_l.trap0  mt_trap  io_trap2 io_trap3     ; 0-3 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_590:
.long (M0_l.trap0-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_602:
.long mt_trap
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_614:
.long io_trap2
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_626:
.long io_trap3
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: l vec.l io_trap4 t.trap5  t.trap6  t.trap7      ; 4-7 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_640:
.long io_trap4
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_655:
.long (((M0_trap5>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_670:
.long (((M0_trap6>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_685:
.long (((M0_trap7>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: l vec.l t.trap8  t.trap9  t.trap10 t.trap11     ; 8-11 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_702:
.long (((M0_trap8>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_717:
.long (((M0_trap9>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_732:
.long (((M0_trap10>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_747:
.long (((M0_trap11>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: l vec.l t.trap12 t.trap13 t.trap14 t.trap15     ; 12-15 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_764:
.long (((M0_trap12>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_779:
.long (((M0_trap13>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_794:
.long (((M0_trap14>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL: xt maclab */
/* QL: o setstr [.right(o,[.len(o)]-2)]>>1+M0_tab */
/* QL: xl maclab */
/* QL: o setstr [o]-M0_ss_base */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_809:
.long (((M0_trap15>>1)+M0_tab)-M0_ss_base)
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: ******************************************************************************* */
/* QL: * utility vectors - words */
/* QL: M0_k.0     equ     0 */
.equ M0_k.0,0
/* QL: M0_k.m1    equ     -1 */
.equ M0_k.m1,(-1)
/* QL: s vec.w mm_alchp mm_rechp ut_windw ut_con   ;  $c0 -  $c6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_829:
.word mm_alchp
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_841:
.word mm_rechp
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_853:
.word ut_windw
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_865:
.word ut_con
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w ut_scr   ut_err0  ut_err   ut_mint  ;  $c8 -  $ce */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_879:
.word ut_scr
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_891:
.word ut_err0
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_903:
.word ut_err
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_915:
.word ut_mint
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w ut_mtext ut_link  ut_unlnk M0_k.0      ;  $d0 -  $d6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_929:
.word ut_mtext
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_941:
.word ut_link
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_953:
.word ut_unlnk
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_965:
.word 0
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w mm_alloc mm_lnkfr io_qset  io_qtest ;  $d8 -  $de */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_979:
.word mm_alloc
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_991:
.word mm_lnkfr
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1003:
.word io_qset
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1015:
.word io_qtest
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w io_qin   io_qout  io_qeof  ut_cstr  ;  $e0 -  $e6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1029:
.word io_qin
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1041:
.word io_qout
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1053:
.word io_qeof
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1065:
.word ut_cstr
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w io_serq  io_serio cn_date  cn_day   ;  $e8 -  $ee */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1079:
.word io_serq
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1091:
.word io_serio
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1103:
.word cn_date
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1115:
.word cn_day
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w cn_ftod  cn_itod  cn_itobb cn_itobw ;  $f0 -  $f6 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1129:
.word cn_ftod
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1141:
.word cn_itod
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1153:
.word cn_itobb
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1165:
.word cn_itobw
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w cn_itobl cn_itohb cn_itohw cn_itohl ;  $f8 -  $fe */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1179:
.word cn_itobl
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1191:
.word cn_itohb
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1203:
.word cn_itohw
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1215:
.word cn_itohl
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w cn_dtof  cn_dtoi  cn_btoib cn_btoiw ; $100 - $106 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1229:
.word cn_dtof
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1241:
.word cn_dtoi
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1253:
.word cn_btoib
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1265:
.word cn_btoiw
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w cn_btoil cn_htoib cn_htoiw cn_htoil ; $108 - $10e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1279:
.word cn_btoil
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1291:
.word cn_htoib
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1303:
.word cn_htoiw
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1315:
.word cn_htoil
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w bp_init  ca_gtint ca_gtfp  ca_gtstr ; $110 - $116 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1329:
.word bp_init
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1341:
.word ca_gtint
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1353:
.word ca_gtfp
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1365:
.word ca_gtstr
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w ca_gtlin bv_chrix ri_exec  ri_execb ; $118 - $11e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1379:
.word ca_gtlin
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1391:
.word bv_chrix
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1403:
.word ri_exec
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1415:
.word ri_execb
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w bp_let   io_name  md$read  md$write ; $120 - $126 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1429:
.word bp_let
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1441:
.word io_name
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1453:
.word md$read
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1465:
.word md$write
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w md$verin md$sectr pa$graph pa$table ; $128 - $12e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1479:
.word md$verin
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1491:
.word md$sectr
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1503:
.word pa$graph
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1515:
.word pa$table
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w pa$expr  pa$strip pa$mist  pf$nwlin ; $130 - $136 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1529:
.word pa$expr
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1541:
.word pa$strip
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1553:
.word pa$mist
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1565:
.word pf$nwlin
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w pf$liste pa$ini   ut$istr  ib$new   ; $138 - $13e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1579:
.word pf$liste
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1591:
.word pa$ini
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1603:
.word ut$istr
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1615:
.word ib$new
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w bp$chan  bp$chand bp$chnid bp$chnew ; $140 - $146 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1629:
.word bp$chan
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1641:
.word bp$chand
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1653:
.word bp$chnid
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1665:
.word bp$chnew
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w bp$fname ca$cnvrt ca$opexe ca$eval  ; $148 - $14e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1679:
.word bp$fname
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1691:
.word ca$cnvrt
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1703:
.word ca$opexe
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1715:
.word ca$eval
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w ip$kbrd  ip$kbend sb$start M0_k.m1     ; $150 - $156 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1729:
.word ip$kbrd
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1741:
.word ip$kbend
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1753:
.word sb$start
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1765:
.word ((-1))&65535
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w mm$move  mm$mrtoa mm$mator mm$mrtor ; $158 - $15e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1779:
.word mm$move
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1791:
.word mm$mrtoa
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1803:
.word mm$mator
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1815:
.word mm$mrtor
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w ss$wser  ss$rser  md$selec md$desel ; $160 - $166 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1829:
.word ss$wser
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1841:
.word ss$rser
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1853:
.word md$selec
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1865:
.word md$desel
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w mm$clear mm$clrr  io$qsetl M0_k.m1     ; $168 - $16e */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1879:
.word mm$clear
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1891:
.word mm$clrr
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1903:
.word io$qsetl
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1915:
.word ((-1))&65535
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: s vec.w ii$raw   ii$drive M0_k.m1     M0_k.m1     ; $170 - $176 */
/* QL: i setnum 0 */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1929:
.word ii$raw
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1941:
.word ii$drive
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1953:
.word ((-1))&65535
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: loop maclab */
/* QL: i setnum [i]+1 */
/* QL: o setstr [.parm([i])] */
/* QL:  ifstr [.right(.left(o,2),1)] = . goto x[.left(o,1)] */
/* QL:         xref.[.lab] [o] */
/* QL:  goto xk */
/* QL: xk maclab */
/* QL:         dc.[.ext] [o] */
.balign 2,0
M0_dc_anchor_1965:
.word ((-1))&65535
/* QL:  ifnum [i] < [.nparms] goto loop */
/* QL: ******************************************************************************* */
/* QL: * The tk2 res_128 command expects find itself neatly in the ram_test code by */
/* QL: * setting up a4 and jumping in here. */
/* QL:         dcb.b   M0_ss_base+$184-*,-1 */
.space ((M0_ss_base+0x184)-.),255
/* QL:         move.l  a4,d1           enter the reset with a4 set to max mem */
    move.l a4,d1
/* QL: ******************************************************************************* */
/* QL: * We will now use $186 (390 decimal) for software reset. Just the value of d1.l */
/* QL: * is required. See ss_ramt for the details on this value. */
/* QL:         trap    #0              force ourselves into supervisor mode */
    trap #0
/* QL:         or.w    #$700,sr        block interrupts */
    or.w #0x700,sr
/* QL:         move.l  $5c,a5          put a magic number in a5 (odd value best) */
    move.l 0x5c,a5
/* QL:         reset                   press the button! */
    reset 
/* QL: * the genuine "reset" instruction does nothing, but ... */
/* QL:         movem.l 0,a0-a1         ... proper reset on miracle 68020 board ... */
    movem.l 0,a0-a1
/* QL:         jmp     (a1)            ... so we made refs to 0-7 for winnie */
    jmp (a1)
/* QL: ******************************************************************************* */
/* QL: * Waste a bit more space to get to location for multirom entry point. */
/* QL:         dcb.b   M0_ss_base+$1ac-*,-1 */
.space ((M0_ss_base+0x1ac)-.),255
/* QL:         moveq   #8,d5           mode 8 reset */
    moveq #8,d5
/* QL:         jmp     ss_init(pc)     skip ramtest and into init */
    jmp ss_init(pc)
/* QL: ******************************************************************************* */
/* QL: * Trap redirection code */
/* QL: M0_rd */
M0_rd:
/* QL:         move.l  a6,-(sp)        save an address register */
    move.l a6,-(sp)
/* QL:         move.l  a7,a6           copy the system stack pointer */
    move.l a7,a6
/* QL:         exg     a6,d7           need it in a data register for and */
    exg a6,d7
/* QL:         and.w   #$8000,d7       this is sv_base */
    and.w #0x8000,d7
/* QL:         exg     a6,d7           now back in the address register */
    exg a6,d7
/* QL:         tst.l   M0_sv_trapv(a6)    is there a redirection vector? */
    tst.l M0_sv_trapv(a6)
/* QL:         bne.s   M0_do_rd           yes - go do it */
    bne.s M0_do_rd
/* QL:         move.l  (sp)+,a6        recover register */
    move.l (sp)+,a6
/* QL:         sub.l   #M0_tab+M0_aerr>>1+2-M0_ss_base,(sp)+ remove return address */
    sub.l #(((M0_tab+(M0_aerr>>1))+2)-M0_ss_base),(sp)+
/* QL:         bne.s   M0_spurint         good - it was not address error */
    bne.s M0_spurint
/* QL: M0_l.berr */
M0_l.berr:
/* QL:         addq.l  #8,sp           for bus or address errors remove junk */
    addq.l #8,sp
/* QL: M0_spurint */
M0_spurint:
/* QL:         jmp     ss_intrd(pc)    let it behave as a surious interrupt */
    jmp ss_intrd(pc)
/* QL: * will luck, the above might un-"treacle" the machine... */
/* QL: M0_tab     repeat  M0_rdend/4 bsr.s   M0_rd */
/* QL: [.lab] */
M0_tab:
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: loop maclab */
/* QL:         [op]    [arg] */
    bsr.s M0_rd
/* QL: n setnum [n]-1 */
/* QL:  ifnum [n] > 0 goto loop */
/* QL: M0_do_rd */
M0_do_rd:
/* QL:         move.l  M0_sv_trapv(a6),a6 get the vector table address */
    move.l M0_sv_trapv(a6),a6
/* QL:         sub.w   #2*(M0_tab+2-M0_ss_base)-M0_sv_trapo,a6 - we've moved the bsr's, sigh! */
    sub.w #((2*((M0_tab+2)-M0_ss_base))-M0_sv_trapo),a6
/* QL:         add.w   6(sp),a6        add return address ... */
    add.w 6(sp),a6
/* QL:         add.w   6(sp),a6        ... twice */
    add.w 6(sp),a6
/* QL:         move.l  (a6),4(sp)      put redirected trap address on stack */
    move.l (a6),4(sp)
/* QL:         move.l  (sp)+,a6        restore the working register */
    move.l (sp)+,a6
/* QL:         rts                     branch to the required code */
    rts 
/* QL: * This code is to sort out the fact that move's from sr are priviledged */
/* QL: * instructions on the 68020, etc. */
/* QL: * The technique employed here is fairly straightforward, if a little slow. */
/* QL: * We check that move sr,daddr is what's being attempted, and if not, go on with */
/* QL: * the normal exception handling for priviledge violations. */
/* QL: * We then always have a shot at converting the instruction to the 68020's move */
/* QL: * from ccr, which will work if the user is in ram, and will mean we don't ever */
/* QL: * have to come back here! */
/* QL: * Although the instruction may well be in ram, we don't check to see if the */
/* QL: * conversion succeeded, as it's conceivable we may have problems with the data */
/* QL: * cache, which might make it look as if we managed to write into rom! */
/* QL: * We then construct live code on the user stack as follows: */
/* QL: * upc-> move    ccr,daddr       1, 2 or 3 words */
/* QL: *       jmp     return          3 word absolute jump */
/* QL: *       ds.w    0..2            padding. note: move ccr,-(sp) will be ok */
/* QL: * usp-> */
/* QL: * Note that we now never show the user any extra bits that might be present in */
/* QL: * the msb of the sr value, as they probably wouldn't know what they meant! */
/* QL: * The only assumptions made in the above system are that the user: */
/* QL: *       1) has at least 12 (+1 if odd!) bytes of stack available in ram. */
/* QL: *       2) doesn't mind us overwriting those bytes. */
/* QL: *       3) doesn't store the value over the live code we put there! */
/* QL: ureg    reg     d7/a5-a6 */
/* QL: M0_ulen    equ     3*4 */
.equ M0_ulen,(3*4)
/* QL: M0_isprivv */
M0_isprivv:
/* QL:         movem.l (sp)+,ureg      restore user's registers */
    movem.l (sp)+,d7/a5-a6
/* QL:         bra.s   M0_tab+M0_priv>>1     go do a real priviledge violation */
    bra.s (M0_tab+(M0_priv>>1))
/* QL: M0_l.q020 */
M0_l.q020:
/* QL:         movem.l ureg,-(sp)      save user's registers */
    movem.l d7/a5-a6,-(sp)
/* QL:         move.l  M0_ulen+2(sp),a6   get user's return address */
    move.l (M0_ulen+2)(sp),a6
/* QL:         moveq   #$40,d7         first byte identifying all move sr,daddr */
    moveq #0x40,d7
/* QL:         cmp.b   (a6),d7         check the offending instruction */
    cmp.b (a6),d7
/* QL:         bne.s   M0_isprivv         it wasn't a move from sr, it's a real violation */
    bne.s M0_isprivv
/* QL:         rol.w   #3,d7           move from ccr ($42xx) just needs bit 9 set */
    rol.w #3,d7
/* QL:         or.w    (a6),d7         construct new 1st word for instruction */
    or.w (a6),d7
/* QL:         move.w  d7,(a6)+        store it as a replacement, wary of rom/cache */
    move.w d7,(a6)+
/* QL:         move    usp,a5          find user's stack */
    move usp,a5
/* QL:         exg     a5,d7           being ultra cautious... */
    exg a5,d7
/* QL:         bclr    #0,d7           ... make certain it's at an even address... */
    bclr #0,d7
/* QL:         exg     a5,d7           ... so we'll never crash in here! */
    exg a5,d7
/* QL:         sub.w   #2*6,a5         4, 5 or 6 words of live code */
    sub.w #(2*6),a5
/* QL:         move.l  a5,M0_ulen+2(sp)   replace return address with live code address */
    move.l a5,(M0_ulen+2)(sp)
/* QL:         move.w  d7,(a5)+        put 1st, or only, word of new instruction */
    move.w d7,(a5)+
/* QL:         cmp.b   #$e8,d7         check instruction size (move sr,daddr >= $40c0) */
    cmp.b #(0xe8&255),d7
/* QL:         bcs.s   M0_srset           modes less than 5 need no more */
    bcs.s M0_srset
/* QL:         move.w  (a6)+,(a5)+     copy first, or only, extra instruction word */
    move.w (a6)+,(a5)+
/* QL:         addq.b  #256-$f9,d7     is destination absolute long? */
.word 20487|((((256-0xf9))&7)<<9)
/* QL:         bcs.s   M0_srset           no, that's ok */
    bcs.s M0_srset
/* QL:         move.w  (a6)+,(a5)+     copy lsw of absolute long address */
    move.w (a6)+,(a5)+
/* QL: M0_srset */
M0_srset:
/* QL:         move.w  #$4ef9,(a5)+    put in jmp $xxx.l instruction 1st word */
    move.w #0x4ef9,(a5)+
/* QL:         move.l  a6,(a5)         complete with address after their instruction */
    move.l a6,(a5)
/* QL:         movem.l (sp)+,ureg      restore user's registers */
    movem.l (sp)+,d7/a5-a6
/* QL:         rte                     let 'em have it */
    rte 
/* QL:         end */
