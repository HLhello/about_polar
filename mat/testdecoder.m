function [decOut,PathMetric]  = testdecoder(recvLLR,A_a,MM,G,L)
Level=MM;
FrozenMat = ones(1,2^MM);
FrozenMat(A_a)=0;
LLRMat = zeros(L,2^MM-1);
ChanLLR = recvLLR;
Dec  =zeros(L,2^MM);
P0=1:L;
P = repmat(P0',1,MM+1);
PathMetric = 127*50*ones(1,L);
PathMetric(1)=0;
RouteBit = zeros(1,2*L);
TempMetric = zeros(1,2*L);

cnt=0;
for cIndx=1:2^MM
    bin=de2bi(cIndx-1,MM);
    
    while Level~=0
        indicateSignal = bin(Level);
        if Level==MM
            for ii=1:2^(Level-1)
                LLtoSort1 = ChanLLR(ii)*ones(L,1);
                LLtoSort2 = ChanLLR(ii+2^(Level-1))*ones(L,1);
                if indicateSignal==0
                    LLRMat(:,2^(Level-1)+ii-1)=sign(LLtoSort1.*LLtoSort2).*min(abs(LLtoSort1),abs(LLtoSort2));
                else
                    bas = BasedBit(:,ii);
                    LLRMat(:,2^(Level-1)+ii-1)=LLtoSort1.*(-1).^bas+LLtoSort2;
                end
            end
        else
            for ii=1:2^(Level-1)
                LLtoSort1 = LLRMat(P(:,Level+1),2^Level-1+ii);
                LLtoSort2 = LLRMat(P(:,Level+1),2^Level-1+ii+2^(Level-1));
                if indicateSignal==0
                    LLRMat(:,ii-1+2^(Level-1))=sign(LLtoSort1.*LLtoSort2).*min(abs(LLtoSort1),abs(LLtoSort2));
                else
                    bas = BasedBit(:,ii);
                    LLRMat(:,ii-1+2^(Level-1))=LLtoSort1.*(-1).^bas+LLtoSort2;
                end
            end
        end
        P(:,Level)=(1:L)';
        Level = Level-1;
    end
    inLLR = LLRMat(:,1);
    C = abs(inLLR);
    TempMetric(1:2:end)=PathMetric;
    TempMetric(2:2:end) =PathMetric+C';
    RouteBit(1:2:end) = (inLLR<0)';
    RouteBit(2:2:end) = (inLLR>=0)';
    if FrozenMat(cIndx)==0
        cnt = cnt+1;
        [val,ind]=sort(TempMetric);
        Pind=floor((ind(1:L)-1)/2)+1;
        OutBit = RouteBit(ind(1:L));
        PathMetric = TempMetric(ind(1:L));
        P = P(Pind,:);
        Dec(:,A_a(1:cnt-1))=Dec(Pind,A_a(1:cnt-1));
        Dec(:,A_a(cnt))=OutBit';
    else
        Pind = 1:L;
        P=P(Pind,:);
        PathMetric = TempMetric(((1:2:2*L)+RouteBit(1:2:end)));
    end
    ind = find(bin==0);
    if ~isempty(ind)
        Level=ind(1);
    end
    if cIndx<2^MM
        G1=G(1:2^(Level-1),1:2^(Level-1));
        BasedBit = mod(Dec(:,cIndx-2^(Level-1)+1:cIndx)*G1,2);
    end
end
decOut = Dec(:,A_a);