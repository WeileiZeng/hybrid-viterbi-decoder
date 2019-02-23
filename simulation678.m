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
% paratemter: to control time
%Now only need to use dataPointTime and numFails


% numTrialsMAX = 1000000;%100000
%  numFails=2000;%100   %these two value  are not mainly control the time, use data point time
               % p_fail_min=0.00001;  
 %numViterbiMax=10000 % for each round typically 20000

 % dataPointTime=600;%600, 0.3 60;%in seconds
 %numViterbiMax=ceil(dataPointTime*300/repeat)
 % numViterbiMax=100000; % not in use anymore %=ceil(dataPointTime*100*repeat/5*0.9) %this has been replace by check toc with dataPointTime

 % pause
 %this is good for small error Prob, not for big erro prob


 % errorModel='f';
 repeat = 9;%17 for 51 qubits  %5,7,11,21,31,40   %code 1: 5 for 12 qubits
 % code='code1'; % code1 code5
 folder = ['data/trellis/',code];
 %filename = 'data/simulation8a-5.mat'
 %filename = 'data/simulations/code2/simulation8a-51qubits-1.mat'
 % filename = ['data/simulations/',code,'/simulation678-repeat',num2str(repeat),...

 % file_version='-soft-2-1'

 filename = ['data/circuit/',code,'/simulation678-repeat',num2str(repeat),...
             'model-',errorModel,file_version,'.mat']
 
 % ratio_ps_pq=10;
 %1 for -1; 0.1 for -2; 10 for -3
 
 switch errorModel
     case {'a','b'}
         %pms=0.6:0.1:1.5;
         pms=1.5:0.25:4
     case {'c','d'}
       pms=0.5:0.4:6.2 %         pms=0.5:0.4:6
                       %       pms=3:0.4:6.2 %         pms=0.5:0.4:6
   case 'g'
     pms=1.5:0.25:4.5;
     %     pms=2.5:0.25:4.5;
   case {'e','f'}
     pms=0.5:0.25:4.5;
     %     pms=2.5:0.25:4.5;
 end
 % pms=2.5
 
 pms
 pms=0.1.^pms;

 
 totalTimeEstimation=dataPointTime*size(pms,2) 


 % get P and trellis from file
 % [P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip]...
 [P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip,P_dual]...
    = getSavedTrellis(repeat,folder);

division = size(pms,2);
table = zeros(division,7);

%for ip = 1:size(pms,2)
parfor ip = 1:division
    tic

    pm = pms(ip);
    disp( ['start calculating for log10(pm) = ',num2str(log10(pm)) ] );
    disp( ['dataPointTime = ',num2str(dataPointTime),' sec, remaining time = ',...
           num2str( dataPointTime * ( size(pms,2)-ip)/60 ),' min'] )
    %pq = pms(ip);
    error_prob = generate_error_prob_vector(errorModel,numInputSymbols,pm,weightP);
    %    error_prob2 = error_prob.*(1-Qtransfer)+Qtransfer*; % ps=0.95
    %error_prob2= (1-Qtransfer)*0.45+Qtransfer*0.001; %for a check
    %    error_prob= (1-Qtransfer)*pm+Qtransfer*pm*ratio_ps_pq; %for a check
    
    %metric_vec_log = - log10( error_prob2./(1-error_prob2) );

    metric_vec_log = - log10( error_prob./(1-error_prob) );
    numGoodError=0;
    numViterbi=0;
    lifetime=0; lifetimeVec=[]; %counting life time
    i=0;
    %for i = 1:numTrials
    %    while numViterbi<numViterbiMax && i<numTrialsMAX
    %    while  i < numTrialsMAX
    errorRemained=zeros(1,size(numInputSymbols,2)); %zero remained error for first round of decoding
    
    while  1  %runtime is controled by numFails and dataPointTime
        i=i+1;
        errorInput = generate_error_from_model(numInputSymbols,error_prob);

        if phenomenological_model=='B'
            errorInput=plusGF4vec(errorInput,errorRemained);%add remined error from last round
        end

        
        %errorInput= generate_error(numInputSymbols,pq,pm);
        %        if sum(ceil(errorInput/4)) <2 
            %remove zero error and single error            
            %   isGoodError =1;
            %elseif sum(ceil(errorInput/4))==2  &&  (errorInput*Qtransfer'>0)
            %double error and at least one syndrome error, it is not able to
            %fix double qubit error. Save >50% of time.
            %isGoodError = 1;
            %if 1<0  %remove optimization to check soft decision decoding
            %'simulation678: 1<0'
            %pause
            %else
        if sum(errorInput) == 0 %remove zero error
                               %        if sum(ceil(errorInput/4)) <2 %remove zero and single error
            isGoodError=1;
        elseif sum(  ceil(errorInput/4) ) ==1  %remove single error, has been tested and verified in runCheckSoft.m
            isGoodError=1;
            %            disp(['i = ',num2str(i)])
            %          checkIsGoodError = viterbiDecoderGF4StripSoft(...
            %   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log);
            %if checkIsGoodError ~= isGoodError
            %    'No match'
            %   Qtransfer
            %   errorInput
            %   pause
            %end
        else            
            numViterbi = numViterbi+1;
            %soft or hard decisoin decoding
%             isGoodError = viterbiDecoderGF4Strip(...
%            P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
%            [isGoodError,errorRemained] = viterbiDecoderGF4StripSoft(...
%               P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log);
            [isGoodError,errorRemained] = viterbiDecoderGF4DegenerateStripSoft(...
                P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log,P_dual);
            if isGoodError == 0 % check again for logical failure
                                %isGoodError = viterbiDecoderGF4StripSoft(...
                                %P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorRemained,metric_vec_log);
                [isGoodError,errorRemained] = viterbiDecoderGF4DegenerateStripSoft(...
                P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log,P_dual);
            end
            %            disp(['                i = ',num2str(i)])
        end
        
        if isGoodError
            %check
            %if sum(errorInput)>0
            %   errorInput
            %   pause
            %end
            numGoodError = numGoodError +1;
            lifetime=lifetime+1;
            %            if i-numGoodError +1 > numFails
            %   break
            %end
        else
            errorRemained=zeros(1,size(numInputSymbols,2));
            lifetimeVec(size(lifetimeVec,2)+1)=lifetime;
            lifetime=0;
            %Qtransfer;
            %errorInput_syndrome_bit=errorInput.*Qtransfer;
            %errorInput_qubit=errorInput.*(1-Qtransfer);
            %weight=[ sum(errorInput_syndrome_bit), sum( ceil( errorInput_qubit/4 ) ) ]
            %pause
        end
        if i-numGoodError +1 > numFails 
            break
        end
        if toc > dataPointTime %check time used
            break
        end
    end
    p_fail = 1 - numGoodError/i;
    lifetime=sum(lifetimeVec)/size(lifetimeVec,2);
    lifetime_p_fail=1/p_fail-1;
    disp( num2str([i,pm,numGoodError,p_fail,lifetime,lifetime_p_fail,toc]));
    %    [pq,pm,numGoodError,p_fail,i]) )
    table(ip,:)=[i,pm,numGoodError,p_fail,lifetime,lifetime_p_fail,0];

    
    %p_fail= 1 - numGoodError/numTrials;
    %    p_fail = 1 - numGoodError/i;
    %    [pm,p_fail,i]'
    %disp( num2str( [i,pm,numGoodError,p_fail] ) )
    %table(ip,:)=[i,pm,numGoodError,p_fail];

    %    if p_fail < p_fail_min
    %   break
    %end

    
    toc
end

%save results
description = 'simulation 6. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numFails];
save(filename, 'description', 'parameters',  'table');
tableConvolutional = table
filename
%simulationPlot(table,filename,repeat)
%simulationPlotSave(table,filename)
 
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
                        
               

