clc;
clear;

stage = 10;
R = 1/2;
N = 2^stage;
K = N * R;
d_min = 0;

EbN0db = [1,2,3];
list_len = [1,2,4,8];
max_tn = 100;

[GN,GF,B] = generate_mat( stage );
parm = generate_parm(stage);

addpath('scldecoder/');
lambda_offset = 2.^(0 : log2(N));
llr_layer = get_llr_layer(N);
bit_layer = get_bit_layer(N);

gen_seq_core = 2;  %generate sequence core (1-->Bhat), (2-->PW), (3-->GA)[Todo]
info_position = channel_polarization( stage, R, d_min, GN, gen_seq_core );
info_idx = find(info_position==1);
if(length(info_idx) < R*(2^stage))
    disp('error: d_min too large to encode');
    return;
end

error = zeros(length(EbN0db),max_tn);
ber = zeros(length(EbN0db),max_tn);
for nEN = 1:1:length(EbN0db)

	en = 10^((EbN0db(nEN)/10));
	sigma = 1/sqrt(2*R*en);
    
    for nframe = 1:1:max_tn

        info = randi([0,1],1,K); 
        
        u = zeros(1,N);
        u(info_idx) = info ;

        c = encoder(u, GF);

        x = 1 - 2 * c;
        % x = 2*sign(-t) + 1;

        GWnoise = sqrt(sigma)*randn(1,length(x));
        y = x + GWnoise;

        llr = 2 * y / sigma;
        
        c_hat = scdecoder(stage, info_position, GF, llr, parm);
        
        for ii = 2:1:length(list_len)
            L = list_len(ii);
            % u_hat = scl_decoder(llr, L, K, frozen_bits, H_crc, lambda_offset, llr_layer, bit_layer);
        end
        
        error(nEN,nframe) = sum(abs(c - c_hat));
        ber(nEN,nframe) = error(nEN,nframe)/( R*(2^stage));
        
    end
          
end