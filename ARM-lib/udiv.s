.data
    .balign 4
    DIV1_LOW: .word 0x0
    DIV1_HIGH: .word 0x0
    DIV2: .word 0x0

.text
.global _start

_start:
    ldr r2, addr_DIV1_LOW
    ldr r3, addr_DIV1_HIGH
    ldr r2, [r2]
    ldr r3, [r3]
    ldr r4, addr_DIV2
    ldr r4, [r4]
    mov r5, #0
    mov r0, #0
_loop:
    cmp r3, #0
    bhi _sub_64
    cmp r2, r4
    bhs _sub
_sub:
    subs r2, r2, r4
    add r0, r0, #1
    bhs _sub
    b end_loop
_sub_64:
    subs r2, r2, r4
    sbc r3, r3, r5
    add r0, r0, #1
    b _loop
end_loop:
    sub r0, r0, #1
    bx lr

addr_DIV1_LOW: .word DIV1_LOW
addr_DIV1_HIGH: .word DIV1_HIGH
addr_DIV2: .word DIV2
