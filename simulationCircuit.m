%% Weilei Zeng Feb 19, 2019
%% This file run simulations for GA and GR code with the circuit error model. The difference from simulationRepeatCircuit.m is that this program read trellis but that one construct the matrix and trellis. (I think this can be generalized by save trellis for GI code and G code to file)





% Weilei Zeng, Jan 2019

% put all simulation together, allowed different codes and different error
% model
% Weilei Zeng, 2018 Aug 14
%run it for the corrected P matrix
% Definition of error mode: pq=qubit error prob, ps =syndrome error prob
% (a) pq=ps=pm
% (d) ps=(1-(1-2pm)^wt(g))/2,pq=(1-(1-2pm)^(n/2))/2; pq =~ 10 ps
% (b) pq=pm, ps=(1-(1-2pm)^wt(g))/2; pq<<ps
% (c) pq=(1-(1-2pm)^(n/2))/2, ps =pm; pq>>ps
% see more error model in generate_error_prob.m

% termination flag of loops: 
 % 1. numFails: max number of bad errors, 
 % 2. dataPointsTimes: time limit for each data point in seconds


% weilei Zeng, 08/06/2018
% Run simulation on error decoding for the designed DS code P, 



% addpath('~/working/matlab/mmio/') % add path for Martrix Market IO. This is not in use, because data from CPP program for circuit error model has been converted into matlab .mat file there.

% paratemters moved to runCircuit.sh:
 % numTrialsMAX = 200;%10000
 %numFails=50;%100
 %errorModel='a';
%file_version="hard-2-1"
% error_folder='~/working/circuit/quantumsimulator/error/run8'; % run6
%code='code1';
 %dataPointTime=0.3;%60;%in seconds
 %numViterbiMax=ceil(dataPointTime*300/repeat) %not in use anymore Fen 19,2019
 %totalTimeEstimation=dataPointTime*size(pms,2) %not in use. use remained time actually

