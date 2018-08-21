%from the codeword generator and a binary/GF(4) vector (called alpha), generate the
%corresponding codeword and calculate its GF(4) weight

%input: code C


%code rate 1/3
vv=2;gg=[11 12 13];  %d=6 [3 0 9 0 27]  
%vv=3; gg=[111 121 110]; %d=8 Nd=2  [6 0 15 0 51]
%vv=4; gg=[1001 1113 1231]; %d=10   [3 3 3 9 3]
%vv=5; gg=[12321 13013 11122]; %d=13 [3 6 12 18 27]
%vv=6; gg=[112031 113103 132222]  %d=16  [12 0 27 0 141]
%vv=7; gg=[1321202 1130033 1002131]; %d=16 Nd=2  [6 0 6 0 27]
%vv=7; gg=[1321203 1202322 1120231];  %d=18 Nd=4 [12 0 33 0 75]
%vv=7; gg=[1213303 1323311 1001212];  %d=18 Nd=4  [12 0 33 0 75]
%vv=7; gg=[1121103 1022022 1313231]; %d=18 Nd=2  [6 0 33 0 96]

alpha=[1 0 1 1];
t=size(alpha, 2);
v=vv(1);n=size(gg,2);
Gcolumn=(v+t-1)*n;
G=zeros(t,Gcolumn);
g=poly2codeword(v,gg);
% %construct G
% for i = 1:t
%     G(i,(1+n*(i-1)):(n*(v+i-1)))=g;
% end

%mupliply alpha*G
alpha_max=1000;
tic
fprintf('all codeword start from 1 to make it in canonical form and remove 3 repetition, then the result need x 3\n');
fprintf('Any code word has more than v continous zeros should also be removed (but not yet), which is just an addition of two nonadjacent codeword.\n');
fprintf('codeword with weight(codeword)/length/spread/weight(alpha)\n');
weight=10;
weight_count=0;
for i =0:alpha_max
    alpha = dec2gf4(i); %convert to GF4 vector
    alpha = [1 alpha];  %add one to make it in canonical form and remove 3 repetition, then the result need x 3.
    codeword = encoding(alpha,g,n,v);
    w_codeword = weightofGF4vector(codeword);
    w_alpha=weightofGF4vector(alpha);
    spread=(v+floor(log2(2*i+1)));  %roughly speaking, spread = spread*n
    if w_codeword ==weight
    fprintf('%d/%d/%d/%d;',...
        w_codeword,spread*n,spread,w_alpha);
    disp(alpha)
    weight_count = weight_count+1;
    end
end
fprintf('\\# of codewords with weight %d is %d x 3 = %d\n',weight,weight_count,weight_count*3);
toc
function vecGF4 = dec2gf4(N)
%convert decimal number to GF4 vector
%the rightmost in the output is the biggist digit
    str = dec2base(N,4);
    length = size(str,2);
    vecGF4=zeros(1,length);
    for i = 1:length
        vecGF4(i) = str2num(str(i));
    end
    vecGF4 = fliplr(vecGF4);
end


function w = weightofGF4vector(vecGF4)
%convert GF4 vector to its 
    col=size(vecGF4,2);
    vecGF2=zeros(1,col);
    for i =1:col
        if vecGF4(i)
            vecGF2(i)=1;
        end
    end
    w = biterr(vecGF2,zeros(1,col));
end


function codeword = encoding(alpha,g,n,v)
%return alpha*G, both in GF(4)
    t=size(alpha,2);
    Gcolumn=(v+t-1)*n;
    
    codeword=zeros(1,Gcolumn);
    for i =1:Gcolumn
       e=0;
       for j=1:t
          Gji=getGij(g,j,i,n,v);
          e_temp =timesGF4(alpha(j),Gji);
          e=plusGF4(e,e_temp);
       end
       codeword(i)=e;
    end
end


function code_g = poly2codeword(v,poly_g)
    n=size(poly_g,2);
    code_g=zeros(1,n*v);
    for i = 1:v
        for j=1:n
            code_g( (i-1)*n +j ) = pickGF4(poly_g(j),v-i+1);
        end
    end
end

function val = getGij(g,i,j,n,v)
%return i,j element of G
%G(i,(1+n*(i-1)):(n*(v+i-1)))=g;
    if j< 1+n*(i-1)
        val =0;
    elseif j> n*(v+i-1)
        val =0;
    else
        gindex= j-n*(i-1);
        val=g(gindex);
    end
end