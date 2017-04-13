; CpS 230 Team Project Alpha: Team Charity (the greatest of these)
; Members: Reed, Santana, Yurkin
;---------------------------------------------------
; Alpha version program.  Details here: https://protect.bju.edu/cps/courses/cps230/project/project/
;---------------------------------------------------
bits 16

; NECESSARY when creating "COM" files (simple DOS executables).
; (tells NASM take into account the fact that DOS loads
;  COM files at offset 0x100 in memory)
org	0x100

IVT8_OFFSET_SLOT	equ	4 * 8		
IVT8_SEGMENT_SLOT	equ	IVT8_OFFSET_SLOT + 2

section	.text

start:
	mov sp, t1stack	+ 256
	;pushf
	;push cs
	push t1
	pusha
	mov	[sp_1], sp

    mov sp, t2stack	+ 256
	;pushf
	;push cs
	push t2
	pusha
	mov	[sp_2], sp
	

	jmp	t1
	
	
t1:
		mov dx, t1msg
		call puts
		jmp yield
		jmp t1
		
	
	
t2:
		mov dx, t2msg
		call puts
		jmp yield
		jmp t2
		
	
	
	
	; This is copied straight off the board from class 
yield:
		;pushf
		;push cs
		cmp word[stack_num],1
		je 	.switch_1
		cmp word[stack_num],2
		je .switch_2

.switch_1:
	;push t1
	pusha
	mov [sp_1], sp
	mov sp, [sp_2]
	inc word[stack_num]
	popa
	jmp t1
.switch_2:
	;push t2
	pusha
	mov [sp_2], sp
	mov sp, [sp_1]
	mov word[stack_num], 1
	popa
	jmp t2


	; print NUL-terminated string from DS:DX to screen using BIOS (INT 10h)
	; takes NUL-terminated string pointed to by DS:DX
	; clobbers nothing
	; returns nothing
puts:
	push	ax
	push	cx
	push	si
	
	mov	ah, 0x0e
	mov	cx, 1		; no repetition of chars
	
	mov	si, dx
.loop:	mov	al, [si]
	inc	si
	cmp	al, 0
	jz	.end
	int	0x10
	jmp	.loop
.end:
	pop	si
	pop	cx
	pop	ax
	ret



section	.data
	t1stack	times	256	dw	0 ; Stack for thread 1
	t2stack	times	256	dw	0 ; Stack for thread 2

	sp_1	dd 0
	sp_2	dd 0

	stack_num	dd 	1
	
	saved_sp	dd	0 		  ; Saved stack pointer
	
	t1msg		db	"This is thread 1", 13, 10, 0
	t2msg		db	"This is thread 2", 13, 10, 0

	ivt8_offset	dd	0
	ivt8_segment	dd	0