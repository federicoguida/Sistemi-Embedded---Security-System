VARIABLE SECURITY_COUNTER
VARIABLE SECURITY_TEMP
100 CONSTANT USER_MAX

CREATE USERS USER_MAX 1 - CELLS ALLOT
CREATE PASSWORD USER_MAX 1 - CELLS ALLOT

: ARRAY_INIT ( addr -- )
    0 SECURITY_COUNTER !
    SECURITY_TEMP !
    BEGIN 0 SECURITY_TEMP @ SECURITY_COUNTER @ CELLS + !
    SECURITY_COUNTER INCREMENT_RETURN USER_MAX 1 - = UNTIL ;

: USER_CODE ( val1 val2 val3 -- usercode )
    SWAP 10 * OR SWAP 100 * OR ;

: PASSWORD_CODE ( val1 val2 val3 val4 val5 val6 -- passcode )
    SWAP 10 * OR SWAP 100 * OR SWAP 1000 * OR SWAP 10000 * OR SWAP 100000 * OR ;

: USERCODE_CONTROL ( val1 val2 val3 -- usercode flag )
    3 SECURITY_COUNTER !
    BEGIN ATOI DUP A < >R -ROT
    SECURITY_COUNTER DECREMENT SECURITY_COUNTER @ 0 = UNTIL
    USER_CODE
    R> R> R> AND AND >R DUP 0 > R> AND ;

: PASSCODE_CONTROL ( val1 val2 val3 val4 val5 val6 -- passcode flag )
    6 SECURITY_COUNTER !
    BEGIN ATOI DUP A < >R -6ROT
    SECURITY_COUNTER DECREMENT SECURITY_COUNTER @ 0 = UNTIL
    PASSWORD_CODE
    R> R> R> R> R> R> AND AND AND AND AND ;

: INLIST ( code -- flag )
    0 SECURITY_COUNTER !
    BEGIN USERS SECURITY_COUNTER @ CELLS + @ SECURITY_COUNTER INCREMENT
    SWAP DUP ROT = IF DROP SECURITY_COUNTER @ 1 - SECURITY_TEMP ! RETURN_TRUE ELSE
    SECURITY_COUNTER @ USER_MAX 1 - = IF DROP RETURN_FALSE ELSE 0
    THEN THEN  1 = UNTIL ;

: USER_REGISTER ( code -- flag )
    0 SECURITY_COUNTER !
    BEGIN USERS SECURITY_COUNTER @ CELLS + @ SECURITY_COUNTER INCREMENT
    0 = IF USERS SECURITY_COUNTER @ 1 - CELLS + ! SECURITY_COUNTER @ 1 - SECURITY_TEMP !
    RETURN_TRUE ELSE
    SECURITY_COUNTER @ USER_MAX 1 - = IF DROP RETURN_FALSE ELSE 0
    THEN THEN 1 = UNTIL ;

: PASSWORD_REGISTER ( passcode -- )
    PASSWORD SECURITY_TEMP @ CELLS + ! ;

: PASSWORD_CONTROL ( passcode -- flag )
    PASSWORD SECURITY_TEMP @ CELLS + @ = ;

: USER_DELETE ( value -- )
    DUP USERS SECURITY_TEMP @ CELLS + !
    PASSWORD SECURITY_TEMP @ CELLS + ! ;

: CREDENTIAL_CHECK ( -- user_code password_code flag )
    3 0 READ_VALUES
    DISPLAY_R2 S" PASS: " SEND_STRING
    6 1 READ_VALUES
    PASSCODE_CONTROL
    >R >R
    USERCODE_CONTROL
    R> SWAP R> AND
    CLEAR_DISPLAY ;

: SEND_LOG ( flag -- ) \ modificato
    >R USERS SECURITY_TEMP @ CELLS + @ DATETIME
    -ROT 2DUP RSP@ @ REGISTER_LOG SWAP R>
    CREATE_STRING PRINT_HDMI SWAP PRINT_HDMI HDMI_RETURN ;

\**********FUNZIONALITA' PRINCIPALI**********

: SYSTEMSECURITY_INIT ( -- )
    USERS ARRAY_INIT
    PASSWORD ARRAY_INIT
    KEYPAD_INIT
    BSC1_ENABLE
    INIT_LCD
    HDMI_INIT
    USERLOG_INIT ;

: CONFIGURATION ( -- )
    SYSTEMSECURITY_INIT
    999 USERS !
    BEGIN
    1 SEC_TIMES
    S" ADMIN CONFIG" SEND_STRING DISPLAY_R2
    S" ROOT PASS:" SEND_STRING
    6 1 READ_VALUES
    PASSCODE_CONTROL CLEAR_DISPLAY
    IF PASSWORD !
    S" CONFIGURATION" SEND_STRING DISPLAY_R2 S" COMPLETED" SEND_STRING
    1 ELSE S" PASSWORD" SEND_STRING DISPLAY_R2 S" NOT VALID!" SEND_STRING
    1 SEC_TIMES CLEAR_DISPLAY
    DROP 0 THEN 1 = UNTIL LED_RGB ;

