% Weilei Zeng, 07/19/2018
% encoder and viterbi decoder for classical covoluitonal code.
% use trellis defined by matlab

clc
clear
disp('Sample code from Shu Lin, a=(n=2,k=1,m=4), 1011 and 1111')
in=[1 1 0 1 0 1 1 1 0 1 0 0 1 1 1 0 0 1 1 1]
t=poly2trellis(4,[13,17]);

%matlab encoding
matlab_code = convenc(in,t)


%my encoding
k=log2(t.numInputSymbols);
currentState = 0; %start from zero state
m=3;
length=size(in,2); %length of input msg
n=2; %code rate k/n
code=zeros(1,length*n);
for i = 1:length
%nextState= floor(currentState/2)+2^(m-1)*input;%add new input synbol to the left, different from poly2trellis4gf4
    input = in(i);
    nextState=t.nextStates(currentState+1,input+1);
    output=t.outputs(currentState+1,input+1);
    code(i*2-1:i*2)=oct2vec(output,n);
    currentState=nextState;
end

code %my encoded codeword



%my decoding
trellis = t;
tblen = 3; % trace back length
decode = zeros(1,k*(length-tblen+1));

path = zeros(trellis.numStates,tblen+1)-1;
new_path = zeros(trellis.numStates,tblen+1)-1;
metric = zeros(1,trellis.numStates);
new_metric = zeros(1,trellis.numStates);
currentState=0;
path(1,1)=0;

for i =1:tblen  % initialize
    received=code((n*(i-1)+1):i*n); % read received bits
    for j = 1:trellis.numStates
        currentState = j-1;
        if path(currentState+1,i) > -1
            for input=0:(trellis.numInputSymbols-1)
                
                nextState=trellis.nextStates(currentState+1,input+1);
                new_path(nextState+1,i+1)=input;
                new_path(nextState+1,1:i)=path(currentState+1,1:i);
                outputvec = oct2vec( t.outputs(currentState+1,input+1), n);
                metric_temp = n-biterr(received,outputvec);  %maximize the metric later
                new_metric(nextState+1)=metric(currentState+1)+metric_temp;            
            end
        end
    end
    path=new_path;
    metric = new_metric;
    
end

metric
[M I]=max(metric)

path = path(:,2:end) %remove the first collumn
decode(1:k) = path(I,1)


%clear data
new_path = zeros(trellis.numStates,tblen)-1;
%metric = zeros(1,trellis.numStates);
new_metric = zeros(1,trellis.numStates);

for i = 1:(length-tblen)  
    received = code( n*(tblen+i-1)+1:n*(tblen+i)) %read received bits
    for j = 1:trellis.numStates  
        currentState = j-1;
        for input=0:(trellis.numInputSymbols-1)
            nextState=trellis.nextStates(currentState+1,input+1);
            
            outputvec = oct2vec( t.outputs(currentState+1,input+1), n);
            metric_temp = n-biterr(received,outputvec);  
            metric_sum = metric(currentState+1)+metric_temp;
            if metric_sum > new_metric(nextState+1) %update the path and metric
                new_metric(nextState+1)=metric_sum;
                new_path(nextState+1,tblen)=input;
                new_path(nextState+1,1:(tblen-1))=path(currentState+1,2:tblen);
            end
                    
        end
    end
    [M I]=max(new_metric);
    decode(k*i+1:k*(i+1)) = path(I,1);
    
    %update metric and path    
    %break  %for test
    
    path=new_path; %path didn't change
    metric=new_metric;
    
end

metric
new_metric
path
new_path;

in 
decode

function vec = oct2vec(octal,N)
%return a binary vector of length N
out=oct2poly(octal);
L=size(out,2);
if  L< N
    vec=[zeros(1,N-L),out];
else
    vec = out;
end
end

 