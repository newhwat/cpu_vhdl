library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity alu is
 Port ( 
 A, B : in  std_logic_vector(3 downto 0);
 CIN  : in  std_logic;
 OP   : in  STD_LOGIC_VECTOR(2 downto 0);
 COUT : out  std_logic;
 F    : out std_logic_vector(3 downto 0)); -- "1111" 
end alu;

architecture Behavioral of alu is
signal Carry : std_logic; -- Initialize Cin based on CIN input
begin
    process (A, B, OP, CIN)
    begin
        case OP is
            when "000" => -- 2's Complement
                F <= (not A) + "0001"; 
            when "001" => -- AND
                F <= A and B;
            when "010" => -- OR
                F <= A or B;
            when "011" => -- ADD
					 Carry <= CIN;
                for i in 0 to 3 loop
                    F(i) <= A(i) xor B(i) xor Cin;
                    Carry <= (A(i) and B(i)) or (Cin and (A(i) or B(i)));
                end loop;
                COUT <= carry; -- Set carry-out to the carry value after addition
            when "100" => -- OUTA (copy A to F)
                F <= A;
            when "101" => -- OUTB (copy B to F)
                F <= B;
            when "110" => -- SLL (shift A left)
                F <= '0' & A(3 downto 1);
            when "111" => -- SRL (shift A right)
                F <= A(2 downto 0) & '0';
            when others =>
                F <= (others => '0'); -- Default behavior (all zeros)
        end case;
    end process;
end Behavioral;
	