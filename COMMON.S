main:
		jsr					enter_super
		move.w			#$2,-(sp)												; r/w mode
		pea					file_name
		move.w			#$3d,-(sp)											; fopen (absolute path)
		trap				#1
		tst.l				d0															; check d0 for error code
		bmi					exit														; quit if so
		move				d0,file_handle									; store file handle
		addq.l			#8,sp														; reset stack pointer

;; d0 now contains a handle to the file

		move.w			#2,-(sp)												; seek mode from end of file
		move.w			file_handle,-(sp)								; file handle
		clr.l				-(sp)														; 0 byte offset (same as move.l #0)
		move.w			#66,-(sp)												; fseek
		trap				#1
		tst.l				d0															; check for error
		bmi					exit														; quit if so
		add.l				#10,sp													; three words and a long
    
;; d0 now contains the length of the file

		jsr					exit_super
		jmp					exit

enter_super:																		;;; enter super mode and store stack pointer
		clr.l				-(sp)														; zero argument  (same as move.l #0)
		move.w			#32,-(sp)												; push opcode 32 (Super)
		trap				#1															; call gemdos
		addq.l			#6,sp														; reset stack pointer
		move.l			d0,old_sp												; store the old stack pointer
		rts

exit_super:																			;;; exit super mode and restore stack pointer
		move.l			old_sp,-(sp)										; push old stack pointer
		move.w			#32,-(sp)												; push Super() again to go back to user mode
		trap				#1															; call gemdos
		addq.l			#6,sp
		rts

exit:																						;;; exit the app
		clr.l				-(sp)														; opcode 0
		trap				#1															; call gemdos (exit)


section: bss
old_sp: ds.l		1
file_handle: ds.b 1


section: data
file_name: dc.b	'D:\WORK\M68KAOC\DAY1\INPUT.TXT',0

