/* ROM section bp_files */
.balign 2,0
/* QL: * Load and start program */
/* QL: * EXEC{_W}<filename>{,#<chan>}...{;<parameter string>} */
/* QL: bp_execw */
bp_execw:
/* QL:         moveq   #-1,d7          wait on activation */
    moveq #(-1),d7
/* QL: bp_exec */
bp_exec:
/* QL:         moveq   #$70,d1 */
    moveq #0x70,d1
/* QL:         and.b   -7(a6,a5.l),d1 */
    and.b (-7)(a6,a5.l),d1
/* QL:         bne.s   M43_err_bpne        mustn't have any trailing delimiter */
    bne.s M43_err_bpne
/* QL:         tst.b   1(a6,a3.l) */
    tst.b 1(a6,a3.l)
/* QL:         bmi.s   M43_err_bpne        mustn't have hash before 1st parameter */
    bmi.s M43_err_bpne
/* QL:         addq.l  #8,a3           forget filename for a while */
    addq.l #8,a3
/* QL:         moveq   #$50,d5         mask for last param and flag no string */
    moveq #0x50,d5
/* QL:         moveq   #0,d6           extra data space needed for parameters */
    moveq #0,d6
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         blt.s   M43_err_bpne        must have at least one parameter */
    blt.s M43_err_bpne
/* QL:         move.l  a3,a0 */
    move.l a3,a0
/* QL:         beq.s   M43_chnent */
    beq.s M43_chnent
/* QL:         tst.b   -7(a6,a5.l) */
    tst.b (-7)(a6,a5.l)
/* QL:         bmi.s   M43_chnent          no hash allowed on string */
    bmi.s M43_chnent
/* QL:         and.b   -15(a6,a5.l),d5 delimiter before last param a ';'? (no nulls) */
    and.b (-15)(a6,a5.l),d5
/* QL:         bne.s   M43_chnent          no, so no string */
    bne.s M43_chnent
/* QL:         subq.l  #8,a5           string will be put waiting on stack */
    subq.l #8,a5
/* QL:         move.l  a5,a3 */
    move.l a5,a3
/* QL:         bsr.l   M43_bp_fnamx */
    bsr.w M43_bp_fnamx
/* QL:         bne.s   M43_rts9            ouch! string didn't work out! */
    bne.s M43_rts9
/* QL:         move.w  0(a6,a1.l),d6 */
    move.w 0(a6,a1.l),d6
/* QL:         addq.l  #1,d6 */
    addq.l #1,d6
/* QL:         bclr    d0,d6           round up string length */
    bclr d0,d6
/* QL:         move.l  a0,a3 */
    move.l a0,a3
/* QL:         bra.s   M43_chnent */
    bra.s M43_chnent
/* QL: * N.B. As we have already verified that the last delimiter is not a comma... */
/* QL: M43_chnloop */
M43_chnloop:
/* QL:         moveq   #$60,d0         won't find a null delimiter, they don't happen */
    moveq #0x60,d0
/* QL:         and.b   -7(a6,a0.l),d0  must be a comma ($10) before the #<channel> */
    and.b (-7)(a6,a0.l),d0
/* QL:         bne.s   M43_err_bpne */
    bne.s M43_err_bpne
/* QL:         addq.l  #4,d6           increase extra data space required */
    addq.l #4,d6
/* QL:         addq.l  #8,a0           move to next param */
    addq.l #8,a0
/* QL: M43_chnent */
M43_chnent:
/* QL:         tst.b   1(a6,a0.l)      check for hash before parameter */
    tst.b 1(a6,a0.l)
/* QL:         bmi.s   M43_chnloop */
    bmi.s M43_chnloop
/* QL:         cmp.l   a0,a5           we should have done all the parameters by now */
    cmp.l a0,a5
/* QL: M43_err_bpne */
M43_err_bpne:
/* QL:         bne.l   M43_err_bp */
    bne.w M43_err_bp
/* QL:         jsr     ca_gtlin(pc)    get them all as long ints (keeps M43_bv_rip nice) */
    jsr ca_gtlin(pc)
/* QL:         move.w  d3,a4           save channel count */
    move.w d3,a4
/* QL:         beq.s   M43_cvtent */
    beq.s M43_cvtent
/* QL: M43_rts9 */
M43_rts9:
/* QL:         rts */
    rts 
/* QL: M43_cvtloop */
M43_cvtloop:
/* QL: *       tst.w   0(a6,a1.l)      (lets no be too pedantic here) */
/* QL: *       bne.s   M43_err_bpne */
/* QL:         move.w  2(a6,a1.l),d1 */
    move.w 2(a6,a1.l),d1
/* QL:         jsr     bp_chnid(pc)    convert them all to channel ids */
    jsr bp_chnid(pc)
/* QL:         bne.s   M43_rts9 */
    bne.s M43_rts9
/* QL:         move.l  a0,0(a6,a1.l) */
    move.l a0,0(a6,a1.l)
/* QL:         addq.l  #4,a1 */
    addq.l #4,a1
/* QL: M43_cvtent */
M43_cvtent:
/* QL:         dbra    d3,M43_cvtloop */
    dbra d3,M43_cvtloop
/* QL:         subq.l  #8,a3           stack data ready, go back to first param */
    subq.l #8,a3
/* QL:         bsr.s   M43_wantload        open read only and get header (d2=length) */
    bsr.s M43_wantload
/* QL:         bne.s   M43_rts9 */
    bne.s M43_rts9
/* QL:         moveq   #M43_err.bp,d0 */
    moveq #M43_err.bp,d0
/* QL:         subq.b  #1,M43_md_detyp(a6,a1.l) is it an executable file? */
    subq.b #1,M43_md_detyp(a6,a1.l)
