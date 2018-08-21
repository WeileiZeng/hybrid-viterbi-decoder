% weilei Zeng, 08/06/2018
% Run simulation on error decoding for the designed DS code P, 
% updated after simulation1.m

% 1 designed DS code P
% paratemter:
 numTrials = 50;
  numFails=2;
  repeat = 4;
 %p_error_max = 0.2;
 filename = 'data/simulation6-test.mat'
 
%new parameter
 pms=0.5:0.2:3
 pms=0.1.^pms 
 
% construct P and trellis from matrix generate  strip
% tic
% P = matrix_generate_strip(repeat);
% [strip,Ptransfer,Qtransfer,numInputSymbols] = matrix_parameter_strip(P);
% disp('time to get trellisGF4Strip')
% trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
% toc


division = size(pms,2);
table = zeros(division,4);

for ip = 1:size(pms,2)  
    tic
    pm = pms(ip)
    pq = pms(ip);
    
    numGoodError=0;
    for i = 1:numTrials
        errorInput= generate_error(numInputSymbols,pq,pm);
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
        %check
        if i-numGoodError +1 > numFails
                break
        end
        toc
    end
    %p_fail= 1 - numGoodError/numTrials;
    p_fail = 1 - numGoodError/i;
    [pm,p_fail,i]
    table(ip,:)=[pq,pm,numGoodError,p_fail];
    toc
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
%generate radnom error from given erro model/probability
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
                        
                

