% weilei Zeng, 08/06/2018
% Run simulation on error decoding for  the repetition case

% paratemter:
 numTrials = 1000;%default 200
 repeat = 4;
 p_error_max = 0.02;
 division = 20;
 filename = "data/simulation2-5.mat";

  %new parameter
pms=0.5:0.2:2
 pms=0.1.^pms 
 
 
%example input 2: terminated convolutional code [1 1 1 1 w W]

%construct the code
g1=[1 1 1;2 2 2 ];g2=[ 1 2 3; 2 3 1 ];
grepeat=repeat;
G=[zeros(2,(grepeat+1)*3);kron(eye(grepeat+1),g1)] ...
    +[kron(eye(grepeat+1),g2);zeros(2,(1+grepeat)*3) ];
%numInputSymbols=ones(1,size(G,2))*4;
rowG = size(G,1);
P=[G, eye(rowG)];
%numInputSymbols=[ numInputSymbols ones(1,rowG)*2 ];
 
%get trellis
tic
[strip,Ptransfer,Qtransfer,numInputSymbols] = matrix_parameter_strip(P);
disp('time to get trellisGF4Strip')
trellisGF4Strip= getTrellisGF4Strip(P,strip,numInputSymbols);
toc

division = size(pms,2);
table = zeros(division,4);




for ip = 1:division
%     p_error = p_error_max*ip/division
%     pm = p_error; %error probability for measuremnt/syndrome error
%     pq = p_error; % error probability for qubit error
%     
    
    pm = pms(ip)
    pq = pms(ip);
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
description = 'simulation 2. parameters =[repeat,numTrials]; table(ip,:)=[pq,pm,numGoodError,p_fail] ';
parameters =[repeat,numTrials];
save(filename, 'description', 'parameters',  'table');
tableRepetition = table
%plot(table(:,2),table(:,4))
 plot(log10(table(:,2)),log10(table(:,4)))
 
 plot(log10(tableConvolutional(:,2)),log10(tableConvolutional(:,4)),'--',log10(tableRepetition(:,2)),log10(tableRepetition(:,4)),'-o')
 
function error = generate_error(numInputSymbols,pq,pm)
%generate radnom error from given erro model/probability
    length = size(numInputSymbols,2);
    error=zeros(1,length);
    r = rand(1,length);
    pq3=pq/3; %error probability for X, Y or Z error
    pm_bad = 1-(1-pm)^3-2*pm*(1-pm)^2; %repeat mesurement 3 times
    for i =1:length
        switch numInputSymbols(i)
            case 2
                error(i) = (r(i)< pm_bad ) *1;
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
                        
                

