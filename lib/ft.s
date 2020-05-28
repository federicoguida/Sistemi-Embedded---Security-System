.data
    .balign 4
    OU_LOW: .word 0x0
    OU_HIGH: .word 0x0
    SYSTIMER_CLO=0xFE003004
    SYSTIMER_CHI=0XFE003008

.text
.global _start

_start:
    ldr r0, addr_SYSTIMER_CLO
    ldrd r0, r1, [r0]
    ldr r2, addr_OU_LOW
    ldr r3, addr_OU_HIGH
    str r0, [r2]
    str r1, [r3]
    bx lr

addr_OU_LOW: .word OU_LOW
addr_OU_HIGH: .word OU_HIGH
addr_SYSTIMER_CLO: .word SYSTIMER_CLO
addr_SYSTIMER_CHI: .word SYSTIMER_CHI
