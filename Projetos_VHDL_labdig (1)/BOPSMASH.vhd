library IEEE;                     -- CODIGO DA UNIDADE DE CONTROLE
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BOPSMASH is
  port ( CLK, BOPITBUTTON : in std_logic;
         PULSO: out std_logic;
         CLK_ENABLE: out std_logic
		 CLEAR: out std_logic;
		 );
		 
end BOPSMASH;






architecture maquina of BOPSMASH is
   type state_type is (ST0,ST1,ST2,ST3);   -- 4 estados de velocidade do game
   signal contagem : bit_vector(2 downto 0); -- fazer a contagem dos clks
   signal PS, NS : state_type;
   
   
   
   
begin 


    sync_proc: process (CLK,NS,RESET)  --PROCESSO PRO RESET DOS ESTADOS
	
	
	begin
	   PS <= ST0;
	   
	   
	if (rising_edge(CLK)) then 
	   PS <= NS;
	end if;
end process sync_proc;


comb_proc: process(PS, BOPITBUTTON, CLK)
  
  begin
    CLEAR <= '1';
    PULSO <= '0';
	CLK_ENABLE <= '1';
	case PS is 
	  when ST0 =>    -- ESTADO 0 , LIMPAR MEMORIA
	    CLEAR <= '1';
	    PULSO <= '0';
		CLK_ENABLE<= '1';
		
	    NS <= ST1;     -- DO ESTADO 0 VAI DIRETO PRO ESTADO 1, PONTO CAMINHANDO
		 
		 
		 
		 
	when ST1 =>      -- apenas um pulso apos o reset
	   PULSO <= '1';
		CLK_ENABLE<= '1';
	   NS <= ST2;
		
	  when ST2 => 
	    PULSO <= '0';
		CLK_ENABLE <= '1';
		if (BOPITBUTTON = '1') then NS <= ST3;
		else NS <= ST2;
		end if;
		
	 when ST3 => 
        PULSO<= '0'	;
		CLK_ENABLE <= '0';
	if (BOPITBUTTON = '1') then NS <= ST0;
	else NS <= ST3;
	end if;
		
	end case;
    end process comb_proc;
    
end maquina;