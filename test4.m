%test syndrome conversion


%Find matrix Gtransfer from P. Gtrasnfer transfer row vector (s_1,s_2) into row vector (s's'') which match P matrix in strip form
%syndromeP=syndrome*Gtransfer'

mat1=P.*Qtransfer;
mat2=ceil((sum(mat1)-1)/max(sum(mat1)))
mat3 = Ptransfer*mat2'
[mat4 mat5]=sort(mat3,'descend')
[rowP colP]=size(P)
Gtransfer=zeros(rowP,rowP)
for i =1:rowP
    Gtransfer(mat5(i),i)=1;
end

error=zeros(1,colP)
%error(1)=1;
%error(5)=1;
%error(14)=1;
error(9)=1;
syndromeP=error*P'
syndrome=syndromeP(mat5)
%if syndrome is given
syndromeP2(mat5)=syndrome
syndromeP
syndromeP3=syndrome*Gtransfer'
syndrome
syndromeP
