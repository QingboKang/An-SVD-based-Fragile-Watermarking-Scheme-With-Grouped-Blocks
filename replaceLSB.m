function [ OutImg ] = replaceLSB( InImg, LSB )
% Replacing the LSB of the InImg with LSB

[h w] = size(InImg);

OutImg = zeros(h, w);
for r = 1 : h
    for c = 1 : w
        pixel = InImg(r, c);
        pixel = fix( pixel / 2) * 2 + LSB(r, c);
        OutImg(r, c) = pixel;
    end
end

end

