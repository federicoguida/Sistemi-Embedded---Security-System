.data
    .balign 4
    FRAMEBUFFER=0x3E8FA000
    LIMIT=0x3EBEA000

.text
.global _start

@ Copy a block of memory, which is an exact multiple of r7 words long
@ from the location pointed to by r7 to the location pointed to by r8. r9
@ points to the end of block to be copied.

_start:
    ldr r7, addr_FRAMEBUFFER
    add r7, r7, #0x10000  @ carico all'interno di r7 indirizzo FRAMEBUFFER + 65536 BYTES
    ldr r9, addr_LIMIT @ carico all'interno di r9 indirizzo Limite
    ldr r8, addr_FRAMEBUFFER @ carico all'interno di r8 indirizzo FRAMEBUFFER

_loop:
    ldmia r7!, {r0-r6} @ Carico 28 bytes
    stmia r8!, {r0-r6} @ Li memorizzo
    cmp r7, r9 @ Controllo se sono arrivato alla fine
    bls _loop @ Continuo a fare il loop se non ho finito
    bx lr

addr_FRAMEBUFFER: .word FRAMEBUFFER
addr_LIMIT: .word LIMIT
