main:
    jsr enter_super

    move.w #$2,-(sp)        ; r/w mode
    pea    file_name
    move.w #$3D,-(sp)       ; fopen
    trap   #1
    addq.l #6,sp            ; clean stack
    tst.l  d0               ; check d0 for error code
    bmi    exit             ; quit if so
    move   d0,file_handle   ; store file handle

    jsr exit_super
    jmp exit

enter_super:                ;;; enter super mode and store stack pointer
    clr.l  -(sp)            ; clear the stack
    move.w #32,-(sp)        ; push opcode 32 (Super)
    trap   #1               ; call gemdos
    addq.l #6,sp            ;
    move.l d0,old_sp        ; store the old stack pointer
    rts

exit_super:                 ;;; exit super mode and restore stack pointer
    move.l old_sp,-(sp)     ; push old stack pointer
    move.w #32,-(sp)        ; push Super() again to go back to user mode
    trap   #1               ; call gemdos
    addq.l #6,sp
    rts

exit:                       ;;; exit the app
    clr.l  -(sp)            ; clear the stack
    trap   #1               ; call gemdos (exit)s



section data

old_sp       dc.l 0
file_name    dc.b 'input.txt',0
file_handle  dc.b 0