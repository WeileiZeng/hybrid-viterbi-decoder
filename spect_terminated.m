% Weilei Zeng, July 6, 2018
%calculate WEF for terminated convolutional code (zero tail)

%from trellis, construct gain matrix A. Then use convcell to calculate Ak.
% the first element in Ak give WEF for zero-tail terminated convolutional
% code.
% this works for both Binary and GF(4)

%clear;disp('data cleared');
tic
%Input code C
disp('note: the current program only works for all memory > 0')
%code rate 1/3
%vv=2;gg=[11 12 13];  %d=6
%vv=3;gg=[111 121 110]; %d=8
%vv=4; gg=[1001 1113 1231]; %d=10
%vv=5;gg=[12321 13013 11122];  %d=14 time=7 min
%vv=6; gg=[1321202 1130033 1002131]; 
%vv=3,gg=[101,111]
repeat=4;  

%Input orthogonal code C^\bot
%GF4 code rate 2/3, d=3
%vv=[1 2];gg=[ 3 2 1; 11 12 13];
%code rate 2/3, d=5
%vv=[2 3],gg=[10 13 13; 202 131 003]

%classical binary code
vv=3,gg=[101,111],

%get trellis
trellis=poly2trellis4gf4(vv,gg);
%max=5;
%[a,b] = istrellis(t),spec=distspec(t,max)

gf=4; %GF(4) or GF(2)

k=size(vv,2);
v=sum(vv);
m=v-k; %memory
A=cell(gf^m,gf^m); %initialize gain matrix
A(:,:)={0};


%go through nextStates matrix and update the output gain into A
for i = 1:gf^m %input state
    currentState=i-1;
    for j = 1:gf^k  % output state
        nextState = trellis.nextStates(i,j);%10 based number. no shift needed, alread start from 0 
        output_octal=trellis.outputs(i,j);
        A{currentState+1,nextState+1}=getgain(output_octal);   
    end
end

%repeat=5;
fprintf('repeat %d times\n',repeat);
kx=m+repeat; %start from 0 state and end into 0 state. add m for zero-tail
Ak = convcell(A,kx);
row=Ak{1,1};
result=[row;linspace( size(row,2)-1,0,size(row,2))];
disp('result in [events] [weight]')
result'

toc

function gain = getgain(octal)
%convert the encoded output in octal format to gain vector/polynomial
%Process: octal --> binary ---> weight --> gain polynomial D^w
%Output: gain = [w1 w2 w3] ---> w3+w2*D+w1*D^2
%        gain =[1 0 0] -------> D^2
d=dec2bin( base2dec(num2str(octal),8));
weight = sum(  d.' == '1' );
gain = zeros(1,weight+1);

gain(1)=1;  %gain = D^weight+...+0

end
        




