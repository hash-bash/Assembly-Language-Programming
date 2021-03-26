%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data
array db 55h,44h,33h,22h,11h

space db '  '

filename db 'bubblesort.txt',00h

msg1 db 10,'Array is : ',10
len1 equ $-msg1

msg2 db 10,'Sorted array is : ',10
len2 equ $-msg2

section .bss
handle resb 8
display resb 2
accept resb 2
filelength resb 8
buffer resb 50

section .text
	global _start

_start:

	mov rax,02h
	mov rdi,filename
	mov rsi,02h
	mov rdx,0777o
	syscall

	mov [handle],rax


	mov rax,00h
	mov rdi,[handle]
	mov rsi,buffer
	mov rdx,50h
	syscall

	mov [filelength],rax

	mov cl,05h
	mov rdi,array
	mov rsi,buffer
nextElement:
	mov al,[rsi]
	mov [accept],al
	inc rsi
	mov al,[rsi]
	mov [accept+1],al

	push rsi
	push rcx
	call acceptNo
	pop rcx
	pop rsi

	mov [rdi],bl
	inc rsi
	inc rsi
	inc rdi
	dec cl
	jnz nextElement

	println msg1,len1	

	mov cl,05
	mov rsi,array

dispNext:	
	mov bl,[rsi]
	push rcx
	push rsi

	call displayNo
	println display,02h
	println space,02h

	pop rsi
	pop rcx
	inc rsi
	dec cl
	jnz dispNext

	mov ch,04h
outer:
	mov cl,ch
	mov rsi,array
	mov rdi,array+1
inner:
	mov al,[rsi]
	mov bl,[rdi]
	cmp al,bl
	jle skipSwap
	mov [rsi],bl
	mov [rdi],al
skipSwap:
	inc rsi
	inc rdi
	dec cl
	jnz inner

	dec ch
	jnz outer

	println msg2,len2

	mov cl,05
	mov rsi,array

dispNext1:	
	mov bl,[rsi]
	push rcx
	push rsi

	call displayNo
	println display,02h
	println space,02h

	pop rsi
	pop rcx

	inc rsi
	dec cl
	jnz dispNext1

	mov rax,01h
	mov rdi,[handle]
	mov rsi,msg2
	mov rdx,len2
	syscall

	mov cl,05h
	mov rsi,array
doAgain:
	mov bl,[rsi]

	push rcx
	push rsi

	call displayNo

	mov rax,01h
	mov rdi,[handle]
	mov rsi,display
	mov rdx,02h
	syscall

	mov rax,01h
	mov rdi,[handle]
	mov rsi,space
	mov rdx,01h
	syscall

	pop rsi	
	pop rcx
	
	inc rsi
	dec cl
	jnz doAgain	

	mov rax,03h
	mov rdi,[handle]
	syscall

	mov rax,60
	syscall

acceptNo:

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

ret