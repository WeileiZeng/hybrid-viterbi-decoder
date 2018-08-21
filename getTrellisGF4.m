% Weilei Zeng, 07/19/2018
% construct syndrome trellis for GF(4) block codes
% input: parity check matrix G=[g1;g2;g3;...] 
%        numInputSymbols=[f1 f2 f3 ...]
% output: trellisGF4

% syndrome s^T=G*(e^T)  s=[s1;s2;s3;...] is a column vector
% syndrome state follow the same format of syndrome s. The converson
% between binary vector representation and decimal number representation is d=bi2de(s,r)  s=bi2de(d)


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

function trellisGF4 = getTrellisGF4( G,numInputSymbols,initialState,shiftLength)

[r,n]=size(G);  %r=n-k
numStates = 2^r; %all states for syndrome. syndrome is always a bit of 0 or 1
numLayers = n;
nextStatesCell=cell(1,numLayers);
previousStatesCell=cell(1,numLayers);
stateIsOccupied=zeros(numStates,numLayers+1);

if nargin == 4
    %start from given state   
    stateIsOccupied(:,1)=initialState;
else
    %start from zero state
    stateIsOccupied(1,1)=1; %1 means occupied, and 0 otherwise
end

for layer = 1:numLayers
    %initialize/clear data
    nextStates=zeros(numStates,numInputSymbols(layer))-1; %-1 for no current state
    previousStates=zeros(numStates,numInputSymbols(layer))-1;
    for i = 1:numStates  
        if stateIsOccupied(i,layer)       %run over all occupied current state
            currentState = i-1; %use a number to represent the binary syndrome vector
            currentStateVec=(de2bi(currentState,r)); %the right most has the higest order in the binary vector, refer to the bottom row in the parity check matrix  

            for j = 1:numInputSymbols(layer)  % and over all possible input
                input = j-1;
                gainVec = getGainVec(numInputSymbols(layer),input,G(:,layer)); %multiply the first column, return a number
                nextStateVec=bitxor(currentStateVec,gainVec);
                nextState=bi2de(nextStateVec);
                %if shiftLength >0, the output state will lose some memory
                %in the next layer. In our decoding method, those losing
                %bits must be zero. Becasue in the trellis disgram, all
                %paths start from zeor state and end in zero state. For
                %usual block code, shiftLength = 0.
                if shiftLength
                    if mod(nextState,2^shiftLength) ==0
                        %good and save
                        nextStates(currentState+1,input+1)=nextState;
                        stateIsOccupied(nextState+1,layer+1)=1;
                        previousStates(nextState+1,input+1)=currentState;
                    else
                        %ignore this state
                    end
                else
                    %good and save
                    nextStates(currentState+1,input+1)=nextState;
                    stateIsOccupied(nextState+1,layer+1)=1;
                    previousStates(nextState+1,input+1)=currentState;
                end                 
            end
        end
    end
    %update info for this layer
    nextStatesCell{layer}=nextStates;    
    previousStatesCell{layer}=previousStates; 
end

trellisGF4=struct();
trellisGF4.numStates=numStates;
trellisGF4.numInputSymbols=numInputSymbols;
trellisGF4.numLayers = numLayers; % = size(nextStatesCell,2)
trellisGF4.nextStatesCell=nextStatesCell;
trellisGF4.previousStatesCell=previousStatesCell;
trellisGF4.stateIsOccupied=stateIsOccupied;

% selfCheck(stateIsOccupied,nextStates,previousStates)
end

function gainvec = getGainVec(numInputSymbols,input,vec) 
%input and vec in GF(4) or GF(2), both return a binary syndrome vector
% gain is this column vec's contribution to syndrome result     
    switch numInputSymbols
        case 4 % use trace product for GF4 qubit
            length = size(vec,1); %vec is a column vector in parity check matrix G
            gainvec=zeros(1,length);
            for i =1:length
                gainvec(i)=traceGF4(input,vec(i));                
            end
        case 2 %binary syndrom bit
            gainvec = (input*vec)'; %return a row vector
    end
            
end
        

function selfCheck(stateIsOccupied,nextStates,previousStates)
%check if the definition of nextStates and previouseStates are right
%so far the result is good
%method: going back and forth in those two matrix and check if return to
%the same states.
    numStates=size(nextStates,1);
    for i =1:numStates
        currentState=i-1;
        
        if stateIsOccupied(currentState+1,1)
            for input=0:size(nextStates,2)-1           
    %            currentState
                nextState=nextStates(currentState+1,input+1);
                if nextState >-1
                    previousState=previousStates(nextState+1,input+1);
                    if previousState == currentState 
     %                   disp('GOOD')
                    else
                        disp('WRONG STATES!')
                    end
                end
            end
        end
    end
end



