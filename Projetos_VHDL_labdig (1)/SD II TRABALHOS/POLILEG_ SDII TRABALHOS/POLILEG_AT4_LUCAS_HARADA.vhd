library IEEE;
use IEEE.numeric_bit.all;

entity controlunit is
port (
	reg2loc: out bit;
	uncondBranch: out bit;
	branch: out bit;
	memRead: out bit;
	memToReg: out bit;
	aluOp: out bit_vector(1 downto 0);
	memWrite: out bit;
	aluSrc: out bit;
	regWrite: out bit;
	opcode: in bit_vector(10 downto 0)
);
end entity;
----------------------------------------------------------------------
---!Arquitetura
-------------------------------------------------------------------------


architecture atividade4 of controlunit is
begin

reg2loc <= '0' when (opcode = "11111000010") else 				-- LDUR
		   '1' when (opcode = "11111000000") else 				-- STUR
           '1' when (opcode(10 downto 3) = "10110100") else 	-- CBZ
           '0' when (opcode(10 downto 5) = "000101") else		-- B  
           '0' when (opcode = "10001011000") else				--   R ADD
           '0' when (opcode = "11001011000") else				--   R SUB
           '0' when (opcode = "10001010000") else				--   R AND
           '0' when (opcode = "10101010000");					--   R ORR
		   -----------------------------------------------------------------------------------------
---------------------------------------------------------------
uncondBranch <= '0' when (opcode = "11111000010") else 				-- LDUR
		   		'0' when (opcode = "11111000000") else 				-- STUR
           		'0' when (opcode(10 downto 3) = "10110100") else 	-- CBZ
           		'1' when (opcode(10 downto 5) = "000101") else		-- B  
           		'0' when (opcode = "10001011000") else				--   R ADD
           		'0' when (opcode = "11001011000") else				--   R SUB
           		'0' when (opcode = "10001010000") else				--   R AND
           		'0' when (opcode = "10101010000");					--   R ORR
-------------------------------------------------------------------------------------

----------------------------------------------------------------------------------
memRead <= '1' when (opcode = "11111000010") else 				-- LDUR
		   '0' when (opcode = "11111000000") else 				-- STUR
           '0' when (opcode(10 downto 3) = "10110100") else 	-- CBZ
           '0' when (opcode(10 downto 5) = "000101") else		-- B  
           '0' when (opcode = "10001011000") else				--   R ADD
           '0' when (opcode = "11001011000") else				--   R SUB
           '0' when (opcode = "10001010000") else				--   R AND
           '0' when (opcode = "10101010000");					--   R ORR
		   
		   
		   
		   
		   
branch <= '0' when (opcode = "11111000010") else 			-- LDUR
		  '0' when (opcode = "11111000000") else 			-- STUR
          '1' when (opcode(10 downto 3) = "10110100") else -- CBZ
          '0' when (opcode(10 downto 5) = "000101") else	-- B  
          '0' when (opcode = "10001011000") else			--   R ADD
          '0' when (opcode = "11001011000") else			--   R SUB
          '0' when (opcode = "10001010000") else			--   R AND
          '0' when (opcode = "10101010000");				--   R ORR

---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------
aluOp <= "00" when (opcode = "11111000010") else 			-- LDUR
		 "00" when (opcode = "11111000000") else 			-- STUR
         "01" when (opcode(10 downto 3) = "10110100") else 	-- CBZ
         "01" when (opcode(10 downto 5) = "000101") else	-- B  
         "10" when (opcode = "10001011000") else			--   R ADD
         "10" when (opcode = "11001011000") else			--   R SUB
         "10" when (opcode = "10001010000") else			--   R AND
         "10" when (opcode = "10101010000");				--   R ORR
		 
		 
		 
------------------------------------------------------------------------------------------------------------		 
memToReg <= '1' when (opcode = "11111000010") else 			-- LDUR
		    '1' when (opcode = "11111000000") else 				-- STUR
            '1' when (opcode(10 downto 3) = "10110100") else 	-- CBZ
            '1' when (opcode(10 downto 5) = "000101") else		-- B  
            '0' when (opcode = "10001011000") else				--   R ADD
            '0' when (opcode = "11001011000") else				--   R SUB
            '0' when (opcode = "10001010000") else				--   R AND
            '0' when (opcode = "10101010000");					--   R ORR


		 ---------------------------------------------------------------------------
regWrite <= '1' when (opcode = "11111000010") else 			-- LDUR
		    '0' when (opcode = "11111000000") else 			-- STUR
            '0' when (opcode(10 downto 3) = "10110100") else 	-- CBZ
            '0' when (opcode(10 downto 5) = "000101") else		-- B  
            '1' when (opcode = "10001011000") else				--   R ADD
            '1' when (opcode = "11001011000") else				--   R SUB
            '1' when (opcode = "10001010000") else				--   R AND
            '1' when (opcode = "10101010000");					--   R ORR

---------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
memWrite <= '0' when (opcode = "11111000010") else 			-- LDUR
		    '1' when (opcode = "11111000000") else 			-- STUR
            '0' when (opcode(10 downto 3) = "10110100") else 	-- CBZ
            '0' when (opcode(10 downto 5) = "000101") else		-- B  
            '0' when (opcode = "10001011000") else				--   R ADD
            '0' when (opcode = "11001011000") else				--   R SUB
            '0' when (opcode = "10001010000") else				--   R AND
            '0' when (opcode = "10101010000");					--   R ORR
			----------------------------------------------------------------------
			
			--------------------------------------------------------------------------

aluSrc <= '1' when (opcode = "11111000010") else 			-- LDUR
		  '1' when (opcode = "11111000000") else 			-- STUR
          '0' when (opcode(10 downto 3) = "10110100") else -- CBZ
          '1' when (opcode(10 downto 5) = "000101") else	-- B  
          '0' when (opcode = "10001011000") else			--   R ADD
          '0' when (opcode = "11001011000") else			--   R SUB
          '0' when (opcode = "10001010000") else			--   R AND
          '0' when (opcode = "10101010000");				--   R ORR


end architecture;