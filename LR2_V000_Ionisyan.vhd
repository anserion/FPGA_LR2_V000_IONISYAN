----------------------------------------------------------------------------------
-- Company: SKFU, 4PMI
-- Engineer: Ionisyan A.S.
-- Module Name:    LR2_V000_Ionisyan
-- Project Name: LR2_var(000)
----------------------------------------------------------------------------------
entity LR2_V000_Ionisyan is
    Port ( a : in  bit_vector(31 downto 0);
           b : in  bit_vector(31 downto 0);
           c : out  bit_vector(31 downto 0);
           clk : in  bit);
end LR2_V000_Ionisyan;

architecture Behavioral of LR2_V000_Ionisyan is
component bin_add is
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n-1 downto 0);
      clk: in bit);
end component;

component bin_sub is
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n-1 downto 0);
      clk: in bit);
end component;

component bin_mul is
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n-1 downto 0);
      clk: in bit);
end component;

signal a_plus_b,a_plus_b_pow2,a_plus_b_pow3,apbp3_minus_am7,a_mul_7:bit_vector(31 downto 0);
begin
--c=(a+b)^3-7a+b
--1) a_plus_b=a+b
a_plus_b_chip: bin_add generic map(32) port map(a,b,a_plus_b,clk);
--2) a_plus_b_pow2=a_plus_b*a_plus_b
a_plus_b_pow2_chip: bin_mul generic map(32) port map(a_plus_b,a_plus_b,a_plus_b_pow2,clk);
--3) a_plus_b_pow3=a_plus_b*a_plus_b_pow2
a_plus_b_pow3_chip: bin_mul generic map(32) port map(a_plus_b_pow2,a_plus_b,a_plus_b_pow3,clk);
--4) a_mul_7=a*7
a_mul_7_chip: bin_mul generic map(32) port map(a,"00000000000000000000000000000111",a_mul_7, clk);
--5) apbp3_minus_am7=a_plus_b_pow3-a_mul_7
apbp3_minus_am7_chip: bin_sub generic map(32) port map(a_plus_b_pow3,a_mul_7,apbp3_minus_am7,clk);
--6) c=apbp3_minus_am7+b
res_chip: bin_add generic map(32) port map(apbp3_minus_am7,b,c,clk);
end Behavioral;

---------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
entity LR2_V000_Ionisyan_good is
    Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
           b : in  STD_LOGIC_VECTOR (31 downto 0);
           c : out  STD_LOGIC_VECTOR (31 downto 0);
           clk : in  STD_LOGIC);
end LR2_V000_Ionisyan_good;

architecture Behavioral of LR2_V000_Ionisyan_good is
signal tmp:std_logic_vector(95 downto 0);
begin
   process (clk)
   begin
   if (clk'event and clk='1') then
      --tmp=(a+b)^3-7a+b
      tmp<=(a+b)*(a+b)*(a+b)-conv_std_logic_vector(7,32)*a+b;
   end if;
   end process;
   c<=tmp(31 downto 0);
end Behavioral;
