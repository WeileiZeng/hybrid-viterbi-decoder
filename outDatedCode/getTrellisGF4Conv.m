%outdated, bad performance in runtime
% Weilei Zeng, 07/19/2018
% construct syndrome trellis for GF(4) block codes
% input: parity check matrix G=[g1;g2;g3;...] 
%        numInputSymbols=[f1 f2 f3 ...]
% output: trellisGF4 for GF(4) convolutional code

% syndrome s^T=G*(e^T)  s=[s1;s2;s3;...] is a column vector
% syndrome state follow the same format of syndrome s. The converson
% between binary vector representation and decimal number representation is d=bi2de(s,r)  s=bi2de(d)




% 


% example input 1: the perfect five qubit code, shift of XZZXI  1ww10
%parity check matrix
%G=[1 2 2 1 0; 0 1 2 2 1; 1 0 1 2 2; 2 1 0 1 2];

%example input 2: terminated convolutional code [1 1 1 1 w W]
%G=[1 1 1 1 2 3 0 0 0; 0 0 0 1 1 1 1 2 3];


% [r,n]=size(G);%r=n-k
% %numInputSymbols = 4; % 4 for GF(4)
% numInputSymbols =ones(1,n)*4; %number of input could be different for each bit/qubit.
% %2 for bit and 4 for qubit


%example input 3: terminated convolutional code [1 1 1 1 w W] with syndrome
%error
% G=[1 1 1 1 2 3 0 0 0 1 0; 0 0 0 1 1 1 1 2 3 0 1];
% numInputSymbols = [ 4 4 4 4 4 4 4 4 4 2 2];
% 
% G=[1 1 1 1 0 1 2 3 0 0 0 ; 0 0 0 0 1 1 1 1 1 2 3 ];
% numInputSymbols = [ 2 4 4 4 2 4 4 4 4 4 4 ];
% G=[  1     0     0     0     0     0
%      1     0     0     0     0     0
%      0     0     0     0     0     0
%      0     0     0     0     0     0
%      1     0     0     0     0     0
%      0     0     0     0     0     0
%      1     0     0     0     0     0
%      1     0     0     0     0     0
%      1     1     2     3     0     0
%      1     0     0     0     0     0
%      1     0     0     0     0     0
%      0     1     1     1     0     0
%      0     0     0     0     1     0
%      0     0     0     0     0     1];
% 
% numInputSymbols = [2 4 4 4 2 2]

function trellisGF4Conv = getTrellisGF4Conv( ...
    header,numInputSymbolsHeader, tail,numInputSymbolsTail, ...
    G,numInputSymbolsG,iteration,shiftLength)
%iteration: times to repeat G block, it is less than 'repeat' ,
%iteration=repeat-v
%shiftLength:the lost of memory in each shiflt of G block
trellisGF4Conv =cell(1,iteration+2);
trellisHeader = getTrellisGF4(header,numInputSymbolsHeader);
trellisGF4Conv{1}=trellisHeader;
lastState=trellisHeader.stateIsOccupied(:,end);%initial state for next round
initialState=zeros(2^size(G,1),1);
initialState(1:size(lastState,1))= lastState;
for i=1:iteration
    trellisG=getTrellisGF4(G,numInputSymbolsG,initialState);
    lastState=trellisG.stateIsOccupied(:,end);
    initialState=last2initial(lastState,shiftLength,2^size(G,1));
    trellisGF4Conv{i+1}=trellisG;
end

tempState=initialState;
initialState=zeros(2^size(tail,1),1);
initialState(1:size(tempState,1))= tempState;

trellisTail=getTrellisGF4(tail,numInputSymbolsTail,initialState);
trellisGF4Conv{iteration+2}=trellisTail;

end

        
function initialState = last2initial(lastState,shiftLength,initialStateLength)
%1 means occupied, and 0 otherwise
%only those in the lastStates, whose positions to lose refer to zero state
%will be transimitted into the inital state in the next layer
    %initialStateLength=size(lastState,1)=2^(size(G,1);
    initialState=zeros(initialStateLength,1);
    for i = 1:initialStateLength/(2^shiftLength)
        state=i-1;
        j=state*(2^shiftLength)+1;
        initialState(i)=lastState(j);
    end    
end