repeat=30
P = matrix_generate_strip2(repeat);
[strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);

%replace the first and last generator in a given way. decribed in qconv002.pdf
na=2;%coderate = 1/na for classical convolutional code.
[a,b]=min(Qtransfer);
cols1=b:(b+2);
row1=strip(1,b)+na+1;

[a,b]=min(fliplr(Qtransfer));
b=size(Qtransfer,2)+1-b-2;
cols2=b:(b+2);
row2=strip(2,b);
P2(row2,cols2)=[3 2 1];

P2=P;
P2(row1,cols1)=[3 2 1];


disp('time to get trellisGF4Strip')
%trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);

return


folder='data/trellis/code6'
%repeats =3:40  %done
repeats=3
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
     'weightP','trellisGF4Strip','-v7.3')


end
