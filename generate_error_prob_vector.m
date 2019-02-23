%% Weilei Zeng Feb 19, 2019
% Definition of error mode: pq=qubit error prob, ps =syndrome error prob
% for summer simulations
% (a) pq=ps=pm
% (b) pq=pm, ps=(1-(1-2pm)^wt(g))/2; pq<<ps
% (c) pq=(1-(1-2pm)^(n/2))/2, ps =pm; pq>>ps
% (d) ps=(1-(1-2pm)^wt(g))/2,pq=(1-(1-2pm)^(n/2))/2; pq =~ 10 ps

% for simple depolarizing channel for both qubit error and syndrome error
% (e) pq=ps=pm  the same as (a)
% (f) pq=pm, ps=pm/10
% (g) pq=pm, ps=pm*10  program will pause if ps>0.49

% for measurement error in circuit error model. No qubit error is generated here.
% (h) ps=pm
% (i) ps=10pm


function error_prob = generate_error_prob_vector(errorModel,numInputSymbols,pm,weightP)
%generate radnom error from given error model/probability distribution
%return a vector of pq and ps
%In numInputSymbols, 2 for syndrome bit, 4 for qubit

length = size(numInputSymbols,2);
 error_prob=zeros(1,length);
 switch errorModel
    case 'a'
        for i =1:length         
             error_prob(i) = pm;                
        end
    case 'b'         
        for i =1:length
            switch numInputSymbols(i)
                case 2  %syndrome bit
                    error_prob(i) = (1-(1-2*pm)^weightP(i))/2;
                case 4  %qubit              
                    error_prob(i)=pm;
            end
        end
    case 'c'      
        n= -sum(numInputSymbols/2-2);%average number of gate operations on qubits in between each error correction circle
        for i =1:length
            switch numInputSymbols(i)
                case 2
                    error_prob(i) = pm;
                case 4 
                    error_prob(i)=(1-(1-2*pm)^(n/2))/2;
            end
        end
    case 'd'
        n= -sum(numInputSymbols/2-2);%average number of gate operations on qubits in between each error correction circle
        for i =1:length
            switch numInputSymbols(i)
                case 2
                    error_prob(i) = (1-(1-2*pm)^weightP(i))/2;
                case 4 
                    error_prob(i)=(1-(1-2*pm)^(n/2))/2;
            end
        end
        
    case 'e'
      for i =1:length
          error_prob(i) = pm;
      end
  case 'f'
    for i =1:length
        switch numInputSymbols(i)
          case 2;
            error_prob(i) = pm/10;
          case 4
            error_prob(i)= pm;
        end
    end
  case 'g'
    for i =1:length
        switch numInputSymbols(i)
          case 2
            error_prob(i) = pm*10;
          case 4
            error_prob(i)= pm;
        end
    end
    if pm*10 >0.49
        error('generate_error_prob_vector.m: error_prob >= 0.49, rerun program with smaller error_prob')
    end
      

  case 'h'
    %another layer of measurement error in circuit model
    %qubit error prob = 0
    error_prob=(4-numInputSymbols)/2*pm;%here ps would be pq
  case 'i'
    %another layer of measurement error in circuit model
    %qubit error prob = 0
    error_prob=(4-numInputSymbols)/2*pm*10;%here ps would be 10pq
    if pm*10>0.49
        error('generate_error_prob_vector.m: error_prob >= 0.49, rerun program with smaller error_prob')
    end
 end
end     