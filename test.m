t = poly2trellis([3 3],[4 5 7;7 4 2]);  
k = log2(t.numInputSymbols);
msg = [1 1 0 1 1 1 1 0 1 0 1 1 0 1 1 1];
%msg = bitxor(msg,ones(1,size(msg,2)))
code = convenc(msg,t);    tblen = 3;
code;
[d1 m1 p1 in1]=vitdec(code(1:end/2),t,tblen,'cont','hard')
[d2 m2 p2 in2]=vitdec(code(end/2+1:end),t,tblen,'cont','hard',m1,p1,in1);
[d m p in] = vitdec(code,t,tblen,'cont','hard')


% The same decoded message is returned in d and [d1 d2].  The pairs m and
% m2, p and p2, in and in2 are equal.  Note that d is a delayed version of
% msg, so d(tblen*k+1:end) is the same as msg(1:end-tblen*k).





 