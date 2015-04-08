function [ index_realign ] = getSubsetsIndex( block_logistic_sequence )
% ����һ���ֿ�Ļ�������(16)�Ĵ�С��ϵ�������������У��ɴ�С

sequence = block_logistic_sequence;

block_length = numel(sequence);

index_realign = zeros(1, block_length);
for c = 1 : block_length
    max_index = find( sequence == max(sequence) );
    sequence(max_index) = -1;
    
    index_realign(1, c) = max_index;
end


end

