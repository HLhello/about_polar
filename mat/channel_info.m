function info_position = channel_info( stage, Rate, min_d, gen_seq_core );
%gen_seq_core (1,Bhat); (2,PW); (3,GA)
switch gen_seq_core
	case 1
		seq = BhatPara(Rate, stage)
	case 2
		seq = PolarWeight(stage)
end


end

