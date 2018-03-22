clear;clc
diary('rejestracja.txt')
disp('Damian Olszewski')
disp('ICT grupa 1, 18.03.18')
%E to E [kPa], NU  to moduł Poissona, t [m] to grubość elementu, w [kN/m^2] to ciśnienie z jak element jest rozciągany
E=210e6
NU=.3
t=.025
w=3000
%dyskretyzacja, czyli dzielimy ten kwadratowy element na dwa trójkąty jak na rysunku z wierzchołkami o wsp.
%   trójkąt 1:
x1i=0
y1i=0
x1j=.5
y1j=.25
x1m=0
y1m=.25
%   trójkąt 2:
x2i=0
y2i=0
x2j=.5
y2j=0
x2m=.5
y2m=.25
%liczę pole trójkąta żeby sprawdzić czy jest >0
%   trójkąt 1
Tri_area1=LinearTriangleElementArea(x1i,y1i,x1j,y1j,x1m,y1m)
%   trójkąt 2
Tri_area2=LinearTriangleElementArea(x2i,y2i,x2j,y2j,x2m,y2m)
%zmienna p jest wpisywana "z palca", dla rozciągania p=1 dla ściskania p=2
p=1
%buduję macierz sztywności k dla każdego elementu
%   trójkąt 1
k1=LinearTriangleElementStiffness(E,NU,t,x1i,y1i,x1j,y1j,x1m,y1m,p)
%   trójkąt 2
k2=LinearTriangleElementStiffness(E,NU,t,x2i,y2i,x2j,y2j,x2m,y2m,p)
% buduję globalną macierz sztywności K. 
%   jako że element ma 4 węzły, to globalna macierz sztywności będzie miała wymiary 4+4=8
%   na początku trzeba wskrześić pustą macierz 8x8 którą potem będziemy zapełniać macierzami od poszczególnych węzłów
K=zeros(8,8)
%   składamy macierze sztywności poszczególnych węzłów do globalnej macierzy sztywności
%   oznaczenie węzłów jak w tabeli
%   K=K+k1
K=LinearTriangleAssemble(K,k1,1,3,4)
%   K=K+k2
K=LinearTriangleAssemble(K,k2,1,2,3)
%do rozwiązania układ równań liniowych w postaci macierzy [K][F]=[U]
%warunki brzegowe
%   dla macierzy sił w postaci  F=[F1x;F1y;F2x;F2y;F3x;F3y;F4x;F4y]
%   mamy                        F=[F1x;F1y;9.375;0;9.375;0;F4x;F4y]
%   dla macierzy przemieszczeń w postaci  U=[U1x;U1y;U2x;U2y;U3x;U3y;U4x;U4y]
%   mamy                                  U=[0;0;U2x;U2y;U3x;U3y;0;0]
%rozwiązuję układ równań
%   w celu obliczenia nieznanych ugięć rozwiązuję układ podmacierzy składającej się z kolumn od 3 do 6 i wierszy od 3 do 6
K_pod=K(3:6,3:6)
F_pod=[9.375;0;9.375;0]
%   obliczam nieznane ugięcia
U_pod=(K_pod\F_pod)
%post-processing
%   wyliczenie nieznanych sił działających na węzły
U=[0;0;U_pod;0;0]
F=K*U
%obliczenie naprężeń w elemencie
%   dla trójkąta 1
u1=[U(1) ; U(2) ; U(5) ; U(6) ; U(7) ; U(8)]
sigma1=LinearTriangleElementStresses(E,NU,t,x1i,y1i,x1j,y1j,x1m,y1m,p,u1)
%   dla trójkąta 2
u2=[U(1) ; U(2) ; U(3) ; U(4) ; U(5) ; U(6)]
sigma2=LinearTriangleElementStresses(E,NU,t,x2i,y2i,x2j,y2j,x2m,y2m,p,u2)
%Obliczam naprężenia główne i ich kąt
s1=LinearTriangleElementPStresses(sigma1)
s2=LinearTriangleElementPStresses(sigma2)
odp=sprintf('ROZWIĄZANIE \n ELEMENT 1 \n naprężenia główne w osi x w elemencie 1 sigma(1)= %d MPa (rozciąganie) \n naprężenia główne w osi y w elemencie 1 sigma(2)= %d MPa (rozciąganie) \n kąt główny teta %d stopni \n ELEMENT 2 \n naprężenia główne w osi x w elemencie 2 sigma(1)= %d MPa (rozciąganie) \n naprężenia główne w osi y w elemencie 2 sigma(2)= %d MPa (ściskanie) \n kąt główny teta %d stopni \n Zadanie opracował Damian Olszewski, nr albumu 146500',s1(1)/1000,s1(2)/1000,s1(3),s2(1)/1000,s2(2)/1000,s2(3))
disp(odp)
diary off
