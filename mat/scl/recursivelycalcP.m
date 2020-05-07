function recursivelycalcP(lambda,phi)
    
    if lambda == 0
        return
    end
    
    PHI = floor(phi/2);
    
    if(mod(phi,2)==0)
        recursivelycalcP(lambda-1,PHI);
    end
    
    disp(lambda);
    disp(PHI);

end