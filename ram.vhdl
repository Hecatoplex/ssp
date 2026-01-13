library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAM is
  port (
    adh, adl: in std_logic_vector(7 downto 0);
    wdbh, wdbl: in std_logic_vector(7 downto 0);
    r, w, clk, mode: in std_logic;
    rdbh, rdbl: out std_logic_vector(7 downto 0)
  );
end RAM;

architecture RAM of RAM is
  type ram_type is array(0 to 32767) of std_logic_vector(7 downto 0);
  signal storage: ram_type := (X"01", X"02", X"03", others => X"00");
  signal address: std_logic_vector(15 downto 0);
begin
  address <= adh & adl;
  process(clk)
  begin
    if (rising_edge(clk)) then
      if (w = '1') then
        storage(to_integer(unsigned(address))) <= wdbl;
        if (mode = '1') then
          storage(to_integer(unsigned(address)) + 1) <= wdbh;
        end if;  
      end if;
    end if;
  end process;

  rdbh <= storage(to_integer(unsigned(address)) + 1) when (r = '1' and mode = '1') else
          (others => 'Z');
  rdbl <= storage(to_integer(unsigned(address))) when (r = '1') else
          (others => 'Z');
end RAM;
