/* ROM section ut_windw */
.balign 2,0
/* QL: * N.B. ut_windw now correctly gets the top byte of d2.w zero before sd.bordr. */
/* QL: * Also, other than ut_wrdef, the rest now do close the channel they've opened */
/* QL: * if any subsequent part of the setup fails. They used to leave it M71_open! */
/* QL: * a0 i o pointer to name / channel id */
/* QL: * a1 i p pointer to parameter block */
/* QL: * d0   o error code */
/* QL: * d1-d3 destroyed (ut_wrdef preserves d3) */
/* QL: ut_windw */
ut_windw:
/* QL:         bsr.s   M71_open */
    bsr.s M71_open
/* QL:         addq.l  #4,a1 */
    addq.l #4,a1
/* QL:         bsr.s   M71_set_attr */
    bsr.s M71_set_attr
/* QL:         bra.s   M71_chk_ok */
    bra.s M71_chk_ok
/* QL: ut_con */
ut_con:
/* QL:         bsr.s   M71_open_wnd */
    bsr.s M71_open_wnd
/* QL:         dc.w    3,'con' */
.balign 2,0
M71_dc_anchor_243:
.word 3
.byte 99,111,110
.balign 2,0
/* QL: M71_go_scr */
M71_go_scr:
/* QL:         bsr.s   M71_open_wnd */
    bsr.s M71_open_wnd
/* QL:         dc.w    3,'scr' */
.balign 2,0
M71_dc_anchor_253:
.word 3
.byte 115,99,114
.balign 2,0
/* QL: * Oh bother! The latest TK2 wants to jump 6 on from the ut.scr vector to get */
/* QL: * this code that does the window redefinition. Naturally enough, it doesn't */
/* QL: * want to re-M71_open the channels: they are the magic ones. Hence the following: */
/* QL: ut_scr */
ut_scr:
/* QL:         bra.s   M71_go_scr */
    bra.s M71_go_scr
/* QL: M71_open_wnd */
M71_open_wnd:
/* QL:         move.l  (sp)+,a0 */
    move.l (sp)+,a0
/* QL:         bsr.s   M71_open */
    bsr.s M71_open
/* QL: * TK2 comes in here */
/* QL:         bsr.s   ut_wrdef */
    bsr.s ut_wrdef
/* QL: M71_chk_ok */
M71_chk_ok:
/* QL:         beq.s   M71_ret */
    beq.s M71_ret
/* QL:         moveq   #M71_io.close,d0 */
    moveq #M71_io.close,d0
/* QL:         trap    #2 */
    trap #2
/* QL:         move.l  d2,d0           copy of error went to d2 */
    move.l d2,d0
/* QL: M71_ret */
M71_ret:
/* QL:         rts */
    rts 
/* QL: ut_wrdef */
ut_wrdef:
/* QL:         addq.l  #4,a1           move to window definition */
    addq.l #4,a1
/* QL:         moveq   #M71_sd.wdef,d0     set window size */
    moveq #M71_sd.wdef,d0
/* QL:         moveq   #0,d2           remove any existing border */
    moveq #0,d2
/* QL:         bsr.s   M71_trap3 */
    bsr.s M71_trap3
/* QL: M71_set_attr */
M71_set_attr:
/* QL:         moveq   #M71_sd.setin,d0    set ink */
    moveq #M71_sd.setin,d0
/* QL:         bsr.s   M71_trap3d */
    bsr.s M71_trap3d
/* QL:         moveq   #M71_sd.setpa,d0    set paper */
    moveq #M71_sd.setpa,d0
/* QL:         bsr.s   M71_trap3d */
    bsr.s M71_trap3d
/* QL:         moveq   #M71_sd.setst,d0    set strip */
    moveq #M71_sd.setst,d0
/* QL:         move.b  (a1),d1 */
    move.b (a1),d1
/* QL:         bsr.s   M71_trap3 */
    bsr.s M71_trap3
/* QL:         moveq   #M71_sd.bordr,d0    set border */
    moveq #M71_sd.bordr,d0
/* QL:         move.b  -(a1),d2        (if we get here, d2.l has been zeroed) */
    move.b -(a1),d2
/* QL:         bsr.s   M71_trap3d */
    bsr.s M71_trap3d
/* QL:         moveq   #M71_sd.clear,d0    clear screen without a border */
    moveq #M71_sd.clear,d0
/* QL:         bsr.s   M71_trap3 */
    bsr.s M71_trap3
/* QL:         rts     N.B. must keep bsr and rts, in case of error causing addq #4,sp */
    rts 
/* QL: M71_open */
M71_open:
/* QL:         move.l  a1,-(sp)        save parameter pointer */
    move.l a1,-(sp)
/* QL:         moveq   #M71_io.open,d0 */
    moveq #M71_io.open,d0
/* QL:         moveq   #-1,d1          for this job */
    moveq #(-1),d1
/* QL:         moveq   #0,d3           old/exclusive */
    moveq #0,d3
/* QL:         trap    #2              ... do it */
    trap #2
/* QL:         bra.s   M71_trap_tst */
    bra.s M71_trap_tst
/* QL: M71_trap3d */
M71_trap3d:
/* QL:         move.b  -(a1),d1 */
    move.b -(a1),d1
/* QL: M71_trap3 */
M71_trap3:
/* QL:         move.l  a1,-(sp)        save parameter pointer */
    move.l a1,-(sp)
/* QL:         trap    #3 */
    trap #3
/* QL: M71_trap_tst */
M71_trap_tst:
/* QL:         move.l  (sp)+,a1        restore parameter pointer */
    move.l (sp)+,a1
/* QL:         move.l  d0,d2           check error return + save it + ok d2 for bordr */
    move.l d0,d2
/* QL:         beq.s   M71_trap_xit */
    beq.s M71_trap_xit
/* QL:         addq.l  #4,sp           remove return */
    addq.l #4,sp
/* QL: M71_trap_xit */
M71_trap_xit:
/* QL:         rts */
    rts 
/* QL:         end */
