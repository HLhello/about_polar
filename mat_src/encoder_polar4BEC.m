function codeframe = encoder_polar4BEC( N, S, signal, Bhat, GN )

    [~,index] = sort( Bhat );          %将巴氏参数从小到大排列
    signal_index = sort( index( 1:S ) );        %前S位作为信息位
    %frozen_index = sort( index( S+1:end ) );    %后面的作为冻结位

    u = zeros(1,N);
    u(1, signal_index) = signal;
    codeframe = mod(u*GN, 2);
    
end

