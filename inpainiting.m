function [sf] = inpainiting(I,maska,ITER,h,dt, method, vi, K)
%% Parametry inpaintingu
%%Iloœæ iteracji do wykonania przez program
maskaP = imerode(maska, ones(3,3));

[nx, ny] = size(I);

vt = zeros(nx,ny);
w  = zeros(nx,ny);
sf = I;
%% Rozwi¹zanie NS
for istep = 1 : ITER
    sf = Poisson(vt,sf,maska,I,h);
    [sfy, sfx] = gradient(sf,h,h);
    u = sfy;
    v = sfx;
    [uy, ux] = gradient(u,h,h);
    [vy, vx] = gradient(v,h,h);
    vt = vx - uy;

    for i=2:nx-1
        for j=2:ny-1
            if(maskaP(i,j) == 0)
                w(i,j)=-0.25*((sf(i,j+1)-sf(i,j-1))*(vt(i+1,j)-vt(i-1,j))-(sf(i+1,j)-sf(i-1,j))*(vt(i,j+1)-vt(i,j-1)))/(h*h);
            end
        end
    end

    if method == 1
        w = w + vi*anisodiff(w,K);
    end
    if method == 2
        w = w + vi*anisodiff2(w,K);
    end
    if method == 3
        w = w + vi*anisodiff2D(w,K);
    end

    for i=1:nx
        for j=1:ny
            if(maska(i,j) == 0)
                vt(i,j)=vt(i,j)+dt*w(i,j);
            end
        end
    end

    if rem(istep,30) == 0 && istep > 29
        istep
    end
end
end

