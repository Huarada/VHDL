library IEEE;
use IEEE.numeric_bit.all;
-------------------------------------------------------------------------------------------------
--! Codigo
-------------------------------------------------------------------------------------------------
entity alu is 
  generic(
      size : natural :=10
	  );
   port(
       A,B : in  bit_vector(size-1 downto 0);
	   F   : out bit_vector(size-1 downto 0);
	   S   : in bit_vector(3 downto 0);
	   Z   : out bit;
	   Ov  : out bit;
	   Co  : out bit
	   );
end entity alu;	   
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
architecture algoritmo2 of alu is
signal lesstemp,cintemp : bit;
signal ztemp,overflow,cout, less,setemp,ftemp,F2,unitario: bit_vector(size-1 downto 0);
 
component alu1bit is 
  port(
      a, b, less, cin             : in bit;
	  result, cout, set, overflow : out bit;
      ainvert, binvert             : in bit;
	  operation                    : in bit_vector(1 downto 0)
    );
end component;	
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
 begin  
  
    ula : for i in size-1 downto 0 generate
        onebit: if i=0 generate
x:	         alu1bit port  map(A(i),B(i),setemp(size-1),'0',ftemp(i),cout(i),setemp(i),overflow(i),S(3),S(2),S(1 downto 0));



	    end generate;
		
		anybit: if i>0 and i<(size-1)  generate	 
		
		
y:	         alu1bit port  map(A(i),B(i),'0',cout(i-1),ftemp(i),cout(i),setemp(i),overflow(i),S(3),S(2),S(1 downto 0));


        end generate;
		finalbit: if i=size-1 generate
		
	 w:        alu1bit port  map(A(i),B(i),'0',cout(i-1),ftemp(i),Co,setemp(i),Ov,S(3),S(2),S(1 downto 0));
        end generate;
	end generate ula;
  
	Zero : for i in size-1 downto 0 generate
	
	
        Z0 :if i=0 generate
	        ztemp(i)<=F2(i);
		end generate;	
		
	    Zn: if i>0 generate
	        ztemp(i)<= F2(i) or ztemp(i-1);
	    end generate;
		
	end generate Zero;
	Z<=not ztemp(size-1);
  
  unitario(0)<=('1');
  
 unitario(size-1 downto 1)<=(others =>'0');
  
  
  
	 F2<= bit_vector(unsigned(ftemp)+unsigned(unitario)) when ((S(1 downto 0)="10") and  (S(3)='1' or S(2)='1')) else
         ftemp ; 
         F<=F2;
end algoritmo2;