;
; file: asm_main.asm

%include "asm_io.inc"
;
; initialized data is put in the .data segment
;

segment .data

	prompt1	db	"What is the size of the array?:",0
	prompt2	db	"What is the scalar of the array?", 0

; uninitialized data is put in the .bss segment
;
segment .bss

	array_in_len	resd	1
	array_in_sca	resd	1
;
; code is put in the .text segment
;
segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha
; next print out result message as series of steps

	push	prompt1
	pop	eax
	call	print_string
	call	read_int
b1:
	push	eax
	
	push	prompt2
	pop	eax
	call	print_string
	call	read_int
b2:
	push	eax

	mov	edx,return1
	push	edx

	call	arrayFunc
return1:

	;return the stack to the original state it was before the program
	pop	eax
	

        popa
        mov     eax, 0            ; return back to C
        leave
        ret

segment .data

segment .bss

array_size	resd	1
array_scalar	resd	1

array	resd	1	;create an array of uninitalized size that is a reserved doubleword
	
segment .text

arrayFunc:
	pop	ebx ;place the return address here

	pop	eax ;mov the scalar into eax
	pop	eax
;	call	print_int
;	call	print_nl
	mov	[array_scalar], eax
b3:
	pop	eax	;mov the array size into eax to be stored into the value later
;	call	print_int
;	call	print_nl
	mov	[array_size], eax
b4:
	xor	eax, eax	;0 out eax
	push	ebx
	
	mov	ecx, [array_size]	;place the array size into ecx
	mov	ebx, array	;mov the starting location of the array into ebx
b5:

	cmp	ecx, 0
	js	end_create

create_array:
	mov	[ebx+4*ecx], ecx ;mov the value of ecx (the array size from the top to bottom)
	mov	al, [ebx+4*ecx]	;mov the value into al to be printed
	call	print_int
	call	print_nl
	loop	create_array
end_create:
	call	print_nl
	call	print_nl
	and	eax, 0
	and	ebx, 0
	and	ecx, 0
	and	edx, 0

scale_array:
	mov	ebx, array
	mov	ecx, [array_size]

	cmp	ecx, 0
	js	end_scale_loop

scale_loop:
	mov	eax, [array_scalar]
	mov	dl, [ebx+4*ecx]
	mul	dl
	mov	[ebx+4*ecx], eax
	call	print_int
	call	print_nl
b6:
	loop	scale_loop
	
end_scale_loop:

	pop	ebx
	jmp	ebx
