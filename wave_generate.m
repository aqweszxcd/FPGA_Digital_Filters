%产生两个正弦信号sin(x)和sin(8x)叠加后的信号，取128个点，将信号放大，
%转换成无符号数据，存入ROM中作为信号源
clear all
depth=128;%采样率
width_H=5;%位深
width_W=20;%位深

x = 0 : 2*pi/(depth-1) :2*pi;
y = sin(x)+sin(8*x);
plot(x,sin(x),'r')  %红色为sin(x)函数
hold on
plot(x,sin(8*x),'g')    %绿色为sin(8x)函数
hold on
plot(x,y,'b')   %蓝色为生成的混合信号
grid

b=round(y*(2^width_W));
%编写mif文件
fid = fopen('sinx.mif','wt'); %将信号写入.mif文件
fprintf(fid,'WIDTH=%d;\n',(width_H+width_W) );%写入存储位宽20位
fprintf(fid,'DEPTH=%d;\n',(depth) );%写入存储深度128
fprintf(fid,'ADDRESS_RADIX=UNS;\n');%写入地址类型为无符号整型
fprintf(fid,'DATA_RADIX=UNS;');%写入数据类型为无符号整型
fprintf(fid,'CONTENT BEGIN\n');%起始内容
for num=0 : 127 
fprintf(fid,'%d:%16.0f;\n',num,b(num+1));
end
fclose(fid);

fid=fopen('sinx.coe','wt');
fprintf(fid,'memory_initialization_radix=%d;\n',(10));
%fprintf(fid,'Coefficient_Width = %d;\n',(width_HIGH+width_LOW) );
fprintf(fid,'memory_initialization_vector =\n');
for num=0 : 126
fprintf(fid,'%16.0f,\n',b(num+1));
end
num=num+1;
fprintf(fid,'%16.0f;\n',b(num+1));
fclose(fid);

%Num=round(Num*(2^16));



