---------------------------------------------------------------------------
-- FSM.vhd (VERSION CORRIGEE)
-- TP1 - Cas 3 : Machine a etats pour le pilotage des LEDs
-- Corrections : ajout when others, affectation par defaut EF <= EP
---------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FSM is
    Port ( Clk    : in  STD_LOGIC;
           Reset  : in  STD_LOGIC;
           Mode   : in  STD_LOGIC_VECTOR (1 downto 0);
           Seuil  : in  STD_LOGIC_VECTOR (31 downto 0);
           LED    : out STD_LOGIC_VECTOR (15 downto 0));
end FSM;

architecture Behavioral of FSM is

    -- Definition des etats de la machine
    type state_type is (LED_OFF, CLIGN_OFF, LED_ON, CLIGN_ON);
    signal EP, EF : state_type;        -- Etat present, etat futur
    signal Cpt    : STD_LOGIC_VECTOR(31 downto 0);  -- Compteur pour le timing

begin

    ---------------------------------------------------------------------------
    -- Process 1 : Registre d'etat (synchrone)
    -- Met a jour l'etat present sur chaque front montant
    ---------------------------------------------------------------------------
    process(Clk, Reset)
    begin
        if Reset = '1' then
            EP <= LED_OFF;
        elsif rising_edge(Clk) then
            EP <= EF;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Process 2 : Logique de transition (combinatoire)
    -- CORRECTION : affectation par defaut EF <= EP en debut de process
    -- pour eviter les latches sur EF
    ---------------------------------------------------------------------------
    process(EP, Mode, Cpt, Seuil)
    begin
        EF <= EP;  -- CORRECTION : par defaut, rester dans l'etat courant

        case (EP) is
            when LED_OFF =>
                -- LEDs eteintes : passage a clignotement si mode != "00"
                if Mode = "01" or Mode = "10" then
                    EF <= CLIGN_OFF;
                elsif Mode = "11" then
                    EF <= LED_ON;
                end if;

            when CLIGN_OFF =>
                -- Phase OFF du clignotement
                if Cpt = Seuil then
                    EF <= CLIGN_ON;       -- Transition apres delai
                elsif Mode = "00" then
                    EF <= LED_OFF;        -- Retour si mode eteint
                elsif Mode = "11" then
                    EF <= LED_ON;         -- Allumage permanent
                end if;

            when LED_ON =>
                -- LEDs allumees en continu
                if Mode = "00" then
                    EF <= LED_OFF;
                elsif Mode = "01" or Mode = "10" then
                    EF <= CLIGN_ON;
                end if;

            when CLIGN_ON =>
                -- Phase ON du clignotement
                if Cpt = Seuil then
                    EF <= CLIGN_OFF;      -- Transition apres delai
                elsif Mode = "00" then
                    EF <= LED_OFF;
                elsif Mode = "11" then
                    EF <= LED_ON;
                end if;

            when others =>
                EF <= LED_OFF;            -- CORRECTION : clause others
        end case;
    end process;

    ---------------------------------------------------------------------------
    -- Process 3 : Compteur de timing (synchrone)
    ---------------------------------------------------------------------------
    process(Clk, Reset)
    begin
        if Reset = '1' then
            Cpt <= (others => '0');
        elsif rising_edge(Clk) then
            if Cpt = Seuil then
                Cpt <= (others => '0');
            else
                Cpt <= Cpt + 1;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- Sortie : LEDs allumees dans les etats CLIGN_ON et LED_ON
    ---------------------------------------------------------------------------
    LED <= X"FFFF" when (EP = CLIGN_ON or EP = LED_ON) else X"0000";

end Behavioral;
