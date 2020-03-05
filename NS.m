%% parametry algorytmu zadawane przez u?ytkownika
image   = 'test.png';
schemat = 2; % 1 - schemat centralny, 2 - schemat upwind
ITER    = 201;
dt      = 1;
vi      = 0.75;
K       = 10^-12;
h=1;
anisDif = 5;
%%
I = im2double(imread(image));

[nx, ny, nz] = size(I);

maska  = double(1-((I(:,:,1) < 0.03) & ...
                 ( I(:,:,2) > 0.9)  & ...
                 ( I(:,:,3) < 0.03)));
%% konwertujê RGB na Spherical Coordinate System zgodnie z artyku³em "Image Inpainting via Fluid Equation, 2006
% L = rgb2hsv(I);
% R = L(:,:,1);
% T = L(:,:,2);
% F = L(:,:,3);

L = rgb2hsv(I);
R = I(:,:,1);
T = I(:,:,2);
F = I(:,:,3);

%% wstawiam maskê w obraz, od teraz w obrazie nie ma czêœci do inpaintingu
R = R.*(maska); T = T.*(maska); F = F.*(maska);

%% realizacja 3 algorytmów inpaintingu dla ka¿dej warstwy
tic
R = inpainiting(R,maska,ITER,h,dt,anisDif,vi,K,schemat);
T = inpainiting(T,maska,ITER,h,dt,anisDif,vi,K,schemat);
F = inpainiting(F,maska,ITER,h,dt,anisDif,vi,K,schemat);
tns = toc;

%% konwersja do obrazu kolorowego
L(:,:,1) = R;
L(:,:,2) = T;
L(:,:,3) = F;
% I = hsv2rgb(L);
I = L;

%% wynik obrazu kolorowego
imwrite(I, ['output' 'SOR' 'ITER_' num2str(ITER) 'h_' num2str(h) '.png']);
