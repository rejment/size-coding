; Sudoku solver for hcompo 25
;
;	v0.7	143b	2006-01-10
;	v0.6	147b	2006-01-09 (plane from chicago)
;	v0.5	154b	submitted 2006-01-06
;	v0.4	157b	submitted 2005-12-14
;	v0.3	180b	submitted 2005-12-14
;	v0.2	190b	2005-12-14
;	v0.1  268b	2005-12-13
;
; nasmw -fbin -oentry.com entry.asm
;

	org	100h

main:
		mov		ah, 3fh
		call	io
		mov		di, dx
		dec		bx
		dec		bx
	
recurse:
		pusha
nextcell:
		cmp		bl, 168
		jne		short notdone

		; print solution
		mov		ah, 40h
		mov		bl, 1
		call	io
		mov		ah, 4Ch			; exit
io:
		mov		cl, 171
		mov		dx, sudoku
		int		21h				; read/write/exit
		ret

notdone:
		inc		bx
		cmp		byte [bx+di], 21h
		jle		short nextcell

		mov		dl, '1'
	
		cmp		byte [bx+di], dl
		jge		short nextcell
	
testvalue:
		mov		ax, bx
		mov		cl, 19
		div		cl
		movzx	bp, al	; bp=row
		mov		dh, ah
		mul		cl
	
		; rows
		mov		si, di
		add		si, ax
column:
		lodsb
		cmp		al, dl
		je		short nextvalue
		loop	column
	
		; columns
		mov		si, di
		mov		al, dh
		add		si, ax
		mov		cl, 9
row:	
		cmp		[si], dl
		je		short nextvalue
		add		si, byte 19
		loop	row
	
		; boxes
		mov		al, dh
		mov		cl, 6
		div		cl
		mul		cl
		mov		dh, al
	
		mov		cl, 3
		mov		ax, bp
		div		cl
		mul		cl
	
		imul	si, ax, byte 19
		mov		al, dh
		add		si, ax
		add		si, di
boxrow:
		mov		dh, 6
boxcolumn:
		lodsb
		cmp		al, dl
		je		short nextvalue
		dec		dh
		jnz		short boxcolumn
		add		si, byte 19-6				;next row down
		loop 	boxrow


		xchg	[bx+di], dl
		call	recurse
		xchg	[bx+di], dl
nextvalue:
		inc		dx
		cmp		dl, '9'
		jle		short testvalue
		popa
		ret

section .bss
sudoku	resb 	171
