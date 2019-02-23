%Weilei Feb 13, 2019, construct code 6 and code 7, where extra generators in first block and last block varies

% Weilei Zeng, 07/27/2018 updated version with g and \omega g

% From the generating matrix $G$ for a QCC, and the generating matrix $A$ of
% a  classical CC, construct the generating matrix of the data syndrome code
% in a tripe form, where the syndrome concolutional code is defines by $A^T$.
% The formula is in data syndrome code2.pdf
%The current program output the quantum code terminated by dual code C, but
%the classical code terminated by code C. For the quantum code, it is easy
%to change the terminated method to terminate code C.(see last part of this
%program)

function P = matrix_generate_strip2(repeat)
%repeat = repeat -2 when terminating dual C code for quantum code

%Input: g (for G), a (for A)

%QCC code
vv=2;gg=[11 12 13];  %111123
%vv=3;gg=[111 121 133];  %111123113
%vv=4;gg=[1001 1113 1232]; %d=5

%vv=4;gg=[1001 1002 1003]


%syndrome concolutional code
%vva=4;gga=[1011 1111]; %11011111  ,u=4,s=2
%vva=2;gga=[10 11]; %1101
vva=3;gga=[101 111]; %110111  d=4 coderate 1/2
                     %vva=1;gga=[1 1]; % repeat twice

%code 1 vv=2;gg=[11 12 13];  %111123   %vva=3;gga=[101 111];
%code 2 vv=2;gg=[11 12 13];  %111123  vva=4;gga=[1011 1111]; %11011111  ,u=4,s=2
%code 3  vv=3;gg=[111 121 133];  %111123113   vva=3;gga=[101 111];
% code 4 vv=4;gg=[1001 1113 1232]  vva=3;gga=[101 111];
% code 5 vv=2;gg=[11 12 13];  %111123    vva=1;gga=[1 1] this is for repetion DS code.
% code 6, same as code 1, but extra generators varies.



vg=vv;  %constraint length
ng=size(gg,2);  %block length
va=vva;  %constraint length  u
na=size(gga,2);  %block length s

%the small repeated matrix block G
rowH = max(2*vg*(1+na),(1+na)*(1+va));%2*(na+1)*va;
colH = ng+2*(1+na);
H=zeros(rowH,colH);

%right bottom corner, indentity matrix
%H(end-2*na+1:end,end-2*na+1:end)=eye(2*na);
%not necessary at bottom
H((1+na)*(va-1)+2:(1+na)*va,end-2*na+1:end-na)=eye(na);
H((1+na)*va+2:(1+na)*(va+1),end-na+1:end)=eye(na);

%first columns in G, using gg
for i =1:vg  %row
    for j=1:ng  %col
        row=1+(i-1)*(na+1)*2;%)(na+1)*(i-1)+1;
        gij=pickGF4(gg(j),i);%pickGF4 use inverse index
        H(row,j)=gij;
        H(row+1+na,j)=timesGF4(gij,2); %times \omega
    end
end

%second columns in G, using b
for i = 1:va %row
    for j=1:na  %sub row
        row=(na+1)*(i-1)+1+j;
        bji=pickGF4(gga(j),va-i+1);
        H(row,ng+1)=bji;
        H(row+na+1,ng+2)=bji;
    end
end
%identity matrix for syndrome error in quantum part
H(1,ng+1)=1;
H(2+na,ng+2)=1;



%construct big matrix P
rowP=rowH+(na+1)*(repeat-1);
colP=colH*repeat+(vg-1)*ng+na*(va-1);
P=zeros(rowP,colP);

%Add first columns, blockg
blockg=zeros((vg-1)*(1+na)*2,ng*(vg-1));
for i = 1:(vg-1) %row
    for j=i:(vg-1)  %col
        for k = 1:ng  % sub col
            gij=pickGF4(gg(k),vg-j+1+i-1);
            blockg(1+(i-1)*(na+1)*2,(j-1)*ng+k)=gij;
            blockg(2+na+(i-1)*(na+1)*2,(j-1)*ng+k)=timesGF4(gij,2); %times omega
        end
    end
