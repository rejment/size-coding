;;;
;; Recursive backtracking knights tour
;;
;   aug 28 - 93 first attempt
;   aug 28 - 79 still just goofing
;   aug 28 - 77 oh how I suck at asm IO
;   aug 28 - 72 carry for backtrack-flag
;   aug 28 - 70 cx for depth counter
;   aug 28 - 69 redundant ret removed
;   aug 28 - 68 updated movetable for smaller 0check
;   aug 30 - 65 pusha/popa, cant believe i missed that
;   aug 30 - 64 many changes, just one byte
;
;; build with
;; nasmw -fbin -o entry.com entry.asm

        bits	16
        org     100h

        mov		di, bp				; 2
        push	di					; 1
        rep stosb					; 2
        pop		di					; 1
        mov		cl, 64				; 2

seek	jcxz	done				; 2

        inc		ax					; 1
        xchg	byte [di+bx], al	; 2
        mov		ah, bl				; 2
        and		ax, 0x88ff			; 3
        jnz		fail				; 2
        mov		si, move			; 3

next	lodsb						; 1
        dec		ax					; 1
        jz		fail				; 2

        pusha						; 1

        add		bl, al				; 2
        dec		cx					; 1
        call	seek				; 3

        popa						; 1
        jnc		next				; 2

        mov		al, bl				; 2
        aam		16					; 2
        mov		dx, ax				; 2
        mov		ah, 2				; 2
        int		21h					; 2
        mov		dl, dh				; 2
        int		21h					; 2

done	stc							; 1
fail	xchg	byte [di+bx], al	; 2
        ret							; 1

move	db		0xe0, 0xe2, 0xef, 0xf3, 0x0f, 0x13, 0x20, 0x22, 0x01		; 9
