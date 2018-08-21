% apply min weight decoding for any block code and compare it with Viterbi
% decoding. Result is positive, they have identical decoding results
%sample input: classical convolutional code with repeat =
% r =4

%construct C
gc=[1 1 0 1 1 1];
r=4
Ar=[ kron(eye(r),gc(1:2)) zeros(r,4)]...
    +[ zeros(r,2) kron(eye(r),gc(3:4)) zeros(r,2)]...
    +[ zeros(r,4) kron(eye(r),gc(5:6))];

G=[eye(size(Ar,1)),Ar];

s=0:15;
u=mod(dec2bin(s),4);

for j = 1:16
    uu = u(j,:);
    v = mod(uu*G,2)
    C(j,1:16)=v;
end
C=(-1).^C;



Pc=[ kron(eye(r),gc(1:2)) zeros(r,4)]...
    +[ zeros(r,2) kron(eye(r),gc(3:4)) zeros(r,2)]...
    +[ zeros(r,4) kron(eye(r),gc(5:6))];
Pc =Pc'
%Pc=[eye(size(Pc,2),size(Pc,1)+size(Pc,2)); Pc eye(size(Pc,1))]; %not decodable in the program
Pc=[ Pc eye(size(Pc,1))];
% %Pr = randi([0 1], 16,16)

% weilei Zeng, 08/06/2018
% soft decision decoding
% Run simulation on error decoding for the designed DS code P, 

% 1 designed DS code P
% paratemter:
 numTrials = 10000;
 numFails=10;
 repeat = 4;
 p_error_max = 0.02;
 %division = 20;
 filename = 'data/minWeight1-4.mat'
 
 %new parameter
 pms=0.5:0.1:1.5
 pms=0.1.^pms 

 %construct P and trellis 
tic
P = Pc;
[strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P)
disp('time to get trellisGF4Strip')
trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
toc

division = size(pms,2);
table = zeros(division,4);

for ip = 1:size(pms,2)
%     p_error = p_error_max*ip/division;
%     pm = p_error; %error probability for measuremnt/syndrome error
%     pq = p_error; % error probability for qubit error
    
    pm = pms(ip)
    pq = pms(ip);
    
    numGoodError=0;
    for i = 1:numTrials
        errorInput= generate_error(numInputSymbols,pq,pm);
        %viterbi decoding
        isGoodErrorViterbi = viterbiDecoderGF4Strip(...
           P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
       %min weight decoding
        e=(-1).^errorInput;
        x=C*e';
        [m,ind]=max(x);
        if ind ==1
            isGoodErrorMinWeight =1;
            if isGoodErrorViterbi ==0
            end
        else
            isGoodErrorMinWeight =0;
        end
     
        if isGoodErrorMinWeight 
            numGoodError = numGoodError +1; 
            if i-numGoodError > numFails
                break
            end
        else       
        end
    end
    p_fail = 1 - numGoodError/i
    table(ip,:)=[pq,pm,numGoodError,p_fail];
end

%save results
description = 'viterbi and minWeightDecoding. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numTrials];
save(filename, 'description', 'parameters',  'table');
tableMinWeight = table

%repetition
pm=pms %0:p_error_max/division:p_error_max;
pm_good = (1-pm).^3-2*pm.*(1-pm).^2
pm_fail=1-pm_good.^r;



%plot(table(:,2),table(:,4),pm,pm_fail)
% 
% plot(log10(table(:,2)),log10(table(:,4)),'-o',log10(pm),log10(pm_fail))
% legend('convolutional','repetition')



function error = generate_error(numInputSymbols,pq,pm)
%generate radnom error from given erro model/probability
    length = size(numInputSymbols,2);
    error=zeros(1,length);
    r = rand(1,length);
    pq3=pq/3; %error probability for X, Y or Z error
    for i =1:length
        switch numInputSymbols(i)
            case 2
                error(i) = (r(i)< pm ) *1;
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
                        
                