/* QL:         bne.s   M43_close_l */
    bne.s M43_close_l
/* QL:         moveq   #M43_mt.cjob,d0     yes, create job */
    moveq #M43_mt.cjob,d0
/* QL:         moveq   #-1,d1          we are the parent */
    moveq #(-1),d1
/* QL:         move.l  M43_md_deinf(a6,a1.l),d3 get length of data space */
    move.l M43_md_deinf(a6,a1.l),d3
/* QL:         add.l   d6,d3           add our extra parameters length */
    add.l d6,d3
/* QL:         move.l  a0,a3           save chan */
    move.l a0,a3
/* QL:         bsr.s   M43_trap1z          (a1=0, start at beginning) */
    bsr.s M43_trap1z
/* QL:         move.l  a0,a1           base address in a1 for load */
    move.l a0,a1
/* QL:         exg     a0,a3           put back chan, save job base */
    exg a3,a0
/* QL:         bne.s   M43_close_l */
    bne.s M43_close_l
/* QL:         move.l  d1,a2           save job id */
    move.l d1,a2
/* QL:         bsr.s   M43_doload          and load file */
    bsr.s M43_doload
/* QL:         bne.s   M43_rjob            did read fail? */
    bne.s M43_rjob
/* QL:         sub.l   d6,M43_jb_a0+7*4-M43_jb_end(a3) adjust the stack pointer */
    sub.l d6,((M43_jb_a0+(7*4))-M43_jb_end)(a3)
/* QL:         move.l  M43_jb_a0+7*4-M43_jb_end(a3),a0 get the stack pointer */
    move.l ((M43_jb_a0+(7*4))-M43_jb_end)(a3),a0
/* QL:         move.w  a4,(a0)+        store channel count */
    move.w a4,(a0)+
/* QL:         tst.w   d5 */
    tst.w d5
/* QL:         bne.s   M43_lenok           if no string, zero string len already on stack */
    bne.s M43_lenok
/* QL:         addq.l  #2,d6           include string length word in amount to move */
    addq.l #2,d6
/* QL: M43_lenok */
M43_lenok:
/* QL:         move.l  M43_bv_rip(a6),a1 */
    move.l M43_bv_rip(a6),a1
/* QL:         move.w  0(a6,a1.l),d5   we have to skip the device/file name */
    move.w 0(a6,a1.l),d5
/* QL:         addq.l  #3,d5 */
    addq.l #3,d5
/* QL:         bclr    d0,d5 */
    bclr d0,d5
/* QL:         add.l   d5,a1 */
    add.l d5,a1
/* QL:         move.l  d6,d1 */
    move.l d6,d1
/* QL:         jsr     mm_mrtoa(pc)    copy all our info into job's stack */
    jsr mm_mrtoa(pc)
/* QL:         moveq   #M43_mt.activ,d0    activate job */
    moveq #M43_mt.activ,d0
/* QL:         move.l  a2,d1           reload job id */
    move.l a2,d1
/* QL:         moveq   #32,d2          priority */
    moveq #32,d2
/* QL:         move.w  d7,d3           set timeout (0 for exec, -1 for exec_w) */
    move.w d7,d3
/* QL:         bsr.s   M43_trap1           any errors? */
    bsr.s M43_trap1
/* QL:         bne.s   M43_rjob            yes, remove job */
    bne.s M43_rjob
/* QL:         tst.w   d7              did we wait? */
    tst.w d7
/* QL:         bne.s   M43_rts0            yes, done */
    bne.s M43_rts0
/* QL:         moveq   #M43_mt.susjb,d0    suspend job */
    moveq #M43_mt.susjb,d0
/* QL:         moveq   #-1,d1          myself */
    moveq #(-1),d1
/* QL:         moveq   #50/2,d3        wait half a sec to give new job a chance */
    moveq #(50/2),d3
/* QL: M43_trap1z */
M43_trap1z:
/* QL:         sub.l   a1,a1           clear flag address */
    sub.l a1,a1
/* QL: M43_trap1 */
M43_trap1:
/* QL:         trap    #1 */
    trap #1
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: M43_rts0 */
M43_rts0:
/* QL:         rts */
    rts 
/* QL: M43_rjob */
M43_rjob:
/* QL:         move.l  d0,d4 */
    move.l d0,d4
/* QL:         moveq   #M43_mt.rjob,d0     could not load or activate */
    moveq #M43_mt.rjob,d0
/* QL:         move.l  a2,d1           ... remove the job */
    move.l a2,d1
/* QL:         trap    #1 */
    trap #1
/* QL:         move.l  d4,d0           restore error key */
    move.l d4,d0
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code */
/* QL: * d2 -  o- file size */
/* QL: * a0 -  o- channel id */
/* QL: * a3 -i o- start of parameters, eight added */
/* QL: * a5 -ip - end of parameters */
/* QL: * d1/d3-d4/a1 destroyed */
/* QL: M43_wantload */
M43_wantload:
/* QL:         bsr.l   bp_fopin        open file for loading */
    bsr.w bp_fopin
/* QL:         bne.s   M43_rts1 */
    bne.s M43_rts1
/* QL:         bsr.s   M43_gethdr          get header and put length in d2 */
    bsr.s M43_gethdr
/* QL: M43_close_l */
M43_close_l:
/* QL:         bne.s   M43_close_s */
    bne.s M43_close_s
/* QL: M43_rts1 */
M43_rts1:
/* QL:         rts */
    rts 
/* QL: * d0 -  o- error code */
/* QL: * d2 -  o- file size */
/* QL: * a0 -i  - channel id */
/* QL: * d1/d3/a1 destroyed */
/* QL: M43_gethdr */
M43_gethdr:
/* QL:         moveq   #M43_fs.headr,d0    fetch the header */
    moveq #M43_fs.headr,d0
