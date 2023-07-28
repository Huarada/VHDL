library IEEE;
use IEEE.numeric_bit.all;

entity jokempo is

port ( 
  a: in bit_vector (1 downto 0); --! gesto do jogador A
  b: in bit_vector (1 downto 0); --! gesto do jogador B 
  y: out bit_vector (1 downto 0) --! resultado do jogo
    );
    end jokempo;    
    
architecture regras of jokempo is
    
    signal Av: bit_vector(2 downto 0);    
    signal Bv: bit_vector(2 downto 0);
    signal C : signed (2 downto 0);
    signal Z : bit_vector(1 downto 0);
    signal Csinal : signed(1 downto 0);
   
    
begin
 Av <= ('0' & a);  
 Bv <= ('0' & b);
 
 C <= signed(Av) - signed(Bv); --! tentar ser 01 quando a vence e 10 quando b vence  
 
 Csinal(1)<= '0';
 Csinal(0) <= C(2); --! necessario corrigir por fator 1 quando C da negativo, devido a base usada. 
 

 
 
 Z <= bit_vector( not( C(1 downto 0) - Csinal) ) ; --! not inverte resultados quando Avence, quando Bvence e empate, Mostrando os resultados corretos
 
 
 y <=  "00" when (a = "00" or b = "00" ) else Z ;
 
 


 end regras;




entity jkpn is
port(
reset, clock: in bit;
inicia, carrega: in bit;
nJogos: in bit_vector(3 downto 0);
gestoA, gestoB: in bit_vector(1 downto 0);
zRodada, zMatch: out bit_vector(1 downto 0);
jogosRestantes: out bit_vector(3 downto 0);
placarA, placarB: out bit_vector(3 downto 0)
);
end jkpn;


entity flipflopd IS
  port( 
    D, reset, clock, EN: in  bit;
    Q:                   out bit
  );
end flipflopd;

architecture behavior of flipflopd is
begin
  process (reset, clock)
  begin
    if reset='0' then
      Q <= '0';
    elsif clock'EVENT and clock='1' and EN='1' then
      Q <= D;
    end if;
  end process ;
end behavior; 





architecture programa of jkpn is
 

  signal ztemp : bit_vector (1 downto 0);
  signal placarAincr: bit_vector ( 3 downto 0);
  signal placarBincr: bit_vector ( 3 downto 0);
  signal zMatchcalc: bit_vector (1 downto 0);
  signal nJogosdiv: bit_vector (3 dowwnto 0);
  component jokempo is
      port ( 
         a: in bit_vector (1 downto 0); --! gesto do jogador A
         b: in bit_vector (1 downto 0); --! gesto do jogador B 
         y: out bit_vector (1 downto 0) --! resultado do jogo
         );
      end component;
	  
  begin
  
    PlacarAincr <= bit_vector( unsigned(placarA) + 1 );
	placarBincr <= bit_vector ( unsigned(placarB) + 1); 
	jogosRestantes <= bit_vector( unsigned (nJogos) - 1);
	process (zRodada , clock , reset) 
	begin 
	 if  reset = '0' then 
	    placarA <= "0000" ;
		placarB <= "0000" ;
		
	 elsif 	zRodada = "10" and clock'EVENT and clock='1'  then 
	    placarA <= placarAincr ; 
		
	 elsif zRodada = "01" and clock'EVENT and clock='1'  then	
	 
	    placarB <= placarBincr;
	
     end if;	
	end process;

  	
    
	Xjokem : jokempo port map (gestoA, gestoB, ztemp) ;
	
	XatualJokem: flipflopd port map (ztemp, reset, clock, carrega, zRodada) ;
	
	Xcontagemjogos: flipflopd port map ( jogosRestantes, reset, clock, carrega, nJogos);
	
	nJogosdiv (3) <= '0';
    nJogosdiv (2 downto 0) <= nJogos(3 downto 1);
 	
	zMatchcalc <= "10" when ( placarA > bit_vector( unsigned( placarB) + unsigned (nJogosdiv))) else
                  "01" when ( placarB > bit_vector( unsigned( placarA) + unsigned (nJogosdiv)))	else
				  "00" ;
	
	process (clock,reset)
	begin
     if reset = '0' then
        zMatch = "00";
     elsif clock'event and clock = '1' and zMatchcalc = "10" then
        
        zMatch = "10" ;
     
     elsif clock'event and clock = '1' and zMatchcalc = "01" then	
        

        zMatch = "01" ;
     else 
        zMatch = "00";
     
     end if;
    end process;

    end programa;	
        
        		
	  
	  

 
  
  

 