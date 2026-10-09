/* =============================================================
 * TP2 - Exercice 2 : Clignotement + Compteur + Boutons
 * =============================================================
 * LED15..LED8  : clignotent si SW0 est releve
 * LED7..LED4   : allumees par Left, eteintes par Right (si SW1)
 * LED3..LED0   : compteur mod 16, incremente par Center (si SW1)
 *
 * Ref. cours C02_SOPC, slides 58-59 : driver AXI-GPIO
 * ============================================================= */

#include "xgpio.h"
#include "xparameters.h"

/* Delai logiciel pour clignotement et anti-rebond */
void delay(int n)
{
    volatile int i;
    for (i = 0; i < n; i++);
}

int main()
{
    XGpio led_sw;   /* Peripherique led_switch (interrupteurs + LEDs) */
    XGpio bouton;   /* Peripherique boutons (Left, Center, Right) */

    int sw_state;
    int btn_state;
    int compteur = 0;
    int led_value = 0;
    int blink = 0;
    int mid_leds = 0;       /* Etat des LED 7-4 */
    int prev_center = 0;    /* Etat precedent du bouton Center */

    /* Initialisation des deux peripheriques */
    XGpio_Initialize(&led_sw, XPAR_LED_SWITCH_DEVICE_ID);
    XGpio_Initialize(&bouton, XPAR_BOUTONS_DEVICE_ID);

    /* Configuration des directions */
    XGpio_SetDataDirection(&led_sw, 1, 0xF);   /* Canal 1 : entrees (SW) */
    XGpio_SetDataDirection(&led_sw, 2, 0x0);   /* Canal 2 : sorties (LED) */
    XGpio_SetDataDirection(&bouton, 1, 0x7);   /* Canal 1 : entrees (BTN) */

    while (1)
    {
        /* Lecture des entrees */
        sw_state  = XGpio_DiscreteRead(&led_sw, 1);
        btn_state = XGpio_DiscreteRead(&bouton, 1);

        /* --- PARTIE 1 : Clignotement LED 15-8 (conditionne par SW0) --- */
        if (sw_state & 0x1)
        {
            blink = !blink;
        }
        else
        {
            blink = 0;
        }

        /* --- PARTIE 2 : Compteur et boutons (conditionne par SW1) --- */
        if (sw_state & 0x2)
        {
            /* Detection de front montant sur le bouton Center (bit 1) */
            int current_center = (btn_state >> 1) & 0x1;
            if (current_center == 1 && prev_center == 0)
            {
                compteur = (compteur + 1) % 16;
            }
            prev_center = current_center;

            /* Bouton Left (bit 2) : allumer LED 7-4 */
            if (btn_state & 0x4)
            {
                mid_leds = 0xF0;
            }

            /* Bouton Right (bit 0) : eteindre LED 7-4 */
            if (btn_state & 0x1)
            {
                mid_leds = 0x00;
            }
        }
        else
        {
            compteur = 0;
            mid_leds = 0;
        }

        /* --- Construction de la valeur 16 bits des LEDs --- */
        led_value = 0;
        if (blink)
            led_value |= 0xFF00;            /* LED 15-8 */
        led_value |= mid_leds;              /* LED 7-4 */
        led_value |= (compteur & 0xF);      /* LED 3-0 */

        XGpio_DiscreteWrite(&led_sw, 2, led_value);

        /* Delai pour clignotement visible et anti-rebond */
        delay(500000);
    }

    return 0;
}
