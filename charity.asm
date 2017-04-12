; CpS 230 Team Project Alpha: Team Charity (the greatest of these)
; Members: Reed, Santana, Yurkin
;---------------------------------------------------
; Alpha version program.  Details here: https://protect.bju.edu/cps/courses/cps230/project/project/
; GitHub Repository: https://github.com/trademark18/charity-kernel/blob/master/charity.asm
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
<<<<<<< HEAD
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
=======
	mov ax, t1stack ; tell start_thread where the stack starts
	mov bx, .t1 ; Tell it where the thread's code starts
	jmp .start_thread 
	 ; TODO: we need to make start_thread return here
	 
	mov ax, t2stack
	mov bx, .t2
	jmp .start_thread
	
	;jmp yield.second_half ; Then somehow jump into t1
	jmp .t1
	
	;mov dx, t2stack ; Debug
	;mov word [saved_sp], t2stack
	
	;mov ax, t1stack
	;jmp start_thread ; Start thread 1
>>>>>>> refs/remotes/trademark18/master
	
	
t1:
		mov dx, t1msg
		call puts
<<<<<<< HEAD
		jmp yield
		jmp t1
		
=======
		call yield
		jmp .t1
>>>>>>> refs/remotes/trademark18/master
	
	
t2:
		mov dx, t2msg
		call puts
<<<<<<< HEAD
		jmp yield
		jmp t2
		
	
	
	
	; This is copied straight off the board from class 
yield:
		pushf
		push cs
		cmp word[stack_num],1
		je 	.switch_1
		cmp word[stack_num],2
		je .switch_2	

.switch_1:
	push t1
	pusha
	mov [sp_1], sp
	mov sp, [sp_2]
	inc word[stack_num]
	popa
	jmp t1
.switch_2:
	push t2
	pusha
	mov [sp_2], sp
	mov sp, [sp_1]
	mov word[stack_num], 1
	popa
	jmp t2


=======
		call yield
		jmp .t2
	
	
	
	.start_thread: ; Takes top of target stack in ax
		; Load up S1's saved state starting at the beginning of t1stack
		;mov ax, t1stack ; Move stack pointer to top of S1 stack (256 bytes)
		
		add ax, 0x100 ; Go to the top of the stack
		mov sp, ax
		
		; Push data (stack) location
		push bx
		; Push registers
		
		;xor ax, ax ; -------
		mov ax, 0x1
		mov bx, 0x2
		mov cx, 0x3
		mov dx, 0x4
		mov si, 0x5
		mov di, 0x6
		mov bp, 0x7
		;xor bx, bx ;
		;xor cx, cx ;
		;xor dx, dx ;  Stick zeros in the saved registers
		;xor si, si ;
		;xor di, di ;
		;xor bp, bp ; -------
		
		push ax
		push bx
		push cx
		push dx
		push si
		push di
		push bp
		
		mov word [saved_sp], sp
		;ret
		
		jmp yield.second_half
	
	; This is copied straight off the board from class 
yield:
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	
	mov ax, [saved_sp]
	mov [saved_sp], sp
	mov sp, ax
	
	.second_half:
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
		
		
>>>>>>> refs/remotes/trademark18/master
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
	
	t1msg		db	"This is thread 1", 10, 0
	t2msg		db	"This is thread 2", 10, 0

	ivt8_offset	dd	0
	ivt8_segment	dd	0