function [ block_img ] = imageBlocked( input_img, block_size )
%   image split into any size blocks
%   2014.08.25

[img_h, img_w] = size(input_img);

block_num = [img_h/block_size(1), img_w/block_size(2)];

% store the block data
block_img = cell(block_num);

block_img = mat2cell( input_img, ones(block_num(1), 1) * block_size(1), ones(block_num(2), 1) * block_size(2));


end

