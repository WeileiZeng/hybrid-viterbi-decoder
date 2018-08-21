%08/08/2018
%test the errors
%check how to optimize the simulation from single error and double errors,
%etc
% not finished


 

%test the range the the input error prob in the simulation
pms=1:0.2:3
pms=0.1.^pms

n=50
N=10^7
noerror=(1-pms).^n
singleerror=n*pms.*((1-pms).^(n-1))
doublerror=n*(n-1)/2*(pms.^2).*((1-pms).^(n-2))
nsd=noerror+singleerror+doublerror;
[pms;noerror;singleerror;doublerror;nsd;...
    (1-nsd)*N]'





 %repetition
%pm=pms %0:p_error_max/division:p_error_max;
repeat=17
[P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip]...
    = getSavedTrellis(repeat);

pms=1:0.2:3;
pms=0.1.^pms;
pm_good = (1-pms).^3+2*pms.*(1-pms).^2
pm_fail=1-pm_good.^(repeat*2+4); %all syndrome bits has no error

length=size(pms,2);
ss=zeros(1,length);
zz=zeros(1,length);
pp=zeros(1,length);
for j=1:length
    pm=pms(j);
    pq=pm;
    s=0;
    z=0;
    n=40000;
    esum=zeros(1,size(numInputSymbols,2));
    for i =1:n
        [error,syndromeError] = generate_error(numInputSymbols,pq,pm);
        esum =esum+ceil(error/4);
        if syndromeError
            s=s+1;
        elseif sum(error)<2%==0
            z=z+1;
        end
    end
    %[esum/n;numInputSymbols]'
    pp(j) = sum(esum/n)/size(esum,2);
    ss(j)=s/n;
    zz(j)=z/n;
end
%[pms;pm_fail;ss]'
[pms;pp]'
[ss;zz;zz+ss]'



function [error,syndromeError] = generate_error(numInputSymbols,pq,pm)
%generate radnom error from given erro model/probability
    syndromeError=0;
    length = size(numInputSymbols,2);
    error=zeros(1,length);
    r = rand(1,length);
    pq3=pq/3; %error probability for X, Y or Z error
    pm_bad = 1-(1-pm)^3-2*pm*(1-pm)^2; %repeat mesurement 3 times
    for i =1:length
        switch numInputSymbols(i)
            case 2
                if r(i)< pm_bad 
                    error(i) = 1 ;             
                    syndromeError=1;
                end
            case 4
                if r(i) < pq3
                    error(i)=1;
                elseif r(i) <2*pq3
                    error(i) = 2;
                elseif r(i) < pq
                    error(i) = 3;
                end
        end
    end
end
     