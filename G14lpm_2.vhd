LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity g14lpm is
port ( i_clk	: in std_logic;
	    i_rstb  : in std_logic;
		 i_x     : in std_logic_vector(31 downto 0);
		 i_y     : in std_logic_vector(31 downto 0);
		 o_xx, o_yy, o_xy : out std_logic_vector(64 downto 0)
);
end g14lpm;

architecture arc of g14lpm is
signal r_x : signed(31 downto 0);
signal r_y : signed(31 downto 0);
signal xx  : std_logic_vector(63 downto 0);
signal yy  : std_logic_vector(63 downto 0);
signal xy  : std_logic_vector(63 downto 0);

--------------------- COMPONENT DECLARATION------------------------------------
component LPM_MULT
generic ( LPM_WIDTHA : natural;
LPM_WIDTHB : natural;
LPM_WIDTHP : natural;
LPM_REPRESENTATION : string := "SIGNED";
LPM_PIPELINE : natural := 0;
LPM_TYPE: string := L_MULT;
LPM_HINT : string := "UNUSED");
port ( DATAA : in std_logic_vector(LPM_WIDTHA-1 downto 0);
		 DATAB : in std_logic_vector(LPM_WIDTHB-1 downto 0);
		 ACLR  : in std_logic := '0';
		 CLOCK : in std_logic := '0';
		 CLKEN : in std_logic := '1';
		 RESULT : out std_logic_vector(LPM_WIDTHP-1 downto 0));
end component;

begin
------------------------COMPONENT INSTANTIATION---------------------------------
		mult1 : LPM_MULT generic map (
				  LPM_WIDTHA => 32,
				  LPM_WIDTHB => 32,
				  LPM_WIDTHP => 64,
				  LPM_REPRESENTATION => "SIGNED",
				  LPM_PIPELINE => 2
		)
		port map ( DATAA => i_x, DATAB => i_x, CLOCK => i_clk, RESULT => xx );
		mult2 : LPM_MULT generic map (
				  LPM_WIDTHA => 32,
				  LPM_WIDTHB => 32,
				  LPM_WIDTHP => 64,
				  LPM_REPRESENTATION => "SIGNED",
				  LPM_PIPELINE => 2
		)
		port map ( DATAA => i_y, DATAB => i_y, CLOCK => i_clk, RESULT => yy );
		mult3 : LPM_MULT generic map (
				  LPM_WIDTHA => 32,
				  LPM_WIDTHB => 32,
				  LPM_WIDTHP => 64,
				  LPM_REPRESENTATION => "SIGNED",
				  LPM_PIPELINE => 2
		)
		port map ( DATAA => i_x, DATAB => i_y, CLOCK => i_clk, RESULT => xy );

		p_mult : process (i_clk, i_rstb)
		begin

		if (i_rstb = '0') then
			o_xx <= (others => '0');
			o_yy <= (others => '0');
			o_xy <= (others => '0');
			r_x <= (others => '0');
			r_y <= (others => '0');
		elsif (rising_edge(i_clk)) then
			r_x <= signed(i_x);
			r_y <= signed(i_y);

		o_xx <= std_logic_vector ('0' & signed(xx) - signed(yy));
		o_yy <= std_logic_vector (r_X*r_y & '0');

		end if;
		end process p_mult;


end arc;
