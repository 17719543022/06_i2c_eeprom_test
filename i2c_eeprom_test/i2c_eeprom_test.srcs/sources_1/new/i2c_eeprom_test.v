`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/09 13:47:36
// Design Name: 
// Module Name: i2c_eeprom_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module i2c_eeprom_test(
    input            sys_clk,       //system clock 50Mhz on board
    input            rst_n,         //reset ,low active
    input            key1,          //user key on board
    inout            i2c_sda,       // i2c data
    inout            i2c_scl,       // i2c clock
    output [3:0]     led            //user leds on board
    );
    
//===========================================================================
// PORT declarations
//===========================================================================

//define the time counter
reg [31:0]   timer;                  
reg [3:0]    led;

          
//===========================================================================
// cycle counter:from 0 to 4 sec
//===========================================================================
  always @(posedge sys_clk or negedge rst_n)    
    begin
      if (~rst_n)                           
          timer <= 32'd0;                     // when the reset signal valid,time counter clearing
      else if (timer == 32'd199_999_999)    //4 seconds count(50M*4-1=199999999)
          timer <= 32'd0;                       //count done,clearing the time counter
      else
		    timer <= timer + 1'b1;            //timer counter = timer counter + 1
    end

//===========================================================================
// LED control
//===========================================================================
  always @(posedge sys_clk or negedge rst_n)   
    begin
      if (~rst_n)                      
          led <= 4'b0000;                  //when the reset signal active         
      else if (timer == 32'd49_999_999)    //time counter count to 1st sec,LED1 lighten
    
          led <= 4'b0001;                 
      else if (timer == 32'd99_999_999)    //time counter count to 2nd sec,LED2 lighten
      begin
          led <= 4'b0010;                  
        end
      else if (timer == 32'd149_999_999)   //time counter count to 3nd sec,LED3 lighten
          led <= 4'b0100;                                          
      else if (timer == 32'd199_999_999)   //time counter count to 4nd sec,LED4 lighten
          led <= 4'b1000;                         
    end

endmodule