repeat = 9;%For GA and GR code, repeat = 9 for 24 qubits, repeat 7 in repetition case; %17 for 51 qubits  %5,7,11,21,31,40

 folder = ['data/trellis/',code];%folder to read trellis
 filename = ['data/circuit/',code,'/simulationCircuit',num2str(repeat),...
     'model-',errorModel,file_version,'.mat'] %filename to save the finale data (table)

 error_filename_prefix=[code,'repeat',num2str(repeat)]; 
 load([error_folder,'/',error_filename_prefix,'prob_mat.mat']); %get pms
 % prob_mat=mmread([error_folder,'/',error_filename_prefix,'prob_mat.mtx']); replaced by load
 %pms=full( prob_mat(:,2)' )
 % pms=pms(1:end-1)

 %not calculate from here anymore. pq is saved inthe error file
 % pqs=1/2-(1-2*pms).^10/2; %error probability on qubits after each round of syndrome measurement
 %pss=pqs*0.01;%error probability on each syndrome bit after each round of syndrome measurement
 %pss=min(pss,0.3) %an bound to avoid number larger than 0.5 
 

 % get P and trellis from file
 [P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip,P_dual]...
    = getSavedTrellis(repeat,folder);
 Gtransfer=getGtransfer(P,Qtransfer,Ptransfer);

 
division = size(pms,2);
table = zeros(division,7);

%for ip = 1:division
parfor ip = 1:division
    tic
    pm = pms(ip);
    %pq = pms(ip);
    %error_prob = generate_error_prob_vector(errorModel,numInputSymbols,pm,weightP);


    %Jan 10 2018, weilei,
    %change soft to hard decision
    %metric_vec_log = ones(1,size(metric_vec_log,2) ); %hard decision
    %metric_vec_log = numInputSymbols; %larger qubit error probability
    
    filename_prefix=[error_folder,'/',error_filename_prefix,'p',num2str(pm,"%.6f")];
    %    [errorMat,syndromeMatCircuit]=get_error_circuit(numInputSymbols,Qtransfer,filename_prefix);
    [pq,errorMat,syndromeMatCircuit]=load_error_circuit(numInputSymbols,Qtransfer,filename_prefix);
    switch errorModel %avoid too large error probabilities on syndrome bits
      case 'i'
        %    if errorModel == 'i'
        if pq>0.05
            continue
        end
        %    end
      case 'h'
        %    if errorModel == 'h'
        if pq>0.5
            continue
        end
    end
    
    error_prob_syndrome = generate_error_prob_vector(errorModel,numInputSymbols,pq,weightP);% prob = 0 for qubits
    
    error_prob=pq*ones(1,size(numInputSymbols,2));%assume ps=pq
    metric_vec_log = - log10( error_prob./(1-error_prob) );
    % Here I use a new counting method, where I count the number of round for successful decoding until it fails, then I take an     average of this number. I expect this number, called lifetime, equals numGoodError/(numTrial-numGoodError) <=1/p_fail-1
    lifetime=0; lifetimeVec=[];
    errorRemained=zeros(1,size(numInputSymbols,2)); %zero remained error for first round of decoding
    syndromeRemained=zeros(1,size(P,1)); %syndrome for remained error is zero for first round of decoding
    
    numGoodError=0;
    numViterbi=0; %number of trials of viterbi decoding, (zero error will be skipped for decoding)
    numTrials=size(errorMat,1); %total number of trials
    
    for i = 1:numTrials
        errorInput=errorMat(i,:);
        syndromeP0=syndromeMatCircuit(i,:);
        syndrome=syndromeP0*Gtransfer';        %transfer syndrome(s_1 s_2) to match index of permuted P


        switch errorModel %add additional measurement error for this two model
          case {'h','i'}
            errorMeasurement = generate_error_from_model(numInputSymbols,error_prob_syndrome);
            syndrome=bitxor(syndrome,errorMeasurement*Ptransfer'); %there will be no qubit error in errorMeasurement
        end
        
        %Two lines for phenomenological model A, comment these two lines for phenomenological model B
        if phenomenological_model=='A'
            %single shot measurement, error doesnot accumulate
            errorRemained=zeros(1,size(numInputSymbols,2));
            syndromeRemained=zeros(1,size(P,1));
        else %phenomenological_model=='B'
            errorInput=plusGF4vec(errorInput,errorRemained);%add remined error from last round
            syndrome=bitxor(syndrome,syndromeRemained);%add remained syndrome for remained error. In practic, this should be in the cpp program of circuit model. However, it is equivalent to calculate here.            
        end
                


        % decode for all errors, except zero vectors
        if sum(errorInput)==0 && sum(syndrome)==0%remove zero error
            isGoodError=1;
            isGoodRemainedError=1;
            errorRemained=zeros(1,size(numInputSymbols,2));
            syndromeRemained=zeros(1,size(P,1));

        else %decoding. We need to use the degenerate one to check remained error, using P_dual.
             %[isGoodError,errorRemained,syndromeRemained] =          viterbiDecoderGF4StripSoftCircuit(P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log,syndrome);
            [isGoodError,errorRemained,syndromeRemained] =          viterbiDecoderGF4DegenerateStripSoftCircuit(P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log,syndrome,P_dual);

            % after this decoding, check for errorRemained.
            isGoodRemainedError = viterbiDecoderGF4DegenerateStripSoft(...
                P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,...
                errorRemained,metric_vec_log,P_dual);

        end 
        if isGoodRemainedError
            lifetime=lifetime+1;
        else
            %record life time here, and reset parameters to zero to start another round of counting lifetime.
            %if j th round of decodin failed, then lifetime = j-1
            lifetimeVec(size(lifetimeVec,2)+1)=lifetime;
            lifetime=0;
            errorRemained=zeros(size(errorRemained));
            syndromeRemained=zeros(size(syndromeRemained));
        end
          
        if isGoodRemainedError
            numGoodError = numGoodError +1; 
            if i-numGoodError +1 > numFails
                break
            end
        end
        if i-numGoodError +1 > numFails
                break
        end
        if toc>dataPointTime
            break
        end
    end
    %p_fail= 1 - numGoodError/numTrials;
    p_fail = 1 - numGoodError/i;
    %    [pm,p_fail,i]'
    %    table(ip,:)=[i,pm,numGoodError,p_fail];
    lifetime=sum(lifetimeVec)/size(lifetimeVec,2);
    lifetime_p_fail=1/p_fail-1;
    %    [i,pm,numGoodError,p_fail,lifetime,lifetime_p_fail]
    disp(num2str( [i,pm,numGoodError,p_fail,lifetime,lifetime_p_fail,pq,toc]  ));
    table(ip,:)=[i,pm,numGoodError,p_fail,lifetime,lifetime_p_fail,pq];
    %    toc
end

%save results
disp('[i,         pm,      numGoodError,    p_fail,      lifetime,       lifetime_p_fail,   pq];')
disp(num2str(table))

description = 'simulation 6. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail,lifetime,lifetime_p_fail] ';
parameters =[repeat,numFails];
save(filename, 'description', 'parameters',  'table');
%tableConvolutional = table
filename
%simulationPlotSave(table,filename)
%simulationPlot(table,filename,repeat)
 

%copy from viterbidecoder....SoftCircuit.m
%function syndrome = measure(G,error,numInputSymbols) %GF4 and GF2;
%from parity check matrix G and row vector error e, calculate the row vector syndrome
%    syndrome = zeros(1,size(G,1));
%    ss=G;
%    for i =1:size(G,1)
%        for j = 1:size(G,2)
%            switch numInputSymbols(j)
%              case 4  %qubit error
%                ss(i,j)=traceGF4(G(i,j),error(j));
%              case 2  %syndrome error
%                ss(i,j) = G(i,j)*error(j);
%            end
%        end
%        temp_sum = sum(ss(i,:));
%        syndromebit = temp_sum - floor(temp_sum/2)*2;
%        syndrome(i)=syndromebit;
%    end
%end


function [pq,errorMat,syndromeMat]=load_error_circuit(numInputSymbols,Qtransfer,filename_prefix)
    filename_mat   =[filename_prefix,'.mat'];
    load(filename_mat);
    syndromeMat=syndromeMatCircuit;
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
                        
               

