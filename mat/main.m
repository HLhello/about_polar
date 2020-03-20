clc;
clear;

stage = 5;
Rate = 1/2;
min_d = 0;
EbN0db = [1,2,3];

info_position = channel_info( stage, Rate, min_d, gen_seq_core );
[GF,GN] = generate_mat( stage );


for nEN = 1:1:length(EbN0db)
	
	en = 10^((EbN0db(nEN)/10));
	sigma = 1/(2*Rate*en);
	% sigmax = 1.0492/en; while Rate = 1/2
	
	nframe = 0;
	while(nframe<=max_tn)
		nframe = nframe + 1;
		
		u = randi([0,1],1,S); 
		
		x=encoder(u, info_position, GN);
		
		GWnoise = sqrt(sigma)*randn(1,length(x1));
		% GWnoise = sqrt(sigmax)*randn(1,length(x));
		
		y = x + GWnoise;
		
		llr = Rate*2*en*y;
		% llr = (1/1.0492)*2*en*y;
		
		uhat = decoder(llr, info_position, GN);
		
		error(nEN,nframe) = sum(abs(u - uhat));
	end
end



