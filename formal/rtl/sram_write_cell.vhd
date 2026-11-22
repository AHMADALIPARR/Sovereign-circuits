library ieee;
use ieee.std_logic_1164.all;

entity sram_write_cell is
  port (
    we   : in  std_logic;
    din  : in  std_logic;
    q_in : in  std_logic;
    q    : out std_logic;
    bl   : out std_logic;
    bl_b : out std_logic
  );
end entity sram_write_cell;

architecture rtl of sram_write_cell is
begin
  -- Zero-dependency combinational write-cell mux + complementary bitlines
  q    <= din when we = '1' else q_in;
  bl   <= din and we;
  bl_b <= (not din) and we;
end architecture rtl;
