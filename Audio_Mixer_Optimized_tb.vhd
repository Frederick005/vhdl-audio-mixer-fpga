-- Code your testbench here
library ieee;
library std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity Audio_Mixer_TB is
generic(Channel_width : natural := 15;
		gain_width : natural := 10;
        OPChannel_width : natural := 23);
end entity;
--#################################################################################################################
--#Architecture of Audio Mixer Testbench                                                                          #
--#################################################################################################################
architecture Behavioral of Audio_Mixer_TB is

component Audio_Mixer is
generic(Channel_width : natural := 15;
	gain_width : natural := 10;
        OPChannel_width : natural := 23);
port(serialbit : IN std_logic;
     count : IN unsigned(2 downto 0);
     bitcount : in std_logic;
     --Setting the gain for each ;
     --Setting the gain for each channels
     GainChannelA : IN unsigned(gain_width-1 downto 0);
     GainChannelB : IN unsigned(gain_width-1 downto 0);
     --setting master gain 
     MasterVolumeGain1 : IN unsigned(gain_width-1 downto 0);
     MasterVolumeGain2 : IN unsigned(gain_width-1 downto 0);
     clk : IN std_logic;
     OPChannelA: OUT signed(OPChannel_width downto 0);
     OPChannelB: OUT signed(OPChannel_width downto 0));
end component;

--Serial entry for channels
signal serialbit : std_logic:='0';
--Count
signal count : unsigned(2 downto 0):=(others=>'1');
signal bitcount : std_logic:='0';
--Signal InputFrame : signed(Channel_width-1 downto 0):=(others=>'0');
signal GainChannelA : unsigned(gain_width-1 downto 0):=(others=>'0');
signal GainChannelB : unsigned(gain_width-1 downto 0):=(others=>'0');
--Setting master gain 
signal MasterVolumeGain1 : unsigned(gain_width-1 downto 0):=(others=>'0');
signal MasterVolumeGain2 : unsigned(gain_width-1 downto 0):=(others=>'0');
signal clk : std_logic:='0';
signal OPChannelA: signed(OPChannel_width downto 0);
signal OPChannelB: signed(OPChannel_width downto 0);

--Needed constant values
constant clock_period: time := 20833.33 ns;

begin
--#################################################################################################################
--#Device Under Test                                                                                              #
--#################################################################################################################
dut: Audio_Mixer
generic map( Channel_width=>Channel_width,
			gain_width=>gain_width,
            OPChannel_width=>OPChannel_width)
port map( serialbit=>serialbit,
	  count=>count,
	  bitcount=>bitcount,
	  GainChannelA=>GainChannelA,
          GainChannelB=>GainChannelB,
          MasterVolumeGain1=>MasterVolumeGain1,
          MasterVolumeGain2=>MasterVolumeGain2,
          clk=>clk,
          OPChannelA=>OPChannelA,
          OPChannelB=>OPChannelB);
          
process
begin
clk <= '1';
wait for clock_period/2;
clk<= '0';
wait for clock_period/2;
end process;
--#################################################################################################################
--#1)Defining the file pointer for Read and Write                                                                 #
--#2)Reading data from the file bit by bit in single TDM stream                                                   #
--#3)Writing output data into file.                                                                               #
--#################################################################################################################
stim: process
file file_pointer: text;
file file_pointer_write: text;
variable line_content: std_logic;
variable line_content_write: std_logic_vector(23 downto 0);
variable Line_number: line;
variable Line_number_write: line;
variable j: integer:=0;
variable part_one:std_logic;
variable combined:std_logic_vector(63 downto 0);
begin
file_open(file_pointer,"LatestOutputwav2bin.txt",READ_MODE);
file_open(file_pointer_write,"Vhdl_OutputFile_final.txt",Write_mode);
while not endfile(file_pointer) loop
readline (file_pointer,Line_number);
read(Line_number,line_content);
part_one:= line_content;
serialbit<= part_one;
bitcount<= not bitcount;
if j=16 then
count<="000";
GainChannelA<="0001100101";
GainChannelB<="0000010001";

elsif j=32 then
GainChannelA<="0000010001";
GainChannelB<="0001100101";
count<="001";

elsif j=48 then
count<="010";
GainChannelA<="0010110011";
GainChannelB<="0001100101";

elsif j=64 then
count<="011";
GainChannelA<="0001100101";
GainChannelB<="0010110011";
MasterVolumeGain1<="0001100101";
MasterVolumeGain2<="0001100101";
j:=0;
line_content_write:=std_logic_vector(OPChannelA);
write(Line_number_write, line_content_write);
writeline(file_pointer_write,Line_number_write);
line_content_write:=std_logic_vector(OPChannelB);
write(Line_number_write, line_content_write);
writeline(file_pointer_write,Line_number_write);


end if;
j:=j+1;
wait for 325.52078125 ns;
end loop;
file_close(file_pointer); 
file_close(file_pointer_write);
wait;
end process;
end architecture;

