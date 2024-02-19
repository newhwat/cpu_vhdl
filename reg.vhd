library ieee;
use ieee.std_logic_1164.all;

entity reg is
port(
	clk   : in std_logic;
	rst   : in std_logic;
	input : in std_logic_vector(3 downto 0);
	output: out std_logic_vector(3 downto 0)
);
end reg;

architecture bhv of reg is
begin
	process(clk, rst, input)
	begin
		if (rst = '1') then
			output <= "0000";
		elsif (rising_edge(clk)) then
			output <= input;
		end if;
	end process;
end bhv;