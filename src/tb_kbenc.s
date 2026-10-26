/* ROM section tb_kbenc */
.balign 2,0
/* QL: * d1 -i o- 6 lsb are keyrow (5-3 column, 2-0 row), see below for output */
/* QL: * d2 -i  - 3 lsb SHIFT/CTRL/ALT */
/* QL: * a4 -ip - sysvar extension address */
/* QL: * a6 -ip - sysvar */
/* QL: * d0/d2 destroyed */
/* QL: * Direct return, CTRL in combination with one of space, TAB or ENTER: */
/* QL: * d1.w  0..11: bit 0 = ALT, bit 1 = SHIFT, bit 2 = TAB, bit 3 = ENTER */
/* QL: * Return + 2, normal characters: */
/* QL: * d1.w  msb 0 and lsb 8 bit char or ... */
/* QL: *       ... msb 8 bit char and lsb $ff if the ALT prefix ($ff) is required. */
/* QL: * Return + 4, ignore this (M186_compose first char stored or M186_compose aborted) */
/* QL: * d1.w  undefined */
/* QL: M186_do_ste */
M186_do_ste:
/* QL:         asr.b   #1,d1           take SHIFT back out */
    asr.b #1,d1
/* QL:         bcs.s   M186_qal1            if no SHIFT, we have the keycode now */
    bcs.s M186_qal1
/* QL:         move.b  M186_stetab-252(pc,d1.w),d1 space, TAB and ENTER to unshifted */
    move.b (M186_stetab-252)(pc,d1.w),d1
/* QL: M186_qal1 */
M186_qal1:
/* QL:         bra.s   M186_qalt            go add in the ALT stuff */
    bra.s M186_qalt
/* QL: M186_special */
M186_special:
/* QL:         bsr.s   M186_roll            M186_roll SHIFT into d1 lsb and lose sign */
    bsr.s M186_roll
/* QL:         bpl.s   M186_tryfx           still positive, try function keys */
    bpl.s M186_tryfx
/* QL:         add.b   d2,d2           do we have CTRL on? */
    add.b d2,d2
/* QL:         bcc.s   M186_do_ste          no - go do normal space/TAB/ENTER */
    bcc.s M186_do_ste
/* QL:         addq.b  #8,d1           make d1 = 0..5, M186_roll in ALT and direct return */
    addq.b #8,d1
/* QL: M186_roll */
M186_roll:
/* QL:         add.b   d2,d2           M186_roll one bit from d2 ... */
    add.b d2,d2
/* QL:         addx.b  d1,d1           ... into d1 */
    addx.b d1,d1
/* QL:         rts */
    rts 
/* QL: M186_tryfx */
M186_tryfx:
/* QL:         bsr.s   M186_roll            transfer CTRL into d1 lsb */
    bsr.s M186_roll
/* QL:         bmi.s   M186_qalt            that's the end for f1-f5 */
    bmi.s M186_qalt
/* QL:         bsr.s   M186_roll            transfer ALT into d1 lsb */
    bsr.s M186_roll
/* QL:         bmi.s   M186_simp1           the end for cursor keys and CAPSLOCK */
    bmi.s M186_simp1
/* QL:         asr.b   #1,d1           oops - it's actually ESC we're doing */
    asr.b #1,d1
/* QL:         roxr.b  #1,d2           so put the ALT flag back into d2 */
    roxr.b #1,d2
/* QL:         move.b  M186_esctab(pc,d1.w),d1 and get the right byte from the table */
    move.b M186_esctab(pc,d1.w),d1
/* QL:         bra.s   M186_qlck            go do capslock/ALT */
    bra.s M186_qlck
/* QL: tb_kbenc */
tb_kbenc:
/* QL:         ror.w   #3,d2           tuck away sca bits */
    ror.w #3,d2
/* QL:         smi     d0              remember SHIFT setting */
    smi d0
