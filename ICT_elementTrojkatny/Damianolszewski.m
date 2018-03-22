clear;clc
diary('rejestracja.txt')
disp('Damian Olszewski')
disp('ICT grupa 1, 18.03.18')
%E to E [kPa], NU  to modu³ Poissona, t [m] to gruboœæ elementu, w [kN/m^2] to ciœnienie z jak element jest rozci¹gany
E=210e6
NU=.3
t=.025
w=3000
%dyskretyzacja, czyli dzielimy ten kwadratowy element na dwa trójk¹ty jak na rysunku z wierzcho³kami o wsp.
%   trójk¹t 1:
x1i=0
y1i=0
x1j=.5
y1j=.25
x1m=0
y1m=.25
%   trójk¹t 2:
x2i=0
y2i=0
x2j=.5
y2j=0
x2m=.5
y2m=.25
%liczê pole trójk¹ta ¿eby sprawdziæ czy jest >0
%   trójk¹t 1
Tri_area1=LinearTriangleElementArea(x1i,y1i,x1j,y1j,x1m,y1m)
%   trójk¹t 2
Tri_area2=LinearTriangleElementArea(x2i,y2i,x2j,y2j,x2m,y2m)
%zmienna p jest wpisywana "z palca", dla rozci¹gania p=1 dla œciskania p=2
p=1
%budujê macierz sztywnoœci k dla ka¿dego elementu
%   trójk¹t 1
k1=LinearTriangleElementStiffness(E,NU,t,x1i,y1i,x1j,y1j,x1m,y1m,p)
%   trójk¹t 2
k2=LinearTriangleElementStiffness(E,NU,t,x2i,y2i,x2j,y2j,x2m,y2m,p)
% budujê globaln¹ macierz sztywnoœci K. 
%   jako ¿e element ma 4 wêz³y, to globalna macierz sztywnoœci bêdzie mia³a wymiary 4+4=8
%   na pocz¹tku trzeba wskrzeœiæ pust¹ macierz 8x8 któr¹ potem bêdziemy zape³niaæ macierzami od poszczególnych wêz³ów
K=zeros(8,8)
%   sk³adamy macierze sztywnoœci poszczególnych wêz³ów do globalnej macierzy sztywnoœci
%   oznaczenie wêz³ów jak w tabeli
%   K=K+k1
K=LinearTriangleAssemble(K,k1,1,3,4)
%   K=K+k2
K=LinearTriangleAssemble(K,k2,1,2,3)
%do rozwi¹zania uk³ad równañ liniowych w postaci macierzy [K][F]=[U]
%warunki brzegowe
%   dla macierzy si³ w postaci  F=[F1x;F1y;F2x;F2y;F3x;F3y;F4x;F4y]
%   mamy                        F=[F1x;F1y;9.375;0;9.375;0;F4x;F4y]
%   dla macierzy przemieszczeñ w postaci  U=[U1x;U1y;U2x;U2y;U3x;U3y;U4x;U4y]
%   mamy                                  U=[0;0;U2x;U2y;U3x;U3y;0;0]
%rozwi¹zujê uk³ad równañ
%   w celu obliczenia nieznanych ugiêæ rozwi¹zujê uk³ad podmacierzy sk³adaj¹cej siê z kolumn od 3 do 6 i wierszy od 3 do 6
K_pod=K(3:6,3:6)
F_pod=[9.375;0;9.375;0]
%   obliczam nieznane ugiêcia
U_pod=(K_pod\F_pod)
%post-processing
%   wyliczenie nieznanych si³ dzia³aj¹cych na wêz³y
U=[0;0;U_pod;0;0]
F=K*U
%obliczenie naprê¿eñ w elemencie
%   dla trójk¹ta 1
u1=[U(1) ; U(2) ; U(5) ; U(6) ; U(7) ; U(8)]
sigma1=LinearTriangleElementStresses(E,NU,t,x1i,y1i,x1j,y1j,x1m,y1m,p,u1)
%   dla trójk¹ta 2
u2=[U(1) ; U(2) ; U(3) ; U(4) ; U(5) ; U(6)]
sigma2=LinearTriangleElementStresses(E,NU,t,x2i,y2i,x2j,y2j,x2m,y2m,p,u2)
%Obliczam naprê¿enia g³ówne i ich k¹t
s1=LinearTriangleElementPStresses(sigma1)
s2=LinearTriangleElementPStresses(sigma2)
odp=sprintf('ROZWI¥ZANIE \n ELEMENT 1 \n naprê¿enia g³ówne w osi x w elemencie 1 sigma(1)= %d MPa (rozci¹ganie) \n naprê¿enia g³ówne w osi y w elemencie 1 sigma(2)= %d MPa (rozci¹ganie) \n k¹t g³ówny teta %d stopni \n ELEMENT 2 \n naprê¿enia g³ówne w osi x w elemencie 2 sigma(1)= %d MPa (rozci¹ganie) \n naprê¿enia g³ówne w osi y w elemencie 2 sigma(2)= %d MPa (œciskanie) \n k¹t g³ówny teta %d stopni \n Zadanie opracowa³ Damian Olszewski, nr albumu 146500',s1(1)/1000,s1(2)/1000,s1(3),s2(1)/1000,s2(2)/1000,s2(3))
disp(odp)
diary off