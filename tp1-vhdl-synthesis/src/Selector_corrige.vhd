---------------------------------------------------------------------------
-- Selector.vhd (VERSION CORRIGEE)
-- TP1 - Cas 3 : Decodeur de mode et seuil de vitesse
-- Corrections : ajout de when others et else final
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Selector is
    Port ( Count  : in  STD_LOGIC_VECTOR (3 downto 0);  -- Valeur du compteur
           Sup    : in  STD_LOGIC;                       -- Flag > 9
           Mode   : out STD_LOGIC_VECTOR (1 downto 0);  -- Mode de la FSM
           Limit  : out STD_LOGIC_VECTOR (31 downto 0)); -- Seuil de vitesse
end Selector;

architecture Behavioral of Selector is
    signal Decode : STD_LOGIC_VECTOR (1 downto 0);
begin

    ---------------------------------------------------------------------------
    -- Decodage du compteur en valeur Decode
    -- CORRECTION : ajout du else "00" final pour eviter l'inference de latch
    ---------------------------------------------------------------------------
    Decode <= "11" when Sup = '1'
         else "10" when Count > 5
         else "01" when Count > 2
         else "00";  -- CORRECTION : else final obligatoire

    ---------------------------------------------------------------------------
    -- Affectation du mode : directement egal a Decode
    ---------------------------------------------------------------------------
    Mode <= Decode;

    ---------------------------------------------------------------------------
    -- Decodage du seuil de vitesse selon Decode
    -- CORRECTION : ajout de when others pour eviter latch
    ---------------------------------------------------------------------------
    process(Decode)
    begin
        case (Decode) is
            when "00"   => Limit <= (others => '0');         -- Vitesse nulle
            when "01"   => Limit <= X"016E3600";             -- 24 000 000 cycles
            when "10"   => Limit <= X"007A1200";             -- 8 000 000 cycles
            when "11"   => Limit <= (others => '1');         -- Vitesse max
            when others => Limit <= (others => '0');         -- CORRECTION : clause others
        end case;
    end process;

end Behavioral;
