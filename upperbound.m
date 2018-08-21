%get upper bound on the classical conolutional code with repeat =4
 %compare it with repetition and other data(convolutional or min weight)

 
%Construct the terminated convolutional code with syndrome bits
gc=[1 1 0 1 1 1];
repeat=4
Pc=[ kron(eye(repeat),gc(1:2)) zeros(repeat,4)]...
    +[ zeros(repeat,2) kron(eye(repeat),gc(3:4)) zeros(repeat,2)]...
    +[ zeros(repeat,4) kron(eye(repeat),gc(5:6))];
Pc =Pc'
%Pc=[eye(size(Pc,2),size(Pc,1)+size(Pc,2)); Pc eye(size(Pc,1))]; %not decodable in the program
Pc=[ Pc eye(size(Pc,1))]  %Pc is the parity check matrix


WEF =[...
    12    12
    24    11
    75    10
    72     9
    33     8
    12     7
    15     6
    12     5
     0     4
     0     3
     0     2
     0     1
     1     0]
 
 Aw=fliplr(WEF(:,1)') % the approximate WEF for the generating matrix
 
 
 pms=0.5:0.1:1.5
 pms=0.1.^pms 
 
 %pms=0.01:0.01:0.1
 
 %Prw2 = getPr(w,pm)
 %pm=0.1;
 d=6
 N=size(Pc,2);
 Pcw = zeros(1,size(pms,2));
 
 %get upper bound
 for i=1:size(pms,2)
     pm=pms(i);
     Pcw(i) = getPcw(d,N,Aw,pm);
 end
 Pcw
 
 
 %repetition
%pm=pms %0:p_error_max/division:p_error_max;
pm_good = (1-pms).^3+2*pms.*(1-pms).^2
pm_fail=1-pm_good.^(4+2*repeat);


filename1 = 'data/simulation5-3.mat';
filename2 = 'data/minWeight1-3.mat';
%get data 
load(filename1);
tableViterbi =table;

%get data 

load(filename2);
tableMinWeight =table;

figure
plot(log10(tableMinWeight(:,2)),log10(tableMinWeight(:,4)),'-o',...
    log10(tableViterbi(:,2)),log10(tableViterbi(:,4)),'-o',...
    log10(pms),log10(pm_fail),'--',...
    log10(pms),log10(Pcw),':')
legend('convolutional min weight','convolutional viterbi','repetition','upper bound with approximate WEF')
legend('Location','northwest')
 title('decoding simulation for syndrome part only');
 xlabel('error probability on qubits and syndrome bits (log10)')
 ylabel('rate of decoding failure (log10)')
 
 function Prw2 = getPw2(w,pm)
    Prw2 = 0.5*nchoosek(w,w/2)*pm^(w/2)*(1-pm)^(w/2);
 end
 
 function Pw = getPw(w,pm)
    Pw=0;
    if mod(w,2)
        %odd
        for j=ceil(w/2):w
            Pw =Pw+ nchoosek(w,j)*pm^j*(1-pm)^(w-j);
        end
    else
        %even
        Pw=getPw2(w,pm);
        for j=(w/2+1):w
            Pw=Pw+nchoosek(w,j)*pm^j*(1-pm)^(w-j);
        end
    end
 end
 
 function Pcw = getPcw(d,N,Aw,pm)
    Pcw=0;
    
    for j=d:size(Aw,2)
        Pcw=Pcw+Aw(j)*getPw(j,pm);
    end
 
 end