: LOGIN ( -- ) \modificato
    1 SEC_TIMES
    CLEAR_DISPLAY S" USER: " SEND_STRING
    CREDENTIAL_CHECK IF
    SWAP INLIST
    1 = IF PASSWORD_CONTROL
    IF 0 SEND_LOG
    S" WELCOME!" SEND_STRING
    LED_RED GPOFF 2 SEC_TIMES LED_RED GPON
    ELSE 1 SEND_LOG
    S" PASSWORD WRONG!" SEND_STRING
    LED_GREEN GPOFF 2 SEC_TIMES LED_GREEN GPON THEN
    ELSE S" USER NOT" SEND_STRING DISPLAY_R2
    S" REGISTER!" SEND_STRING DROP THEN
    ELSE S" USER OR PASSWORD" SEND_STRING DISPLAY_R2
    S" NOT VALID!" SEND_STRING 2DROP THEN ;

: REGISTRATION ( -- )
    1 SEC_TIMES
    CLEAR_DISPLAY S" ADMIN USER: " SEND_STRING
    CREDENTIAL_CHECK IF
    SWAP USERS @ = SWAP PASSWORD @ = AND IF
    S" USER: " SEND_STRING
    CREDENTIAL_CHECK IF
    SWAP DUP INLIST 0 = IF USER_REGISTER
    1 = IF S" REGISTRATION" SEND_STRING DISPLAY_R2
    S" COMPLETED" SEND_STRING PASSWORD_REGISTER
    ELSE S" OUTSIZE!" SEND_STRING 2DROP THEN
    ELSE S" EXISTING USER!" SEND_STRING 2DROP THEN
    ELSE S" USER OR PASSWORD" SEND_STRING DISPLAY_R2
    S" NOT VALID!" SEND_STRING 2DROP THEN
    ELSE S" ACCESS DENIED" SEND_STRING THEN
    ELSE S" USER OR PASSWORD" SEND_STRING DISPLAY_R2
    S" NOT VALID!" SEND_STRING 2DROP THEN ;

: DELETE ( -- )
    1 SEC_TIMES
    CLEAR_DISPLAY S" ADMIN USER: " SEND_STRING
    CREDENTIAL_CHECK IF
    SWAP USERS @ = SWAP PASSWORD @ = AND IF
    S" USER: " SEND_STRING
    3 0 READ_VALUES
    USERCODE_CONTROL CLEAR_DISPLAY IF
    INLIST 1 = IF 0 USER_DELETE
    S" USER DELETED!" SEND_STRING
    ELSE S" USER DOES" SEND_STRING DISPLAY_R2
    S" NOT EXIST" SEND_STRING THEN
    ELSE S" USER NOT VALID!" SEND_STRING 2DROP THEN
    ELSE S" ACCESS DENIED" SEND_STRING THEN
    ELSE S" USER OR PASSWORD" SEND_STRING DISPLAY_R2
    S" NOT VALID!" SEND_STRING 2DROP THEN ;

: LOG ( -- )
    1 SEC_TIMES
    CLEAR_DISPLAY S" ADMIN USER: " SEND_STRING
    CREDENTIAL_CHECK IF
    SWAP USERS @ = SWAP PASSWORD @ = AND IF
    S" USER: " SEND_STRING
    3 0 READ_VALUES
    USERCODE_CONTROL CLEAR_DISPLAY IF
    HDMI_RETURN S" --------------USER LOG HISTORY--------------" PRINT_HDMI HDMI_RETURN
    PRINT_LOG S" --------------------END---------------------" PRINT_HDMI HDMI_RETURN
    ELSE S" USER NOT VALID!" SEND_STRING 2DROP THEN
    ELSE S" ACCESS DENIED" SEND_STRING THEN
    ELSE S" USER OR PASSWORD" SEND_STRING DISPLAY_R2
    S" NOT VALID!" SEND_STRING 2DROP THEN ;

: MAIN ( -- )
    2 SEC_TIMES
    CLEAR_DISPLAY
    S" WELCOME TO THE" SEND_STRING DISPLAY_R2
    S" SECURITY SYSTEM" SEND_STRING
    LED_RED GPON
    BEGIN
    2 SEC_TIMES
    CLEAR_DISPLAY
\*******************************************************/
    CR CR ." DEBUG INFORMATION"
    CR ." USERS: " USERS 1 CELLS + ? USERS 2 CELLS + ?
    CR ." PASSWORD: " PASSWORD 1 CELLS + ? PASSWORD 2 CELLS + ?
    CR ." STACK: " .S CR
\*******************************************************/
    S" A.LOGIN C.DELETE" SEND_STRING DISPLAY_R2
    S" B.ENTRY D.LOG  " SEND_STRING
    1 0 READ_VALUES
    DUP 41 = IF LOGIN 0 SWAP ELSE
    DUP 42 = IF REGISTRATION 0 SWAP ELSE
    DUP 43 = IF DELETE 0 SWAP ELSE
    DUP 44 = IF LOG 0 SWAP ELSE
    DUP 23 = IF 1 SWAP CR ELSE
    CLEAR_DISPLAY S" ERROR!" SEND_STRING
    THEN THEN THEN THEN THEN DROP
    1 = UNTIL ;

: BOOT ( -- ) CONFIGURATION SCROLLING SCROLLING PRESENTATION MAIN ;
