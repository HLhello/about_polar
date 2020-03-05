function [ u_hat ] = decoder_SC( R, channel_info, llr)
% 串行抵消译码算法 Successive Cancellation
% 输入：码率R，信道信息channel_info，接收软信息llr
% 输出：估计码字 C_hat

frozen_index = find(channel_info==0);
info_index = find(channel_info==1); 

%initial llr




end

