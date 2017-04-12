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

section	.text

start:
	mov cx, t1stack ; Debug
	mov dx, t2stack ; Debug
	mov word [saved_sp], t2stack
	
	;mov ax, t1stack
	jmp .start_threads ; Start thread 1
	
	
	.t1:
		mov dx, t1msg
		call puts
		call yield
		jmp .t1
	
	
	.t2:
		mov dx, t2msg
		call puts
		call yield
		jmp .t2
	
	
	
	.start_threads: ; Takes top of target stack in ax
		; Load up S1's saved state starting at the beginning of t1stack
		mov ax, t1stack ; Move stack pointer to top of S1 stack (256 bytes)
		add ax, 0x100 ; Go to the top of the stack
		mov sp, ax
		
		; Push t1stack
		push .t1
		; Push registers
		
		xor ax, ax ; -------
		xor bx, bx ;
		xor cx, cx ;
		xor dx, dx ;  Stick zeros in the saved registers
		xor si, si ;
		xor di, di ;
		xor bp, bp ; -------
		
		push ax
		push bx
		push cx
		push dx
		push si
		push di
		push bp
		
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
	
	.second_half:
	mov ax, [saved_sp] ; Problem here
	mov [saved_sp], sp
	mov sp, ax
	
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret
		
		
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
	t1stack	times	256	dd	0 ; Stack for thread 1
	t2stack	times	256	dd	0 ; Stack for thread 2
	
	saved_sp	dd	0 		  ; Saved stack pointer
	
	t1msg		db	"This is thread 1", 10, 0
	t2msg		db	"This is thread 2", 10, 0