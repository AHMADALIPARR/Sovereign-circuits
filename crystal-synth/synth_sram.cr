# synth_sram.cr — Synthesizes pure VHDL for GHDL + gate-level JSON for SAW (no Yosys)
require "json"

VHDL_SRC = <<-VHDL
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
VHDL

File.write("sram_write_cell.vhd", VHDL_SRC)

# Structural gate-level JSON netlist in SAW's yosys_import schema (no Yosys needed)
netlist = {
  "creator" => "Crystal-ZeroDep-Synth 1.0",
  "modules" => {
    "sram_write_cell" => {
      "attributes" => {"top" => "00000000000000000000000000000001"},
      "ports" => {
        "we"   => {"direction" => "input",  "bits" => [2]},
        "din"  => {"direction" => "input",  "bits" => [3]},
        "q_in" => {"direction" => "input",  "bits" => [4]},
        "q"    => {"direction" => "output", "bits" => [5]},
        "bl"   => {"direction" => "output", "bits" => [6]},
        "bl_b" => {"direction" => "output", "bits" => [7]},
      },
      "cells" => {
        "$mux_q" => {
          "type" => "$_MUX_",
          "port_directions" => {"A" => "input", "B" => "input", "S" => "input", "Y" => "output"},
          "connections"     => {"A" => [4], "B" => [3], "S" => [2], "Y" => [5]},
        },
        "$and_bl" => {
          "type" => "$_AND_",
          "port_directions" => {"A" => "input", "B" => "input", "Y" => "output"},
          "connections"     => {"A" => [3], "B" => [2], "Y" => [6]},
        },
        "$not_din" => {
          "type" => "$_NOT_",
          "port_directions" => {"A" => "input", "Y" => "output"},
          "connections"     => {"A" => [3], "Y" => [8]},
        },
        "$and_bl_b" => {
          "type" => "$_AND_",
          "port_directions" => {"A" => "input", "B" => "input", "Y" => "output"},
          "connections"     => {"A" => [8], "B" => [2], "Y" => [7]},
        },
      },
    },
  },
}

File.write("sram_write_cell.json", netlist.to_pretty_json)
puts "Synthesized sram_write_cell.vhd and sram_write_cell.json (0 Yosys deps)"
