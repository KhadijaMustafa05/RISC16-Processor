library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Program_Counter is
    Port (
        clk      : in  STD_LOGIC;
        reset    : in  STD_LOGIC;
        pc_write : in  STD_LOGIC;
        pc_next  : in  STD_LOGIC_VECTOR(15 downto 0);
        pc_out   : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Program_Counter;

architecture Behavioral of Program_Counter is

    signal pc_reg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

begin

    process(clk, reset)
    begin
        if reset = '1' then
            pc_reg <= (others => '0');

        elsif rising_edge(clk) then
            if pc_write = '1' then
                pc_reg <= pc_next;
            end if;
        end if;
    end process;

    pc_out <= pc_reg;

end Behavioral;