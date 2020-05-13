

//module //when N=X there will be 2X const for calculation
//IIR //当N=X有(2X计算节点
module IIR_DISRST
#(
parameter width_H = 15,
parameter width_W = 10,
parameter N = 8,
parameter [(width_H+width_W-1):0]const_num_SOS[0:(3*(N/2)-1)] = ({//you might use //你可能会用到 //SOS=round(SOS*(2^width_W));
2543,-13578,54303,
23920,762,35031,
69243,20824,18356,
121461,36581,7356
}),
parameter [(width_H+width_W-1):0]const_num_G[0:(N/2-1)] = ({//you might use //你可能会用到 //G=round(G*(2^width_W));
28745,
22997,
12516,
1985
})
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
reg pipe_en[0:(N/2-1)][0:2];
reg [(width_H+width_W-1):0] pipe[0:(N/2-1)][0:2];
reg [(width_H+width_W-1):0] delay[0:(N/2-1)][0:1];

//pipeline run
//运行流水线
always@(posedge clk)begin
if (data_i_en==1) begin
    //RUN pipeline_delay
    for (a=0;a<(N/2);a=a+1) begin
        delay[a][0]<=pipe[a][1];
        delay[a][1]<=delay[a][0];
    end
    //input & MUL G
    pipe_en[0][0]<=data_i_en;
    pipe[0][0]<=mul(data_i,const_num_G[0]);
    for (a=1;a<(N/2);a=a+1) begin
        pipe_en[a][0]<=pipe_en[a-1][2];
        pipe[a][0]<=mul(pipe[a-1][2],const_num_G[a]);
    end
    //MUL A
    for (a=0;a<(N/2);a=a+1) begin
        pipe_en[a][1]<=pipe_en[a][0];
        pipe[a][1]<=mul(delay[a][0],const_num_SOS[3*a+1])+mul(delay[a][1],const_num_SOS[3*a+2])+pipe[a][0];
    end
    //MUL B
    for (a=0;a<(N/2);a=a+1) begin
        pipe_en[a][2]<=pipe_en[a][1];
        pipe[a][2]<=mul(delay[a][0],const_num_SOS[3*a+0])+delay[a][1]+pipe[a][1];
    end
    //output
    data_o_en<=pipe_en[N/2-1][2];
    data_o<=pipe[N/2-1][2];
end
end
//endmodule
endmodule
