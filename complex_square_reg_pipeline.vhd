library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity complex_square_reg_pipeline is 
port (
	i_clk		: in 	std_logic;
	i_rstb	: in std_logic;
	i_x		: in std_logic_vector(31 downto 0);
	i_y		: in std_logic_vector(31 downto 0);
	o_xx, o_yy	: out std_logic_vector(64 downto 0));
end complex_square_reg_pipeline;

architecture rtl of complex_square_reg_pipeline is 
signal r_x, r_y : signed (31 downto 0);
signal p_reg_x : signed(64 downto 0);
signal p_reg_y : signed(63 downto 0);
begin 
p_mult : process(i_clk, i_rstb)

begin 
	if (i_rstb = '0') then 
	o_xx <= (others => '0');
	o_yy <= (others => '0');
	r_x <= (others => '0');
	r_y <= (others => '0');
	p_reg_x <= (others => '0');
	p_reg_y <= (others => '0');
	
	elsif(rising_edge(i_clk)) then 
				r_x <= signed(i_x);
				r_y <= signed(i_y);
				p_reg_x <= ('0' & (r_x*r_x));
				p_reg_y <= (r_y * r_y);
				o_xx <= std_logic_vector(p_reg_x - p_reg_y);
				o_yy <= std_logic_vector(r_x*r_y & '0');
				
				end if;
end process p_mult;
end rtl;
