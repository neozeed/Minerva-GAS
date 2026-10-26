/* ROM section pa_code */
.balign 2,0
/* QL: * Except where otherwise stated, all the routines operate as follows: */
/* QL: * M134_return immediate if not recognised, or + 2 if sucessfully tokenised. */
/* QL: * a0 -i o- input text pointer (undefined on immediate M134_return) */
/* QL: * a6 -ip - the base of basic */
/* QL: * d0-d6/a1-a3 destroyed */
/* QL: * Tokenise spaces - always suceeds and returns immediate */
/* QL: * a0 -i o- pointer to input text buffer */
/* QL: * a6 -ip - the base of basic */
/* QL: * d0-d5/a3 destroyed */
/* QL: pa_cdspc */
pa_cdspc:
/* QL:         moveq   #' ',d1 */
    moveq #32,d1
/* QL:         cmp.b   0(a6,a0.l),d1   any spaces at all? */
    cmp.b 0(a6,a0.l),d1
/* QL:         bne.s   M134_rts0            no - make a quick return... speed */
    bne.s M134_rts0
/* QL:         move.w  a0,d5 */
    move.w a0,d5
/* QL: M134_nxchr */
M134_nxchr:
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         cmp.b   0(a6,a0.l),d1   get first non-space */
    cmp.b 0(a6,a0.l),d1
/* QL:         beq.s   M134_nxchr */
    beq.s M134_nxchr
/* QL:         sub.w   a0,d5 */
    sub.w a0,d5
/* QL:         neg.b   d5 */
    neg.b d5
/* QL:         seq     d4 */
    seq d4
/* QL:         or.b    d4,d5           ensure we don't code up a zero for 256*n */
    or.b d4,d5
/* QL:         moveq   #M134_b.spc,d4       space token */
    moveq #M134_b.spc,d4
/* QL:         bra.l   pa_tok1 */
    bra.w pa_tok1
/* QL: * Check text and tokenise */
/* QL: pa_cdtxt */
pa_cdtxt:
/* QL:         move.l  M134_bv_tkp(a6),a3   user might have typed "rem   ar" */
    move.l M134_bv_tkp(a6),a3
/* QL:         cmp.b   #M134_b.spc,-2(a6,a3.l) so spaces will have already been tokened */
    cmp.b #(M134_b.spc&255),(-2)(a6,a3.l)
/* QL:         beq.s   pa_text         that'll be OK */
    beq.s pa_text
/* QL:         jsr     pa_alfnm(pc)    is first char alpha-numeric? */
    jsr pa_alfnm(pc)
/* QL:         bls.s   M134_rts0            yes, that's no good here */
    bls.s M134_rts0
/* QL: pa_text */
pa_text:
/* QL:         move.l  a0,a2           beginning of text line */
    move.l a0,a2
/* QL:         move.l  M134_bv_bfp(a6),a0   end of text line */
    move.l M134_bv_bfp(a6),a0
/* QL:         subq.l  #1,a0           ..not including the line feed of course.. */
    subq.l #1,a0
/* QL:         move.w  #M134_w.txt,d4       text token and zero fill-in */
    move.w #M134_w.txt,d4
/* QL:         move.l  a0,d1           point at line feed */
    move.l a0,d1
/* QL:         sub.l   a2,d1           length of text */
    sub.l a2,d1
/* QL:         bne.s   M134_strlen          not zero, so we have to tokenise it */
    bne.s M134_strlen
/* QL:         addq.l  #2,(sp)         now we're OK */
    addq.l #2,(sp)
/* QL: ;       bra.s   M134_rts0 */
/* QL: ; */
/* QL: ;* Check system variable name */
/* QL: ; */
/* QL: pa_cdsyv */
pa_cdsyv:
/* QL: ;        cmp.b  #'&',0(a6,a0.l)  start with &? */
/* QL: ;        bne.s  M134_rts0 */
/* QL: ;        addq.l #1,a0 */
/* QL: ;        moveq  #0,d3 */
/* QL: ;        jsr    pa_chnlt(pc)     and rest of name */
/* QL: ;        bra.s  M134_rts0 */
/* QL: ; */
/* QL: ; must put in a test for existance when we know where they're kept */
/* QL: ; -- just save the token for now */
/* QL: ; */
/* QL: ;        move.w #M134_w.syv,d4        name token and zero fill for now? */
/* QL: ;        bra.s  M134_tok2             put in list */
/* QL: M134_rts0 */
M134_rts0:
/* QL:         rts */
    rts 
