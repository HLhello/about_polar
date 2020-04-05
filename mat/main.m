clc;
clear;

load('parm.mat');
load GK
load bhat1_pw2;

stage = 10;
Rate = 1/2;
d_min = 0;

EbN0db = [1,2,3];
max_tn = 5;

[GN,Gm
,B] = generate_mat( stage );

% gen_seq_core = 1;  %generate sequence core (1-->Bhat), (2-->PW), (3-->GA)
% info_position = channel_info( stage, Rate, d_min, GN, gen_seq_core );
% if(length(find(info_position==1)) < Rate*2^stage)
%     disp('error: d_min too large to encode');
%     return;
% end

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
	sigma1=1.0492/(10^(EbN0db(nEN)/10));
	
	for nframe = 1:1:max_tn
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		u = randi([0,1],1,Rate*(2^stage)); 
		[x,c]=encoder(u, info_position1, GK);
		GWnoise = sqrt(sigma)*randn(1,length(x));
		y = x + GWnoise;
		llr = 2*y/sigma;
		chat = decoder(stage, info_position1, GK, llr, parm);
		error(nEN,nframe) = sum(abs(c - chat));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        free_bit1=round(rand(1,512));
        j=1;
        for i=1:1024
            if info_position1(i)==1
                msg1(i)=free_bit1(j);
                j=j+1;
            else
                msg1(i)=0;
            end
        end
		x1 = mod(msg1*GK, 2);
		t1 = 2*sign(-x1) + 1;
		noise1=sqrt(sigma1)*randn(1,1024);
		y1=t1+noise1;
        Ly1=(2*y1)/sigma1;
        uu = decoder(10, info_position1, GK, Ly1, parm);
        error1(nEN,nframe) = sum(abs(msg1 - uu));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	end
end


