%Weilei Zeng, Feb 2019
%construct some trellis and save it into folder data/trellis/

%for code parameters, go to matric_generate_strip.m

repeats =3:20  %3:40done
               %repeats=10
parfor repeat=repeats
    saveTrellis4repeat(repeat,folder)
end


function saveTrellis4repeat(repeat,folder)
% construct P and trellis from matrix_generate_strip.m
tic
code='code6'
folder=['data/trellis/',code];
%code6 for GA and code7 for GR, code 8 for GI
switch code
  case {'code6','code7'}
    P = matrix_generate_strip(repeat,code);
    [strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
    %change the second and last generatos accordingly
    %replace the first and last generator in a given way. decribed in qconv002.pdf
    na=2;%coderate = 1/na for classical convolutional code.
    [a,b]=min(Qtransfer);
    cols1=b:(b+2);
    row1=strip(1,b)+na+1;

    [a,b]=min(fliplr(Qtransfer));
    b=size(Qtransfer,2)+1-b-2;
    cols2=b:(b+2);
    row2=strip(2,b);
    
    P2=P;
    codeword=[3 2 1]; %for P and P_dual
    codeword2=[1 3 2]; %for P_dual
    P2(row1,cols1)=codeword; %[3 2 1] [W w 1] is a codeword of the infinite QCC
    P2(row2,cols2)=codeword;
    P=P2;

    %find P_dual ,P*P_dual^T=0. the codeword generating matrix
    n=sum(1-Qtransfer);
    nm=size(Qtransfer,2);
    P_dual=zeros((n/3-2)*2,nm );

    qubit_positions=zeros(1,n);
    k=1;
    for i=1:nm
        if Qtransfer(i)==0
            qubit_positions(k)=i;
            k=k+1;
        end
    end

    for i=1:(n/3-2)
        P_dual( (1+2*i-2):(2*i), qubit_positions( (3*i+1):(3*i+3) ) )=[codeword;codeword2];
    end
    %    P_dual
    %nothing of these parameters changed, so no need to rerun the matrix parameters
    %[strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);

  case 'code0'
    %not in use and not in use anymore     %no P_dual for this case
    %code0 is just the GI or G code. It is always constructed in the simulation.n file, now I just move it here, so that all code will be reading the trellis from file.
    %it was also named code1, the same as GA code. To distinguish them the data file will have name simulation7 and simulation678 respectively. Now I change this GI code to code 0.
    g1=[1 1 1;2 2 2 ];g2=[ 1 2 3; 2 3 1 ];
    grepeat=repeat;
    G=[zeros(2,(grepeat+1)*3);kron(eye(grepeat+1),g1)] ...
      +[kron(eye(grepeat+1),g2);zeros(2,(1+grepeat)*3) ];
    rowG = size(G,1);
    P=[G, eye(rowG)];
    [strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);

  case 'code8'
    %modifies code0, where the second and last generator is changed to form a valid stabilizer code.
    %copy from code 1/0
    g1=[1 1 1;2 2 2 ];g2=[ 1 2 3; 2 3 1 ];
    grepeat=repeat;
    G=[zeros(2,(grepeat+1)*3);kron(eye(grepeat+1),g1)] ...
      +[kron(eye(grepeat+1),g2);zeros(2,(1+grepeat)*3) ];
    rowG = size(G,1);

    %modify G for code 8
    codeword=[3 2 1]; %for P and P_dual
    codeword2=[1 3 2]; %for P_dual
    
    G(2,1:3)=codeword;
    G(end-1,(end-2):end)=codeword;
    P=[G, eye(rowG)];
    %change
    %get P_dual here, and then transform with P later after massaging
    half_row_P_dual=grepeat-1;%half of the number of rows in P_dual
    P_dual = [ zeros(2*half_row_P_dual,3),  kron(eye(grepeat-1),[codeword;codeword2]),...
               zeros(2*half_row_P_dual,3)];%This P_dual has some (rowG) missing zero colums, will add later
    

    P = massageP(P);
    [strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
    %change P_dual accorddingly.
    for i=1:size(Qtransfer,2)
        if Qtransfer(i)==1 %syndrome bits, add a zero column
            P_dual=[P_dual(:,1:i-1),zeros(2*half_row_P_dual,1),P_dual(:,i:end)  ];
        end
    end
end


disp('time to get trellisGF4Strip')
trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
toc


%save all data into file
filename=[folder,'/repeat',num2str(repeat),'.mat' ]
save(filename,'P','strip','Ptransfer','Qtransfer','numInputSymbols',...
    'weightP','trellisGF4Strip','P_dual','-v7.3')
%some old case may not have P_dual
%I use -v7.3 because in code3 or code4, the trelli is so big because of a wrong structure. I don;t think I need to use -v7.3 anymore, but it doesn't matter anymore.
end