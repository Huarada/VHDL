
entity bass_hero_versus is
 port (clk, reset: in bit;
 target: in bit_vector (3 downto 0);
 played: in bit_vector (3 downto 0);
 jam: in bit;
 score: out bit_vector (2 downto 0);
 cheers: out bit );
end entity;


architecture logica of bass_hero_versus is
 
 type state_type is (zero,PO1,PO2,aplauso,NEG1,NEG2);
 signal present_state, next_state, jam_state : state_type;
 signal igual : bit;
 begin 
 
  ESTADOS: process(reset,clk)
  begin
  
  if clk'event and clk ='1' and reset ='1' then
    present_state <= zero;
	
  elsif clk'event and clk ='1' and jam = '1' then
    present_state <=  jam_state;

  elsif clk'event and clk ='1' then 	
    present_state <= next_state ;
	
	end if;
	
  end process ESTADOS;
  
  igual <= '1' when (target = played) else '0' ;
  
  next_state <=  zero when ( present_state = PO1 and igual = '0') or (present_state = NEG1 and igual = '1') else
                 PO1 when ( present_state = PO2 and igual = '0') or (present_state = zero and igual = '1') or (present_state = aplauso and igual = '0') else 
				 PO2 when (present_state = PO1 and igual ='1') else
				 aplauso when (present_state = PO2 and igual = '1') or (present_state = aplauso and igual ='1') else
				 NEG1 when (present_state = zero and igual = '0') or (present_state = NEG2 and igual = '1') else
				 NEG2 when (present_state = NEG1 and igual = '0') or (present_state = NEG2 and igual = '0');
	

  jam_state <= zero when (present_state = PO2 or present_state = aplauso ) else 
               NEG1 when (present_state = PO1) else 
               NEG2 when (present_state = zero or present_state = NEG1);			   
	
  score <= "000" when present_state = zero    else
           "001" when present_state = PO1     else
           "010" when present_state = PO2     else
           "010" when present_state = aplauso else
           "111" when present_state = NEG1    else
           "110" when present_state = NEG2 	;	   

  cheers <= '1' when present_state = aplauso else '0';
  
 end architecture;
  
  
    