/* QL:         move.b  M186_sv_ichar(a6),d2 are we composing? */
    move.b M186_sv_ichar(a6),d2
/* QL:         beq.s   M186_noshf           no - carry on */
    beq.s M186_noshf
/* QL:         sf      M186_sv_ichar(a6)    drop the M186_compose flag */
    sf M186_sv_ichar(a6)
/* QL:         lsl.b   #7,d0           make 0 or $80 if SHIFT is on */
    lsl.b #7,d0
/* QL:         or.b    d0,d2           saved or this SHIFT will do for later */
    or.b d0,d2
/* QL:         asl.w   #3,d2           this junks SHIFT/CTRL/ALT */
    asl.w #3,d2
/* QL:         addq.b  #4,d2           and pretend SHIFT only is on */
    addq.b #4,d2
/* QL:         ror.w   #3,d2           tuck away sca = 100 */
    ror.w #3,d2
/* QL: M186_noshf */
M186_noshf:
/* QL:         ror.w   #8,d2           save M186_compose in msb */
    ror.w #8,d2
/* QL:         and.w   #$3f,d1 */
    and.w #0x3f,d1
/* QL:         move.b  M186_keytab(pc,d1.w),d1 */
    move.b M186_keytab(pc,d1.w),d1
/* QL:         bmi.s   M186_special */
    bmi.s M186_special
/* QL:         add.b   d2,d2           was SHIFT on? */
    add.b d2,d2
/* QL:         bcc.s   M186_nctrl           no - have a go at CTRL */
    bcc.s M186_nctrl
/* QL:         bsr.s   M186_toggle          form upper case letters and {|} */
    bsr.s M186_toggle
/* QL:         cmp.b   #'`'-32,d1      was that the right thing to do? */
    cmp.b #((96-32)&255),d1
/* QL:         bhi.s   M186_nctrl           yes - can look at CTRL now */
    bhi.s M186_nctrl
/* QL:         bne.s   M186_notilde         equality means is was a ` */
    bne.s M186_notilde
/* QL:         asr.b   #3,d1           turn the $40 into $08 (v. sneaky) */
    asr.b #3,d1
/* QL: M186_notilde */
M186_notilde:
/* QL:         move.b  M186_shftab(pc,d1.w),d1 */
    move.b M186_shftab(pc,d1.w),d1
/* QL: M186_nctrl */
M186_nctrl:
/* QL:         add.b   d2,d2           was CTRL on? */
    add.b d2,d2
/* QL:         bcc.s   M186_qlck            no - go sort out capslock/ALT */
    bcc.s M186_qlck
/* QL:         sub.b   #$60,d1         try normal CTRL/char */
    sub.b #(0x60&255),d1
/* QL:         bpl.s   M186_qalt            ok, go do ALT */
    bpl.s M186_qalt
/* QL:         add.b   #$c0,d1         others wanted + $60 */
    add.b #(0xc0&255),d1
/* QL: M186_qlck */
M186_qlck:
/* QL:         tst.b   M186_sv_caps(a6)     is capslock set */
    tst.b M186_sv_caps(a6)
/* QL:         beq.s   M186_qalt            no - skip this bit */
    beq.s M186_qalt
/* QL:         moveq   #'z'+1,d0 */
    moveq #(122+1),d0
/* QL:         bsr.s   M186_togq */
    bsr.s M186_togq
/* QL:         moveq   #$8c-256,d0 */
    moveq #(0x8c-256),d0
/* QL:         bsr.s   M186_togq */
    bsr.s M186_togq
/* QL: M186_qalt */
M186_qalt:
/* QL:         not.b   d2              was ALT on? */
    not.b d2
/* QL: M186_simp1 */
M186_simp1:
/* QL:         bmi     M186_simple          no - go finish off */
    bmi M186_simple
/* QL:         rol.w   #8,d1           put char into msb */
    rol.w #8,d1
