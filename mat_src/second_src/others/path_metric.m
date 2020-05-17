function PM = path_metric( i,u,PM_former,LLR,Z )
% 路径度量定义为该路径所对应的译码序列的概率，实现时往往采用对数形式
% 输入：i——第i位估计
%       u——待估计的信息比特或固定比特
%       PM_former——第（i-1）位之前的路径度量
%       Z——位置矩阵，指示信息位和固定位的位置,“0”表示固定比特位置，“1”表示信息比特位置
%       LLR——对应的对数似然比矩阵
% 输出：PM——路径度量值


if (Z(i)==1 || (Z(i)==0 && u==0)) && ((1-2*u) == sign(LLR))
    if i==1
        PM = 0;
    else 
        PM = PM_former;
    end
elseif (Z(i)==1 || (Z(i)==0 && u==0)) && ((1-2*u) ~= sign(LLR))
	if i==1
		PM = 0-abs(LLR);
	else
		PM = PM_former-abs(LLR);
	end
else
	PM = -inf;
end

end

