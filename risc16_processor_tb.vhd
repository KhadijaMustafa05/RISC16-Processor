library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RISC16_Processor_TB is
end RISC16_Processor_TB;

architecture Behavioral of RISC16_Processor_TB is

    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';

    signal debug_pc     : STD_LOGIC_VECTOR(15 downto 0);
    signal debug_instr  : STD_LOGIC_VECTOR(15 downto 0);
    signal debug_result : STD_LOGIC_VECTOR(15 downto 0);
    signal debug_zero   : STD_LOGIC;
    signal debug_branch : STD_LOGIC;

begin

    --------------------------------------------------
    -- Device Under Test
    --------------------------------------------------

    DUT : entity work.RISC16_Processor
        port map (
            clk          => clk,
            reset        => reset,
            debug_pc     => debug_pc,
            debug_instr  => debug_instr,
            debug_result => debug_result,
            debug_zero   => debug_zero,
            debug_branch => debug_branch
        );

    --------------------------------------------------
    -- Clock: 10 ns period
    --------------------------------------------------

    clk <= not clk after 5 ns;

    --------------------------------------------------
    -- Automatic Verification
    --------------------------------------------------

    process
    begin

        -- Reset
        reset <= '1';
        wait for 20 ns;

        reset <= '0';

        -- PC = 0
        wait for 1 ns;

        assert unsigned(debug_pc) = 0
            report "FAIL: Expected PC = 0"
            severity error;

        -- First instruction
        wait until rising_edge(clk);
        wait for 1 ns;

        assert unsigned(debug_pc) = 1
            report "FAIL: Expected PC = 1"
            severity error;

        -- Second instruction
        wait until rising_edge(clk);
        wait for 1 ns;

        assert unsigned(debug_pc) = 2
            report "FAIL: Expected PC = 2"
            severity error;

        --------------------------------------------------
        -- BEQ should execute here
        -- R1 = 5 and R2 = 5
        --------------------------------------------------

        assert debug_zero = '1'
            report "FAIL: Zero flag should be 1 during BEQ"
            severity error;

        assert debug_branch = '1'
            report "FAIL: BEQ should be taken"
            severity error;

        -- Next PC MUST jump to 5
        wait until rising_edge(clk);
        wait for 1 ns;

        assert unsigned(debug_pc) = 5
            report "FAIL: Branch failed - expected PC = 5"
            severity error;

        report "PASS: BEQ branch taken correctly. PC jumped from 2 to 5."
            severity note;

        --------------------------------------------------
        -- Continue executing
        --------------------------------------------------

        wait until rising_edge(clk);
        wait for 1 ns;

        assert unsigned(debug_pc) = 6
            report "FAIL: Expected PC = 6"
            severity error;

        wait until rising_edge(clk);
        wait for 1 ns;

        assert unsigned(debug_pc) = 7
            report "FAIL: Expected PC = 7"
            severity error;

        report "PASS: RISC16 control-flow verification completed."
            severity note;

        wait;

    end process;

end Behavioral;