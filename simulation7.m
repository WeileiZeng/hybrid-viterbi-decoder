%% Weilei Zeng, Feb 19, 2019
%% run simulation for GI and G code, for phenomenogical error model A and B

% weilei Zeng, 08/06/2018
% Run simulation on error decoding for  the repetition case
% allowed different error model
% modified from simulation2.m

% paratemter from runSimulation.sh
%only use numFails
% numTrials = 1000000;%200000
 % numFails=200;%100
 %  p_fail_min=0.00001; %0.00001  p_fail stop when reach this value
  %errorModel='g';%d b
  %code='code1';
code='code8';
%  G_code_switch=0; %0 for off ;1 for on
% file_version='-G-soft-1-test';
repeat = 7;%7 for 24 qubits code

  %add name flag to distinguish between GI and G. notice that there is no difference in the name of GI with and without majority vote.
  if G_code_switch == 1
      G_code_text='-G';
  else
      G_code_text='';
  end
 folder = ['data/trellis/',code]; %folder to read the saved trellis from. not in use here
                                  % filename = ['data/simulations/',code,'/simulation7-repeat',num2str(repeat),...

 filename = ['data/circuit/',code,'/simulation7-repeat',num2str(repeat),... %weilei Feb 3 2019
             'model-',errorModel,G_code_text,file_version,'.mat']   
 
 % ratio_ps_pq=3;
 %log scaled error probability: 1 for -1; 0.1 for -2; 10 for -3
 pms=0.5:0.25:4;  

 switch errorModel %change range of pms accordingly
   case 'g'
     pms=1.5:0.25:4.5;
     %     pms=2.5:0.25:4.5;  
   case {'e','f'}
     pms=0.5:0.25:4.5;
     %pms=2.5:0.25:4.5;
     %     pms=0.2:0.1:2  %for a check
 end

 pms
 pms=0.1.^pms ;

 %want to move this part to saveTrellis to File
%example input 2: terminated convolutional code [1 1 1 1 w W],

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
                       
    %[strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
    disp('time to get trellisGF4Strip')
    trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
    toc
end


division = size(pms,2);
table = zeros(division,7);




%for ip = 1:size(pms,2)
parfor ip = 1:division
    tic
    pm = pms(ip);
    pq = pms(ip);
    disp( ['start calculating for log10(pm) = ', num2str(log10(pm)) ] );
    disp( ['dataPointTime = ',num2str(dataPointTime),' sec, remaining time = ',...
           num2str( dataPointTime * ( size(pms,2)-ip)/60 ),' min'] );
    %remained time is not accurate in the case of parfor
    error_prob = generate_error_prob_vector(errorModel,numInputSymbols,pm,weightP);
    %    error_prob= (1-Qtransfer)*pm+Qtransfer*pm*ratio_ps_pq;
    
    %change error_prob for majority vote, for both GI and G decoder; switch it off for repeated measurement and decoding without majority vote
    majority_vote_flag=0
    if majority_vote_flag
        error_prob_s=Qtransfer.*error_prob; %syndrome part
        error_prob_vote = error_prob_s.^3+3*(error_prob_s.^2).*(1-error_prob_s);
        error_prob= (1-Qtransfer).*error_prob + Qtransfer.*error_prob_vote;
    end
    
    metric_vec_log = - log10( error_prob./(1-error_prob) );
    lifetime=0; lifetimeVec=[]; %counting life time
    numGoodError=0;
    i=0;
    errorRemained=zeros(1,size(numInputSymbols,2)); %zero remained error for first round of decoding
    while 1  %only control by numFails
        i=i+1;
        [errorInput,syndromeError] = generate_error_from_model(numInputSymbols,error_prob);

        if phenomenological_model=='B'
            errorInput=plusGF4vec(errorInput,errorRemained);%add remined error from last round
        end
        
        if sum(errorInput) == 0 % remove zero error, any nonzero error seems not valid for removing
            isGoodError=1;
            
        elseif G_code_switch ==1 && syndromeError  % wrong syndrome ,G decoder
            isGoodError=0;
            %check if it gives wrong decoding
            %isGoodError = viterbiDecoderGF4StripSoft(...
            %   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log);
            %if isGoodError
            %   numInputSymbols
            %   i
            %   inputError
            %   pause
            %end
        else
            %[isGoodError,errorRemained] = viterbiDecoderGF4StripSoft(...
            %  P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log);
            [isGoodError,errorRemained] = viterbiDecoderGF4DegenerateStripSoft(...
               P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log,P_dual);
           if isGoodError==0 % check logical failure
                             %isGoodError = viterbiDecoderGF4StripSoft(...
                             %P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorRemained,metric_vec_log);
               isGoodError = viterbiDecoderGF4DegenerateStripSoft(...
                   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log,P_dual);
           end
           
        end

           %end 
        if isGoodError
            numGoodError = numGoodError +1;
            lifetime=lifetime+1;
        else
            errorRemained=zeros(1,size(numInputSymbols,2));
            lifetimeVec(size(lifetimeVec,2)+1)=lifetime;
            lifetime=0;
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
    table(ip,:)=[i,pm,numGoodError,p_fail,lifetime,lifetime_p_fail,0];
    toc
end

%save results
description = 'simulation 7. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numFails];
save(filename, 'description', 'parameters',  'table');
tableRepetition = table
filename
%simulationPlot(table,filename,repeat)
%simulationPlotSave(table,filename)

%save the figure directly without display it.
fig=figure('visible','off');
plot(log10(table(:,2)),log10(table(:,4)),'-o') %plot p_fail
title(filename);
xlabel('error probability on qubits and syndrome bits (log10)')
ylabel('rate of decoding failure (log10)')
saveas(fig,[filename(1:end-4),'.fig'],'fig')
saveas(fig,[filename(1:end-4),'.png'],'png')
%system('./sync_to_macbook_weilei.sh')



              
              
function [error,syndromeError] = generate_error_from_model(numInputSymbols,error_prob)
%This function could be generalized to a seperate function for all simulations
    
%generate radnom error from given error model/probability
%syndromeError is a flag that if syndrome is wrong, the decoding will
%be wrong eventually, so no decoding is needed. (this is for G decdoer, not GI decoder)
    syndromeError=0;
    length = size(numInputSymbols,2);
    error=zeros(1,length);
    rand_vec = rand(1,length);
    for i =1:length
        switch numInputSymbols(i)
            case 2
              p_temp=error_prob(i);
              %error probability for the majority vote has beenremoved to upper level such that the soft decision can use the same modified error_prob
                %pm_bad = 1-(1-p_temp)^3-2*p_temp*(1-p_temp)^2; %repeat mesurement 3 times % should be 3*p_temp... in last term
                %                pm_bad=p_temp^3+3*(1-p_temp)*p_temp^2; % Feb 3 2019 soft-4
                pm_bad=p_temp;
                if rand_vec(i)< pm_bad 
                    error(i) = 1;               
                    syndromeError=1;
                end
            case 4
                pq3=error_prob(i)/3;
                if rand_vec(i) < pq3
                    error(i) = 1;
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
% input P=[G,I], mix columns of G and I

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
%P=P1
%end

end
