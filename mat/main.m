clc;
clear;

stage = 10;
Rate = 1/2;
d_min = 0;

EbN0db = [1,2,3];
max_tn = 100;

[GN,GK,B] = generate_mat( stage ); % GN = GK * B
parm = generate_parm(stage);

gen_seq_core = 1;  %generate sequence core (1-->Bhat), (2-->PW), (3-->GA)
info_position = channel_info( stage, Rate, d_min, GN, 1 );
frozenpos = find(info_position == 0);
if(length(find(info_position==1)) < Rate*(2^stage))
    disp('error: d_min too large to encode');
    return;
end

error = zeros(length(EbN0db),max_tn);
ber = zeros(length(EbN0db),max_tn);
for nEN = 1:1:length(EbN0db)

	en = 10^((EbN0db(nEN)/10));
	sigma = 1/(2*Rate*en);
    
    for nframe = 1:1:max_tn

        u = randi([0,1],1,Rate*(2^stage)); 
        
		[x,c]=encoder(u, info_position, GK); % GN = GK * B
		
        GWnoise = sqrt(sigma)*randn(1,length(x));
        y = x + GWnoise;
        
		llr = 2*y/sigma;
        c_hat = scdecoder(stage, info_position, GK, llr, parm);
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %[decOut,PathMetric] = testdecoder(llr,frozenpos,stage,GK,8);
		test_c = testscldecoder(8, llr, info_position);
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        error(nEN,nframe) = sum(abs(c - c_hat));
        ber(nEN,nframe) = error(nEN,nframe)/( Rate*(2^stage));
    end
          
end