/* QL:         moveq   #M43_md_denam,d2 */
    moveq #M43_md_denam,d2
/* QL:         bsr.l   M43_trp3b           into the buffer */
    bsr.w M43_trp3b
/* QL:         move.l  M43_bv_bfbas(a6),a1 */
    move.l M43_bv_bfbas(a6),a1
/* QL:         move.l  M43_md_delen(a6,a1.l),d2 get file length */
    move.l M43_md_delen(a6,a1.l),d2
/* QL:         tst.l   d0 */
    tst.l d0
/* QL:         rts */
    rts 
/* QL: * load bytes: LBYTES<filename>,<address> */
/* QL: bp_lbyts */
bp_lbyts:
/* QL:         moveq   #1,d5           just one parameter wanted */
    moveq #1,d5
/* QL:         bsr.s   M43_gtlin           get start address */
    bsr.s M43_gtlin
/* QL:         bsr.s   M43_wantload        (d2=length) */
    bsr.s M43_wantload
/* QL:         move.l  (sp)+,a1        get start address */
    move.l (sp)+,a1
/* QL:         bne.s   M43_rts1 */
    bne.s M43_rts1
/* QL: M43_doload */
M43_doload:
/* QL:         moveq   #M43_fs.load,d0 */
    moveq #M43_fs.load,d0
/* QL:         bsr.l   M43_trap3 */
    bsr.w M43_trap3
/* QL: M43_close_s */
M43_close_s:
/* QL:         bra.s   M43_close */
    bra.s M43_close
/* QL: * Get long integers after 1st parameter */
/* QL: * If no error is reported, d1 is also returned on the top of the stack */
/* QL: * d0 -  o- error code */
/* QL: * d1 -  o- 2nd parameter (verified as even) */
/* QL: * d2 -  o- 3rd parameter (default 0) */
/* QL: * d5 -i  - maximum number of parameters required */
/* QL: * d7 -i o- default 6th parameter / 6th parameter */
/* QL: * a0 -  o- 4th parameter (default 0) */
/* QL: * a2 -  o- 5th parameter (default 0) */
/* QL: * a3 -ip - start of parameters */
/* QL: * a5 -i o- end of parameters (output as 8(a3)) */
/* QL: * d3-d4/d6/a4 destroyed */
/* QL: M43_gtlin */
M43_gtlin:
/* QL:         move.l  (sp)+,a4 */
    move.l (sp)+,a4
/* QL:         addq.l  #8,a3           step past 1st parameter */
    addq.l #8,a3
/* QL:         cmp.l   a5,a3 */
    cmp.l a5,a3
/* QL:         bge.s   M43_err_bp1         minimum two parameters */
    bge.s M43_err_bp1
/* QL:         jsr     ca_gtlin(pc)    get arguments */
    jsr ca_gtlin(pc)
/* QL:         bne.s   M43_rts1 */
    bne.s M43_rts1
/* QL:         cmp.l   d3,d5 */
    cmp.l d3,d5
/* QL:         bcs.s   M43_err_bp1 */
    bcs.s M43_err_bp1
/* QL:         lsl.l   #2,d3 */
    lsl.l #2,d3
/* QL:         add.l   d3,M43_bv_rip(a6) */
    add.l d3,M43_bv_rip(a6)
/* QL:         movem.l 0(a6,a1.l),d1-d2/a0/a2/a5 start{,length{,data{,xtra{,type}}}} */
    movem.l 0(a6,a1.l),d1-d2/a0/a2/a5
/* QL:         lsr.l   #1,d3 */
    lsr.l #1,d3
/* QL:         jmp     M43_zaparg-5*2(pc,d3.w) */
.word 0x4efb
.word 12288|(((M43_zaparg-(5*2))-.)&255)
/* QL:         moveq   #0,d2           start,0,0,0,d7 */
    moveq #0,d2
/* QL:         sub.l   a0,a0           start,length,0,0,d7 */
    sub.l a0,a0
/* QL:         sub.l   a2,a2           start,length,data,0,d7 */
    sub.l a2,a2
/* QL:         move.w  d7,a5           start,length,data,xtra,d7 */
    move.w d7,a5
/* QL: M43_zaparg                         ;start,length,data,xtra,type */
M43_zaparg:
/* QL:         move.w  a5,d7 */
    move.w a5,d7
/* QL:         btst    d0,d1 */
    btst d0,d1
/* QL:         bne.s   M43_err_bp1 */
    bne.s M43_err_bp1
/* QL:         move.l  a3,a5 */
    move.l a3,a5
/* QL:         subq.l  #8,a3           return to 1st parameter */
    subq.l #8,a3
/* QL:         move.l  d1,-(sp) */
    move.l d1,-(sp)
/* QL:         jmp     (a4) */
    jmp (a4)
/* QL: M43_err_bp1 */
M43_err_bp1:
/* QL:         bra.s   M43_err_bp */
    bra.s M43_err_bp
/* QL: * Save executable code or bytes: */
/* QL: * SEXEC|SBYTES<filename>,<address>{,<length>{,<data>{,<extra>{,<acc/type>}}}} */
/* QL: bp_sexec */
bp_sexec:
/* QL:         moveq   #1,d7           file type 1 */
    moveq #1,d7
/* QL: bp_sbyts */
bp_sbyts:
/* QL:         moveq   #5,d5           at most five arguments */
    moveq #5,d5
/* QL:         bsr.s   M43_gtlin           get arguments */
    bsr.s M43_gtlin
/* QL:         move.l  M43_bv_bfbas(a6),a1 */
    move.l M43_bv_bfbas(a6),a1
