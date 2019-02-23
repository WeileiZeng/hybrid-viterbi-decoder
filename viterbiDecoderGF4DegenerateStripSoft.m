%Weilei Zeng, Feb 19, 2019
% add P_dual to check if the remained error is trivial or not.

% Weilei Zeng, 07/19/2018
% soft decision decoding
% viterbi decoding for hybrid convolutional code (quantum and classical).
% use trellisGF4 defined by Weilei Zeng.

function [isGoodError,errorRemained] = viterbiDecoderGF4DegenerateStripSoft(...
    P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,...
    errorInput,metric_vec_P_input,P_dual)
%return 1 for fully-detected good error and 0 otherwise


metric_vec_P = measureP(P,errorInput,Ptransfer,Qtransfer,numInputSymbols,metric_vec_P_input);

%initialize
numLayers = size(trellisGF4Strip,2);
trellisGF4=trellisGF4Strip{1};
metric = zeros(trellisGF4.numStates,1)-numLayers; %-trellisGF4.numLayers for some non-exist path 
path  = zeros(trellisGF4.numStates,trellisGF4.numLayers)-1; %-1 for some non-exist path
pathMetricCell = cell(4,numLayers); %rows: shiftLength,pathLength,Path[]
 %initialize
 layer=1;
for i = 1:trellisGF4.numStates  

    if trellisGF4.stateIsOccupied(i,layer)       %run over all occupied current state
        currentState = i-1; %use a number to represent the binary syndrome vector
        %currentStateVec=(de2bi(currentState,r)); %the right most has the higest order in the binary vector, refer to the bottom row in the parity check matrix  

        for j = 1:trellisGF4.numInputSymbols(layer)  % and over all possible input
            input = j-1;
            metric_temp = getMetric(input,1,metric_vec_P);
            nextState=trellisGF4.nextStatesCell{1}(currentState+1,input+1);

            if metric_temp > metric(nextState+1) %find path with maximum metric
                path(nextState+1,1)=input;
                metric(nextState+1)=metric_temp;
            end
        
        end
    end
end
shiftLength=0;

pathMetricCell{1,1}=shiftLength;
pathMetricCell{3,1}=path;
pathMetricCell{4,1}=metric;



%going through the path and find the path with maximum metric
for layer = 2:numLayers
    %initialize/clear data
    trellisGF4=trellisGF4Strip{layer};
    shiftLength=strip(1,layer)-strip(1,layer-1);
    initialMetric = last2initialMetric(metric,shiftLength,trellisGF4.numStates); %shift the last metric to match the curent Length
    currentMetric = zeros(size(initialMetric,1),1)-numLayers; %save metric in this layer
    
    %new_metric = zeros(trellisGF4.numStates,1)-trellisGF4.numLayers;
    new_path  = zeros(trellisGF4.numStates,trellisGF4.numLayers)-1;
      
   
    %nextStates=trellisGF4.nextStatesCell{layer};
    for i = 1:trellisGF4.numStates  

        if trellisGF4.stateIsOccupied(i,1)       %run over all occupied current state
            currentState = i-1; %use a number to represent the binary syndrome vector
            %currentStateVec=(de2bi(currentState,r)); %the right most has the higest order in the binary vector, refer to the bottom row in the parity check matrix  

            for j = 1:numInputSymbols(layer)  % and over all possible input
                input = j-1;
                metric_temp = getMetric(input,layer,metric_vec_P);
                nextState=trellisGF4.nextStatesCell{1}(currentState+1,input+1);
                metric_temp=initialMetric(currentState+1)+metric_temp;
                
                
                if  nextState > -1 & trellisGF4.stateIsOccupied(nextState+1,2) == 1 ...
                        & metric_temp > currentMetric(nextState+1) %find path with maximum metric
                    
                    %disp([metric_temp,new_metric(nextState+1)])
                    %update metric and path
                    error = getError(input,layer,metric_vec_P);
                    new_path(nextState+1,1)=error;
                    %new_path(nextState+1,1:(layer-1)) = path(currentState+1,1:(layer-1));
                    currentMetric(nextState+1)=metric_temp;
                end
                
            end
        end
    
    end
    %update info for this layer
    path=new_path;
    metric=currentMetric;
%     if (size(path,1) == -sum(path))
%         disp(['WRONG PATH when layer = ',num2str(layer)])
%     end
    
    pathMetricCell{1,layer}=shiftLength;
    %pathMetricCell{2,layer}=pathLength;
    pathMetricCell{3,layer}=path;
    pathMetricCell{4,layer}=metric;

    %check
%     if layer == 37
%         path37 = path;
%     end
end

%save pathMetricCell

%pause

%track back the decoded error
errorDetected=zeros(1,numLayers)-1;
finalState=0;
for i = 2:numLayers
    layer=numLayers-i+2;
%     top = strip(1,layer);
%     bottom = strip(2,layer);
    
    path=pathMetricCell{3,layer};
    error=path(finalState+1);
    trellisGF4 = trellisGF4Strip{layer};
    previousStates =trellisGF4.previousStatesCell{1};
%       finalState
%       error
    previousState = previousStates(finalState+1,getError(error,layer,metric_vec_P)+1);
    errorDetected(layer) = error;
    shiftLength=strip(1,layer)-strip(1,layer-1);
  %  shiftLength
    finalState = previous2final(previousState,shiftLength);

    %check
    %    layer,path,error,previousStates ,previousState,finalState
%    pause
end

%the first layer/error
layer=1;    
path=pathMetricCell{3,layer};
error=path(finalState+1);
%trellisGF4 = trellisGF4Strip{layer};
%previousStates =trellisGF4.previousStatesCell{1};
%previousState = previousStates(finalState+1,getError(error,layer,metric_vec_P)+1);
errorDetected(layer) = error;
%shiftLength=0;
%finalState = previous2final(previousState,shiftLength);
% path,error,previousStates,previousState,finalState

