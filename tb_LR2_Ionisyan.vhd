----------------------------------------------------------------------------------
-- Company: SKFU, 4PMI
-- Engineer: Ionisyan A.S.
-- Module Name: LR2_V000_Ionisyan
-- Project Name: LR2_var(000)
----------------------------------------------------------------------------------
LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.numeric_bit.all;
 
ENTITY tb_LR2_Ionisyan IS
END tb_LR2_Ionisyan;
 
ARCHITECTURE behavior OF tb_LR2_Ionisyan IS 
    COMPONENT LR2_V000_Ionisyan
    PORT(a : IN  bit_vector(31 downto 0);
         b : IN  bit_vector(31 downto 0);
         c : OUT  bit_vector(31 downto 0);
         clk : IN  bit);
    END COMPONENT;

    COMPONENT LR2_V000_Ionisyan_good is
    PORT( a : in  STD_LOGIC_VECTOR (31 downto 0);
          b : in  STD_LOGIC_VECTOR (31 downto 0);
          c : out  STD_LOGIC_VECTOR (31 downto 0);
          clk : in  STD_LOGIC);
    END COMPONENT;

   --Inputs/Outputs
   signal a,b,c : bit_vector(31 downto 0);
   signal clk : bit := '0';

   signal a_good,b_good,c_good : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut_lr2: LR2_V000_Ionisyan PORT MAP(a,b,c,clk);
   uut_good: LR2_V000_Ionisyan_good PORT MAP(a_good,b_good,c_good,to_stdulogic(clk));

   a<=bit_vector(to_unsigned(7,32));
   b<=bit_vector(to_unsigned(5,32));
   
   -- Clock process definitions
   clk_process :process
	variable a_tmp:integer:=0;
	variable b_tmp:integer:=0;
   begin
      clk <= '1';
		a_good<=conv_std_logic_vector(a_tmp,32);
		b_good<=conv_std_logic_vector(b_tmp,32);
		wait for clk_period/2;
		clk <= '0';
		a_tmp:=a_tmp+1;
		if a_tmp>15 then 
		   a_tmp:=0;
			b_tmp:=b_tmp+1;
			if b_tmp>15 then b_tmp:=0; end if;
		end if;
		wait for clk_period/2;
   end process;
END;
