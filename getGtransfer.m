%Weilei Feb 14 2019
% a temp function to find Gtransfer.
function Gtransfer = getGtransfer(P,Qtransfer,Ptransfer)
%Find matrix Gtransfer from P. Gtrasnfer transfer row vector (s_1,s_2) into row vector (s's'') which match P matrix in strip form
%syndromeP=syndrome*Gtransfer'
%syndrome=(s_1,s_2) is the syndrome result for G and AG respectively in the natural order
%syndromeP is a row vector, which is the syndrome match the index of P.


%Gtransfer*s' will transfer (s_1,s_2) tot he order of P
    sumPt=sum(  ( P.*(1-Qtransfer) )' );
    [a,b]=sort( ceil(sumPt/max(sumPt)),'descend' );
    [rowP colP]=size(P);
    Gtransfer=zeros(rowP,rowP);

    for i =1:rowP
        Gtransfer(b(i),i)=1;
    end
    return

    s1=s;
    %s2 should become the syndrome for G part
    s1(b)=s

    s2=mod(s1*Ptransfer*P',2)

    s1*Gtransfer


    
mat1=P.*Qtransfer;
mat2=ceil((sum(mat1)-1)/max(sum(mat1)));
mat3 = Ptransfer*mat2';
[mat4 mat5]=sort(mat3,'descend');
[rowP colP]=size(P);
Gtransfer=zeros(rowP,rowP);
for i =1:rowP
    Gtransfer(mat5(i),i)=1;
end


end