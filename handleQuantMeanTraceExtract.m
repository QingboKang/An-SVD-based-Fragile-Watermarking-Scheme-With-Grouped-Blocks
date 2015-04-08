function [ numberOfTimes ] = handleQuantMeanTraceExtract( quant_mean_trace_extract )
%HANDLEQUANTMEANTRACEEXTRACT Summary of this function goes here
%   Detailed explanation goes here

block_num = size( quant_mean_trace_extract );

% 转换为1行n列矩阵
quant_mean_trace_extract = reshape(quant_mean_trace_extract', 1, numel( quant_mean_trace_extract ));

numberOfTimes = zeros(1, numel( quant_mean_trace_extract ) );

for k = 1 : 5: numel(quant_mean_trace_extract)
    end_index = k + 4;
    if(end_index > numel(quant_mean_trace_extract))
        end_index = numel(quant_mean_trace_extract);
    end
    
    corresponding_traces = quant_mean_trace_extract(k : end_index);
    
    count = zeros(1, end_index + 1 - k);
    for m = 1 : end_index + 1 - k
        number = corresponding_traces(m);
        count(1, m) = numel( find(corresponding_traces == number) );
    end
    
    numberOfTimes(1, k: end_index) = count;
end

numberOfTimes = reshape(numberOfTimes, block_num);
numberOfTimes = numberOfTimes';

end

