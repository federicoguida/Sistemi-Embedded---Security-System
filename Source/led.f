: LED_RED 13 ;
: LED_GREEN D ;
: LED_BLUE 1A ;
: LED_RGB
    LED_GREEN GPFSEL GPIO_OUTPUT
    LED_RED GPFSEL GPIO_OUTPUT
    LED_BLUE GPFSEL GPIO_OUTPUT
    LED_RED GPOFF
    LED_GREEN GPON
    LED_BLUE GPON ;

