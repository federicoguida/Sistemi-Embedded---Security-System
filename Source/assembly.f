VARIABLE OP1_L
VARIABLE OP1_H
VARIABLE OP2
VARIABLE OU_LOW
VARIABLE OU_HIGH

CREATE UDIV
\00008000 <_start>:
e59f20ec ,	\ldr	r2, [pc, #236]	; 80f4 <addr_OP1_L>
e59f30ec ,	\ldr	r3, [pc, #236]	; 80f8 <addr_OP1_H>
e5922000 ,	\ldr	r2, [r2]
e5933000 ,	\ldr	r3, [r3]
e59f40e4 ,	\ldr	r4, [pc, #228]	; 80fc <addr_OP2>
e5944000 ,	\ldr	r4, [r4]
e3a00000 ,	\mov	r0, #0
e3a01000 ,	\mov	r1, #0
e3a05000 ,	\mov	r5, #0
e3a06000 ,	\mov	r6, #0
e3a07000 ,	\mov	r7, #0
e3a08001 ,	\mov	r8, #1
\00008030 <_label>:
e3530000 ,	\cmp	r3, #0
8a000000 ,	\bhi	803c <_case1>
da000003 ,	\ble	804c <_case2>
\0000803c <_case1>:
e1510003 ,	\cmp	r1, r3
8a000004 ,	\bhi	8058 <_greater>
0a000013 ,	\beq	8098 <_same>
3a00000d ,	\bcc	8084 <_minus>
\0000804c <_case2>:
e736f412 ,	\udiv	r6, r2, r4
e0870006 ,	\add	r0, r7, r6
e12fff1e ,	\bx	lr
\00008058 <_greater>:
e2455001 ,	\sub	r5, r5, #1
e1a08518 ,	\lsl	r8, r8, r5
e0810894 ,	\umull	r0, r1, r4, r8
e0522000 ,	\subs	r2, r2, r0
e0c33001 ,	\sbc	r3, r3, r1
e0877008 ,	\add	r7, r7, r8
e3a08001 ,	\mov	r8, #1
e3a05000 ,	\mov	r5, #0
e3a00000 ,	\mov	r0, #0
e3a01000 ,	\mov	r1, #0
eaffffea ,	\b	8030 <_label>
\00008084 <_minus>:
e2855001 ,	\add	r5, r5, #1
e1a08518 ,	\lsl	r8, r8, r5
e0810894 ,	\umull	r0, r1, r4, r8
e3a08001 ,	\mov	r8, #1
eaffffe8 ,	\b	803c <_case1>
\00008098 <_same>:
e1500002 ,	\cmp	r0, r2
8a000000 ,	\bhi	80a4 <_op1>
da00000a ,	\ble	80d0 <_op2>
\000080a4 <_op1>:
e2455001 ,	\sub	r5, r5, #1
e1a08518 ,	\lsl	r8, r8, r5
e0810894 ,	\umull	r0, r1, r4, r8
e0522000 ,	\subs	r2, r2, r0
e0c33001 ,	\sbc	r3, r3, r1
e0877008 ,	\add	r7, r7, r8
e3a08001 ,	\mov	r8, #1
e3a05000 ,	\mov	r5, #0
e3a00000 ,	\mov	r0, #0
e3a01000 ,	\mov	r1, #0
eaffffd7 ,	\b	8030 <_label>
\000080d0 <_op2>:
e1a08518 ,	\lsl	r8, r8, r5
e0522000 ,	\subs	r2, r2, r0
e0c33001 ,	\sbc	r3, r3, r1
e0877008 ,	\add	r7, r7, r8
e3a08001 ,	\mov	r8, #1
e3a05000 ,	\mov	r5, #0
e3a00000 ,	\mov	r0, #0
e3a01000 ,	\mov	r1, #0
eaffffce ,	\b	8030 <_label>
\DATA
OP1_L ,
OP1_H ,
OP2 ,
DOES> JSR ;

: UM/ ( div1_lo div1_hi div2 -- quotient )
    OP2 ! OP1_H ! OP1_L ! UDIV ;

CREATE TIME
\00008000 <_start>:
e59f001c ,	\ldr	r0, [pc, #28]	; 8024 <addr_SYSTIMER_CLO>
e1c000d0 ,	\ldrd	r0, [r0]
e59f200c ,	\ldr	r2, [pc, #12]	; 801c <addr_OU_LOW>
e59f300c ,	\ldr	r3, [pc, #12]	; 8020 <addr_OU_HIGH>
e5820000 ,	\str	r0, [r2]
e5831000 ,	\str	r1, [r3]
e12fff1e ,	\bx	lr
\DATA
OU_LOW ,
OU_HIGH ,
fe003004 ,
fe003008 ,
DOES> JSR ;

: TIME@ ( -- val_lo val_hi )
    TIME DROP OU_LOW @ OU_HIGH @ ;
