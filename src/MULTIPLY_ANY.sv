

module MULTIPLY_ANY
#(
parameter width_H = 5,
parameter width_W = 20,
parameter const_num = 6553
)
(
input wire clk,
input wire rst,
input wire data_i_en,
input wire [(width_H+width_W-1):0]data_i,
output reg data_o_en,
output reg [(width_H+width_W-1):0]data_o
);

//function mul
//乘法函数
function [(width_H+width_W-1):0]mul;
input wire[(width_H+width_W-1):0]mul_a;
input wire[(width_H+width_W-1):0]mul_b;
reg[(width_H*2+width_W*2-1):0]mul_0;
begin
mul_0=($signed(mul_a)*$signed(mul_b));
mul=(    { { width_W { mul_0[(width_H*2+width_W*2-1)]} },{mul_0} }    >>width_W );
end
endfunction

//pipeline run
//运行流水线
always@(posedge clk)begin
if (rst==1) begin
    data_o_en<=0;
    data_o<=0;
end
else if (data_i_en==1) begin
    //output
    data_o_en<=data_i_en;
    data_o<=mul(data_i,const_num);
end
end
//endmodule
endmodule
