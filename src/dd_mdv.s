/* ROM section dd_mdv */
.balign 2,0
/* QL: dd_mdv */
dd_mdv:
/* QL:         dc.w    dd_mdvio-* */
.balign 2,0
M121_dc_anchor_58:
.word ((dd_mdvio-M121_dc_anchor_58))&65535
/* QL:         dc.w    dd_mdvop-* */
.balign 2,0
M121_dc_anchor_62:
.word ((dd_mdvop-M121_dc_anchor_62))&65535
/* QL:         dc.w    dd_mdvcl-* */
.balign 2,0
M121_dc_anchor_66:
.word ((dd_mdvcl-M121_dc_anchor_66))&65535
/* QL:         dc.w    md_slave-* */
.balign 2,0
M121_dc_anchor_70:
.word ((md_slave-M121_dc_anchor_70))&65535
/* QL:         dc.w    0 */
.balign 2,0
M121_dc_anchor_74:
.word 0
/* QL:         dc.w    0 */
.balign 2,0
M121_dc_anchor_78:
.word 0
/* QL:         dc.w    md_formt-* */
.balign 2,0
M121_dc_anchor_82:
.word ((md_formt-M121_dc_anchor_82))&65535
/* QL:         dc.l    M121_md_end          length of definition block */
.balign 2,0
M121_dc_anchor_86:
.long M121_md_end
/* QL:         dc.w    3,'MDV'         microdrive device name */
.balign 2,0
M121_dc_anchor_90:
.word 3
.byte 77,68,86
.balign 2,0
/* QL:         end */
