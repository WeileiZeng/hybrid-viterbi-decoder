% weilei Zeng, 08/06/2018
% soft decision decoding, not finished
% Run simulation on error decoding for the designed DS code P, 

% 1 designed DS code P
% paratemter:
 numTrials = 200;
 repeat = 4;
 p_error_max = 0.1;
 division = 20;
 filename = 'data/simulation3-3.mat'
 
%construct P and trellis from matrix generate  strip
tic
P = matrix_generate_strip(repeat);
[strip,Ptransfer,Qtransfer,numInputSymbols] = matrix_parameter_strip(P);
disp('time to get trellisGF4Strip')
trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
toc

table = zeros(division,4);

for ip = 1:division
    p_error = p_error_max*ip/division
    pm = p_error; %error probability for measuremnt/syndrome error
    pq = p_error; % error probability for qubit error
    
    numGoodError=0;
    for i = 1:numTrials
        errorInput= generate_error(numInputSymbols,pq,pm);
        isGoodError = viterbiDecoderGF4Strip(...
           P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
        if isGoodError
            numGoodError = numGoodError +1;        
        else       
            %errorInput
        end
    end
    p_fail= 1 - numGoodError/numTrials;
    table(ip,:)=[pq,pm,numGoodError,p_fail];
    %[numGoodError,trials]
end

%save results
description = 'simulation 3. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numTrials];
save(filename, 'description', 'parameters',  'table');
table
plot(table(:,2),table(:,4))



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
                        
                

