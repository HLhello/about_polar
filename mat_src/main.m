clc;
clear;

n = 5;      % 级数
N=2^n;      % 编码长度
R=1/2;      % 码率

S=N*R;      % 信息位所占码长
F=N-S;      % 冻结位所占码长
d_min = 0;  % 最小码距

info = randi([0,1],1,S);       % 信息位比特，随机二进制数

% 生成矩阵
[GF,GN] = gen_matrix( n );

% 巴氏参数法对BEC信道的可靠度估计
Bhat = BhatPara(0.5, n-1);

% 基于高斯近似法的信道可靠度估计
% GA = GaussApprox()

% 基于PW公式的信道可靠度估计 
PW  = PolarWeight( N );          

% 比较两种信道可靠度的不同之处
[~, Bhat_seq] = sort(Bhat);
[~, PW_seq] = sort(PW, 'descend');
diff_PW_Bhat = length(find(Bhat_seq ~= PW_seq));

% 信道编码
[codeframe1,channel_info1] = encoder_polar4BEC( N, S, info, Bhat, GN );     % for BEC
[codeframe2,channel_info2] = encoder_RMpolar( N, S, 0, info, PW, GN);       % polar code
[codeframe3,channel_info3] = encoder_RMpolar( N, S, d_min, info, PW, GN);   % RM_polar code 

% BPSk调制(0-->1,1-->-1)
code_out1=2*sign(-codeframe1)+1;
code_out2=2*sign(-codeframe2)+1;
code_out3=2*sign(-codeframe3)+1;

% 过信道

% 译码模块

% 误码率统计

% 译码程序