/* QL: * Check string & tokenise */
/* QL: pa_cdstr */
pa_cdstr:
/* QL:         move.w  #M134_w.str,d4       string token */
    move.w #M134_w.str,d4
/* QL:         move.b  0(a6,a0.l),d4   move in delimiter */
    move.b 0(a6,a0.l),d4
/* QL:         moveq   #'''',d1        single quote ... */
    moveq #39,d1
/* QL:         sub.b   d4,d1 */
    sub.b d4,d1
/* QL:         beq.s   M134_body */
    beq.s M134_body
/* QL:         subq.b  #''''-'"',d1    ... or double quotes are OK */
.word 20737|((((39-34))&7)<<9)
/* QL:         bne.s   M134_rts0 */
    bne.s M134_rts0
/* QL: M134_body */
M134_body:
/* QL:         addq.l  #1,a0           skip opening quote */
    addq.l #1,a0
/* QL:         move.l  a0,a2           this is where M134_body of string starts */
    move.l a0,a2
/* QL:         moveq   #10,d5          avoid linefeeds */
    moveq #10,d5
/* QL: M134_stnxt */
M134_stnxt:
/* QL:         move.b  0(a6,a0.l),d1   next char */
    move.b 0(a6,a0.l),d1
/* QL:         cmp.b   d5,d1           check it isn't a line feed */
    cmp.b d5,d1
/* QL:         beq.s   M134_rts0            we can't recover from that */
    beq.s M134_rts0
/* QL:         addq.l  #1,a0           space over the byte */
    addq.l #1,a0
/* QL:         cmp.b   d4,d1           is it the matching quote? */
    cmp.b d4,d1
/* QL:         bne.s   M134_stnxt           ..no, carry on then */
    bne.s M134_stnxt
/* QL: * I'm tempted to add the syntax of repeated delim -> single... but it's a */
/* QL: * hassle for listing the program. Also, leaving off final delim as valid? */
/* QL:         move.l  a0,d1 */
    move.l a0,d1
/* QL:         subq.l  #1,d1           don't include the closing quote */
    subq.l #1,d1
/* QL:         sub.l   a2,d1           calculate length */
    sub.l a2,d1
/* QL: M134_strlen */
M134_strlen:
/* QL:         move.w  d1,d5           save the length */
    move.w d1,d5
/* QL: * Don't bother to validate the length, as the worst possible input we can ever */
/* QL: * get is an unnumbered line with 32767 characters, containing a string with */
/* QL: * it's delimiting quotes and a line feed. I.e. 32764, which is just OK! */
/* QL:         addq.w  #4,d1           string header takes 4 bytes */
    addq.w #4,d1
/* QL:         bsr.l   M134_move4           do the first four bytes */
    bsr.w M134_move4
/* QL:         bra.s   M134_cent */
    bra.s M134_cent
/* QL: M134_copy */
M134_copy:
/* QL:         move.b  0(a6,a2.l),4(a6,d2.l) M134_copy a character */
    move.b 0(a6,a2.l),4(a6,d2.l)
/* QL:         addq.l  #1,d2 */
    addq.l #1,d2
/* QL:         addq.l  #1,a2 */
    addq.l #1,a2
/* QL: M134_cent */
M134_cent:
/* QL:         dbra    d5,M134_copy */
    dbra d5,M134_copy
/* QL:         rol.b   #8,d2           was the length odd or even? */
    rol.b #8,d2
/* QL:         bcc.s   M134_retur2          even is OK */
    bcc.s M134_retur2
/* QL:         clr.b   4(a6,d2.l)      fill any odd byte with a nought */
    clr.b 4(a6,d2.l)
/* QL:         addq.l  #1,a3           round up tk pointer to even */
    addq.l #1,a3
/* QL:         bra.s   M134_retur2 */
    bra.s M134_retur2
/* QL: * Check value and tokenise it */
/* QL: pa_cdnum */
pa_cdnum:
/* QL: pa_cdval */
pa_cdval:
/* QL:         lea     cn_dtof(pc),a3  convert decimal to float */
    lea cn_dtof(pc),a3
/* QL:         bsr.s   M134_cndto           go do it */
    bsr.s M134_cndto
