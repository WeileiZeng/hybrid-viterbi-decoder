% 08/03/2018  outdated, bad performance in rumtime
% Weilei Zeng, 07/19/2018
% viterbi decoding for data syndrome code.
% use trellisGF4 defined by Weilei Zeng.

%input: blockg blockI G
%value from matrix generate 3
iteration=repeat-(va-1); %number of G block
shiftLength=(na+1)*2;
numInputSymbolsG = [4 4 4 2 2 2 2 2 2]
metric_vec_G = [1 1 1 1 1 1 1 1 1]
%G=P;
%numInputSymbols_G=kron(ones(1,repeat),numInputSymbols_G);
%metric_vec_G = kron(ones(1,repeat),metric_vec_G);

%numInputSymbols_G=[[4*ones(1,n*(v-1)) 2*ones(1,2*na*(va-1))] numInputSymbols_G];
%metric_vec_G=[  ones(1,n*(v-1)+na*(va-1))  metric_vec_G];


header=[ [blockg; zeros(size(blockI,1)-size(blockg,1),size(blockg,2)) ]      blockI];
numInputSymbolsHeader = [4*ones(1,n*(v-1)) 2*ones(1,2*na*(va-1))];

rowTail=na*2*(va-1)+(na+1)*2*(va-1);
colTail=(va-1)*size(G,2);
tail = P( end-rowTail+1:end,end-colTail+1:end); 
numInputSymbolsTail=kron(ones(1,va-1),numInputSymbolsG);

trellisGF4Conv = getTrellisGF4Conv( ...
    header,numInputSymbolsHeader, tail,numInputSymbolsTail, ...
    G,numInputSymbolsG,iteration,shiftLength);

% G =[1 1 0 1 1 1 0 0 0 0 0 0 0 0
%     0 0 1 1 0 1 1 1 0 0 0 0 0 0
%     0 0 0 0 1 1 0 1 1 1 0 0 0 0
%     0 0 0 0 0 0 1 1 0 1 1 1 0 0
%     0 0 0 0 0 0 0 0 1 1 0 1 1 1]
% numInputSymbols = ones(1,size(G,2))*2;
% metric_vec = ones(1,size(G,2));

 
%G=[1 1 0 0;0 1 1 0;0 0 1 1];
%numInputSymbols=[2 2 2 2];


% %flip test
% G=fliplr(G);
% numInputSymbols = fliplr(numInputSymbols);



trellisGF4 = getTrellisGF4(G,numInputSymbolsG);

%trellisGF4_2 = getTrellisGF4Conv(G,numInputSymbols,trellisGF4.stateIsOccupied(:,15));


% %sample error
%  error = [1 3 1 0 0 0 0 0 0 0]
%   error = [3 3 0 1 0 0 0 0 0 0]
%   %error = [0 0 1 0 0 0 0 0 0 0]
%  syndrome = measure(G,error,numInputSymbols)
%  bi2de(syndrome)
 
%  s=[-1 -1 1 1 1]
%  metric_vec = [1 1 1 1 1 s];
 
%initialize
metric = zeros(trellisGF4.numStates,1)-trellisGF4.numLayers; %-trellisGF4.numLayers for some non-exist path 
path  = zeros(trellisGF4.numStates,trellisGF4.numLayers)-1; %-1 for some non-exist path



%trellisGF4=trellisGF4;

 %initialize
 layer=1;
%nextStates=trellisGF4.nextStatesCell{layer};
for i = 1:trellisGF4.numStates  

    if trellisGF4.stateIsOccupied(i,layer)       %run over all occupied current state
        currentState = i-1; %use a number to represent the binary syndrome vector
        %currentStateVec=(de2bi(currentState,r)); %the right most has the higest order in the binary vector, refer to the bottom row in the parity check matrix  

        for j = 1:trellisGF4.numInputSymbols(layer)  % and over all possible input
            input = j-1;
            metric_temp = getMetric(input,1,metric_vec_G);
            nextState=trellisGF4.nextStatesCell{layer}(currentState+1,input+1);

            
            if metric_temp > metric(nextState+1) %find path with maximum metric
                    %disp([metric_temp,new_metric(nextState+1)])
                    %update metric and path
%                     new_path(nextState+1,layer)=input;
%                     new_path(nextState+1,1:(layer-1)) = path(currentState+1,1:(layer-1));
%                     new_metric(nextState+1)=metric_temp;

                path(nextState+1,layer)=input;
                metric(nextState+1)=metric_temp;

            end
            
            
        end
    end
end
metric;
path;

for layer = 2:trellisGF4.numLayers
    layer;
    %initialize/clear data
    new_metric = zeros(trellisGF4.numStates,1)-trellisGF4.numLayers;
    new_path  = zeros(trellisGF4.numStates,trellisGF4.numLayers)-1;
    
    
    %nextStates=trellisGF4.nextStatesCell{layer};
    for i = 1:trellisGF4.numStates  

        if trellisGF4.stateIsOccupied(i,layer)       %run over all occupied current state
            currentState = i-1; %use a number to represent the binary syndrome vector
            %currentStateVec=(de2bi(currentState,r)); %the right most has the higest order in the binary vector, refer to the bottom row in the parity check matrix  

            for j = 1:trellisGF4.numInputSymbols(layer)  % and over all possible input
                input = j-1;
                metric_temp = getMetric(input,layer,metric_vec_G);
                nextState=trellisGF4.nextStatesCell{layer}(currentState+1,input+1);
                metric_temp=metric(currentState+1)+metric_temp;
                if metric_temp > new_metric(nextState+1) %find path with maximum metric
                    %disp([metric_temp,new_metric(nextState+1)])
                    %update metric and path
                    new_path(nextState+1,layer)=input;
                    new_path(nextState+1,1:(layer-1)) = path(currentState+1,1:(layer-1));
                    new_metric(nextState+1)=metric_temp;
                end
                

            end
        end
    
    end
    %update info for this layer
    path=new_path;
    metric=new_metric ;
end

metric;
temp = ([path,(0:trellisGF4.numStates-1)']);
disp("decoded error for this syndrome")
path(1,1:end)

toc

function metric = getMetric(input,layer,metric_vec)
%return 'weight'/metric of input qubit/bit
% In metric_vec use 1, -1 for hard decision, use Log(1-p)/p for soft
% decision
    if input ==0
        %metric=1; %weight 0
        %if metric_vec[layer]=
        metric = metric_vec(layer);
    else
        %metric=-1; %weight 1
        metric = -metric_vec(layer);
    end
end


function syndrome = measure(G,error,numInputSymbols) %GF4 and GF2
%from parity check matrix G and row vector error e, calculate the row vector syndrome
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















