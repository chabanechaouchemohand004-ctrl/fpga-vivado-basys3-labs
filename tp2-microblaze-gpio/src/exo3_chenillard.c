/* =============================================================
 * TP2 - Exercice 3 : Chenillard a vitesse variable
 * =============================================================
 * Une seule LED allumee a la fois, se deplacant de droite a gauche.
 * La vitesse de defilement depend de la valeur des 4 interrupteurs.
 *
 * Ref. cours C02_SOPC : utilisation du driver GPIO
 * ============================================================= */

#include "xgpio.h"
#include "xparameters.h"

/* Delai logiciel parametrable */
void delay(int n)
{
    volatile int i;
    for (i = 0; i < n; i++);
}

int main()
{
    XGpio led_sw;
    int sw_state;
    int led_pattern;
    int speed;

    /* Initialisation */
    XGpio_Initialize(&led_sw, XPAR_LED_SWITCH_DEVICE_ID);
    XGpio_SetDataDirection(&led_sw, 1, 0xF);   /* Interrupteurs en entree */
    XGpio_SetDataDirection(&led_sw, 2, 0x0);   /* LEDs en sortie */

    /* Initialisation du motif : LED0 allumee */
    led_pattern = 0x0001;

    while (1)
    {
        /* Lecture de la vitesse depuis les interrupteurs (0 a 15) */
        sw_state = XGpio_DiscreteRead(&led_sw, 1) & 0xF;

        /* Calcul du delai : plus de switches = plus rapide */
        if (sw_state == 0)
            speed = 3000000;        /* Tres lent si aucun switch */
        else
            speed = 3000000 / (sw_state + 1);

        /* Affichage du motif sur les LEDs */
        XGpio_DiscreteWrite(&led_sw, 2, led_pattern);

        /* Decalage du motif vers la gauche */
        led_pattern = led_pattern << 1;

        /* Retour a LED0 quand on depasse LED15 */
        if (led_pattern > 0x8000)
        {
            led_pattern = 0x0001;
        }

        /* Delai parametre par les interrupteurs */
        delay(speed);
    }

    return 0;
}
