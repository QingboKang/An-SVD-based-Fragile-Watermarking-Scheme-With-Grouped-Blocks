function [ randmtx ] = randCS( row, col, seed )
A = 4;
Xb = 2.5;
randmtx( 1, 1) = seed;
for i = 2 : row * col
    randmtx( 1, i ) = A * sin(randmtx(1, i-1) - Xb) * sin(randmtx(1, i - 1) - Xb);
end

randmtx = reshape(randmtx, row, col);

%RANDCS Summary of this function goes here
%   Detailed explanation goes here


end

