

////////////////////////////////说明书synopsis////////////////////////////////
////////////////结构structure////////////////
//所有"被调用模块"都采用"全流水线"结构,延迟固定，一般延迟为"N+log_2_N"量级，可任意串联;
//所有"clk"和所有"rst"都由"调用模块"提供，其中"rst"信号可以不提供，可直接冲刷流水线，可以节省部分资源;
//第一级的"data_i_en"和第一级"data_i"由"调用模块"提供;
//所有除了第一级的"data_i_en"和第一级"data_i"都由上一级的"data_o_en"和"data_o"提供;
//最后一级的"data_o_en"和"data_o"将返回数据和使能信号;
// All "called modules" adopt the "full pipeline" structure, the delay is fixed, the delay is generally of the order of "N + log_2_N", and can be arbitrarily connected in series;
// All "clk" and all "rst" are provided by the "calling module", where the "rst" signal may not be provided, and the pipeline can be directly flushed, which can save some resources;
// The first level "data_i_en" and the first level "data_i" are provided by the "calling module";
// All except the first level "data_i_en" and the first level "data_i" are provided by the upper level "data_o_en" and "data_o";
// The last level of "data_o_en" and "data_o" will return data and enable signals;
////////////////功能function////////////////
//可自定义"定点数"的"小数点以上"和"小数点以下"的计算精度;
//如果想要乘法计算核心只占用FPGA的1个DSP，需要精度"width_H"和"width_W"相加小于等于25bit;
//本文件内自带测试数据，便于测试;
// The calculation accuracy of "above decimal point" and "below decimal point" of "fixed point number" can be customized;
// If you want the multiplication calculation core to occupy only one DSP of the FPGA, the precision "width_H" add "width_W" needs to be 25 bits or less;
// This file comes with test data for easy testing;
////////////////数据about_data////////////////
//从matlab文件取得;
//常数是matlab数据*2^width_W取整;
//matlab取整命令; //%Num=round(Num*(2^width_W));
//access from matlab;
//const_num needs to be int of "matlab_data(float)*2^16";
//matlab rounding command; //%Num=round(Num*(2^width_W));
////////////////资源消耗resources////////////////
//
//    NAME                    width_H    width_W    N    LUT    FF    DSP        Synthesis Run Strategy
//
//    FIR                     5          20         32   790    792   33(N+1)    Vivado Synthesis Defaults
//    FIR                     5          20         32   790    792   33(N+1)    Flow_AreaOptimized_high
//    FIR                     5          20         32   788    1600  33(N+1)    Flow_PerfOptimized_high
//    FIR_DISRST              5          20         32   810    849   33(N+1)    Vivado Synthesis Defaults
//    FIR_DISRST              5          20         32   810    849   33(N+1)    Flow_AreaOptimized_high
//    FIR_DISRST              5          20         32   775    1739  33(N+1)    Flow_PerfOptimized_high
//
//    IIR                     15         10         8    200    363   16(2N)     Vivado Synthesis Defaults
//    IIR                     15         10         8    200    363   16(2N)     Flow_AreaOptimized_high
//    IIR                     15         10         8    200    363   16(2N)     Flow_PerfOptimized_high
//    IIR_DISRST              15         10         8    200    350   16(2N)     Vivado Synthesis Defaults
//    IIR_DISRST              15         10         8    200    350   16(2N)     Flow_AreaOptimized_high
//    IIR_DISRST              15         10         8    200    350   16(2N)     Flow_PerfOptimized_high
//
//    MEAN                    5          20         32   775    1474  0          Vivado Synthesis Defaults
//    MEAN                    5          20         32   775    1474  0          Flow_AreaOptimized_high
//    MEAN                    5          20         32   775    2254  0          Flow_PerfOptimized_high
//    MEAN_DISRST             5          20         32   775    1435  0          Vivado Synthesis Defaults
//    MEAN_DISRST             5          20         32   775    1435  0          Flow_AreaOptimized_high
//    MEAN_DISRST             5          20         32   775    2215  0          Flow_PerfOptimized_high
//
//    RRS                     5          20         32   90     178   0          Vivado Synthesis Defaults
//    RRS                     5          20         32   90     178   0          Flow_AreaOptimized_high
//    RRS                     5          20         32   100    205   0          Flow_PerfOptimized_high
//    RRS_DISRST              5          20         32   75     120   0          Vivado Synthesis Defaults
//    RRS_DISRST              5          20         32   75     120   0          Flow_AreaOptimized_high
//    RRS_DISRST              5          20         32   75     145   0          Flow_PerfOptimized_high
//
//    CIC                     5          20         32   90     183   0          Vivado Synthesis Defaults
//    CIC                     5          20         32   90     183   0          Flow_AreaOptimized_high
//    CIC                     5          20         32   100    210   0          Flow_PerfOptimized_high
//    CIC_DISRST              5          20         32   75     125   0          Vivado Synthesis Defaults
//    CIC_DISRST              5          20         32   75     125   0          Flow_AreaOptimized_high
//    CIC_DISRST              5          20         32   75     150   0          Flow_PerfOptimized_high
//
//    CIC_DOWNSAMPLE          5          20         32   88     209   0          Vivado Synthesis Defaults
//    CIC_DOWNSAMPLE          5          20         32   88     209   0          Flow_AreaOptimized_high
//    CIC_DOWNSAMPLE          5          20         32   100    210   0          Flow_PerfOptimized_high
//    CIC_DOWNSAMPLE_DISRST   5          20         32   75     150   0          Vivado Synthesis Defaults
//    CIC_DOWNSAMPLE_DISRST   5          20         32   75     150   0          Flow_AreaOptimized_high
//    CIC_DOWNSAMPLE_DISRST   5          20         32   75     150   0          Flow_PerfOptimized_high
//
//    ADD                     5          20         32   1      26    0          Vivado Synthesis Defaults
//    ADD                     5          20         32   1      26    0          Flow_AreaOptimized_high
//    ADD                     5          20         32   1      26    0          Flow_PerfOptimized_high
//    ADD_DISRST              5          20         32   1      25    0          Vivado Synthesis Defaults
//    ADD_DISRST              5          20         32   1      25    0          Flow_AreaOptimized_high
//    ADD_DISRST              5          20         32   1      25    0          Flow_PerfOptimized_high
//
//    MULTIPLY_ANY            5          20         32   0      1     1          Vivado Synthesis Defaults
//    MULTIPLY_ANY            5          20         32   0      1     1          Flow_AreaOptimized_high
//    MULTIPLY_ANY            5          20         32   0      26    1          Flow_PerfOptimized_high
//    MULTIPLY_ANY_DISRST     5          20         32   0      0     1          Vivado Synthesis Defaults
//    MULTIPLY_ANY_DISRST     5          20         32   0      0     1          Flow_AreaOptimized_high
//    MULTIPLY_ANY_DISRST     5          20         32   0      25    1          Flow_PerfOptimized_high
//
//    MULTIPLY_LOG            5          20         32   0      24    0          Vivado Synthesis Defaults
//    MULTIPLY_LOG            5          20         32   0      24    0          Flow_AreaOptimized_high
//    MULTIPLY_LOG            5          20         32   0      24    0          Flow_PerfOptimized_high
//    MULTIPLY_LOG_DISRST     5          20         32   0      23    0          Vivado Synthesis Defaults
//    MULTIPLY_LOG_DISRST     5          20         32   0      23    0          Flow_AreaOptimized_high
//    MULTIPLY_LOG_DISRST     5          20         32   0      23    0          Flow_PerfOptimized_high
//
////////////////其他others////////////////
//本人是学FPGA的三流大学垃圾本科生在读，只接触过一丁点数字信号处理，有什么错误/有什么函数需求请指出;
//吐槽一下，像我这种考不上好学校研究生的，毕业收入能有6k-8k嘛，草，生活艰辛啊;
//我们集成电路专业普遍考上研能工作轻松12k-13k，不然就只能工作辛苦5k-6k？这不没比化工海船好到哪里嘛;
//some discontent emmm......To be honest, I am afraid it is difficult to find a job after graduate my undergraduate course;
//tell me please if there are some thing wrong, or telling me what youn eed;
////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//fixed-point number 4bit in int and 16 bit in decimal
//定点数，整数4bit小数16bit
`define width_H 32
`define width_W 32

