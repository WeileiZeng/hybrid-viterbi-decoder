%try to find a lower bound on the distance of a hybrid convolutional code
%decode single, double,... errors until failures or out of capacity.

%result: currently only check single error and double error,(double qubit error excluded). For all the big GA codes, checked for repeat=5,9
% code 1 and code 5 show exactly the same performance. They can correct all double syndrome error. The number of double error they cannot correct is 228, when repeat =5, 12 qubit code.

%get trellis
repeat =5  %5 9
folder='data/trellis/code5'%1
[P,strip,Ptransfer,Qtransfer,numInputSymbols,weightP,trellisGF4Strip]...
    = getSavedTrellis(repeat,folder);

%control switch
checkSingleError=1; % 0 1
checkDoubleError=0;

%check single error

length=size(numInputSymbols,2)

if checkSingleError
    numSingleErrors=0;
    numGoodSingleErrors=0;
    for i=1:length   
        i;
        switch numInputSymbols(i)
            case 2 %syndrome error
                errorInput = zeros(1,length);
                errorInput(i)=1;
                isGoodError = viterbiDecoderGF4Strip(...
                    P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
                numSingleErrors =numSingleErrors +1;
                numGoodSingleErrors = numGoodSingleErrors + isGoodError;
            case 4 % qubit error
                for ie=1:3
                    errorInput = zeros(1,length);
                    errorInput(i)=ie;
                    isGoodError = viterbiDecoderGF4Strip(...
                        P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
                    numSingleErrors =numSingleErrors +1;
                    numGoodSingleErrors = numGoodSingleErrors + isGoodError;
                end
        end
    end

    numSingleErrors
    numGoodSingleErrors
    GoodSingleErrorRate = numGoodSingleErrors/numSingleErrors
    %    pause
end

%double errors
if checkDoubleError 

    %finish for repeat =17, i=1-48,88-157.
    numDoubleErrors=0;
    numGoodDoubleErrors=0;
    for i=1:length-1
        i
        %i=length-i
        %i=44-i
        %i=19+i
        
        for j=(i+1):length
            switch numInputSymbols(i)
                case 2 %2 %syndrome error

                    switch numInputSymbols(j)
                        case 2
                            errorInput = zeros(1,length);
                            errorInput(i)=1;
                            errorInput(j)=1;

                            isGoodError = viterbiDecoderGF4Strip(...
                                P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
                            numDoubleErrors =numDoubleErrors +1;
                            numGoodDoubleErrors = numGoodDoubleErrors + isGoodError;
                            if isGoodError ==0
                                 errorInput
    %                             if errorInput*Qtransfer==2
    %                                 errorInput
    %                             end
                            end
                        case 4
                            for je=1:3
                                errorInput = zeros(1,length);
                                errorInput(i)=1;
                                errorInput(j)=je;
                                isGoodError = viterbiDecoderGF4Strip(...
                                    P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
                                numDoubleErrors =numDoubleErrors +1;
                                numGoodDoubleErrors = numGoodDoubleErrors + isGoodError;
                                if isGoodError ==0
                                    errorInput
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
                        case 2 %2
                            errorInput = zeros(1,length);
                            errorInput(i)=ie;
                            errorInput(j)=1;

                            isGoodError = viterbiDecoderGF4Strip(...
                                P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
                            numDoubleErrors =numDoubleErrors +1;
                            numGoodDoubleErrors = numGoodDoubleErrors + isGoodError;
                            if isGoodError ==0
                                errorInput
                            end
                        case 4  %double qubit error
                            for je=1:3
                                errorInput = zeros(1,length);
                                errorInput(i)=ie;
                                errorInput(j)=je;
                                isGoodError = viterbiDecoderGF4Strip(...
                                    P,strip,Ptransfer,Qtransfer,numInputSymbols,trellisGF4Strip,errorInput);
                                numDoubleErrors =numDoubleErrors +1;
                                numGoodDoubleErrors = numGoodDoubleErrors + isGoodError;
                                if isGoodError ==0
                                    [i,j,ie,je]
                                    errorInput;
                                else
                                    [i,j,ie,je];
                                end
                            end
                        end     
                    end
            end
        end
    end
    numDoubleErrors
    numGoodDoubleErrors
    numGoodDoubleErrorRate = numGoodDoubleErrors/numDoubleErrors
    % for repeat =4, I got 1637/1796, that means the distance 3=<d<=5
    disp('The program check all double errors, and print the bad error if it include a syndrome bit error.')
end


