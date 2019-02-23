%Weilei Feb 10 2019
%This one just do a test with Alexei, for a 9 quits code

% weilei Zeng, 08/06/2018
% Run simulation on error decoding for  the repetition case
% allowed different error model
% modified from simulation2.m
% paratemter:
%only use numFails
% numTrials = 1000000;%200000
 % numFails=200;%100
 %  p_fail_min=0.00001; %0.00001  p_fail stop when reach this value

%outside parameters
numFails=100000;
dataPointTime=60;
G_code_switch=0;
errorModel='f';
phenomenological_model='B'
file_version= ['-', phenomenological_model,'-1-4'];
%results -1-3 100sec logical failure
%        -1-4 60sec  decoding failure
%inside parameter
majority_vote_switch=0;
repeat = 2;  % 7;%7 for 24 qubits code

%filename = "data/simulation7-test.mat";

  %errorModel='g';%d b
  code='code1';
  %  G_code_switch=0; %0 for off ;1 for on
  if G_code_switch == 1
      G_code_text='-G';
  else
      G_code_text='';
  end
 folder = ['data/trellis/',code]; %folder to read the saved trellis from. not in use here
                                  % filename = ['data/simulations/',code,'/simulation7-repeat',num2str(repeat),...
    % file_version='-G-soft-1-test';
 filename = ['data/circuit/',code,'/simulation7-repeat',num2str(repeat),... %weilei Feb 3 2019
             'model-',errorModel,G_code_text,file_version,'.mat']   
 
 % ratio_ps_pq=3;
 %1 for -1; 0.1 for -2; 10 for -3
 pms=0.5:0.25:4;  %general range

 switch errorModel
   case 'g'
     pms=1.5:0.25:4.5;
     %     pms=2.5:0.25:4.5;  
   case {'e','f'}
     pms=0.5:0.25:4.5;
     pms=0.25:0.25:4;%test with Alexei
     %pms=2.5:0.25:4.5;
     %     pms=0.2:0.1:2  %for a check
 end
 %  pms=1.07301965:0.000000015:1.07301975 % check  The number for the wired gap is located in this region
 %  pms=1.0:0.3:6 %mode d
 %pms=2.0:0.5:7
 pms
 pms=0.1.^pms ;
 
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
        case 'code3'                   
    end
    P = massageP(P);
    %get trellis
    tic
    [strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
    %[strip,Ptransfer,Qtransfer,numInputSymbols,weightP] = matrix_parameter_strip(P);
    disp('time to get trellisGF4Strip')
    trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
    toc
end


division = size(pms,2);
table = zeros(division,7);




for ip = 1:size(pms,2)
    tic
    pm = pms(ip);
    pq = pms(ip);
    disp( ['start calculating for log10(pm) = ', num2str(log10(pm)) ] );
    disp( ['dataPointTime = ',num2str(dataPointTime),' sec, remaining time = ',...
                      num2str( dataPointTime * ( size(pms,2)-ip)/60 ),' min'] );
    error_prob = generate_error_prob_vector(errorModel,numInputSymbols,pm,weightP);
    %    error_prob= (1-Qtransfer)*pm+Qtransfer*pm*ratio_ps_pq;
    
    %change error_prob for majority vote, for both GI and G decoder; turn it off for a one time (GI) code
    if majority_vote_switch==1
        error_prob_s=Qtransfer.*error_prob; %syndrome part
        error_prob_vote = error_prob_s.^3+3*(error_prob_s.^2).*(1-error_prob_s);
        error_prob= (1-Qtransfer).*error_prob + Qtransfer.*error_prob_vote;
    end
    
    metric_vec_log = - log10( error_prob./(1-error_prob) );

    numGoodError=0;
    i=0;
    %    for i = 1:numTrials
    errorRemained=zeros(1,size(numInputSymbols,2)); %zero remained error for first round of decoding
    
    while 1  %only control by numFails
        i=i+1;
        [errorInput,syndromeError] = generate_error_from_model(numInputSymbols,error_prob);

        if phenomenological_model=='B'
            %errorInput
            %errorRemained
            errorInput=plusGF4vec(errorInput,errorRemained);%add remined error from last round
        end
        
        %if syndromeError<0  %claim decoding failure if syndrome error occurs 
        %this case is removed by let check it <0 %weilei Feb 3 2019
        %   isGoodError =0;
%         elseif sum(errorInput) <2 %optimization, can also eliminate the single errors
        %             isGoodError =1;
        %elseif sum(ceil(errorInput/4)) <2 
            %remove zeor error and single error            
            %   isGoodError =1;
            %elseif sum(ceil(errorInput/4))==2  &&  (errorInput*Qtransfer'>0)
            %double error and at least one syndrome error, it is not able to
            %fix double qubit error. Save >50% of time.
            %This has been tested and verified. Feb 6, 2019 weilei
            %isGoodError =1;
            %else
%             isGoodError = viterbiDecoderGF4Strip(...
%            P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
        if sum(errorInput) == 0 % remove zero error, any nonzero error seems not valid for removing
            isGoodError=1;
            %        elseif sum(  ceil(errorInput/4) ) ==1  %remove single error, has been tested and verified in runCheckSoft.m
            %isSingleSyndromeError=sum(errorInput.*Qtransfer);
            %if G_code_switch==1
            %    %G code cannot correct single syndrome error, but can correct all single qubit error
            %    if isSingleSyndromeError==1
            %        isGoodError=0;
            %    else
            %        isGoodError=1;
            %    end
            %else
            %    isGoodError=1; %GI code can correct any single error
            %end                    
            %check if it gives wrong decoding
            %checkIsGoodError = viterbiDecoderGF4StripSoft(...
            %   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log);
            %if isGoodError ~= checkIsGoodError
            %    numInputSymbols
            %    i
            %    errorInput
            %    disp('wrong optimization')
            %    pause
            %end
            
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
           [isGoodError,errorRemained] = viterbiDecoderGF4StripSoft(...
               P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_log);
           if isGoodError == 0 % check logical failure
               isGoodError = viterbiDecoderGF4StripSoft(...
                   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorRemained,metric_vec_log);
           end
           
        end
       
           %end 
        if isGoodError
            numGoodError = numGoodError +1;
            %        else


            %   Qtransfer;
            %errorInput_syndrome_bit=errorInput.*Qtransfer
            %errorInput_qubit=errorInput.*(1-Qtransfer)
            %weight=[ sum(errorInput_syndrome_bit), sum( ceil( errorInput_qubit/4 ) ) ]
            %pause
        else
            errorRemained=zeros(1,size(numInputSymbols,2));
        end
        if i-numGoodError +1 > numFails
            break
        end
        if toc > dataPointTime %check time used
            break
        end  
        
    end
    p_fail = 1 - numGoodError/i;
    disp( num2str([i,pm,numGoodError,p_fail,0,0,pq]));
    %    [pq,pm,numGoodError,p_fail,i]) )
    table(ip,:)=[i,pm,numGoodError,p_fail,0,0,pq];
    %    if p_fail<p_fail_min %avoid too small value taking too much time, Feb 7
    %    break
    %end
    toc
end

%save results
description = 'simulation 7. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numFails];
save(filename, 'description', 'parameters',  'table');
tableRepetition = table;
disp( num2str( table ))
filename
%simulationPlot(table,filename,repeat)
%simulationPlotSave(table,filename)

%save the figure directly without display it.
fig=figure('visible','off');
%plot(table(:,2),table(:,4))
plot(log10(table(:,2)),log10(table(:,4)),'-o') %plot p_fail
%plot(log10(table(:,2)),log10(table(:,5))+log10(39),'-o') %plot life_time*timesteps
%plot(log10(tableConvolutional(:,2)),log10(tableConvolutional(:,4)),'-o',log10(tableRepetition(:,2)),log10(tableRepetition(:,4)),'-o')
%plot((tableConvolutional(:,2)),(tableConvolutional(:,4)),'--',(tableRepetition(:,2)),(tableRepetition(:,4)),'-o')
%  legend(filename);
%  legend('Location','northwest')
%  title(['decoding simulation, repeat = ',num2str(repeat)]);
title(filename);
xlabel('error probability on qubits and syndrome bits (log10)')
ylabel('rate of decoding failure (log10)')
saveas(fig,[filename(1:end-4),'.fig'],'fig')
saveas(fig,[filename(1:end-4),'.png'],'png')
%system('./sync_to_macbook_weilei.sh')



              
              
function [error,syndromeError] = generate_error_from_model(numInputSymbols,error_prob)
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
%P=P1
%end

end
