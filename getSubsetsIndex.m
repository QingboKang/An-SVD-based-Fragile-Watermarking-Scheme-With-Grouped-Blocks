function [ index_realign ] = getSubsetsIndex( block_logistic_sequence )
% 根据一个分块的混沌序列(16)的大小关系，将其重新排列，由大到小

sequence = block_logistic_sequence;

block_length = numel(sequence);

index_realign = zeros(1, block_length);
for c = 1 : block_length
    max_index = find( sequence == max(sequence) );
    sequence(max_index) = -1;
    
    index_realign(1, c) = max_index;
end


end

