/* ROM section pa_table */
.balign 2,0
/* QL: pa_table dc.l   pa_kytab,pa_grtab */
.balign 2,0
pa_table:
M129_dc_anchor_14:
.long pa_kytab
.long pa_grtab
/* QL:         vect4000 pa_table */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ pa$table,(pa_table-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
