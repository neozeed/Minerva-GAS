/* ROM section tb_msg */
.balign 2,0
/* QL: tb_msg */
tb_msg:
/* QL:         dc.w    $4afb */
.balign 2,0
M191_dc_anchor_15:
.word 0x4afb
/* QL:         msg     {'not complete'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_20:
.word ((M191_x1-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'invalid job'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_54:
.word ((M191_x2-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'out of memory'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_88:
.word ((M191_x3-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'out of range'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_122:
.word ((M191_x4-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'buffer full'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_156:
.word ((M191_x5-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'channel not open'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_190:
.word ((M191_x6-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'not found'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_224:
.word ((M191_x7-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'already exists'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_258:
.word ((M191_x8-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'in use'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_292:
.word ((M191_x9-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'end of file'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_326:
.word ((M191_x10-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'drive full'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_360:
.word ((M191_x11-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'bad name'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_394:
.word ((M191_x12-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'Xmit error'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_428:
.word ((M191_x13-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'format failed'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_462:
.word ((M191_x14-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'bad parameter'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_496:
.word ((M191_x15-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'bad or changed medium'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_530:
.word ((M191_x16-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'error in expression'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_564:
.word ((M191_x17-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'overflow'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_598:
.word ((M191_x18-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'not implemented yet'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_632:
.word ((M191_x19-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'read only'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_666:
.word ((M191_x20-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'bad line'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_700:
.word ((M191_x21-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'At line '} */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_734:
.word ((M191_x22-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {' sectors'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_762:
.word ((M191_x23-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {' F1/F2 sets monitor/TV'},M191_lf  {' F3/F4 for dual screen'},M191_lf  {' 128K+SHIFT  dumb+CTRL'} */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_796:
.word ((M191_x24-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'  The QView Mega Corporation!'} */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_848:
.word ((M191_x25-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'during WHEN processing'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_876:
.word ((M191_x26-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg     {'PROC/FN cleared'},M191_lf */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_910:
.word ((M191_x27-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg.b   {'SunMonTueWedThuFriSat'} */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_944:
.word ((M191_x28-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         msg.b   {'JanFebMarAprMayJunJulAugSepOctNovDec'} */
/* QL:         dc.w    x[.l]-tb_msg */
.balign 2,0
M191_dc_anchor_968:
.word ((M191_x29-tb_msg))&65535
/* QL:         section tb_txt */
/* QL:         end */
