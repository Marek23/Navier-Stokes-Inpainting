function [fy, fx] = boundGradient(f,m,h)
[nx, ny] = size(f);
H  = 2*h;
fp = padarray(f, [1 1], 'replicate');
mp = padarray(m, [1 1], 'replicate');

fy = zeros(nx,ny);
fx = zeros(nx,ny);

for i=1 : nx
    x = i+1;
    for j=1 : ny
        y = j+1;
        %% dy
        fy(i,j) = (fp(x,y+1) - fp(x,y-1))/H;
        if mp(x,y) == 1
            if mp(x,y+1) == 0
                fy(i,j) = (fp(x,y) - fp(x,y-1))/h;
            elseif mp(x,y-1) == 0
                fy(i,j) = (fp(x,y+1) - fp(x,y))/h;
            end
        end
        %% dx
        fx(i,j) = (fp(x+1,y) - fp(x-1,y))/H;
        if mp(x,y) == 1
            if mp(x+1,y) == 0
                fx(i,j) = (fp(x,y) - fp(x-1,y))/h;
            elseif mp(x-1,y) == 0
                fx(i,j) = (fp(x+1,y) - fp(x,y))/h;
            end
        end
    end
end
end

