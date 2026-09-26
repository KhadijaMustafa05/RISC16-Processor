library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RISC16_Processor is
    Port (
        clk          : in  STD_LOGIC;
        reset        : in  STD_LOGIC;

        -- Debug outputs for verification
        debug_pc     : out STD_LOGIC_VECTOR(15 downto 0);
        debug_instr  : out STD_LOGIC_VECTOR(15 downto 0);
        debug_result : out STD_LOGIC_VECTOR(15 downto 0);
        debug_zero   : out STD_LOGIC;
        debug_branch : out STD_LOGIC
    );
end RISC16_Processor;

architecture Structural of RISC16_Processor is

    -- Program Counter
    signal pc_current    : STD_LOGIC_VECTOR(15 downto 0);
    signal pc_plus_one   : STD_LOGIC_VECTOR(15 downto 0);
    signal pc_next       : STD_LOGIC_VECTOR(15 downto 0);
    signal branch_target : STD_LOGIC_VECTOR(15 downto 0);

    -- Instruction
    signal instruction : STD_LOGIC_VECTOR(15 downto 0);

    -- Register addresses
    signal rs1 : STD_LOGIC_VECTOR(2 downto 0);
    signal rs2 : STD_LOGIC_VECTOR(2 downto 0);
    signal rd  : STD_LOGIC_VECTOR(2 downto 0);

    -- Register data
    signal reg_data1  : STD_LOGIC_VECTOR(15 downto 0);
    signal reg_data2  : STD_LOGIC_VECTOR(15 downto 0);
    signal write_data : STD_LOGIC_VECTOR(15 downto 0);

    -- Immediate
    signal immediate : STD_LOGIC_VECTOR(15 downto 0);

    -- ALU
    signal alu_sel     : STD_LOGIC_VECTOR(2 downto 0);
    signal alu_input_b : STD_LOGIC_VECTOR(15 downto 0);
    signal alu_result  : STD_LOGIC_VECTOR(15 downto 0);

    -- ALU Flags
    signal zero_flag     : STD_LOGIC;
    signal carry_flag    : STD_LOGIC;
    signal overflow_flag : STD_LOGIC;
    signal negative_flag : STD_LOGIC;

    -- Control
    signal reg_write : STD_LOGIC;
    signal alu_src   : STD_LOGIC;
    signal mem_read  : STD_LOGIC;
    signal mem_write : STD_LOGIC;
    signal branch    : STD_LOGIC;

    -- Branch decision
    signal branch_taken : STD_LOGIC;

    -- Data Memory
    signal memory_data : STD_LOGIC_VECTOR(15 downto 0);

begin

    --------------------------------------------------
    -- Instruction Decode
    --------------------------------------------------

    rd  <= instruction(11 downto 9);
    rs1 <= instruction(8 downto 6);
    rs2 <= instruction(5 downto 3);

    immediate <= "0000000000000" & instruction(2 downto 0);

    --------------------------------------------------
    -- Program Counter Logic
    --------------------------------------------------

    pc_plus_one <=
        std_logic_vector(unsigned(pc_current) + 1);

    branch_target <=
        std_logic_vector(
            unsigned(pc_plus_one) +
            unsigned(immediate)
        );

    branch_taken <= branch and zero_flag;

    pc_next <= branch_target
               when branch_taken = '1'
               else pc_plus_one;

    --------------------------------------------------
    -- Program Counter
    --------------------------------------------------

    PC_UNIT : entity work.Program_Counter
        port map (
            clk      => clk,
            reset    => reset,
            pc_write => '1',
            pc_next  => pc_next,
            pc_out   => pc_current
        );

    --------------------------------------------------
    -- Instruction Memory
    --------------------------------------------------

    IMEM : entity work.Instruction_Memory
        port map (
            address     => pc_current,
            instruction => instruction
        );

    --------------------------------------------------
    -- Register File
    --------------------------------------------------

    REG_FILE : entity work.Register_File
        port map (
            clk        => clk,
            reset      => reset,
            write_en   => reg_write,
            read_addr1 => rs1,
            read_addr2 => rs2,
            write_addr => rd,
            write_data => write_data,
            read_data1 => reg_data1,
            read_data2 => reg_data2
        );

    --------------------------------------------------
    -- ALU Input MUX
    --------------------------------------------------

    alu_input_b <= immediate
                   when alu_src = '1'
                   else reg_data2;

    --------------------------------------------------
    -- ALU
    --------------------------------------------------

    ALU_UNIT : entity work.ALU
        port map (
            A        => reg_data1,
            B        => alu_input_b,
            ALU_Sel  => alu_sel,
            Result   => alu_result,
            Zero     => zero_flag,
            Carry    => carry_flag,
            Overflow => overflow_flag,
            Negative => negative_flag
        );

    --------------------------------------------------
    -- Data Memory
    --------------------------------------------------

    DATA_MEM : entity work.Data_Memory
        port map (
            clk        => clk,
            mem_write  => mem_write,
            mem_read   => mem_read,
            address    => alu_result,
            write_data => reg_data2,
            read_data  => memory_data
        );

    --------------------------------------------------
    -- Control Unit
    --------------------------------------------------

    CONTROL : entity work.Control_Unit
        port map (
            opcode      => instruction(15 downto 12),
            reg_write   => reg_write,
            alu_src     => alu_src,
            mem_write   => mem_write,
            mem_read    => mem_read,
            branch      => branch,
            alu_control => alu_sel
        );

    --------------------------------------------------
    -- Write Back
    --------------------------------------------------

    write_data <= memory_data
                  when mem_read = '1'
                  else alu_result;

    --------------------------------------------------
    -- Debug / Verification Outputs
    --------------------------------------------------

    debug_pc     <= pc_current;
    debug_instr  <= instruction;
    debug_result <= alu_result;
    debug_zero   <= zero_flag;
    debug_branch <= branch_taken;

end Structural;