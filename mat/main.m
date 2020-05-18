clc;
clear;

addpath('scldecoder/');
addpath('crc/');

stage = 10;
crc_len = 16;
d_min = 0;
epslion = 0.32;

N = 2^stage;
K = N/2 + crc_len;
R = K/N;

EbN0db = [1,2,3];
list_len = [1,4,8];
max_tn = 100;

[GN,GF,B] = generate_mat( stage );
parm = generate_parm(stage);
[G_crc, H_crc]= generate_crc(crc_len, K-crc_len);
crc_parity_check = G_crc(:, K - crc_len + 1 : end)';

lambda_offset = 2.^(0 : log2(N));
llr_layer = get_llr_layer(N);
bit_layer = get_bit_layer(N);

gen_seq_core = 2;  %generate sequence core (1-->Bhat), (2-->PW), (3-->GA)[Todo]
info_position = channel_polarization( N, K, d_min, GN, epslion, gen_seq_core );
info_idx = find(info_position==1);
if(length(info_idx) < K)
    disp('error: d_min too large to encode');
    return;
end

err = zeros(length(EbN0db),length(list_len));
ber = zeros(length(EbN0db),length(list_len));
for nEN = 1:1:length(EbN0db)

	en = 10^((EbN0db(nEN)/10));
	sigma = 1/sqrt(2*R*en);
    
    for nframe = 1:1:max_tn

        info_no_crc = randi([0,1],1,(K-crc_len)); 
        if(crc_len == 0)
            info = info_no_crc;
        else 
            info = [info_no_crc, mod((crc_parity_check * info_no_crc')', 2)];
        end
        
        u = zeros(1,N);
        u(info_idx) = info;

        c = encoder(u, GN);

        x = 1 - 2 * c;

        y = x + sigma*randn(1,N); % GWnoise = sigma*randn(1,N);

        llr = 2 * y / sigma^2;
        
        for ii = 1:1:length(list_len)
            L = list_len(ii);
            if L == 1
                info_hat = sc_decoder(llr, info_position, GN, B, parm);
                if(crc_len == 0)
                    err(nEN,ii) = err(nEN, ii ) + sum(abs(info - info_hat));
                else 
                    err(nEN,ii) = err(nEN, ii ) + sum(mod(H_crc * info_hat', 2));
                end
                % error(nEN,nframe) = sum(abs(info - info_hat));
                % berx(nEN,nframe) = error(nEN,nframe)/( R*(2^stage));
            else 
                [info_hat_mat,PM] = scl_decoder(llr, L, K, B, info_idx, lambda_offset, llr_layer, bit_layer);
                [~, path_num] = min(PM);
                info_hat = info_hat_mat(: , path_num);
                if(crc_len == 0)
                    err(nEN,ii) = err(nEN, ii) + sum(abs(info -  info_hat'));
                else 
                    err(nEN,ii) = err(nEN, ii ) + sum(mod(H_crc * info_hat, 2));
                end
            end   
        end
    end
    ber = err / (max_tn * K);   
end