/* QL:         move.l  2(a6,a1.l),d4   get the mantissa */
    move.l 2(a6,a1.l),d4
/* QL:         tst.b   M134_bv_toe(a6)      bit 7 set means no integer tokenisation */
    tst.b M134_bv_toe(a6)
/* QL:         bmi.s   M134_mkfp */
    bmi.s M134_mkfp
/* QL:         jsr     ri_int(pc) */
    jsr ri_int(pc)
/* QL:         bne.s   M134_mkfp */
    bne.s M134_mkfp
/* QL:         move.w  0(a6,a1.l),d6   get integer */
    move.w 0(a6,a1.l),d6
/* QL:         jsr     ri_float(pc)    send it back to f.p. */
    jsr ri_float(pc)
/* QL:         cmp.l   2(a6,a1.l),d4   is it identically the same? */
    cmp.l 2(a6,a1.l),d4
/* QL:         bne.s   M134_mkfp */
    bne.s M134_mkfp
/* QL:         cmp.w   0(a6,a1.l),d5 */
    cmp.w 0(a6,a1.l),d5
/* QL:         beq.s   M134_mkint */
    beq.s M134_mkint
/* QL: M134_mkfp */
M134_mkfp:
/* QL:         moveq   #6,d1           float takes six bytes */
    moveq #6,d1
/* QL:         bsr.s   M134_tkchk */
    bsr.s M134_tkchk
/* QL:         or.w    #$f000,d5       add the flpnt token */
    or.w #0xf000,d5
/* QL:         move.w  d5,-6(a6,a3.l)  put the tok+exponent into toklist */
    move.w d5,(-6)(a6,a3.l)
/* QL:         move.l  d4,-4(a6,a3.l)  followed by the mantissa */
    move.l d4,(-4)(a6,a3.l)
/* QL: M134_retur2 */
M134_retur2:
/* QL:         addq.l  #2,(sp)         OK now */
    addq.l #2,(sp)
/* QL: M134_return */
M134_return:
/* QL:         move.l  a3,M134_bv_tkp(a6)   update token list pointer */
    move.l a3,M134_bv_tkp(a6)
/* QL:         rts */
    rts 
/* QL: * Check for a line number and tokenise */
/* QL: pa_cdlno */
pa_cdlno:
/* QL:         lea     cn_dtoi(pc),a3  convert decimal to integer */
    lea cn_dtoi(pc),a3
/* QL:         bsr.s   M134_cndto           go do it */
    bsr.s M134_cndto
/* QL:         ble.s   M134_rts1            don't allow neg or zero line numbers */
    ble.s M134_rts1
/* QL:         moveq   #4+12,d0        total stack depth for unvr M134_return */
    moveq #(4+12),d0
/* QL:         jsr     pa_chunr(pc)    no M134_return if stuck in unravel */
    jsr pa_chunr(pc)
/* QL:         move.w  #M134_w.lno,d4       line number token and zero fill */
    move.w #M134_w.lno,d4
/* QL:         bra.s   M134_tok2            put token on list */
    bra.s M134_tok2
/* QL: M134_cndto */
M134_cndto:
/* QL:         jsr     bv_chri(pc)     reset and check ri stack */
    jsr bv_chri(pc)
/* QL:         move.l  M134_bv_rip(a6),a1 */
    move.l M134_bv_rip(a6),a1
/* QL:         move.l  a0,d3 */
    move.l a0,d3
/* QL:         jsr     (a3)            convert decimal to whatever */
    jsr (a3)
/* QL:         cmp.l   a0,d3 */
    cmp.l a0,d3
/* QL:         beq.s   M134_poprts          if it fails or converts nowt, discard M134_return */
    beq.s M134_poprts
/* QL:         move.w  0(a6,a1.l),d5   get exponent/number */
    move.w 0(a6,a1.l),d5
/* QL:         rts */
    rts 
/* QL: M134_poprts */
M134_poprts:
/* QL:         addq.l #4,sp            discard top of stack */
    addq.l #4,sp
/* QL: M134_rts1 */
M134_rts1:
/* QL:         rts */
    rts 
/* QL: M134_mkint */
M134_mkint:
/* QL:         move.w  #M134_w.lgi,d4 */
    move.w #M134_w.lgi,d4
/* QL:         move.w  d6,d5 */
    move.w d6,d5
/* QL:         asl.w   #8,d6           check if we can squash integer in single byte */
    asl.w #8,d6