/* QL:         assert  M43_md_delen,M43_md_deacs-4,M43_md_detyp-5,M43_md_deinf-6 */
/* original assertion: M43_md_delen,M43_md_deacs-4,M43_md_detyp-5,M43_md_deinf-6 */
/* QL:         movem.l d7/a0/a2,M43_md_delen+2(a6,a1.l) access,type,data,xtra */
    movem.l d7/a0/a2,(M43_md_delen+2)(a6,a1.l)
/* QL:         move.l  d2,M43_md_delen(a6,a1.l) length */
    move.l d2,M43_md_delen(a6,a1.l)
/* QL:         blt.s   M43_bp_pop          don't allow silly lengths (sexec<10 is silly!) */
    blt.s M43_bp_pop
/* QL:         bsr.s   M43_fopnew */
    bsr.s M43_fopnew
/* QL:         bne.l   M43_poprts */
    bne.w M43_poprts
/* QL:         moveq   #M43_fs.heads,d0    set header */
    moveq #M43_fs.heads,d0
/* QL:         bsr.s   M43_trp3b */
    bsr.s M43_trp3b
/* QL:         move.l  (sp)+,a1 */
    move.l (sp)+,a1
/* QL:         bne.s   M43_close */
    bne.s M43_close
/* QL:         moveq   #M43_fs.save,d0     save file in toto */
    moveq #M43_fs.save,d0
/* QL:         bsr.s   M43_trap3 */
    bsr.s M43_trap3
/* QL:         bra.s   M43_close           M43_close the file */
    bra.s M43_close
/* QL: * File delete: DELETE<filename> */
/* QL: bp_delee */
bp_delee:
/* QL:         bsr.s   M43_bp_fname */
    bsr.s M43_bp_fname
/* QL:         bne.s   M43_rts2            couldn't get filename parameter */
    bne.s M43_rts2
/* QL:         cmp.l   a3,a5 */
    cmp.l a3,a5
/* QL:         bne.s   M43_err_bp          wasn't just one parameter */
    bne.s M43_err_bp
/* QL:         moveq   #M43_io.delet,d0 */
    moveq #M43_io.delet,d0
/* QL:         bra.s   M43_trp2me */
    bra.s M43_trp2me
/* QL: * Saves current basic program in ASCII: SAVE<filename>{,<start>{to<end>}} */
/* QL: bp_save */
bp_save:
/* QL:         bsr.s   M43_fopnew          save on a new file only */
    bsr.s M43_fopnew
/* QL:         bne.s   M43_rts2 */
    bne.s M43_rts2
/* QL:         jsr     bp_listd(pc)    and continue just as list */
    jsr bp_listd(pc)
/* QL: M43_close */
M43_close:
/* QL:         move.l  d0,d4           save error flag */
    move.l d0,d4
/* QL: M43_close_n */
M43_close_n:
/* QL:         moveq   #M43_io.close,d0    and M43_close file */
    moveq #M43_io.close,d0
/* QL:         trap    #2 */
    trap #2
/* QL:         move.l  d4,d0 */
    move.l d4,d0
/* QL: M43_rts2 */
M43_rts2:
/* QL:         rts */
    rts 
/* QL: M43_fopnew */
M43_fopnew:
/* QL:         moveq   #M43_io.new,d4 */
    moveq #M43_io.new,d4
/* QL:         bra.s   M43_fopen */
    bra.s M43_fopen
/* QL: M43_bp_pop */
M43_bp_pop:
/* QL:         addq.l  #4,sp           remove return address */
    addq.l #4,sp
/* QL: M43_err_bp */
M43_err_bp:
/* QL:         moveq   #M43_err.bp,d0 */
    moveq #M43_err.bp,d0
/* QL:         rts */
    rts 
/* QL: M43_trp3b */
M43_trp3b:
/* QL:         move.l  M43_bv_bfbas(a6),a1 use basic buffer */
    move.l M43_bv_bfbas(a6),a1
/* QL: M43_trp3r */
M43_trp3r:
/* QL:         trap    #4              next trap is relative a1 */
    trap #4
/* QL: M43_trap3 */
M43_trap3:
/* QL:         moveq   #-1,d3 */
    moveq #(-1),d3
/* QL:         trap    #3 */
    trap #3
/* QL:         bra.s   M43_tstrts3 */
    bra.s M43_tstrts3
/* QL: * Get a file name */
/* QL: * d0 -  o- error code */
/* QL: * a1 -  o- ri pointer to file name string (if d0=0) */
/* QL: * a3 -i o- name table entry to look at (update by 8 if a3<a5) */
/* QL: * a5 -ip - top of name table entries (if <= a3, bad param, skipped by fnamx) */
/* QL: M43_bp_fname */
M43_bp_fname:
/* QL:         cmp.l   a5,a3           is there a name */
    cmp.l a5,a3
/* QL:         bge.s   M43_bp_pop          nope, that's silly */
    bge.s M43_bp_pop
/* QL: M43_bp_fnamx */
M43_bp_fnamx:
/* QL:         movem.l d1-d2/a4-a5,-(sp) */
    movem.l d1-d2/a4-a5,-(sp)
/* QL:         jsr     bp_rdchk(pc)    could it be given a value? */
    jsr bp_rdchk(pc)
/* QL:         movem.w 0(a6,a3.l),d0-d2 grab name table bits */
    movem.w 0(a6,a3.l),d0-d2
/* QL:         addq.l  #8,a3           update a3 now */
    addq.l #8,a3
/* QL:         bne.s   M43_fnam_nam        can't assign, so we certainly need its name */
    bne.s M43_fnam_nam
/* QL:         asl.w   #7,d0           is it unset? (it's never -1 in msb) */
    asl.w #7,d0
/* QL:         bvc.s   M43_fnam_nam        yes, unset variable, so use its name */
    bvc.s M43_fnam_nam
