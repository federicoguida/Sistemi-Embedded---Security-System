\*********I2C INTERFACE*********
: I2C{ ( -- addr ) PERIBASE 804000 + ;
: }I2C ( addr -- ) DROP ;
I2C{
PIN BSC1C PIN BSC1S PIN BSC1DLEN
PIN BSC1A PIN BSC1FIFO PIN BSC1DIV
PIN BSC1DEL }I2C

\*- I2C operazioni -*
: I2C_ENABLE? ( -- ) F BSC1C GET_BIT . ;
: I2C_ON ( -- ) BSC1C @ 8000 INVERT AND 8000 OR BSC1C ! ;
: I2C_OFF ( -- ) BSC1C @ 8000 INVERT AND 0 OR BSC1C ! ;
: I2C_START ( -- ) BSC1C @ 80 OR BSC1C ! ;
: I2C_WRITE ( -- ) BSC1C @ 0 INVERT AND 0 OR BSC1C ! ;
: I2C_CLEAR ( -- ) BSC1C @ 20 OR BSC1C ! ;
: I2C_STATUS ( -- ) BSC1S @ U. ;
: I2C_DLEN ( n -- ) BSC1DLEN ! ;
: I2C_SETSLAVE ( addr -- ) BSC1A ! ;
: I2C_GETSLAVE ( -- ) BSC1A @ U. ;
: I2C_FIFO ( data -- ) BSC1FIFO ! ;
: I2C_DONE? ( -- bit ) 1 BSC1S GET_BIT ;
: I2C_TA? ( -- bit ) 0 BSC1S GET_BIT ;
: I2C_RESETDONE ( -- ) BSC1S @ 2 INVERT AND 2 OR BSC1S ! ;
\************************
: GPIO_I2C ( -- )
    2 GPFSEL GPIO_AF0
    3 GPFSEL GPIO_AF0 ;

\ aspetta fino all'effettivo invio del messaggio
: WAIT_DONE ( -- )
  BEGIN I2C_DONE? 1 = UNTIL ;
 \ aspetta fino al trasferimento attivo
: WAIT_TA ( -- )
  BEGIN I2C_TA? 0= UNTIL ;

: BSC1_ENABLE ( -- ) GPIO_I2C I2C_ON ;

: WRITE_I2C ( data slave len -- )
    I2C_CLEAR
    I2C_RESETDONE
    I2C_DLEN
    I2C_SETSLAVE
    I2C_FIFO
    I2C_WRITE
    I2C_START
    WAIT_DONE
    WAIT_TA ;
