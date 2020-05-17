clc;
clear;
era_p = 0.5;
n = 10;
Bhat = zeros(n, 2^(n+1));
for ii = 1:1:n
    temp = Bhat_para(era_p, ii);
    temp = sort(temp);
    Bhat(ii,1:2^(ii+1)) = temp;
    
    y = linspace(ii-1,ii,2^(ii+1));
    plot(y(1,1:2^(ii+1)),Bhat(ii,1:2^(ii+1)),'*');
    hold on;
end
    