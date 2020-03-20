function [ u_hat ] = decoder_SC( llr, channel_info, parm, F_k )
% 串行抵消译码算法 Successive Cancellation
% 输入：码率R，信道信息channel_info，接收软信息llr
% 输出：估计码C_hat

len = length(llr);
total_stage = log2(len);
h_x = zeros(1,len);
f_x = zeros(len/2,total_stage);
u_hat = zeros(1,len);
seek_idx = ones(1,len);
idx=0;

for stage = 1:1:total_stage
	if(stage==1)
		for ii = 1:1:len/(2^stage)
			f_x(ii,stage) = f_calc(llr(ii),llr(ii+len/(2^stage)));
        end
	elseif(stage == total_stage)
		for ii = 1:1:len/(2^stage)
			f_x(ii,stage) = f_calc(f_x(ii,stage-1),f_x(ii+len/(2^stage),stage-1));
		end
	else 
		for ii = 1:1:len/(2^stage)
			f_x(ii,stage) = f_calc(f_x(ii,stage-1),f_x(ii+len/(2^stage),stage-1));
        end
	end
end


while idx < len
	if stage == total_stage
		idx = idx + 1;
		h_x(idx) = f_x(1,stage);
		if channel_info(idx) == 0
			u_hat(idx) = 0;
		else
			u_hat(idx) = (sign(-h_x(idx)+1))/2;
		end
		idx = idx + 1;
        
		if mod(idx+2,4) == 0
			g_value(1,stage) = g_calc(f_x(1,stage-1),f_x(2,stage-1),u_hat(idx-1));
        end
        
        if mod(idx,4) == 0
			g_value(1,stage) = g_calc(g_value(1,stage-1),g_value(2,stage-1),u_hat(idx-1));
		end
		
		h_x(idx) = g_value(1,stage);
		if channel_info(idx) == 0
			u_hat(idx) = 0;
		else
			u_hat(idx) = (sign(-h_x(idx)+1))/2;
		end
		
		stage = stage -parm(idx/2);
		if stage>0
			seek_idx(stage) = seek_idx(stage) + 1;
		end
	elseif stage == 1
		G(1:2^(parm(idx/2)),stage) = u_hat(idx-2^(parm(idx/2))+1:idx) * F_k(1:2^(parm(idx/2)),1:2^(parm(idx/2)));
		
		for ii = 1:2^(parm(idx/2))
			if mod(G(ii,stage),2) == 0
				G_bit(ii,stage) = 0;
			else
				G_bit(ii,stage) = 1;
            end
		end
		
		for ii = 1:len/(2^(stage))
			g_value(ii,stage) = g_calc(llr(ii),llr(ii+len/(2^(stage))),G_bit(ii,stage));
		end
		stage = stage + 1;
		seek_idx(stage) = seek_idx(stage)+1;
	else
		if mod(seek_idx(stage),2) == 0
			G(1:2^(parm(idx/2)),stage) = u_hat(idx-2^(parm(idx/2))+1:idx) * F_k(1:2^(parm(idx/2)),1:2^(parm(idx/2)));
			for ii = 1:2^(parm(idx/2))
				if mod(G(ii,stage),2) == 0
					G_bit(ii,stage) = 0;
				else
					G_bit(ii,stage) = 1;
				end
			end
			
			if mod(seek_idx(stage)+2,4) == 0
				for ii = 1:len/(2^(stage))
					g_value(ii,stage) = g_calc(f_x(ii,stage-1),f_x(ii+len/(2^(stage)),stage-1),G_bit(ii,stage));
				end
			end
			
			if mod(seek_idx(stage),4) == 0
				for ii = 1:len/(2^(stage))
					g_value(ii,stage) = g_calc(g_value(ii,stage-1),g_value(ii+len/(2^(stage)),stage-1),G_bit(ii,stage));
				end
			end
			
			for ii = 1:len/(2^(stage+1))
				f_x(ii,stage+1) = f_calc(g_value(ii,stage),g_value(ii+len/(2^(stage+1)),stage));
			end
			
		else
			if mod(seek_idx(stage)+1,4) == 0
				for ii = 1:len/(2^(stage))
					f_x(ii,stage) = f_calc(g_value(ii,stage-1),g_value(ii+len/(2^(stage)),stage-1));
				end
			end
			
			if mod(seek_idx(stage)+3,4) == 0
				for ii = 1:len/(2^(stage))
					f_x(ii,stage) = f_calc(f_x(ii,stage),f_x(ii+len/(2^(stage+1)),stage));
				end
			end

			for ii = 1:len(2^(stage+1))
				f_x(ii,stage+1) = f_calc(f_x(ii,stage),f_x(ii+len/(2^(stage+1)),stage));
			end			
			stage = stage + 1;
			seek_idx(stage) = seek_idx(stage) + 1;
		end
	end
end

end

