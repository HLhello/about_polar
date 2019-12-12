clc;
clear;

block=10;   
N=2^3;
R=1/2;
SNR=1:5;
snr=10.^(SNR./10);

S=floor(N*R);       % 信息位所占码长，使用floor意在当N为奇数时冻结位占据数量优势
F=N-S;              % 冻结位所占码长
ST=S*block;         % signal_total总的信息位长度
FT=F*block;         % frozen_total总的冻结位长度

signal = randi([0,1],1,ST);       %信息位比特，随机二进制数
frozen = zeros(1,FT);             %固定位比特，规定全为0
encode = zeros(1,N * block);      %编码后的比特
noise = snr(ii) ^ 1/2 * randn(1,N * block);  %加性高斯白噪声

y = B_para( p );

[Z_in_order,index] = sort( y );             %将巴氏参数从小到大排列
signal_index = sort( index( 1:S ) );        %前S位作为信息位
frozen_index = sort( index( s+1:end ) );    %后面的作为冻结位

GN = gen_matrix( n );

for j=1:block                 %对每一个码块都要进行编码处理
    encoded(1,((j-1)*N+1):(j*N)) = signal(((j-1)*S+1):(j*S))*G(signal_index,:) + frozen(((j-1)*F+1):(j*F))*G(frozen_index,:);
end                           %进行编码
encode = mod(encode,2);       %对2取模
encode = 2 * encode - 1;      %符号化
encode = encode + noise;      %叠加噪声