/* QL:         st      d1              put $ff into lsb */
    st d1
/* QL:         addq.l  #2,(sp)         make a normal + 2 return */
    addq.l #2,(sp)
/* QL:         rts */
    rts 
/* QL: M186_togq */
M186_togq:
/* QL:         cmp.b   d0,d1           compare high end of range */
    cmp.b d0,d1
/* QL:         bcc.s   M186_togx            too big - no M186_toggle */
    bcc.s M186_togx
/* QL:         and.b   #$e1,d0         get low end of range */
    and.b #(0xe1&255),d0
/* QL:         cmp.b   d0,d1           compare low end of range */
    cmp.b d0,d1
/* QL:         bcs.s   M186_togx            too small - no M186_toggle */
    bcs.s M186_togx
/* QL: M186_toggle */
M186_toggle:
/* QL:         eor.b   #32,d1          flip upper/lower case bit */
    eor.b #(32&255),d1
/* QL: M186_togx */
M186_togx:
/* QL:         rts */
    rts 
/* QL: * ESC with optional SHIFT/CTRL */
/* QL: M186_esctab */
M186_esctab:
/* QL:  dc.b $1b,$80,$7f,$1f {s/}{c/}ESC -> ESC  etc */
M186_dc_anchor_439:
.byte (0x1b)&255
.byte (0x80)&255
.byte (0x7f)&255
.byte (0x1f)&255
/* QL: * Primary key translate... decrypt the keyrow and detect interesting keys. */
/* QL: * Simple keys sort of go direct to their proper unshifted ASCII code. */
/* QL: * Top bits are used to sort out M186_special cases. */
/* QL: M186_keytab equ *-3 first three not used       1   2   4   8  16  32  64  128 */
.equ M186_keytab,(.-3)
/* QL:  dc.b             $78,$76,$2f,$6e,$2c 7               x   v   /   n   , */
M186_dc_anchor_450:
.byte (0x78)&255
.byte (0x76)&255
.byte (0x2f)&255
.byte (0x6e)&255
.byte (0x2c)&255
/* QL:  dc.b $38,$32,$36,$71,$65,$30,$74,$75 6   8   2   6   q   e   0   t   u */
M186_dc_anchor_457:
.byte (0x38)&255
.byte (0x32)&255
.byte (0x36)&255
.byte (0x71)&255
.byte (0x65)&255
.byte (0x30)&255
.byte (0x74)&255
.byte (0x75)&255
/* QL:  dc.b $39,$77,$69,$fd,$72,$2d,$79,$6f 5   9   w   i  TAB  r   -   y   o */
M186_dc_anchor_467:
.byte (0x39)&255
.byte (0x77)&255
.byte (0x69)&255
.byte (0xfd)&255
.byte (0x72)&255
.byte (0x2d)&255
.byte (0x79)&255
.byte (0x6f)&255
/* QL:  dc.b $6c,$33,$68,$31,$61,$70,$64,$6a 4   l   3   h   1   a   p   d   j */
M186_dc_anchor_477:
.byte (0x6c)&255
.byte (0x33)&255
.byte (0x68)&255
.byte (0x31)&255
.byte (0x61)&255
.byte (0x70)&255
.byte (0x64)&255
.byte (0x6a)&255
/* QL:  dc.b $5b,$9c,$6b,$73,$66,$3d,$67,$3b 3  \{/ cap  k   s   f   =   g   ; */
M186_dc_anchor_487:
.byte (0x5b)&255
.byte (0x9c)&255
.byte (0x6b)&255
.byte (0x73)&255
.byte (0x66)&255
.byte (0x3d)&255
.byte (0x67)&255
.byte (0x3b)&255
/* QL:  dc.b $5d,$7a,$2e,$63,$62,$60,$6d,$27 2   ]   z   .   c   b   `   m   ' */
M186_dc_anchor_497:
.byte (0x5d)&255
.byte (0x7a)&255
.byte (0x2e)&255
.byte (0x63)&255
.byte (0x62)&255
.byte (0x60)&255
.byte (0x6d)&255
.byte (0x27)&255
/* QL:  dc.b $fe,$98,$9a,$80,$99,$5c,$fc,$9b 1  ent <-- /|\ ESC -->  \  spc \|/ */
M186_dc_anchor_507:
.byte (0xfe)&255
.byte (0x98)&255
.byte (0x9a)&255
.byte (0x80)&255
.byte (0x99)&255
.byte (0x5c)&255
.byte (0xfc)&255
.byte (0x9b)&255
/* QL:  dc.b $bd,$ba,$35,$bb,$bc,$be,$34,$37 0  f4  f1   5  f2  f3  f5   4   7 */
M186_dc_anchor_517:
.byte (0xbd)&255
.byte (0xba)&255
.byte (0x35)&255
.byte (0xbb)&255
.byte (0xbc)&255
.byte (0xbe)&255
.byte (0x34)&255
.byte (0x37)&255
/* QL: * the results from the table give us: */
/* QL: * miscellany    $27..$3d                $27 to $3d -> need 2nd table if SHIFT */
/* QL: * a..z+         $5b..$7d                $5b to $7a -> eor $20 if SHIFT */
/* QL: * ESC           $80                     $80(c),$7f(s),$1f(cs) or $1b */
/* QL: * cursor keys   $98,$99,$9a,$9b         $c0,$c8,$d0,$d8 + SHIFT/CTRL/ALT */
/* QL: * CAPSLOCK      $9c                     $e0 + SHIFT/CTRL/ALT */
/* QL: * f1-f5         $ba,$bb,$bc,$bd,$be     $e8,$ec,$f0,$f4,$f8 + SHIFT/CTRL */
/* QL: * space         $fc                     $fc(s) or $20 \ */
/* QL: * TAB           $fd                     $fd(s) or $09  > leave CTRL in d2 lsb */
/* QL: * ENTER         $fe                     $fe(s) or $0a / */
/* QL: * Unshifted space, TAB and ENTER */
/* QL: M186_stetab equ *+2  overlap with unused entries in M186_shftab */
.equ M186_stetab,(.+2)
/* QL: * Miscellany SHIFTed */
/* QL: M186_shftab equ *-7 */
.equ M186_shftab,(.-7)
/* QL:  dc.b $22 ' -> " */
M186_dc_anchor_543:
.byte (0x22)&255
/* QL:  dc.b $7e ` -> ~ (sneaky translate) */
M186_dc_anchor_546:
.byte (0x7e)&255
/* QL:  dc.b $20,$09,$0a (spare 3 bytes in mshift, reused for M186_stetab) */
M186_dc_anchor_549:
.byte (0x20)&255
.byte (0x09)&255
.byte (0x0a)&255
/* QL:  dc.b $3c,$5f,$3e,$3f ,-./ -> <_>? */
M186_dc_anchor_554:
.byte (0x3c)&255
.byte (0x5f)&255
.byte (0x3e)&255
.byte (0x3f)&255
/* QL:  dc.b $29,$21,$40,$23,$24,$25,$5e,$26,$2a,$28 0123456789 -> )!@#$%^&*( */
M186_dc_anchor_560:
.byte (0x29)&255
.byte (0x21)&255
.byte (0x40)&255
.byte (0x23)&255
.byte (0x24)&255
.byte (0x25)&255
.byte (0x5e)&255
.byte (0x26)&255
.byte (0x2a)&255
.byte (0x28)&255
/* QL:  ds.b 1 unused */
.space (1)*1,0
/* QL:  dc.b $3a ; -> : */
M186_dc_anchor_574:
.byte (0x3a)&255
/* QL:  ds.b 1 unused */
.space (1)*1,0
/* QL:  dc.b $2b = -> + */
M186_dc_anchor_579:
.byte (0x2b)&255
/* QL:  ds.w 0 */
.balign 2,0
/* QL: M186_compose */
M186_compose:
/* QL:         add.w   d2,d2           put SHIFT into bit 8 */
    add.w d2,d2
