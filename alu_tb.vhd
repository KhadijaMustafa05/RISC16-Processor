library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_TB is
end ALU_TB;

architecture Behavioral of ALU_TB is

    signal A       : STD_LOGIC_VECTOR(15 downto 0);
    signal B       : STD_LOGIC_VECTOR(15 downto 0);
    signal ALU_Sel : STD_LOGIC_VECTOR(2 downto 0);
    signal Result  : STD_LOGIC_VECTOR(15 downto 0);

begin

    DUT: entity work.ALU
        port map (
            A       => A,
            B       => B,
            ALU_Sel => ALU_Sel,
            Result  => Result
        );

    stimulus: process
    begin

        -- ADD: 7 + 3 = 10
        A <= std_logic_vector(to_unsigned(7,16));
        B <= std_logic_vector(to_unsigned(3,16));
        ALU_Sel <= "000";
        wait for 10 ns;

        -- SUB: 7 - 3 = 4
        ALU_Sel <= "001";
        wait for 10 ns;

        -- AND
        ALU_Sel <= "010";
        wait for 10 ns;

        -- OR
        ALU_Sel <= "011";
        wait for 10 ns;

        -- XOR
        ALU_Sel <= "100";
        wait for 10 ns;

        -- SHIFT LEFT
        ALU_Sel <= "101";
        wait for 10 ns;

        -- SHIFT RIGHT
        ALU_Sel <= "110";
        wait for 10 ns;

        wait;

    end process;

end Behavioral;