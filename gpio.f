\*********GPIO*********
: GPIO{ ( addr -- ) PERIBASE 200034 + ;
: }GPIO ( addr -- ) DROP ;
GPIO{
PIN GPLEV0 PIN GPLEV1 SKIP
PIN GPEDS0 PIN GPEDS1 SKIP
PIN GPREN0 PIN GPREN1 SKIP
PIN GPFEN0 PIN GPFEN1 SKIP
PIN GPHEN0 PIN GPHEN1 SKIP
PIN GPLEN0 PIN GPLEN1
}GPIO

: GPON ( pin -- ) 20 /MOD 4 * PERIBASE 20001C + + SWAP MASK SWAP ! ;
: GPOFF ( pin -- ) 20 /MOD 4 * PERIBASE 200028 + + SWAP MASK SWAP ! ;
: GPFSEL ( gpioPinNumber -- addr_gpfsel clr_value_gpfsel offset_base )
    A /MOD 4 * PERIBASE 200000 + + SWAP 3 * DUP 7 SWAP LSHIFT ROT DUP @ ROT INVERT AND ROT ;
: GPIO_INPUT ( addr_gpfsel clr_value_gpfsel offset_base -- )
    1 SWAP LSHIFT INVERT AND SWAP ! ;
: GPIO_OUTPUT ( addr_gpfsel clr_value_gpfsel offset_base -- )
    1 SWAP LSHIFT OR SWAP ! ;
: GPIO_AF0 ( addr_gpfsel clr_value_gpfsel offset_base -- )
    1 SWAP 2 + LSHIFT OR SWAP ! ;
: EVENT_DETECT ( pin -- event )
    MASK GPEDS0 @ AND 0 <> -1 = ;
: PIN_LEVEL ( pin -- level )
    MASK GPLEV0 @ AND 0 = IF 0 ELSE 1 THEN ;
: CLEAR_EVENT ( pin -- )
    MASK GPEDS0 @ OR GPEDS0 ! ;
: FALLING_EDGE_DETECT_ENABLE ( pin -- )
    MASK GPFEN0 @ OR GPFEN0 ! ;
\*************************
