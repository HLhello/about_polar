function GN = gen_matrix( n )
    N = 2 ^ n;   
    Gpre = 1;
    for i=1:n
        Ni = 2 ^ i;
        G = zeros(Ni);
        %Fn = zeros(Ni);
        A = zeros(Ni);
        for j = 1 : Ni / 2
            A(2 * j - 1 , j) = 1;
            A(2 * j , j) = 1;
            A(2 * j , Ni / 2 + j) = 1;
        end
        G = A*kron(eye(2),Gpre);
        Gpre = G;
    end
    GN = G;
end


