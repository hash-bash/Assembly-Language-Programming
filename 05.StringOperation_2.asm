global space,lines,occurence
extern msg3,len3,buffer,filelength,msg4,len4,msg5,len5,msg6,len6,character

%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data

section .bss
display resb 2

section .text

space:
	println msg3,len3

	mov rsi,buffer
	mov rcx,[filelength]
	mov bl,00h		;space count	

	mov al,' '
chkNext:
	cmp al,[rsi]
	jne skip

	inc bl
skip:
	inc rsi
	dec rcx
	jnz chkNext
	
	call displayNo

ret

lines:

	println msg4,len4

	mov rsi,buffer
	mov rcx,[filelength]
	mov bl,00h		;Line count	

	mov al,0ah		;ascci of enter
chkNext1:
	cmp al,[rsi]
	jne skip1

	inc bl
skip1:
	inc rsi
	dec rcx
	jnz chkNext1
	
	call displayNo
ret

occurence:

	println msg6,len6

	mov rax,00h
	mov rdi,00h
	mov rsi,character
	mov rdx,02h
	syscall

	println msg5,len5
	
	mov rsi,buffer
	mov rcx,[filelength]
	mov bl,00h		;char count	

	mov al,[character]		;ascci of enter
chkNext2:
	cmp al,[rsi]
	jne skip2

	inc bl
skip2:
	inc rsi
	dec rcx
	jnz chkNext2
	
	call displayNo

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