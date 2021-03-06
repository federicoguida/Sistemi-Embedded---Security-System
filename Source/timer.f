\*********TIMER*********
: TIMER{ ( addr -- ) PERIBASE 3000 + ;
: }TIMER ( addr -- ) DROP ;
TIMER{
PIN SYSTEMTIMER_CS
    PIN SYSTEMTIMER_CLO PIN SYSTEMTIMER_CHI
}TIMER

VARIABLE INITIAL_TIME
VARIABLE TIME_TEMP

: MSEC ( u_sec -- m_sec ) 3E8 * ;
: SEC ( u_sec -- sec ) F4240 * ;
: USEC_TIMES ( u_sec -- )
    SYSTEMTIMER_CLO @ INITIAL_TIME !
    BEGIN SYSTEMTIMER_CLO @ INITIAL_TIME @ - OVER SWAP - 0 <
    UNTIL DROP ;
: MSEC_TIMES ( m_sec -- ) MSEC USEC_TIMES ;
: SEC_TIMES ( sec -- ) SEC USEC_TIMES ;

: 2NUMBER_STORE ( value pos1 pos2 -- )
    >R >R A /MOD SWAP
    30 + TIME_TEMP @ R> + C! 30 + TIME_TEMP @ R> + C! ;

: 3NUMBER_STORE ( value pos1 pos2 pos3 -- )
    >R >R >R 64 /MOD SWAP A /MOD SWAP
    30 + TIME_TEMP @ R> + C! 30 + TIME_TEMP @ R> + C! 30 + TIME_TEMP @ R> + C! ;

: DATETIME ( -- addr len)
    HERE 10 ALLOT TIME_TEMP !
    TIME@ F4240 UM/
    3C /MOD SWAP F E 2NUMBER_STORE
    3A D TIME_TEMP @ + C!
    3C /MOD SWAP C B 2NUMBER_STORE
    3A A TIME_TEMP @ + C!
    18 /MOD SWAP 9 8 2NUMBER_STORE
    2F 7 TIME_TEMP @ + C!
    16D /MOD SWAP 6 5 4 3NUMBER_STORE
    2F 3 TIME_TEMP @ + C!
    2 1 0 3NUMBER_STORE
    TIME_TEMP @ 10 ;
