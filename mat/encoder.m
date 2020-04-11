function [x,pre_c] = encoder(u, info_position, G)

len = length(info_position);
c = zeros(1,len);
idx = 1;
for ii = 1:1:len
	if(info_position(ii) == 1)
		c(ii) = u(idx);
		idx = idx + 1;
    else 
        c(ii) = 0;
	end
end

pre_c = c;
t = mod(c*G, 2);
x = 2*sign(-t) + 1;
% 0 -->  1
% 1 --> -1
end