/* QL:         bvs.s   M134_tok2            nope - tokenise as lgi */
    bvs.s M134_tok2
/* QL:         moveq   #M134_b.shi,d4       wow! yes, -128..127 is popular! */
    moveq #M134_b.shi,d4
/* QL:         bra.s   M134_goodtok1 */
    bra.s M134_goodtok1
/* QL: M134_moretk */
M134_moretk:
/* QL:         move.l  d1,a3 */
    move.l d1,a3
/* QL:         jsr     bv_chtkx(pc)    get enough room */
    jsr bv_chtkx(pc)
/* QL:         move.l  a3,d1 */
    move.l a3,d1
/* QL: M134_tkchk */
M134_tkchk:
/* QL:         move.l  M134_bv_tkp(a6),a3   get running toklist pointer */
    move.l M134_bv_tkp(a6),a3
/* QL:         move.l  a3,d2           save it */
    move.l a3,d2
/* QL:         add.l   d1,a3           this is where we want to extend to */
    add.l d1,a3
/* QL:         cmp.l   M134_bv_tkp+4(a6),a3 check next pointer */
    cmp.l (M134_bv_tkp+4)(a6),a3
/* QL:         bgt.s   M134_moretk          need more space */
    bgt.s M134_moretk
/* QL: * Above arrangement to improve speed of tokenisation */
/* QL:         rts */
    rts 
/* QL: * Check name and tokenise */
/* QL: pa_cdnam */
pa_cdnam:
/* QL:         move.l  a0,a3           save buffer pointer */
    move.l a0,a3
/* QL:         jsr     pa_chnlt(pc)    check next thing in buffer looks like a name */
    jsr pa_chnlt(pc)
/* QL:         bra.s   M134_rts1            ..it doesn't... */
    bra.s M134_rts1
/* QL:         move.l  a0,d5           end of name */
    move.l a0,d5
/* QL:         sub.l   a3,d5           length of name */
    sub.l a3,d5
/* QL:         cmp.w   #256,d5         is name too long for a byte length? */
    cmp.w #256,d5
/* QL:         bcc.s   M134_rts1            ..serves user right for trying it on.. */
    bcc.s M134_rts1
/* QL:         move.l  a0,-(sp)        save buffer pos */
    move.l a0,-(sp)
/* QL: * N.B. Dirty tricks in chnam/chunr means we must have stack right here! */
/* QL:         jsr     pa_chnam(pc)    check name in table */
    jsr pa_chnam(pc)
/* QL:         bra.s   M134_poprts          rats - it looks like a keyword */
    bra.s M134_poprts
/* QL:         move.l  (sp)+,a0        restore buffer */
    move.l (sp)+,a0
/* QL:         move.w  #M134_w.nam,d4       name token and zero fill */
    move.w #M134_w.nam,d4
/* QL: * Put four byte token into the token list */
/* QL: M134_tok2 */
M134_tok2:
/* QL:         moveq   #4,d1           four byte token */
    moveq #4,d1
/* QL:         pea     M134_retur2 */
    pea M134_retur2(pc)
/* QL: M134_move4 */
M134_move4:
/* QL:         bsr.s   M134_tkchk */
    bsr.s M134_tkchk
/* QL:         movem.w d4-d5,0(a6,d2.l) (e.g. toktyp byte, delimiter and length) */
    movem.w d4-d5,0(a6,d2.l)
/* QL:         rts */
    rts 
/* QL: * Check for monadic operators, dyadic operators and separators. */
/* QL: * Note. The symbol table follows the call address, after the symbol type byte. */
/* QL: * The type is fetched, then the table must be in the form: */
/* QL: *        (a2).b no of symbols in table starting with 1 (n) */
/* QL: *       r(a2).b offset on a2 of r'th prebyte */
/* QL: *     n+1(a2).b 1st prebyte of the form 0XYh where Y is no of chars and X */
/* QL: *               is zero if no trailing space is required else 1 */
/* QL: *   n+1+c(a2).b c'th character of 1st symbol */
/* QL: * n+1+c+1(a2).b pre-byte of 2nd symbol */
/* QL: *         etc */
/* QL: M134_end_sym */
M134_end_sym:
/* QL:         lsl.w   #7,d6           did the prebyte say we need a space */
    lsl.w #7,d6
