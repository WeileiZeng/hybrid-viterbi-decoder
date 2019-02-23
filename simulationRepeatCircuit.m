%% Weilei Zeng Feb 19, 2019
%% This program run simulation for GI and G code with circuit error model. GI could be with majority vote or no majority vote

% Jan 12 2018
% This program read errors generated from the cpp program for circuit error mode. The input is seperated into qubit error and syndrome. This program is only for the repeating measurement, hence no A part in P matrix.

% summary of change, compared with simulation7.m
% - use hard decision decoding, no input error probability distribution
% - add new quantity lifetime=1/p_fail-1; still plot p_fail though
% - For each error, add an extra round of perfect syndrome measurement. If it fails, count and reset the lifetime. Otherwise, it is a successful decoding where remained qubit error accumulate to next round.
% - syndrome error = 0; remove previous optimization on decoding
% - read error from file


% weilei Zeng, 08/06/2018
% Run simulation on error decoding for  the repetition case
% allowed different error model
% modified from simulation2.m

% addpath('~/working/matlab/mmio/')
% paratemter:
 % dataPointTime=60;
 %numTrials = 200;%200000
 %numFails=1000;%100
 %errorModel='a';
 %code='code1';
 %file_version='-GI-soft-1-2';
%error_folder='~/working/circuit/quantumsimulator/error/run5'; % run8 run6 run4
%error_folder='~/working/circuit/quantumsimulator/error/GI_run11'

 repeat = 7;% repeat = 7 for 24 qubit code
 folder = ['data/trellis/',code];
 
 filename = ['data/circuit/',code,'/simulationRepeatCircuitRepeat',num2str(repeat),...
     'model-',errorModel,file_version,'.mat'] %file to save result

 % ratio_ps_pq=1; % 1 for hard decision, otherwise soft decision



error_filename_prefix=[code,'repeat',num2str(repeat)];

%load pms
load([error_folder,'/',error_filename_prefix,'prob_mat.mat'],'pms');


%I want to move this to saveTrellis to file
%example input 2: terminated convolutional code [1 1 1 1 w W]
constructCode=1;
if constructCode ==1
    %construct the code
    switch code
        case {'code1','code2'}
            g1=[1 1 1;2 2 2 ];g2=[ 1 2 3; 2 3 1 ];
            grepeat=repeat;
            G=[zeros(2,(grepeat+1)*3);kron(eye(grepeat+1),g1)] ...
                +[kron(eye(grepeat+1),g2);zeros(2,(1+grepeat)*3) ];
            rowG = size(G,1);
            P=[G, eye(rowG)];

      case 'code8'
        %copy from code 1
        g1=[1 1 1;2 2 2 ];g2=[ 1 2 3; 2 3 1 ];
        grepeat=repeat;
        G=[zeros(2,(grepeat+1)*3);kron(eye(grepeat+1),g1)] ...
          +[kron(eye(grepeat+1),g2);zeros(2,(1+grepeat)*3) ];
        rowG = size(G,1);

        %modify G for code 8
        codeword=[3 2 1]; %for P and P_dual
        codeword2=[1 3 2]; %for P_dual

        G(2,1:3)=codeword;
        G(end-1,(end-2):end)=codeword;

        P=[G, eye(rowG)];
        %change
        %get P_dual here, and then transform with P later after massaging
        half_row_P_dual=grepeat-1;%half of the number of rows in P_dual
        P_dual = [ zeros(2*half_row_P_dual,3),  kron(eye(grepeat-1),[codeword;codeword2]),...
                   zeros(2*half_row_P_dual,3)];%This P_dual has some (rowG) missing zero colums, will add later
        
            
        case 'code3'                   
    end
    P = massageP(P);
    %get trellis
    tic
    [strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);

    %change P_dual accorddingly.
    for i=1:size(Qtransfer,2)
        if Qtransfer(i)==1 %syndrome bits, add a zero column
            P_dual=[P_dual(:,1:i-1),zeros(2*half_row_P_dual,1),P_dual(:,i:end)  ];
        end
    end
    
    disp('time to get trellisGF4Strip')
    trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
    toc