/* QL:         lsl.w   #16-7-2,d0      is it a (sub)string? (bit 2 should have been 0) */
    lsl.w #((16-7)-2),d0
/* QL:         or.w    d2,d0           and does it truly have a value? */
    or.w d2,d0
/* QL:         bmi.s   M43_fnam_nam        fp/int or no value offset, so we use its name */
    bmi.s M43_fnam_nam
/* QL:         move.l  a3,a5           copy to a5 for ca_etos */
    move.l a3,a5
/* QL:         jsr     ca_etos(pc)     force string value onto ri stack */
    jsr ca_etos(pc)
/* QL:         bra.s   M43_fnam_pop        done */
    bra.s M43_fnam_pop
/* QL: M43_fnam_nam */
M43_fnam_nam:
/* QL:         moveq   #M43_err.bn,d0 */
    moveq #M43_err.bn,d0
/* QL:         asl.l   #3,d1           make offset to original nt entry */
    asl.l #3,d1
/* QL:         bmi.s   M43_fnam_pop        user boobed - nt ref was negative */
    bmi.s M43_fnam_pop
/* QL:         add.l   M43_bv_ntbas(a6),d1 original nt entry */
    add.l M43_bv_ntbas(a6),d1
/* QL:         move.l  M43_bv_nlbas(a6),a4 name list base */
    move.l M43_bv_nlbas(a6),a4
/* QL:         add.w   2(a6,d1.l),a4   point at name */
    add.w 2(a6,d1.l),a4
/* QL:         moveq   #0,d1 */
    moveq #0,d1
/* QL:         move.b  0(a6,a4.l),d1   no of chars in name (byte!) */
    move.b 0(a6,a4.l),d1
/* QL:         addq.l  #1,a4           beg of chars for ca_putss */
    addq.l #1,a4
/* QL:         jsr     ca_putss(pc)    put the variable's name on the ri stack */
    jsr ca_putss(pc)
/* QL: M43_fnam_pop */
M43_fnam_pop:
/* QL:         movem.l (sp)+,d1-d2/a4-a5 */
    movem.l (sp)+,d1-d2/a4-a5
/* QL:         rts */
    rts 
/* QL: * Open a file */
/* QL: * d0 -  o- error code */
/* QL: * d1 -  o- own job id */
/* QL: * d4 -ip - open type (set to M43_io.share at bp_fopin) */
/* QL: * a0 -  o- channel id */
/* QL: * a3 -i o- start of parameters (8 added) */
/* QL: * a5 -ip - end of parameters */
/* QL: * d3/a1 destroyed */
/* QL: bp_fopin */
bp_fopin:
/* QL:         moveq   #M43_io.share,d4    open read only file */
    moveq #M43_io.share,d4
/* QL: M43_fopen */
M43_fopen:
/* QL:         bsr.s   M43_bp_fname */
    bsr.s M43_bp_fname
/* QL:         bne.s   M43_rts3 */
    bne.s M43_rts3
/* QL:         move.l  d4,d3           put open key in correct register */
    move.l d4,d3
/* QL: M43_trp_open */
M43_trp_open:
/* QL:         moveq   #M43_io.open,d0     open channel */
    moveq #M43_io.open,d0
/* QL: M43_trp2me */
M43_trp2me:
/* QL:         moveq   #-1,d1          for this job */
    moveq #(-1),d1
/* QL: M43_trp2r */
M43_trp2r:
/* QL:         move.l  a1,a0 */
    move.l a1,a0
/* QL:         trap    #4              a0 relative to a6 */
    trap #4
/* QL:         trap    #2 */
    trap #2
/* QL: M43_tstrts3 */
M43_tstrts3:
/* QL:         tst.l   d0 */
    tst.l d0
/* QL: M43_rts3 */
M43_rts3:
/* QL:         rts */
    rts 
/* QL: * Check for optional #chan followed by filename */
/* QL: * Skips return address on any error, leaving just d0 set to error code */
/* QL: * d0 -  o- 0 */
/* QL: * d1 -  o- #chan number */
/* QL: * d5 -  o- #chan channel id (default #1) */
/* QL: * a1 -  o- ri stack pointer to filename string */
/* QL: * a2 -  o- pointer to #chan block */
/* QL: * a3 -i o- start of parameters (16 added) */
/* QL: * a5 -ip - end of parameters */
/* QL: M43_ch_fname */
M43_ch_fname:
/* QL:         jsr     bp_chan(pc)     get channel */
    jsr bp_chan(pc)
/* QL:         bne.s   M43_poprts */
    bne.s M43_poprts
/* QL:         move.l  a0,d5           save id */
    move.l a0,d5
/* QL:         bsr.s   M43_bp_fname        get file name */
    bsr.s M43_bp_fname
/* QL:         bne.s   M43_poprts */
    bne.s M43_poprts
/* QL:         cmp.l   a5,a3           that should have been the last parameter */
    cmp.l a5,a3
/* QL:         beq.s   M43_rts3 */
    beq.s M43_rts3
/* QL:         moveq   #M43_err.bp,d0 */
    moveq #M43_err.bp,d0
/* QL: M43_poprts */
M43_poprts:
/* QL:         addq.l  #4,sp           discard return */
    addq.l #4,sp
/* QL:         rts */
    rts 
/* QL: * Directory listing: DIR{#<chan>,}<filename> */
/* QL: bp_dir */
bp_dir:
/* QL:         bsr.s   M43_ch_fname        get optional #n and file name */
    bsr.s M43_ch_fname
/* QL:         moveq   #M43_io.dir,d3      open with directory key */
    moveq #M43_io.dir,d3
/* QL:         bsr.s   M43_trp_open */
    bsr.s M43_trp_open
