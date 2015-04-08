% Zero the LSB bit planes
% Only work for 8-bit grayscale image
function OutImg = ZeroBits(InImg, zero_number)

if(zero_number > 8 || zero_number < 0)
    return;
end

number = power( 2, zero_number );

[h w] = size(InImg);
OutImg = zeros(h, w);

for i = 1 : h
    for j = 1 : w
        pixel_value = InImg(i, j);
        pixel_value = fix( pixel_value / number ) * number;
        OutImg(i, j) = pixel_value;
        
    end
end
