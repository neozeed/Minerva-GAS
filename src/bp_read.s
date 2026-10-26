/* ROM section bp_read */
.balign 2,0
/* QL: * d0 -  o- error return (ccr set) */
/* QL: * a3 -ip - pointer to name table entry tested (a6 rel.) */
/* QL: bp_rdchk */
bp_rdchk:
/* QL:         move.b  0(a6,a3.l),d0   get usage byte */
    move.b 0(a6,a3.l),d0
/* QL:         beq.s   M47_unass           zero, so check for blank space */
    beq.s M47_unass
/* QL:         ror.b   #2,d0           bit 1 set implies type 2,3,6,7 - all ok */
    ror.b #2,d0
/* QL:         bpl.s   M47_err_bn          types not allowed... */
    bpl.s M47_err_bn
/* QL:         cmp.b   #M47_t.arr<<6,d0    is it an M47_array? */
    cmp.b #((M47_t.arr<<6)&255),d0
/* QL:         bne.s   M47_okrts           not an M47_array, so it's ok */
    bne.s M47_okrts
/* QL:         btst    #1,1(a6,a3.l)   check second byte */
    btst #1,1(a6,a3.l)
/* QL:         bne.s   M47_err_ni          fp or integer, so no go... */
    bne.s M47_err_ni
/* QL:         move.l  4(a6,a3.l),d0   we have a (sub-)string M47_array */
    move.l 4(a6,a3.l),d0
/* QL:         add.l   M47_bv_vvbas(a6),d0 */
    add.l M47_bv_vvbas(a6),d0
/* QL:         cmp.w   #1,M47_d_dims(a6,d0.l)   so is it only one dimensioned? */
    cmp.w #1,M47_d_dims(a6,d0.l)
/* QL:         beq.s   M47_okrts           yes, so allowed */
    beq.s M47_okrts
/* QL: M47_err_ni */
M47_err_ni:
/* QL:         moveq   #M47_err.ni,d0 */
    moveq #M47_err.ni,d0
/* QL:         rts */
    rts 
/* QL: M47_unass */
M47_unass:
/* QL:         moveq   #3,d0 */
    moveq #3,d0
/* QL:         and.b   1(a6,a3.l),d0   is entry completely blank? */
    and.b 1(a6,a3.l),d0
/* QL:         bne.s   M47_okrts           no, so must be unassigned - ok */
    bne.s M47_okrts
/* QL: M47_err_bn */
M47_err_bn:
/* QL:         moveq   #M47_err.bn,d0 */
    moveq #M47_err.bn,d0
/* QL:         rts */
    rts 
/* QL: * d0 error code */
/* QL: * d6 -1 while no M47_array block is allocated, otherwise vv offset to it */
/* QL: * d7 counter*8 of remaining args */
/* QL: * a3 nt pointer to argument being read */
/* QL: bp_read */
bp_read:
/* QL:         move.l  a5,d7 */
    move.l a5,d7
/* QL:         sub.l   a3,d7           counter */
    sub.l a3,d7
/* QL:         bra.s   M47_nx_arg */
    bra.s M47_nx_arg
/* QL: M47_go_arg */
M47_go_arg:
/* QL:         bsr.s   bp_arset        set up in case M47_array needs handling */
    bsr.s bp_arset
/* QL:         bsr.s   bp_rdchk        check that we can read into it (now) */
    bsr.s bp_rdchk
/* QL:         bne.s   M47_arend */
    bne.s M47_arend
/* QL: M47_nx_ind */
M47_nx_ind:
/* QL:         jsr     bp_data(pc)     get the next data item */
    jsr bp_data(pc)
/* QL:         bne.s   M47_arend */
    bne.s M47_arend
/* QL:         addq.b  #1,M47_bv_daitm(a6) good, so move on next time */
    addq.b #1,M47_bv_daitm(a6)
/* QL:         bsr.l   bp_arind        set nt entry for M47_array element */
    bsr.w bp_arind
/* QL:         move.b  1(a6,a3.l),d0   what are we reading */
    move.b 1(a6,a3.l),d0
/* QL:         sub.l   M47_bv_ntbas(a6),a3 */
    sub.l M47_bv_ntbas(a6),a3
/* QL:         move.l  a3,-(sp) */
    move.l a3,-(sp)
/* QL:         jsr     ca_eval(pc)     read expression */
    jsr ca_eval(pc)
/* QL:         move.l  (sp)+,a3 */
    move.l (sp)+,a3
/* QL:         add.l   M47_bv_ntbas(a6),a3 */
    add.l M47_bv_ntbas(a6),a3
/* QL:         ble.s   M47_arend           evaluation error */
    ble.s M47_arend
