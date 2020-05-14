clc
clear

l       %assigninitialpath()
p0       %getArrayPionter_P(0,l)
for  beta = 1:1:n
	set p0(beta,0) = w(y|0)
	set p0(beta,1) = w(y|1)
end


for phi = 1:1:n
	for l = 1:1:L
		if(pathIndexInactive(l))
			continue
		end
		recursivelyCalcP(m,phi,l)
	end
	if u_phi is frozen then
		continuePaths_FrozenBit(phi)
	else 
			continuePaths_UnFrozenBit(phi)
	end
	if phi mod 2 == 1
		for l = 1:1:L
			if(pathIndexInactive(l))
				continue
			end
			recursivelyCalcP(m,phi,l)
		end
	end
	
end

ls
ps

for l = 1:1:L
	if(pathIndexInactive(l))
		continue
	end
	c_m = getArrayPionter_c(m,l)
	p_m = getArrayPionter_p(m,l)
	if(ps < p_m(1,c_m(0,1)))
		ls = l;
		ps = p_m(0,c_m(0,1))
	end
end


set c0 % getArrayPointer_c(0,ls);
beta = 1:1:n
return chat = c0(beta,1)









