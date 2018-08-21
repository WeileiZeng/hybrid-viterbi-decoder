%Weilei Zeng, 08/03/2018

function [strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P)
%construct some necessary parameters for matrix P

strip = P2strip(P); %2-row matrix, denote the top and bottom nonzero position in each row
Ptransfer = P2metric_transfer(P);  %Ptrasnfer=T_p=T_{row}(0|I)T_{col}, it can convert a syndrome to input metric
%checked: sum(sum(Ptransfer)) = size(P,1)
Qtransfer = sum(Ptransfer); % a vector indicate the position of syndrome bits in the mixed error vector
numInputSymbols = (Qtransfer-2)*(-2); %denote it is a qubit or syndrome bit

weightP =P2weight(P,Ptransfer,Qtransfer);
end

function strip = P2strip(P)
%construct strip matrix for any P matrix.
% strip matrix is used to remove memory in trellis diagram
    [rowP,colP]=size(P);
    strip=zeros(2,colP);
    %get first and last nonzero element in each column
    for i_col = 1:colP
        for i_row=1:rowP
            if P(i_row,i_col)
                strip(1,i_col)=i_row;
                break
            end
        end
        
        for i_row=1:rowP 
            if P(rowP-i_row+1,i_col)
                strip(2,i_col)=rowP-i_row+1;
                break
            end
        end      
    end
    
    %put top rows and bottom rows in decreasing order
    for i_col = 1:colP-1       
        if strip(1,colP-i_col+1) <  strip(1,colP-i_col)
             strip(1,colP-i_col) =  strip(1,colP-i_col+1);
        end       
        if  strip(2,i_col) > strip(2,i_col+1)
            strip(2,i_col+1) = strip(2,i_col);
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

function weightP =P2weight(P,Ptransfer,Qtransfer)
%return weight of P
    [rowP,colP]=size(P);
    PG=P.*(1-Qtransfer); %only column of qubit remains
    PG2 = ceil(PG/4); %make GF(4) elements  binary
    weightG=sum(PG2,2)'; %return a row vector
    Wtransfer=P.*Qtransfer;
    Wtransfer = Wtransfer-Ptransfer;
    AGtransfer = Wtransfer*Ptransfer';
    AG=zeros(rowP,colP);
    weightA=zeros(1,rowP);
    for i =1:rowP
        g=zeros(1,colP); %temp generator
        for j=1:rowP
            if AGtransfer(i,j)               
                g=plusGF4vec(g,PG(j,:));
            end
        end
        AG(i,:)=g;
        weightA(i)=sum(  ceil(g/4));
    end

    weightP=weightG + weightA; % add together weight of original independent generator and extra genertors
    weightP = weightP*Ptransfer; %convert weight of each row to weight of corresponding clolumn for  that syndrome bit
         
end