module testbench(

);
////////////////////////////////TEST_DATA////////////////////////////////

//declare
reg[6:0]addra;
wire [63:0]douta;

reg clk;
reg rst;
reg data_i_en;
//reg [(`width_H+`width_W-1):0]data_i;
wire data_o_en;
wire [(`width_H+`width_W-1):0]data_o;

//logic
initial begin
clk=0;
rst=0;
data_i_en=0;
addra=0;
#30 rst=1;
#30 rst=0;
#30 data_i_en=1;
end

always #5 clk=~clk;//100MHz
always@(posedge clk)addra+=1;

//rom
ROM ROM_0(
.addra(addra),
.clka(clk),
.douta(douta)
);

////////////////////////////////TEST_DATA_divide////////////////////////////////

//declare
reg[6:0]addra_divide;
wire [63:0]douta_divide;

reg clk_divide;
//reg rst;
reg data_i_en_divide;
//reg [(`width_H+`width_W-1):0]data_i;
wire data_o_en_divide;
wire [(`width_H+`width_W-1):0]data_o_divide;

//logic
initial begin
clk_divide=0;
data_i_en_divide=0;
addra_divide=0;
#30 data_i_en_divide=1;
end

always #(5*8) clk_divide=~clk_divide;//100/N MHz //////////////////N=32
always@(posedge clk_divide)addra_divide+=8;

