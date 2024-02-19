-- Controller Design

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity controller is
port(
	-- Inputs:
	START : in std_logic;
	cout : in std_logic;
	machine_code : in std_logic_vector(4 downto 0); -- 5-Bit machine code, (3 bit inst, 2 bit destination)
	clk, reset : in std_logic;

	-- Outputs:
	lda, ldb : out std_logic; -- load a or b 
	sel1, sel2 : out std_logic_vector(1 downto 0); -- select value in datapath
	cin : out std_logic;
	op : out std_logic_vector(2 downto 0); -- operation for the ALU
	DONE : out std_logic); -- When controller has finished operations
end controller;


-- controller architecture
architecture behaviorial of controller is
	-- STATES:
	type StateType is (Decode, LD, TB, AN, OO, AD, SB, SL, OT, TWOS);
	signal cur_state : StateType:=Decode;

	-- CONSTANTS:
	-- Constant values for selectors:
	constant sel_A : std_logic_vector(1 downto 0):= "00";
	constant sel_B : std_logic_vector(1 downto 0):= "11";
	constant sel_in : std_logic_vector(1 downto 0):= "01";
	constant sel_out : std_logic_vector(1 downto 0):= "10";

begin
	
	ASM : process(clk, reset)
	begin
		if (reset = '1') then
			cur_state <= Decode;
			DONE <= '0';
		elsif (rising_edge(clk)) then
			case cur_state is
				-- DECODE INSTRUCTIONS
				when Decode =>
					if (START = '1' and (machine_code(1 downto 0) < "10")) then
						case machine_code(4 downto 2) is
							when "000" => 
								cur_state <= LD;
								lda <= '1';
								ldb <= '1';
							when "001" => 
								cur_state <= TB; 
								lda <= '1'; 
								ldb <= '1';
							when "010" => 
								cur_state <= AN; 
								lda <= '1'; 
								ldb <= '1';
							when "011" => 
								cur_state <= OO; 
								lda <= '1'; 
								ldb <= '1';
							when "100" => 
								cur_state <= AD; 
								lda <= '1'; 
								ldb <= '1';
							when "101" => 
								cur_state <= TWOS; 
								lda <= '1';
							when "110" => 
								cur_state <= SL; 
								lda <= '1';
							when "111" => 
								cur_state <= OT; 
							when others => NULL;
						end case;
						DONE <= '1';
					else 
						-- MALFORMED INSTRUCTION OR START = '0'
						DONE <= '0';
					end if;
				when TWOS =>
					cur_state <= SB;
				when others => -- default case:
					cur_state <= Decode;
					DONE <= '1';
			end case;
		end if;
	end process;	
	
	Control: process(cur_state, machine_code(1 downto 0))
	begin
		if (cur_state = Decode) then
			sel1 <= sel_a;
			sel2 <= sel_b;
		elsif (cur_state = LD) then
			case machine_code(1 downto 0) is 
				when "00" => -- REG A
					sel1 <= sel_in;
					sel2 <= sel_b;
				when "01" => -- REG B
					sel1 <= sel_a;
					sel2 <= sel_in;
				when others => NULL;
			end case;
		elsif (cur_state = TWOS) then
			sel1 <= sel_a;
		elsif (cur_state = SB) then
			sel1 <= sel_b;
			sel2 <= sel_a;
		else 
			case machine_code(1 downto 0) is 
				when "00" => -- REG A
					sel1 <= sel_out;
				when "01" => -- REG B
					sel2 <= sel_out;
				when others => NULL;
			end case;
		end if;

		-- Operations
		
		case cur_state is
			when AD =>
				OP <= "011";
				cin <= cout;
			when SL =>
				OP <= "111";
			when AN =>
				OP <= "001";
			when OO =>
				OP <= "010";
			when TWOS =>
				OP <= "000";
			when SB =>
				OP <= "011";
			when others => NULL;
		end case;
	end process;
end architecture;