%zbiór 1
% Tworzenie dziedziny funkcji
x=[1:10]
% Generowanie tablic liczb losowych, które pos³u¿¹ do modelowania
% danych zaszumionych
y1 = [1.3338,4.8153,5.3822,8.1522,10.2259,11.7741,13.8478,16.6178,17.1847,20.6662]
% Aproksymacja wielomianowa liniowa (polyfit zwraca wektor a ze wspó³czynnikami
% wielomianu, polyval zwraca wektor y_ok wartoœci prostej aproksymuj¹cej)
a1=polyfit(x,y1,1), y_ok1=polyval(a1,x)
% Oszacowanie b³êdu dopasowania prostej aproksymuj¹cej do danych
blad=norm(y1-y_ok1)
% Wykresy ilustruj¹ce wykonan¹ aproksymacjê danych
figure(1)
subplot(2,1,1);
plot(x,y1,'k*','MarkerSize',15),hold on
plot(x,y_ok1,'ro','LineWidth',3,'MarkerSize',15)
legend('Dane pomiarowe','Dane aproksymowane','Location','NorthWest')
subplot(2,1,2)
bar(x,y1-y_ok1)
xlim([0 10])
%zbiór 2
% Tworzenie dziedziny funkcji
x=[1:10]
% Generowanie tablic liczb losowych, które pos³u¿¹ do modelowania
% danych zaszumionych
y2 =[2.7267,3.1105,6.6739,7.8339,9.7536,12.2464,14.1661,15.3261,18.8895,19.2733]
% Aproksymacja wielomianowa liniowa (polyfit zwraca wektor a ze wspó³czynnikami
% wielomianu, polyval zwraca wektor y_ok wartoœci prostej aproksymuj¹cej)
a2=polyfit(x,y2,1), y_ok2=polyval(a2,x)
% Oszacowanie b³êdu dopasowania prostej aproksymuj¹cej do danych
blad=norm(y2-y_ok2)
% Wykresy ilustruj¹ce wykonan¹ aproksymacjê danych
figure(2)
subplot(2,1,1);
plot(x,y2,'k*','MarkerSize',15),hold on
plot(x,y_ok2,'ro','LineWidth',3,'MarkerSize',15)
legend('Dane pomiarowe','Dane aproksymowane','Location','NorthWest')
subplot(2,1,2)
bar(x,y2-y_ok2)
xlim([0 10])