%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data
msg0 db 10,'How many elements : '
len0 equ $-msg0

msg1 db 10,'Enter array elements : '
len1 equ $-msg1

msg2 db 10,'Before transfer : '
len2 equ $-msg2

msg3 db 10,'Array is : '
len3 equ $-msg3

msg5 db 10,'After transfer : '
len5 equ $-msg5

msg6 db 10,'Overlap cnt : '
len6 equ $-msg6

space db '  '

section .bss
array resb 15
cnt resb 1
ovcnt resb 1

display resb 2
accept resb 3

section .text
	global _start

_start:

	println msg0,len0
	call acceptNo
	mov [cnt],bl

	println msg1,len1

	mov cl,[cnt]
	mov rsi,array
movNext:
	push rcx
	push rsi
	call acceptNo
	pop rsi
	pop rcx

	mov [rsi],bl
	inc rsi
	dec cl
	jnz movNext
	
	println msg6,len6
	call acceptNo
	mov [ovcnt],bl

	println msg2,len2
	println msg3,len3

	mov cl,15
	mov rsi,array

dispNext:	
	mov bl,[rsi]
	push rcx
	push rsi

	call displayNo
	println space,02h

	pop rsi
	pop rcx

	inc rsi
	dec cl
	jnz dispNext

	mov rsi,array
	mov rcx,00h
	mov cl,[cnt]
	add rsi,rcx
	dec rsi

	mov rdi,array
	mov rcx,00h
	mov cl,[cnt]
	add cl,cl
	sub cl,[ovcnt]
	add rdi,rcx
	dec rdi

	mov rcx,00h
	mov cl,[cnt]
	
	std 
	rep movsb

	println msg5,len5
	println msg3,len3

	mov cl,15
	mov rsi,array

dispNext1:	
	mov bl,[rsi]
	push rcx
	push rsi

	call displayNo
	println space,02h

	pop rsi
	pop rcx

	inc rsi
	dec cl
	jnz dispNext1

	mov rax,60
	syscall

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