function [ LSB_marked, total_mean_traces, quant_mean_trace] = handleLSB( InImg_zerolsb_blocked, block_LSB, block_traces )
% Handle the input image's LSB small blocks, do some operations
% block_LSB is the LSB blocked data(ceil)
% block_traces is 2-D double matrix, and all values are map to [0 1023]
% one element of LSB block matches to one element of traces

block_size = size( cell2mat(block_LSB(1, 1)) );
block_num = size(block_LSB);

block_LSB_marked = cell(block_num);

total_mean_values = zeros(block_num);
total_std_values = zeros(block_num);
logistic_initial_value = zeros(block_num);
logistic_param = zeros(block_num);
logistic_sequence = cell(block_num);

total_mean_traces = zeros( block_num );
quant_mean_trace = zeros( block_num );
for r = 1 : block_num(1)
    for c = 1 : block_num(2)
         
        % �õ��ٽ�5����ļ�ƽ��ֵ
        [mean_trace] = getCorrespondingTraceMeanValue( block_traces, r, c );       
        total_mean_traces(r, c) = mean_trace;
    end
end

for r = 1 : block_num(1)
    for c = 1 : block_num(2)
        LSB_data = cell2mat( block_LSB(r, c) );
        InImg_zerolsb_blockdata = cell2mat( InImg_zerolsb_blocked(r, c) );
        
        
        % ����ÿ�������ȡ�þ�ֵ��׼����ɻ�������(����16)
        mean_value = mean( InImg_zerolsb_blockdata(:) );
        std_value = std( InImg_zerolsb_blockdata(:), 0 );
        
        total_mean_values(r, c) = mean_value;
        total_std_values(r, c) = std_value;
        % ��ʼֵ
        logistic_initial_value(r, c) = (mean_value + 1)/257;
        % ����
        logistic_param(r, c) =  3.5699456 + (std_value - floor(std_value)) * 0.43;
        
        logistic_sequence(r, c) = {logistic( logistic_initial_value(r, c), logistic_param(r, c), 16 )};
        % ������֮���������ǰ10λ��֤���飬��6λΪ�鼯����֤��������
        [ index_realign ] = getSubsetsIndex( cell2mat( logistic_sequence(r, c) ) );
        
        % get trace and its binary format, which have 10 bits
        trace = block_traces(r, c);
        trace_binary = char( dec2bin( trace, 10));
        
        LSB_data = reshape(LSB_data', 1, numel(LSB_data));
        LSB_data(:) = 0;
        for k = 1:10
            LSB_data( index_realign(1, k)  ) = trace_binary(k) - 48;
        end
        
        % ��ƽ����������[0 63]
        quant_mean_trace(r, c) =  floor( mod(total_mean_traces(r, c), 64) );
        quant_mean_trace_binary = char( dec2bin(  quant_mean_trace(r, c), 6));
        
        for k = 11: 16
            LSB_data( index_realign(1, k)  ) = quant_mean_trace_binary(k - 10) - 48;
        end
        
      %  LSB_data( 1: 10) = trace_binary - 48;
        LSB_data = reshape(LSB_data, block_size);
        LSB_data = LSB_data';
        
        block_LSB_marked(r, c) = {LSB_data};

    end
end

LSB_marked = cell2mat(block_LSB_marked);


end

