/* ROM section mt_lxint */
.balign 2,0
/* QL: * d0 -i o- trap code / 0 */
/* QL: * a0 -ip - absolute pointer to item */
/* QL: * a1 -  o- pointer to start of linked list */
/* QL: mt_lxint */
mt_lxint:
/* QL: mt_lpoll */
mt_lpoll:
/* QL: mt_lschd */
mt_lschd:
/* QL: mt_liod */
mt_liod:
/* QL: mt_ldd */
mt_ldd:
/* QL:         add.w   d0,d0 */
    add.w d0,d0
/* QL:         lea     M35_sv_i2lst-2*M35_mt.lxint(a6,d0.w),a1 */
    lea (M35_sv_i2lst-(2*M35_mt.lxint))(a6,d0.w),a1
/* QL:         move.l  (a1),(a0)       put pointer to next in this item */
    move.l (a1),(a0)
/* QL:         move.l  a0,(a1)         and link it in (used to use ut_link) */
    move.l a0,(a1)
/* QL:         bra.s   M35_exit */
    bra.s M35_exit
/* QL: * d0 -i o- trap code / 0 */
/* QL: * a0 -ip - absolute pointer to item */
/* QL: * a1 -  o- pointer to prior entry or zero if the item was not on the list! */
/* QL: mt_rxint */
mt_rxint:
/* QL: mt_rpoll */
mt_rpoll:
/* QL: mt_rschd */
mt_rschd:
/* QL: mt_riod */
mt_riod:
/* QL: mt_rdd */
mt_rdd:
/* QL:         add.w   d0,d0 */
    add.w d0,d0
/* QL:         lea     M35_sv_i2lst-2*M35_mt.rxint(a6,d0.w),a1 */
    lea (M35_sv_i2lst-(2*M35_mt.rxint))(a6,d0.w),a1
/* QL:         jsr     ut_unlnk(pc) */
    jsr ut_unlnk(pc)
/* QL: M35_exit */
M35_exit:
/* QL:         jmp     ss_noer(pc) */
    jmp ss_noer(pc)
/* QL:         end */
