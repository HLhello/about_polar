clc;
clear;

n = 5;     % 级数
N=2^n;      % 编码长度
R=1/2;      % 码率

S=N*R;      % 信息位所占码长
F=N-S;      % 冻结位所占码长

info = randi([0,1],1,S);       %信息位比特，随机二进制数
frozen = zeros(1,F);             %固定位比特，规定全为0

% 生成矩阵
GN = gen_matrix( n );

% 巴氏参数法估计BEC信道的可靠度估计
% Bhat = Bhat_para(0.5, n-1);

% 基于PW公式的信道可靠度评估 
PW  = Polar_Weight( N );          

% codeframeBEC = encoder_polar4BEC( N, S, info, Bhat, GN ); %
codeframeRM = encoder_RMpolar( N, S, 32, info, PW, GN );

% BPSk调制(0-->1,1-->-1)
info_out=2*sign(-codeframeRM)+1;

% 过信道

% 译码模块

% 误码率统计


