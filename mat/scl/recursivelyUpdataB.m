function recursivelyUpdataB(lambda,phi,m)
    
    Beta = zeros();
    PHI = floor(phi/2);
    for bt = 0:1:(2^(m-lambda-1))
        Beta
    end
    
    if(mod(PHI,2) == 1)
        recursivelyUpdataB(lambda-1,PHI,m)
    end
    
    
    

end