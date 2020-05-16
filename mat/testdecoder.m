function [decOut,PathMetric]  = testdecoder(llr,info_position,stage,G,L)

frozen_idx = find(info_position == 0);

LLRMat = zeros(L,2^stage-1);
Dec  = zeros(L,2^stage);

P0=1:L;
P = repmat(P0',1,stage+1);
PathMetric = 127*50*ones(1,L);

PathMetric(1)=0;
RouteBit = zeros(1,2*L);

TempMetric = zeros(1,2*L);

cnt = 0;
stg = stage;
for idx=1:2^stage
    bin=de2bi(idx-1,stage);
    while stg ~= 0
        indicateSignal = bin(stg);
        if stg == stage
            for ii=1:2^(stg-1)
                LLtoSort1 = llr(ii)*ones(L,1);
                LLtoSort2 = llr(ii+2^(stg-1))*ones(L,1);
                if indicateSignal==0
                    LLRMat(:,2^(stg-1)+ii-1)=sign(LLtoSort1.*LLtoSort2).*min(abs(LLtoSort1),abs(LLtoSort2));
                else
                    bas = BasedBit(:,ii);
                    LLRMat(:,2^(stg-1)+ii-1)=LLtoSort1.*(-1).^bas+LLtoSort2;
                end
            end
        else
            for ii=1:2^(stg-1)
                LLtoSort1 = LLRMat(P(:,stg+1),2^stg-1+ii);
                LLtoSort2 = LLRMat(P(:,stg+1),2^stg-1+ii+2^(stg-1));
                if indicateSignal==0
                    LLRMat(:,ii-1+2^(stg-1))=sign(LLtoSort1.*LLtoSort2).*min(abs(LLtoSort1),abs(LLtoSort2));
                else
                    bas = BasedBit(:,ii);
                    LLRMat(:,ii-1+2^(stg-1))=LLtoSort1.*(-1).^bas+LLtoSort2;
                end
            end
        end
        P(:,stg)=(1:L)';
        stg = stg-1;
    end
    inLLR = LLRMat(:,1);
    C = abs(inLLR);
    TempMetric(1:2:end)=PathMetric;
    TempMetric(2:2:end) =PathMetric+C';
    RouteBit(1:2:end) = (inLLR<0)';
    RouteBit(2:2:end) = (inLLR>=0)';
    if info_position(idx)==0
        cnt = cnt+1;
        [val,ind]=sort(TempMetric);
        Pind=floor((ind(1:L)-1)/2)+1;
        OutBit = RouteBit(ind(1:L));
        PathMetric = TempMetric(ind(1:L));
        P = P(Pind,:);
        Dec(:,frozen_idx(1:cnt-1))=Dec(Pind,frozen_idx(1:cnt-1));
        Dec(:,frozen_idx(cnt))=OutBit';
    else
        Pind = 1:L;
        P=P(Pind,:);
        PathMetric = TempMetric(((1:2:2*L)+RouteBit(1:2:end)));
    end
    ind = find(bin==0);
    if ~isempty(ind)
        stg=ind(1);
    end
    if idx<2^stage
        G1=G(1:2^(stg-1),1:2^(stg-1));
        BasedBit = mod(Dec(:,idx-2^(stg-1)+1:idx)*G1,2);
    end
end

decOut = Dec(:,frozen_idx);

end