%errorMap = errorDetected+errorInput;
%errorDetected  = totalError2QubitError(errorDetected,Qtransfer)
%errorRemained=bitxor(errorDetected,errorInput);
errorRemained=plusGF4vec(errorDetected,errorInput);

errorRemained = totalError2QubitError(errorRemained,Qtransfer);
%totalNumberOfErrorRemained = sum(errorRemained);
%disp('notation in errormap => 1: remained error; 2: fixed error')





if sum(abs(errorRemained)) %nonzero error
    isGoodError = 0;
    %check if errorRemained is a trivial error in the stabilzier group
    %a trivial error in stabilizer group commute with all codeword, but a code doesn't commute with at least one other codeword.
    dual_syndrome=measure(P_dual,errorRemained,numInputSymbols);
    if sum(dual_syndrome)==0 %is a trivial error
        isGoodError=1;
        errorRemained=errorRemained*0;
    end
else
    isGoodError = 1;
end


end

function metric = getMetric(input,layer,metric_vec)
%return 'weight'/metric of input qubit/bit
% In metric_vec use 1, -1 for hard decision, use Log(1-p)/p for soft
% decision
    if input ==0
        %metric=1; %weight 0
        metric = metric_vec(layer);
    else
        %metric=-1; %weight 1
        metric = -metric_vec(layer);
    end
end

function error = getError(input,layer,metric_vec)
%return the right error for this branch: flip the input when the syndrome
%is 1
    if metric_vec(layer)>0
            error = input;
    else  %flip the error
        if input > 1  %qubit error
                      %            disp('decoder: only 0/1 input for syndrome bit, no input for qubits')
            error = input;
        else %syndrome bit
            error = 1-input;    
        end
        
    end


    
end


function syndrome = measure(G,error,numInputSymbols) %GF4 and GF2; 
%from parity check matrix G and row vector error e, calculate the row vector syndrome
%this doesnot work for GA, need the next function measureP
    
    syndrome = zeros(1,size(G,1));
    ss=G;
    for i =1:size(G,1)
        for j = 1:size(G,2)
            switch numInputSymbols(j)
                case 4  %qubit error
                    ss(i,j)=traceGF4(G(i,j),error(j));
                case 2  %syndrome error
                    ss(i,j) = G(i,j)*error(j);
            end
        end
        temp_sum = sum(ss(i,:));
        syndromebit = temp_sum - floor(temp_sum/2)*2;
        syndrome(i)=syndromebit;
    end
end

function mixMetric = measureP(P,errorInput,Ptransfer,Qtransfer,numInputSymbols,metric_vec_P_input)
%calculate qubit error and syndrome error independently and return the
%metricVec
  
    qubitError = errorInput.*( 1-Qtransfer );
    syndromeError = errorInput.*( Qtransfer );
    syndrome_G = measure(P,qubitError,numInputSymbols);
    metric_G=syndrome2metric_vec_P(syndrome_G,Ptransfer);
    error_sG = (metric_G-1)/(-2); % convert 1 -1 to 0 1
    syndrome_A = measure(P,error_sG,numInputSymbols);
    
    
    metric_A=syndrome2metric_vec_P(syndrome_A,Ptransfer);
    error_sA = (metric_A-1)/(-2);
    mixError = bitxor(error_sA , syndromeError);%only syndrome error
    
    %mixMetric = -(mixError*2-1);%for hard decision decoding
    
    %soft decision decoding. when metric_vec_P_input is an even vector, it
    %goes back to hard decision decoding
    mixMetric = metric_vec_P_input;
    for i =1:size(mixMetric,2)
       if mixError(i)
           mixMetric(i) = -mixMetric(i);
       end
    end
    
end


function metric_vec =syndrome2metric_vec_P(syndrome,Ptransfer)
%apply syndrome result to the correspoing columns in metric_vec_P,
%according to Ptransfer
    [rowP,colP]=size(Ptransfer);
    %colP=size(syndrome,2);
%     size(syndrome)
% size(    Ptransfer)
    metric01 = syndrome*Ptransfer;
    metric_vec = ones(1,colP);
    for i =1:colP
        if metric01(i) %if get this syndrome
            metric_vec(i)=-1;
        end
    end
    
end

function qubitError = totalError2QubitError(totalError,Qtransfer)
    qubitError = totalError;
    for i=1:size(totalError,2)
        if Qtransfer(i)
            qubitError(i)=0;
        end
    end
end

function initial_metric = last2initialMetric(last_metric,shiftLength,numStates)
%1 means occupied, and 0 otherwise
%only those in the lastStates, whose positions to lose refer to zero state
%will be transimitted into the inital state in the next layer
    %initialStateLength=size(lastState,1)=2^(size(G,1);
    %shift length in binary
    initial_metric=zeros(numStates,1)-1;
    numLastState=size(last_metric,1);
    for i_initial = 1:numLastState/(2^shiftLength)
        initialState=i_initial-1;
        lastZeroState=initialState*(2^shiftLength)+1;
        initial_metric(i_initial)=last_metric(lastZeroState);
    end    
end

function finalState = previous2final(previousState,shiftLength)%,shiftSyndrome)
%1 means occupied, and 0 otherwise
%only those in the lastStates, whose positions to lose refer to zero state
%will be transimitted into the inital state in the next layer
    %initialStateLength=size(lastState,1)=2^(size(G,1);
    %shift length in binary
    finalState = previousState*(  2^shiftLength ); 
%    finalState = finalState + shiftSyndrome;
end










