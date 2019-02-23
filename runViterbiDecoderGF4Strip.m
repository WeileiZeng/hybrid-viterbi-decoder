
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

  G=[1 2 2 1 0; 0 1 2 2 1; 1 0 1 2 2; 2 1 0 1 2; 2 2 1 0 1];
  rowG=size(G,1);
  G=[G,eye(rowG)];
 P=G;

% the classical convolutional code
% G =[1 1 0 1 1 1 0 0 0 0 0 0 0 0
%     0 0 1 1 0 1 1 1 0 0 0 0 0 0
%     0 0 0 0 1 1 0 1 1 1 0 0 0 0
%     0 0 0 0 0 0 1 1 0 1 1 1 0 0
%     0 0 0 0 0 0 0 0 1 1 0 1 1 1]

%comment: the construction of trellis takes most of the time(95%) of
%decoding. 

%from matrix generate  strip
% repeat = 33;
%  
%  P = matrix_generate_strip(repeat);
 [strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
% 
% tic
 trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
% disp('time to get trellisGF4Strip')
% toc

%[P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip]...
%    = getSavedTrellis(repeat);

%check run time
colP=size(P,2);
metric_vec_P_input=ones(1,colP);
%metric_vec_P_input(6:10)=-0.70000;% 0.501 for single qubit error, -0.7 for single syndrome bit error

flag_check=3;

switch flag_check
    case 0 %hard decision
      pq=0.05;ps=0.05;
      error_prob=Qtransfer*pq+(1-Qtransfer)*ps;
      metric_vec_P_input = - log10( error_prob./(1-error_prob) );
    case 1 %first qubit wrong
      pq=0.000000001;
      ps=0.599999;
      pq=0.05;ps=0.05;
      error_prob=Qtransfer*pq+(1-Qtransfer)*ps;
      error_prob(1)=0.9;
      metric_vec_P_input = - log10( error_prob./(1-error_prob) );
  case 2  %syndrome 9,10 wrong. (syndrome for first qubit error
      pq=0.05;ps=0.05;
      error_prob=Qtransfer*pq+(1-Qtransfer)*ps;
      error_prob(9)=0.9;
      error_prob(10)=0.9;
      metric_vec_P_input = - log10( error_prob./(1-error_prob) );
  case 3  %syndrome 9,10 wrong. (syndrome for first qubit error
      pq=0.05;ps=0.05;
      error_prob=Qtransfer*pq+(1-Qtransfer)*ps;
      error_prob(9)=0.19;
      error_prob(10)=0.19;
      metric_vec_P_input = - log10( error_prob./(1-error_prob) );
end

if 1
    errorInput=zeros(1,colP);
    %    errorInput(1)=1;
    errorInput(9)=1;
    errorInput(10)=1;
    %errorInput(i+1)=1;
    %    isGoodError = viterbiDecoderGF4Strip(...
    %   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);

    isGoodError = viterbiDecoderGF4StripSoft(...
        P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,    metric_vec_P_input);
    [0,isGoodError]
end

      
for i = 1:0
    tic
    errorInput=zeros(1,colP);
    errorInput(i)=1;
    %errorInput(i+1)=1;
    %    isGoodError = viterbiDecoderGF4Strip(...
    %   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);

    isGoodError = viterbiDecoderGF4StripSoft(...
        P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,    metric_vec_P_input);
    [i,isGoodError]
    %    time=toc
    %    time/repeat
    %break
end







