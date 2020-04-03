function chat = decoder(stage, info_position, GN, B, llr, parm)

len = 2^stage;

ver_llr = llr;%ver_llr = llr*B;
GK = GN;%GK = B*GN;

fx = zeros(len/2, stage);
gx = zeros(len/2, stage);
hx = zeros(1,len);
cx = zeros(1,len);
seek_idx = ones(1,stage);
idx = 0;

for stg = 1:stage
    if(stg == 1)
        for ii = 1:len/(2^stg)
            fx(ii,stg) = f_calc(ver_llr(ii), ver_llr(ii + len/(2^stg)));
        end
    else 
        for ii = 1:len/(2^stg)
            fx(ii,stg) = f_calc(fx(ii, stg-1), fx(ii+len/(2^stg), stg-1));
        end

    end
end

while idx < len
    if(stg==stage)
		idx = idx + 1;
		
		hx(idx) = fx(1,stg);
		if(info_position(idx)==0)
			cx(idx) = 0;
		else 
			cx(idx) = (sign(-hx(idx))+1)/2;
		end
		
		idx = idx + 1;
		
		if(mod(idx+2, 4)==0)
			gx(1, stg) = g_calc(fx(1, stg-1), fx(2, stg-1), cx(idx-1));
		end
		
		if(mod(idx, 4)==0)
			gx(1, stg) = g_calc(gx(1, stg-1), gx(2, stg-1), cx(idx-1));
		end
		
		hx(idx) = gx(1,stg);
		if(info_position(idx)==0)
			cx(idx) = 0;
		else 
			cx(idx) = (sign(-hx(idx))+1)/2;
		end
		
		stg = stg - parm(idx/2);
		if(stg>0)
			seek_idx(stg) = seek_idx(stg) + 1;
		end
		
	elseif(stg==1)
		temp = 2^(parm(idx/2));
		G(1:temp, stg) = cx(idx-temp+1 : idx) * GK(1:temp, 1:temp);
		for ii = 1:temp
			if(mod(G(ii, stg), 2)==0)
				Gbit(ii, stg) = 0;
			else 
				Gbit(ii, stg) = 1;
			end
		end
		
		for ii = 1:len/(2^stg)
			gx(ii, stg) = g_calc(ver_llr(ii), ver_llr(ii+len/(2^stg)), Gbit(ii, stg));
		end
		
		stg = stg + 1;
		seek_idx(stg) = seek_idx(stg) + 1;
		
	else 
		temp = 2^(parm(idx/2));
		if(mod(seek_idx(stg), 2)==0)
			G(1:temp, stg) = cx(idx-temp+1 : idx) * GK(1:temp, 1:temp);
			for ii = 1:temp
				if(mod(G(ii, stg), 2)==0)
					Gbit(ii, stg) = 0;
				else 
					Gbit(ii, stg) = 1;
				end
			end
			
			if(mod(seek_idx(stg)+2, 4)==0)
				for ii = 1:len/(2^stg)
					gx(ii, stg) = g_calc(fx(ii, stg-1), fx(ii+len/(2^stg), stg-1), Gbit(ii, stg));
				end
			end
			
			if(mod(seek_idx(stg), 4)==0)
				for ii = 1:len/(2^stg)
					gx(ii, stg) = g_calc(gx(ii, stg-1), gx(ii+len/(2^stg), stg-1), Gbit(ii, stg));
				end
			end
			
			for ii = 1:len/(2^(stg+1))
				fx(ii, stg+1) = f_calc(gx(ii, stg),gx(ii+len/(2^(stg+1)), stg));
			end
			
		else 
			
			if(mod(seek_idx(stg)+1,4)==0)
				for ii = 1:len/(2^stg)
					fx(ii,stg) = f_calc(gx(ii, stg-1), gx(ii+len/(2^stg), stg-1));
				end
			end
			
			if(mod(seek_idx(stg)+3,4)==0)
				for ii = 1:len/(2^stg)
					fx(ii, stg) = f_calc(fx(ii, stg-1), fx(ii+len/(2^stg), stg-1));
				end
			end
			
			for ii = 1:len/(2^(stg+1))
				fx(ii, stg+1) = f_calc(fx(ii,stg), fx(ii+len/(2^(stg+1)), stg));
			end	
		end
		
		stg = stg + 1;
		seek_idx(stg) = seek_idx(stg) + 1;
	end
end

chat = cx;

end
