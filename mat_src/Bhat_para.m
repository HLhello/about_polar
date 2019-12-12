function y = Bhat_para(p)
% 将巴氏参数计算过程封装在函数B_para之中方便调用，Z为数组，作为实参传递进来。数组中只有第一个元素。

% Z第一个元素可以通过计算得到
Z = 2*(p*(1-p))^0.5;

for i = 1 : log2(N)         %迭代次数，N为码长
    Z_pre = Z;              %z_pre为上一层信道巴氏参数
    for j = 1 : 2^(i-1)     %本层运算使用的下标
        Z(2*j-1) = 2*Z_pre(j) - Z_pre(j)^2;
        Z(2*j) = Z_pre(j)^2;    %递推公式
    end
end
y = z;      % y作为实参从函数中传递出去，y就是最终的巴氏参数
end
