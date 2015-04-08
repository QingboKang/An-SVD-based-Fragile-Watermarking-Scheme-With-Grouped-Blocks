function [ LSB_extract, quant_mean_trace_extract] = handleLSBExtract( InImg_zerolsb_blocked, block_LSB, calc_block_traces )
% block_LSB is the original eatermarked image's LSB which are blocked in
% ceil,  high-order
% calc_block_traces is the calculate watermarked block traces,
% Compare them to get the information whether the block are tampered
% write by kangqingbo at 2014.09.12

block_size = size( cell2mat( block_LSB(1, 1) ) );
block_num = size(block_LSB);

block_LSB_marked = cell(block_num);

%%%%
logistic_initial_value = zeros(block_num);
logistic_param = zeros(block_num);
logistic_sequence = cell(block_num);

total_mean_traces = zeros( block_num );

%%% 提取出的平均量化迹
quant_mean_trace_extract = zeros( block_num );
for r = 1 : block_num(1)
    for c = 1 : block_num(2)
        InImg_zerolsb_blockdata = cell2mat( InImg_zerolsb_blocked(r, c) );
        
        % 根据每块的数据取得均值标准差，生成混沌序列(长度16)
        mean_value = mean( InImg_zerolsb_blockdata(:) );
        std_value = std( InImg_zerolsb_blockdata(:), 0 );

        % 初始值
        logistic_initial_value(r, c) = (mean_value + 1)/257;
        % 参数
        logistic_param(r, c) =  3.5699456 + (std_value - floor(std_value)) * 0.43;
        
        logistic_sequence(r, c) = {logistic( logistic_initial_value(r, c), logistic_param(r, c), 16 )};
        % 重排列之后的索引，前10位认证本块，后6位为块集合认证数据区域
        [ index_realign ] = getSubsetsIndex( cell2mat( logistic_sequence(r, c) ) );
        
        % 取出含水印图像的LSB平面，利用求得的索引得到本地块认证数据区域
        original_bits_2d = cell2mat( block_LSB(r, c) );
        original_bits = reshape( original_bits_2d', 1, numel(original_bits_2d) );
            
        %%%% 取得其存储的平均量化迹
        average_trace_bits = zeros(1, 6);
        average_trace = 0;
        for k = 11 : 16
            average_trace_bits(1, k) = original_bits( index_realign(1, k) );
            average_trace = average_trace + average_trace_bits(1, k) * power(2, 16 - k);
        end
        quant_mean_trace_extract(r, c) = average_trace;
    end
end


[numberOfTimes] = handleQuantMeanTraceExtract(quant_mean_trace_extract);

        count = 0;
        count_mean = 0;
for r = 1 : block_num(1)
    for c = 1 : block_num(2)
        
        InImg_zerolsb_blockdata = cell2mat( InImg_zerolsb_blocked(r, c) );
        
        % 重排列之后的索引，前10位认证本块，后6位为块集合认证数据区域
        [ index_realign ] = getSubsetsIndex( cell2mat( logistic_sequence(r, c) ) );
        
        % 取出含水印图像的LSB平面，利用求得的索引得到本地块认证数据区域
        original_bits_2d = cell2mat( block_LSB(r, c) );
        original_bits = reshape( original_bits_2d', 1, numel(original_bits_2d) );
        
        block_trace_bits = zeros(1, 10);
        for k = 1 : 10
            block_trace_bits(1, k) = original_bits( index_realign(1, k) );
        end
        
        % using the bit sequence to get the decimal block's trace
        original_trace = 0;
        for k = 1 : 10
            original_trace = original_trace + block_trace_bits(k) * power(2, 10 - k);
        end
        
        calc_trace = calc_block_traces(r, c);
        trace_binary = char( dec2bin( calc_trace, 10));
        
        LSB_data_extract = zeros(block_size);
        
        %%%% 未通过本块数据认证
        if( calc_trace ~= original_trace )
            LSB_data_extract = abs(original_bits_2d - 1);
            count = count + 1;
            
        else
            %%%% 该块未通过相应块数据认证
            if ( numberOfTimes(r, c) == 1 || numberOfTimes(r, c) == 2  )
                LSB_data_extract = abs(original_bits_2d - 1);
                count_mean = count_mean + 1;
            else
                LSB_data_extract = original_bits_2d;
            end
        end
       
        block_LSB_marked(r, c) = {LSB_data_extract};
    end
end

count
count_mean
LSB_extract = cell2mat( block_LSB_marked );

end

