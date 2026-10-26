/* ROM section tb_txt */
.balign 2,0
/* QL: x[.l] */
M191_x1:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_29:
.word (((M191_y1-M191_dc_anchor_29)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_36:
.byte 110,111,116,32,99,111,109,112,108,101,116,101
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_42:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y1:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x2:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_63:
.word (((M191_y2-M191_dc_anchor_63)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_70:
.byte 105,110,118,97,108,105,100,32,106,111,98
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_76:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y2:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x3:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_97:
.word (((M191_y3-M191_dc_anchor_97)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_104:
.byte 111,117,116,32,111,102,32,109,101,109,111,114,121
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_110:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y3:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x4:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_131:
.word (((M191_y4-M191_dc_anchor_131)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_138:
.byte 111,117,116,32,111,102,32,114,97,110,103,101
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_144:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y4:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x5:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_165:
.word (((M191_y5-M191_dc_anchor_165)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_172:
.byte 98,117,102,102,101,114,32,102,117,108,108
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_178:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y5:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x6:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_199:
.word (((M191_y6-M191_dc_anchor_199)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_206:
.byte 99,104,97,110,110,101,108,32,110,111,116,32,111,112,101,110
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_212:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y6:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x7:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_233:
.word (((M191_y7-M191_dc_anchor_233)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_240:
.byte 110,111,116,32,102,111,117,110,100
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_246:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y7:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x8:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_267:
.word (((M191_y8-M191_dc_anchor_267)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_274:
.byte 97,108,114,101,97,100,121,32,101,120,105,115,116,115
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_280:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y8:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x9:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_301:
.word (((M191_y9-M191_dc_anchor_301)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_308:
.byte 105,110,32,117,115,101
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_314:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y9:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x10:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_335:
.word (((M191_y10-M191_dc_anchor_335)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_342:
.byte 101,110,100,32,111,102,32,102,105,108,101
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_348:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y10:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x11:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_369:
.word (((M191_y11-M191_dc_anchor_369)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_376:
.byte 100,114,105,118,101,32,102,117,108,108
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_382:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y11:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x12:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_403:
.word (((M191_y12-M191_dc_anchor_403)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_410:
.byte 98,97,100,32,110,97,109,101
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_416:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y12:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x13:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_437:
.word (((M191_y13-M191_dc_anchor_437)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_444:
.byte 88,109,105,116,32,101,114,114,111,114
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_450:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y13:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x14:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_471:
.word (((M191_y14-M191_dc_anchor_471)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_478:
.byte 102,111,114,109,97,116,32,102,97,105,108,101,100
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_484:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y14:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x15:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_505:
.word (((M191_y15-M191_dc_anchor_505)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_512:
.byte 98,97,100,32,112,97,114,97,109,101,116,101,114
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_518:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y15:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x16:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_539:
.word (((M191_y16-M191_dc_anchor_539)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_546:
.byte 98,97,100,32,111,114,32,99,104,97,110,103,101,100,32,109,101,100,105,117,109
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_552:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y16:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x17:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_573:
.word (((M191_y17-M191_dc_anchor_573)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_580:
.byte 101,114,114,111,114,32,105,110,32,101,120,112,114,101,115,115,105,111,110
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_586:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y17:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x18:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_607:
.word (((M191_y18-M191_dc_anchor_607)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_614:
.byte 111,118,101,114,102,108,111,119
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_620:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y18:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x19:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_641:
.word (((M191_y19-M191_dc_anchor_641)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_648:
.byte 110,111,116,32,105,109,112,108,101,109,101,110,116,101,100,32,121,101,116
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_654:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y19:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x20:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_675:
.word (((M191_y20-M191_dc_anchor_675)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_682:
.byte 114,101,97,100,32,111,110,108,121
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_688:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y20:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x21:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_709:
.word (((M191_y21-M191_dc_anchor_709)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_716:
.byte 98,97,100,32,108,105,110,101
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_722:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y21:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x22:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_743:
.word (((M191_y22-M191_dc_anchor_743)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_750:
.byte 65,116,32,108,105,110,101,32
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y22:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x23:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_771:
.word (((M191_y23-M191_dc_anchor_771)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_778:
.byte 32,115,101,99,116,111,114,115
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_784:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y23:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x24:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_805:
.word (((M191_y24-M191_dc_anchor_805)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_812:
.byte 32,70,49,47,70,50,32,115,101,116,115,32,109,111,110,105,116,111,114,47,84,86
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_818:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_824:
.byte 32,70,51,47,70,52,32,102,111,114,32,100,117,97,108,32,115,99,114,101,101,110
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_830:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_836:
.byte 32,49,50,56,75,43,83,72,73,70,84,32,32,100,117,109,98,43,67,84,82,76
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y24:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x25:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_857:
.word (((M191_y25-M191_dc_anchor_857)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_864:
.byte 32,127,32,84,104,101,32,81,86,105,101,119,32,77,101,103,97,32,67,111,114,112,111,114,97,116,105,111,110,33
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y25:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x26:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_885:
.word (((M191_y26-M191_dc_anchor_885)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_892:
.byte 100,117,114,105,110,103,32,87,72,69,78,32,112,114,111,99,101,115,115,105,110,103
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_898:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y26:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x27:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL:         dc.w    y[.l]-*-2 */
.balign 2,0
M191_dc_anchor_919:
.word (((M191_y27-M191_dc_anchor_919)-2))&65535
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_926:
.byte 80,82,79,67,47,70,78,32,99,108,101,97,114,101,100
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_932:
.byte (M191_lf)&255
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y27:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x28:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_956:
.byte 83,117,110,77,111,110,84,117,101,87,101,100,84,104,117,70,114,105,83,97,116
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y28:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
/* QL: x[.l] */
M191_x29:
/* QL:         ifstr   {[.ext]} = B goto nolen */
/* QL: nolen   maclab */
/* QL: i       setnum  0 */
/* QL: loop    maclab */
/* QL: i       setnum  [i]+1 */
/* QL:         dc.b    [.parm([i])] */
M191_dc_anchor_980:
.byte 74,97,110,70,101,98,77,97,114,65,112,114,77,97,121,74,117,110,74,117,108,65,117,103,83,101,112,79,99,116,78,111,118,68,101,99
/* QL:         ifnum   [i] < [.nparms] goto loop */
/* QL: y[.l] */
M191_y29:
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         section tb_msg */
