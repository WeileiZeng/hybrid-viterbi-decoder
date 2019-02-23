
%errorMat
%syndromMatCircuit
%error_folder='~/working/circuit/quantumsimulator/error/run3';
%errorMat=mmread([error_folder,

G=P;
t=size(errorMat,1)
syndromeMatDiff=zeros(t,size(G,1));
for i_t = 1:t
error=errorMat(i_t,:);


%function syndrome = measure(G,error,numInputSymbols) %GF4 and GF2;
%from parity check matrix G and row vector error e, calculate the row vector syndrome
syndrome = zeros(1,size(G,1));
ss=G;
for i =1:size(G,1)
    for j = 1:size(G,2)
        switch numInputSymbols(j)
          case 4  %qubit error
            ss(i,j)=traceGF4(G(i,j),error(j));
          case 2  %syndrome error
            ss(i,j) = G(i,j)*error(j);
        end
    end
    temp_sum = sum(ss(i,:));
    syndromebit = temp_sum - floor(temp_sum/2)*2;
    syndrome(i)=syndromebit;
end

%end

error %input error
syndrome %measured syndrome for error
syndromeMatCircuit(i_t,:) %syndrome from cpp program
syndrome_diff=bitxor(syndromeMatCircuit(i_t,:),syndrome)
syndromeMatDiff(i_t,:)=syndrome_diff;

i_t
pause
end

sum(syndromeMatDiff)