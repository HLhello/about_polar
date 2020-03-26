clc;
clear;

stage = 3;
Rate = 1/2;
d_min = 0;

EbN0db = [1,2,3];
max_tn = 10;

[GN,B] = generate_mat( stage );

gen_seq_core = 2;  %generate sequence core (1-->Bhat), (2-->PW), (3-->GA)
info_position = channel_info( stage, Rate, d_min, GN, gen_seq_core );
if(length(find(info_position==1)) < Rate*2^stage)
    disp('error: d_min too large to encode');
    return;
end
% debug\/\/\/\/\/\/\/\/\/\/
% load('info_position.mat')
% info_position1 = channel_info( stage, Rate, d_min, GN, 1 );
% info_position2 = channel_info( stage, Rate, d_min, GN, 2 );
% diff_PW_Bhat = length(find(info_position1 ~= info_position2));
% x1 = length(find(info_position1 ~= info_position));
% x2 = length(find(info_position2 ~= info_position));
% l1 = length(find(info_position1==1));
% l2 = length(find(info_position1==1));


error = zeros(length(EbN0db),max_tn);
for nEN = 1:1:length(EbN0db)
	
	en = 10^((EbN0db(nEN)/10));
	sigma = 1/(2*Rate*en);
	% sigmax = 1.0492/en; while Rate = 1/2
	
	nframe = 0;
	while(nframe<=max_tn)
		nframe = nframe + 1;
		
		u = randi([0,1],1,Rate*2^stage); 
		
		x=encoder(u, info_position, GN);
		
		GWnoise = sqrt(sigma)*randn(1,length(x));
		% GWnoise = sqrt(sigmax)*randn(1,length(x));
		
		y = x + GWnoise;
		
		llr = 2*y/sigma;
		% llr = 2*y/sigmax;
		
		uhat = decoder(stage, info_position, GN, B, llr);
		
		error(nEN,nframe) = sum(abs(u - uhat));
	end
end



