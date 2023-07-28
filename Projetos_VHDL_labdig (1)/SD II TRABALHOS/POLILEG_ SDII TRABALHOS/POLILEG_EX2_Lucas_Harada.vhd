library IEEE;
use IEEE.numeric_bit.all;



-------------------------------------------------------------------------------------





entity fulladder is
	port (
    	  a, b, cin: in bit;
          s, cout: out bit
    );
end entity;

architecture structural of fulladder is
signal axorb: bit;

begin
  	axorb <= a XOVar b;
  	s <= axorb XOVar cin;
  	cout <= (axorb AND cin) or (a AND b);

end architecture;
-----------------------------------------------------------------------


entity alu1bit is
	port (
    	  a, b, less, cin: in bit;
          result, cout, set, overflow: out bit;
          ainvert, binvert: in bit;
          operation: in bit_vector(1 downto 0)
    );
end entity;

---------------------------------------------------------------------

architecture algoritmo of alu1bit is


component fulladder is
	port (
    	  a, b, cin: in bit;
          s, cout: out bit
    );
end component;



signal atemp, btemp, andmemoria, ormemoria, soma, contador: bit;

begin




atemp <= a when (ainvert = '0') else (not a);
btemp <= b when (binvert = '0') else (not b);

andmemoria <= (atemp AND btemp);
ormemoria <= (atemp OVar btemp);
ADD: fulladder port map (atemp, btemp, cin, soma, contador);

result <= andmemoria when (operation = "00") else  ormemoria  when (operation = "01") else  soma when (operation = "10") else     less	 when (operation = "11");	

cout <= contador;
set  <= soma;
overflow <= cin XOVar contador; 
          
end architecture;
--------------------------------------------------------------------------
--------------------------------------------------------------------------
library IEEE;
use IEEE.numeric_bit.all;

entity alu is
  	generic (
    	size : natural := 64
  	);
  	port (
    	A, B : in  bit_vector(size-1 downto 0); 
    	F    : out bit_vector(size-1 downto 0); 
    	S    : in  bit_vector(3 downto 0); 
    	Z    : out bit; 
    	Ov   : out bit;
    	Co   : out bit 
    );
end entity alu; 
-------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------------
architecture structural of alu is
    component alu1bit is
    	port (
      		a, b, less, cin: in bit;
      		result, cout, set, overflow: out bit;
      		ainvert, binvert: in bit;
      		operation: bit_vector(1 downto 0)
    	);
  	end component;
  	signal Var,carry : bit_vector(size-1 downto 0);
  	signal setter: bit;

begin
  	alus: for i in size-1 downto 0 generate
	----------------------------------------------------------------------------------------------------------------
	
	
	--!Generate--
	---------------------------------------------------------------------------------------------------------------------

    	msb: if i=(size-1) generate
    		alumsb: alu1bit port map(A(i), B(i), '0', Couts(i-1), Var(i), carry(i), setter, Ov, S(3), S(2), S(1 downto 0));
    	end generate;
		    	lsb: if i=0 generate
    		alulsb: alu1bit port map(A(i), B(i), setter, S(2), Var(i), carry(i), open, open, S(3), S(2), S(1 downto 0));
    	end generate;
    	oth: if i>0 and i<(size-1) generate
    		aluoth: alu1bit port map(A(i), B(i), '0', Couts(i-1), Var(i), carry(i), open, open, S(3), S(2), S(1 downto 0));
    	end generate;
  	end generate;
         
F <= Var;
Co <= Couts(size-1);
Z <= '1' when (unsigned(Var) = 0) else '0';

end architecture;