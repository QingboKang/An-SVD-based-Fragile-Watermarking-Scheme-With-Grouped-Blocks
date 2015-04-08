function [ corr_block_index ] = getCorrespondingBlockIndex( total_size, block_index  )
% Get the four corresponding blocks, let's say up bottom left right

up_index = block_index + [-1, 0];
bottom_index = block_index + [1, 0];
left_index = block_index + [0, -1];
right_index = block_index + [0, 1];

if(up_index(1) == 0)
    up_index(1) = total_size(1);
end

if(bottom_index(1) > total_size(1))
    bottom_index(1) = 1;
end

if(left_index(2) == 0)
    left_index(2) = total_size(2);
end

if(right_index(2) > total_size(2))
    right_index(2) = 1;
end

corr_block_index = zeros(4, 2);
corr_block_index(1, :) = up_index;
corr_block_index(2, :) = bottom_index;
corr_block_index(3, :) = left_index;
corr_block_index(4, :) = right_index;

end

