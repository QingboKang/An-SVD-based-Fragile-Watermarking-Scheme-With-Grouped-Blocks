function [ WatermarkBinaryImg, DifferenceImg , extract_block_traces_quant] = ExtractFragileWatermark( InImg, OriginalWatermarkImg )
% Extract Fragile watermark (Image Authentication)
close all;

InImg = double(InImg);
OriginalWatermarkImg = double( OriginalWatermarkImg./255 );

% Block Size
block_size = [4, 4];

InImg_size = size(InImg);
block_num = InImg_size ./ block_size;

% Block-based Scrambling transformation 
% for 128 * 128 blocks, 96 is the period number
InImg_Scr = ImgBlockArnold( InImg, 30, block_size);


% First, Zero the LSB, get the InImg_zerolsb 
InImg_zerolsb = ZeroBits( double(InImg_Scr), 1 );

% Blcoked the InImg_zerolsb, get the block data
InImg_zerolsb_blocked = cell(block_num);

[InImg_zerolsb_blocked ] = imageBlocked( InImg_zerolsb, block_size );

% Calculate the SVD's matrix S's trace of each block data 
extract_block_traces_quant = zeros(block_num);
extract_block_traces = zeros(block_num);
for i = 1 : block_num(1)
    for j = 1 : block_num(2)
        block_data = cell2mat( InImg_zerolsb_blocked(i, j) );
      
        % SVD trace
        [U S V] = svd(double(block_data));
        extract_block_traces(i, j) = trace(S);
        
        % round to [0 1023]
        extract_block_traces_quant(i, j) =  floor( mod( extract_block_traces(i, j), 1024));
    end
end

% Get the LSB of the original image
[InImg_bitplanes] = BitsPlanes(InImg_Scr);
InImg_LSB = InImg_bitplanes(:, :, 8);
OriginalLSB = bitxor( InImg_LSB, OriginalWatermarkImg);

% Divide the LSB into small blocks
block_LSB = cell(block_num);
block_LSB = mat2cell( OriginalLSB, ones(block_num(1), 1) * block_size(1), ones(block_num(2), 1) * block_size(2) );

% Generate the watermarked LSB with block_LSB and block_traces
[ LSB_marked ] = handleLSBExtract( InImg_zerolsb_blocked, block_LSB, extract_block_traces_quant );

WatermarkBinaryImg = bitxor( LSB_marked, InImg_LSB);
DifferenceImg = abs( WatermarkBinaryImg - OriginalWatermarkImg );

% Block-based Scrambling transformation
% for 128 * 128 blocks, 96 is the period number
DifferenceImg = ImgBlockArnold( DifferenceImg, 66, block_size);

figure, imshow(WatermarkBinaryImg, []), title('Extract Watermark Image');
figure, imshow(DifferenceImg, []), title( 'Difference Image The Between Original and The Extract One' );

end