/* QL:         jsr     bp_let(pc)      do the assignment */
    jsr bp_let(pc)
/* QL:         bsr.s   bp_arnxt        step M47_array elements */
    bsr.s bp_arnxt
/* QL:         bgt.s   M47_nx_ind          more elements, so carry on */
    bgt.s M47_nx_ind
/* QL: M47_arend */
M47_arend:
/* QL:         bsr.s   bp_arend        discard any M47_array index block */
    bsr.s bp_arend
/* QL:         bne.s   M47_rts0 */
    bne.s M47_rts0
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL:         subq.l  #8,d7 */
    subq.l #8,d7
/* QL: M47_nx_arg */
M47_nx_arg:
/* QL:         bne.s   M47_go_arg */
    bne.s M47_go_arg
/* QL: M47_okrts */
M47_okrts:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL: M47_rts0 */
M47_rts0:
/* QL:         rts */
    rts 
/* QL: * Arrays (other than singly dimensioned (sub-)string ones) are handled by */
/* QL: * allocating a temporary vv structure. A dummy singly dimensioned M47_array */
/* QL: * descriptor is constructed here, followed by the original descriptor offset, */
/* QL: * and thereafter words contain the current indices. */
/* QL: * The step size in the dummy descriptor is not relevent. */
/* QL: * For strings and substrings, the vv offset to this structure, and hence to the */
/* QL: * dummy descriptor replaces the vv pointer in the nt entry. */
/* QL: * For integer and fp arrays, the nt entry is modified to suggest that a M47_simple */
/* QL: * variable is being accessed, and its vv pointer tracks through the array. */
/* QL: * Constructing the dummy descriptor for int/fp is somewhat redundant, but */
/* QL: * simplifies the code rather a lot! */
/* QL: * Start up for possible elements of an M47_array (N.B. VV allocation may be done) */
/* QL: * d0 -i o- unchanged if no M47_array set up, or set to zero */
/* QL: * d6 -  o- -1 or M47_array index block vv offset (ccr set) */
/* QL: * a3 -ip - nt pointer to argument under examination */
/* QL: * d0-d3/a1 destroyed */
/* QL: bp_arset */
bp_arset:
/* QL:         cmp.b   #M47_t.arr,0(a6,a3.l) are we about to operate on an M47_array? */
    cmp.b #(M47_t.arr&255),0(a6,a3.l)
/* QL:         bne.s   M47_simple          no - so just do a M47_simple argument */
    bne.s M47_simple
/* QL:         move.l  4(a6,a3.l),d3   get vv offset to M47_array descriptor */
    move.l 4(a6,a3.l),d3
/* QL:         add.l   M47_bv_vvbas(a6),d3 make pointer to descriptor */
    add.l M47_bv_vvbas(a6),d3
/* QL:         bsr.s   M47_tsttype         check for (sub-)string */
    bsr.s M47_tsttype
/* QL:         bcs.s   M47_intfp           int/fp must always be done  */
    bcs.s M47_intfp
/* QL:         cmp.w   #1,M47_d_dims(a6,d3.l) check dimensionality */
    cmp.w #1,M47_d_dims(a6,d3.l)
/* QL:         bne.s   M47_array           single dimension, i.e.(sub-)string, we can do */
    bne.s M47_array
/* QL: M47_simple */
M47_simple:
/* QL:         moveq   #-1,d6          we haven't set up an M47_array struct */
    moveq #(-1),d6
/* QL:         rts */
    rts 
/* QL: * Step to next of possible elements of an M47_array */
/* QL: * ccr-  o- lt or mi: not M47_array, eq: end M47_array, gt: still going */
/* QL: * d0 -i o- unchanged if not an M47_array, set to zero at end or 2*indices left */
/* QL: * d6 -  o- -1 or M47_array index block vv offset */
/* QL: * a3 -ip - nt pointer to argument under examination */
/* QL: * d1-d3 destroyed */
/* QL: bp_arnxt */
bp_arnxt:
/* QL:         bsr.s   M47_pickup          are we doing an M47_array? */
    bsr.s M47_pickup
/* QL:         bmi.s   M47_rts5            no - just say we've finished */
    bmi.s M47_rts5
/* QL:         add.l   d1,d2           point past counter for index */
    add.l d1,d2
/* QL:         add.l   d1,d3 */
    add.l d1,d3
/* QL:         add.l   d1,d3           point at max for index */
    add.l d1,d3
/* QL:         bsr.s   M47_tsttype         check type */
    bsr.s M47_tsttype
/* QL:         bcc.s   M47_dec_str         skip back one subscript for (sub-)strings */
    bcc.s M47_dec_str
