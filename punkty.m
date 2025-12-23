t = 0:0.001:5;
acc_idealny = sygnal(t);

% --- LOSOWANIE PUNKTÓW ---
procent_danych = 0.25; % Np. zachowujemy tylko 5% punktów (bardzo rzadkie próbkowanie)
n_probek = round(length(t) * procent_danych);
% Losujemy indeksy z wektora czasu
indeksy_losowe = randperm(length(t), n_probek);
% WAŻNE: Dodajemy indeks 1 i ostatni, żeby nie mieć dziur na brzegach
indeksy_losowe = unique([1, indeksy_losowe, length(t)]);
% WAŻNE: interp1 wymaga, aby argumenty były posortowane!
indeksy_losowe = sort(indeksy_losowe);
% Tworzymy wektory "znane" na podstawie wylosowanych indeksów
t_znane = t(indeksy_losowe);
acc_znane = acc_idealny(indeksy_losowe);
% --- REKONSTRUKCJA ---
% Metoda A: Interpolacja Liniowa  
acc_linear = interp1(t_znane, acc_znane, t, 'linear');
% Metoda B: Interpolacja Wielomianowa (PCHIP)
acc_pchip = interp1(t_znane, acc_znane, t, 'pchip');
% --- BŁĘDY ---
% Liczymy błąd dla całego przebiegu (bo rekonstruujemy całość z punktów)
error_linear = mean((acc_idealny - acc_linear).^2);
error_pchip = mean((acc_idealny - acc_pchip).^2);
fprintf('Ilość punktów znanych: %d z %d\n', length(t_znane), length(t));
fprintf('Błąd MSE (Liniowa): %.6f\n', error_linear);
fprintf('Błąd MSE (PCHIP):   %.6f\n', error_pchip);
% --- WYKRESY ---
figure
subplot(3,1,1)
plot(t, acc_idealny, 'Color', [0.7 0.7 0.7], 'LineWidth', 2); hold on;
% Dodajemy kropki tam, gdzie "pobraliśmy" próbkę
plot(t_znane, acc_znane, 'r.', 'MarkerSize', 10); 
title('Oryginał + wylosowane próbki (czerwone kropki)')
legend('Idealny', 'Próbki')
subplot(3,1,2)
plot(t, acc_linear)
title(['Rekonstrukcja liniowa '])
subplot(3,1,3)
plot(t, acc_pchip);
title(['Rekonstrukcja wielomianowa'])
