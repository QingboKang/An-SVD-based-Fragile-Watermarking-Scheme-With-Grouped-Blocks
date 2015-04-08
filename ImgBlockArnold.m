% 512 * 512 的图像进行分块(size)的Arnold变换 
function OUTIMG = ImgBlockArnold(input_img, arnold_count, block_size)

% 分块
[img_size] = size(input_img);
block_num = img_size ./ block_size;
block = cell( block_num );
block = mat2cell(input_img, ones(512/block_size(1), 1) * block_size(1), ones(512/block_size(2), 1) * block_size(2));
index = ones( img_size ./ block_size );
for i = 1 : block_num(1)
    for j = 1 : block_num(2)
        index(j, i) = (i-1) * block_num(2) + j;
    end
end

index_reverse = Arnold(index, arnold_count);

% 恢复的分块
block_reverse = cell( block_num ); 
for i = 1 : block_num(1)
    for j = 1 : block_num(2)
        block_reverse{(i - 1) * block_num(2) + j} = block{index_reverse((i - 1) * block_num(2) + j)};
    end
end
OUTIMG = cell2mat(block_reverse);