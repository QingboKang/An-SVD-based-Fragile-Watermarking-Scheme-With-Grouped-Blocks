function [ mean_trace ] = getCorrespondingTraceMeanValue( block_traces, r, c )
%GETCORRESPONDINGTRACEMEANVALUE Summary of this function goes here
%   Detailed explanation goes here

block_num = size(block_traces);
lengthofblock = block_num(2) * (r-1) + c;

temp_block_traces = block_traces;
start_index = floor( (lengthofblock-1) / 5 ) * 5 + 1;
end_index = ceil( lengthofblock / 5 ) * 5;

if(end_index > (block_num(1) * block_num(2)) )
    end_index = (block_num(1) * block_num(2));
end

temp_block_traces = reshape(temp_block_traces', 1, numel(temp_block_traces));


sum_trace = sum( temp_block_traces(start_index : end_index) );

mean_trace = round(sum_trace/(end_index + 1 - start_index) );


end

