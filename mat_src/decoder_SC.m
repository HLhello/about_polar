function info_bits = decoder_SC( N,llr )
% 串行抵消译码算法 Successive Cancellation

% f(a,b) = log(1+e(a+b)) - log(exp(a)+exp(b));
% g(a,b,uhat) = ((-1)^uhat) * a + b;

% L_(N)_(2i-1)_[1,N] = f(L_(N/2)_(i)_[1,N/2] , L_(N/2)_(i)_[N/2+1,N])
% L_(N)_(2i)_[1,N] = g(L_(N/2)_(i)_[1,N/2] , L_(N/2)_(i)_[N/2+1,N] , uhat_(2i-1))

% L_(N)_(i)_[1,N] = log(W_(N)_(i)_[1,N]_0) - log(W_(N)_(i)_[1,N]_1)

% L_1_1_[1,1] =   Log(W_-_-_-_0) - Log(W_-_-_-_0) = 2y/sigma^2







end

