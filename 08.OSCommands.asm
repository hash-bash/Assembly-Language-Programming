%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro 

section .data

menu	db 10,10,'Menu'
		db 10,'1. Type Cmd'
		db 10,'2. Copy Cmd'
		db 10,'3. Delete Cmd'
		db 10,'4. Exit'
		db 10,'Enter Choice : '

lenmenu equ $-menu

msg1 db 10,'Enter command : '
len1 equ $-msg1

msg5 db 10,'Not a valid command '
len5 equ $-msg5

section .bss
choice resb 2
command resb 20
cmdLength resb 8
filename resb 20
display resb 2
handle resb 8
buffer resb 1
section .text
	global _start

_start:

menuDisp:
	println menu,lenmenu
	
	mov rax,00h
	mov rdi,00h
	mov rsi,choice
	mov rdx,02h
	syscall

	cmp byte[choice],31h
	jne next1
	
	call typCmd
	jmp menuDisp

next1:
	cmp byte[choice],32h
	jne next2
	
	call cpyCmd
	jmp menuDisp

next2:
	cmp byte[choice],33h
	jne next3
	
	call delCmd
	jmp menuDisp


next3:
	cmp byte[choice],34h
	je exit
	jmp menuDisp

exit:

	mov rax,60
	syscall


typCmd:
	println msg1,len1

	mov rax,00h
	mov rdi,00h
	mov rsi,command
	mov rdx,20
	syscall

	mov [cmdLength],rax

	mov rsi,command
	mov rcx,[cmdLength]

	mov al,[rsi]
	cmp al,'t'
	je goAhead
	jmp notValid

goAhead:	
	inc rsi
	dec rcx
	jz notValid

	mov al,[rsi]
	cmp al,'y'
	je goAhead1
	jmp notValid

goAhead1:	
	inc rsi
	dec rcx
	jz notValid

	mov al,[rsi]
	cmp al,'p'
	je goAhead2
	jmp notValid

goAhead2:	
	inc rsi
	dec rcx
	jz notValid

	mov al,[rsi]
	cmp al,'e'
	je goAhead3
	jmp notValid

goAhead3:
	inc rsi
	dec rcx			

	inc rsi
	dec rcx			;Skip Space

	mov rdi,filename
next:
	mov al,[rsi]
	cmp al,0ah
	je finish
	mov [rdi],al
	
	inc rsi
	inc rdi
	dec rcx
	jnz next

finish:

	mov rax,02h
	mov rdi,filename
	mov rsi,02h
	mov rdx,0777o
	syscall

	mov [handle],rax

readAgain:

	mov rax,00h
	mov rdi,[handle]
	mov rsi,buffer
	mov rdx,01h
	syscall

	cmp rax,00h
	je comeOut
	
	println buffer,01h

	jmp readAgain

comeOut:

	mov rax,03h
	mov rdi,[handle]
	syscall
	ret

notValid:
	println msg5,len5
ret

cpyCmd:

ret

delCmd:

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