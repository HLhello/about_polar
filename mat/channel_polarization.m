function info_position = channel_polarization( N, K, d_min, GN, epslion, gen_seq_core )
%gen_seq_core (1,Bhat); (2,PW); (3,GA)

stage = log2(N);
d_weight = zeros(1, N);
info_position = zeros(1,N);

switch gen_seq_core
	case 1
		Bhat = BhatPara(epslion, stage-1);
        [~, seq_index] = sort(Bhat);
	case 2
		seq_index = PolarWeight(stage);
end
	
for ii = 1:1:N
	d_weight(1,ii) = length(find(GN(ii,:)==1));
	if(d_weight(1,ii) <= d_min)
        seq_index(1,ii) = 0;
    end
end

idx = 0;
for ii = 1:1:N
    if(seq_index(1,ii) ~= 0)
        info_position(1,seq_index(ii)) = 1;
        idx = idx + 1; 
    end
    if(idx == K)
        break;
    end
end

end
