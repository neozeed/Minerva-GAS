/* ROM section tb_multi */
.balign 2,0
/* QL:         ds.b    1               padding */
.space (1)*1,0
/* QL: tb_multi */
tb_multi:
/* QL:         dc.b    -1              serial channel $ff prefix */
M185_dc_anchor_106:
.byte ((-1))&255
/* QL:         dc.l    tb_multx-M185_multi  length of code */
.balign 2,0
M185_dc_anchor_110:
.long (tb_multx-M185_multi)
/* QL:         dc.b    0               access code (unused) */
M185_dc_anchor_113:
.byte (0)&255
/* QL:         dc.b    1               executeable */
M185_dc_anchor_116:
.byte (1)&255
/* QL:         dc.l    M185_base+M185_area-tb_multx data space */
.balign 2,0
M185_dc_anchor_120:
.long ((M185_base+M185_area)-tb_multx)
/* QL:         dc.l    0               extra */
.balign 2,0
M185_dc_anchor_124:
.long 0
/* QL: M185_multi */
M185_multi:
/* QL:         moveq   #M185_mt.inf,d0      get our job number */
    moveq #M185_mt.inf,d0
/* QL:         trap    #1 */
    trap #1
/* QL:         bra.s   M185_base            go start setting up */
    bra.s M185_base
/* QL:         dc.w    $4afb,M185_nmex-M185_name */
.balign 2,0
M185_dc_anchor_136:
.word 0x4afb
.word ((M185_nmex-M185_name))&65535
/* QL: M185_name */
M185_name:
/* QL:         dc.b    'SB.' we append our job number to this */
M185_dc_anchor_142:
.byte 83,66,46
/* QL: M185_nmex    ds.b    0 */
M185_nmex:
/* QL:         ds.w    0 */
.balign 2,0
/* QL: M185_base */
M185_base:
/* QL:         move.l  M185_sv_progd(a0),a3 we may like to use the prog_use prefix */
    move.l M185_sv_progd(a0),a3
/* QL:         moveq   #0,d6 */
    moveq #0,d6
/* QL:         move.w  d1,d6           we'll use this in case we default setup */
    move.w d1,d6
/* QL:         divu    #2*M185_n,d6         job mod possible default windows */
    divu #(2*M185_n),d6
/* QL:         swap    d6 */
    swap d6
/* QL:         move.w  #M185_name-M185_multi,a0 */
    move.w #(M185_name-M185_multi),a0
/* QL:         add.w   -2(a6,a0.l),a0 */
    add.w (-2)(a6,a0.l),a0
/* QL:         move.w  #M185_tables-2,a1    we will overwrite our code */
    move.w #(M185_tables-2),a1
/* QL:         move.w  M185_cn.itod,a2 */
    move.w M185_cn.itod,a2
/* QL:         move.w  d1,0(a6,a1.l) */
    move.w d1,0(a6,a1.l)
/* QL: * NB. This had better be >= M185_multi+M185_tables now! */
/* QL:         jsr     (a2)            extend job M185_name with job number */
    jsr (a2)
/* QL:         add.w   d1,M185_name-2-M185_multi(a6) a little used fact: d1 returns char count! */
    add.w d1,((M185_name-2)-M185_multi)(a6)
/* QL:         move.l  a1,(a6)         put table offset at start of job + 2 */
    move.l a1,(a6)
/* QL:         add.l   a1,a6           push on past M185_base of our transient M185_area */
    add.l a1,a6
/* QL:         sub.l   a1,a5           discount it from the data M185_area */
    sub.l a1,a5
/* QL:         tst.l   (sp)            have we been given anything at all? */
    tst.l (sp)
/* QL:         bne.s   M185_useit           yes - they've got TK2 or somesuch */
    bne.s M185_useit
/* QL: * Zilch being passed in, so let's be nice, and give them some defaults */
/* QL:         moveq   #32,d1 */
    moveq #32,d1
/* QL:         lsr.w   #1,d6 */
    lsr.w #1,d6
