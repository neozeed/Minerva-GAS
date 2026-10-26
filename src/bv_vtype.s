/* ROM section bv_vtype */
.balign 2,0
/* QL: * Central code for setting a variable's type */
/* QL: * d0 -  o- pointer to last byte of name */
/* QL: * d1 -  o- type 1, 2 or 3 for str$, fp or int% */
/* QL: * a2 -ip - name table entry. byte 0 cleared, byte 1 set to type */
/* QL: bv_vtype */
bv_vtype:
/* QL:         moveq   #0,d0 */
    moveq #0,d0
/* QL:         move.w  2(a6,a2.l),d0   get namelist offset */
    move.w 2(a6,a2.l),d0
/* QL:         add.l   M72_bv_nlbas(a6),d0 point at it */
    add.l M72_bv_nlbas(a6),d0
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         move.b  0(a6,d0.l),d1   number of chars in name */
    move.b 0(a6,d0.l),d1
/* QL:         add.w   d1,d0           point to last char */
    add.w d1,d0
/* QL:         moveq   #'%',d1 */
    moveq #37,d1
/* QL:         sub.b   0(a6,d0.l),d1   examine last character */
    sub.b 0(a6,d0.l),d1
/* QL:         bhi.s   M72_nt_set          if '$', d1='%'-'$'=1 for string */
    bhi.s M72_nt_set
/* QL:         sne     d1              if '%', d1=0+3=3 for integer */
    sne d1
/* QL:         addq.b  #3,d1           others, d1=-1+3=2 for floating point */
    addq.b #3,d1
/* QL: M72_nt_set */
M72_nt_set:
/* QL:         move.w  d1,0(a6,a2.l)   unset usage and set type */
    move.w d1,0(a6,a2.l)
/* QL:         rts */
    rts 
/* QL:         end */
