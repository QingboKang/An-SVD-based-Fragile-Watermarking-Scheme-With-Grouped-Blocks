function [ MarkedImg, quant_block_traces] = AddFragileWatermark( InImg, WatermarkBinaryImg )
% Add Fragile watermark (Image Authentication)
% The size of the InImg and WatermarkBinaryImg are equal.
% WatermarkBinaryImg is a bianry image(i.e. all the elements are 255 or 0)

InImg = double(InImg);
WatermarkBinaryImg = double(WatermarkBinaryImg./255);

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
quant_block_traces = zeros(block_num);
block_traces = zeros(block_num);
for i = 1 : block_num(1)
    for j = 1 : block_num(2)
        block_data = cell2mat( InImg_zerolsb_blocked(i, j) );
      
        % SVD trace
        [U S V] = svd(double(block_data));
        block_traces(i, j) = trace(S);
        
        % round to [0 1023]
        quant_block_traces(i, j) =  floor( mod( block_traces(i, j), 1024));
    end
end


% Get the LSB of the original image
[InImg_bitplanes] = BitsPlanes(InImg_Scr);
InImg_LSB = InImg_bitplanes(:, :, 8);

% Divide the LSB into small blocks
block_LSB = cell(block_num);
block_LSB = mat2cell( InImg_LSB, ones(block_num(1), 1) * block_size(1), ones(block_num(2), 1) * block_size(2) );

% Generate the watermarked LSB with block_LSB and block_traces
[ LSB_marked_original,  total_mean_traces, quant_mean_trace ] = handleLSB( InImg_zerolsb_blocked, block_LSB, quant_block_traces );
LSB_marked = bitxor( LSB_marked_original, WatermarkBinaryImg );

% Replacing LSB upon the original image generate the watermarked image
MarkedImg = replaceLSB( InImg_Scr, LSB_marked );


% Block-based Scrambling transformation 
% for 128 * 128 blocks, 96 is the period number
MarkedImg = ImgBlockArnold( MarkedImg, 66, block_size);

psnr( InImg, MarkedImg )


end