/* QL:         bne.s   M43_rts3 */
    bne.s M43_rts3
/* QL:         move.l  a0,a5           save directory channel */
    move.l a0,a5
/* QL:         moveq   #M43_fs.mdinf,d0    get information about the medium... */
    moveq #M43_fs.mdinf,d0
/* QL:         bsr.l   M43_trp3b           ... into the basic buffer */
    bsr.w M43_trp3b
/* QL: M43_closene */
M43_closene:
/* QL:         bne.l   M43_close */
    bne.w M43_close
/* QL:         move.l  d1,-(sp)        save the M43_sector counts */
    move.l d1,-(sp)
/* QL:         move.l  M43_bv_bfbas(a6),a1 write out the medium name */
    move.l M43_bv_bfbas(a6),a1
/* QL:         moveq   #10,d2 */
    moveq #10,d2
/* QL:         bsr.s   M43_w_s_nl */
    bsr.s M43_w_s_nl
/* QL:         move.l  (sp)+,d1 */
    move.l (sp)+,d1
/* QL:         moveq   #0,d4           preset the saved error flag */
    moveq #0,d4
/* QL:         bsr.s   M43_sector          write the M43_sector counts */
    bsr.s M43_sector
/* QL: M43_dir_loop */
M43_dir_loop:
/* QL:         move.l  a5,a0 */
    move.l a5,a0
/* QL:         bne.s   M43_closene */
    bne.s M43_closene
/* QL:         tst.b   M43_bv_brk(a6)      is there a break? */
    tst.b M43_bv_brk(a6)
/* QL:         bpl.l   M43_close           yes - get out now (leaving break set) */
    bpl.w M43_close
/* QL:         moveq   #M43_io.fstrg,d0    now fetch the directory entries */
    moveq #M43_io.fstrg,d0
/* QL:         moveq   #M43_md_deend,d2 */
    moveq #M43_md_deend,d2
/* QL:         bsr.l   M43_trp3b           into the basic buffer */
    bsr.w M43_trp3b
/* QL:         bne.l   M43_close_n */
    bne.w M43_close_n
/* QL:         tst.l   M43_md_delen-M43_md_deend(a6,a1.l) */
    tst.l (M43_md_delen-M43_md_deend)(a6,a1.l)
/* QL:         beq.s   M43_dir_loop        ignore zero length files */
    beq.s M43_dir_loop
/* QL:         move.w  M43_md_denam-M43_md_deend(a6,a1.l),d2  set the character count */
    move.w (M43_md_denam-M43_md_deend)(a6,a1.l),d2
/* QL:         lea     M43_md_denam+2-M43_md_deend(a1),a1 go to the start of the name */
    lea ((M43_md_denam+2)-M43_md_deend)(a1),a1
/* QL:         bsr.s   M43_w_s_nl          write out with newline */
    bsr.s M43_w_s_nl
/* QL:         bra.s   M43_dir_loop */
    bra.s M43_dir_loop
/* QL: * Format medium: FORMAT{#<chan>,}<filename> */
/* QL: bp_formt */
bp_formt:
/* QL:         bsr.s   M43_ch_fname        get optional #n and file name... */
    bsr.s M43_ch_fname
/* QL:         moveq   #M43_io.formt,d0    ... and format */
    moveq #M43_io.formt,d0
/* QL:         bsr.s   M43_trp2r */
    bsr.s M43_trp2r
/* QL:         bne.s   M43_rts4 */
    bne.s M43_rts4
/* QL:         swap    d1 */
    swap d1
/* QL:         move.w  d2,d1           set up like md.inf */
    move.w d2,d1
/* QL: M43_sector */
M43_sector:
/* QL:         move.l  M43_bv_bfbas(a6),a1 */
    move.l M43_bv_bfbas(a6),a1
/* QL:         move.l  d1,0(a6,a1.l) */
    move.l d1,0(a6,a1.l)
/* QL:         lea     4(a1),a0 */
    lea 4(a1),a0
/* QL:         jsr     cn_itod(pc)     convert first one */
    jsr cn_itod(pc)
/* QL:         move.b  #'/',0(a6,a0.l) */
    move.b #(47&255),0(a6,a0.l)
/* QL:         addq.l  #1,a0 */
    addq.l #1,a0
/* QL:         jsr     cn_itod(pc)     convert second one */
    jsr cn_itod(pc)
/* QL:         bsr.s   M43_w_strg          write them both out */
    bsr.s M43_w_strg
/* QL:         moveq   #M43_err.sc,d0 */
    moveq #M43_err.sc,d0
/* QL:         jsr     ut_err(pc)      now write ' sectors' */
    jsr ut_err(pc)
/* QL:         moveq   #0,d0           ensure a correct return */
    moveq #0,d0
/* QL: M43_rts4 */
M43_rts4:
/* QL:         rts */
    rts 
/* QL: M43_w_s_nl */
M43_w_s_nl:
/* QL:         lea     1(a1,d2.w),a0 */
    lea 1(a1,d2.w),a0
/* QL:         move.b  #10,-1(a6,a0.l) tack a newline on the end of the string */
    move.b #(10&255),(-1)(a6,a0.l)
/* QL: M43_w_strg */
M43_w_strg:
/* QL:         move.w  a0,d2 */
    move.w a0,d2
/* QL:         sub.w   a1,d2 */
    sub.w a1,d2
/* QL:         moveq   #M43_io.sstrg,d0    write string */
    moveq #M43_io.sstrg,d0
/* QL:         move.l  d5,a0           output channel */
    move.l d5,a0
/* QL: M43_trp3r1 */
M43_trp3r1:
/* QL:         bra.l   M43_trp3r */
    bra.w M43_trp3r