end



division = size(pms,2);
table = zeros(division,7);%change from 4 to 7 to add lifetime and lifetime_p_fail and pq


parfor ip=1:division
    tic
    pm = pms(ip);

    %        metric_vec_log = - log10( error_prob./(1-error_prob) ); % not in use

    %Jan 10 2018, weilei,
    %change soft to hard decision
    %    metric_vec_log = ones(1,size(metric_vec_log,2) );


    filename_prefix=[error_folder,'/',error_filename_prefix,'p',num2str(pm,"%.6f")];
    %    [errorMat,syndromeMatCircuit]=get_error_circuit(numInputSymbols,Qtransfer,filename_prefix);
    [pq,errorMat,syndromeMatCircuit]=load_error_circuit(numInputSymbols,Qtransfer,filename_prefix);
    if errorModel == 'i' %avoid too large error prob on syndrome bit
        if pq>0.05
            continue
        end
    end
    
    error_prob_syndrome = generate_error_prob_vector(errorModel,numInputSymbols,pq,weightP);
    

    %vary error_prob for soft decoding Jan 31 2019 Weilei
    %    error_prob=pq*(numInputSymbols.^5)/64/16; %pq=32*ps
    %error_prob=pq*(numInputSymbols)/4; %pq=2*ps  less-ps
    %error_prob=(6-numInputSymbols-1.8)/4.4; %-1.8: ps =0.5; pq=0.5*ps  less-pq
    %error_prob=Qtransfer*pq+(1-Qtransfer)*pq*ratio_ps_pq; %soft decision decoding ps=pq*ratio_ps_pq
    %error_prob=Qtransfer*pq+(1-Qtransfer)*0.95; %soft decision decoding ps=pq*ratio_ps_pq
    %    error_prob=min(error_prob,0.95);
    %metric_vec_log = - log10( error_prob./(1-error_prob) );
    %    metric_vec_log = metric_vec_log.^2; enlarge the difference
    metric_vec_log = ones(1,size(metric_vec_log,2) ); %hard decision
    
    % Here I use a new counting method, where I count the number of round for successful decoding until it fails, then I take an average of this number. I expect this number, called lifetime, equals numGoodError/(numTrial-numGoodError) <=1/p_fail-1
    lifetime=0; lifetimeVec=[];
    errorRemained=zeros(1,size(numInputSymbols,2)); %zero remained error for first round of decoding
    syndromeRemained=zeros(1,size(P,1)); %syndrome for remained error is zero for first round of decoding

    numTrials=size(errorMat,1); %total number of errors for this probability pm, we called it 't' in other place, for number of trials
    numGoodError=0;
    for i = 1:numTrials      
        
        errorInput=errorMat(i,:);
        syndrome=syndromeMatCircuit(i,:);
        switch errorModel
          case {'h','i'}
            [errorMeasurement,syndromeError] = generate_error_from_model(numInputSymbols,error_prob_syndrome);
            %sum(errorMeasurement);
            syndrome=bitxor(syndrome,errorMeasurement*Ptransfer'); %there will be no qubit error in errorMeasurement
        end
        
        %add another layer of measurement error


        %Two lines for phenomenological model A, comment these two lines for phenomenological model B
        if phenomenological_model=='A'
            %single shot measurement, error doesnot accumulate
            errorRemained=zeros(1,size(numInputSymbols,2));
            syndromeRemained=zeros(1,size(P,1));
        end
        
        errorInput=plusGF4vec(errorInput,errorRemained);%add remined error from last round
        syndrome=bitxor(syndrome,syndromeRemained);%add remained syndrome for remained error. In practic, this should be in the cpp program of circuit model. However, it is equivalent to add here.

          % decode for all errors, except zero error vectors
          if sum(errorInput)==0 && sum(syndrome)==0 %remove zero error
                                
              isGoodError=1;
              isGoodRemainedError=1;
              errorRemained=zeros(1,size(numInputSymbols,2));
              syndromeRemained=zeros(1,size(P,1));
              %     elseif G_code_switch ==1 && syndromeError
                  % wrong syndrome filter, I didn't appy this to circuit error model
              %   isGoodError=0;
              %   errorRemained=errorInput.*(1-Qtransfer);%only qubit error remains
              %   syndromeRemained = measure(P,errorRemained,numInputSymbols);
              %   isGoodRemainedError = viterbiDecoderGF4StripSoft(...
              %   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,...
              %                   errorRemained,metric_vec_log);
              else
              %              [isGoodError,errorRemained,syndromeRemained] =	  viterbiDecoderGF4StripSoftCircuit(P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log,syndrome);
              [isGoodError,errorRemained,syndromeRemained] =	  viterbiDecoderGF4DegenerateStripSoftCircuit(P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log,syndrome,P_dual);

              % after this decoding, check for errorRemained. 
              isGoodRemainedError = viterbiDecoderGF4DegenerateStripSoft(...
              P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorRemained,metric_vec_log,P_dual);
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
              end
              if i-numGoodError +1 > numFails
                  break
                  end

          if toc >dataPointTime  %check runtime, want to change it to cpu runtime
              break
          end
    end
    p_fail = 1 - numGoodError/i;
    lifetime=sum(lifetimeVec)/size(lifetimeVec,2);
    lifetime_p_fail=1/p_fail-1;
    disp(num2str( [i,pm,numGoodError,p_fail,lifetime,lifetime_p_fail,pq,toc]  ));
    table(ip,:)=[i,pm,numGoodError,p_fail,lifetime,lifetime_p_fail,pq];
end

%save results
description = 'simulationRepeatCircuit. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numFails];
save(filename, 'description', 'parameters',  'table');
% 'table(ip,:)=[pq,pm,numGoodError,p_fail];'
%disp('  table(ip,:)=[i,pm,numGoodError,p_fail,lifetime,lifetime_p_fail];')
disp('[i,         pm,      numGoodError,    p_fail,      lifetime,       lifetime_p_fail,   pq];')
tableRepetition = table;
disp(num2str(table));
filename
timestep=10;
simulationPlotSave(table,filename,timestep)
%simulationPlot(table,filename,repeat)
 
function [pq,errorMat,syndromeMat]=load_error_circuit(numInputSymbols,Qtransfer,filename_prefix)
    filename_mat   =[filename_prefix,'.mat'];
    load(filename_mat);
    syndromeMat=syndromeMatCircuit;
    end
        
    

              
function [error,syndromeError] = generate_error_from_model(numInputSymbols,error_prob)
%generate radnom error from given error model/probability
%syndromeError is a flag that if syndrome is wrong, the decoding will
%be wrong eventually, so no decoding is needed.
    syndromeError=0;
    length = size(numInputSymbols,2);
    error=zeros(1,length);
    rand_vec = rand(1,length);
    for i =1:length
        switch numInputSymbols(i)
            case 2
              p_temp=error_prob(i);
              %no majority vote in circuit error model C
              %however, this is applied to the data in the first submiited version of the paper
                %pm_bad = 1-(1-p_temp)^3-2*p_temp*(1-p_temp)^2; %repeat mesurement 3 times
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
          
         

function P1 = massageP(P)
%masssage P to make it into strip form, in the repetition case, 
% input P=[G,I]

    [rowP,colP]=size(P);
    strip=zeros(2,colP);
    %get first and last nonzero element in each column
    for i_col = 1:colP
        for i_row=1:rowP
            if P(i_row,i_col)
                strip(1,i_col)=i_row;
                break
            end
        end
        
        for i_row=1:rowP 
            if P(rowP-i_row+1,i_col)
                strip(2,i_col)=rowP-i_row+1;
                break
            end
        end      
    end
    
    P1=zeros(rowP,colP);
    ig=1;
    ii=1;
    for i =1:colP
%         strip(1,colP-rowP-ig+1) , rowP-ii+1+1   
        if strip(1,colP-rowP-ig+1) < rowP-ii+1+1     
            P1(:,colP-i+1)=P(:,colP-ii+1);
            ii=ii+1;          
        else
            P1(:,colP-i+1)=P(:,colP-rowP-ig+1);
            ig = ig+1;
        end
        
    end
end
