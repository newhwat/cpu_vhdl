library ieee;
use ieee.std_logic_1164.all;

entity mux4x1 is 
port(
	A, B, C, D : in std_logic_vector(3 downto 0);
	sel        : in std_logic_vector(1 downto 0);
	output     : out std_logic_vector(3 downto 0)
);
end mux4x1;

architecture bhv of mux4x1 is
begin
	process(A, B, C, D, sel)
	begin
		case sel is
			when "00" =>
				output <= D;
			when "01" =>
				output <= C;
			when "10" =>
				output <= B;
			when "11" =>
				output <= A;
			when others => null;
		end case;
	end process;
end bhv;