//rom
ROM ROM_1(
.addra(addra_divide),
.clka(clk_divide),
.douta(douta_divide)
);

////////////////////////////////////////////////////////////////







////////////////////////////////FIR////////////////////////////////
FIR #(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal //定点数，整数4bit小数16bit
.width_W(20),
.N(32),//Specify order needs to be 2^x //级数需要是2^N
.log_N(5),//`define log_N //log_N=log 2 N
.const_num({//you might use //你可能会用到 //Num=round(Num*(2^width_W)); //filterDesigner;
/*1082,1223,1362,1501,1635,1766,1890,2007,
2116,2214,2302,2378,2442,2492,2528,2550,
2558,2550,2528,2492,2442,2378,2302,2214,
2116,2007,1890,1766,1635,1501,1362,1223,
1082*/
17316,19561,21800,24009,26167,28252,30241,32113,
33849,35429,36836,38054,39071,39873,40453,40803,
40921,40803,40453,39873,39071,38054,36836,35429,
33849,32113,30241,28252,26167,24009,21800,19561,
17316
})
) FIR_0(
.clk(clk),
.rst(rst),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////FIR_DISRST////////////////////////////////
FIR_DISRST #(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal //定点数，整数4bit小数16bit
.width_W(20),
.N(32),//Specify order needs to be 2^x //级数需要是2^N
.log_N(5),//`define log_N //log_N=log 2 N
.const_num({//you might use //你可能会用到 //Num=round(Num*(2^width_W)); //filterDesigner;
/*1082,1223,1362,1501,1635,1766,1890,2007,
2116,2214,2302,2378,2442,2492,2528,2550,
2558,2550,2528,2492,2442,2378,2302,2214,
2116,2007,1890,1766,1635,1501,1362,1223,
1082*/
17316,19561,21800,24009,26167,28252,30241,32113,
33849,35429,36836,38054,39071,39873,40453,40803,
40921,40803,40453,39873,39071,38054,36836,35429,
33849,32113,30241,28252,26167,24009,21800,19561,
17316
})
) FIR_DISRST_0(
.clk(clk),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////IIR////////////////////////////////
//我总感觉这个算法做的不太靠谱,仿真一下自己要做的信号看看靠不靠谱,建议使用FIR;
//I don't know whether this algorithm is right, simu your signal before using it, it is recommended to use FIR;
IIR #(
.width_H(15),//fixed-point number 16bit in int and 16 bit in decimal //定点数，整数16bit小数16bit
.width_W(10),//need to use WIDTH_H=12 WIDTH_W=20 for running testbench, but you can define any number when you use it
//跑testbench要用WIDTH_H=12 WIDTH_W=20, 拿来自己调用就随意了
.N(8),//Specify order needs to be 2*x //级数需要是2*N
//The three columns are the second column, the fifth column, the sixth column of matlab
//三列分别是matlab第二列第五列第六列
.const_num_SOS({//you might use //你可能会用到 //SOS=round(SOS*(2^width_W));
//2543,-13578,54303,
//23920,762,35031,
//69243,20824,18356,
//121461,36581,7356
40683,-217252,868844,
382716,12186,560498,
1107889,333177,293700,
1943369,585297,117690
}),
.const_num_G({//you might use //你可能会用到 //G=round(G*(2^width_W));
//52119,42845,34259,28410
833907,685526,548149,454557
})
) IIR_0(
.clk(clk),
.rst(rst),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////IIR_DISRST////////////////////////////////
//我总感觉这个算法做的不太靠谱,仿真一下自己要做的信号看看靠不靠谱,建议使用FIR;
//I don't know whether this algorithm is right, simu your signal before using it, it is recommended to use FIR;
IIR_DISRST #(
.width_H(15),//fixed-point number 16bit in int and 16 bit in decimal //定点数，整数16bit小数16bit
.width_W(10),//need to use WIDTH_H=12 WIDTH_W=20 for running testbench, but you can define any number when you use it
//跑testbench要用WIDTH_H=12 WIDTH_W=20, 拿来自己调用就随意了
.N(8),//Specify order needs to be 2*x //级数需要是2*N
//The three columns are the second column, the fifth column, the sixth column of matlab
//三列分别是matlab第二列第五列第六列
.const_num_SOS({//you might use //你可能会用到 //SOS=round(SOS*(2^width_W));
//2543,-13578,54303,
//23920,762,35031,
//69243,20824,18356,
//121461,36581,7356
40683,-217252,868844,
382716,12186,560498,
1107889,333177,293700,
1943369,585297,117690
}),
.const_num_G({//you might use //你可能会用到 //G=round(G*(2^width_W));
//52119,42845,34259,28410
833907,685526,548149,454557
})
) IIR_DISRST_0(
.clk(clk),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////MEAN////////////////////////////////
//均值;
MEAN #(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.N(32),//Specify order needs to be 2^x; //级数需要是2^N;
.log_N(5)//`define log_N; //log_N=log 2 N;
) MEAN_0(
.clk(clk),
.rst(rst),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////MEAN_DISRST////////////////////////////////
//均值;
MEAN_DISRST #(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.N(32),//Specify order needs to be 2^x; //级数需要是2^N;
.log_N(5)//`define log_N; //log_N=log 2 N;
) MEAN_DISRST_0(
.clk(clk),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////Recursive running-sum filter////////////////////////////////
//similar with mean; //Except phase and frequency, it works well with little source;
//类似均值,具体大概没有中文译名; //除了反馈结构的频率相位问题, 别的都整挺好, 资源消耗低;
RRS#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.N(32),//delay, needs to be 2^x; //延迟需要是2^N;
.log_N(5)//`define log_N; //log_N=log 2 N;
) RRS_0(
.clk(clk),
.rst(rst),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////Recursive running-sum filter////////////////////////////////
//similar with mean; //Except phase and frequency, it works well with little source;
//类似均值,具体大概没有中文译名; //除了反馈结构的频率相位问题, 别的都整挺好, 资源消耗低;
RRS_DISRST#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.N(32),//delay, needs to be 2^x; //延迟需要是2^N;
.log_N(5)//`define log_N; //log_N=log 2 N;
) RRS_DISRST_0(
.clk(clk),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////CIC////////////////////////////////
//CIC digital filter; //Recursive running-sum filter *N;
//CIC 数字滤波器; //Recursive running-sum filter *N;
CIC#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.N(32)//can be any non-zero value //任意非0值
) CIC_0(
.clk(clk),
.rst(rst),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////CIC_DISRST////////////////////////////////
//CIC digital filter; //Recursive running-sum filter *N;
//CIC 数字滤波器; //Recursive running-sum filter *N;
CIC_DISRST#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.N(32)//can be any non-zero value //任意非0值
) CIC_DISRST_0(
.clk(clk),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////CIC_UPSAMPLE////////////////////////////////
//CIC_UPSAMPLE; //just CIC;
//CIC_UPSAMPLE超采样; //就是CIC;
CIC_UPSAMPLE#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.N(32)//can be any non-zero value; //任意非0值;
) CIC_UPSAMPLE_0(
.clk_divide(clk_divide),//No need to fill in, add here for easy understanding; //不需要填入，在此加入便于理解;
.clk(clk),
.rst(rst),
.data_i_en(data_i_en_divide),
.data_i(douta_divide),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////CIC_UPSAMPLE_DISRST////////////////////////////////
//CIC_UPSAMPLE; //just CIC;
//CIC_UPSAMPLE超采样; //就是CIC;
CIC_UPSAMPLE_DISRST#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.N(32)//can be any non-zero value; //任意非0值;
) CIC_UPSAMPLE_DISRST_0(
.clk_divide(clk_divide),//No need to fill in, add here for easy understanding; //不需要填入，在此加入便于理解;
.clk(clk),
.data_i_en(data_i_en_divide),
.data_i(douta_divide),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////CIC_DOWNSAMPLE////////////////////////////////
//CIC_DOWNSAMPLE; //just CIC Transpose;
//CIC_DOWNSAMPLE降; //就是CIC转置;
CIC_DOWNSAMPLE#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.N(32)//can be any non-zero value; //任意非0值;
) CIC_DOWNSAMPLE_0(
.clk_divide(clk_divide),//output clk; //输出时钟;
.clk(clk),
.rst(rst),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en_divide),
.data_o(data_o_divide)
);

