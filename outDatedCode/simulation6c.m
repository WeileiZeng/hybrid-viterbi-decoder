% change error model from random to some model c

% weilei Zeng, 08/06/2018
% Run simulation on error decoding for the designed DS code P, 

% 1 designed DS code P
% paratemter:
 numTrials = 1000;%10000
  numFails=5;%100
  repeat = 17;
 %p_error_max = 0.2;
 filename = 'data/simulation6c-51qubits-1.mat'
 
%new parameter
 pms=0.5:0.2:3
 pms=0.1.^pms 
 
%  % construct P and trellis from matrix generate  strip
% tic
% P = matrix_generate_strip(repeat);
% [strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
% disp('time to get trellisGF4Strip')
% trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
% toc


division = size(pms,2);
table = zeros(division,4);

for ip = 1:size(pms,2)  
    pm = pms(ip);
    %pq = pms(ip);
    error_prob = generate_error_prob_vector(numInputSymbols,pm,weightP);   
    numGoodError=0;
    for i = 1:numTrials
        errorInput = generate_error_from_model(numInputSymbols,error_prob);
        %errorInput= generate_error(numInputSymbols,pq,pm);
        if sum(errorInput) <2 %optimization, can also eliminate the single errors
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
        if i-numGoodError +1 > numFails
                break
        end
    end
    %p_fail= 1 - numGoodError/numTrials;
    p_fail = 1 - numGoodError/i;
    [pm,p_fail,i]
    table(ip,:)=[0,pm,numGoodError,p_fail];
end

%save results
description = 'simulation 6. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numTrials];
save(filename, 'description', 'parameters',  'table');
tableConvolutional = table

%plot(table(:,2),table(:,4))
 %plot(log10(table(:,2)),log10(table(:,4)))
 plot(log10(tableConvolutional(:,2)),log10(tableConvolutional(:,4)),'-o',log10(tableRepetition(:,2)),log10(tableRepetition(:,4)),'-o')
 
 %plot((tableConvolutional(:,2)),(tableConvolutional(:,4)),'--',(tableRepetition(:,2)),(tableRepetition(:,4)),'-o')
 
 legend('convolutional viterbi','repetition')
 title('decoding simulation');
 xlabel('error probability on qubits and syndrome bits (log10)')
 ylabel('rate of decoding failure (log10)')
 
%comments: there are big variation in the plots
%possible reasons: the failure on qubits is much higher than the failure of
%syndrome bits.


function error = generate_error(numInputSymbols,pq,pm)
%generate radnom error from given erro model/probability Pq=Ps=Pm
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

function error = generate_error_from_model(numInputSymbols,error_prob)
%generate radnom error from given error model/probability

    length = size(numInputSymbols,2);
    error=zeros(1,length);
    rand_vec = rand(1,length);
    for i =1:length
        switch numInputSymbols(i)
            case 2
                error(i) = (rand_vec(i)< error_prob(i) ) *1;
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

