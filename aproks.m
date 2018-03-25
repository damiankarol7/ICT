% Tworzenie dziedziny funkcji
x=[1:10]
% Generowanie tablic liczb losowych, które pos³u¿¹ do modelowania
% danych zaszumionych
t1=rand(size(x)); t2=fliplr(t1); t3=t1-t2;
% Tworzenie wartoœci funkcji (dane zaszumione)
y=1.25*x+t3
% Aproksymacja wielomianowa liniowa (polyfit zwraca wektor a ze wspó³czynnikami
% wielomianu, polyval zwraca wektor y_ok wartoœci prostej aproksymuj¹cej)
a=polyfit(x,y,1), y_ok=polyval(a,x)
% Oszacowanie b³êdu dopasowania prostej aproksymuj¹cej do danych
blad=norm(y-y_ok)
% Wykresy ilustruj¹ce wykonan¹ aproksymacjê danych
subplot(2,1,1);
plot(x,y,'k*','MarkerSize',15),hold on
plot(x,y_ok,'ro','LineWidth',3,'MarkerSize',15)
legend('Dane pomiarowe','Dane aproksymowane','Location','NorthWest')
subplot(2,1,2)
bar(x,y-y_ok)
xlim([0 10])