/* QL:         bpl.s   M134_tok1ok          no space needed, we're OK */
    bpl.s M134_tok1ok
/* QL:         jsr     pa_alfnm(pc)    want a non-alphanumeric */
    jsr pa_alfnm(pc)
/* QL:         bls.s   M134_char1           not there, try the next (gets a0 sorted) */
    bls.s M134_char1
/* QL: M134_tok1ok */
M134_tok1ok:
/* QL:         move.w  a3,d5 */
    move.w a3,d5
/* QL:         sub.w   a2,d5           token number */
    sub.w a2,d5
/* QL:         lsr.w   #8,d4           fetch down token type */
    lsr.w #8,d4
/* QL: M134_goodtok1 */
M134_goodtok1:
/* QL:         addq.l  #2,(sp)         good M134_return */
    addq.l #2,(sp)
/* QL: * Put two byte token into the token list */
/* QL: * d4 -i  - token type */
/* QL: * d5 -i  - token lsb */
/* QL: * a6 -ip - the base of basic */
/* QL: * d0-d3/a3 destroyed */
/* QL: pa_tok1 */
pa_tok1:
/* QL:         moveq   #2,d1           two byte token */
    moveq #2,d1
/* QL:         bsr.s   M134_tkchk           check space and get a3 */
    bsr.s M134_tkchk
/* QL:         move.b  d4,-2(a6,a3.l)  first byte (toktyp) */
    move.b d4,(-2)(a6,a3.l)
/* QL:         move.b  d5,-1(a6,a3.l)  second byte (value) */
    move.b d5,(-1)(a6,a3.l)
/* QL:         bra.l   M134_return */
    bra.w M134_return
/* QL: M134_nextchar */
M134_nextchar:
/* QL:         addq.l  #1,a0           move to next buffer character */
    addq.l #1,a0
/* QL:         sub.b   d5,d6 */
    sub.b d5,d6
/* QL:         beq.s   M134_end_sym         no chars left in symtab symbol */
    beq.s M134_end_sym
/* QL:         bsr.s   M134_getchar         and get it */
    bsr.s M134_getchar
/* QL:         cmp.b   (a1)+,d1        does it match next table char? */
    cmp.b (a1)+,d1
/* QL:         beq.s   M134_nextchar        no, start again with next symbol */
    beq.s M134_nextchar
/* QL: M134_char1 */
M134_char1:
/* QL:         move.l  d0,a0           get posn of 1st char of buffer */
    move.l d0,a0
/* QL:         bsr.s   M134_getchar         get 1st char, converted to single case */
    bsr.s M134_getchar
/* QL: M134_nextsym */
M134_nextsym:
/* QL:         subq.b  #1,d4           any symbols left to check? */
    subq.b #1,d4
/* QL:         bcs.s   M134_rts3            no, don't have a valid symbol then */
    bcs.s M134_rts3
/* QL:         move.b  (a3)+,d2        get prebyte offset (n.b. alfnm clears d2 15-8) */
    move.b (a3)+,d2
/* QL:         lea     -1(a2,d2.w),a1  point to prebyte */
    lea (-1)(a2,d2.w),a1
/* QL:         move.b  (a1)+,d6        read prebyte and move on */
    move.b (a1)+,d6
/* QL:         cmp.b   (a1)+,d1        does 1st char match? */
    cmp.b (a1)+,d1
/* QL:         bne.s   M134_nextsym         no, try the next symbol */
    bne.s M134_nextsym
/* QL:         lsl.w   #4,d6           put space flag in bit 8 */
    lsl.w #4,d6
/* QL:         bra.s   M134_nextchar */
    bra.s M134_nextchar
/* QL: M134_getchar */
M134_getchar:
/* QL:         jsr     pa_alfnm(pc)    find out if char at (a0,a6) is a letter */
    jsr pa_alfnm(pc)
/* QL:         bcc.s   M134_rts3            if it's a letter, force to a single case */
    bcc.s M134_rts3
/* QL:         bclr    #5,d1           accented, lower case, or normal, upper case */
    bclr #5,d1
/* QL: M134_rts3 */
M134_rts3:
/* QL:         rts */
    rts 
/* QL: M134_chsym */
M134_chsym:
/* QL:         move.l  (sp)+,a2        get table base off stack */
    move.l (sp)+,a2
/* QL:         move.w  (a2)+,d4        get token type and count */
    move.w (a2)+,d4
