function  PW  = PolarWeight( N )
%POLAR_WEIGHT 输入信道数，输出基于PW公式的可靠度序列
    
    PW = zeros(1,N);
    bin_vec = dec2binvector( 0:1:(N-1), log2(N) );
    
    for ii= 1:1:N
        for jj = 0:1:log2(N)-1
            PW(1,ii) = PW(1,ii) + bin_vec(ii,log2(N)-jj) * 2^(jj/4);
        end
    end
end

