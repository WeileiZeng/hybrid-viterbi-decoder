% Weilei Zeng, 07/19/2018
% construct syndrome trellis for strip codes P
%return a cell of trellisGF4, whose elements are the trellisGF4 for each
%column.

function trellisGF4Strip = getTrellisGF4Strip(P,strip,numInputSymbolsP)

numLayers=size(P,2);
trellisGF4Strip =cell(1,numLayers); % the output which contains the trellis for each layer/lolumn in P

%initialize for the first layer
lastStateIsOccupied=[1];
layer = 1;
shiftLength = strip(1,layer+1)-strip(1,layer);
initialStateIsOccupied = last2initial(lastStateIsOccupied,...
        0,2^(strip(2,layer)-strip(1,layer)+1));
trellisLayer=getTrellisGF4(P(strip(1,layer):strip(2,layer),layer),...
        numInputSymbolsP(layer),initialStateIsOccupied,shiftLength);
trellisGF4Strip{layer}=trellisLayer;
lastStateIsOccupied=trellisLayer.stateIsOccupied(:,2);

for layer=2:numLayers-1
    shiftLength = strip(1,layer+1)-strip(1,layer);
    initialStateIsOccupied = last2initial(lastStateIsOccupied,...
        strip(1,layer)-strip(1,layer-1),2^(strip(2,layer)-strip(1,layer)+1));
    trellisLayer=getTrellisGF4(P(strip(1,layer):strip(2,layer),layer),...
        numInputSymbolsP(layer),initialStateIsOccupied,shiftLength);
    trellisGF4Strip{layer}=trellisLayer;
    lastStateIsOccupied=trellisLayer.stateIsOccupied(:,2);
end

%last layer
layer=numLayers;
shiftLength = size(P,1)-strip(1,layer);
initialStateIsOccupied = last2initial(lastStateIsOccupied,...
    strip(1,layer)-strip(1,layer-1),2^(strip(2,layer)-strip(1,layer)+1));
trellisLayer=getTrellisGF4(P(strip(1,layer):strip(2,layer),layer),...
    numInputSymbolsP(layer),initialStateIsOccupied,shiftLength);
trellisGF4Strip{layer}=trellisLayer;
end
        
function initialStateIsOccupied = last2initial(lastStateIsOccupied,shiftLength,initialStateLength)
%1 means occupied, and 0 otherwise
%only those in the lastStates, whose positions to lose has zero value
%will be transimitted into the inital state in the next layer
    %initialStateLength=size(lastState,1)=2^(size(G,1);
    %shift length in binary
    initialStateIsOccupied=zeros(initialStateLength,1);
    lastStateLength=size(lastStateIsOccupied,1);
    for i_initial = 1:lastStateLength/(2^shiftLength)
        state=i_initial-1;
        i_last=state*(2^shiftLength)+1;
        if sum( lastStateIsOccupied(i_last:(i_last+2^shiftLength-1)) )
            initialStateIsOccupied(i_initial)=1;
        end
    end    
end








