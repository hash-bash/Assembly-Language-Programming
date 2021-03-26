%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data
menumsg db 10,'Menu'
        db 10,'1. Add & Shift'
		db 10,'2. Successive Add'
		db 10,'3. Exit'
		db 10,10,'Enter Choice : '

lenmenu equ $-menumsg	

msg1 db 10,'Enter Muld : '
len1 equ $-msg1

msg2 db 10,'Enter Mulr : '
len2 equ $-msg2

msg3 db 10,'Product is : '
len3 equ $-msg3

section .bss
choice resb 2
muld resb 1
mulr resb 1
result resb 2

display resb 2
accept resb 3

section .text
	global _start

_start:

menuDisp:
	println menumsg,lenmenu 

	mov rax,00h
	mov rdi,00h
	mov rsi,choice
	mov rdx,02h
	syscall

	cmp byte[choice],31h
	jne next

	call addShift
	jmp menuDisp
next:
	cmp byte[choice],32h
	jne next1

	call successive
	jmp menuDisp
	
next1:
	cmp byte[choice],33h
	je exit
	jmp menuDisp
exit:
	mov rax,60
	syscall

addShift:
	println msg1,len1
	call acceptNo
	mov [muld],bl

	println msg2,len2
	call acceptNo
	mov [mulr],bl

	mov dx,0000h
	mov bh,00h
	mov bl,[muld]
	mov cl,08h
	mov al,[mulr]

chkNext:
	shr al,01h
	jnc onlyShift

	add dx,bx

onlyShift:
	shl bx,01h
	dec cl
	jnz chkNext

	mov [result],dx

	println msg3,len3

	mov bl,[result+1]
	call displayNo
	
	mov bl,[result]
	call displayNo	

ret

successive:
	println msg1,len1
	call acceptNo
	mov [muld],bl

	println msg2,len2
	call acceptNo
	mov [mulr],bl

	
	mov cl,[mulr]
	mov dx,0000h
	mov bh,00h
	mov bl,[muld]
again:
	add dx,bx
	dec cl
	jnz again

	mov [result],dx

	println msg3,len3

	mov bl,[result+1]
	call displayNo
	
	mov bl,[result]
	call displayNo	

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