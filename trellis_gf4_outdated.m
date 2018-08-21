%Weilei Zeng, 07/02/2018
%use trellis to define a GF(4) convolutional code.


%{
sample code from Forney's paper
 g=1111wW, use W=w^2 
 g=(1+D,1+wD,1+WD)
%}

outputs1=bin2octal([000 111 111 111;...
    111 011 110 101; 111 101 011 110;111 110 101 011]);
trellis1 = struct('numInputSymbols',4,'numOutputSymbols',16 ,...
   'numStates',4,'nextStates',[0 1 2 3;0 1 2 3;0 1 2 3;0 1 2 3],...
   'outputs',outputs1);
istrellis(trellis1)
distspec(trellis1,5)

%temp=[10 11; 101 1];
%bin2octal(temp)

poly2trellis4gf4(4)

function octal = bin2octal(binary)
%convert matrix of binary value to octal numbers
%example: [10 11; 101 1] --> [2 3;5,1]
    [row,col]=size(binary);
    octal=zeros(row,col);
    for i=1:row
        for j=1:col
            octal(i,j)=str2num(dec2base(bin2dec(num2str(binary(i,j))),8));
        end
    end
end




