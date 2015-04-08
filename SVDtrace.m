function [ traces ] = SVDtrace( data )
%SVDTRACE Summary of this function goes here
%   Detailed explanation goes here
data = double(data);
for i = 0:255
    data(1, 1)= i;
    [U S V] = svd(data);
    traces = trace(S)
end

end

