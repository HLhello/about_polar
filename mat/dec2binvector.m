function bin_vec = dec2binvector( num_dec, m )
% convert decimal number to binary vector of (MSB...LSB)

for j = 1:length( num_dec )
   for i = m:-1:1
       state(j,m-i+1) = fix( num_dec(j)/ (2^(i-1)) );
       num_dec(j) = num_dec(j) - state(j,m-i+1)*2^(i-1);
   end
end

bin_vec = state;

end



