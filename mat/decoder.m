function uhat = decoder(stage, info_position, GN, B, llr)

len = 2^stage;
ver_llr = llr * B;

fx = zeros(stage, len/2);

for stg = 1:1:stage
    if(stg == 1)
        for ii = 1:1:len/(2^stg)
            fx(stg,ii) = f_calc(ver_llr(ii), ver_llr(ii + len/(2^stg)));
        end
    elseif(stg == stage)
        for ii = 1:1:len/(2^stg)
            fx(stg,ii) = f_calc(fx(stg-1, ii), fx(stg-1, ii+len/(2^stg)));
        end
    else
        for ii = 1:1:len/(2^stg)
            fx(stg,ii) = f_calc(fx(stg-1, ii), fx(stg-1, ii+len/(2^stg)));
        end
    end
end

end

