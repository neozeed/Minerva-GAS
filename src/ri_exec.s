/* ROM section ri_exec */
.balign 2,0
/* QL: tab     macro */
/* QL: M105_exec_tab */
M105_exec_tab:
/* QL:  tab e     one   nint  zero  int   n     nlint k     ;00-07 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_124:
.word ((M105_ri_e-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_135:
.word ((ri_one-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_146:
.word ((ri_nint-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_157:
.word ((ri_zero-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_168:
.word ((ri_int-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_179:
.word ((ri_n-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_190:
.word ((ri_nlint-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_201:
.word ((ri_k-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tab float flong add   cmp   sub   halve mult  doubl ;08-0f */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_215:
.word ((ri_float-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_226:
.word ((ri_flong-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_237:
.word ((ri_add-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_248:
.word ((ri_cmp-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_259:
.word ((ri_sub-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_270:
.word ((ri_halve-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_281:
.word ((ri_mult-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_292:
.word ((ri_doubl-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tab div   recip abs   roll  neg   over  dup   swap  ;10-17 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_306:
.word ((ri_div-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_317:
.word ((ri_recip-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_328:
.word ((ri_abs-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_339:
.word ((ri_roll-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_350:
.word ((ri_neg-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_361:
.word ((ri_over-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_372:
.word ((ri_dup-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_383:
.word ((ri_swap-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tab cos   e     sin   e     tan   e     cot   e     ;18-1f */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_397:
.word ((ri_cos-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_407:
.word ((M105_ri_e-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_418:
.word ((ri_sin-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_428:
.word ((M105_ri_e-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_439:
.word ((ri_tan-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_449:
.word ((M105_ri_e-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_460:
.word ((ri_cot-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_470:
.word ((M105_ri_e-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tab asin  e     acos  e     atan  arg   acot  mod   ;20-27 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_484:
.word ((ri_asin-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_494:
.word ((M105_ri_e-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_505:
.word ((ri_acos-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_515:
.word ((M105_ri_e-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_526:
.word ((ri_atan-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_537:
.word ((ri_arg-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_548:
.word ((ri_acot-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_559:
.word ((ri_mod-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tab sqrt  squar ln    e     log10 e     exp   power ;28-2f */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_573:
.word ((ri_sqrt-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_584:
.word ((ri_squar-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_595:
.word ((ri_ln-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_605:
.word ((M105_ri_e-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_616:
.word ((ri_log10-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_626:
.word ((M105_ri_e-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_637:
.word ((ri_exp-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_648:
.word ((ri_power-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL:  tab powfp                                           ;30 */
/* QL:         local   i,p */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL: p       setstr  [.parm([i])] */
/* QL:         ifstr   {[p]} = {e} goto dcit */
/* QL:         xref    ri_[p] */
/* QL: dcit    maclab */
/* QL:         dc.w    ri_[p]-M105_ri_e */
.balign 2,0
M105_dc_anchor_662:
.word ((ri_powfp-M105_ri_e))&65535
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: * abex and abexb used to clear d2 on error. They don't now, as gw is sensible. */
/* QL: * d0 -i o- instruction code / error code */
/* QL: * a1 -i o- arithmetic stack pointer */
/* QL: * a3 -ip - pointer to instructions */
/* QL: * a4 -ip - base (high address) of arithmetic load/save area */
/* QL: reglist reg d1-d3/a0/a2-a3/a5 */
/* QL: ri_abex */
ri_abex:
/* QL:         move.l  a6,-(sp)        absolute a1 and a4 entry for exec */
    move.l a6,-(sp)
/* QL:         sub.l   a6,a6 */
    sub.l a6,a6
/* QL:         bsr.s   ri_exec */
    bsr.s ri_exec
/* QL:         bra.s   M105_rst_a6 */
    bra.s M105_rst_a6
/* QL: ri_abexb */
ri_abexb:
/* QL:         move.l  a6,-(sp)        absolute a1 and a4 entry for execb */
    move.l a6,-(sp)
/* QL:         sub.l   a6,a6 */
    sub.l a6,a6
/* QL:         bsr.s   ri_execb */
    bsr.s ri_execb
/* QL: M105_rst_a6 */
M105_rst_a6:
/* QL:         move.l (sp)+,a6 */
    move.l (sp)+,a6
/* QL:         rts */
    rts 
/* QL: ri_exec */
ri_exec:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d3/a0/a2-a3/a5,-(sp)
/* QL:         or.w    #-256,d0        make it how we like it */
    or.w #(-256),d0
/* QL:         lea     M105_exec_tab,a5     no operations to follow */
    lea M105_exec_tab(pc),a5
/* QL:         bra.s   M105_exec_do */
    bra.s M105_exec_do
/* QL: ri_execb */
ri_execb:
/* QL:         movem.l reglist,-(sp) */
    movem.l d1-d3/a0/a2-a3/a5,-(sp)
/* QL:         move.l  a3,a5           set internal pointer to ops */
    move.l a3,a5
/* QL:         bra.s   M105_exec_nxt        enter loop */
    bra.s M105_exec_nxt
/* QL: * Non-command odd d0, M105_store a float in the a4 area */
/* QL: M105_store */
M105_store:
/* QL:         move.w  0(a6,a1.l),0(a6,a4.l) M105_store a floating point number */
    move.w 0(a6,a1.l),0(a6,a4.l)
/* QL:         move.l  2(a6,a1.l),2(a6,a4.l) */
    move.l 2(a6,a1.l),2(a6,a4.l)
/* QL:         addq.l  #6,a1           remove operand */
    addq.l #6,a1
/* QL:         bra.s   M105_rst_a4 */
    bra.s M105_rst_a4
/* QL: M105_not_op */
M105_not_op:
/* QL:         bclr    #0,d0           test bit 0 of operand */
    bclr #0,d0
/* QL:         add.w   d0,a4           move to source / destination */
    add.w d0,a4
/* QL:         bne.s   M105_store           choose load or M105_store on bit zero d0 */
    bne.s M105_store
/* QL: * Non-command even d0, load a float from the a4 area */
/* QL:         subq.l  #6,a1           make room for operand */
    subq.l #6,a1
/* QL:         move.w  0(a6,a4.l),0(a6,a1.l) load a floating point number */
    move.w 0(a6,a4.l),0(a6,a1.l)
/* QL:         move.l  2(a6,a4.l),2(a6,a1.l) */
    move.l 2(a6,a4.l),2(a6,a1.l)
/* QL: M105_rst_a4 */
M105_rst_a4:
/* QL:         sub.w   d0,a4           restore a4 to base address */
    sub.w d0,a4
/* QL: M105_exec_nxt */
M105_exec_nxt:
/* QL:         moveq   #-256+(255),d0  ready for anything! */
    moveq #((-256)+255),d0
/* QL:         move.b  (a5)+,d0        fetch next instruction byte */
    move.b (a5)+,d0
/* QL: M105_exec_do */
M105_exec_do:
/* QL:         cmp.b   #M105_ri.maxop,d0    is it an operator? */
    cmp.b #(M105_ri.maxop&255),d0
/* QL:         bhi.s   M105_not_op          no, load or save */
    bhi.s M105_not_op
/* QL:         add.b   d0,d0 */
    add.b d0,d0
/* QL:         move.w  M105_exec_tab+256(pc,d0.w),d0 get offset from table */
    move.w (M105_exec_tab+256)(pc,d0.w),d0
/* QL:         jsr     M105_ri_e(pc,d0.w)   go do it */
    jsr M105_ri_e(pc,d0.w)
/* QL:         beq.s   M105_exec_nxt        loop if no problem detected */
    beq.s M105_exec_nxt
/* QL:         bra.s   M105_exit_b          otherwise, we're finished */
    bra.s M105_exit_b
/* QL: M105_ri_e */
M105_ri_e:
/* QL:         addq.l  #4,sp           scrap return address */
    addq.l #4,sp
/* QL:         moveq   #0,d0           no error */
    moveq #0,d0
/* QL: M105_exit_b */
M105_exit_b:
/* QL:         movem.l (sp)+,reglist */
    movem.l (sp)+,d1-d3/a0/a2-a3/a5
/* QL:         rts */
    rts 
/* QL:         end */
