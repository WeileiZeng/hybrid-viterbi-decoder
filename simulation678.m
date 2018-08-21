% put all simulation together, allowed different codes and different error
% model
% Weilei Zeng, 2018 Aug 14
%run it for the corrected P matrix
% Definition of error mode: pq=qubit error prob, ps =syndrome error prob
% (a) pq=ps=pm
% (d) ps=(1-(1-2pm)^wt(g))/2,pq=(1-(1-2pm)^(n/2))/2; pq =~ 10 ps
% (b) pq=pm, ps=(1-(1-2pm)^wt(g))/2; pq<<ps
% (c) pq=(1-(1-2pm)^(n/2))/2, ps =pm; pq>>ps
% termination flag of loops: 
 % 1. numFails: max number of bad errors, 
 % 2. dataPointsTimes: time limit for each data point in seconds


% weilei Zeng, 08/06/2018
% Run simulation on error decoding for the designed DS code P, 

% 1 designed DS code P
% paratemter:

 numTrialsMAX = 10000000;%10000
 numFails=100;%100
 
 errorModel='d';
 repeat = 4+7;%17 for 51 qubits
 code='code3';
 folder = ['data/trellis/',code];
 %filename = 'data/simulation8a-5.mat'
 %filename = 'data/simulations/code2/simulation8a-51qubits-1.mat'
 filename = ['data/simulations/',code,'/simulation678-repeat',num2str(repeat),...
     'model-',errorModel,'-soft-2.mat']
 switch errorModel
     case {'a','b'}
         pms=0.5:0.4:4
     case {'c','d'}
         pms=0.5:0.4:6
 end
 pms=0.1.^pms 
 dataPointTime=60;%in seconds
 numViterbiMax=ceil(dataPointTime*300/repeat)
 totalTimeEstimation=dataPointTime*size(pms,2) 
 %this is good for small error Prob, not for big erro prob

 % get P and trellis from file
 [P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip]...
    = getSavedTrellis(repeat,folder);

division = size(pms,2);
table = zeros(division,4);

for ip = 1:size(pms,2)  
    tic
    pm = pms(ip);
    %pq = pms(ip);
    error_prob = generate_error_prob_vector(errorModel,numInputSymbols,pm,weightP);   
    metric_vec_log = - log10( error_prob./(1-error_prob) );
    numGoodError=0;
     numViterbi=0;
    i=0;
    %for i = 1:numTrials
    while numViterbi<numViterbiMax && i<numTrialsMAX
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
            %soft or hard decisoin decoding
%             isGoodError = viterbiDecoderGF4Strip(...
%            P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
            isGoodError = viterbiDecoderGF4StripSoft(...
               P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log);
       
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
    [pm,p_fail,i]'
    table(ip,:)=[i,pm,numGoodError,p_fail];
    toc
end

%save results
description = 'simulation 6. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numViterbiMax];
save(filename, 'description', 'parameters',  'table');
tableConvolutional = table
filename
simulationPlot(table,filename,repeat)
 
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
                        
               

