function parm = generate_parm(stage)

len = 2^stage;
parm = zeros(1,len);

for stg = 1:1:stage+1
    step = 2^(stg-1);
    for ii = step:step:len
        parm(1,ii) = parm(1,ii)+1;
    end
end

end
