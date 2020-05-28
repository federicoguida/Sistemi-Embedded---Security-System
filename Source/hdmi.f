3E8FA000 CONSTANT FRAMEBUFFER_HDMI
FRAMEBUFFER_HDMI 2FFFFFF + CONSTANT FRAMEBUFFER_HDMIMAX
3EBDA000 CONSTANT MAXROW
3EBEA000 CONSTANT LIMIT 
1000 CONSTANT HEIGHT
4 CONSTANT WIDTH

VARIABLE ROW
VARIABLE COLOR
VARIABLE POINTER
VARIABLE HDMI_COUNTER
VARIABLE STR_LEN

\Word utilizzate per muoversi all'interno del framebuffer.
: NORTH ( color addr value --) >R BEGIN HEIGHT - 2DUP ! R> 1 - DUP >R 0 = UNTIL R> DROP ;
: SUD ( color addr value --) >R BEGIN HEIGHT + 2DUP ! R> 1 - DUP >R 0 = UNTIL R> DROP ; 
: EAST ( color addr value --) >R BEGIN WIDTH + 2DUP ! R> 1 - DUP >R 0 = UNTIL R> DROP ; 
: OVEST ( color addr value --) >R BEGIN WIDTH - 2DUP ! R> 1 - DUP >R 0 = UNTIL R> DROP ;
: NORTHEAST ( color addr value --) >R BEGIN HEIGHT - WIDTH + 2DUP ! R> 1 - DUP >R 0 = UNTIL R> DROP ;
: NORTHOVEST ( color addr value --) >R BEGIN  HEIGHT - WIDTH - 2DUP ! R> 1 - DUP >R 0 = UNTIL R> DROP ;
: SUDEAST ( color addr value --) >R BEGIN  HEIGHT + WIDTH + 2DUP ! R> 1 - DUP >R 0 = UNTIL R> DROP  ;
: SUDOVEST ( color addr value --) >R BEGIN  HEIGHT + WIDTH - 2DUP ! R> 1 - DUP >R 0 = UNTIL R> DROP ;
: UP ( addr value -- addr ) BEGIN SWAP HEIGHT - SWAP 1 - DUP 0 = UNTIL DROP ;
: DOWN ( addr value -- addr ) BEGIN SWAP HEIGHT + SWAP 1 - DUP 0 = UNTIL DROP ;
: LEFT ( addr value -- addr ) BEGIN SWAP WIDTH - SWAP 1 - DUP 0 = UNTIL DROP ;
: RIGHT ( addr value -- addr ) BEGIN SWAP WIDTH + SWAP 1 - DUP 0 = UNTIL DROP ;
: NEXT_CHAR ( addr -- addr )  6 UP 3 RIGHT ;
\*****************************

: !A ( color, addr -- color, addr )
    2DUP 3 DOWN 1 RIGHT 1 SUD 2 EAST 2DROP
    7 DOWN 6 NORTH 1 NORTHEAST 2 EAST 1 SUDEAST
    5 SUD NEXT_CHAR ;

: !B ( color, addr -- color, addr )
    2 DOWN 1 RIGHT 1 SUD 2 EAST 1 NORTHEAST 1 NORTH
    1 NORTHOVEST 3 OVEST 6 SUD 3 EAST 1 NORTHEAST 1 NORTH
    2 DOWN NEXT_CHAR ;

: !C ( color, addr -- color, addr )
    1 DOWN 3 RIGHT 1 EAST 1 NORTHOVEST 2 OVEST
    1 SUDOVEST 4 SUD 1 SUDEAST 2 EAST 1 NORTHEAST
    1 DOWN NEXT_CHAR ;
: SELECT_COLOR ( color -- ) COLOR ! ;
: WRITE_PREPARE ( -- color addr ) COLOR @ POINTER @ ;
: SELECT_POINT ( x y --  ) 400 * + 4 * FRAMEBUFFER_HDMI + POINTER ! ;
: POINT_INITIALIZZATION (  --  ) 0 0 SELECT_POINT POINTER @ ROW ! ;

CREATE SCROLL
\00008000 <_start>:
e59f701c ,	\ldr	r7, [pc, #28]	; 8024 <addr_FRAMEBUFFER>
e2877801 ,	\add	r7, r7, #65536	; 0x10000
e59f9018 ,	\ldr	r9, [pc, #24]	; 8028 <addr_LIMIT>
e59f8010 ,	\ldr	r8, [pc, #16]	; 8024 <addr_FRAMEBUFFER>
\00008010 <_loop>:
e8b7007f ,	\ldm	r7!, {r0, r1, r2, r3, r4, r5, r6}
e8a8007f ,	\stmia	r8!, {r0, r1, r2, r3, r4, r5, r6}
e1570009 ,	\cmp	r7, r9
9afffffb ,	\bls	8010 <_loop>
e12fff1e ,	\bx	lr
\DATA
FRAMEBUFFER_HDMI ,
LIMIT ,
DOES> JSR ;

: SCROLLING ( -- ) SCROLL DROP ;
: HDMI_INIT ( -- ) FFFFFF SELECT_COLOR POINT_INITIALIZZATION ;
