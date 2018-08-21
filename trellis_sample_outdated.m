%7/2/2018 Weilei Zeng
%give some sample of trellis and poy2trellis from Communication ToolBox

%(1,1,1) code
s = struct('numInputSymbols',2,'numOutputSymbols',2,...
   'numStates',2,'nextStates',[0 1;0 1],'outputs',[0 0;1 1]);
istrellis(s)
b=struct();
b.numInputSymbols=2;
b.numOutputSymbols=2;
b.numStates=2;
b.nextStates=[0 1;0 1];
b.outputs=[0 0 ;1 1];

istrellis(b)

%(2,1,2) code
trellis = struct('numInputSymbols',2,'numOutputSymbols',4,...
'numStates',4,'nextStates',[0 2;0 2;1 3;1 3],...
'outputs',[0 3;1 2;3 0;2 1]);

istrellis(trellis)

convenc([1 1 0 1],trellis)



t = poly2trellis([4 3],[4 5 17;7 4 2]);

x = ones(12,1);
code = convenc(x,t);


txt='1110';
str2num(dec2base(bin2dec(txt),8));

in=[0 1 0]
aa=poly2trellis(2,[2,3]);
convenc(in,aa)

aa=poly2trellis(2,[3,2]);
convenc(in,aa)

aa=poly2trellis(2,[1,3]);
convenc(in,aa)

disp('Sample code from Shu Lin, a=(n=2,k=1,m=4), 1011 and 1111')
aa=poly2trellis(4,[13,17]);
aa
convenc(in,aa);

spect=distspec(aa,5)
berub = bercoding(1:0.2:5,'conv','hard',1/2,spect); % BER bound
berfit(1:0.2:5,berub); ylabel('Upper Bound on BER'); % Plot.

disp('rate 1/3 code g from Forney, constraint length v=2')
g=poly2trellis(3,[1,5,7]);
spect=distspec(g,10)

disp('orthogonal code of g, rate 2/3')
h=poly2trellis([2 2],[3,2,3;1,3,2]);
spect=distspec(h,10)

disp('orthgonal 2/3 code of rate 1/3 code g from Forney, constraint length v=3')
hv3=poly2trellis([3 2],[5,5,4;1,2,3]);
spect=distspec(hv3,10)



