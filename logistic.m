function [ logistic_sequence ] = logistic( x1, param, length )
%  0 < x1 < 1   3.5699456 < param < 4

logistic_sequence = zeros(1, length);

logistic_sequence(1, 1) = x1;
for i = 2 : length
    logistic_sequence(1, i) = param * logistic_sequence(1, i-1) * ( 1 - logistic_sequence(1, i-1) );
end

end

