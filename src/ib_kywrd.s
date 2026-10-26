/* ROM section ib_kywrd */
.balign 2,0
/* QL: M169_kyentry */
M169_kyentry:
/* QL:         gotab         end   for   if    rep   sel   when  def */
/* QL: i setnum  0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_78:
.word ((ib_end-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_89:
.word ((ib_for-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_100:
.word ((ib_if-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_111:
.word ((ib_rep-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_122:
.word ((ib_sel-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_133:
.word ((ib_when-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_144:
.word ((ib_def-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         gotab   errnf errnf goto  errnf errnf errnf errnf errnf */
/* QL: i setnum  0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_156:
.word ((M169_ib_errnf-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_166:
.word ((M169_ib_errnf-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_177:
.word ((ib_goto-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_187:
.word ((M169_ib_errnf-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_197:
.word ((M169_ib_errnf-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_207:
.word ((M169_ib_errnf-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_217:
.word ((M169_ib_errnf-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_227:
.word ((M169_ib_errnf-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         gotab   errnf restr next  exit  else  on    ret   errnf */
/* QL: i setnum  0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_239:
.word ((M169_ib_errnf-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_250:
.word ((ib_restr-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_261:
.word ((ib_next-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_272:
.word ((ib_exit-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_283:
.word ((ib_else-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_294:
.word ((ib_on-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_305:
.word ((ib_ret-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_315:
.word ((M169_ib_errnf-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         gotab   rts   dim   errbl name  errnf errnf rts   errbl */
/* QL: i setnum  0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_327:
.word ((M169_ib_rts-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_338:
.word ((ib_dim-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_348:
.word ((M169_ib_errbl-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL:         xref    [n] */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_359:
.word ((ib_name-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_369:
.word ((M169_ib_errnf-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_379:
.word ((M169_ib_errnf-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_389:
.word ((M169_ib_rts-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: n setstr ib_[.parm([i])] */
/* QL:  ifnum [.instr(h,n)] > 0 goto d */
/* QL: d maclab */
/* QL:         dc.w    [n]-M169_ib_rts */
.balign 2,0
M169_dc_anchor_399:
.word ((M169_ib_errbl-M169_ib_rts))&65535
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: ib_kywrd */
ib_kywrd:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         move.b  1(a6,a4.l),d0   read key number */
    move.b 1(a6,a4.l),d0
/* QL:         addq.l  #2,a4 */
    addq.l #2,a4
/* QL:         add.b   d0,d0           entries in words */
    add.b d0,d0
/* QL:         move.w  M169_kyentry-2(pc,d0.w),d0 get code offset */
    move.w (M169_kyentry-2)(pc,d0.w),d0
/* QL:         jmp     M169_ib_rts(pc,d0.w) note: if we go to M169_ib_rts, d0=0 */
.word 0x4efb
.word 0|((M169_ib_rts-.)&255)
/* QL: M169_ib_errnf */
M169_ib_errnf:
/* QL:         moveq   #M169_err.nf,d0 */
    moveq #M169_err.nf,d0
/* QL:         rts */
    rts 
/* QL: M169_ib_errbl */
M169_ib_errbl:
/* QL:         moveq   #M169_err.bl,d0 */
    moveq #M169_err.bl,d0
/* QL: M169_ib_rts */
M169_ib_rts:
/* QL:         rts */
    rts 
/* QL:         end */
