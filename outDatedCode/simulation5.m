%change the distribution of pm from linear to log

%compare just for the [A I] part, the performance of convolutional and
%repetition


gc=[1 1 0 1 1 1];
r=4
Pc=[ kron(eye(r),gc(1:2)) zeros(r,4)]...
    +[ zeros(r,2) kron(eye(r),gc(3:4)) zeros(r,2)]...
    +[ zeros(r,4) kron(eye(r),gc(5:6))];
Pc =Pc'
%Pc=[eye(size(Pc,2),size(Pc,1)+size(Pc,2)); Pc eye(size(Pc,1))]; %not decodable in the program
Pc=[ Pc eye(size(Pc,1))];
%Pr = randi([0 1], 16,16)

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
 filename = 'data/simulation5-4.mat'
 
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
    pm = pms(ip)
    pq = pms(ip);
    
    numGoodError=0;
    for i = 1:numTrials
        errorInput= generate_error(numInputSymbols,pq,pm);
        isGoodError = viterbiDecoderGF4Strip(...
           P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
        if isGoodError
            numGoodError = numGoodError +1; 
            if i-numGoodError +1 > numFails
                break
            end
        else       
            %errorInput
        end
    end
    %p_fail= 1 - numGoodError/numTrials;
    p_fail = 1 - numGoodError/i
    table(ip,:)=[pq,pm,numGoodError,p_fail];
end

%save results
description = 'simulation 5. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numTrials];
save(filename, 'description', 'parameters',  'table');
tableViterbi = table

%repetition
pm=pms %0:p_error_max/division:p_error_max;
pm_good = (1-pm).^3-2*pm.*(1-pm).^2
pm_fail=1-pm_good.^r;



%plot(table(:,2),table(:,4),pm,pm_fail)

plot(log10(table(:,2)),log10(table(:,4)),'-o',log10(pm),log10(pm_fail))
legend('convolutional','repetition')



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
                        
                