/* QL: * Copy file to file (with or without header): COPY{_N}<fromfile>,<tofile> */
/* QL: bp_copyn */
bp_copyn:
/* QL:         moveq   #-1,d7          set length unknown */
    moveq #(-1),d7
/* QL: bp_copy */
bp_copy:
/* QL:         bsr.l   bp_fopin        set source... */
    bsr.w bp_fopin
/* QL:         bne.s   M43_rts4 */
    bne.s M43_rts4
/* QL:         move.l  a0,d5 */
    move.l a0,d5
/* QL:         bsr.l   M43_fopnew          ... and destination */
    bsr.w M43_fopnew
/* QL:         bne.s   M43_close_1 */
    bne.s M43_close_1
/* QL:         subq.l  #1,d7           was header required (d7.l now -1 or -2) */
    subq.l #1,d7
/* QL:         bcc.s   M43_copy_lop        if it went to -2, we're not doing the header */
    bcc.s M43_copy_lop
/* QL:         exg     a0,d5 */
    exg a0,d5
/* QL:         bsr.l   M43_gethdr          read header into buffer (d2=length) */
    bsr.w M43_gethdr
/* QL:         exg     a0,d5 */
    exg a0,d5
/* QL:         bne.s   M43_copy_lop        if no header from this device, carry on */
    bne.s M43_copy_lop
/* QL:         move.l  d2,d7           set length of file... */
    move.l d2,d7
/* QL:         moveq   #M43_fs.heads,d0    ... and set header */
    moveq #M43_fs.heads,d0
/* QL:         bsr.s   M43_trp3r1 */
    bsr.s M43_trp3r1
/* QL: M43_copy_lop */
M43_copy_lop:
/* QL:         move.l  M43_bv_bfbas(a6),a1 set buffer base address */
    move.l M43_bv_bfbas(a6),a1
/* QL:         move.l  M43_bv_bfbas+8(a6),d2 use next base as top of area */
    move.l (M43_bv_bfbas+8)(a6),d2
/* QL:         sub.l   a1,d2           buffer length (*** we assume this is < 65536!) */
    sub.l a1,d2
/* QL:         exg     a0,d5           get the right file id */
    exg a0,d5
/* QL:         cmp.l   d7,d2           is buffer greater than remaining number */
    cmp.l d7,d2
/* QL:         bls.s   M43_copy_try */
    bls.s M43_copy_try
/* QL:         tst.l   d7              is file length known (and greater than 0) */
    tst.l d7
/* QL:         ble.s   M43_copy_try */
    ble.s M43_copy_try
/* QL:         move.l  d7,d2           just fetch the remaining number of bytes */
    move.l d7,d2
/* QL: M43_copy_try */
M43_copy_try:
/* QL:         tst.b   M43_bv_brk(a6)      is there a break? */
    tst.b M43_bv_brk(a6)
/* QL:         bpl.s   M43_close_2         yes - get out now (leaving break set) */
    bpl.s M43_close_2
/* QL:         moveq   #M43_io.fstrg,d0    fetch as many bytes as possible */
    moveq #M43_io.fstrg,d0
/* QL:         moveq   #M43_err.nc-M43_err.ef,d3 don't hang about long (was 5, now 9) */
    moveq #(M43_err.nc-M43_err.ef),d3
/* QL:         trap    #4 */
    trap #4
/* QL:         trap    #3 */
    trap #3
/* QL:         move.l  d0,d2 */
    move.l d0,d2
/* QL:         beq.s   M43_copy_w          no problems, go write it out */
    beq.s M43_copy_w
/* QL:         addq.l  #-M43_err.nc,d2 */
.word 20610|((((-M43_err.nc))&7)<<9)
/* QL:         beq.s   M43_copy_w          not complete, go write it out */
    beq.s M43_copy_w
/* QL:         add.l   d3,d2 */
    add.l d3,d2
/* QL:         bne.s   M43_close_2         if not eof, bad error */
    bne.s M43_close_2
/* QL:         moveq   #0,d0           we expected eof eventually */
    moveq #0,d0
/* QL:         tst.w   d1              if eof and no bytes read, we've finished */
    tst.w d1
/* QL:         beq.s   M43_close_2 */
    beq.s M43_close_2
/* QL: M43_copy_w */
M43_copy_w:
/* QL:         moveq   #M43_io.sstrg,d0    write as much as we have read */
    moveq #M43_io.sstrg,d0
/* QL:         move.w  d1,d2 */
    move.w d1,d2
/* QL:         exg     a0,d5 */
    exg a0,d5
/* QL:         bsr.l   M43_trp3b */
    bsr.w M43_trp3b
/* QL:         bne.s   M43_close_2 */
    bne.s M43_close_2
/* QL:         sub.l   d2,d7           how many left (top end of d2 is be 0) */
    sub.l d2,d7
/* QL:         bne.s   M43_copy_lop        if any bytes left, fetch them */
    bne.s M43_copy_lop
/* QL: M43_close_2 */
M43_close_2:
/* QL:         bsr.s   M43_close_b         M43_close one file... */
    bsr.s M43_close_b
/* QL: M43_close_1 */
M43_close_1:
/* QL:         exg     a0,d5           ... and the other */
    exg a0,d5
/* QL: M43_close_b */
M43_close_b:
/* QL:         bra.l   M43_close */
    bra.w M43_close
/* QL: * Close channels: CLOSE{#<chan>{,#<chan>}...} */
/* QL: * No parameters = M43_close all channels above #2 */
/* QL: bp_close */
bp_close:
/* QL:         moveq   #3,d1           ready to M43_close #3 and above */
    moveq #3,d1
/* QL:         cmp.l   a3,a5           are there any parameters at all? */
    cmp.l a3,a5
