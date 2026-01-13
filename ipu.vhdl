library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

library work;
use work.types.calc;
use work.types.dest;
use work.reg8;

entity IPU is
  port (
    wdbl: in std_logic_vector(7 downto 0);
    clk: out std_logic;
    dst: out dest;
    clc: out calc
  );
end IPU;

architecture IPU of IPU is
  type microcode_type is record
    clc: calc;
    dst: dest;
  end record;  
  type instr_type is array(0 to 15) of microcode_type;
  type instr_table_type is array(0 to 255) of instr_type;
  signal itable: instr_table_type := (
    ((c16_pc1, d16_adc), (c16_imm, d16_adc), (c8_mem, d8_rga), (c16_pc3, d16_pct), (c_nil, d0_end), others => (c_nil, d_nil)),
    others => ((c_nil, d0_end), others => (c_nil, d_nil))
  );  
begin
  process
    variable step: integer := 0;
    variable instr: integer := 0;
  begin
    step := 0;
    clk <= '0';
    
    clc <= c16_pc0;
    dst <= d16_adc;
    
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    
    clc <= c8_mem;
    dst <= d_nil;

    wait for 5 ns;
    instr := to_integer(unsigned(wdbl));
    clk <= '1';
    wait for 5 ns;
    clk <= '0';

    loop
      clc <= itable(instr)(step).clc;
      dst <= itable(instr)(step).dst;

      wait for 5 ns;
      clk <= '1';
      wait for 5 ns;
      clk <= '0';

      exit when itable(instr)(step).dst = d0_end;
      step := step + 1;
    end loop;
  end process;
      
end IPU;      