/* QL:         bcc.s   M185_xset */
    bcc.s M185_xset
/* QL:         lsl.w   #3,d1 32<<3=256 x position 32(even)/256(odd) */
    lsl.w #3,d1
/* QL: M185_xset */
M185_xset:
/* QL: M185_h       equ     (200/M185_n-3)/10*10+3 height of windows, including border */
.equ M185_h,(((((200/M185_n)-3)/10)*10)+3)
/* QL: M185_g       equ     (202-M185_h*M185_n)/(M185_n+1) gaps between windows */
.equ M185_g,((202-(M185_h*M185_n))/(M185_n+1))
/* QL:         mulu    #M185_h+M185_g,d6 */
    mulu #(M185_h+M185_g),d6
/* QL:         add.w   #16+(200-M185_h*M185_n-M185_g*(M185_n-1))/2,d6 top window y position */
    add.w #(16+(((200-(M185_h*M185_n))-(M185_g*(M185_n-1)))/2)),d6
/* QL:         move.w  d6,(sp)         set y */
    move.w d6,(sp)
/* QL:         move.w  d1,-(sp)        set x */
    move.w d1,-(sp)
/* QL:         move.l  #222<<16!M185_h,-(sp) set width and height */
    move.l #((222<<16)|M185_h),-(sp)
/* QL:         move.l  #$ff010207,-(sp) set border colour/width, paper and ink */
    move.l #0xff010207,-(sp)
/* QL:         move.l  sp,a1 */
    move.l sp,a1
/* QL:         move.w  M185_ut.con,a2 */
    move.w M185_ut.con,a2
/* QL:         jsr     (a2) */
    jsr (a2)
/* QL:         bne.s   M185_err */
    bne.s M185_err
/* QL:         addq.l  #8,sp */
    addq.l #8,sp
/* QL:         move.l  a0,(sp) */
    move.l a0,(sp)
/* QL:         move.w  #1,-(sp) */
    move.w #1,-(sp)
/* QL:         bra.s   M185_nochan */
    bra.s M185_nochan
/* QL: M185_useit */
M185_useit:
/* QL:         move.l  sp,a4 */
    move.l sp,a4
/* QL:         moveq   #0,d4 */
    moveq #0,d4
/* QL:         move.w  (a4)+,d4        pick up channel count */
    move.w (a4)+,d4
/* QL:         lsl.l   #2,d4 */
    lsl.l #2,d4
/* QL:         add.l   d4,a4           move on past them */
    add.l d4,a4
/* QL:         move.l  a4,a2           remember start of command string */
    move.l a4,a2
/* QL:         move.w  (a4)+,d4        get command string length */
    move.w (a4)+,d4
/* QL:         cmp.b   #M185_rom,-1(a4,d4.w) are we being asked not to do M185_rom names? */
    cmp.b #(M185_rom&255),(-1)(a4,d4.w)
/* QL:         seq     d5 */
    seq d5
/* QL:         ext.w   d5 */
    ext.w d5
/* QL:         add.w   d5,d4           no - set a zero */
    add.w d5,d4
/* QL:         move.w  d4,(a2)         yes - lose the byte and leave a minus one */
    move.w d4,(a2)
/* QL: M185_sclp */
M185_sclp:
/* QL:         subq.w  #1,d4 */
    subq.w #1,d4
/* QL:         bcs.s   M185_nochan          didn't find our M185_file marker */
    bcs.s M185_nochan
/* QL:         cmp.b   #M185_file,(a4)+     is this our M185_file marker? */
    cmp.b #(M185_file&255),(a4)+
/* QL:         bne.s   M185_sclp            no - keep looking */
    bne.s M185_sclp
/* QL: * File marker found, d4 has remaining string length */
/* QL:         sub.w   d4,(a2)         the filename length plus the M185_file marker */
    sub.w d4,(a2)
/* QL:         subq.w  #1,(a2)         so this is the filename length */
    subq.w #1,(a2)
