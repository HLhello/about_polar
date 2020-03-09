function [ u_hat ] = decoder_SC( llr )
% 串行抵消译码算法 Successive Cancellation
% 输入：码率R，信道信息channel_info，接收软信息llr
% 输出：估计码字 C_hat
llr_len = length(llr);
total_stage = log2(llr_len);

u_hat = zeros(1,llr_len);
l_oe(total_stage+1,llr_len) = zeros(total_stage+1,llr_len);
l_oe(1,:) = llr;
 
for stage = 1:1:total_stage%1,2,3
	total_group = 2^(total_stage-stage);%4,2,1
	group_size = llr_len/total_group;%2,4,8
	step = 2^(stage-1);%1,2,4	
	if(group_size==2)
		l_oe(stage+1,2*ii-1) = f_calc(l_oe(1,2*ii-1),l_oe(1,2*ii));
	else
		for group = 1:1:total_group
	
		l_oe(stage+1,2*ii-1) = f_calc(l_oe(1,),l_oe(1,2*ii));
	end
	end
	
end

end

