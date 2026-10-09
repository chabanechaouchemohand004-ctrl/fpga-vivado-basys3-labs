/****************************************************************************
 * main.c -- TP3 : Pilotage des LED via l'IP custom my_led
 *
 * Principe : lecture des 4 interrupteurs via GPIO, puis ecriture dans les
 * registres de l'IP my_led pour allumer les LED par groupes de 4.
 *
 * Mapping :
 *   SW0 -> slv_reg0 bit 0 -> LED 3:0
 *   SW1 -> slv_reg0 bit 1 -> LED 7:4
 *   SW2 -> slv_reg1 bit 0 -> LED 11:8
 *   SW3 -> slv_reg1 bit 1 -> LED 15:12
 ****************************************************************************/

#include "xparameters.h"    /* Adresses de base des peripheriques */
#include "xgpio.h"          /* Driver du GPIO (interrupteurs) */
#include "xil_io.h"         /* Fonctions d'E/S bas niveau */
#include "my_led.h"         /* Driver de l'IP custom my_led */

/* Adresse de base de l'IP my_led */
#define MY_LED_BASE  XPAR_MY_LED_0_S00_AXI_BASEADDR

/* ID du GPIO pour les interrupteurs */
#define SW_DEVICE_ID XPAR_GPIO_0_DEVICE_ID

int main(void)
{
    XGpio sw_gpio;          /* Instance du GPIO */
    u32 sw_value;           /* Valeur lue des interrupteurs */
    u32 reg0_value;         /* Valeur pour slv_reg0 */
    u32 reg1_value;         /* Valeur pour slv_reg1 */

    /* Initialisation du GPIO */
    XGpio_Initialize(&sw_gpio, SW_DEVICE_ID);

    /* Configuration en entree (masque 0xF = 4 bits en entree) */
    XGpio_SetDataDirection(&sw_gpio, 1, 0xF);

    /* Boucle principale : scrutation permanente */
    while (1)
    {
        /* Lecture des 4 interrupteurs */
        sw_value = XGpio_DiscreteRead(&sw_gpio, 1);

        /* Bits 0-1 de sw -> slv_reg0 (LED 3:0 et LED 7:4) */
        reg0_value = sw_value & 0x3;

        /* Bits 2-3 de sw, decales en positions 0-1 -> slv_reg1 (LED 11:8 et LED 15:12) */
        reg1_value = (sw_value >> 2) & 0x3;

        /* Ecriture dans les registres de l'IP */
        MY_LED_mWriteReg(MY_LED_BASE, MY_LED_S00_AXI_SLV_REG0_OFFSET, reg0_value);
        MY_LED_mWriteReg(MY_LED_BASE, MY_LED_S00_AXI_SLV_REG1_OFFSET, reg1_value);
    }

    return 0;
}
