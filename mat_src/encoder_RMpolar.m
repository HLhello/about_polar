function codeframe = encoder_RMpolar( N, S, d_min, info, PW, GN )

    d_weight = zeros(1,N);
    frozen = zeros(1,N);
    
    for ii = 1:1:N
        d_weight(1,ii) = length(find(GN(ii,:)==1));
        if(d_weight(1,ii) <= d_min)
            frozen(1,ii) = 1;
        end 
    end
    
    [~,index] = sort(PW);          %将巴氏参数从小到大排列
    temp_index = zeros(1,N);

    for ii = 1:1:N
        if(frozen(1,index(1,ii))==0)
            temp_index(1,ii) = index(1,ii);
        else
            temp_index(1,ii) = -100;
        end
    end
   
    unfrozen_bits = temp_index(1, find(temp_index(1,:)~=-100));
    unfrozen_len = length(unfrozen_bits);
    
    u = zeros(1,N);
    
    if(unfrozen_len>=S)
        signal_index = sort( unfrozen_bits(1,(unfrozen_len-S+1):end) );
        u(1, signal_index) = info;    
        codeframe = mod(u*GN, 2);
    else 
        codeframe(1,:) = zeros(1,N)-1; % code error
    end
    

    
end