function Bhat = Bhat_para(era_p, n)
% 计算B-DMC信道的子信道BEC信道的巴氏参数
% era_p：行到转移概率
% n    ：递归次数
% Bhat ：信道可靠度评估序列

% 由于对称性
Z = zeros(1,2^(n+1));

if(n == 0)
    Z(1,1) = 2*era_p - era_p*era_p;
    Z(1,2) = era_p*era_p;
else
    n_pre = n-1;
    B_pre = Bhat_para(era_p,n_pre);
    for ii = 1:1:2^n
        Z(1,2*ii-1) = 2*B_pre(1,ii)-B_pre(1,ii)*B_pre(1,ii);
        Z(1,2*ii) = B_pre(1,ii)*B_pre(1,ii);
    end
end
Bhat = Z;
end
