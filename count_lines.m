%function costproject=castingprojecte1(mfilproject,ratperlin) 
%coutn the number of non empty line for all .m files in the (current) folder
myfileproject = "."
rateperline =1;
[fileList0,~] = matlab.codetools.requiredFilesAndProducts(myfileproject);

fileList=fileList0';

for j=1:size(fileList,1) 
    myfile=(fileList{j,1}); 
    if strncmp(myfile(1,end-1:(end)),'.m',2)==1 
        myfiletrue(j,1)=true; 
    else 
        myfiletrue(j,1)=false; 
    end 

    clear index 
    fileid = fopen(fileList{j,1});

    allText = textscan(fileid,'%s','delimiter','\n');

    netalltext=allText{1};

    index=true(size(netalltext,1) ,1);
    for i=1:size(netalltext,1) 
        if isempty(netalltext{i,1})==0 
            index(i,1)=true; 
        else 
            index(i,1)=false; 
        end 
    end 

    netalltext2=netalltext(index,1);

    numberOfLines{j,1} = length(netalltext2); 
    numberOfLines{j,2} = fileList{j,1}; 
    fclose(fileid) 
end 
numberOfLines2=numberOfLines(myfiletrue,:) 
sumlinnoemp=sum(cell2mat(numberOfLines2(:,1))) 
costproject=(rateperline*sumlinnoemp)