/* QL:         lsr.b   #1,d2           set M186_toggle flag = 0 */
    lsr.b #1,d2
/* QL:         addq.l  #2,(sp)         return + 2 if ready, + 4 if scrap or first */
    addq.l #2,(sp)
/* QL:         moveq   #M186_compfst-1,d0   table starts after lower case specials */
    moveq #(M186_compfst-1),d0
/* QL:         subq.b  #1,d2           is it our second character? */
    subq.b #1,d2
/* QL:         beq.s   M186_sing            no - go do the first char lookup */
    beq.s M186_sing
/* QL:         addq.b  #1,d2 */
    addq.b #1,d2
/* QL:         asl.w   #8,d1           put this char into msb */
    asl.w #8,d1
/* QL:         move.b  d2,d1 */
    move.b d2,d1
/* QL: M186_dual */
M186_dual:
/* QL:         addq.b  #2,d0 */
    addq.b #2,d0
/* QL:         bmi.s   M186_ret2 */
    bmi.s M186_ret2
/* QL: M186_chkswap */
M186_chkswap:
/* QL:         rol.w   #8,d1 */
    rol.w #8,d1
/* QL:         cmp.w   M186_comptab-1(pc,d0.w),d1 (n.b. d0 kept permanently odd) */
    cmp.w (M186_comptab-1)(pc,d0.w),d1
