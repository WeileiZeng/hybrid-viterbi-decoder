%construct some trellis and save it into folder data/trellis/

%QCC code
%vv=2;gg=[11 12 13];  %111123
vv=3;gg=[111 121 133];  %111123113

%syndrome concolutional code
%vva=4;gga=[1011 1111]; %11011111  ,u=4,s=2
%vva=2;gga=[10 11]; %1101
vva=3;gga=[101 111];

%code 1 vv=2;gg=[11 12 13];  %111123   %vva=3;gga=[101 111];

%code 2 vv=2;gg=[11 12 13];  %111123  vva=4;gga=[1011 1111]; %11011111  ,u=4,s=2

%code 3  vv=3;gg=[111 121 133];  %111123113   vva=3;gga=[101 111];

folder='data/trellis/code3'
repeats =5:40  %done
for repeat=repeats
    saveTrellis4repeat(repeat,folder)
end


function saveTrellis4repeat(repeat,folder)

 % construct P and trellis from matrix generate  strip
tic
P = matrix_generate_strip(repeat);
[strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
disp('time to get trellisGF4Strip')
trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
toc

filename=[folder,'/repeat',num2str(repeat),'.mat' ]
save(filename,'P','strip','Ptransfer','Qtransfer','numInputSymbols',...
    'weightP','trellisGF4Strip')


end