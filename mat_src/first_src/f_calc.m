function l_odd = f_calc(a,b)

l_odd = log( (1 + exp(a+b)) / (exp(a) + exp(b)) );

%l_odd = sign(a) * sign(b) * min(abs(a),abs(b));

end