/* QL:         move.l  a2,a3           set running pointer to offsets */
    move.l a2,a3
/* QL:         move.l  a0,d0           save where 1st char of buffer is */
    move.l a0,d0
/* QL:         moveq   #1<<4,d5        speed up counting */
    moveq #(1<<4),d5
/* QL:         bra.s   M134_char1 */
    bra.s M134_char1
/* QL: * Generate code/tables for text lexical stuff */
/* QL: alpha setstr ABCDEFGHIJKLMNOPQRSTUVWXYZ */
/* QL: pa_cd macro */
/* QL: * Generate entry points, code and tables for text lexical objects */
/* QL: sep pa_cd {,} {;} {\} ! to */
/* QL:         xdef    pa_cd[.lab],pa_tb[.lab] */
/* QL: pa_cd[.lab] */
pa_cdsep:
/* QL:         bsr.s   M134_chsym */
    bsr.s M134_chsym
/* QL:         dc.b    b.[.lab] */
M134_dc_anchor_1452:
.byte (M134_b.sep)&255
/* QL: pa_tb[.lab] dc.b [.nparms] */
pa_tbsep:
M134_dc_anchor_1456:
.byte (5)&255
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1462:
.byte (((M134_sep1-M134_dc_anchor_1462)+1))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1468:
.byte (((M134_sep2-M134_dc_anchor_1468)+2))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1474:
.byte (((M134_sep3-M134_dc_anchor_1474)+3))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1480:
.byte (((M134_sep4-M134_dc_anchor_1480)+4))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1486:
.byte (((M134_sep5-M134_dc_anchor_1486)+5))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: i setnum 0 */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_sep1:
M134_dc_anchor_1495:
.byte (0x01)&255
.byte 44
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_sep2:
M134_dc_anchor_1504:
.byte (0x01)&255
.byte 59
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_sep3:
M134_dc_anchor_1513:
.byte (0x01)&255
.byte 92
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_sep4:
M134_dc_anchor_1522:
.byte (0x01)&255
.byte 33
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_sep5:
M134_dc_anchor_1531:
.byte (0x12)&255
.byte 84,79
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL:         ds.w    0 */
.balign 2,0
/* QL: mon pa_cd - + ~~ not */
/* QL:         xdef    pa_cd[.lab],pa_tb[.lab] */
/* QL: pa_cd[.lab] */
pa_cdmon:
/* QL:         bsr.s   M134_chsym */
    bsr.s M134_chsym
/* QL:         dc.b    b.[.lab] */
M134_dc_anchor_1545:
.byte (M134_b.mon)&255
/* QL: pa_tb[.lab] dc.b [.nparms] */
pa_tbmon:
M134_dc_anchor_1549:
.byte (4)&255
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1555:
.byte (((M134_mon1-M134_dc_anchor_1555)+1))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1561:
.byte (((M134_mon2-M134_dc_anchor_1561)+2))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1567:
.byte (((M134_mon3-M134_dc_anchor_1567)+3))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1573:
.byte (((M134_mon4-M134_dc_anchor_1573)+4))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: i setnum 0 */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_mon1:
M134_dc_anchor_1582:
.byte (0x01)&255
.byte 45
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_mon2:
M134_dc_anchor_1591:
.byte (0x01)&255
.byte 43
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_mon3:
M134_dc_anchor_1600:
.byte (0x02)&255
.byte 126,126
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_mon4:
M134_dc_anchor_1609:
.byte (0x13)&255
.byte 78,79,84
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL:         ds.w    0 */
.balign 2,0
/* QL: ops pa_cd + - * / >= > == = <> <= < || && ^^ ^ & or and xor mod div instr */
/* QL:         xdef    pa_cd[.lab],pa_tb[.lab] */
/* QL: pa_cd[.lab] */
pa_cdops:
/* QL:         bsr.s   M134_chsym */
    bsr.s M134_chsym
