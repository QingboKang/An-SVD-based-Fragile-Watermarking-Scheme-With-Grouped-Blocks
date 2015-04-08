function [img_planes] = BitsPlanes(img)
% Get the img's 8 bit planes

[h w] = size(img);

img_planes = zeros(h, w, 8);

% for each pixel
for i = 1: h
    for j = 1 : w
        dec_value = img(i, j);
        bin_value = dec2bin(dec_value, 8);
        for k = 1 : 8
            img_planes(i, j, k) = bin_value(k) - 48;
        end
    end
end

% for k = 1 : 8
%     figure, imshow(img_planes(:, :, k), []);
% end

end
