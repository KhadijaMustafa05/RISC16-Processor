library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_Memory is
    Port (
        clk        : in  STD_LOGIC;
        mem_write  : in  STD_LOGIC;
        mem_read   : in  STD_LOGIC;
        address    : in  STD_LOGIC_VECTOR(15 downto 0);
        write_data : in  STD_LOGIC_VECTOR(15 downto 0);
        read_data  : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Data_Memory;

architecture Behavioral of Data_Memory is

    type memory_array is array (0 to 255) of STD_LOGIC_VECTOR(15 downto 0);
    signal memory : memory_array := (others => (others => '0'));

begin

    -- Synchronous write
    process(clk)
    begin
        if rising_edge(clk) then
            if mem_write = '1' then
                memory(to_integer(unsigned(address(7 downto 0)))) <= write_data;
            end if;
        end if;
    end process;

    -- Asynchronous read
    process(memory, address, mem_read)
    begin
        if mem_read = '1' then
            read_data <= memory(to_integer(unsigned(address(7 downto 0))));
        else
            read_data <= (others => '0');
        end if;
    end process;

end Behavioral;