/* QL:         dc.b    b.[.lab] */
M134_dc_anchor_1623:
.byte (M134_b.ops)&255
/* QL: pa_tb[.lab] dc.b [.nparms] */
pa_tbops:
M134_dc_anchor_1627:
.byte (22)&255
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1633:
.byte (((M134_ops1-M134_dc_anchor_1633)+1))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1639:
.byte (((M134_ops2-M134_dc_anchor_1639)+2))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1645:
.byte (((M134_ops3-M134_dc_anchor_1645)+3))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1651:
.byte (((M134_ops4-M134_dc_anchor_1651)+4))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1657:
.byte (((M134_ops5-M134_dc_anchor_1657)+5))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1663:
.byte (((M134_ops6-M134_dc_anchor_1663)+6))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1669:
.byte (((M134_ops7-M134_dc_anchor_1669)+7))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1675:
.byte (((M134_ops8-M134_dc_anchor_1675)+8))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1681:
.byte (((M134_ops9-M134_dc_anchor_1681)+9))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1687:
.byte (((M134_ops10-M134_dc_anchor_1687)+10))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1693:
.byte (((M134_ops11-M134_dc_anchor_1693)+11))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1699:
.byte (((M134_ops12-M134_dc_anchor_1699)+12))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1705:
.byte (((M134_ops13-M134_dc_anchor_1705)+13))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1711:
.byte (((M134_ops14-M134_dc_anchor_1711)+14))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1717:
.byte (((M134_ops15-M134_dc_anchor_1717)+15))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1723:
.byte (((M134_ops16-M134_dc_anchor_1723)+16))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1729:
.byte (((M134_ops17-M134_dc_anchor_1729)+17))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1735:
.byte (((M134_ops18-M134_dc_anchor_1735)+18))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1741:
.byte (((M134_ops19-M134_dc_anchor_1741)+19))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1747:
.byte (((M134_ops20-M134_dc_anchor_1747)+20))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1753:
.byte (((M134_ops21-M134_dc_anchor_1753)+21))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL:  dc.b [.lab][i]-*+[i] */
M134_dc_anchor_1759:
.byte (((M134_ops22-M134_dc_anchor_1759)+22))&255
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL: i setnum 0 */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops1:
M134_dc_anchor_1768:
.byte (0x01)&255
.byte 43
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops2:
M134_dc_anchor_1777:
.byte (0x01)&255
.byte 45
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops3:
M134_dc_anchor_1786:
.byte (0x01)&255
.byte 42
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops4:
M134_dc_anchor_1795:
.byte (0x01)&255
.byte 47
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops5:
M134_dc_anchor_1804:
.byte (0x02)&255
.byte 62,61
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops6:
M134_dc_anchor_1813:
.byte (0x01)&255
.byte 62
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops7:
M134_dc_anchor_1822:
.byte (0x02)&255
.byte 61,61
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops8:
M134_dc_anchor_1831:
.byte (0x01)&255
.byte 61
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops9:
M134_dc_anchor_1840:
.byte (0x02)&255
.byte 60,62
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops10:
M134_dc_anchor_1849:
.byte (0x02)&255
.byte 60,61
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops11:
M134_dc_anchor_1858:
.byte (0x01)&255
.byte 60
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops12:
M134_dc_anchor_1867:
.byte (0x02)&255
.byte 124,124
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops13:
M134_dc_anchor_1876:
.byte (0x02)&255
.byte 38,38
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops14:
M134_dc_anchor_1885:
.byte (0x02)&255
.byte 94,94
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops15:
M134_dc_anchor_1894:
.byte (0x01)&255
.byte 94
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops16:
M134_dc_anchor_1903:
.byte (0x01)&255
.byte 38
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops17:
M134_dc_anchor_1912:
.byte (0x12)&255
.byte 79,82
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops18:
M134_dc_anchor_1921:
.byte (0x13)&255
.byte 65,78,68
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops19:
M134_dc_anchor_1930:
.byte (0x13)&255
.byte 88,79,82
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops20:
M134_dc_anchor_1939:
.byte (0x13)&255
.byte 77,79,68
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops21:
M134_dc_anchor_1948:
.byte (0x13)&255
.byte 68,73,86
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL: m maclab */
/* QL: i setnum [i]+1 */
/* QL: j setnum 1-([.instr(alpha,.ucase(.right(.parm([i]),1)))]-1)>>8&1 */
/* QL: [.lab][i] dc.b $[j][.len(.parm([i]))],'[.ucase(.parm([i]))]' */
M134_ops22:
M134_dc_anchor_1957:
.byte (0x15)&255
.byte 73,78,83,84,82
/* QL:  ifnum [i] < [.nparms] goto m */
/* QL:         ds.w    0 */
.balign 2,0
/* QL:         end */
