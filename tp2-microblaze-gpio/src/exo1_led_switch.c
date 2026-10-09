/* =============================================================
 * TP2 - Exercice 1 : LED suit l'etat de l'interrupteur
 * =============================================================
 * Principe : On lit en boucle l'etat des 4 interrupteurs (port 1
 * de led_switch) et on recopie cette valeur sur les 4 premieres
 * LEDs (port 2 de led_switch).
 *
 * Ref. cours C02_SOPC, slide 59 : fonctions du driver AXI-GPIO
 * ============================================================= */

#include "xgpio.h"
#include "xparameters.h"

int main()
{
    XGpio led_sw;
    int sw_state;

    /* Initialisation : associe led_sw au peripherique LED_SWITCH (ID=1) */
    XGpio_Initialize(&led_sw, XPAR_LED_SWITCH_DEVICE_ID);

    /* Direction : canal 1 = entrees (0xF), canal 2 = sorties (0x0) */
    XGpio_SetDataDirection(&led_sw, 1, 0xF);
    XGpio_SetDataDirection(&led_sw, 2, 0x0);

    while (1)
    {
        sw_state = XGpio_DiscreteRead(&led_sw, 1);
        XGpio_DiscreteWrite(&led_sw, 2, sw_state);
    }

    return 0;
}