/* QL:         beq.s   M186_compok */
    beq.s M186_compok
/* QL:         not.b   d2              alternate swapping chars each time */
    not.b d2
/* QL:         bmi.s   M186_chkswap */
    bmi.s M186_chkswap
/* QL:         bra.s   M186_dual */
    bra.s M186_dual
/* QL: M186_sing */
M186_sing:
/* QL:         addq.b  #1,d0 */
    addq.b #1,d0
/* QL:         bmi.s   M186_ret2            no such char in M186_compose table */
    bmi.s M186_ret2
/* QL:         cmp.b   M186_comptab(pc,d0.w),d1 */
    cmp.b M186_comptab(pc,d0.w),d1
/* QL:         bne.s   M186_sing */
    bne.s M186_sing
/* QL:         tst.b   d1 */
    tst.b d1
/* QL:         bpl.s   M186_savec1          non-print (+ESC) are single char M186_compose */
    bpl.s M186_savec1
/* QL: M186_compok */
M186_compok:
/* QL:         ror.b   #1,d0           we have (cleverly) arranged d0 to be odd */
    ror.b #1,d0
/* QL:         move.w  d0,d1           (also gets rid of junk in top of d1) */
    move.w d0,d1
/* QL:         lsr.w   #1,d2           was SHIFT on for this (or prev) key ... */
    lsr.w #1,d2
/* QL:         or.b    M186_sv_caps(a6),d2  ... or is capslock on? */
    or.b M186_sv_caps(a6),d2
/* QL:         bmi.s   M186_ret0            yes - that's ok */
    bmi.s M186_ret0
/* QL:         moveq   #$ac-256,d0     is it $a0 to $ab? */
    moveq #(0xac-256),d0
/* QL:         bra     M186_togq            if so, this'll change it */
    bra M186_togq
/* QL: M186_savec1 */
M186_savec1:
/* QL:         asr.w   #1,d2           get out the SHIFT we kept in top of d2 */
    asr.w #1,d2
/* QL:         or.b    d2,d1           incorporate this char */
    or.b d2,d1
/* QL:         move.b  d1,M186_sv_ichar(a6) store it, then do an ignore return */
    move.b d1,M186_sv_ichar(a6)
/* QL: M186_ret2 */
M186_ret2:
/* QL:         addq.l  #2,(sp) */
    addq.l #2,(sp)
