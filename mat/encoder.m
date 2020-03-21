function x = encoder(u, info_position, GN)
len = length(info_position);
c = zeros(1,len);
idx = 1;
for ii = 1:1:len
	if(info_position(1,ii) == 1)
		c(1,ii) = u(1,idx);
		idx = idx + 1;
	end
end
x = mod(c*GN, 2);
x=2*sign(x)+1;
end
