library IEEE;
use IEEE.numeric_bit.all;
use std.textio.all;

entity rom_arquivo_generica is
	generic(
    	addressSize : natural := 5;
        wordSize    : natural := 8;
        datFileName : string  := "conteudo_rom_ativ_02_carga.dat"
    );
    port(
    	addr : in  bit_vector(addressSize-1 downto 0);
        data : out bit_vector(wordSize-1 downto 0)
    );
end rom_arquivo_generica;

---------------------------------------------------------------------
architecture algoritmo3 of rom_arquivo_generica is
constant quantity: natural := 2**addressSize;
type memtype is array (0 to quantity-1) of bit_vector(wordSize-1 downto 0);

---------------------------------------------------------------------
impure function init_mem(nome_arquivo: in string) return memtype is
	file arq: 			text open read_mode is nome_arquivo;
    variable linha: 	line;
  	variable temp_bitv: bit_vector(wordSize-1 downto 0);
  	variable temp_mem:  memtype;
  	begin
    	for i in memtype'range loop
      		readline(arq, linha);
      		read(linha, temp_bitv);
     		temp_mem(i) := temp_bitv;
    	end loop;
    	return temp_mem;
  	end;
---------------------------------------------------------------------
constant mem : memtype := init_mem(datFileName);

---------------------------------------------------------------------
begin
  data <= mem(to_integer(unsigned(addr)));

end algortmo3;