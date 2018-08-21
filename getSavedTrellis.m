%get info from saved trellis in data/trellis/



% 
% repeat =5
% [P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip]...
%     = getSavedTrellis(repeat)


function [P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip]...
    = getSavedTrellis(repeat,folder)


filename=[folder,'/repeat',num2str(repeat),'.mat' ]
load(filename,'P','strip','Ptransfer','Qtransfer','numInputSymbols',...
    'weightP','trellisGF4Strip')


end


