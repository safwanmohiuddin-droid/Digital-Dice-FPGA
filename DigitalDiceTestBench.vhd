library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DigitalDiceTestBench is
    -- No ports as it's a test bench
end DigitalDiceTestBench;

architecture Behavioral of DigitalDiceTestBench is

    -- Component declaration for the Unit Under Test (UUT)
    component DigitalDice
        Port (
            clk      : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            roll     : in  STD_LOGIC;
            dice_out : out STD_LOGIC_VECTOR (2 downto 0);
            seg_out  : out STD_LOGIC_VECTOR (6 downto 0)
        );
    end component;

    -- Signals to connect to the UUT
    signal clk      : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '0';
    signal roll     : STD_LOGIC := '0';
    signal dice_out : STD_LOGIC_VECTOR (2 downto 0);
    signal seg_out  : STD_LOGIC_VECTOR (6 downto 0);

    -- Clock period constant
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the UUT
    UUT: DigitalDice
        Port map (
            clk      => clk,
            reset    => reset,
            roll     => roll,
            dice_out => dice_out,
            seg_out  => seg_out
        );

    -- Clock generation process
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Reset the system
        reset <= '1';
        wait for 20 ns;
        reset <= '0';

        -- Wait for a few clock cycles
        wait for 50 ns;

        -- Start rolling the dice
        roll <= '1';
        wait for 100 ns;

        -- Stop rolling the dice
        roll <= '0';
        wait for 50 ns;

        -- Start rolling again
        roll <= '1';
        wait for 50 ns;

        -- Stop rolling again
        roll <= '0';
        wait for 50 ns;

        -- End simulation
        wait for 100 ns;
        assert false report "Simulation Complete" severity note;

    end process;

end Behavioral;
