;
; file: asm_main.asm


%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
        syswrite: equ 4
        stdout: equ 1
        exit: equ 1
        SUCCESS: equ 0
        kernelcall: equ 80h
	
	prompt1	db	"What is the base of the array:", 0
	prompt2 db	"What is the length of the array:" ,0
	prompt3	db	"What is the scalar:", 0
	
	myArray	times 100 db 1 ;creates an aray of 100 0's

; uninitialized data is put in the .bss segment
;
segment .bss

	array_size	resd 1 	;i.e my_array[array_size] (in c)
	array_base	resd 1	;i.e my_array = [base, base*2, base*3, base*4, base*5...]
	array_scalar	resd 1	;i.e my_second_array = [base*scalar, base*2*sclar, base*3*sclar...]

; code is put in the .text segment
;
segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha
; *********** Start  Assignment Code *******************

	push	prompt1
	pop	eax
	call	print_string	;mov string into eax and call
	call	read_int	;array base should be in eax now
b1:
	mov	[array_base], eax
	and	eax, 0

	push	prompt3
	pop 	eax
	call	print_string
	call	read_int

	mov	[array_scalar], eax
	and	eax, 0
b2:

	push	prompt2
	pop	eax
	call	print_string
	call	read_int
	mov	[array_size], eax
	and	eax, 0

	push	myArray


	;mov	eax, [array_size]
	;call	print_int
	;call	print_nl	
;
	;mov	eax, [array_base]
	;call	print_int
	;call	print_nl
;
	
	;mov	eax, [array_scalar]
	;call	print_int
	;call	print_nl
	
;        popa
 ;       mov     eax, SUCCESS       ; return back to the C program
  ;      leave                     
   ;     ret


create_array:
;	enter	0,0
	
	pop	eax
	mov	ecx, [array_size]
					
	mov	ebx, [array_scalar]
b3:
	mov	esi, eax
	mov	edi, eax
	push 	eax

;	mov	esi, [ebp+8]
;	mov	edi, [ebp+8]
	
	start_loop:
b4:
		lodsw
		;mul	ebx
		stosw
		loop	start_loop	
	
	end_loop:

	mov	ecx, [array_size]
	pop	eax	
	mov	esi, eax 
	print_array:
		lodsw
		movsx	eax, ax
		call	print_int
		call	print_nl
		loop	print_array
	
; *********** End Assignment Code **********************

        popa
        mov     eax, SUCCESS       ; return back to the C program
        leave                     
        ret