/* QL: M47_cn_inc */
M47_cn_inc:
/* QL:         move.w  M47_d_max-4(a6,d3.l),d0 get max for this dimension */
    move.w (M47_d_max-4)(a6,d3.l),d0
/* QL:         addq.w  #1,M47_d_index-2(a6,d2.l) update count */
    addq.w #1,(M47_d_index-2)(a6,d2.l)
/* QL:         cmp.w   M47_d_index-2(a6,d2.l),d0 has current count gone past max? */
    cmp.w (M47_d_index-2)(a6,d2.l),d0
/* QL:         bcc.s   M47_nxt_ex          no - do this one */
    bcc.s M47_nxt_ex
/* QL:         clr.w   M47_d_index-2(a6,d2.l) reset count to zero */
    clr.w (M47_d_index-2)(a6,d2.l)
/* QL: M47_dec_str */
M47_dec_str:
/* QL:         subq.l  #4,d3 */
    subq.l #4,d3
/* QL:         subq.l  #2,d2 */
    subq.l #2,d2
/* QL:         subq.w  #2,d1           count off this index */
    subq.w #2,d1
/* QL:         bne.s   M47_cn_inc          and try again (if not dropping off the front) */
    bne.s M47_cn_inc
/* QL: M47_nxt_ex */
M47_nxt_ex:
/* QL:         move.l  d1,d0           set ccr and d0.l=0 at end */
    move.l d1,d0
/* QL: M47_rts5 */
M47_rts5:
/* QL:         rts */
    rts 
/* QL: * Finished with M47_array index block */
/* QL: * d0 -ip - error code, ccr set */
/* QL: * d6 -ip - -1 or M47_array index block vv offset */
/* QL: * d1-d3/a1 destroyed */
/* QL: bp_arend */
bp_arend:
/* QL:         bsr.s   M47_pickup */
    bsr.s M47_pickup
/* QL:         bpl.s   M47_frvv */
    bpl.s M47_frvv
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: M47_intfp */
M47_intfp:
/* QL:         subq.b  #M47_t.arr-M47_t.var,0(a6,a3.l) convert int/fp from M47_array to M47_simple var */
    subq.b #(M47_t.arr-M47_t.var),0(a6,a3.l)
/* QL: M47_array */
M47_array:
/* QL:         bsr.s   M47_cn_len */
    bsr.s M47_cn_len
/* QL:         sub.l   M47_bv_ntbas(a6),a3 */
    sub.l M47_bv_ntbas(a6),a3
/* QL:         lea     bv_alvvz(pc),a1 */
    lea bv_alvvz(pc),a1
/* QL:         bsr.s   M47_callit */
    bsr.s M47_callit
/* QL:         add.l   M47_bv_ntbas(a6),a3 */
    add.l M47_bv_ntbas(a6),a3
/* QL:         move.l  4(a6,a3.l),M47_d_oldvv(a6,d2.l) save original descriptor offset */
    move.l 4(a6,a3.l),M47_d_oldvv(a6,d2.l)
/* QL:         addq.w  #1,M47_d_dims(a6,d2.l) dimensionality set to one (rdchk needs it) */
    addq.w #1,M47_d_dims(a6,d2.l)
/* QL:         move.l  d2,d6 */
    move.l d2,d6
/* QL:         sub.l   M47_bv_vvbas(a6),d6 */
    sub.l M47_bv_vvbas(a6),d6
/* QL:         move.l  d6,4(a6,a3.l)   replace vv offset to go to our dummy descriptor */
    move.l d6,4(a6,a3.l)
/* QL:         rts */
    rts 
/* QL: M47_tsttype */
M47_tsttype:
/* QL:         move.b  1(a6,a3.l),d0 */
    move.b 1(a6,a3.l),d0
/* QL:         rol.b   #7,d0           check type */
    rol.b #7,d0
/* QL:         rts */
    rts 
/* QL: M47_pickup */
M47_pickup:
/* QL:         move.l  d6,d2 */
    move.l d6,d2
/* QL:         bmi.s   M47_rts7 */
    bmi.s M47_rts7
/* QL:         move.l  M47_bv_vvbas(a6),d3 */
    move.l M47_bv_vvbas(a6),d3
/* QL:         add.l   d3,d2           point at out index block */
    add.l d3,d2
/* QL:         add.l   M47_d_oldvv(a6,d2.l),d3 point at original descriptor */
    add.l M47_d_oldvv(a6,d2.l),d3
/* QL: M47_cn_len */
M47_cn_len:
/* QL:         moveq   #2,d1           in words (last unused for (sub-)strings) */
    moveq #2,d1
/* QL:         mulu    M47_d_dims(a6,d3.l),d1 no of dimensions */
    mulu M47_d_dims(a6,d3.l),d1
