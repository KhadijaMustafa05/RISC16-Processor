library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Memory is
    Port (
        address     : in  STD_LOGIC_VECTOR(15 downto 0);
        instruction : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is

    type memory_array is array (0 to 255) of
        STD_LOGIC_VECTOR(15 downto 0);

    signal memory : memory_array := (

        -- ADDI R1, R0, 5
        -- R1 = 5
        0 => "0111001000000101",

        -- ADDI R2, R0, 3
        -- R2 = 3
        1 => "0111010000000011",

        -- ADD R3, R1, R2
        -- R3 = 5 + 3 = 8
        2 => "0000011001010000",

        -- SUB R4, R1, R2
        -- R4 = 5 - 3 = 2
        3 => "0001100001010000",

        -- AND R5, R1, R2
        -- R5 = 5 AND 3 = 1
        4 => "0010101001010000",

        -- OR R6, R1, R2
        -- R6 = 5 OR 3 = 7
        5 => "0011110001010000",

        -- XOR R7, R1, R2
        -- R7 = 5 XOR 3 = 6
        6 => "0100111001010000",

        others => (others => '0')
    );

begin

    instruction <= memory(
        to_integer(unsigned(address(7 downto 0)))
    );

end Behavioral;