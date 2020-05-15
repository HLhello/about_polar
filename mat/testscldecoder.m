function c_hat = testscldecoder(list_len, llr, info_position)

% 输入：list_len——路径搜索宽度；
% 	    llr——接收序列向量，长度为N；
% 	    info_position——位置矩阵，指示信息比特和固定比特的位置；
% 输出：c_hat

mat_init = llr;
N = length(llr);
allpath = log2(list_len);          

% u_mat(:,1:N)存放一串保留路径对应的码字
% u_mat(:,N+1)对应着候选路径的度量值
u_mat = zeros(list_len,N+1);  

reserve_all = path_matrix(list_len);
flag = 0;                          %%表示当前还没有遇到第一个信息位

PM_temp = zeros(2*list_len,2);             %存放2Lo个码字串的判断位置，用于选出Lo个码字串的临时矩阵
PM_temp(1:2:2*list_len,1) = ones(list_len,1);   %把第一列奇数行的值设为1

LLR_matrix = zeros(1,2*N-1);
LLR_matrix(1,1:N) = llr;

step_all = 0;

for ii = 0:log2(N)-1
    step = N/2^ii;
    LLR_temp = LLR_matrix(1,step_all+1:step_all+step);
    step_all = step_all + step;
    for jj = 1:N/2^(ii+1)
        LLR_matrix(step_all+jj) = sign( LLR_temp(2*jj-1) .* LLR_temp(2*jj) ) .* min( abs(LLR_temp(2*jj-1)),abs(LLR_temp(2*jj)) );
    end
end

for i = 1:N
    if info_position(i)==0
        if i==1
            uu = [];
            u_mat(:,i) = zeros(list_len,1);
            u = 0;
            LLR_matrix = mat_init;
            LLR = likelihood_rate(N,i,uu,LLR_matrix);
            PM_former = 0;
            for j = 1:list_len
                u_mat(j,N+1) = path_metric( i,u,PM_former,LLR,info_position );
            end
        else
            u_mat(:,i) = zeros(list_len,1);
            u = 0;
            for j = 1:list_len
                uu = u_mat(j,1:i-1);
                LLR_matrix = mat_init;
                LLR = likelihood_rate(N,i,uu,LLR_matrix);
                PM_former = u_mat(j,N+1);
                u_mat(j,N+1) = path_metric( i,u,PM_former,LLR,info_position );
            end
        end
    else
        flag = flag+1;
        if flag<=allpath                   %%此时要保留所有路径 并算概率
             u_mat(:,i) = reserve_all(:,flag);
             for j = 1:list_len
                 uu = u_mat(j,1:i-1);
                 u = u_mat(j,i);
                 LLR_matrix = mat_init;
                 LLR = likelihood_rate(N,i,uu,LLR_matrix);
                 PM_former = u_mat(j,N+1);
                 u_mat(j,N+1) = path_metric( i,u,PM_former,LLR,info_position );
             end
        else
            for j = 1:list_len
                uu = u_mat(j,1:i-1);
                LLR_matrix = mat_init;
                LLR = likelihood_rate(N,i,uu,LLR_matrix);
                PM_former = u_mat(j,N+1);
                PM_temp(2*j-1,2) = path_metric(i,1,PM_former,LLR,info_position);   %PM_temp矩阵奇数行存判定比特为1的路径测量值
                PM_temp(2*j,2) = path_metric(i,0,PM_former,LLR,info_position);     %PM_temp矩阵偶数行存判定比特为0的路径测量值
                [vals,inds]    = sort(PM_temp(:,2),'descend');
                temp=[];
                for k=1:list_len                                                                                           %%%这个循坏用于从2Lo个概率值中选取最优
                    if  mod(inds(k),2)==1                                                                            %%奇数索引值表示最后一位是1，tempcode最后一位是该路径的概率
                        tempcode=[u_mat((inds(k)+1)/2,1:i-1),1,vals(k)];
                        temp=[temp;tempcode];
                    else                                                                                             %%偶数索引表示最后一位是0 ，tempcode最后一位是该路径的概率
                        tempcode=[u_mat(inds(k)/2,1:i-1),0,vals(k)];
                        temp=[temp;tempcode];
                    end   
                end                       %%end of k_cycle
            end                           %%end of j_cycle
            u_mat(:,1:i)=temp(:,1:i);
            u_mat(:,N+1)=temp(:,i+1);
        end   
    end
end
    [values,index]=sort(u_mat(:,N+1),'descend');
    u_mat(1,1:N) = u_mat(index(1),1:N);
    c_hat = u_mat(1,1:N);
end




