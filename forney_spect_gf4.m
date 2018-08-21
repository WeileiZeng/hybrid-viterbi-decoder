%From forney's code, calculate the WEF for each orthogonal code
%WEF: weight enumerating funtion
%code data for Table VI. Self-orthogonal F4-linear rate-1/3 convolutional codes
%Method: construct trellis using the generators, mainly the nextState
%matrix and putputs matrix. The output, originally in GF4, is vconverted to
%binary to represent its weight.

%Input:
%binary code rate 1/2
%vv=4;gg=[1011 1111];
%binary code rate 1/3
%vv=[2 2];gg=[01 11 10 ;01 11 10];

%GF4 code rate 2/3, d=3
%vv=[1 2];gg=[ 3 2 1; 11 12 13];
%GF4 code rate 2/3, d=4
%vv=[2 2];gg=[02 03 11; 10 13 13];


%code rate 2/3, d=5
%vv=[2 3],gg=[10 13 13; 202 131 003]

%wrong result, wrong definition?
%vv=[3 3],gg=[321 32 321; 331 211 03]; %matlab give d=5, Nd = 6
%vv=[4 4], gg= [3211 113 0101; 2221 1021 323]; %matlab give d =8, Nd=72

%code rate 2/3 d=8
%vv=[3 4],gg=[321 103 232; 3103 2031 0022];

%input: code C

%code rate 1/3
%vv=2;gg=[11 12 13];  %d=6 [3 0 9 0 27]  
%vv=3; gg=[111 121 110]; %d=8 Nd=2  [6 0 15 0 51]
%vv=4; gg=[1001 1113 1231]; %d=10   [3 3 3 9 3]
%vv=5; gg=[12321 13013 11122]; %d=13 [3 6 12 18 27]
%vv=6; gg=[112031 113103 132222]  %d=16  [12 0 27 0 141]
%vv=7; gg=[1321202 1130033 1002131]; %d=16 Nd=2  [6 0 6 0 27]
%vv=7; gg=[1321203 1202322 1120231];  %d=18 Nd=4 [12 0 33 0 75]
%vv=7; gg=[1213303 1323311 1001212];  %d=18 Nd=4  [12 0 33 0 75]
%vv=7; gg=[1121103 1022022 1313231]; %d=18 Nd=2  [6 0 33 0 96]

%code A^T construct convolutional code from the alpha vector which give
%small weight codeword in G
%vv=5;gg=[10031];  % catastropic
%vv=5;gg=[13001];   % catastropic
%vv=5;gg=[33131];    % catastropic
%vv=5;gg=[13133];     % catastropic
%vv=3; gg=[132];       % catastropic
vv=6;gg=[10031 13133];  %non catastrophic




tic
%result
max=5;
t=poly2trellis4gf4(vv,gg),[a,b] = istrellis(t);
if ~a 
    disp(b)
end
spec=distspec(t,max)

disp('Explaination of result: since it is for GF(4) code, any codeword multiplied by 1 w W is still a codeword. Hence, the elements in the event vector is muliplied by 3, 3^2, 3^3 and so on. The order is not determined')
toc
