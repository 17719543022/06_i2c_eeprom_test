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
    input                   sys_clk,        //system clock 50Mhz on board
    input                   rst_n,          //reset ,low active
    input                   key1,           //user key on board
    inout                   i2c_sda,        // i2c data
    inout                   i2c_scl,        // i2c clock
    output reg [3:0]        led             //user leds on board
    );

parameter				TWENTY_SECOND_CLOCKS = 1000000;
reg						key1_1d;
reg						key1_2d;
wire					key1_xor;
wire					key1_posedge;
wire					key1_negedge;
reg [31:0]				counter;
reg [31:0]				counter_1d;

//===========================================================================
// 
//===========================================================================
assign key1_xor = key1_1d ^ key1_2d;
assign key1_negedge = (counter == TWENTY_SECOND_CLOCKS - 1) & (counter_1d == TWENTY_SECOND_CLOCKS) & (key1_1d == 1'b0);
assign key1_posedge = (counter == TWENTY_SECOND_CLOCKS - 1) & (counter_1d == TWENTY_SECOND_CLOCKS) & (key1_1d == 1'b1);

always@(posedge key1_posedge or negedge rst_n)
begin
	if (rst_n == 1'b0)
		led <= 4'b0000;
	else
		led <= ~(~led + 4'b1);
end

always@(posedge sys_clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
	begin
		key1_1d <= 1'b1;
		key1_2d <= 1'b1;
	end
	else
	begin
		key1_1d <= key1;
		key1_2d <= key1_1d;
	end
end

always@(key1_xor, counter)
begin
	if (key1_xor == 1'b1)
		counter_1d <= 32'h00000000;
	else if (counter < TWENTY_SECOND_CLOCKS)
		counter_1d <= counter + 1'b1;
	else
		counter_1d <= counter;
end

always@(posedge sys_clk or negedge rst_n)
begin
	if (rst_n == 1'b0)
	begin
		counter <= 32'h00000000;
	end
	else
	begin
		counter <= counter_1d;
	end
end

//===========================================================================
// 
//===========================================================================



//===========================================================================
// 
//===========================================================================



endmodule
