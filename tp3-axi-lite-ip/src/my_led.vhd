---------------------------------------------------------------------------
-- my_led.vhd
-- TP3 : Fonctionnalite de l'IP controleur de LED
-- Chaque bit de sw_state allume un groupe de 4 LED (logique combinatoire)
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led is
    Port (
        sw_state : in  std_logic_vector(3 downto 0);   -- 4 bits depuis les registres AXI
        leds     : out std_logic_vector(15 downto 0)    -- 16 bits vers les LED physiques
    );
end led;

architecture Behavioral of led is
begin
    -- Groupe LED 0 : LED(3:0) controlees par sw_state(0)
    leds(3 downto 0)   <= "1111" when sw_state(0) = '1' else "0000";

    -- Groupe LED 1 : LED(7:4) controlees par sw_state(1)
    leds(7 downto 4)   <= "1111" when sw_state(1) = '1' else "0000";

    -- Groupe LED 2 : LED(11:8) controlees par sw_state(2)
    leds(11 downto 8)  <= "1111" when sw_state(2) = '1' else "0000";

    -- Groupe LED 3 : LED(15:12) controlees par sw_state(3)
    leds(15 downto 12) <= "1111" when sw_state(3) = '1' else "0000";
end Behavioral;
