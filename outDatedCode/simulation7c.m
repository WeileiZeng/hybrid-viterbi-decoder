% change error model from random to some model

% weilei Zeng, 08/06/2018
% Run simulation on error decoding for  the repetition case
% modified from simulation2.m
% paratemter:
 numTrials = 20000;
  numFails=100;
  repeat = 4;
  
 filename = "data/simulation7c-2.mat";

  %new parameter
 pms=0.5:0.2:4
 pms=0.1.^pms 
 
%example input 2: terminated convolutional code [1 1 1 1 w W]

%construct the code
g1=[1 1 1;2 2 2 ];g2=[ 1 2 3; 2 3 1 ];
grepeat=repeat;
G=[zeros(2,(grepeat+1)*3);kron(eye(grepeat+1),g1)] ...
    +[kron(eye(grepeat+1),g2);zeros(2,(1+grepeat)*3) ];
rowG = size(G,1);
P=[G, eye(rowG)];

 
%get trellis
tic
[strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
disp('time to get trellisGF4Strip')
trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
toc

division = size(pms,2);
table = zeros(division,4);


for ip = 1:size(pms,2)  
%     pm = pms(ip)
%     pq = pms(ip);
%     
     pm = pms(ip);
    %pq = pms(ip);
    error_prob = generate_error_prob_vector(numInputSymbols,pm,weightP);   
    
    
    numGoodError=0;
    for i = 1:numTrials
        %[errorInput,syndromeError]= generate_error(numInputSymbols,pq,pm);
        [errorInput,syndromeError] = generate_error_from_model(numInputSymbols,error_prob);
        if syndromeError
            isGoodError =0;
        elseif sum(errorInput) <2 %optimization, can also eliminate the single errors
            isGoodError =1;
        else
            isGoodError = viterbiDecoderGF4Strip(...
           P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
         end 
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
    table(ip,:)=[0,pm,numGoodError,p_fail];
end

%save results
description = 'simulation 7. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numTrials];
save(filename, 'description', 'parameters',  'table');
tableRepetition = table
%plot(table(:,2),table(:,4))
 plot(log10(table(:,2)),log10(table(:,4)))
 
 plot(log10(tableConvolutional(:,2)),log10(tableConvolutional(:,4)),'--',log10(tableRepetition(:,2)),log10(tableRepetition(:,4)),'-o')
 
  
 legend('convolutional viterbi','repetition')
 title('decoding simulation');
 xlabel('error probability on qubits and syndrome bits (log10)')
 ylabel('rate of decoding failure (log10)')
 
 
function [error,syndromeError] = generate_error(numInputSymbols,pq,pm)
%generate radnom error from given erro model/probability
    syndromeError=0;
    length = size(numInputSymbols,2);
    error=zeros(1,length);
    rand_vec = rand(1,length);
    pq3=pq/3; %error probability for X, Y or Z error
    pm_bad = 1-(1-pm)^3-2*pm*(1-pm)^2; %repeat mesurement 3 times
    for i =1:length
        switch numInputSymbols(i)
            case 2
                if rand_vec(i)< pm_bad 
                    error(i) = 1;               
                    syndromeError=1;
                end
            case 4
                if rand_vec(i) < pq3
                    error(i)=1;
                elseif rand_vec(i) <2*pq3
                    error(i) = 2;
                elseif rand_vec(i) < pq
                    error(i) = 3;
                end
        end
    end
end
                        
function [error,syndromeError] = generate_error_from_model(numInputSymbols,error_prob)
%generate radnom error from given error model/probability
    syndromeError=0;
    length = size(numInputSymbols,2);
    error=zeros(1,length);
    rand_vec = rand(1,length);
    for i =1:length
        switch numInputSymbols(i)
            case 2
                p_temp=error_prob(i);
                pm_bad = 1-(1-p_temp)^3-2*p_temp*(1-p_temp)^2; %repeat mesurement 3 times
                if rand_vec(i)< pm_bad 
                    error(i) = 1;               
                    syndromeError=1;
                end
            case 4
                pq3=error_prob(i)/3;
                if rand_vec(i) < pq3
                    error(i)=1;
                elseif rand_vec(i) <2*pq3
                    error(i) = 2;
                elseif rand_vec(i) < 3*pq3
                    error(i) = 3;
                end
        end
    end
end
                        
function error_prob = generate_error_prob_vector(numInputSymbols,pm,weightP)
% %generate radnom error from given erro model/probability
% % pq=pm,ps=(1-(1-2pm)^wt(g))/2
% %return a vector of pq and ps
% 
%     length = size(numInputSymbols,2);
%     error_prob=zeros(1,length);
% 
%     for i =1:length
%         switch numInputSymbols(i)
%             case 2
%                 error_prob(i) = (1-(1-2*pm)^weightP(i))/2;
%             case 4              
%                 error_prob(i)=pm;
%         end
%     end
 %generate radnom error from given erro model/probability
% ps=pm,pq=(1-(1-2pm)^(n/2))/2
%return a vector of pq and ps

    length = size(numInputSymbols,2);
    error_prob=zeros(1,length);
    n= -sum(numInputSymbols/2-2);
    for i =1:length
        switch numInputSymbols(i)
            case 2
                error_prob(i) = pm;
            case 4 
                error_prob(i)=(1-(1-2*pm)^(n/2))/2;
        end
    end   
    
end                
         

