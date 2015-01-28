;;;
;; Generate and Test version of the "Roman<->Decimal Converter"
;;
;;
;; 2002-06-10
;;  version 0.1  not working, not optimised (127b)
;;  version 1.0  working, not optimised (190b)
;; 2002-06-11
;;  version 1.1 , minor register allocations (165b)
;; 2002-06-12
;;  version 1.2 , introducing xlat (1b) for lookups (159b)
;;  version 1.3 , rearranged in table (151b)
;;  version 1.4 , inlining code (144b)
;;
;; nasmw -fbin -o entry.com entry.asm

        org    100h

entry   mov    di, line
.wslop  mov    ah, 8
        int    21h
        cmp    al, ' '
        je     short .wslop
        cmp    al, 1ah
        je     short .exit
        stosb
        cmp    al, 0ah
        jne    short .wslop

        mov    ax, 3999
.loop   pusha

        mov    si, 9
        mov    bp, decimal+100
        mov    di, roman+100
        mov    bx, 0a0dh
        mov    [di], bx
        mov    [di+2], byte '$'
        mov    [bp], bx
        mov    [bp+2], byte '$'
        mov    bx, table


.generate
        cwd
        or     ax,ax
        je     short .test
        mov    cl, 10
        idiv   cx
        xchg   ax,dx

        add    al, '0'
        dec    bp
        mov    [bp], byte al
        sub    al, '0'

        xlatb
.lop    push   ax
        and    al, 3
        jz     short .skip
        add    ax, si
        xlatb
        dec    di
        mov    [di],al
.skip   pop    ax
        shr    al,2
        jnz    short .lop

        xchg   ax, dx
        inc    si
        inc    si
        jmp    short .generate


.test
        mov    cl,2
.next   xchg   bp, di
        pusha
        mov    si, line
        mov    cl, 0ffh
        repe   cmpsb
        cmp    [di-1], byte '$'
        jne    short .nomat
        mov    dx, bp
        mov    ah, 9h
        int    21h
.nomat  popa
        loop    .next

.cont   popa
        dec    ax
        jnz    short .loop
        jmp    entry
.exit   ret


table   db 0x00, 0x40, 0x50, 0x54, 0x60, 0x80, 0x90, 0x94, 0x95, 0x70
        db 'IVXLCDM'

SECTION .bss
line:       resb 103
roman:      resb 103
decimal:    resb 103
