

//module //when N=X there will be X+1 const for calculation
//FIR滤波器 //当N=X有X+1计算节点
module FIR_DISRST
#(
parameter width_H = 5,
parameter width_W = 20,
parameter N = 32,
parameter log_N = 5,
//data of FIR //fixed-point number 4bit in int and 16 bit in decimal
//FIR数据 //定点数，整数4bit小数16bit
parameter [(width_H+width_W-1):0]const_num[0:N]=
{1082,1223,1362,1501,1635,1766,1890,2007,
2116,2214,2302,2378,2442,2492,2528,2550,
2558,2550,2528,2492,2442,2378,2302,2214,
2116,2007,1890,1766,1635,1501,1362,1223,
1082}
)
(
input wire clk,
input wire data_i_en,
input wire [(width_H+width_W-1):0]data_i,
output reg data_o_en,
output reg [(width_H+width_W-1):0]data_o
);

//num used in "for" //no meaning
//用于"for"结构 //无意义
int a,b,c;
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

//pipeline reg
//流水线寄存器
reg pipe_en[0:N];
reg [(width_H+width_W-1):0]pipe[0:N];
reg pipe_result_en[0:(log_N-1)];
reg [(width_H+width_W-1):0]pipe_result[0:(log_N-1)][0:N];

//pipeline run
//运行流水线
always@(posedge clk)begin
if (data_i_en==1) begin
    pipe_en[0]<=data_i_en;
    pipe[0]<=data_i;

    for (a=0;a<(N);a=a+1) begin
        pipe_en[a+1]<=pipe_en[a];
        pipe[a+1]<=pipe[a];
        pipe_result[0][a]<=mul(pipe[a],const_num[a]);
    end
    pipe_result_en[0]<=pipe_en[N];
    pipe_result[0][N]<=mul(pipe[N],const_num[N]);

    for (b=0;b<(log_N);b=b+1) begin
        pipe_result_en[b+1]<=pipe_result_en[b];
        for (a=0;a<(N/2);a=a+1) begin
            pipe_result[b+1][a]<=pipe_result[b][2*a]+pipe_result[b][2*a+1];
        end
        pipe_result[b+1][N]<=pipe_result[b][N];
    end
    data_o_en<=pipe_result_en[(log_N-1)];
    data_o<=pipe_result[(log_N-1)][0]+pipe_result[(log_N-1)][1]+pipe_result[(log_N-1)][N];
end
end
//endmodule
endmodule
