library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
use STD.textio.all;
--##############################################################################################################
--#Entity Declaration for Audio Mixer                                                                          #
--#Port Declarations                                                                                           #
--##############################################################################################################
entity Audio_Mixer is
generic(Channel_width : natural := 15;
	gain_width : natural := 10;
        OPChannel_width : natural := 23);
	port(serialbit : IN std_logic;
	count : IN unsigned(2 downto 0);
	bitcount : in std_logic;

	--Setting the gain for each channels
        GainChannelA : IN unsigned(gain_width-1 downto 0);
        GainChannelB : IN unsigned(gain_width-1 downto 0);
 
        --setting master gain 
        MasterVolumeGain1 : IN unsigned(gain_width-1 downto 0);
        MasterVolumeGain2 : IN unsigned(gain_width-1 downto 0);
        clk : IN std_logic;

	--Output channel
        OPChannelA: OUT signed(OPChannel_width downto 0);
        OPChannelB: OUT signed(OPChannel_width downto 0));
    end Audio_Mixer;

--#################################################################################################################
--#Architecture of Audio Mixer                                                                                    #
--#################################################################################################################

architecture behavioral of Audio_Mixer is

signal channel_inter : std_logic_vector(Channel_width downto 0):= (others=>'0');
signal channel1: signed(Channel_width downto 0);

--Control signals
signal channel_control : std_logic := '0';
signal Calculation_control :std_logic :='0';

--Signals for first channel and gain multiplication
signal Channel1gainA : signed(26 downto 0);
signal Channel2gainA : signed(26 downto 0);
signal Channel3gainA : signed(26 downto 0);
signal Channel4gainA : signed(26 downto 0);
signal Channel1gainB : signed(26 downto 0);
signal Channel2gainB : signed(26 downto 0);
signal Channel3gainB : signed(26 downto 0);
signal Channel4gainB : signed(26 downto 0);

--signal for storing value after channel addition
signal AddChannelA : signed(28 downto 0);
signal AddChannelB : signed(28 downto 0);

--Truncating Signal
signal Inter_trunc_chA : signed(Channel_width downto 0);
signal Inter_trunc_chB : signed(Channel_width downto 0);

--Truncated storing mater volume
signal ChannelAMV : signed(26 downto 0);
signal ChannelBMV : signed(26 downto 0);

--function to multiply gain
function gainmultiply(channel : signed(15 downto 0);
			gain: unsigned(gain_width-1 downto 0)) return signed is
                      variable ChannelGain : signed(26 downto 0) :=(others=>'0');
                      variable intermediate_gain : unsigned (10 downto 0) :=(others=>'0');
                      begin
                      intermediate_gain(9 downto 0):= gain;
                      ChannelGain:=channel*signed(intermediate_gain);
                      return ChannelGain;
                      end function;
                      
begin

--#################################################################################################################
--#Obtaining a 16 bit channel from the input file                                                                 #
--#################################################################################################################

process(bitcount)
begin
channel_inter<= channel_inter(14 downto 0) & serialbit;
end process;

--Receiving the channels one at a time.
process(count)
begin
channel1 <= signed(channel_inter);
channel_control<= not channel_control;
end process;

--#################################################################################################################
--#Multiplying the individual chaneels with respective gains based on the channel received                        #
--#################################################################################################################
process(channel_control)
begin
if count = "000" then
Channel1gainA<= gainmultiply(channel1,GainChannelA);
Channel1gainB<= gainmultiply(channel1,GainChannelB);
end if;
end process;

process(channel_control)
begin
if count = "001" then
Channel2gainA<= gainmultiply(channel1,GainChannelA);
Channel2gainB<= gainmultiply(channel1,GainChannelB);
end if;
end process;

process(channel_control)
begin
if count = "010" then
Channel3gainA<= gainmultiply(channel1,GainChannelA);
Channel3gainB<= gainmultiply(channel1,GainChannelB);
end if;
end process;

process(channel_control)
begin
if count = "011" then
Channel4gainA<= gainmultiply(channel1,GainChannelA);
Channel4gainB<= gainmultiply(channel1,GainChannelB);
Calculation_control <= not Calculation_control;
end if;
end process;


--#################################################################################################################
--#1)Adding the product of the gain and channels to get 2 different channels                                      #
--#2)Multiplying the new channels with Master Volume                                                              #
--#3)Truncating extra bits                                                                                        #
--#################################################################################################################
process(Calculation_control)
begin

--Adding the multiplication of the channels with the gains
AddChannelA<= ("00"&Channel1gainA) + ("00"&Channel2gainA) + ("00"&Channel3gainA) + ("00"&Channel4gainA);
AddChannelB<= ("00"&Channel1gainB) + ("00"&Channel2gainB) + ("00"&Channel3gainB) + ("00"&Channel4gainB);

--Intermediate truncation
Inter_trunc_chA <= AddChannelA(28 downto 13);
Inter_trunc_chB <= AddChannelB(28 downto 13);

--with truncation
ChannelAMV<= gainmultiply(Inter_trunc_chA,MasterVolumeGain1);
ChannelBMV<= gainmultiply(Inter_trunc_chB,MasterVolumeGain2);

--output with truncation
OPChannelA<= ChannelAMV(26 downto 3);
OPChannelB<= ChannelBMV(26 downto 3);

end process;

end behavioral;

