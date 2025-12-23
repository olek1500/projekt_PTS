t = 0:0.001:5;
acc_idealny=sygnal(t);
acc_brak = acc_idealny;
tp_loss = 0.3; %początek usuwania
tk_loss = 0.7; %koniec
loss_red = (t > tp_loss) & (t < tk_loss); 
acc_brak(loss_red) = NaN; %usunięcie danych
valid_mask = ~isnan(acc_brak);
t_znane = t(valid_mask);
acc_znane = acc_brak(valid_mask);
% Metoda A: Interpolacja Liniowa  
acc_linear = interp1(t_znane, acc_znane, t, 'linear');
% Metoda B: Interpolacja Wielomianowa 3. stopnia
acc_pchip = interp1(t_znane, acc_znane, t, 'pchip');
error_linear = mean((acc_idealny(loss_red) - acc_linear(loss_red)).^2);
error_pchip = mean((acc_idealny(loss_red) - acc_pchip(loss_red)).^2);
fprintf('Błąd MSE (Liniowa): %.4f\n', error_linear);
fprintf('Błąd MSE (Wielomianowa):  %.4f\n', error_pchip);
figure
subplot(3,1,1)
plot(t, acc_idealny)
title('idealny przebieg')
subplot(3,1,2)
plot(t,acc_linear)
title('Interpolacja liniowa')
subplot(3,1,3)
plot(t, acc_pchip);
title('Interpolacja wielomianowa')
