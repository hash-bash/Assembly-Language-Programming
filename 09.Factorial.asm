%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data
msg1 db 10,'Enter number : '
len1 equ $-msg1

msg2 db 10,'Factorial of number is : '
len2 equ $-msg2

fact0 db 10,'Factorial of 0 is : 1'
factlen equ $-fact0

section .bss
display resb 2
accept resb 3	
number resb 1
result resb 8

section .text
	global _start
_start:

	println msg1,len1

	call acceptNo
	mov [number],bl

	cmp bl,00h
	jne goAhead
	println fact0,factlen
	jmp exit

goAhead:

	println msg2,len2

	mov bl,[number]

	call fact

	mov [result],rax

	mov rsi,result+7
	mov rcx,08h
dispNext:
	mov bl,[rsi]
	push rcx
	push rsi
	call displayNo
	pop rsi
	pop rcx
	dec rsi
	dec rcx
	jnz dispNext

exit:
	mov rax,60
	syscall

fact:
	cmp bl,01h
	jne doStack	
	mov ax,01h
ret

doStack:
	push rbx
	dec bl
	call fact
	pop rbx
	mul rbx
ret

acceptNo:

	mov rax,00h
	mov rdi,00h
	mov rsi,accept
	mov rdx,03h
	syscall

	mov al,[accept]
	sub al,30h
	cmp al,09h
	jle dontSub
	sub al,07h

dontSub:	
	mov cl,04h
	shl al,cl
	mov bl,al

	mov al,[accept+1]
	sub al,30h
	cmp al,09h
	jle dontSubb
	sub al,07h

dontSubb:
	or bl,al
ret

displayNo:

	mov al,bl
	and al,0f0h
	mov cl,04h
	shr al,cl
	add al,30h
	cmp al,39h
	jle dontAdd
	add al,07h

dontAdd:
	mov [display],al

	mov al,bl
	and al,0fh
	add al,30h
	cmp al,39h
	jle dontAddd
	add al,07h

dontAddd:
	mov [display+1],al

	println display,02h

ret