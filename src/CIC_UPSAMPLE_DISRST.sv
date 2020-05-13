

module CIC_UPSAMPLE_DISRST
#(
parameter width_H = 5,
parameter width_W = 20,
parameter N = 32
)
(
input wire clk_divide,
input wire clk,
input wire data_i_en,
input wire [(width_H+width_W-1):0]data_i,
output reg data_o_en,
output reg [(width_H+width_W-1):0]data_o
);

//num used in "for" //no meaning
//用于"for"结构 //无意义
int a,b,c;

//pipeline reg
//流水线寄存器
reg pipe_en[0:2];
reg [(width_H+width_W-1):0]pipe[0:2];
reg [(width_H+width_W-1):0]delay_head[0:(N-1)];
reg [(width_H+width_W-1):0]delay_tail;

//pipeline run
//运行流水线
always@(posedge clk)begin
if (data_i_en==1) begin
    //input
    pipe_en[0]<=data_i_en;
    pipe[0]<=data_i;

    //delay head
    delay_head[0]<=pipe[0];
    for (a=1;a<(N);a=a+1) begin
        delay_head[a]<=delay_head[a-1];
    end
    //add head
    pipe_en[1]<=pipe_en[0];
    pipe[1]<=pipe[0]-delay_head[N-1];

    //add tail
    pipe_en[2]<=pipe_en[1];
    pipe[2]<=pipe[1]+delay_tail;
    //delay tail
    delay_tail<=pipe[2];
    
    //output
    data_o_en<=pipe_en[2];
    data_o<=pipe[2];
end
end
//endmodule
endmodule
