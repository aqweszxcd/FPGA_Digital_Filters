%�������������ź�sin(x)��sin(8x)���Ӻ���źţ�ȡ128���㣬���źŷŴ�
%ת�����޷������ݣ�����ROM����Ϊ�ź�Դ
clear all
depth=128;%������
width_H=5;%λ��
width_W=20;%λ��

x = 0 : 2*pi/(depth-1) :2*pi;
y = sin(x)+sin(8*x);
plot(x,sin(x),'r')  %��ɫΪsin(x)����
hold on
plot(x,sin(8*x),'g')    %��ɫΪsin(8x)����
hold on
plot(x,y,'b')   %��ɫΪ���ɵĻ���ź�
grid

b=round(y*(2^width_W));
%��дmif�ļ�
fid = fopen('sinx.mif','wt'); %���ź�д��.mif�ļ�
fprintf(fid,'WIDTH=%d;\n',(width_H+width_W) );%д��洢λ��20λ
fprintf(fid,'DEPTH=%d;\n',(depth) );%д��洢���128
fprintf(fid,'ADDRESS_RADIX=UNS;\n');%д���ַ����Ϊ�޷�������
fprintf(fid,'DATA_RADIX=UNS;');%д����������Ϊ�޷�������
fprintf(fid,'CONTENT BEGIN\n');%��ʼ����
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



