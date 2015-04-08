%Arnoldtransf.m    Arnold±ä»»µÄº¯Êý
function Y=Arnoldtransf(x,y,N,m)
Y=[x,y];
for k=1:N
    t=x;
    x=mod(x+y,m);
    y=mod(t+2*y,m);
end
Y=[x,y];