/* QL:         beq.s   M43_clall           no, so M43_close #3 and all above */
    beq.s M43_clall
/* QL: M43_cllist */
M43_cllist:
/* QL:         bsr.s   M43_opclose         M43_close a channel from the list */
    bsr.s M43_opclose
/* QL:         bne.s   M43_rts5            any problem (other than not open) is bad */
    bne.s M43_rts5
/* QL:         cmp.l   a3,a5           check if any more parameters left */
    cmp.l a3,a5
/* QL:         bne.s   M43_cllist          carry on to end of list */
    bne.s M43_cllist
/* QL:         rts */
    rts 
/* QL: M43_clthis */
M43_clthis:
/* QL:         bsr.s   M43_clblot          wipe out id in slot and M43_close the channel */
    bsr.s M43_clblot
/* QL: M43_clnext */
M43_clnext:
/* QL:         addq.l  #1,d1 */
    addq.l #1,d1
/* QL: M43_clall */
M43_clall:
/* QL:         jsr     bp_chnid(pc)    check this # channel */
    jsr bp_chnid(pc)
/* QL:         beq.s   M43_clthis          a real, open slot, so M43_close it */
    beq.s M43_clthis
/* QL:         subx.l  d0,d0           is there actually a closed slot here? */
    subx.l d0,d0
/* QL:         bmi.s   M43_clnext          yes, keep going */
    bmi.s M43_clnext
/* QL:         rts */
    rts 
/* QL: M43_opclose */
M43_opclose:
/* QL:         cmp.l   a3,a5           check for at least one parameter */
    cmp.l a3,a5
/* QL:         ble.s   M43_err_bp2 */
    ble.s M43_err_bp2
/* QL:         tst.b   1(a6,a3.l)      must be preceeded by a hash */
    tst.b 1(a6,a3.l)
/* QL:         bpl.s   M43_err_bp2 */
    bpl.s M43_err_bp2
/* QL:         jsr     bp_chan(pc)     read the channel no & see if it's there */
    jsr bp_chan(pc)
/* QL:         bne.s   M43_chn_err         wrong number or channel not open */
    bne.s M43_chn_err
/* QL: M43_clblot */
M43_clblot:
/* QL:         moveq   #-1,d2 */
    moveq #(-1),d2
/* QL:         move.l  d2,0(a6,a2.l)   blot out the ch id in the list */
    move.l d2,0(a6,a2.l)
/* QL:         bra.s   M43_close_b         and M43_close it in reality */
    bra.s M43_close_b
/* QL: M43_err_bp2 */
M43_err_bp2:
/* QL:         moveq   #M43_err.bp,d0 */
    moveq #M43_err.bp,d0
/* QL: M43_chn_err */
M43_chn_err:
/* QL:         addq.l  #-M43_err.no,d0     channel not open is ok */
.word 20608|((((-M43_err.no))&7)<<9)
/* QL:         beq.s   M43_rts5 */
    beq.s M43_rts5
/* QL:         subq.l  #-M43_err.no,d0 */
.word 20864|((((-M43_err.no))&7)<<9)
/* QL: M43_rts5 */
M43_rts5:
/* QL:         rts */
    rts 
/* QL: * Open a channel: OPEN|OPEN_IN|OPEN_NEW#<chan>,<filename>{,<opentype>} */
/* QL: bp_openw */
bp_openw:
/* QL:         moveq   #M43_io.new-M43_io.share,d7 */
    moveq #(M43_io.new-M43_io.share),d7
/* QL: bp_openn */
bp_openn:
/* QL:         addq.b  #M43_io.share,d7 */
    addq.b #M43_io.share,d7
/* QL: bp_open */
bp_open:
/* QL:         assert  0,M43_io.old */
/* original assertion: 0,M43_io.old */
/* QL:         bsr.s   M43_opclose         run a check on the channel */
    bsr.s M43_opclose
/* QL:         bne.s   M43_rts5 */
    bne.s M43_rts5
/* QL:         move.l  d7,d4           save open type */
    move.l d7,d4
/* QL:         move.l  d1,d7           save #chan */
    move.l d1,d7
/* QL:         addq.l  #8,a3 */
    addq.l #8,a3
/* QL:         cmp.l   a5,a3 */
    cmp.l a5,a3
/* QL:         beq.s   M43_opnorm          normally just one parameter will be given */
    beq.s M43_opnorm
/* QL:         jsr     ca_gtlin(pc)    if another is present, take it as open code */
    jsr ca_gtlin(pc)
/* QL:         bne.s   M43_rts5 */
    bne.s M43_rts5
/* QL:         move.l  0(a6,a1.l),d4 */
    move.l 0(a6,a1.l),d4
/* QL:         subq.l  #8,a5 */
    subq.l #8,a5
/* QL: M43_opnorm */
M43_opnorm:
/* QL:         subq.l  #8,a3 */
    subq.l #8,a3
/* QL:         bsr.l   M43_fopen */
    bsr.w M43_fopen
/* QL:         bne.s   M43_rts5 */
    bne.s M43_rts5
/* QL:         move.l  d7,d1           restore #chan */
    move.l d7,d1
/* QL:         jmp     bp_chnew(pc) */
    jmp bp_chnew(pc)
/* QL:         vect4000 M43_bp_fname */
/* QL: i setnum 0 */
/* QL: l maclab */
/* QL: i setnum [i]+1 */
/* QL: h setstr [.parm([i])] */
/* QL: o setstr [.left(h,2)]$[.right(h,[.len(h)]-3)] */
/* QL:         xdef    [o] */
/* QL: [o]     equ     [h]-$4000 */
.equ bp$fname,(M43_bp_fname-0x4000)
/* QL:  ifnum [i] < [.nparms] goto l */
/* QL:         end */
