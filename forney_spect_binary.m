%From forney's code, calculate the WEF for each orthogonal code
%WEF: weight enumerating funtion
%code data for Table V. Self-orthogonal binary linear rate-1/3 convolutional codes
%Method: use built-in matlab function, (poly2trellis, distspec) 
help forney_spect

delta_d_max=5;%give WEF in the range of (d_free, d_free+delta_d_max-1)

disp('Example: orthgonal 2/3 code of rate 1/3 code g from Forney, constraint length v=3')
hv3=poly2trellis([3 2],[5,5,4;1,2,3]);
distspec(hv3,delta_d_max)

%one line command to convert bin to octal
str2num(dec2base(bin2dec('1101'),8));


in=[11,10,11;01,11,10;
    101,101,100;01,10,11;
    101 010 001;111 111 100;
    0001 1000 1001;11 11 10;
    1001 1001 1000;01 10 11;
    1011 0001 0100;111 110 111;
    1111 1000 1101;1101 0011 0110;
    10111 00001 01100;1101 1110 1101;
     10101 11010 11011;
    11101 01001 00100;
   
    01011 11000 11101;
    11011 00111 01000;
    
    00111 11010 10011;
    10001 11011 11100;
    
    100101 000011 011000;
    1001 1110 1011;
    
    110111 101001 100000;
    11101 00110 01101;
    
    111111 101100 100001;
    10011 01111 00010;
    
    1011111 1011000 0101111;
    11001 10111 11000;
    
    1110011 1011101 1010100;
    010011 000110 110101;
    
    0111111 1001010 1000111;
    1010001 1111001 1010100;
    ];

%spect([11,10,11;01,11,10])
%spect([101,101,100;01,10,11])
%spect(in(1:2,1:3))
%spect(in(3:4,1:3))

disp('HERE')
spect([101,111])

%run all code in forney's paper, infinite convolutional code
% s=size(in,1)/2
% for i=1:s
%     spect(in(i*2-1:i*2,1:3));
% end


function sp = spect(input_generator)
%return WEF of input_genertors in binary format
    delta_d_max=5;
    v=constraint_length(input_generator);
    o=bin2octal(input_generator);
    sp=distspec(poly2trellis(v,o),delta_d_max)
    nu=sum(v)-size(v,2);
    disp(['nu = ',num2str(nu),', d_free = ',num2str(sp.dfree),', event for w=d_free is ',num2str(sp.event(1))])
end


function octal =bin2octal(binatry)
%convert matrix of binary value to octal numbers
%example: [10 11; 101 1] --> [2 3;4,1]
    [row,col]=size(binatry);
    octal=zeros(row,col);
    for i=1:row
        for j=1:col
            octal(i,j)=str2num(dec2base(bin2dec(num2str(binatry(i,j))),8));
        end
    end
end

function v=constraint_length(binary)
%return constraint length of each row generators in the matrix o
%the dimension of v is 1 x (row of binary)
    [row,col]=size(binary);
    vv=zeros(row,col);
    v=zeros(1,row);
    for i=1:row
        for j=1:col
            ss=size(num2str(binary(i,j)));
            vv(i,j)=ss(2);
        end
        v(1,i)=max(vv(i,1:col));
    end
end
    