end
%blockg
P(1:size(blockg,1),1:size(blockg,2))=blockg;

%add second columns, blockI
blockI=zeros((1+na)*(va-1),na*(va-1) );
for i =1:(va-1)
    blockI(1+1+(i-1)*(na+1):na+1+(i-1)*(na+1),...
        1+(i-1)*na:na*i)=eye(na);    
end
P(1:size(blockI,1),1+size(blockg,2):size(blockg,2)+size(blockI,2))=blockI;

%add repeated part, H
for i = 1:(repeat) % add G
    row=2*(na+1)*(i-1)+1;
    col=1+colH*(i-1)+size(blockg,2)+size(blockI,2);
    P(row:(row+rowH-1),col:(col+colH-1))=H;
end
%P1=P;
%remove last rows of extra g and omega g
for i =1:(vg-1)
  row_to_remove = 1+2*(na+1)*repeat+2*(na)*(i-1);
  P(row_to_remove,:)=[];
  P(row_to_remove+na,:)=[];
end

%comment this part to terminate the generating code C
%remove some columns to terminate dual code C instead of generating code C.
%distance of dual code is preserved in this case.
%repeat = repeat-2 in this case.
%remove g_3 wg_3
for i=1:vg-1
    P(:,end-i*size(H,2)+1:end-i*size(H,2)+ng)=[];
end
%remove g_1 wg_1  % remove blockg
P(:,1:ng*(vg-1))=[];

% %construct some necessary matrix
% strip = P2strip(P); %2-row matrix, denote the top and bottom nonzero position in each row
% Ptransfer = P2metric_transfer(P);  %Ptrasnfer=T_p=T_{row}(0|I)T_{col}, it can convert a syndrome to input metric
% %checked: sum(sum(Ptransfer)) = size(P,1)
% 
% Qtransfer = sum(Ptransfer); % a vector indicate the position of syndrome bits in the mixed error vector
% 
% numInputSymbols = (Qtransfer-2)*(-2); %denote it is a qubit or syndrome bit
% 
% %display 
% %repeat, G,blockg,blockI,...

%Qtransfer

end



function st = P2strip(P)
%construct strip matrix for any P matrix.
% strip matrix is used to remove memory in trellis diagram
    [rowP,colP]=size(P);
    st=zeros(2,colP);
    %get first and last nonzero element in each column
    for i_col = 1:colP
        for i_row=1:rowP
            if P(i_row,i_col)
                st(1,i_col)=i_row;
                break
            end
        end
        
        for i_row=1:rowP 
            if P(rowP-i_row+1,i_col)
                st(2,i_col)=rowP-i_row+1;
                break
            end
        end      
    end
    
    %put top rows and bottom rows in decreasing order
    for i_col = 1:colP-1       
        if st(1,colP-i_col+1) <  st(1,colP-i_col)
             st(1,colP-i_col) =  st(1,colP-i_col+1);
        end       
        if  st(2,i_col) > st(2,i_col+1)
            st(2,i_col+1) = st(2,i_col);
        end
    end
end
           
function Ptransfer = P2metric_transfer(P)
%this method depends on the structure of P. 
%remove g and b in P matrix. only 1 and I remains. Use it to transfer syndrome to metric_vec    
    Ptransfer=P;
    [rowP,colP]=size(Ptransfer);
    for i=1:colP
        [maxCol,maxIndex]=max(Ptransfer(:,i));
        if maxCol>1  %g cols, clear it
            Ptransfer(:,i)=zeros(rowP,1);
        else   %I or b columns. In b columns, there are 1 in the top, so remove the bottom part.
            length=rowP-maxIndex;
            Ptransfer(maxIndex+1:end,i)=zeros(length,1); 
        end
    end
end





