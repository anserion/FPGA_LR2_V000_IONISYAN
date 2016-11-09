----------------------------------------------------------------------------------
-- Company: SKFU, 4PMI
-- Engineer: Ionisyan A.S.
-- Module Name:  LR2_V000_Ionisyan
-- Project Name: LR2_var(000)
----------------------------------------------------------------------------------
------------------------------------------------------------------------
-- полный 1-битовый сумматор
------------------------------------------------------------------------
entity full_adder is
   Port (op1,op2,carry_in: in bit; res,carry_out: out bit; clk: in bit);
end full_adder;
architecture Behavioral of full_adder is
signal p:bit;
begin
process(clk)
begin
   if (clk'event and clk = '1') then
      p<=(not(op1) and op2)or (op1 and not(op2));
      res<=(not(p) and carry_in)or(p and not(carry_in));
      carry_out<=(op1 and op2)or(p and carry_in);
   end if;
end process;
end Behavioral;

------------------------------------------------------------------------
-- n-бит двоичный сумматор
------------------------------------------------------------------------
entity bin_add is
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n-1 downto 0);
      clk: in bit);
end bin_add;
architecture Behavioral of bin_add is
component full_adder
   Port (op1,op2,carry_in: in bit; res,carry_out: out bit; clk: in bit);
end component;
signal carry:bit_vector(n downto 0);
begin
carry(0)<='0';
gen: for i in 0 to n-1 generate
   begin
     adder: full_adder port map(op1(i),op2(i),carry(i),res(i),carry(i+1),clk);
   end generate;
end Behavioral;

------------------------------------------------------------------------
-- n-бит двоичный вычитатель
------------------------------------------------------------------------
entity bin_sub is
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n-1 downto 0);
      clk: in bit);
end bin_sub;
architecture Behavioral of bin_sub is
component full_adder
   Port (op1,op2,carry_in: in bit; res,carry_out: out bit; clk: in bit);
end component;
signal carry:bit_vector(n downto 0);
begin
carry(0)<='1';
gen: for i in 0 to n-1 generate
   begin
     adder: full_adder port map(op1(i),not(op2(i)),carry(i),res(i),carry(i+1),clk);
   end generate;
end Behavioral;

------------------------------------------------------------------------
-- n-бит двоичный перемножитель (столбиком)
------------------------------------------------------------------------
entity bin_mul is
Generic (n: integer);
Port (op1,op2: in bit_vector(n-1 downto 0);
      res: out bit_vector(n-1 downto 0);
      clk: in bit);
end bin_mul;
architecture Behavioral of bin_mul is
component bin_add
generic(n:integer);
Port(op1,op2:in bit_vector(n-1 downto 0); res:out bit_vector(n-1 downto 0); clk: in bit);
end component;
type T_tmp_sum is array(0 to n) of bit_vector(n-1 downto 0);
signal tmp_sum,tmp_op1: T_tmp_sum; 
begin
tmp_sum(0)<=(others=>'0');
gen: for i in 0 to n-1 generate
   begin
     tmp_op1(i)(i-1 downto 0)<=(others=>'0');
     tmp_op1(i)(n-1 downto i)<=(others=>'0') when op2(i)='0' else op1(n-i-1 downto 0);
     adder: bin_add generic map(n) port map(tmp_sum(i),tmp_op1(i),tmp_sum(i+1),clk);
   end generate;
res<=tmp_sum(n);
end Behavioral;
