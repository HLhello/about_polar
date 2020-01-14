function codeframe = encoder_polar4BEC( N, S, info, Bhat, GN )
    
    u = zeros(1,N);
    [~,index] = sort( Bhat );                   %将巴氏参数从小到大排列
    signal_index = sort( index( 1:S ) );        %前S位作为信息位
    u(1, signal_index) = info;
    codeframe = mod(u*GN, 2);
end

