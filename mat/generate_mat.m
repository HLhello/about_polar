function [GF,GN] = generate_mat( n )

    F_ini= [1 0; 1 1];
    I = eye(2);
    B_ini = eye(2);

    for ii=1:n
        odd_ind = 1:2:2^(ii);
        even_ind = 2:2:2^(ii);
        if ii==1
            F = F_ini;
            B = B_ini;
        else
            F = kron( F_ini,F );
            
            r = eye(2^(ii));
            R(1:2^(ii), 1:2^(ii-1)) = r(1:2^(ii), odd_ind);
            R(1:2^(ii), 2^(ii-1)+1:2^(ii)) = r(1:2^(ii), even_ind);
            
            b = kron( I, B );
            B = R*b;
        end
    end
    GF = F;
    GN = B*F;
end


