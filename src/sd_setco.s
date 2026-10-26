/* ROM section sd_setco */
.balign 2,0
/* QL: * d0 -i o- paper, strip or ink key / error code */
/* QL: * d1 -i  - required colour */
/* QL: * a0 -ip - address of definition block */
/* QL: * a1 -   - address of colour mask */
/* QL: sd_setco */
sd_setco:
/* QL:         move.b  d1,M119_sd_pcolr-M119_sd.setpa(a0,d0.w) set colour byte */
    move.b d1,(M119_sd_pcolr-M119_sd.setpa)(a0,d0.w)
/* QL:         lsl.w   #2,d0           select mask by quadrupling d0 */
    lsl.w #2,d0
/* QL:         lea     M119_sd_pmask-M119_sd.setpa<<2(a0,d0.w),a1 get address */
    lea (M119_sd_pmask-(M119_sd.setpa<<2))(a0,d0.w),a1
/* QL:         moveq   #0,d0           clear error flag */
    moveq #0,d0
/* QL:         jmp     cs_color(pc)    go set up colour masks */
    jmp cs_color(pc)
/* QL:         end */
