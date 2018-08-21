
%example input 2: terminated convolutional code [1 1 1 1 w W]

% g1=[1 1 1;2 2 2 ; 1 3 2; 2 1 3];g2=[ 1 2 3; 2 3 1 ; 0 0  0;0 0 0];
% gr=2;
% G=[kron(eye(gr),g1),zeros(gr*4,3)]+[zeros(gr*4,3) kron(eye(gr),g2)];
% numInputSymbols=ones(1,size(G,2))*4;
% metric_vec=ones(1,size(G,2));
% 

% % example input 1: the perfect five qubit code, shift of XZZXI  1ww10
% %parity check matrix
 % G=[1 2 2 1 0; 0 1 2 2 1; 1 0 1 2 2; 2 1 0 1 2];
%  numInputSymbols=ones(1,size(G,2))*4;
 
%  % example input 1-2: the perfect five qubit code, shift of XZZXI  1ww10
% %parity check matrix with one extra row
%  G=[1 2 2 1 0; 0 1 2 2 1; 1 0 1 2 2; 2 1 0 1 2; 2 2 1 0 1];
%  numInputSymbols=ones(1,size(G,2))*4;
 
%  % example input 1-2: the perfect five qubit code, shift of XZZXI  1ww10
% %parity check matrix with one extra row and syndrome error bits

%  G=[1 2 2 1 0; 0 1 2 2 1; 1 0 1 2 2; 2 1 0 1 2; 2 2 1 0 1];
%  rowG=size(G,1);
%  G=[G,eye(rowG)];
% 

% the classical convolutional code
% G =[1 1 0 1 1 1 0 0 0 0 0 0 0 0
%     0 0 1 1 0 1 1 1 0 0 0 0 0 0
%     0 0 0 0 1 1 0 1 1 1 0 0 0 0
%     0 0 0 0 0 0 1 1 0 1 1 1 0 0
%     0 0 0 0 0 0 0 0 1 1 0 1 1 1]

%comment: the construction of trellis takes most of the time(95%) of
%decoding. 

%from matrix generate  strip
 repeat = 33;
%  
%  P = matrix_generate_strip(repeat);
% [strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
% 
% tic
% trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
% disp('time to get trellisGF4Strip')
% toc

[P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip]...
    = getSavedTrellis(repeat);

%check run time
colP=size(P,2);
for i = 1:5
    tic
    errorInput=zeros(1,colP);
    errorInput(i)=1;
    %errorInput(i+1)=1;
    isGoodError = viterbiDecoderGF4Strip(...
        P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
    [i,isGoodError]
    time=toc
    time/repeat
    %break
end







