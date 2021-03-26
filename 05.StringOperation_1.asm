extern space,lines,occurence
global msg3,len3,buffer,filelength,msg4,len4,msg5,len5,msg6,len6,character

%macro println 2
	mov rax,01h
	mov rdi,01h
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

section .data
msg1 db 10,'Enter file name : '
len1 equ $-msg1

msg2 db 10,'File contents are : '
len2 equ $-msg2

msg3 db 10,'No of spaces : '
len3 equ $-msg3

msg4 db 10,'No of lines : '
len4 equ $-msg4

msg5 db 10,'No of occur : '
len5 equ $-msg5

msg6 db 10,'Enter char : '
len6 equ $-msg6

menumsg db 10,'Menu'
        db 10,'1.space'
	db 10,'2.lines'
	db 10,'3.occurence'
	db 10,'4.Exit'
	db 10,10,'Enter Choice'

lenmenu equ $-menumsg

section .bss
filename resb 20
handle resb 8
buffer resb 500
filelength resb 8
choice resb 2
character resb 2

section .text
	global _start

_start:

	println msg1,len1

	mov rax,00h
	mov rdi,00h
	mov rsi,filename
	mov rdx,20
	syscall

	mov rsi,filename
	add rsi,rax
	dec rsi
	mov al,00h
	mov [rsi],al

	mov rax,02h
	mov rdi,filename
	mov rsi,02h
	mov rdx,0777o
	syscall

	mov [handle],rax

	mov rax,00h
	mov rdi,[handle]
	mov rsi,buffer
	mov rdx,500
	syscall
	
	mov [filelength],rax

	println msg2,len2

	println buffer,[filelength]

	mov rax,03h
	mov rdi,[handle]
	syscall

menuDisp:
	println menumsg,lenmenu 

	mov rax,00h
	mov rdi,00h
	mov rsi,choice
	mov rdx,02h
	syscall

	cmp byte[choice],31h
	jne next

	call space
	jmp menuDisp
next:
	cmp byte[choice],32h
	jne next1

	call lines
	jmp menuDisp
	
next1:
	cmp byte[choice],33h
	jne next2
	call occurence
	jmp menuDisp

next2:
	cmp byte[choice],34h
	je exit
	jmp menuDisp

exit:
	mov rax,60
	syscall