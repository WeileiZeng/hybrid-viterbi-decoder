% change error model from random to some model c

% weilei Zeng, 08/06/2018
% Run simulation on error decoding for the designed DS code P, 

% 1 designed DS code P

  
  repeat = 17;% 17*3=51 qubits 
 %p_error_max = 0.2;
 filename = 'data/simulation6d-51qubits-7test.mat'
 
 % paratemter:
 numTrials = 1000;%10000
  numFails=50;%100 
 dataPointTime=60;%in seconds
 numViterbiMax=dataPointTime*20/repeat
  
 
%new parameter
 pms=2.5:0.2:4.5
 pms=0.1.^pms 
 
 totalTimeEstimation=dataPointTime*size(pms,2) 
 
%  % construct P and trellis from matrix generate  strip
% tic
% P = matrix_generate_strip(repeat);
% [strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
% disp('time to get trellisGF4Strip')
% trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
% toc
[P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip]...
    = getSavedTrellis(repeat,'data/trellis');

division = size(pms,2);
table = zeros(division,4);

for ip = 1:size(pms,2)  
    tic
    pm = pms(ip);
    %pq = pms(ip);
    error_prob = generate_error_prob_vector('d',numInputSymbols,pm,weightP);   
    numGoodError=0;
    numViterbi=0;
    i=0;
    while numViterbi<numViterbiMax
    %for i = 1:numTrials
        i=i+1;
        errorInput = generate_error_from_model(numInputSymbols,error_prob);
        %errorInput= generate_error(numInputSymbols,pq,pm);
        if sum(ceil(errorInput/4)) <2 
            %remove zeor error and single error            
            isGoodError =1;
        elseif sum(ceil(errorInput/4))==2  &&  (errorInput*Qtransfer'>0)
            %double error and at least one syndrome error, it is not able to
            %fix double qubit error. Save >50% of time.
            isGoodError =1;
        else
            numViterbi = numViterbi+1;
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
    [pm,p_fail,i,numGoodError]
    table(ip,:)=[i,pm,numGoodError,p_fail];
    toc
end

%save results
description = 'simulation 6. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numTrials];
save(filename, 'description', 'parameters',  'table');
tableConvolutional = table

figure
%plot(table(:,2),table(:,4))
 plot(log10(table(:,2)),log10(table(:,4)),'-o')
 %plot(log10(tableConvolutional(:,2)),log10(tableConvolutional(:,4)),'-o',log10(tableRepetition(:,2)),log10(tableRepetition(:,4)),'-o')
 
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
                        
% function error_prob = generate_error_prob_vector(numInputSymbols,pm,weightP)
% %generate radnom error from given erro model/probability
% % pq -=- 10 ps
% % ps=ps=(1-(1-2pm)^wt(g))/2,pq=(1-(1-2pm)^(n/2))/2
% %return a vector of pq and ps
% 
%     length = size(numInputSymbols,2);
%     error_prob=zeros(1,length);
%     n= -sum(numInputSymbols/2-2);
%     for i =1:length
%         switch numInputSymbols(i)
%             case 2
%                 %error_prob(i) = pm;
%                 error_prob(i) = (1-(1-2*pm)^weightP(i))/2;
%             case 4 
%                 error_prob(i)=(1-(1-2*pm)^(n/2))/2;
%         end
%     end
% end                

