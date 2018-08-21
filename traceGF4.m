% return trace of two GF(4) numbers, as defined in Forney's paper
% 0 mean commute, and 1 otherwise

function t = traceGF4(x,y)
    if x == 0
        t=0;
    elseif y == 0
        t=0;
    elseif x ==y
        t=0;
    else
        t=1;
    end
end