.data
    .balign 4
    OP1_L: .word 0x0
    OP1_H: .word 0x0
    OP2: .word 0x0

.text
.global _start

_start:
    ldr r2, addr_OP1_L @ Mi inserisco il valore dell'indirizzo op1 lowerbit 32
    ldr r3, addr_OP1_H @ Mi inserisco il valore dell'indirizzo op1 upperbit 32
    ldr r2, [r2] @ Carico il valore
    ldr r3, [r3] @ Carico il valore
    ldr r4, addr_OP2 @ Carico indirizo op2
    ldr r4, [r4] @ Carico value di op2
    mov r0, #0 @ Utilizzata come Lower_value bit
    mov r1, #0 @ Utilizzata come Upper_value bit
    mov r5, #0 @ Utilizzata come index
    mov r6, #0 @ Utilizzata come temp
    mov r7, #0 @ Utilizzata come result
    mov r8, #1 @ Utilizzato come costante

_label: @ Ciclo principale
    cmp r3, #0 @ Analizzo se r3>0 oppure r3<=0
    bhi _case1 @ se è maggiore strettamente vado a case1
    ble _case2 @ se è minore o uguale vado a case2

_case1: @ Ciclo per il primo caso
    cmp r1, r3 @ Confronto il valore alto del Op2(es 1Milione) con upperbit di op1
    bhi _greater @ Se r1 > r3
    beq _same @ Se r1 = r3
    blo _minus @ Se r1 < r3

_case2: @ Ciclo per il secondo caso
    udiv r6, r2, r4 @ Memorizzo in una variable temp il risultato della divisione tra i lower32 e value
    add r0, r7, r6 @ Memorizzo all'interno del registro di ritorno il valore tra temp e result che mi tiene la somma dei valori
    bx lr @ termino il programma

_greater: @ Label che si occupa del caso maggiore
    sub r5, r5, #1 @ Index = Index - 1 Perchè ho sforato
    lsl r8, r8, r5 @ Calcoliamo 2^i
    umull r0, r1, r4, r8 @ Moltiplico Value * 2^i e memorizzo i valori
    subs r2, r2, r0 @ Effettuo la sottrazione con carry dei valori bassi
    sbc r3 , r3, r1 @ Effettuo la sottrazione con il riporto eventuale tra i valori alti
    add r7, r7, r8 @ Memorizzo all'interno di result il valore 2^i corrispondente
    mov r8, #1 @ Resettiamo parte del quoziente
    mov r5, #0 @ Resettiamo il numero di shift
    mov r0, #0 @ Resettiamo il registro basso di op2
    mov r1, #0 @ Resettiamo il registro alto di op2
    b _label @ ritorno a label

_minus: @ Label che si occupa del caso minore
    add r5, r5, #1 @ Devo incrementare il contatore per poi fare l'op di moltiplicazione
    lsl r8, r8, r5 @ Calcoliamo 2^i
    umull r0, r1, r4, r8 @ Faccio la moltiplicazione per aggiornarmi il valore di High_Value cosi da confrontarlo sopra
    mov r8, #1 @ Resettiamo parte del quoziente
    b _case1 @ Torno al case1 per confrontare il valore r1 aggiornato

_same: @ Label che si occupa del caso uguale
    cmp r0, r2 @ Confronto i valori piu bassi per evitare sottrazioni sbagliate
    bhi _op1 @ se r0 > r2 significa che il mio valore è piu grande del valore complessivo
    ble _op2 @ se r0 <=r2 posso fare la sottrazione

_op1: @ Label che si occupa del caso r0>r2
    sub r5, r5, #1 @ Index = Index - 1 Perchè ho sforato
    lsl r8, r8, r5 @ Calcoliamo 2^i
    umull r0, r1, r4, r8 @ Moltiplico Value * 2^i e memorizzo i valori
    subs r2, r2, r0 @ Effettuo la sottrazione con carry dei valori bassi
    sbc r3 , r3, r1 @ Effettuo la sottrazione con il riporto eventuale tra i valori alti
    add r7, r7, r8 @ Memorizzo all'interno di result il valore 2^i corrispondente
    mov r8, #1 @ Resettiamo parte del quoziente
    mov r5, #0 @ Resettiamo il numero di shift
    mov r0, #0 @ Resettiamo il registro basso di op2
    mov r1, #0 @ Resettiamo il registro alto di op2
    b _label @ Torno a label per confrontare il nuovo valore di R3

_op2: @ Label che si occupa del caso r0<=r2
    lsl r8, r8, r5 @ Calcoliamo 2^i
    subs r2, r2, r0 @ Effettuo la sottrazione con carry dei valori bassi
    sbc r3 , r3, r1 @ Effettuo la sottrazione con il riporto eventuale tra i valori alti
    add r7, r7, r8 @ Memorizzo all'interno di result il valore 2^i corrispondente
    mov r8, #1 @ Resettiamo parte del quoziente
    mov r5, #0 @ Resettiamo il numero di shift
    mov r0, #0 @ Resettiamo il registro basso di op2
    mov r1, #0 @ Resettiamo il registro alto di op2
    b _label @ Torno a label per confrontare il nuovo valore di R3

addr_OP1_L: .word OP1_L
addr_OP1_H: .word OP1_H
addr_OP2: .word OP2
