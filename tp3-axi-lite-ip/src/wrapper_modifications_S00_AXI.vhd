---------------------------------------------------------------------------
-- wrapper_modifications_S00_AXI.vhd
-- TP3 - Modifications apportees au wrapper AXI genere par Vivado
--
-- FICHIER CONCERNÉ : my_led_v1_0_S00_AXI.vhd
--
-- Ce fichier documente et reproduit les SEULES parties modifiees
-- dans le wrapper AXI. Le reste du fichier est genere automatiquement
-- par Vivado et ne doit pas etre modifie directement.
--
-- ATTENTION : ne pas modifier les fichiers directement dans ip_repo/
--             Toute modification doit passer par "Edit in IP Package"
--             dans Vivado, puis "Repackage IP".
---------------------------------------------------------------------------

-- =========================================================================
-- MODIFICATION 1 : Ajout du port de sortie dans l'ENTITE
-- (apres la ligne "-- Users to add ports here")
-- =========================================================================

--   leds : out std_logic_vector(15 downto 0);   -- 16 LED physiques


-- =========================================================================
-- MODIFICATION 2 : Declaration du signal interne sw_state
-- (juste avant le "begin" de l'architecture)
-- =========================================================================

--   signal sw_state : std_logic_vector(3 downto 0);
--   -- Ce signal est l'interface entre les registres AXI et le module led.
--   -- Chaque bit active un groupe de 4 LED.


-- =========================================================================
-- MODIFICATION 3 : Zone "Add user logic here"
-- Instanciation du module led et connexion des registres
-- =========================================================================

-- Instanciation directe du module fonctionnel (syntaxe VHDL-93)
-- Le port map est en ordre positionnel : (entree, sortie)
L0: entity work.led port map (sw_state, leds);

-- Connexion des bits des registres AXI -> signal sw_state
-- Le MicroBlaze ecrit dans slv_reg0 et slv_reg1 via le bus AXI.
-- On extrait les bits d'interet pour piloter les 4 groupes de LED.

sw_state(0) <= slv_reg0(0);   -- bit 0 de slv_reg0 -> LED(3:0)
sw_state(1) <= slv_reg0(1);   -- bit 1 de slv_reg0 -> LED(7:4)
sw_state(2) <= slv_reg1(0);   -- bit 0 de slv_reg1 -> LED(11:8)
sw_state(3) <= slv_reg1(1);   -- bit 1 de slv_reg1 -> LED(15:12)

-- =========================================================================
-- RAPPEL : modification identique dans my_led_v1_0.vhd (le top-level)
-- =========================================================================
-- 1) Dans l'entite (apres "-- Users to add ports here") :
--      leds : out std_logic_vector(15 downto 0);
--
-- 2) Dans la declaration du composant (avant S_AXI_ACLK) :
--      leds : out std_logic_vector(15 downto 0);
--
-- 3) Dans le port map de l'instanciation du sous-composant :
--      leds => leds,
-- =========================================================================
