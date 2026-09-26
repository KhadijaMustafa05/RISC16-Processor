library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File is
    Port (
        clk        : in  STD_LOGIC;
        reset      : in  STD_LOGIC;
        write_en   : in  STD_LOGIC;
        read_addr1 : in  STD_LOGIC_VECTOR(2 downto 0);
        read_addr2 : in  STD_LOGIC_VECTOR(2 downto 0);
        write_addr : in  STD_LOGIC_VECTOR(2 downto 0);
        write_data : in  STD_LOGIC_VECTOR(15 downto 0);
        read_data1 : out STD_LOGIC_VECTOR(15 downto 0);
        read_data2 : out STD_LOGIC_VECTOR(15 downto 0)
    );
end Register_File;

architecture Behavioral of Register_File is

    type register_array is array (0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
    signal registers : register_array := (others => (others => '0'));

begin

    process(clk, reset)
    begin
        if reset = '1' then
            registers <= (others => (others => '0'));

        elsif rising_edge(clk) then
            if write_en = '1' then
                registers(to_integer(unsigned(write_addr))) <= write_data;
            end if;
        end if;
    end process;

    read_data1 <= registers(to_integer(unsigned(read_addr1)));
    read_data2 <= registers(to_integer(unsigned(read_addr2)));

end Behavioral;