library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.types.calc;
use work.types.dest;

entity APU is
  port (
    adh, adl, x, y: in std_logic_vector(7 downto 0);
    clc: in calc;
    dst: in dest;
    w_ram, r_ram, r_rom, mode: out std_logic;
    offset: out std_logic_vector(7 downto 0)
  );
end APU;

architecture APU of APU is
  -- user will have to ensure that 16 bit accesses stay in either ram or rom.
  type map_section is (ram_acc, rom_acc);
  signal rgn: map_section;
  signal wt, rd: std_logic;
  signal addr: std_logic_vector(15 downto 0);
begin
  addr <= adh & adl;
  rgn <= ram_acc when addr < X"7FFF" else
         rom_acc;

  wt <= '1' when (dst = d8_mem or dst = d8_mmx) else
        '0';
  rd <= '1' when (clc = c8_mem or clc = c8_mmx or clc = c8_mmy or clc = c16_imm or clc = c16_inx or clc = c16_iny) else
        '0';

  w_ram <= '1' when (rgn = ram_acc and wt = '1') else
           '0';
  r_ram <= '1' when (rgn = ram_acc and rd = '1') else
           '0';
  r_rom <= '1' when (rgn = rom_acc and rd = '1') else
           '0';

  mode <= '1' when (clc = c16_imm or clc = c16_inx or clc = c16_iny) else
          '0';
  offset <= X"00" when (clc = c8_mem or clc = c16_imm or dst = d8_mem) else
            x when (clc = c8_mmx or clc = c16_inx or dst = d8_mmx) else
            y when (clc = c8_mmy or clc = c16_iny) else
            (others => 'Z');
end APU;
