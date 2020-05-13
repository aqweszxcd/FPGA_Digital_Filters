

//module //when N=X there will be X const for calculation
//均值滤波 //当N=X有X计算节点
module MEAN_DISRST
#(
parameter width_H = 5,
parameter width_W = 20,
parameter N = 32,
parameter log_N = 5
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

//pipeline reg
//流水线寄存器
reg pipe_en[0:N];
reg [(width_H+width_W-1):0]pipe[0:N];
reg [(width_H+width_W-1):0]pipe_result_en[0:(log_N-1)];
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
        pipe_result[0][a]<=( { { log_N{pipe[a][(width_H+width_W-1)]} },{pipe[a]} } >>log_N );//MEAN 除法
    end
    pipe_result_en[0]<=pipe_en[N];
    pipe_result[0][N]<=(pipe[N]>>log_N);//MEAN 除法
    
    for (b=0;b<(log_N);b=b+1) begin
        pipe_result_en[b+1]<=pipe_result_en[b];
        for (a=0;a<(N/2);a=a+1) begin
            pipe_result[b+1][a]<=pipe_result[b][2*a]+pipe_result[b][2*a+1];
        end
    end
    data_o_en<=pipe_result_en[(log_N-1)];
    data_o<=pipe_result[(log_N-1)][0]+pipe_result[(log_N-1)][1];
end
end
//endmodule
endmodule
