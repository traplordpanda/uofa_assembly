section .data
	msg1: db"Here are the array element values",10,0
	msgL1: equ $-msg1
	msg2: db"The max value for the array is",10,0
	msgL2: equ $-msg2

	array1: dd 12, 16, 6, 18, 10, 40, 30
	array1N: equ ($-array1)/4
	max dd 0

section .text
global main
main:
	push ebp
	mov ebp, esp

    ;output first message
	mov ecx, msg1
	mov edx, msgL1
	call printString
	
    ;move base address of array into ebx and save size
	mov ebx, array1
	mov ecx, array1N
	call printArray
    
	;output second message
    mov ecx, msg2
    mov edx, msgL2
    call printString
        
    ;move base address of array into ebx and size int ecx and array to move into in ecx
	mov ebx, array1
	mov ecx, array1N
	call findMax
	
	;print output of max
	mov ecx, [max]
	mov edx, 4
	call printDec
	call printLn

        
	mov esp, ebp
	pop ebp
	ret

printArray:
	
	mov eax, [ebx]
	call printDec
	call printLn
	add ebx, 4
	loop printArray
	
	mov esp, ebp
	pop ebp
	ret 

findMax:
section .text
	push ebp
	mov ebp, esp


	
top1:
	mov eax, [ebx]	;access first array element move it's value to eax
	cmp eax, [max]	;compare eax value to max stored  
	jl L2			;if less skip moving value to edx
	mov [max], eax
	L2:
	add ebx, 4		;move to next array value
	loop top1		



	mov esp, ebp 
	pop ebp
	ret 


	
	
printDec:
section .bss
	decstr resb 10
	ct1 resd 1		;keep track of string size

section .text
	pusha

	mov dword[ct1],0 	;assume initially 0
	mov edi,decstr		;edi points to dec-string in memory
	add edi,9			;mov the last element of string
	xor edx, edx		;clear out edx for 64 bit division

	whileNotZero:
	mov ebx, 10			;store 10 for division
	div ebx				;divide by 10
	add ebx,'0'			;convert to ascii char
	mov byte[edi],dl	;move to string
	dec edi				; mov to next char in string
	inc dword[ct1]		;increment char counter
	xor edx, edx		;clear edx 
	cmp eax, 0			;is remainder 0
	jne whileNotZero	; if not keep looping

	inc edi				;conversion, finish, bring edi
	mov ecx, edi		;back to beginning of string, make ecx
	mov edx, [ct1]		;point to it, and edx gets # chars
	mov eax, 4			;and print! to the stndout
	mov ebx, 1			
	int 80h

	popa
	ret

printString:
	;save register values of the called function
	pusha

	;string is pointed by ecx, edx has it's length
	mov eax, 4
	mov ebx, 1
	int 80h

	;return old register values of the called function
	popa
	ret

printLn:
section .data
	n1 db"",10

section .text
	pusha

	mov ecx, n1
	mov edx, 1
	mov eax, 4
	call printString

	popa 
	ret 
