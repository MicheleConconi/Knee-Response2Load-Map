function z = response_to_load_fitting_model(Coeff,x,y)
% Simply return the z value for (x,y) evaluated to the polinomial 

%logaritmic of load
z = (Coeff(1) + Coeff(2)*x + Coeff(3)*x^2 + Coeff(4)*x^3) * log(abs(y)+1);
