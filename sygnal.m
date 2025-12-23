function y = sygnal(x) 
 y = 0.4*sin(5*pi*x.^0.5) - 3.5./(x+1) +3.7;
 y = y + 0.25 * randn(size(x)); %dodaj szum  
end
