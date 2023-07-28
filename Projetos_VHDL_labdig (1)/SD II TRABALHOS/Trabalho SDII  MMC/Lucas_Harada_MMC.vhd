library IEEE;
use IEEE.numeric_bit.all;

entity mmc is
port(
    reset, clock: in bit;
    inicia: in bit;
    A,B: in bit_vector(7 downto 0);
    fim: out bit;
    nSomas: out bit_vector(8 downto 0);
    MMC: out bit_vector(15 downto 0)
);
end mmc;

architecture mmc_arquitetura of mmc is
signal a_auce , b_auce : bit_vector ( 15 downto 0 ) ;
signal n_Somas : bit_vector ( 8 downto 0 ) ;
type ciclos_maquina is ( espera , testa , diferente , igual ) ;
signal estado : ciclos_maquina ;

begin
abc : process ( clock , inicia )
begin
if ( reset = '1' ) then
estado <= espera ;
fim <= '0' ;
nSomas <= "000000000" ;
MMC <= "0000000000000000" ;
elsif ( clock'event and clock = '1') then
case estado is
when espera =>
if ( inicia = '1' ) then
fim <= '0' ;
a_auce <= bit_vector ( unsigned ("00000000"&A) ) ; 
b_auce <= bit_vector ( unsigned ("00000000"&B) ) ;
estado <= testa ;
n_Somas <= "000000000" ;
else
estado <= espera ;
end if ;
when testa =>
if (A = "00000000" OR B = "00000000") then
estado <= igual ;
fim <= '1' ;
nSomas <= (others => '0') ;
end if ;
if (a_auce /= b_auce) then
estado <= diferente ;
else
estado <= igual ;
end if ;
when diferente =>
n_Somas <= bit_vector ( unsigned (n_Somas) + 1 ) ;
if ( a_auce > b_auce ) then 
b_auce <= bit_vector ( unsigned (b_auce) + unsigned (B) ) ;
else
a_auce <= bit_vector ( unsigned (a_auce) + unsigned (A) );
end if;
estado <= testa ;
when igual =>
mmc <= a_auce ;
fim <= '1' ;
estado <= espera ;
nSomas <= n_Somas ;
end case ;
end if ;
end process ;
end architecture ;