function PM = path_metric( i,u,PM_former,LLR,Z )
% ·����������Ϊ��·������Ӧ���������еĸ��ʣ�ʵ��ʱ�������ö�����ʽ
% ���룺i������iλ����
%       u���������Ƶ���Ϣ���ػ�̶�����
%       PM_former�����ڣ�i-1��λ֮ǰ��·������
%       Z����λ�þ���ָʾ��Ϣλ�͹̶�λ��λ��,��0����ʾ�̶�����λ�ã���1����ʾ��Ϣ����λ��
%       LLR������Ӧ�Ķ�����Ȼ�Ⱦ���
% �����PM����·������ֵ


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

