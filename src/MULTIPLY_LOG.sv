

module MULTIPLY_LOG
#(
parameter width_H = 5,
parameter width_W = 20,
parameter const_num = 2
)
(
input wire clk,
input wire rst,
input wire data_i_en,
input wire [(width_H+width_W-1):0]data_i,
output reg data_o_en,
output reg [(width_H+width_W-1):0]data_o
);

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
    if(const_num>=0)data_o<=(    { {((width_H+width_W-1)){data_i[width_H+width_W-1]}} , {data_i} }    <<const_num);
    else data_o<=(    { {((width_H+width_W-1)){data_i[width_H+width_W-1]}} , {data_i} }    >>((~const_num)+1));
end
end
//endmodule
endmodule
