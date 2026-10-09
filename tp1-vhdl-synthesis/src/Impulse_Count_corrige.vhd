---------------------------------------------------------------------------
-- Impulse_Count.vhd (VERSION CORRIGEE)
-- TP1 - Cas 2 : Compteur d'impulsions par boutons
-- Correction : architecture synchrone avec detection de front
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IMPULSE_COUNT is
    Port ( Clk      : in  STD_LOGIC;           -- Horloge systeme 100 MHz (ajoutee)
           Reset    : in  STD_LOGIC;            -- Reset asynchrone
           Button_L : in  STD_LOGIC;            -- Bouton Left : increment
           Button_C : in  STD_LOGIC;            -- Bouton Center : decrement
           Count    : out STD_LOGIC_VECTOR (3 downto 0);  -- Compteur 4 bits
           Sup      : out STD_LOGIC);           -- Flag : compteur > 9
end IMPULSE_COUNT;

architecture Behavioral of IMPULSE_COUNT is

    signal cpt : std_logic_vector(3 downto 0);   -- Compteur interne
    -- Registres de memorisation pour detection de front montant
    signal Button_L_prev, Button_C_prev : std_logic;

begin

    Count <= cpt;  -- Sortie = valeur courante du compteur

    ---------------------------------------------------------------------------
    -- Process synchrone principal
    -- Cadence par l'horloge systeme Clk (100 MHz)
    -- Detection de front montant : transition 0->1 sur le bouton
    ---------------------------------------------------------------------------
    process(Clk, Reset)
    begin
        if Reset = '1' then
            -- Reset asynchrone : remise a zero
            cpt <= "0000";
            Button_L_prev <= '0';
            Button_C_prev <= '0';

        elsif rising_edge(Clk) then
            -- Detection de front montant sur Button_L
            -- Condition : etat actuel = '1' ET etat precedent = '0'
            if Button_L = '1' and Button_L_prev = '0' then
                cpt <= cpt + 1;  -- Incrementation
            end if;

            -- Detection de front montant sur Button_C
            if Button_C = '1' and Button_C_prev = '0' then
                cpt <= cpt - 1;  -- Decrementation
            end if;

            -- Memorisation de l'etat actuel pour le prochain cycle
            Button_L_prev <= Button_L;
            Button_C_prev <= Button_C;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Process combinatoire : generation du flag Sup
    -- Sup = '1' si le compteur depasse 9 (utile pour le Selector)
    ---------------------------------------------------------------------------
    process(cpt)
    begin
        if cpt > 9 then
            Sup <= '1';
        else
            Sup <= '0';
        end if;
    end process;

end Behavioral;
