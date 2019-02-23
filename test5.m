code = 'code1';
repeat=5
constructCode=1;
if constructCode ==1
    %construct the code
    switch code
      case {'code1','code2'}
        g1=[1 1 1;2 2 2 ];g2=[ 1 2 3; 2 3 1 ];
        grepeat=repeat;
        G=[zeros(2,(grepeat+1)*3);kron(eye(grepeat+1),g1)] ...
          +[kron(eye(grepeat+1),g2);zeros(2,(1+grepeat)*3) ];
        rowG = size(G,1);
        P=[G, eye(rowG)];
      case 'code3'
    end
    P = massageP(P);
    %get trellis
    tic
    [strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
    %[strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
    disp('time to get trellisGF4Strip')
    trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
    toc
end


function P1 = massageP(P)
%masssage P to make it into strip form, in the repetition case,
% input P=[G,I]

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

P1=zeros(rowP,colP);
ig=1;
ii=1;
for i =1:colP
    %         strip(1,colP-rowP-ig+1) , rowP-ii+1+1
    if strip(1,colP-rowP-ig+1) < rowP-ii+1+1
        P1(:,colP-i+1)=P(:,colP-ii+1);
        ii=ii+1;
    else
        P1(:,colP-i+1)=P(:,colP-rowP-ig+1);
        ig = ig+1;
    end

end
%P=P1
%end

end