% Weilei Zeng, 07/02/2018
% For GF4 convolutional code, build trellis from polynomial representation
% TRELLIS = poly2trellis4gf4(CONSTRAINTLENGTH,CODEGENERATOR)
% example: code with rate 2/3 and generators h1=Ww1,h2=1111wW
% h1= W,w,1 => 3,2,1  h2=11,1w,1W => 11,12,13(base 4)
% vv=[1 2],gg=[ 3 2 1; 11 12 13]
% say m=v-1 in our difinition,(v in matlab = 1+ v in Forney's paper)
% m in matlab = v in Forney's paper
% format of encoding: code = u*g:  u=u3 u2 u1, 
% state = s3 s2 s1. s1 for newest memory. si = si3 si2 si1
% gg=[g1 g2 g3]. gi=gi1 gi2 gi3

function trellis = poly2trellis4gf4(vv,gg)
%coderate k/n
    gf=4;%use GF(4) or GF(2)
    k=size(vv,2);%number of generators
    n=size(gg,2);%the usual n, number of qubits.
    numInputSymbols = gf^k;
    numOutputSymbols = 2^n; %it is 2^n after converting to weight output
    v=sum(vv);
    m=v-k;%total memory
    numStates = gf^(m);
    %k,n,numInputSymbols,numOutputSymbols,v,m,numStates
    nextStates=zeros(numStates,numInputSymbols);
    outputs=zeros(numStates,numInputSymbols);
    
    for i = 1:numStates
        for j = 1:numInputSymbols
            inputSymbol=j-1;%shift 1 cause matlab use index start from 1 but we need 0
            %when we restore the value of nextState, we start from 0, no
            %need to add 1 to match the index. Matlab will do it by itself
            
            currentState=i-1;
            %each state has m bits(GF4)
            %s in base 4 but converted to base 10
            
            nextStates(i,j)=getNextState(inputSymbol,currentState,vv);
            %(inputSymbol)*(4^(m-1))+floor((currentState)/4);
    
            output=0;
            %u=[u1 u2] g11*u1+g21*u1+g22*u2
            for i1 = 1:n %for n encoded bits
                sum_ug=0;              
                for i2=1:k  %to sum u*g   
                    %ki=i2;
                    currentState4ki = getCurrentState4ki(currentState,k,i2,vv);
                    [currentState,currentState4ki];
                    inputSymbol4ki = floor(mod(inputSymbol,4^(i2))/(4^(i2-1)));
                    ug_temp=ug(inputSymbol4ki,currentState4ki,gg(i2,i1),vv(i2));
                    sum_ug = plusGF4(sum_ug,ug_temp);                  
                end
                output= output*4+sum_ug;
            end
            [currentState,output];
            outputs(i,j)=output;
        end
    end    
    outputs=gf42octal(outputs);
    trellis = struct('numInputSymbols',numInputSymbols,...
    'numOutputSymbols',numOutputSymbols,...
   'numStates',numStates,'nextStates',nextStates,'outputs',outputs);
    save('temp.mat')
end

function code = ug(inputSymbol4ki,currentState4ki,g4ki,v4ki)
%return product of code = u*g, for given k and n value.
%k for generator, n for encoded qubits
%g in natural order, currenstState4ki in inverse order
%sample input g (2,1,1)  (13,12,2)  u=1w
% convert to  (w,1,1)  (1W, 1w, 2)
% calculation   w*1=w   1*1+w*W=1+1=0
%sample output 2       0

%use timesGF4 instead of symplecticGF4
%g=base2dec(num2str(g),4);

%inputSymbol4ki,currentState4ki,g,v
switch v4ki %v=m+1
    case 1 %u1*g1
        code = timesGF4(inputSymbol4ki,g4ki);
    case 2  %u1*g1+u2*g2
        
        code = plusGF4( timesGF4(inputSymbol4ki,pickGF4(g4ki,2)),...
            timesGF4(currentState4ki,pickGF4(g4ki,1))...
        );
    otherwise %sum more terms
        
        code = timesGF4(inputSymbol4ki, pickGF4(g4ki,v4ki) );
        for i = 1:(v4ki-1)
            code =plusGF4(code,...
                timesGF4( pick10(currentState4ki,i,i),pickGF4(g4ki,v4ki-i)...
            ));
            %timesGF4( pick10(currentState4ki,v-i,v-i),pickGF4(g,v-i)...
        end

end
[inputSymbol4ki,currentState4ki,g4ki,v4ki,code];
end            



function state = getCurrentState4ki(currentState,k,ki,vv)
%return the digits in curentState conrresponding to vv(ki)
%all number (currentState and currentState4ki) based 10, but represent GF(4)
% the rightmost in currentState has index 1
% state = s3 s2 s1, ski=ski2 ski1
    m1 = sum(vv(1:(ki-1)))-ki+1;
    m2 = vv(ki)-1;
    state = mod(currentState,4^(m1+m2)); %remove the part big than ki
    state = floor( state/(4^(m1))); % remove the part smaller than ki
end


function state = getNextState(inputSymbol,currentState,vv)
%input u = u3 u2 u1, state = s3 s2 s1
    k=size(vv,2);
    state=0;
    pos=0; %current position
    for i = 1:k %get new memery part from inputSymbols
        m=vv(i)-1;
        if m==0
            %skip it if m=0
        elseif m==1 
            ui = pick10(inputSymbol,i,i);
            state = state+ui*(4^pos);
            pos=pos+1;
        else %m>1
            ui = pick10(inputSymbol,i,i);
            state = state+ui*(4^pos);
            temp = pick10(currentState,pos+1,pos+m-1);
            state = state + temp * (4^(pos+1));
            pos=pos+m;
        end
    end
end


