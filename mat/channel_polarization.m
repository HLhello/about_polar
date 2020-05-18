function info_position = channel_polarization( stage, Rate, d_min, GN, gen_seq_core )
%gen_seq_core (1,Bhat); (2,PW); (3,GA)

len = 2^stage;
d_weight = zeros(1, len);
info_len = len * Rate;
info_position = zeros(1,len);

switch gen_seq_core
	case 1
		Bhat = BhatPara(Rate, stage-1);
        [~, seq_index] = sort(Bhat);
	case 2
		seq_index = PolarWeight(stage);
end
	
for ii = 1:1:len
	d_weight(1,ii) = length(find(GN(ii,:)==1));
	if(d_weight(1,ii) <= d_min)
        seq_index(1,ii) = 0;
    end
end

idx = 0;
for ii = 1:1:len
    if(seq_index(1,ii) ~= 0)
        info_position(1,seq_index(ii)) = 1;
        idx = idx + 1; 
    end
    if(idx == info_len)
        break;
    end
end

end
