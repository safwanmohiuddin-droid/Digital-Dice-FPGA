library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DigitalDice is
    Port (
        clk      : in  STD_LOGIC;                      -- Clock input
        reset    : in  STD_LOGIC;                      -- Reset signal
        roll     : in  STD_LOGIC;                      -- Button to roll the dice
        dice_out : out STD_LOGIC_VECTOR (2 downto 0);  -- Dice value (1-6)
        seg_out  : out STD_LOGIC_VECTOR (6 downto 0)   -- 7-segment display output
    );
end DigitalDice;

architecture Behavioral of DigitalDice is

    signal lfsr       : STD_LOGIC_VECTOR (2 downto 0) := "001"; -- 3-bit LFSR
    signal dice_value : STD_LOGIC_VECTOR (2 downto 0) := "001"; -- Dice value (1-6)
    signal running    : STD_LOGIC := '0';                        -- Flag to indicate rolling state

begin

    -- Main process for dice logic
    process (clk, reset)
    begin
        if reset = '1' then
            -- Reset LFSR and dice state
            lfsr       <= "001"; -- Reset LFSR to initial state
            dice_value <= "001"; -- Reset dice to 1
            running    <= '0';

        elsif rising_edge(clk) then
            if roll = '1' then
                running <= '1'; -- Start rolling

            elsif roll = '0' and running = '1' then
                running <= '0'; -- Stop rolling
                -- Capture dice value (map LFSR output to dice range 1-6)
                case lfsr is
                    when "000"  => dice_value <= "001"; -- Map 0 to 1
                    when "111"  => dice_value <= "001"; -- Map 7 to 1
                    when others => dice_value <= lfsr;  -- Use value as-is
                end case;
            end if;

            -- Generate next LFSR value while rolling
            if running = '1' then
                lfsr <= lfsr(1 downto 0) & (lfsr(2) xor lfsr(1)); -- Pseudo-random sequence
            end if;
        end if;
    end process;

    -- Map dice_value to 7-segment display output (updated immediately after dice_value)
    process (clk, reset)
    begin
        if reset = '1' then
            seg_out <= "1111111"; -- Blank on reset

        elsif rising_edge(clk) then
            case dice_value is
                when "001"  => seg_out <= "1111001"; -- 1
                when "010"  => seg_out <= "0100100"; -- 2
                when "011"  => seg_out <= "0110000"; -- 3
                when "100"  => seg_out <= "0011001"; -- 4
                when "101"  => seg_out <= "0010010"; -- 5
                when "110"  => seg_out <= "0000010"; -- 6
                when others => seg_out <= "1111111"; -- Blank (default case)
            end case;
        end if;
    end process;

    -- Output the dice value to LEDs
    dice_out <= dice_value;

end Behavioral;