/* QL: M47_rts7 */
M47_rts7:
/* QL:         rts */
    rts 
/* QL: M47_frvv */
M47_frvv:
/* QL:         move.l  M47_d_oldvv(a6,d2.l),4(a6,a3.l) restore original vv ptr into nt */
    move.l M47_d_oldvv(a6,d2.l),4(a6,a3.l)
/* QL:         move.b  #M47_t.arr,0(a6,a3.l)   restore M47_array type (for int/fp) */
    move.b #(M47_t.arr&255),0(a6,a3.l)
/* QL:         lea     bv_frvv(pc),a1  preserves d0.l and sets ccr from it */
    lea bv_frvv(pc),a1
/* QL: M47_callit */
M47_callit:
/* QL:         exg     a0,d2           swap a0 with d2 */
    exg a0,d2
/* QL:         add.w   #M47_d_index,d1     include dummy 1-dim desc and old descr pointer */
    add.w #M47_d_index,d1
/* QL:         jsr     (a1)            (note we can get away with add.w, as d1<16384) */
    jsr (a1)
/* QL:         exg     a0,d2           restore a0 */
    exg a0,d2
/* QL:         rts */
    rts 
/* QL: * Index possible elements of an M47_array */
/* QL: * d6 -  o- -1 or M47_array index block vv offset */
/* QL: * a3 -ip - nt pointer to argument under examination */
/* QL: * d0-d3/a1 destroyed */
/* QL: bp_arind */
bp_arind:
/* QL:         bsr.s   M47_pickup */
    bsr.s M47_pickup
/* QL:         bmi.s   M47_rts9 */
    bmi.s M47_rts9
/* QL: * Calculate position of next element in M47_array */
/* QL:         sub.l   a1,a1           element offset zero */
    sub.l a1,a1
/* QL:         add.l   d1,d3 */
    add.l d1,d3
/* QL:         add.l   d1,d3           temporarily shift descriptor pointer by 4*n */
    add.l d1,d3
/* QL:         move.w  M47_d_max-4(a6,d3.l),M47_d_max(a6,d2.l) copy last max for (sub-)strings */
    move.w (M47_d_max-4)(a6,d3.l),M47_d_max(a6,d2.l)
/* QL:         add.l   d1,d2           temporarily shift counter pointer by 2*n */
    add.l d1,d2
/* QL: M47_nx_dim */
M47_nx_dim:
/* QL:         subq.l  #2,d2           move counter pointer back */
    subq.l #2,d2
/* QL:         move.w  M47_d_index(a6,d2.l),d0 get count of index */
    move.w M47_d_index(a6,d2.l),d0
/* QL:         subq.l  #4,d3           move descriptor pointer back */
    subq.l #4,d3
/* QL:         mulu    M47_d_step(a6,d3.l),d0 multiplier */
    mulu M47_d_step(a6,d3.l),d0
/* QL:         add.l   d0,a1           move element offset on for this dimension */
    add.l d0,a1
/* QL:         subq.w  #2,d1           move back one dimension */
    subq.w #2,d1
/* QL:         bne.s   M47_nx_dim          drop out when d6/d3 are back to start */
    bne.s M47_nx_dim
/* QL:         move.l  M47_d_vvptr(a6,d3.l),d1 get vv offset to indexed value */
    move.l M47_d_vvptr(a6,d3.l),d1
/* QL:         bsr.s   M47_tsttype         check type */
    bsr.s M47_tsttype
/* QL:         bcc.s   M47_add_ok          (sub-)strings are ready to have dummy set up */
    bcc.s M47_add_ok
/* QL:         add.l   a1,a1           x 2 does for integers */
    add.l a1,a1
/* QL:         bmi.s   M47_bendptr         so they're ready here */
    bmi.s M47_bendptr
/* QL:         add.l   a1,d1 */
    add.l a1,d1
/* QL:         add.l   a1,a1           x 6 for f.p. */
    add.l a1,a1
/* QL: M47_bendptr */
M47_bendptr:
/* QL:         moveq   #4-M47_d_vvptr,d2 */
    moveq #(4-M47_d_vvptr),d2
/* QL:         add.l   a3,d2           bend pointer appropriatly at nt entry */
    add.l a3,d2
/* QL: M47_add_ok */
M47_add_ok:
/* QL:         add.l   d1,a1           form vv offset to indexed value */
    add.l d1,a1
/* QL:         move.l  a1,M47_d_vvptr(a6,d2.l) set offset in dummy descriptor or nt entry */
    move.l a1,M47_d_vvptr(a6,d2.l)
/* QL: M47_rts9 */
M47_rts9:
/* QL:         rts */
    rts 
/* QL:         end */
