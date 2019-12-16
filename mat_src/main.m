clc;
clear;

n = 3;      % 级数
R=1/2;      % 码率

N=2^n;      % 编码长度
S=N*R;      % 信息位所占码长
F=N-S;      % 冻结位所占码长

signal = randi([0,1],1,S);       %信息位比特，随机二进制数
frozen = zeros(1,F);             %固定位比特，规定全为0

% 生成矩阵
GN = gen_matrix( n );

% 信道的可靠性估计
Bhat = Bhat_para(0.5, n-1);
PW  = Polar_Weight( N );

codeframeBEC = encoder_polar4BEC( N, S, signal, Bhat, GN );
codeframeRM = encoder_RMpolar( N, S, 4, signal, PW, GN );