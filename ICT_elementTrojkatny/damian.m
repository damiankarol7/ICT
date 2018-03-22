clear;clc
diary('rejestracja.txt')
disp('Damian Olszewski')
disp('ICT grupa 1, 18.03.18')
%E to E [kPa], NU  to modu� Poissona, t [m] to grubo�� elementu, w [kN/m^2] to ci�nienie z jak element jest rozci�gany
E=210e6
NU=.3
t=.025
w=3000
%dyskretyzacja, czyli dzielimy ten kwadratowy element na dwa tr�jk�ty jak na rysunku z wierzcho�kami o wsp.
%   tr�jk�t 1:
x1i=0
y1i=0
x1j=.5
y1j=.25
x1m=0
y1m=.25
%   tr�jk�t 2:
x2i=0
y2i=0
x2j=.5
y2j=0
x2m=.5
y2m=.25
%licz� pole tr�jk�ta �eby sprawdzi� czy jest >0
%   tr�jk�t 1
Tri_area1=LinearTriangleElementArea(x1i,y1i,x1j,y1j,x1m,y1m)
%   tr�jk�t 2
Tri_area2=LinearTriangleElementArea(x2i,y2i,x2j,y2j,x2m,y2m)
%zmienna p jest wpisywana "z palca", dla rozci�gania p=1 dla �ciskania p=2
p=1
%buduj� macierz sztywno�ci k dla ka�dego elementu
%   tr�jk�t 1
k1=LinearTriangleElementStiffness(E,NU,t,x1i,y1i,x1j,y1j,x1m,y1m,p)
%   tr�jk�t 2
k2=LinearTriangleElementStiffness(E,NU,t,x2i,y2i,x2j,y2j,x2m,y2m,p)
% buduj� globaln� macierz sztywno�ci K. 
%   jako �e element ma 4 w�z�y, to globalna macierz sztywno�ci b�dzie mia�a wymiary 4+4=8
%   na pocz�tku trzeba wskrze�i� pust� macierz 8x8 kt�r� potem b�dziemy zape�nia� macierzami od poszczeg�lnych w�z��w
K=zeros(8,8)
%   sk�adamy macierze sztywno�ci poszczeg�lnych w�z��w do globalnej macierzy sztywno�ci
%   oznaczenie w�z��w jak w tabeli
%   K=K+k1
K=LinearTriangleAssemble(K,k1,1,3,4)
%   K=K+k2
K=LinearTriangleAssemble(K,k2,1,2,3)
%do rozwi�zania uk�ad r�wna� liniowych w postaci macierzy [K][F]=[U]
%warunki brzegowe
%   dla macierzy si� w postaci  F=[F1x;F1y;F2x;F2y;F3x;F3y;F4x;F4y]
%   mamy                        F=[F1x;F1y;9.375;0;9.375;0;F4x;F4y]
%   dla macierzy przemieszcze� w postaci  U=[U1x;U1y;U2x;U2y;U3x;U3y;U4x;U4y]
%   mamy                                  U=[0;0;U2x;U2y;U3x;U3y;0;0]
%rozwi�zuj� uk�ad r�wna�
%   w celu obliczenia nieznanych ugi�� rozwi�zuj� uk�ad podmacierzy sk�adaj�cej si� z kolumn od 3 do 6 i wierszy od 3 do 6
K_pod=K(3:6,3:6)
F_pod=[9.375;0;9.375;0]
%   obliczam nieznane ugi�cia
U_pod=(K_pod\F_pod)
%post-processing
%   wyliczenie nieznanych si� dzia�aj�cych na w�z�y
U=[0;0;U_pod;0;0]
F=K*U
%obliczenie napr�e� w elemencie
%   dla tr�jk�ta 1
u1=[U(1) ; U(2) ; U(5) ; U(6) ; U(7) ; U(8)]
sigma1=LinearTriangleElementStresses(E,NU,t,x1i,y1i,x1j,y1j,x1m,y1m,p,u1)
%   dla tr�jk�ta 2
u2=[U(1) ; U(2) ; U(3) ; U(4) ; U(5) ; U(6)]
sigma2=LinearTriangleElementStresses(E,NU,t,x2i,y2i,x2j,y2j,x2m,y2m,p,u2)
%Obliczam napr�enia g��wne i ich k�t
s1=LinearTriangleElementPStresses(sigma1)
s2=LinearTriangleElementPStresses(sigma2)
odp=sprintf('ROZWI�ZANIE \n ELEMENT 1 \n napr�enia g��wne w osi x w elemencie 1 sigma(1)= %d MPa (rozci�ganie) \n napr�enia g��wne w osi y w elemencie 1 sigma(2)= %d MPa (rozci�ganie) \n k�t g��wny teta %d stopni \n ELEMENT 2 \n napr�enia g��wne w osi x w elemencie 2 sigma(1)= %d MPa (rozci�ganie) \n napr�enia g��wne w osi y w elemencie 2 sigma(2)= %d MPa (�ciskanie) \n k�t g��wny teta %d stopni \n Zadanie opracowa� Damian Olszewski, nr albumu 146500',s1(1)/1000,s1(2)/1000,s1(3),s2(1)/1000,s2(2)/1000,s2(3))
disp(odp)
diary off