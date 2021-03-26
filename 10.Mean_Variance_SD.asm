%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

segment .data
array dd 1.1,2.2,3.3,4.4,5.5

mdivfact dw 5

precFact dw 10000

msg1 db 10,13,'Mean value is : '
len1 equ $-msg1

msg2 db 10,13,'Variance is : '
len2 equ $-msg2

msg3 db 10,13,'Standard deviation is : '
len3 equ $-msg3

dot db '.'

section .bss
meanP resb 10
mean resb 4
variP resb 10
vari resb 4
stdDev resb 10
display resb 2

section .text
	global _start
_start:
	finit
	mov rsi,array
	mov cl,05h
	fldz
addNext:
	fadd dword[rsi]
	add rsi,04h
	dec cl
	jnz addNext

	fild word [mdivfact]
	fdiv
	fst dword [mean]
	fild word [precFact]
	fmul
	fbstp [meanP]

	println msg1,len1

	mov rsi,meanP+9
	call dispBcd


	mov cl,05h
	mov rsi,array
	fldz
again1:
	fld dword [rsi]
	fld dword [mean]
	fsub
	fmul st0,st0
	fadd
	add rsi,04h
	dec cl
	jnz again1

	fild word [mdivfact]
	fdiv
	fst dword [vari]
	fild word [precFact]
	fmul
	fbstp [variP]

	println msg2,len2
	mov rsi,variP+9
	call dispBcd

	fld dword [vari]
	fsqrt
	fild word [precFact]
	fmul
	fbstp [stdDev]
	println msg3,len3
	mov rsi,stdDev+9
	call dispBcd


	mov rax,60
	syscall
dispBcd:
	mov cl,10
	mov ch,00h
	;Flag for checking . printed or not

dispNext:
	cmp cl,02h
	jne goAhead
	push rcx
	push rsi
	println dot,1
	pop rsi
	pop rcx
	mov ch,01h
goAhead:
	mov bl,[rsi]
	cmp ch,01h
	je goDisp
	cmp bl,00h
	je skip
goDisp:
	push rcx
	push rsi
	call displayNo
	pop rsi
	pop rcx
skip:
	dec rsi
	dec cl
	jnz dispNext
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

	println display,2
ret