////////////////////////////////CIC_DOWNSAMPLE_DISRST////////////////////////////////
//CIC_DOWNSAMPLE; //just CIC Transpose;
//CIC_DOWNSAMPLE降; //就是CIC转置;
CIC_DOWNSAMPLE_DISRST#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.N(32)//can be any non-zero value; //任意非0值;
) CIC_DOWNSAMPLE_DISRST_0(
.clk_divide(clk_divide),//output clk; //输出时钟;
.clk(clk),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en_divide),
.data_o(data_o_divide)
);

////////////////////////////////ADD////////////////////////////////
ADD#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.const_num(1048576)//num you want to add (can be nagtive number); //加数(可以为负);
) ADD_0(
.clk(clk),
.rst(rst),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////ADD_DISRST////////////////////////////////
ADD_DISRST#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.const_num(1048576)//num you want to add (can be nagtive number); //加数(可以为负);
) ADD_DISRST_0(
.clk(clk),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////MULTIPLY_ANY////////////////////////////////
MULTIPLY_ANY#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.const_num(104857)//num you want to mul (can be nagtive number); //乘数(可以为负);
) MULTIPLY_ANY_0(
.clk(clk),
.rst(rst),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////MULTIPLY_ANY_DISRST////////////////////////////////
MULTIPLY_ANY_DISRST#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.const_num(104857)//num you want to mul (can be nagtive number); //乘数(可以为负);
) MULTIPLY_ANY_DISRST_0(
.clk(clk),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////MULTIPLY_LOG////////////////////////////////
MULTIPLY_LOG#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.const_num(2)//log you want to mul (can be nagtive number); //log2格式乘数(可以为负);
) MULTIPLY_LOG_0(
.clk(clk),
.rst(rst),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

////////////////////////////////MULTIPLY_LOG_DISRST////////////////////////////////
MULTIPLY_LOG_DISRST#(
.width_H(5),//fixed-point number 4bit in int and 16 bit in decimal; //定点数，整数4bit小数16bit;
.width_W(20),
.const_num(2)//log you want to mul (can be nagtive number); //log2格式乘数(可以为负);
) MULTIPLY_LOG_DISRST_0(
.clk(clk),
.data_i_en(data_i_en),
.data_i(douta),
.data_o_en(data_o_en),
.data_o(data_o)
);

endmodule
