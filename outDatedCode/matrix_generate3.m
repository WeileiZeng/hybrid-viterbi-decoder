%outdated, the same as matrix_generate_strip.m, but with less parameters
% Weilei Zeng, 07/26/2018 updated version with \omega

% From the generating matrix $G$ for a QCC, and the generating matrix $A$ of
% a  classical CC, construct the generating matrix of the data syndrome code
% in a tripe form, where the syndrome code is defines by $A^T$.
% The formula is in data syndrome code2.pdf

%Input: g (for G), a (for A)

%QCC code
vv=2;gg=[11 12 13];  %111123
%vv=3;gg=[111 121 133];  %111123113


%syndrome code
%vva=4;gga=[1011 1111]; %11011111  ,u=4,s=2
%vva=2;gga=[10 11]; %1101
vva=3;gga=[101 111];

v=vv;  %constraint length
n=size(gg,2);  %block length
va=vva;  %constraint length  u
na=size(gga,2);  %block length s




%H=zeros(va*na+v+extra_length,1+n+na); %1 for only one generator in gga
G=zeros(2*(na+1)*va,n+2*(1+na));


%right bottom corner, indentity matrix
G(end-2*na+1:end,end-2*na+1:end)=eye(2*na);

%first columns in G, using gg
for i =1:v  %row
    for j=1:n  %col
        row=1+(i-1)*(na+1)*2;%)(na+1)*(i-1)+1;
        gij=pickGF4(gg(j),i);%pickGF4 use inverse index
        G(row,j)=gij;
        G(row+1,j)=timesGF4(gij,2); %times \omega
    end
end

%second column in G, suing b
for i = 1:va %row
    for j=1:na  %sub row
        row=2*(na+1)*(i-1)+2+j;
        bji=pickGF4(gga(j),va-i+1);
        G(row,n+1)=bji;
        G(row+na,n+2)=bji;
    end
end
G(1,n+1)=1;
G(2,n+2)=1

%repeat r=4 times to construct the big code  with 33 sec decoding time
repeat=5;
[rowG,colG] = size(G);
rowP=rowG+(na+1)*(repeat-1);
colP=colG*repeat+(v-1)*n+na*(va-1);
P=zeros(rowP,colP);

%Add first columns
blockg=zeros((v-1)*(1+na)*2,n*(v-1));
for i = 1:(v-1) %row
    for j=i:(v-1)  %col
        for k = 1:n  % sub col
            gij=pickGF4(gg(k),v-j+1+i-1);
            blockg(1+(i-1)*(na+1)*2,(j-1)*n+k)=gij;
            blockg(2+(i-1)*(na+1)*2,(j-1)*n+k)=timesGF4(gij,2); %times omega
        end
    end
end
blockg
P(1:size(blockg,1),1:size(blockg,2))=blockg;

blockI=zeros(2*(1+na)*(va-1),2*na*(va-1) );
for i =1:(va-1)
    blockI(1+2+(i-1)*(na+1)*2:1+2+2*na-1+(i-1)*(na+1)*2,1+(i-1)*na*2:2*na*i)=eye(na*2);    
end
blockI

P(1:size(blockI,1),1+size(blockg,2):size(blockg,2)+size(blockI,2))=blockI;

for i = 1:(repeat) % add G
    row=2*(na+1)*(i-1)+1;
    col=colG*(i-1)+1+(v-1)*n+2*na*(va-1);
    P(row:(row+rowG-1),col:(col+colG-1))=G;
end
P1=P;
%remove last rows
for i =1:(va-1)
  row_to_remove = 2*(na+1)*repeat+1+2*(na)*(i-1);
  P(row_to_remove:row_to_remove+1,:)=[];
end




