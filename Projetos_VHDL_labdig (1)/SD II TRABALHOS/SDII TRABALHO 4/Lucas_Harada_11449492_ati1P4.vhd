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
  	axorb <= a XOR b;
  	s <= axorb XOR cin;
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
ormemoria <= (atemp OR btemp);
ADD: fulladder port map (atemp, btemp, cin, soma, contador);

result <= andmemoria when (operation = "00") else  ormemoria  when (operation = "01") else  soma when (operation = "10") else     less	 when (operation = "11");	

cout <= contador;
set  <= soma;
overflow <= cin XOR contador; 
          
end architecture;