/* QL:         move.l  a2,a0           set filename start */
    move.l a2,a0
/* QL:         bsr.s   M185_open            try to M185_open plain M185_name */
    bsr.s M185_open
/* QL:         beq.s   M185_gotit           if ok, go use it */
    beq.s M185_gotit
/* QL:         move.l  a6,a0           fill it in down where out M185_tables will go */
    move.l a6,a0
/* QL:         moveq   #127,d2         silly upper limit on M185_file M185_name */
    moveq #127,d2
/* QL:         move.w  d2,(a0)+        first put in the limit value */
    move.w d2,(a0)+
/* QL:         bsr.s   M185_concat          start with the default prefix */
    bsr.s M185_concat
/* QL: * Upper limit on M185_file M185_name is really (*-M185_base-2), but that's more than 127! */
/* QL:         move.l  a2,a3 */
    move.l a2,a3
/* QL:         bsr.s   M185_concat          then add the plain M185_name */
    bsr.s M185_concat
/* QL:         move.l  a6,a0 */
    move.l a6,a0
/* QL:         sub.w   d2,(a0)         this is now the concatenated M185_name length */
    sub.w d2,(a0)
/* QL:         bsr.s   M185_open            try to M185_open prefixed M185_name */
    bsr.s M185_open
/* QL:         bne.s   M185_err             no good, so we'll have to die! */
    bne.s M185_err
/* QL: M185_gotit */
M185_gotit:
/* QL:         move.w  d4,(a2)+        cut string length back to what's left */
    move.w d4,(a2)+
/* QL: M185_shlp */
M185_shlp:
/* QL:         subq.b  #1,d4 */
    subq.b #1,d4
/* QL:         bcs.s   M185_basic */
    bcs.s M185_basic
/* QL:         move.b  (a4)+,(a2)+     copy remaining command string down */
    move.b (a4)+,(a2)+
/* QL:         bra.s   M185_shlp */
    bra.s M185_shlp
/* QL: M185_nochan */
M185_nochan:
/* QL:         sub.l   a0,a0           no command channel */
    sub.l a0,a0
/* QL: M185_basic */
M185_basic:
/* QL:         move.w  d5,a1           set inherit(0) or M185_rom(-ve) names */
    move.w d5,a1
/* QL:         move.w  M185_sb.start,a2     get entry vector */
    move.w M185_sb.start,a2
/* QL:         jmp     $4000(a2)       a0/a5-a7 are set, so run off to M185_basic! */
    jmp 0x4000(a2)
/* QL: M185_open */
M185_open:
/* QL:         moveq   #-1,d1          we'll own it */
    moveq #(-1),d1
/* QL:         moveq   #M185_io.open,d0 */
    moveq #M185_io.open,d0
/* QL:         moveq   #M185_io.share,d3 */
    moveq #M185_io.share,d3
/* QL:         trap    #2 */
    trap #2
/* QL:         move.l  d0,d3           was the M185_file opened ok? */
    move.l d0,d3
/* QL:         rts */
    rts 
/* QL: M185_concat */
M185_concat:
/* QL:         move.w  (a3)+,d0        get length */
    move.w (a3)+,d0
/* QL:         sub.w   d0,d2 */
    sub.w d0,d2
/* QL:         bge.s   M185_ccent */
    bge.s M185_ccent
/* QL: M185_err */
M185_err:
/* QL:         moveq   #-1,d1          ourself */
    moveq #(-1),d1
/* QL:         moveq   #M185_mt.frjob,d0    force remove job */
    moveq #M185_mt.frjob,d0
/* QL:         trap    #1 */
    trap #1
/* QL: M185_pcopy */
M185_pcopy:
/* QL:         move.b  (a3)+,(a0)+ */
    move.b (a3)+,(a0)+
/* QL: M185_ccent */
M185_ccent:
/* QL:         dbra    d0,M185_pcopy */
    dbra d0,M185_pcopy
/* QL:         rts */
    rts 
/* QL: tb_multx */
tb_multx:
/* QL:         end */