/* QL: M186_ret0 */
M186_ret0:
/* QL:         rts */
    rts 
/* QL: M186_simple */
M186_simple:
/* QL:         asr.w   #8,d2           are we composing? */
    asr.w #8,d2
/* QL:         bne.s   M186_compose         yes - go do it */
    bne.s M186_compose
/* QL:         moveq   #12,d2          counter and offset */
    moveq #12,d2
/* QL: M186_rdlp */
M186_rdlp:
/* QL:         subq.b  #1,d2 */
    subq.b #1,d2
/* QL:         bcs.s   M186_ret2            end of table, return normal */
    bcs.s M186_ret2
/* QL:         cmp.b   M186_sx_kbste(a4,d2.w),d1 */
    cmp.b M186_sx_kbste(a4,d2.w),d1
/* QL:         bne.s   M186_rdlp */
    bne.s M186_rdlp
/* QL:         move.w  d2,d1           found a match, M186_special return */
    move.w d2,d1
/* QL:         rts */
    rts 
/* QL: * The M186_compose table is byte pairs, which will be matched either way round. */
/* QL: * All entries are the SHIFT'ed characters, as this is forced while composing. */
/* QL: * The twelve entries that have lower case versions are changed back provided */
/* QL: * that capslock is not on and the SHIFT key was not held on either keypress. */
/* QL: M186_compfst equ     12*2    the first block (lower case) are not needed */
.equ M186_compfst,(12*2)
/* QL: M186_comptab equ     *-M186_compfst */
.equ M186_comptab,(.-M186_compfst)
/* QL:         dc.w    'A?A|A^E:E|E^I:I?I|I^O?O|O^U?U|U^SSC!Y_||' */
.balign 2,0
M186_dc_anchor_701:
.byte 65,63,65,124,65,94,69,58,69,124,69,94,73,58,73,63,73,124,73,94,79,63,79,124,79,94,85,63,85,124,85,94,83,83,67,33,89,95,124,124
.balign 2,0
/* QL:         dc.w    'A:A~AOE?O:O~O!U:C<N~AEOE' these may be "lower-case'ed" */
.balign 2,0
M186_dc_anchor_706:
.byte 65,58,65,126,65,79,69,63,79,58,79,126,79,33,85,58,67,60,78,126,65,69,79,69
.balign 2,0
/* QL:         dc.w    'AADDTTLLMMPIPH!!??TMPPOX<<>>OO:_',-60,-52,-44,-36 */
.balign 2,0
M186_dc_anchor_711:
.byte 65,65,68,68,84,84,76,76,77,77,80,73,80,72,33,33,63,63,84,77,80,80,79,88,60,60,62,62,79,79,58,95
.balign 2,0
.word ((-60))&65535
.word ((-52))&65535
.word ((-44))&65535
.word ((-36))&65535
/* QL: * N.B. Negative values in the above table (other than the convenient $ff, which */
/* QL: * never comes here) must be at odd addresses. They are single char compose. */
/* QL: * These are the space, TAB, ENTER, CAPSLOCK, ESC, function and cursor keys. */
/* QL: * Just the cursor keys are used at the moment (last 4 entries). */
/* QL: * Also, note that the following keys never occur in M186_compose sequences: */
/* QL: *       space, TAB, ENTER, CAPSLOCK, ESC, function keys and "23457890=[]'" */
/* QL: * This makes them abort the M186_compose immediately. Assigning one as the remapped */
/* QL: * M186_compose key makes a lot of sense... though this will lose it's function on */
/* QL: * the keyboard. The neatest ones would be either open or close square bracket. */
/* QL: * one other candidate for the M186_compose key is "`", which isn't used in basic. */
/* QL: * A word of warning... don't assign a 128-191 byte as the compose... you can */
/* QL: * get really stuck... */
/* QL:         end */
