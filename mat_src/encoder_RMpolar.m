function [codeframe, channel_info] = encoder_RMpolar( N, S, d_min, info, PW ,GN)

    d_weight = zeros(1,N);
    
    for ii = 1:1:N
        d_weight(1,ii) = length(find(GN(ii,:)==1));
        if(d_weight(1,ii) <= d_min)
            PW(1,ii) = 0;
        end 
    end
    
    u = zeros(1,N);
    channel_info = zeros(1,N);
    
    [~,index] = sort(PW, 'descend');          %将PW从小到大排列 
    
    if(length(find(PW~=0))>=S)
        signal_index = sort( index( 1:S ) );        %前S位作为信息位
        u(1, signal_index) = info;
        
        channel_info(1,signal_index) = 1;
        codeframe = mod(u*GN, 2);
    else 
        channel_info(1,:) = 0;
        codeframe(1,:) = zeros(1,N)-1; % code error
    end
    
end