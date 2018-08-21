% weilei Zeng, 08/06/2018
% Run simulation on error decoding for  the repetition case
% allowed different error model
% modified from simulation2.m
% paratemter:
 numTrials = 200000;
  numFails=1000;
  
  repeat = 5;
 %filename = "data/simulation7-test.mat";

 errorModel='d';
 code='code1';
 folder = ['data/trellis/',code];
 filename = ['data/simulations/',code,'/simulation7-repeat',num2str(repeat),...
     'model-',errorModel,'-soft-1.mat']

 pms=0.5:0.5:6
 %pms=3.5:0.5:7
 pms=0.1.^pms 
 
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
table = zeros(division,4);




for ip = 1:size(pms,2)  
    pm = pms(ip)
    pq = pms(ip);
    error_prob = generate_error_prob_vector(errorModel,numInputSymbols,pm,weightP);   
    metric_vec_log = - log10( error_prob./(1-error_prob) );
    numGoodError=0;
    for i = 1:numTrials      
        [errorInput,syndromeError] = generate_error_from_model(numInputSymbols,error_prob);
        if syndromeError
            isGoodError =0;
%         elseif sum(errorInput) <2 %optimization, can also eliminate the single errors
%             isGoodError =1;
        elseif sum(ceil(errorInput/4)) <2 
            %remove zeor error and single error            
            isGoodError =1;
        elseif sum(ceil(errorInput/4))==2  &&  (errorInput*Qtransfer'>0)
            %double error and at least one syndrome error, it is not able to
            %fix double qubit error. Save >50% of time.
            isGoodError =1;
        else
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
        end
    end
    p_fail = 1 - numGoodError/i
    table(ip,:)=[pq,pm,numGoodError,p_fail];
end

%save results
description = 'simulation 7. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numTrials];
save(filename, 'description', 'parameters',  'table');
tableRepetition = table
filename
simulationPlot(table,filename,repeat)
 
              
              
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
