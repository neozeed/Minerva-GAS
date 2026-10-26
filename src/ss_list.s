/* ROM section ss_list */
.balign 2,0
/* QL:         dc.b    0,1             address       will be set up with */
M3_dc_anchor_28:
.byte (0)&255
.byte (1)&255
/* QL:         dc.w    ss_ext+24*2-*   base+$00: 00000000 + 11 addresses + 13 words */
.balign 2,0
M3_dc_anchor_33:
.word (((ss_ext+(24*2))-M3_dc_anchor_33))&65535
/* QL:         dc.b    2,11*2-1 */
M3_dc_anchor_36:
.byte (2)&255
.byte (((11*2)-1))&255
/* QL:         dc.w    ip_poll-*       base+$50: 00000000 ip_poll */
.balign 2,0
M3_dc_anchor_41:
.word ((ip_poll-M3_dc_anchor_41))&65535
/* QL:         dc.b    2,1 */
M3_dc_anchor_44:
.byte (2)&255
.byte (1)&255
/* QL:         dc.w    sd_sched-*                                  base+$60 sd_sched */
.balign 2,0
M3_dc_anchor_49:
.word ((sd_sched-M3_dc_anchor_49))&65535
/* QL:         dc.w    ip_sched-*      base+$60: base+$68 ip_sched */
.balign 2,0
M3_dc_anchor_53:
.word ((ip_sched-M3_dc_anchor_53))&65535
/* QL:         dc.w    io_sched-*                                  00000000 io_scan */
.balign 2,0
M3_dc_anchor_57:
.word ((io_sched-M3_dc_anchor_57))&65535
/* QL:         dc.b    2,1 */
M3_dc_anchor_60:
.byte (2)&255
.byte (1)&255
/* QL:         dc.w    od_ser+3*2-*    base+$70: base+$80 od_serio od_serop od_sercl */
.balign 2,0
M3_dc_anchor_65:
.word (((od_ser+(3*2))-M3_dc_anchor_65))&65535
/* QL:         dc.w    od_pipe+3*2-*   base+$80: base+$90 io_serq  od_pipop od_pipcl */
.balign 2,0
M3_dc_anchor_69:
.word (((od_pipe+(3*2))-M3_dc_anchor_69))&65535
/* QL:         dc.w    od_con+3*2-*    base+$90: base+$a0 od_conio od_conop od_concl */
.balign 2,0
M3_dc_anchor_73:
.word (((od_con+(3*2))-M3_dc_anchor_73))&65535
/* QL:         dc.w    od_net+3*2-*    base+$a0: 00000000 od_netio od_netop od_netcl */
.balign 2,0
M3_dc_anchor_77:
.word (((od_net+(3*2))-M3_dc_anchor_77))&65535
/* QL:         dc.b    1,3*2-1 */
M3_dc_anchor_80:
.byte (1)&255
.byte (((3*2)-1))&255
/* QL:         dc.w    dd_mdv+12*2-*   base+$b0: 00000000 dd_mdvio dd_mdvop dd_mdvcl */
.balign 2,0
M3_dc_anchor_85:
.word (((dd_mdv+(12*2))-M3_dc_anchor_85))&65535
/* QL: *                               base+$c0: md_slave 00000000 00000000 md_formt */
/* QL: *                               base+$d0: 0 md_end 0 3 m d  v 0 0000 00000000 */
/* QL: *                               base+$e0: end of system extension */
/* QL: ss_list */
ss_list:
/* QL:         end */
