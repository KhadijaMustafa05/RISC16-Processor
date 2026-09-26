library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        A        : in  STD_LOGIC_VECTOR(15 downto 0);
        B        : in  STD_LOGIC_VECTOR(15 downto 0);
        ALU_Sel  : in  STD_LOGIC_VECTOR(2 downto 0);

        Result   : out STD_LOGIC_VECTOR(15 downto 0);
        Zero     : out STD_LOGIC;
        Carry    : out STD_LOGIC;
        Overflow : out STD_LOGIC;
        Negative : out STD_LOGIC
    );
end ALU;

architecture Behavioral of ALU is

    signal result_temp   : STD_LOGIC_VECTOR(15 downto 0);
    signal extended_temp : UNSIGNED(16 downto 0);
    signal carry_temp    : STD_LOGIC;
    signal overflow_temp : STD_LOGIC;

begin

    process(A, B, ALU_Sel)
        variable temp_result : STD_LOGIC_VECTOR(15 downto 0);
        variable temp_ext    : UNSIGNED(16 downto 0);
        variable temp_carry  : STD_LOGIC;
        variable temp_over   : STD_LOGIC;
    begin

        temp_result := (others => '0');
        temp_ext    := (others => '0');
        temp_carry  := '0';
        temp_over   := '0';

        case ALU_Sel is

            -- ADD
            when "000" =>
                temp_ext :=
                    ('0' & unsigned(A)) +
                    ('0' & unsigned(B));

                temp_result := STD_LOGIC_VECTOR(temp_ext(15 downto 0));
                temp_carry  := temp_ext(16);

                if (A(15) = B(15)) and
                   (temp_result(15) /= A(15)) then
                    temp_over := '1';
                end if;

            -- SUB
            when "001" =>
                temp_result :=
                    STD_LOGIC_VECTOR(unsigned(A) - unsigned(B));

                if unsigned(A) >= unsigned(B) then
                    temp_carry := '1';
                else
                    temp_carry := '0';
                end if;

                if (A(15) /= B(15)) and
                   (temp_result(15) /= A(15)) then
                    temp_over := '1';
                end if;

            -- AND
            when "010" =>
                temp_result := A and B;

            -- OR
            when "011" =>
                temp_result := A or B;

            -- XOR
            when "100" =>
                temp_result := A xor B;

            -- SHIFT LEFT
            when "101" =>
                temp_result :=
                    STD_LOGIC_VECTOR(shift_left(unsigned(A), 1));
                temp_carry := A(15);

            -- SHIFT RIGHT
            when "110" =>
                temp_result :=
                    STD_LOGIC_VECTOR(shift_right(unsigned(A), 1));
                temp_carry := A(0);

            when others =>
                temp_result := (others => '0');

        end case;

        result_temp   <= temp_result;
        extended_temp <= temp_ext;
        carry_temp    <= temp_carry;
        overflow_temp <= temp_over;

    end process;

    Result   <= result_temp;
    Carry    <= carry_temp;
    Overflow <= overflow_temp;
    Negative <= result_temp(15);

    Zero <= '1' when result_temp = x"0000"
            else '0';

end Behavioral;