

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tap is
port(TMS : in std_logic;
     TCK : in std_logic;
     update_IR, shift_IR, capture_IR, update_DR, shift_DR, capture_DR : out std_logic 
);
end tap;


architecture Behavioral of tap is
type state is (
testLogicReset,
runTestIdle,

--------------
selectDR,
captureDR,
shiftDR,
exit1DR,
pauseDR,
exit2DR,
updateDR,

--------------
selectIRscan,
captureIR,
shiftIR,
exit1IR,
pauseIR,
exit2IR,
updateIR

);

signal prest, nxtst : state;

 


begin

--State register--
process(TMS, TCK)
    begin
        if(TMS = '0') then
            prest <= runTestIdle; -- Starting state
       
        elsif(rising_edge(TCK)) then
            prest <= nxtst;
        end if;
    
end process;

--Next State logic -- 
process(TMS, prest)
    begin
        nxtst <= prest;
        
        case prest is
        
            -- INPUT MAP--
            when testLogicReset =>
                if (TMS = '0') then
                    nxtst <= runTestIdle;
                end if;
                
           when runTestIdle =>
                if (TMS = '1') then
                    nxtst <= selectDR;
                end if;
          
          --DATA REGISTER--
          when selectDR =>
                if (TMS = '1') then
                    nxtst <= selectIRscan;
                else
                    nxtst <= captureDR;
                end if;
                
         when captureDR =>
                if (TMS = '1') then
                    nxtst <= exit1DR;
                else
                    nxtst <= shiftDR;
                end if;
                
         when shiftDR =>
                if (TMS = '1') then
                    nxtst <= exit1DR;
                end if;
                
         when exit1DR =>
                if (TMS = '0') then
                    nxtst <= pauseDR;
                else
                    nxtst <= updateDR;
                end if;
                
         when pauseDR =>
                if (TMS = '1') then
                    nxtst <= exit2DR;
             
                end if;
         
         when exit2DR =>
                if (TMS = '1') then
                    nxtst <= updateDR;
                else
                    nxtst <= shiftDR;
                end if;
                
         when updateDR =>
                if (TMS = '1') then
                    nxtst <= selectDR;
                else
                    nxtst <= runTestIdle;
                end if;
          
          --INSTRUCTION REGISTER-- 
          when selectIRscan =>
                if (TMS = '0') then
                    nxtst <= captureIR;
                else
                    nxtst <= testLogicReset;
                end if;
                
          when captureIR =>
                if (TMS = '0') then
                    nxtst <= shiftIR;
                else
                    nxtst <= exit1IR;
                end if;
                
           when shiftIR =>
                if (TMS = '1') then
                    nxtst <= exit1IR;
                end if;
                
           when exit1IR =>
                if (TMS = '0') then
                    nxtst <= pauseIR;
                else
                    nxtst <= updateIR;
                end if;
                
          when pauseIR =>
                if (TMS = '1') then
                    nxtst <= exit2IR;
                end if;
          
          when exit2IR =>
                if (TMS = '1') then
                    nxtst <= updateIR;
                    
                else
                    nxtst <= shiftIR;
                end if;
                
           when updateIR =>
                if (TMS = '1') then
                    nxtst <= selectDR;
                    
                else
                    nxtst <= runTestIdle;
                end if;

        end case;
    
end process;


process(TMS, TCK)
begin
    case prest is
        when testLogicReset =>
            --SET BS CELLS TO TRANSPARENT MODE--
            update_IR <= '0';
            shift_IR <= '1'; --BYPASS INSTRUCTION IS LOADED "1111"
            capture_IR <= '0';
            
            update_DR <= '0';
            shift_DR <= '0';
            capture_DR <= '0';
        
        when runTestIdle =>
            --SET BS CELLS TO TRANSPARENT MODE--
            update_IR <= '0';
            shift_IR <= '0';
            capture_IR <= '0';
            
            update_DR <= '0';
            shift_DR <= '0';
            capture_DR <= '0';
        
        when selectDR  =>
            --SET BS CELLS TO TRANSPARENT MODE--
            update_IR <= '0';
            shift_IR <= '0';
            capture_IR <= '0';
            
            update_DR <= '0';
            shift_DR <= '0';
            capture_DR <= '0';
            
        when captureDR  =>
            --TRANSPARENT MODE--
            capture_DR <= '1';
         
         when shiftDR  =>
           --TRANSPARENT MODE--
           shift_DR <= '1';
           capture_DR <= '0';    

         when exit1DR => 
         
         when pauseDR =>
         
         when exit2DR =>
         
         when updateDR =>
            -- INSTRUCTION IS SEEN BY THE INFRASTRUCTURE--
            update_DR <= '1';
            
            
         when captureIR  =>
            --SET BS CELLS TO TRANSPARENT MODE--
            capture_IR <= '1';
        
        when shiftIR  =>
           --SET BS CELLS TO TRANSPARENT MODE--
           shift_IR <= '1';
           capture_IR <= '0';    
       
        when exit1IR =>
        
        when pauseIR =>
        
        when exit2IR =>
        
        when updateIR =>
            update_IR <= '1';
               
          
   end case;
        
end process;


end Behavioral;
