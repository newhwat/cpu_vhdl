library ieee;
use ieee.std_logic_1164.all;

entity datapath is
port(
	clk, rst   : in std_logic;
	in_bus     : in std_logic_vector(3 downto 0);
	sel1, sel2 : in std_logic_vector(1 downto 0);
	cin        : in std_logic;
	op         : in std_logic_vector(2 downto 0);
	cout       : out std_logic;
	out_bus    : out std_logic_vector(3 downto 0)
);
end datapath;

architecture behavioral of datapath is

	signal mux1out, mux2out : std_logic_vector(3 downto 0);
	signal regAout, regBout : std_logic_vector(3 downto 0);
	signal ALUout           : std_logic_vector(3 downto 0);

begin
	
	MUX1 : entity work.mux4x1
	port map(
		A => regBout,
		B => ALUout,
		C => in_bus,
		D => regAout,
		sel => sel1,
		output => mux1out
	);
	
	MUX2 : entity work.mux4x1
	port map(
		A => regBout,
		B => ALUout,
		C => in_bus,
		D => regAout,
		sel => sel2,
		output => mux2out
	);
	
	REGA : entity work.reg
	port map(
		clk => clk,
		rst => rst,
		input => mux1out,
		output => regAout
	);
	
	REGB : entity work.reg
	port map(
		clk => clk,
		rst => rst,
		input => mux2out,
		output => regBout
	);
	
	ALU_INST : entity work.alu
	port map(
		A => regAout,
		B => regBout,
		CIN => cin,
		op  => op ,
		cout=>cout,
		F => ALUout
	);
	
	out_bus <= ALUout;
	
end behavioral;