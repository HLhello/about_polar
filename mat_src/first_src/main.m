clc;
clear;

load('parm');

n = 5;      % 级数
N=2^n;      % 编码长度
R=1/2;      % 码率

S=N*R;      % 信息位所占码�?
F=N-S;      % 冻结位所占码�?
d_min = 0;  % �?��码距

EbN0db = [1,2,3];		%噪声
max_tn = 10;			%帧数

info = randi([0,1],1,S);       % 信息位比特，随机二进制数

% 生成矩阵
[GF,GN] = gen_matrix( n );

% 巴氏参数法对BEC信道的可靠度估计
Bhat = BhatPara(0.5, n-1);

% 基于高斯近似法的信道可靠度估�?
% GA = GaussApprox()

% 基于PW公式的信道可靠度估计 
PW  = PolarWeight( N );          

% 比较两种信道可靠度的不同之处
[~, Bhat_seq] = sort(Bhat);
[~, PW_seq] = sort(PW, 'descend');
diff_PW_Bhat = length(find(Bhat_seq ~= PW_seq));


EbN0db = [1,2,3];
max_tn = 10;
for nEN = 1:1:length(EbN0db)
	
	en = 10^((EbN0db(nEN)/10));
	L_c = 4*en*R;

	sigma = 1/sqrt(2*R*en);
	% sigmax = 1.0492/(en));
	
	nframe = 0;
	while(nframe<=max_tn)
		nframe = nframe + 1;
		% 信道编码
		[u1,channel_info1] = encoder_polar4BEC( N, S, info, Bhat, GN );     % for BEC
		[u2,channel_info2] = encoder_RMpolar( N, S, 0, info, PW, GN);       % polar code
		[u3,channel_info3] = encoder_RMpolar( N, S, d_min, info, PW, GN);   % RM_polar code 

		% BPSk调制(0-->1,1-->-1)
		x1=2*sign(-u1)+1;
		x2=2*sign(-u2)+1;
		x3=2*sign(-u3)+1;
	
		noise = sigma*randn(1,length(x1));
		% noise = sqrt(sigmax)*randn(1,length(x));
		
		y1 = x1 + noise; 
		y2 = x2 + noise; 
		y3 = x3 + noise; 
		
		rec_s1 = 0.5*L_c*y1;
		rec_s2 = 0.5*L_c*y2;
		rec_s3 = 0.5*L_c*y3;
        
		% rec_s1 = 2*y1/sigmax;
		% rec_s2 = 2*y2/sigmax;
		% rec_s3 = 2*y3/sigmax;
		
		uhat1 = decoder_SC(rec_s1,channel_info1, parm, GN);
		uhat2 = decoder_SC(rec_s2,channel_info2, parm, GN);
		uhat3 = decoder_SC(rec_s3,channel_info3, parm, GN);
		
		error1(nEN,nframe) = sum(abs(u1 - uhat1));
		error2(nEN,nframe) = sum(abs(u2 - uhat2));
		error3(nEN,nframe) = sum(abs(u3 - uhat3));
	end

end


