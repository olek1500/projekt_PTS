t = 0:0.001:5;
acc_idealny = sygnal(t);
% --- PARAMETRY SYMULACJI ---
procent_danych = 0.20; % Zostawiamy tylko 10% losowych punktów
tp_loss = 0.3;     % Początek dziury
tk_loss = 0.7;       % Koniec dziury

% 1. Wybór losowych punktów (jak w poprzednim przykładzie)
n_probek = round(length(t) * procent_danych);
indeksy_losowe = randperm(length(t), n_probek);
% 2. Usuwanie punktów z przedziału (robienie dziury)
% Sprawdzamy, które z WYLOSOWANYCH indeksów wpadają w czas dziury
t_wylosowane = t(indeksy_losowe);
maska_dziury = (t_wylosowane > tp_loss) & (t_wylosowane < tk_loss);
% Usuwamy te indeksy
indeksy_po_dziurze = indeksy_losowe(~maska_dziury);
% 3. Zabezpieczenie brzegów (dodajemy 1. i ostatni punkt, żeby wykres się spinał)
indeksy_finalne = unique([1, indeksy_po_dziurze, length(t)]);
indeksy_finalne = sort(indeksy_finalne); % interp1 wymaga sortowania!
% --- PRZYGOTOWANIE DANYCH ZNANYCH ---
t_znane = t(indeksy_finalne);
acc_znane = acc_idealny(indeksy_finalne);
% --- REKONSTRUKCJA ---
acc_linear = interp1(t_znane, acc_znane, t, 'linear');
acc_pchip = interp1(t_znane, acc_znane, t, 'pchip');
% --- BŁĘDY ---
error_linear = mean((acc_idealny - acc_linear).^2);
error_pchip = mean((acc_idealny - acc_pchip).^2);
fprintf('Liczba punktów po cięciach: %d (z %d oryginalnych)\n', length(t_znane), length(t));
fprintf('MSE Linear: %.6f\n', error_linear);
fprintf('MSE PCHIP:  %.6f\n', error_pchip);
subplot(3,1,1)
plot(t,acc_idealny);hold on;
plot(t_znane, acc_znane, 'r.', 'MarkerSize', 10); 
title('Oryginał');
legend('Idealny', 'Znane punkty');
subplot(3,1,2)
plot(t, acc_linear, 'r');
title('Linear ')
subplot(3,1,3)
plot(t, acc_pchip, 'g-');
title('PCHIP ' )
