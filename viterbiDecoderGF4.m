% not sure what i am doing here, this may be applicale for any block codes.
% Weilei Zeng, 07/19/2018
% viterbi decoding for quantum block code.
% use trellisGF4 defined by Weilei Zeng.

%example input 2: terminated convolutional code [1 1 1 1 w W]
% G=[1 1 1 1 2 3 0 0 0; 0 0 0 1 1 1 1 2 3];
% g1=[1 1 1; 1 3 2];g2=[ 1 2 3;0 0 0];
% gr=5;
% G=[kron(eye(gr),g1),zeros(gr*2,3)]+[zeros(gr*2,3) kron(eye(gr),g2)];
% numInputSymbols=ones(1,size(G,2))*4;
% metric_vec=ones(1,size(G,2));

% g1=[1 1 1;2 2 2 ; 1 3 2; 2 1 3];g2=[ 1 2 3; 2 3 1 ; 0 0  0;0 0 0];
% gr=2;
% G=[kron(eye(gr),g1),zeros(gr*4,3)]+[zeros(gr*4,3) kron(eye(gr),g2)];
% numInputSymbols=ones(1,size(G,2))*4;
% metric_vec=ones(1,size(G,2));

% g1=[1 1 1;2 2 2 ];g2=[ 1 2 3; 2 3 1];
% gr=5;
% G=[kron(eye(gr),g1),zeros(gr*size(g2,1),3)]+[zeros(gr*size(g2,1),3) kron(eye(gr),g2)];
% numInputSymbols=ones(1,size(G,2))*4;
% metric_vec=ones(1,size(G,2));


% g1=[1 1 1];g2=[ 1 2 3];g3=[1 1 0];
% gr=8;
% G=[kron(eye(gr),g1),zeros(gr,6)]+[zeros(gr,3) kron(eye(gr),g2) zeros(gr,3)]+[zeros(gr,6) kron(eye(gr),g2)];
% numInputSymbols=ones(1,size(G,2))*4;
% metric_vec=ones(1,size(G,2));

% % example input 1: the perfect five qubit code, shift of XZZXI  1ww10
% %parity check matrix
  G=[1 2 2 1 0; 0 1 2 2 1; 1 0 1 2 2; 2 1 0 1 2];
  numInputSymbols=ones(1,size(G,2))*4;
 
  %metric_vec=[ 1 1 1 -1 -1]
%  % example input 1-2: the perfect five qubit code, shift of XZZXI  1ww10
% %parity check matrix with one extra row
%  G=[1 2 2 1 0; 0 1 2 2 1; 1 0 1 2 2; 2 1 0 1 2; 2 2 1 0 1];
%  numInputSymbols=ones(1,size(G,2))*4;
 
%  % example input 1-2: the perfect five qubit code, shift of XZZXI  1ww10
% %parity check matrix with one extra row and syndrome error bits
%  G=[1 2 2 1 0; 0 1 2 2 1; 1 0 1 2 2; 2 1 0 1 2; 2 2 1 0 1];
%  rowG=size(G,1);
%  numInputSymbols=ones(1,size(G,2))*4;
%  G=[G,eye(rowG)];
%  numInputSymbols = [ numInputSymbols, ones(1,rowG)*2];




% G =[1 1 0 1 1 1 0 0 0 0 0 0 0 0
%     0 0 1 1 0 1 1 1 0 0 0 0 0 0
%     0 0 0 0 1 1 0 1 1 1 0 0 0 0
%     0 0 0 0 0 0 1 1 0 1 1 1 0 0
%     0 0 0 0 0 0 0 0 1 1 0 1 1 1]
% numInputSymbols = ones(1,size(G,2))*2;
% metric_vec = ones(1,size(G,2));


trellisGF4 = getTrellisGF4(G,numInputSymbols,0,0);

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

 %initialize
 layer=1;
for i = 1:trellisGF4.numStates  
    if trellisGF4.stateIsOccupied(i,layer)       %run over all occupied current state
        currentState = i-1; %use a number to represent the binary syndrome vector
        %currentStateVec=(de2bi(currentState,r)); %the right most has the higest order in the binary vector, refer to the bottom row in the parity check matrix  

        for j = 1:trellisGF4.numInputSymbols(layer)  % and over all possible input
            input = j-1;
            metric_temp = getMetric(input,1,metric_vec);
            nextState=trellisGF4.nextStatesCell{layer}(currentState+1,input+1);
        
            if metric_temp > metric(nextState+1) %find path with maximum metric

                path(nextState+1,layer)=input;
                metric(nextState+1)=metric_temp;
            end         
        end
    end
end

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
                metric_temp = getMetric(input,layer,metric_vec);
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
    metric=new_metric    ;
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















