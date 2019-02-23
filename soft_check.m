% Weilei Feb 3, 2019
% Check the soft decoding for the 5 qubits codes again. every thing works. The result differ with different metric_vec_P_input, which is expected.
%I didn't check the convolutional codes though.


%try to find a lower bound on the distance of a hybrid convolutional code
%decode single, double,... errors until failures or out of capacity.

%currently only check single error and double error,(double qubit error excluded).

%time estimation: one viterbi decoding takes 0.01 sec for repeat=5, 0.02 sec for repeat=9

%get trellis
repeat =9 %7 for 24
folder='data/trellis/code6' %code1 code5
                            %[P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip]...
                            %    = getSavedTrellis(repeat,folder);
[P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip,P_dual]...
    = getSavedTrellis(repeat,folder); % add P_dual for code 6

%repeat=3
%code='code6'
%example input 2: terminated convolutional code [1 1 1 1 w W]
constructCode=0;
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





%check single error
length=size(numInputSymbols,2)
colP=length;

%pm=0.4;
%ratio_ps_pq=1;
%error_prob2= (1-Qtransfer)*pm+Qtransfer*pm*ratio_ps_pq; %for a check
%metric_vec_P_input = - log10( error_prob2./(1-error_prob2) );
%metric_vec_P_input=ones(1,colP); 
%metric_vec_P_input=numInputSymbols.^5/64/16;

%control switch
checkSingleError=1;
checkDoubleError=0;

pq_ps_flag=1;
%33 22 for same pq
switch pq_ps_flag
  case 1 %hard decision
    pq=0.05;ps=0.05;
  case 2
    pq=0.05;ps=0.45;
  case 3
    pq=0.45;ps=0.05;
  case 21
    pq=0.005;ps=0.045;
  case 211
    pq=0.05;ps=0.45;
  case 22
    pq=0.0005;ps=0.0045;
  case 23
    pq=0.00005;ps=0.00045;
  case 32
    pq=0.0045;ps=0.0005;
  case 33
    pq=0.00045;ps=0.00005;
end

%pq=0.001;
%ps=pq/10;
%majority vote
%ps=ps^3+3*ps^2*(1-ps)

disp(['pq_ps_falg pq ps = ',num2str([pq_ps_flag pq ps]) ])
error_prob=Qtransfer*ps+(1-Qtransfer)*pq;

%error_prob(5)=0.2;
%error_prob(10)=0.2;
metric_vec_P_input = - log10( error_prob./(1-error_prob) );
%metric_vec_P_input=metric_vec_P_input.*(   1-2*Qtransfer );


%check double error by manually input error
if 1==0
    errorInput = zeros(1,length);
    %errorInput(1)=2;
    %errorInput(2)=2;
    errorInput(10)=2;
    %    errorInput(5)=1;
    %errorInput(1)=2;
    %errorInput(4)=1;
    %soft decoding
    %    isGoodError = viterbiDecoderGF4StripSoft(...
    %   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input)
    isGoodError = viterbiDecoderGF4DegenerateStripSoft(...
        P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input,P_dual);
    pause
end

exhaustive_check=0
if exhaustive_check %didn't finish programing
    total_bit=sum(numInputSymbols/2) %qubit is two bits
    total_error=2^total_bit
    for i=1:total_error
        binvec=de2bi(i);
        Gvec=zeros(1,length);
        for j=1:length
            switch numInputSymbols(j)

            end
        end
    end
end


if checkSingleError
    numSingleErrors=0;
    numGoodSingleErrors=0;
    numSingleSyndromeErrors=0;
    numGoodSingleSyndromeErrors=0;
    for i=1:length
    %    for i=5
        i;
        %tic
        switch numInputSymbols(i)
            case 2 %syndrome error
                errorInput = zeros(1,length);
                errorInput(i)=1;
                %isGoodError = viterbiDecoderGF4Strip(...
                %    P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);

                %soft decoding
                isGoodError = viterbiDecoderGF4StripSoft(...
                    P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input);
                
                numSingleErrors =numSingleErrors +1;
                numGoodSingleErrors = numGoodSingleErrors + isGoodError;
                numSingleSyndromeErrors =     numSingleSyndromeErrors+1;
                numGoodSingleSyndromeErrors =     numGoodSingleSyndromeErrors+isGoodError;                
            case 4 % qubit error
                for ie=1:3
                    errorInput = zeros(1,length);
                    errorInput(i)=ie;
                    %   isGoodError = viterbiDecoderGF4Strip(...
                    %   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);

                    %soft decoding
                    %isGoodError = viterbiDecoderGF4StripSoft(...
                    %P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input);
                    
                    isGoodError = viterbiDecoderGF4DegenerateStripSoft(...
                        P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input,P_dual);
                    
                    numSingleErrors =numSingleErrors +1;
                    numGoodSingleErrors = numGoodSingleErrors + isGoodError;

                    if isGoodError ==0
                        errorInput
                        pause
                    end
                end
        end
        %        toc
    end

    %numSingleErrors
    %numGoodSingleErrors
    GoodSingleErrorRate = numGoodSingleErrors/numSingleErrors;
    disp('[numGoodSingleSyndromeErrors,numSingleSyndromeErrors,numGoodSingleErrors,    numSingleErrors, GoodSingleErrorRate]') 
    disp( num2str( [  numGoodSingleSyndromeErrors, numSingleSyndromeErrors,...
                        numGoodSingleErrors,    numSingleErrors,    GoodSingleErrorRate] ) )

    if numSingleErrors>numGoodSingleErrors
        'numSingleErrors>numGoodSingleErrors'
        pause
    end
