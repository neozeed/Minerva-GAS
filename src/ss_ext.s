/* ROM section ss_ext */
.balign 2,0
/* QL: ss_ext          ;               user routine to call on shift/ctrl/alt/enter */
ss_ext:
/* QL:         dc.w    tb_itrn-*       input tranlation routine */
.balign 2,0
M4_dc_anchor_11:
.word ((tb_itrn-M4_dc_anchor_11))&65535
/* QL:         dc.w    tb_otrn-*       output translation routine */
.balign 2,0
M4_dc_anchor_15:
.word ((tb_otrn-M4_dc_anchor_15))&65535
/* QL:         dc.w    mm_rechp-*      memory management driver, close entry point */
.balign 2,0
M4_dc_anchor_19:
.word ((mm_rechp-M4_dc_anchor_19))&65535
/* QL:         dc.w    tb_kbenc-*      keyboard encoder routine */
.balign 2,0
M4_dc_anchor_23:
.word ((tb_kbenc-M4_dc_anchor_23))&65535
/* QL:         dc.w    0               linked list of routines to front end mt.ipcom */
.balign 2,0
M4_dc_anchor_27:
.word 0
/* QL:         dc.w    0               reserved */
.balign 2,0
M4_dc_anchor_31:
.word 0
/* QL:         dc.w    0               reserved */
.balign 2,0
M4_dc_anchor_35:
.word 0
/* QL:         dc.w    tb_trn-*        default i/o translation table address */
.balign 2,0
M4_dc_anchor_39:
.word ((tb_trn-M4_dc_anchor_39))&65535
/* QL:         dc.w    tb_msg-*        default message table address */
.balign 2,0
M4_dc_anchor_43:
.word ((tb_msg-M4_dc_anchor_43))&65535
/* QL:         dc.w    tb_f0-*         default primary font */
.balign 2,0
M4_dc_anchor_47:
.word ((tb_f0-M4_dc_anchor_47))&65535
/* QL:         dc.w    tb_f1-*         default secondary font */
.balign 2,0
M4_dc_anchor_51:
.word ((tb_f1-M4_dc_anchor_51))&65535
/* QL: * A zero word delimits the constants */
/* QL:         dc.b    0               real display mode */
M4_dc_anchor_55:
.byte (0)&255
/* QL:         dc.b    0               suppress flags: bit 7 = format with files open */
M4_dc_anchor_58:
.byte (0)&255
/* QL:         dc.b    0               event byte: bits 4-7 toggled by ip_kybrd: */
M4_dc_anchor_61:
.byte (0)&255
/* QL:         ;break job 0 basic      ctrl/space              bit 4 */
/* QL:         ;break all multibasic's ctrl/alt/space          bit 5 */
/* QL:         ;first user kbd event   shift/ctrl/space        bit 6 */
/* QL:         ;second user kbd event  shift/ctrl/alt/space    bit 7 */
/* QL:         dc.b    10<<3!0<<3!3    cursor flash rate, size and color */
M4_dc_anchor_68:
.byte ((((10<<3)|(0<<3))|3))&255
/* QL:         dc.l    $ffffffff,$fff9ffff,$ffffe0ff special key remap table */
.balign 2,0
M4_dc_anchor_72:
.long 0xffffffff
.long 0xfff9ffff
.long 0xffffe0ff
/* QL:         ;       freeze screen   ctrl/alt/tab            ctrl/f5 */
/* QL:         ;       caps lock       shift/ctrl/enter        caps lock */
/* QL:         dc.w    '1.98',4,'JSL1' */
.balign 2,0
M4_dc_anchor_80:
.byte 49,46,57,56
.balign 2,0
.word 4
.byte 74,83,76,49
.balign 2,0
/* QL: *       dc.w    0,0,0           reserved */
/* QL:         end */
