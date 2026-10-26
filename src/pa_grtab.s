/* ROM section pa_grtab */
.balign 2,0
/* QL: pa_grtab */
pa_grtab:
/* QL: gnum    setnum  $80     graph numbers and entry points         */
/* QL: M128_q       equ     [gnum] possible exit from graph = graph plus zero */
.equ M128_q,128
/* QL: line    graph   basic line */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_line.l,130
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_52:
.word ((M128_line_a-pa_grtab))&65535
/* QL: odc     graph   opening definition clause */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_odc.l,132
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_61:
.word ((M128_odc_a-pa_grtab))&65535
/* QL: osl     graph   opening select clause */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_osl.l,134
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_70:
.word ((M128_osl_a-pa_grtab))&65535
/* QL: oc      graph   opening clause */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_oc.l,136
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_79:
.word ((M128_oc_a-pa_grtab))&65535
/* QL: ;ocif    graph   entry to opening if clause (no longer used) */
/* QL: ic      graph   intermediate clause */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_ic.l,138
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_89:
.word ((M128_ic_a-pa_grtab))&65535
/* QL: icon    graph   entry to intermediate on clause */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_icon.l,140
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_98:
.word ((M128_icon_a-pa_grtab))&65535
/* QL: ec      graph   end clause */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_ec.l,142
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_107:
.word ((M128_ec_a-pa_grtab))&65535
/* QL: stat    graph   statement */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_stat.l,144
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_116:
.word ((M128_stat_a-pa_grtab))&65535
/* QL: dplst   graph   definition parameter list */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_dplst.l,146
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_125:
.word ((M128_dplst_a-pa_grtab))&65535
/* QL: rnge    graph   range */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_rnge.l,148
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_134:
.word ((M128_rnge_a-pa_grtab))&65535
/* QL: expr    graph   expression */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_expr.l,150
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_143:
.word ((M128_expr_a-pa_grtab))&65535
/* QL: whcon   graph   condition (part-way thro' expression) */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_whcon.l,152
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_152:
.word ((M128_whcon_a-pa_grtab))&65535
/* QL: da      graph   dimension array list */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_da.l,154
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_161:
.word ((M128_da_a-pa_grtab))&65535
/* QL: var     graph   variable */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_var.l,156
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_170:
.word ((M128_var_a-pa_grtab))&65535
/* QL: splst   graph   separated parameter list */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_splst.l,158
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_179:
.word ((M128_splst_a-pa_grtab))&65535
/* QL: subs    graph   subscription list */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_subs.l,160
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_188:
.word ((M128_subs_a-pa_grtab))&65535
/* QL: lit     graph   literal */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_lit.l,162
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_197:
.word ((M128_lit_a-pa_grtab))&65535
/* QL: ongo    graph   distinguish "ON name = expr" from "ON expr GO ..." */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_ongo.l,164
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_206:
.word ((M128_ongo_a-pa_grtab))&65535
/* QL: proc    graph   distinguish "name(expr) = expr" from "name splst" (mostly) */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_proc.l,166
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_215:
.word ((M128_proc_a-pa_grtab))&65535
/* QL: ass     graph   distingish assignment statements as far as possible */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_ass.l,168
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_224:
.word ((M128_ass_a-pa_grtab))&65535
/* QL: tosub   graph   GO TO or GO SUB, to save a little space */
/* QL: [.lab] gen.l */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_tosub.l,170
/* QL:  dc.w [.lab]_a-pa_grtab */
.balign 2,0
M128_dc_anchor_233:
.word ((M128_tosub_a-pa_grtab))&65535
/* QL: gnum    setnum  $40     keyword numbers */
/* QL: END     gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_end.w,66
/* QL: FOR     gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_for.w,68
/* QL: IF      gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_if.w,70
/* QL: REP     gen.w   ; REPeat */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_rep.w,72
/* QL: SEL     gen.w   ; SELect */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_sel.w,74
/* QL: WHEN    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_when.w,76
/* QL: DEF     gen.w   ; DEFine */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_def.w,78
/* QL: PROC    gen.w   ; PROCedure */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_proc.w,80
/* QL: FN      gen.w   ; FuNction */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_fn.w,82
/* QL: GO      gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_go.w,84
/* QL: TO      gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_to.w,86
/* QL: SUB     gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_sub.w,88
/* QL:         xxx.w   ; extra WHEN, not parsed, needed by keyword check for WHENERRor */
/* QL: gnum setnum [gnum]+2 */
/* QL: ERR     gen.w   ; ERRor */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_err.w,92
/* QL:         xxx.w   ; spare keyword (currently IF, historically EOF then END) */
/* QL: gnum setnum [gnum]+2 */
/* QL:         xxx.w   ; spare keyword (currently IF, historically INPUT then ERRor) */
/* QL: gnum setnum [gnum]+2 */
/* QL: RESTORE gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_restore.w,98
/* QL: NEXT    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_next.w,100
/* QL: EXIT    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_exit.w,102
/* QL: ELSE    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_else.w,104
/* QL: ON      gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_on.w,106
/* QL: RET     gen.w   RETurn */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_ret.w,108
/* QL: REMAINDER gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_remainder.w,110
/* QL: DATA    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_data.w,112
/* QL: DIM     gen.w   DIMension */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_dim.w,114
/* QL: LOC     gen.w   LOCal */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_loc.w,116
/* QL: LET     gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_let.w,118
/* QL: THEN    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_then.w,120
/* QL: STEP    gen.w */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_step.w,122
/* QL: REM     gen.w   REMark */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_rem.w,124
/* QL: MIST    gen.w   MISTake (reading line from file) */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_mist.w,126
/* QL: gnum    setnum  $20     symbol numbers */
/* QL: equ     gen.s   equals '=' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_equ.s,34
/* QL: col     gen.s   colon ':' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_col.s,36
/* QL: hsh     gen.s   hash '#' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_hsh.s,38
/* QL: com     gen.s   comma ',' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_com.s,40
/* QL: obr     gen.s   open bracket '(' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_obr.s,42
/* QL: cbr     gen.s   close bracket')' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_cbr.s,44
/* QL: ocb     gen.s   open curly bracket '{' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_ocb.s,46
/* QL: ccb     gen.s   close curly bracket '}' */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_ccb.s,48
/* QL: spc     gen.s   space */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_spc.s,50
/* QL: lf      gen.s   line feed */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_lf.s,52
/* QL: gnum    setnum  $00     coded atom numbers */
/* QL: M128_z       equ     [gnum] - end of possibilities is coded atom zero */
.equ M128_z,0
/* QL: name    gen.b   name */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_name.b,2
/* QL: val     gen.b   value */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_val.b,4
/* QL: num     xxx.b   number - code actually duplicates the above... s/l integers? */
/* QL: gnum setnum [gnum]+2 */
/* QL: sysv    xxx.b   system variable */
/* QL: gnum setnum [gnum]+2 */
/* QL: ops     gen.b   operation symbol */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_ops.b,10
/* QL: mons    gen.b   mon-operation symbol */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_mons.b,12
/* QL: sep     gen.b   separator */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_sep.b,14
/* QL: str     gen.b   string */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_str.b,16
/* QL: txt     gen.b   text */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_txt.b,18
/* QL: linum   gen.b   line number */
/* QL: gnum setnum [gnum]+2 */
/* QL: [.lab].[.ext] equ [gnum] */
.equ M128_linum.b,20
/* QL: * Line graph table */
/* QL: M128_line_a dc.b M128_linum.b,M128_line_b-*-1 optional line number */
M128_line_a:
M128_dc_anchor_437:
.byte (M128_linum.b)&255
.byte (((M128_line_b-M128_dc_anchor_437)-1))&255
/* QL: M128_line_b dc.b  M128_odc.l,M128_line_d-*-1 */
M128_line_b:
M128_dc_anchor_442:
.byte (M128_odc.l)&255
.byte (((M128_line_d-M128_dc_anchor_442)-1))&255
/* QL: ;M128_line_b dc.b  M128_odc.l,line_f-*-1 see below */
/* QL: M128_line_c dc.b   IF.w,M128_line_l-*-1,M128_osl.l,M128_line_j-*-3,M128_oc.l,M128_line_d-*-5 */
M128_line_c:
M128_dc_anchor_448:
.byte (M128_if.w)&255
.byte (((M128_line_l-M128_dc_anchor_448)-1))&255
.byte (M128_osl.l)&255
.byte (((M128_line_j-M128_dc_anchor_448)-3))&255
.byte (M128_oc.l)&255
.byte (((M128_line_d-M128_dc_anchor_448)-5))&255
/* QL:        dc.b    ELSE.w,M128_line_c-*-1,M128_ic.l,M128_line_d-*-3,M128_ec.l,M128_line_d-*-5 */
M128_dc_anchor_456:
.byte (M128_else.w)&255
.byte (((M128_line_c-M128_dc_anchor_456)-1))&255
.byte (M128_ic.l)&255
.byte (((M128_line_d-M128_dc_anchor_456)-3))&255
.byte (M128_ec.l)&255
.byte (((M128_line_d-M128_dc_anchor_456)-5))&255
/* QL:        dc.b     M128_stat.l,M128_line_d-*-1 */
M128_dc_anchor_464:
.byte (M128_stat.l)&255
.byte (((M128_line_d-M128_dc_anchor_464)-1))&255
/* QL: M128_line_d dc.b      M128_col.s,M128_line_c-*-1 */
M128_line_d:
M128_dc_anchor_469:
.byte (M128_col.s)&255
.byte (((M128_line_c-M128_dc_anchor_469)-1))&255
/* QL: M128_line_e dc.b       M128_lf.s,*-*,M128_z */
M128_line_e:
M128_dc_anchor_474:
.byte (M128_lf.s)&255
.byte ((M128_dc_anchor_474-M128_dc_anchor_474))&255
.byte (M128_z)&255
/* QL: ;line_f dc.b M128_equ.s,line_g-*-1,M128_col.s,M128_line_c-*-3,M128_lf.s,*-*,M128_z */
/* QL: ; replace above when single line functions are going to be implemented */
/* QL: ;line_g dc.b M128_expr.l,M128_line_e-*-1,M128_z */
/* QL: M128_line_h dc.b THEN.w,M128_line_c-*-1 */
M128_line_h:
M128_dc_anchor_483:
.byte (M128_then.w)&255
.byte (((M128_line_c-M128_dc_anchor_483)-1))&255
/* QL: M128_line_i dc.b                   M128_col.s,M128_line_c-*-1,M128_lf.s,*-*,M128_z */
M128_line_i:
M128_dc_anchor_488:
.byte (M128_col.s)&255
.byte (((M128_line_c-M128_dc_anchor_488)-1))&255
.byte (M128_lf.s)&255
.byte ((M128_dc_anchor_488-M128_dc_anchor_488))&255
.byte (M128_z)&255
/* QL: M128_line_j dc.b M128_lf.s,*-*,M128_col.s,M128_line_k-*-3 */
M128_line_j:
M128_dc_anchor_496:
.byte (M128_lf.s)&255
.byte ((M128_dc_anchor_496-M128_dc_anchor_496))&255
.byte (M128_col.s)&255
.byte (((M128_line_k-M128_dc_anchor_496)-3))&255
/* QL: M128_line_k dc.b                           M128_icon.l,M128_line_c-*-1,M128_z */
M128_line_k:
M128_dc_anchor_503:
.byte (M128_icon.l)&255
.byte (((M128_line_c-M128_dc_anchor_503)-1))&255
.byte (M128_z)&255
/* QL: M128_line_l dc.b M128_expr.l,M128_line_h-*-1,M128_z */
M128_line_l:
M128_dc_anchor_509:
.byte (M128_expr.l)&255
.byte (((M128_line_h-M128_dc_anchor_509)-1))&255
.byte (M128_z)&255
/* QL: * Opening definition clause graph table */
/* QL: M128_odc_a dc.b DEF.w,M128_odc_b-*-1,M128_z */
M128_odc_a:
M128_dc_anchor_516:
.byte (M128_def.w)&255
.byte (((M128_odc_b-M128_dc_anchor_516)-1))&255
.byte (M128_z)&255
/* QL: M128_odc_b dc.b PROC.w,M128_odc_c-*-1,FN.w,M128_odc_c-*-3,M128_z */
M128_odc_b:
M128_dc_anchor_522:
.byte (M128_proc.w)&255
.byte (((M128_odc_c-M128_dc_anchor_522)-1))&255
.byte (M128_fn.w)&255
.byte (((M128_odc_c-M128_dc_anchor_522)-3))&255
.byte (M128_z)&255
/* QL: M128_odc_c dc.b M128_name.b,M128_odc_d-*-1,M128_z */
M128_odc_c:
M128_dc_anchor_530:
.byte (M128_name.b)&255
.byte (((M128_odc_d-M128_dc_anchor_530)-1))&255
.byte (M128_z)&255
/* QL: M128_odc_d dc.b M128_q,M128_dplst.l,*-*,M128_z */
M128_odc_d:
M128_dc_anchor_536:
.byte (M128_q)&255
.byte (M128_dplst.l)&255
.byte ((M128_dc_anchor_536-M128_dc_anchor_536))&255
.byte (M128_z)&255
/* QL: * Opening clause graph table */
/* QL: M128_oc_a dc.b FOR.w,M128_oc_b-*-1,REP.w,M128_oc_d-*-3,WHEN.w,M128_oc_f-*-5,M128_z */
M128_oc_a:
M128_dc_anchor_544:
.byte (M128_for.w)&255
.byte (((M128_oc_b-M128_dc_anchor_544)-1))&255
.byte (M128_rep.w)&255
.byte (((M128_oc_d-M128_dc_anchor_544)-3))&255
.byte (M128_when.w)&255
.byte (((M128_oc_f-M128_dc_anchor_544)-5))&255
.byte (M128_z)&255
/* QL: M128_oc_b dc.b M128_name.b,M128_oc_g-*-1,M128_z */
M128_oc_b:
M128_dc_anchor_554:
.byte (M128_name.b)&255
.byte (((M128_oc_g-M128_dc_anchor_554)-1))&255
.byte (M128_z)&255
/* QL: ;M128_oc_d dc.b M128_name.b,*-*,M128_z */
/* QL: M128_oc_f dc.b ERR.w,*-*,M128_name.b,M128_oc_r-*-3,M128_z */
M128_oc_f:
M128_dc_anchor_561:
.byte (M128_err.w)&255
.byte ((M128_dc_anchor_561-M128_dc_anchor_561))&255
.byte (M128_name.b)&255
.byte (((M128_oc_r-M128_dc_anchor_561)-3))&255
.byte (M128_z)&255
/* QL: M128_oc_g dc.b M128_equ.s,M128_oc_m-*-1,M128_z */
M128_oc_g:
M128_dc_anchor_569:
.byte (M128_equ.s)&255
.byte (((M128_oc_m-M128_dc_anchor_569)-1))&255
.byte (M128_z)&255
/* QL: *oc_h dc.b M128_q allowed WHEN ERRor <expr>{,<expr>} !!! */
/* QL: *oc_i dc.b     M128_expr.l,oc_n-*-1,M128_z */
/* QL: *oc_j dc.b M128_hsh.s,oc_p-*-1,M128_z oc_j/p/t were "#expr{,#expr}" - not used! */
/* QL: M128_oc_m dc.b M128_rnge.l,M128_oc_s-*-1,M128_z */
M128_oc_m:
M128_dc_anchor_578:
.byte (M128_rnge.l)&255
.byte (((M128_oc_s-M128_dc_anchor_578)-1))&255
.byte (M128_z)&255
/* QL: *oc_n dc.b M128_q,M128_com.s,oc_i-*-2,M128_z */
/* QL: *oc_p dc.b M128_expr.l,oc_u-*-1,M128_z */
/* QL: M128_oc_r dc.b M128_q,M128_whcon.l,*-*,M128_z this starts at possible subscription/slicing */
M128_oc_r:
M128_dc_anchor_586:
.byte (M128_q)&255
.byte (M128_whcon.l)&255
.byte ((M128_dc_anchor_586-M128_dc_anchor_586))&255
.byte (M128_z)&255
/* QL: M128_oc_s dc.b STEP.w,M128_oc_v-*-1 */
M128_oc_s:
M128_dc_anchor_593:
.byte (M128_step.w)&255
.byte (((M128_oc_v-M128_dc_anchor_593)-1))&255
/* QL: M128_oc_t dc.b                 M128_q,M128_com.s,M128_oc_m-*-2,M128_z */
M128_oc_t:
M128_dc_anchor_598:
.byte (M128_q)&255
.byte (M128_com.s)&255
.byte (((M128_oc_m-M128_dc_anchor_598)-2))&255
.byte (M128_z)&255
/* QL: *oc_u dc.b M128_q,M128_com.s,oc_j-*-2,M128_z */
/* QL: M128_oc_v dc.b M128_expr.l,M128_oc_t-*-1,M128_z */
M128_oc_v:
M128_dc_anchor_606:
.byte (M128_expr.l)&255
.byte (((M128_oc_t-M128_dc_anchor_606)-1))&255
.byte (M128_z)&255
/* QL: * Opening select clause */
/* QL: M128_osl_a dc.b SEL.w,M128_osl_b-*-1,M128_z */
M128_osl_a:
M128_dc_anchor_613:
.byte (M128_sel.w)&255
.byte (((M128_osl_b-M128_dc_anchor_613)-1))&255
.byte (M128_z)&255
/* QL: M128_osl_b dc.b ON.w,M128_osl_c-*-1 */
M128_osl_b:
M128_dc_anchor_619:
.byte (M128_on.w)&255
.byte (((M128_osl_c-M128_dc_anchor_619)-1))&255
/* QL: M128_oc_d */
M128_oc_d:
/* QL: M128_ic_b */
M128_ic_b:
/* QL: M128_osl_c dc.b                M128_name.b,*-*,M128_z */
M128_osl_c:
M128_dc_anchor_628:
.byte (M128_name.b)&255
.byte ((M128_dc_anchor_628-M128_dc_anchor_628))&255
.byte (M128_z)&255
/* QL: * Intermediate clause graph table (now takes in the "ON expr GO ..." statement) */
/* QL: M128_ic_a dc.b EXIT.w,M128_ic_b-*-1,NEXT.w,M128_ic_b-*-3,RET.w,M128_ic_c-*-5,ON.w,M128_ic_d-*-7 */
M128_ic_a:
M128_dc_anchor_635:
.byte (M128_exit.w)&255
.byte (((M128_ic_b-M128_dc_anchor_635)-1))&255
.byte (M128_next.w)&255
.byte (((M128_ic_b-M128_dc_anchor_635)-3))&255
.byte (M128_ret.w)&255
.byte (((M128_ic_c-M128_dc_anchor_635)-5))&255
.byte (M128_on.w)&255
.byte (((M128_ic_d-M128_dc_anchor_635)-7))&255
/* QL: M128_icon_a dc.b                            M128_equ.s,M128_ic_e-*-1,M128_z */
M128_icon_a:
M128_dc_anchor_646:
.byte (M128_equ.s)&255
.byte (((M128_ic_e-M128_dc_anchor_646)-1))&255
.byte (M128_z)&255
/* QL: ;M128_ic_b dc.b M128_name.b,*-*,M128_z */
/* QL: ;M128_ic_c dc.b M128_q,M128_expr.l,*-*,M128_z */
/* QL: M128_ic_d dc.b M128_ongo.l,*-*,M128_name.b,M128_icon_a-*-3,M128_z */
M128_ic_d:
M128_dc_anchor_654:
.byte (M128_ongo.l)&255
.byte ((M128_dc_anchor_654-M128_dc_anchor_654))&255
.byte (M128_name.b)&255
.byte (((M128_icon_a-M128_dc_anchor_654)-3))&255
.byte (M128_z)&255
/* QL: M128_ic_e dc.b REMAINDER.w,*-* */
M128_ic_e:
M128_dc_anchor_662:
.byte (M128_remainder.w)&255
.byte ((M128_dc_anchor_662-M128_dc_anchor_662))&255
/* QL: M128_ic_f dc.b                 M128_rnge.l,M128_ic_g-*-1,M128_z */
M128_ic_f:
M128_dc_anchor_667:
.byte (M128_rnge.l)&255
.byte (((M128_ic_g-M128_dc_anchor_667)-1))&255
.byte (M128_z)&255
/* QL: M128_ic_g dc.b M128_com.s,M128_ic_f-*-1,M128_q,M128_z */
M128_ic_g:
M128_dc_anchor_673:
.byte (M128_com.s)&255
.byte (((M128_ic_f-M128_dc_anchor_673)-1))&255
.byte (M128_q)&255
.byte (M128_z)&255
/* QL: * End clause graph table */
/* QL: M128_ec_a dc.b END.w,M128_ec_b-*-1,M128_z */
M128_ec_a:
M128_dc_anchor_681:
.byte (M128_end.w)&255
.byte (((M128_ec_b-M128_dc_anchor_681)-1))&255
.byte (M128_z)&255
/* QL: M128_ec_b dc.b REP.w,M128_ec_d-*-1,FOR.w,M128_ec_d-*-3,IF.w,*-*,SEL.w,*-* */
M128_ec_b:
M128_dc_anchor_687:
.byte (M128_rep.w)&255
.byte (((M128_ec_d-M128_dc_anchor_687)-1))&255
.byte (M128_for.w)&255
.byte (((M128_ec_d-M128_dc_anchor_687)-3))&255
.byte (M128_if.w)&255
.byte ((M128_dc_anchor_687-M128_dc_anchor_687))&255
.byte (M128_sel.w)&255
.byte ((M128_dc_anchor_687-M128_dc_anchor_687))&255
/* QL:      dc.b                            WHEN.w,*-*,DEF.w,M128_ec_c-*-3,M128_z */
M128_dc_anchor_697:
.byte (M128_when.w)&255
.byte ((M128_dc_anchor_697-M128_dc_anchor_697))&255
.byte (M128_def.w)&255
.byte (((M128_ec_c-M128_dc_anchor_697)-3))&255
.byte (M128_z)&255
/* QL: M128_ec_c dc.b M128_q */
M128_ec_c:
M128_dc_anchor_705:
.byte (M128_q)&255
/* QL: M128_ec_d dc.b   M128_name.b,*-*,M128_z */
M128_ec_d:
M128_dc_anchor_709:
.byte (M128_name.b)&255
.byte ((M128_dc_anchor_709-M128_dc_anchor_709))&255
.byte (M128_z)&255
/* QL: * Proc call "name(expr)=expr sep" (to distinguish it from assignment) */
/* QL: M128_proc_a dc.b M128_obr.s,M128_proc_b-*-1,M128_z */
M128_proc_a:
M128_dc_anchor_716:
.byte (M128_obr.s)&255
.byte (((M128_proc_b-M128_dc_anchor_716)-1))&255
.byte (M128_z)&255
/* QL: M128_proc_b dc.b M128_expr.l,M128_proc_c-*-1,M128_z */
M128_proc_b:
M128_dc_anchor_722:
.byte (M128_expr.l)&255
.byte (((M128_proc_c-M128_dc_anchor_722)-1))&255
.byte (M128_z)&255
/* QL: M128_proc_c dc.b M128_cbr.s,M128_proc_d-*-1,M128_z */
M128_proc_c:
M128_dc_anchor_728:
.byte (M128_cbr.s)&255
.byte (((M128_proc_d-M128_dc_anchor_728)-1))&255
.byte (M128_z)&255
/* QL: M128_proc_d dc.b M128_ops.b,M128_proc_e-*-1 */
M128_proc_d:
M128_dc_anchor_734:
.byte (M128_ops.b)&255
.byte (((M128_proc_e-M128_dc_anchor_734)-1))&255
/* QL: M128_proc_e dc.b M128_expr.l,M128_proc_f-*-1 */
M128_proc_e:
M128_dc_anchor_739:
.byte (M128_expr.l)&255
.byte (((M128_proc_f-M128_dc_anchor_739)-1))&255
/* QL: M128_proc_f dc.b M128_sep.b,*-*,M128_z */
M128_proc_f:
M128_dc_anchor_744:
.byte (M128_sep.b)&255
.byte ((M128_dc_anchor_744-M128_dc_anchor_744))&255
.byte (M128_z)&255
/* QL: * ON expr GO ... graph table (to distinguish it from ON var = expr) */
/* QL: M128_ongo_a dc.b M128_expr.l,M128_ongo_l-*-1,M128_z */
M128_ongo_a:
M128_dc_anchor_751:
.byte (M128_expr.l)&255
.byte (((M128_ongo_l-M128_dc_anchor_751)-1))&255
.byte (M128_z)&255
/* QL: M128_ongo_l dc.b GO.w,M128_ongo_m-*-1,M128_z */
M128_ongo_l:
M128_dc_anchor_757:
.byte (M128_go.w)&255
.byte (((M128_ongo_m-M128_dc_anchor_757)-1))&255
.byte (M128_z)&255
/* QL: M128_ongo_m dc.b M128_tosub.l,M128_ongo_p-*-1,M128_z */
M128_ongo_m:
M128_dc_anchor_763:
.byte (M128_tosub.l)&255
.byte (((M128_ongo_p-M128_dc_anchor_763)-1))&255
.byte (M128_z)&255
/* QL: M128_ongo_n dc.b M128_expr.l,M128_ongo_p-*-1,M128_z */
M128_ongo_n:
M128_dc_anchor_769:
.byte (M128_expr.l)&255
.byte (((M128_ongo_p-M128_dc_anchor_769)-1))&255
.byte (M128_z)&255
/* QL: M128_ongo_p dc.b M128_com.s,M128_ongo_n-*-1,M128_q,M128_z */
M128_ongo_p:
M128_dc_anchor_775:
.byte (M128_com.s)&255
.byte (((M128_ongo_n-M128_dc_anchor_775)-1))&255
.byte (M128_q)&255
.byte (M128_z)&255
/* QL: * TO or SUB plus expr to save a couple of bytes */
/* QL: M128_tosub_a dc.b TO.w,M128_tosub_c-*-1,SUB.w,M128_tosub_c-*-3,M128_z */
M128_tosub_a:
M128_dc_anchor_783:
.byte (M128_to.w)&255
.byte (((M128_tosub_c-M128_dc_anchor_783)-1))&255
.byte (M128_sub.w)&255
.byte (((M128_tosub_c-M128_dc_anchor_783)-3))&255
.byte (M128_z)&255
/* QL: *M128_tosub_c dc.b M128_expr.l,*-*,M128_z */
/* QL: * Statement graph table */
/* QL: M128_stat_a dc.b LOC.w,M128_stat_v-*-1,DIM.w,M128_stat_c-*-3,DATA.w,M128_ongo_n-*-5 */
M128_stat_a:
M128_dc_anchor_793:
.byte (M128_loc.w)&255
.byte (((M128_stat_v-M128_dc_anchor_793)-1))&255
.byte (M128_dim.w)&255
.byte (((M128_stat_c-M128_dc_anchor_793)-3))&255
.byte (M128_data.w)&255
.byte (((M128_ongo_n-M128_dc_anchor_793)-5))&255
/* QL:        dc.b  RESTORE.w,M128_stat_b-*-1,REM.w,M128_stat_h-*-3,MIST.w,M128_stat_h-*-5 */
M128_dc_anchor_801:
.byte (M128_restore.w)&255
.byte (((M128_stat_b-M128_dc_anchor_801)-1))&255
.byte (M128_rem.w)&255
.byte (((M128_stat_h-M128_dc_anchor_801)-3))&255
.byte (M128_mist.w)&255
.byte (((M128_stat_h-M128_dc_anchor_801)-5))&255
/* QL:        dc.b   GO.w,M128_tosub_a-*-1,LET.w,M128_stat_p-*-3,M128_name.b,M128_stat_t-*-5,M128_z */
M128_dc_anchor_809:
.byte (M128_go.w)&255
.byte (((M128_tosub_a-M128_dc_anchor_809)-1))&255
.byte (M128_let.w)&255
.byte (((M128_stat_p-M128_dc_anchor_809)-3))&255
.byte (M128_name.b)&255
.byte (((M128_stat_t-M128_dc_anchor_809)-5))&255
.byte (M128_z)&255
/* QL: * Note: "name(expr)=expr" still has to be left to runtime! */
/* QL: M128_ic_c */
M128_ic_c:
/* QL: M128_stat_b dc.b M128_q */
M128_stat_b:
M128_dc_anchor_822:
.byte (M128_q)&255
/* QL: M128_rnge_c */
M128_rnge_c:
/* QL: M128_tosub_c */
M128_tosub_c:
/* QL: M128_stat_s dc.b   M128_expr.l,*-*,M128_z */
M128_stat_s:
M128_dc_anchor_830:
.byte (M128_expr.l)&255
.byte ((M128_dc_anchor_830-M128_dc_anchor_830))&255
.byte (M128_z)&255
/* QL: M128_stat_c dc.b M128_name.b,M128_stat_d-*-1,M128_z */
M128_stat_c:
M128_dc_anchor_836:
.byte (M128_name.b)&255
.byte (((M128_stat_d-M128_dc_anchor_836)-1))&255
.byte (M128_z)&255
/* QL: M128_stat_d dc.b M128_da.l,M128_stat_e-*-1,M128_z */
M128_stat_d:
M128_dc_anchor_842:
.byte (M128_da.l)&255
.byte (((M128_stat_e-M128_dc_anchor_842)-1))&255
.byte (M128_z)&255
/* QL: M128_stat_e dc.b M128_com.s,M128_stat_c-*-1,M128_q,M128_z */
M128_stat_e:
M128_dc_anchor_848:
.byte (M128_com.s)&255
.byte (((M128_stat_c-M128_dc_anchor_848)-1))&255
.byte (M128_q)&255
.byte (M128_z)&255
/* QL: M128_stat_v dc.b M128_name.b,M128_stat_f-*-1,M128_z */
M128_stat_v:
M128_dc_anchor_855:
.byte (M128_name.b)&255
.byte (((M128_stat_f-M128_dc_anchor_855)-1))&255
.byte (M128_z)&255
/* QL: M128_stat_f dc.b M128_da.l,M128_stat_g-*-1 */
M128_stat_f:
M128_dc_anchor_861:
.byte (M128_da.l)&255
.byte (((M128_stat_g-M128_dc_anchor_861)-1))&255
/* QL: M128_stat_g dc.b                 M128_com.s,M128_stat_v-*-1,M128_q,M128_z */
M128_stat_g:
M128_dc_anchor_866:
.byte (M128_com.s)&255
.byte (((M128_stat_v-M128_dc_anchor_866)-1))&255
.byte (M128_q)&255
.byte (M128_z)&255
/* QL: M128_stat_h dc.b M128_txt.b,*-*,M128_z */
M128_stat_h:
M128_dc_anchor_873:
.byte (M128_txt.b)&255
.byte ((M128_dc_anchor_873-M128_dc_anchor_873))&255
.byte (M128_z)&255
/* QL: M128_stat_p dc.b M128_name.b,M128_stat_q-*-1,M128_z */
M128_stat_p:
M128_dc_anchor_879:
.byte (M128_name.b)&255
.byte (((M128_stat_q-M128_dc_anchor_879)-1))&255
.byte (M128_z)&255
/* QL: M128_stat_q dc.b M128_var.l,M128_stat_r-*-1,M128_z */
M128_stat_q:
M128_dc_anchor_885:
.byte (M128_var.l)&255
.byte (((M128_stat_r-M128_dc_anchor_885)-1))&255
.byte (M128_z)&255
/* QL: M128_ass_b */
M128_ass_b:
/* QL: M128_stat_r dc.b M128_equ.s,M128_stat_s-*-1,M128_z */
M128_stat_r:
M128_dc_anchor_893:
.byte (M128_equ.s)&255
.byte (((M128_stat_s-M128_dc_anchor_893)-1))&255
.byte (M128_z)&255
/* QL: M128_stat_t dc.b M128_proc.l,M128_stat_u-*-1,M128_ass.l,*-* */
M128_stat_t:
M128_dc_anchor_899:
.byte (M128_proc.l)&255
.byte (((M128_stat_u-M128_dc_anchor_899)-1))&255
.byte (M128_ass.l)&255
.byte ((M128_dc_anchor_899-M128_dc_anchor_899))&255
/* QL: M128_stat_u dc.b                             M128_splst.l,*-*,M128_z */
M128_stat_u:
M128_dc_anchor_906:
.byte (M128_splst.l)&255
.byte ((M128_dc_anchor_906-M128_dc_anchor_906))&255
.byte (M128_z)&255
/* QL: * Assignment statement (with a chance of getting it wrong! "name(expr)=expr") */
/* QL: M128_ass_a dc.b M128_var.l,M128_ass_b-*-1,M128_z */
M128_ass_a:
M128_dc_anchor_913:
.byte (M128_var.l)&255
.byte (((M128_ass_b-M128_dc_anchor_913)-1))&255
.byte (M128_z)&255
/* QL: * Definition parameter list graph table */
/* QL: M128_dplst_a dc.b M128_obr.s,M128_dplst_b-*-1,M128_z */
M128_dplst_a:
M128_dc_anchor_920:
.byte (M128_obr.s)&255
.byte (((M128_dplst_b-M128_dc_anchor_920)-1))&255
.byte (M128_z)&255
/* QL: M128_dplst_b dc.b M128_name.b,M128_dplst_c-*-1,M128_obr.s,M128_dplst_e-*-3,M128_z */
M128_dplst_b:
M128_dc_anchor_926:
.byte (M128_name.b)&255
.byte (((M128_dplst_c-M128_dc_anchor_926)-1))&255
.byte (M128_obr.s)&255
.byte (((M128_dplst_e-M128_dc_anchor_926)-3))&255
.byte (M128_z)&255
/* QL: * Wow! We can have DEFFN fred(a,b,(c,d))! */
/* QL: M128_dplst_c dc.b M128_com.s,M128_dplst_b-*-1 */
M128_dplst_c:
M128_dc_anchor_935:
.byte (M128_com.s)&255
.byte (((M128_dplst_b-M128_dc_anchor_935)-1))&255
/* QL: M128_dplst_d dc.b                   M128_cbr.s,*-*,M128_z */
M128_dplst_d:
M128_dc_anchor_940:
.byte (M128_cbr.s)&255
.byte ((M128_dc_anchor_940-M128_dc_anchor_940))&255
.byte (M128_z)&255
/* QL: M128_dplst_e dc.b M128_name.b,M128_dplst_f-*-1,M128_z */
M128_dplst_e:
M128_dc_anchor_946:
.byte (M128_name.b)&255
.byte (((M128_dplst_f-M128_dc_anchor_946)-1))&255
.byte (M128_z)&255
/* QL: M128_dplst_f dc.b M128_com.s,M128_dplst_e-*-1,M128_cbr.s,M128_dplst_d-*-3,M128_z */
M128_dplst_f:
M128_dc_anchor_952:
.byte (M128_com.s)&255
.byte (((M128_dplst_e-M128_dc_anchor_952)-1))&255
.byte (M128_cbr.s)&255
.byte (((M128_dplst_d-M128_dc_anchor_952)-3))&255
.byte (M128_z)&255
/* QL: * Range graph table */
/* QL: M128_rnge_a dc.b M128_expr.l,M128_rnge_b-*-1,M128_z */
M128_rnge_a:
M128_dc_anchor_961:
.byte (M128_expr.l)&255
.byte (((M128_rnge_b-M128_dc_anchor_961)-1))&255
.byte (M128_z)&255
/* QL: M128_rnge_b dc.b TO.w,M128_rnge_c-*-1,M128_q,M128_z */
M128_rnge_b:
M128_dc_anchor_967:
.byte (M128_to.w)&255
.byte (((M128_rnge_c-M128_dc_anchor_967)-1))&255
.byte (M128_q)&255
.byte (M128_z)&255
/* QL: ;M128_rnge_c dc.b M128_expr.l,*-*,M128_z */
/* QL: * Expression graph table - WHEN var condition graph starts at M128_whcon_a */
/* QL: M128_pa_expr */
M128_pa_expr:
/* QL: M128_expr_a dc.b M128_val.b,M128_expr_d-*-1,M128_mons.b,M128_expr_a-*-3 we may do multiple monadics */
M128_expr_a:
M128_dc_anchor_978:
.byte (M128_val.b)&255
.byte (((M128_expr_d-M128_dc_anchor_978)-1))&255
.byte (M128_mons.b)&255
.byte (((M128_expr_a-M128_dc_anchor_978)-3))&255
/* QL:        dc.b  M128_obr.s,M128_expr_b-*-1 */
M128_dc_anchor_984:
.byte (M128_obr.s)&255
.byte (((M128_expr_b-M128_dc_anchor_984)-1))&255
/* QL:        dc.b   M128_str.b,M128_expr_d-*-1,M128_lit.l,M128_expr_d-*-3,M128_name.b,M128_expr_h-*-5,M128_z */
M128_dc_anchor_988:
.byte (M128_str.b)&255
.byte (((M128_expr_d-M128_dc_anchor_988)-1))&255
.byte (M128_lit.l)&255
.byte (((M128_expr_d-M128_dc_anchor_988)-3))&255
.byte (M128_name.b)&255
.byte (((M128_expr_h-M128_dc_anchor_988)-5))&255
.byte (M128_z)&255
/* QL: M128_expr_b dc.b M128_expr.l,M128_expr_g-*-1,M128_z */
M128_expr_b:
M128_dc_anchor_998:
.byte (M128_expr.l)&255
.byte (((M128_expr_g-M128_dc_anchor_998)-1))&255
.byte (M128_z)&255
/* QL: M128_whcon_a ; new entry point for WHEN var condition, allow subscription of var */
M128_whcon_a:
/* QL: M128_expr_d dc.b M128_obr.s,M128_expr_f-*-1,M128_q,M128_ops.b,M128_expr_a-*-4,M128_z */
M128_expr_d:
M128_dc_anchor_1006:
.byte (M128_obr.s)&255
.byte (((M128_expr_f-M128_dc_anchor_1006)-1))&255
.byte (M128_q)&255
.byte (M128_ops.b)&255
.byte (((M128_expr_a-M128_dc_anchor_1006)-4))&255
.byte (M128_z)&255
/* QL: M128_expr_f dc.b M128_subs.l,M128_expr_g-*-1,M128_z */
M128_expr_f:
M128_dc_anchor_1015:
.byte (M128_subs.l)&255
.byte (((M128_expr_g-M128_dc_anchor_1015)-1))&255
.byte (M128_z)&255
/* QL: M128_expr_g dc.b M128_cbr.s,M128_expr_d-*-1,M128_z */
M128_expr_g:
M128_dc_anchor_1021:
.byte (M128_cbr.s)&255
.byte (((M128_expr_d-M128_dc_anchor_1021)-1))&255
.byte (M128_z)&255
/* QL: M128_expr_h dc.b M128_obr.s,M128_expr_i-*-1,M128_q,M128_ops.b,M128_expr_a-*-4,M128_z */
M128_expr_h:
M128_dc_anchor_1027:
.byte (M128_obr.s)&255
.byte (((M128_expr_i-M128_dc_anchor_1027)-1))&255
.byte (M128_q)&255
.byte (M128_ops.b)&255
.byte (((M128_expr_a-M128_dc_anchor_1027)-4))&255
.byte (M128_z)&255
/* QL: M128_expr_i dc.b M128_splst.l,M128_expr_g-*-1,M128_z */
M128_expr_i:
M128_dc_anchor_1036:
.byte (M128_splst.l)&255
.byte (((M128_expr_g-M128_dc_anchor_1036)-1))&255
.byte (M128_z)&255
/* QL: * Dimensioned array graph table (name already parsed) */
/* QL: M128_da_a dc.b M128_obr.s,M128_da_c-*-1,M128_z */
M128_da_a:
M128_dc_anchor_1043:
.byte (M128_obr.s)&255
.byte (((M128_da_c-M128_dc_anchor_1043)-1))&255
.byte (M128_z)&255
/* QL: M128_da_c dc.b M128_expr.l,M128_da_d-*-1,M128_z */
M128_da_c:
M128_dc_anchor_1049:
.byte (M128_expr.l)&255
.byte (((M128_da_d-M128_dc_anchor_1049)-1))&255
.byte (M128_z)&255
/* QL: M128_da_d dc.b M128_com.s,M128_da_c-*-1,M128_cbr.s,*-*,M128_z */
M128_da_d:
M128_dc_anchor_1055:
.byte (M128_com.s)&255
.byte (((M128_da_c-M128_dc_anchor_1055)-1))&255
.byte (M128_cbr.s)&255
.byte ((M128_dc_anchor_1055-M128_dc_anchor_1055))&255
.byte (M128_z)&255
/* QL: * Variable graph table (name already parsed) */
/* QL: M128_var_a dc.b M128_q,M128_obr.s,M128_var_b-*-2,M128_z */
M128_var_a:
M128_dc_anchor_1064:
.byte (M128_q)&255
.byte (M128_obr.s)&255
.byte (((M128_var_b-M128_dc_anchor_1064)-2))&255
.byte (M128_z)&255
/* QL: M128_var_b dc.b M128_subs.l,M128_var_c-*-1,M128_z n.b. this still allows a lot of bad constructs! */
M128_var_b:
M128_dc_anchor_1071:
.byte (M128_subs.l)&255
.byte (((M128_var_c-M128_dc_anchor_1071)-1))&255
.byte (M128_z)&255
/* QL: M128_var_c dc.b M128_cbr.s,M128_var_a-*-1,M128_z */
M128_var_c:
M128_dc_anchor_1077:
.byte (M128_cbr.s)&255
.byte (((M128_var_a-M128_dc_anchor_1077)-1))&255
.byte (M128_z)&255
/* QL: * Separated parameter list */
/* QL: M128_splst_a dc.b M128_q,M128_sep.b,M128_splst_a-*-2,M128_hsh.s,M128_splst_b-*-4 */
M128_splst_a:
M128_dc_anchor_1084:
.byte (M128_q)&255
.byte (M128_sep.b)&255
.byte (((M128_splst_a-M128_dc_anchor_1084)-2))&255
.byte (M128_hsh.s)&255
.byte (((M128_splst_b-M128_dc_anchor_1084)-4))&255
/* QL: M128_splst_b dc.b                                         M128_expr.l,M128_splst_c-*-1,M128_z */
M128_splst_b:
M128_dc_anchor_1092:
.byte (M128_expr.l)&255
.byte (((M128_splst_c-M128_dc_anchor_1092)-1))&255
.byte (M128_z)&255
/* QL: M128_splst_c dc.b M128_sep.b,M128_splst_a-*-1,M128_q,M128_z */
M128_splst_c:
M128_dc_anchor_1098:
.byte (M128_sep.b)&255
.byte (((M128_splst_a-M128_dc_anchor_1098)-1))&255
.byte (M128_q)&255
.byte (M128_z)&255
/* QL: * Subscription parameter list (as good as we can manage...) */
/* QL: M128_subs_0 dc.b M128_q */
M128_subs_0:
M128_dc_anchor_1106:
.byte (M128_q)&255
/* QL: M128_subs_a dc.b   M128_sep.b,M128_subs_0-*-1 */
M128_subs_a:
M128_dc_anchor_1110:
.byte (M128_sep.b)&255
.byte (((M128_subs_0-M128_dc_anchor_1110)-1))&255
/* QL: M128_subs_b dc.b                      M128_expr.l,M128_subs_c-*-1,M128_z */
M128_subs_b:
M128_dc_anchor_1115:
.byte (M128_expr.l)&255
.byte (((M128_subs_c-M128_dc_anchor_1115)-1))&255
.byte (M128_z)&255
/* QL: M128_subs_c dc.b M128_sep.b,M128_subs_0-*-1,M128_q,M128_z */
M128_subs_c:
M128_dc_anchor_1121:
.byte (M128_sep.b)&255
.byte (((M128_subs_0-M128_dc_anchor_1121)-1))&255
.byte (M128_q)&255
.byte (M128_z)&255
/* QL: * If we could insist on specific separators, we could do subscription properly! */
/* QL: * subscript list graph */
/* QL: *M128_subs_a dc.b sube.l,M128_subs_b-*-1,M128_z */
/* QL: *M128_subs_b dc.b M128_q,comsep.b,M128_subs_a-*-2,M128_z */
/* QL: * subscript element graph */
/* QL: *sube_a dc.b septo.b,sube_c-*-1,M128_expr.l,sube_b-*-3,M128_z */
/* QL: *sube_b dc.b M128_q,septo.b,sube_c-*-2,M128_z */
/* QL: *sube_c dc.b M128_q,M128_expr.l,*-*,M128_z */
/* QL: * Literal graph table */
/* QL: M128_lit_a dc.b M128_ocb.s,M128_lit_b-*-1,M128_z */
M128_lit_a:
M128_dc_anchor_1137:
.byte (M128_ocb.s)&255
.byte (((M128_lit_b-M128_dc_anchor_1137)-1))&255
.byte (M128_z)&255
/* QL: M128_lit_b dc.b M128_expr.l,M128_lit_c-*-1,M128_lit.l,M128_lit_c-*-3,M128_z */
M128_lit_b:
M128_dc_anchor_1143:
.byte (M128_expr.l)&255
.byte (((M128_lit_c-M128_dc_anchor_1143)-1))&255
.byte (M128_lit.l)&255
.byte (((M128_lit_c-M128_dc_anchor_1143)-3))&255
.byte (M128_z)&255
/* QL: M128_lit_c dc.b M128_com.s,M128_lit_b-*-1,M128_ccb.s,*-*,M128_z */
M128_lit_c:
M128_dc_anchor_1151:
.byte (M128_com.s)&255
.byte (((M128_lit_b-M128_dc_anchor_1151)-1))&255
.byte (M128_ccb.s)&255
.byte ((M128_dc_anchor_1151-M128_dc_anchor_1151))&255
.byte (M128_z)&255
/* QL: tabset macro max */
/* QL: tab macro */
/* QL: tabend macro */
/* QL: * Keywords */
/* QL: pa_kytab tabset 31 ; Note we can ONLY have $1f keywords */
/* QL: [.lab] dc.b [max] */
pa_kytab:
M128_dc_anchor_1164:
.byte (31)&255
/* QL: k setstr k[.l] */
/* QL: kno setnum 0 */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1171:
.byte ((M128_k941-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1177:
.byte ((M128_k942-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1183:
.byte ((M128_k943-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1189:
.byte ((M128_k944-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1195:
.byte ((M128_k945-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1201:
.byte ((M128_k946-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1207:
.byte ((M128_k947-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1213:
.byte ((M128_k948-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1219:
.byte ((M128_k949-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1225:
.byte ((M128_k9410-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1231:
.byte ((M128_k9411-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1237:
.byte ((M128_k9412-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1243:
.byte ((M128_k9413-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1249:
.byte ((M128_k9414-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1255:
.byte ((M128_k9415-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1261:
.byte ((M128_k9416-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1267:
.byte ((M128_k9417-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1273:
.byte ((M128_k9418-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1279:
.byte ((M128_k9419-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1285:
.byte ((M128_k9420-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1291:
.byte ((M128_k9421-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1297:
.byte ((M128_k9422-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1303:
.byte ((M128_k9423-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1309:
.byte ((M128_k9424-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1315:
.byte ((M128_k9425-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1321:
.byte ((M128_k9426-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1327:
.byte ((M128_k9427-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1333:
.byte ((M128_k9428-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1339:
.byte ((M128_k9429-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1345:
.byte ((M128_k9430-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: plp maclab */
/* QL: kno setnum [kno]+1 */
/* QL:  dc.b [k][kno]-[.lab] */
M128_dc_anchor_1351:
.byte ((M128_k9431-pa_kytab))&255
/* QL:  ifnum [kno] < [max] goto plp */
/* QL: kno setnum 1 */
/* QL: kfoll setnum 0 */
/* QL:         tab     6 END FOR IF REPeat SELect WHEN 2 DEFine PROCedure FuNction */
/* QL: i setnum 0 */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: kfoll setnum [this] */
/* QL:  goto tlp  */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k941:
M128_dc_anchor_1373:
.byte (((3<<4)|6))&255
.byte 69,78,68
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k942:
M128_dc_anchor_1387:
.byte (((3<<4)|0))&255
.byte 70,79,82
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k943:
M128_dc_anchor_1401:
.byte (((2<<4)|0))&255
.byte 73,70
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k944:
M128_dc_anchor_1415:
.byte (((6<<4)|0))&255
.byte 82,69,80,101,97,116
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k945:
M128_dc_anchor_1429:
.byte (((6<<4)|0))&255
.byte 83,69,76,101,99,116
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k946:
M128_dc_anchor_1443:
.byte (((4<<4)|0))&255
.byte 87,72,69,78
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: kfoll setnum [this] */
/* QL:  goto tlp  */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k947:
M128_dc_anchor_1464:
.byte (((6<<4)|2))&255
.byte 68,69,70,105,110,101
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k948:
M128_dc_anchor_1478:
.byte (((9<<4)|0))&255
.byte 80,82,79,67,101,100,117,114,101
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k949:
M128_dc_anchor_1492:
.byte (((8<<4)|0))&255
.byte 70,117,78,99,116,105,111,110
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: tex maclab */
/* QL:         tab     2 GO TO SUB 1 WHEN ERRor GO GO */
/* QL: i setnum 0 */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: kfoll setnum [this] */
/* QL:  goto tlp  */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9410:
M128_dc_anchor_1519:
.byte (((2<<4)|2))&255
.byte 71,79
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9411:
M128_dc_anchor_1533:
.byte (((2<<4)|0))&255
.byte 84,79
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9412:
M128_dc_anchor_1547:
.byte (((3<<4)|0))&255
.byte 83,85,66
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: kfoll setnum [this] */
/* QL:  goto tlp  */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9413:
M128_dc_anchor_1568:
.byte (((4<<4)|1))&255
.byte 87,72,69,78
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9414:
M128_dc_anchor_1582:
.byte (((5<<4)|0))&255
.byte 69,82,82,111,114
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9415:
M128_dc_anchor_1596:
.byte (((2<<4)|0))&255
.byte 71,79
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9416:
M128_dc_anchor_1610:
.byte (((2<<4)|0))&255
.byte 71,79
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: tex maclab */
/* QL: * Next time we need keywords, replace the last pair above */
/* QL: * They used to be "END ERRor", and earlier "EOF INPUT"! */
/* QL: * Using "GO", which has already been parsed and rejected, saves 4 bytes. */
/* QL:         tab     RESTORE NEXT EXIT ELSE ON RETurn REMAINDER DATA DIM */
/* QL: i setnum 0 */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9417:
M128_dc_anchor_1633:
.byte (((7<<4)|0))&255
.byte 82,69,83,84,79,82,69
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9418:
M128_dc_anchor_1647:
.byte (((4<<4)|0))&255
.byte 78,69,88,84
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9419:
M128_dc_anchor_1661:
.byte (((4<<4)|0))&255
.byte 69,88,73,84
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9420:
M128_dc_anchor_1675:
.byte (((4<<4)|0))&255
.byte 69,76,83,69
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9421:
M128_dc_anchor_1689:
.byte (((2<<4)|0))&255
.byte 79,78
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9422:
M128_dc_anchor_1703:
.byte (((6<<4)|0))&255
.byte 82,69,84,117,114,110
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9423:
M128_dc_anchor_1717:
.byte (((9<<4)|0))&255
.byte 82,69,77,65,73,78,68,69,82
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9424:
M128_dc_anchor_1731:
.byte (((4<<4)|0))&255
.byte 68,65,84,65
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9425:
M128_dc_anchor_1745:
.byte (((3<<4)|0))&255
.byte 68,73,77
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: tex maclab */
/* QL:         tab     LOCal LET THEN STEP REMark MISTake */
/* QL: i setnum 0 */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9426:
M128_dc_anchor_1765:
.byte (((5<<4)|0))&255
.byte 76,79,67,97,108
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9427:
M128_dc_anchor_1779:
.byte (((3<<4)|0))&255
.byte 76,69,84
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9428:
M128_dc_anchor_1793:
.byte (((4<<4)|0))&255
.byte 84,72,69,78
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9429:
M128_dc_anchor_1807:
.byte (((4<<4)|0))&255
.byte 83,84,69,80
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9430:
M128_dc_anchor_1821:
.byte (((6<<4)|0))&255
.byte 82,69,77,97,114,107
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: this setstr [.parm([i])] */
/* QL:  ifnum [.len(this)] > 1 goto defit */
/* QL: defit maclab */
/* QL: [k][kno] dc.b [.len(this)]<<4![kfoll],'[this]' */
M128_k9431:
M128_dc_anchor_1835:
.byte (((7<<4)|0))&255
.byte 77,73,83,84,97,107,101
/* QL: kfoll setnum 0 */
/* QL: kno setnum [kno]+1 */
/* QL:  goto tlp */
/* QL: tlp maclab */
/* QL: i setnum [i]+1 */
/* QL:  ifnum [i] > [.nparms] goto tex */
/* QL: tex maclab */
/* QL:         tabend */
/* QL: k[kno] ds.b 0 */
M128_k32:
/* QL:         vect4000 M128_pa_expr */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ pa$expr,(M128_pa_expr-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
