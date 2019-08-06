library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counterWithSaturation is 
    generic (DATA_WIDTH : INTEGER := 32;
             KEEP_WIDTH : INTEGER := 4);
    port (
    clk, counterEnable : in std_logic;
    MAX_WORDS : in integer;
    tData : out std_logic_vector(DATA_WIDTH-1 downto 0);
    tKeep : out std_logic_vector(KEEP_WIDTH-1 downto 0);
    tLast, tValid : out std_logic;
    tReady : in std_logic);   
end counterWithSaturation;

architecture behavioral of counterWithSaturation is
    signal countVal, dataVal : integer;    
begin
    counter : process(clk, counterEnable, tReady)
    begin
        if rising_edge(clk) then
            if counterEnable='0' then 
                countVal <= 0;
                dataVal <= 0;
                tValid <= '0';
                tLast <= '0';
            else
                if tReady='1' then
                    tValid <= '1';
                    if countVal < MAX_WORDS then  
                        tLast <= '0';          
                        countVal <= countVal + 1;
                        dataVal <= 2*countVal + 1;
                    else
                        countVal <= MAX_WORDS;
                        tLast <= '1';
                    end if;
                else
                    tValid <= '0';                    
                end if;
            end if;
        end if;
    end process counter;
    tData <= std_logic_vector(to_unsigned(dataVal,DATA_WIDTH));
    tKeep <= X"F";
end behavioral;

