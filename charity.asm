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
	push t1
	pusha
	mov	[sp_1], sp

    mov sp, t2stack	+ 256
	push t2
	pusha
	mov	[sp_2], sp

	mov sp, t3stack	+ 256
	push t3
	pusha
	mov	[sp_3], sp

	mov sp, t4stack	+ 256
	push t4
	pusha
	mov	[sp_4], sp

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

t3:
		mov dx, t3msg
		call puts
		jmp yield
		jmp t3
t4:
		mov dx, t4msg
		call puts
		jmp yield
		jmp t4
		
yield:
		cmp word[stack_num],1
		je 	.switch_1
		cmp word[stack_num],2
		je .switch_2
		cmp word[stack_num],3
		je .switch_3
		cmp word[stack_num],4
		je .switch_4
		

.switch_1:
	pusha
	mov [sp_1], sp
	mov sp, [sp_2]
	inc word[stack_num]
	popa
	jmp t1
	
.switch_2:
	pusha
	mov [sp_2], sp
	mov sp, [sp_3]
	inc word[stack_num]
	popa
	jmp t2

.switch_3:
	pusha
	mov [sp_3], sp
	mov sp, [sp_4]
	inc word[stack_num]
	popa
	jmp t3

.switch_4:
	pusha
	mov [sp_4], sp
	mov sp, [sp_1]
	mov word[stack_num], 1
	popa
	jmp t4


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
	t3stack	times	256	dw	0 ; Stack for thread 2
	t4stack	times	256	dw	0 ; Stack for thread 2

	sp_1	dd 0
	sp_2	dd 0
	sp_3	dd 0
	sp_4	dd 0

	stack_num	dd 	1
	
	saved_sp	dd	0 		  ; Saved stack pointer
	
	t1msg		db	"This is thread 1", 13, 10, 0
	t2msg		db	"This is thread 2", 13, 10, 0
	t3msg		db	"This is thread 3", 13, 10, 0
	t4msg		db	"This is thread 4", 13, 10, 0
