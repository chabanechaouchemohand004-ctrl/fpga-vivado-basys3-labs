---------------------------------------------------------------------------
-- Test_CPT.vhd (VERSION CORRIGEE)
-- TP1 - Cas 1 : Compteurs imbriques
--
-- ERREUR ORIGINALE :
--   signal Cpt : integer range 0 to 20000000;  -- range trop petit
--   Vivado detecte que Cpt ne peut jamais atteindre 70 000 000,
--   optimise (supprime) toute la logique dependante => dead logic.
--
-- CORRECTION :
--   Etendre le range a 70 000 000 pour que la comparaison soit possible.
--
-- FONCTIONNEMENT ATTENDU :
--   - Cpt s'incremente a chaque front montant de Clk (100 MHz).
--   - Quand Cpt atteint 70 000 000 (toutes les 0,7 s), start bascule
--     et Cpt2 s'incremente a son tour.
--   - Les 4 bits de poids fort de Cpt2 (bits 27-24) s'affichent sur
--     les LEDs (comptage binaire lent visible a l'oeil).
--   - Si Button_L est appuye, les 4 LEDs s'allument toutes.
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Test_CPT is
    Port (
        Clk      : in  STD_LOGIC;                      -- Horloge 100 MHz
        Reset    : in  STD_LOGIC;                      -- Reset asynchrone actif haut
        Button_L : in  STD_LOGIC;                      -- Bouton gauche
        LED      : out STD_LOGIC_VECTOR(3 downto 0)   -- 4 LEDs de droite
    );
end Test_CPT;

architecture Behavioral of Test_CPT is

    -- CORRECTION : range etendu a 70 000 000 (etait 20 000 000)
    signal Cpt   : integer range 0 to 70000000;
    signal Cpt2  : STD_LOGIC_VECTOR(27 downto 0);
    signal start : STD_LOGIC;

begin

    ---------------------------------------------------------------------------
    -- Process 1 : Gestion du compteur principal Cpt et du signal start
    -- start bascule toutes les 70 000 000 cycles (= 0,7 s a 100 MHz)
    ---------------------------------------------------------------------------
    process(Clk, Reset)
    begin
        if Reset = '1' then
            Cpt   <= 0;
            start <= '0';
        elsif rising_edge(Clk) then
            Cpt <= Cpt + 1;
            if Cpt = 70000000 then      -- condition atteignable grace a la correction
                start <= not start;     -- bascule du signal de cadence
                Cpt   <= 0;             -- remise a zero du compteur
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Process 2 : Gestion du compteur secondaire Cpt2
    -- Cpt2 s'incremente uniquement quand start = '1'
    -- (soit pendant la premiere moitie de chaque periode de 1,4 s)
    ---------------------------------------------------------------------------
    process(Clk, Reset)
    begin
        if Reset = '1' then
            Cpt2 <= (others => '0');
        elsif rising_edge(Clk) then
            if start = '1' then
                Cpt2 <= Cpt2 + 1;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Sortie LEDs :
    --   - Bouton non appuye : affiche les 4 bits de poids fort de Cpt2
    --   - Bouton appuye     : toutes les LEDs s'allument ("1111")
    ---------------------------------------------------------------------------
    LED <= Cpt2(27 downto 24) when Button_L = '0'
           else "1111";

end Behavioral;
