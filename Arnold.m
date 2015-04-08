% Arnold置乱 图像
% inputimg -- 输入图像
% count -- 置乱次数
function OUTIMG = Arnold(inputimg, count)

[m, n] = size(inputimg);   % 输入图像大小
OUTIMG = zeros(m, n);
for i = 0 : m - 1
    for j = 0 : n - 1
        Y = Arnoldtransf(i, j, count, m);
        OUTIMG(m - Y(1), Y(2) + 1) = inputimg(m - i, j + 1);
    end
end