end


%double errors
if checkDoubleError 

    %finish for repeat =17, i=1-48,88-157.
    numDoubleErrors=0;
    numGoodDoubleErrors=0;
    numDoubleSyndromeErrors=0;
    numGoodDoubleSyndromeErrors=0;
    for i=1:length-1
        i;
        %i=length-i
        %i=44-i
        %i=19+i
        
        for j=(i+1):length
            
            switch numInputSymbols(i)
                case 2 %syndrome error

                    switch numInputSymbols(j)
                        case 2
                            errorInput = zeros(1,length);
                            errorInput(i)=1;
                            errorInput(j)=1;
                            %                            isGoodError = viterbiDecoderGF4Strip(...
                            %    P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
                            %soft decoding
                            %isGoodError = viterbiDecoderGF4StripSoft(...
                            %    P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input);

                            isGoodError = viterbiDecoderGF4DegenerateStripSoft(...
                                P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input,P_dual);
                            
                            numDoubleErrors =numDoubleErrors +1;
                            numGoodDoubleErrors = numGoodDoubleErrors + isGoodError;

                            numDoubleSyndromeErrors =numDoubleSyndromeErrors +1;
                            numGoodDoubleSyndromeErrors = numGoodDoubleSyndromeErrors + isGoodError;

                            
                            if isGoodError ==0
                                [i,j,1,1]
                                pause
                                errorInput;
    %                             if errorInput*Qtransfer==2
    %                                 errorInput
    %                             end
                            end
                        case 4
                            for je=1:3
                                errorInput = zeros(1,length);
                                errorInput(i)=1;
                                errorInput(j)=je;
                                %    isGoodError = viterbiDecoderGF4Strip(...
                                %   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);

                                %soft decoding
                                %isGoodError = viterbiDecoderGF4StripSoft(...
                                %   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input);

                                isGoodError = viterbiDecoderGF4DegenerateStripSoft(...
                                    P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input,P_dual);
                                
                                numDoubleErrors =numDoubleErrors +1;
                                numGoodDoubleErrors = numGoodDoubleErrors + isGoodError;
                                if isGoodError ==0
                                    errorInput
                                    pause
                                end
                            end
                    end

                case 4 % qubit error
                    for ie=1:3
    %                     errorInput = zeros(1,length);
    %                     errorInput(i)=ie;
    %                     isGoodError = viterbiDecoderGF4Strip(...
    %                         P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
    %                     numErrors =numErrors +1;
    %                     numGoodErrors = numGoodErrors + isGoodError;
    %                     
                        switch numInputSymbols(j)
                        case 2
                            errorInput = zeros(1,length);
                            errorInput(i)=ie;
                            errorInput(j)=1;

                            %                            isGoodError = viterbiDecoderGF4Strip(...
                            %    P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);

                            %soft decoding
                            %isGoodError = viterbiDecoderGF4StripSoft(...
                            %   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input);

                            isGoodError = viterbiDecoderGF4DegenerateStripSoft(...
                                P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input,P_dual);
                            
                            numDoubleErrors =numDoubleErrors +1;
                            numGoodDoubleErrors = numGoodDoubleErrors + isGoodError;
                            if isGoodError ==0
                                errorInput;
                                pause;
                            end
                        case 4  %double qubit error
                            for je=1:3
                                errorInput = zeros(1,length);
                                errorInput(i)=ie;
                                errorInput(j)=je;
                                %isGoodError = viterbiDecoderGF4Strip(...
                                %    P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);

                                %soft decoding
                                %isGoodError = viterbiDecoderGF4StripSoft(...
                                %   P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input);

                                isGoodError = viterbiDecoderGF4DegenerateStripSoft(...
                                    P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput,metric_vec_P_input,P_dual);
                                
                                numDoubleErrors =numDoubleErrors +1;
                                numGoodDoubleErrors = numGoodDoubleErrors + isGoodError;

                                %                 [i,j,ie,je,isGoodError]
                                if isGoodError ==0
                                    [i,j,ie,je]
                                    %   errorInput;
                                else
                                    [i,j,ie,je];
                                end
                            end
                        end     
                    end
            end
        end
    end
    %numDoubleErrors
    %    numGoodDoubleErrors
    numGoodDoubleErrorRate = numGoodDoubleErrors/numDoubleErrors;
    disp('numGoodDoubleSyndromeErrors, numDoubleSyndromeErros,numGoodDoubleErrors,    numDoubleErrors,numGoodDoubleErrorRate')
    disp(num2str(     [numGoodDoubleSyndromeErrors, numDoubleSyndromeErrors,...
                        numGoodDoubleErrors,    numDoubleErrors,    numGoodDoubleErrorRate]) )


    
    % for repeat =4, I got 1637/1796, that means the distance 3=<d<=5
    disp('The program check all double errors, and print the bad error if it include a syndrome bit error.')
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
