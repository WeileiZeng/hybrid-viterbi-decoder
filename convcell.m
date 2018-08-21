%Weilei Zeng July 6, 2018
%mulptiply matrix k times.
%Input: gain matrix Cell A. i-j element: weight gain from state i to state
%j
% output: A^k, multiplication refer to the convolution of two
% polynomial

function Ak = convcell(A,k)
%k=t+m, where we shift the generator t-1 times and get a generating matrix
%with t rows and (t+m)*n columns
%if k < m return 1
    initial=0; %flag to determine if Ak has been initialized or not.
    if k>1
        n=floor(log2(k)); %max number n-1 of calling conv2cell()
        Acell=cell(1,n+1);  %store all the cells, A^1,A^2,A^(2^n)
        Acell{1}=A;
        for i = 2:(n+1)
            Acell{i}=conv2cell(Acell{i-1},Acell{i-1});
            %Ak=conv2cell(Ak,A);
        end
        k2=dec2bin(k);
        for j=1:(n+1)
           if k2(n+1-j+1) =='1'
               if initial==0 %initialize Ak
                   Ak=Acell{j};
                   initial=1;
               else
                   Ak=conv2cell(Ak,Acell{j});
               end
           end
                   
        end
    end
end

function C = conv2cell(A,B)
%return C = A*B, A,B are square lattice of the same size, whose elements
%are vector (representing polynomial)
    L=size(A,1);
    C=cell(L,L);
    for i = 1:L
        for j =1:L
            c=0;
            for k=1:L
                e = conv(A{i,k},B{k,j});
                c=add(c,e);
            end
            C{i,j} = c; 
        end
    end
end

function c = add(a,b)
%add two polynomial vectors of different length
%align them to the right end, not the left end
%sample: add([1 0 1],[1 2]) ---> [1 1 3]
    sa=size(a,2);
    sb=size(b,2);
    if sa > sb
        c=[  a(1:sa-sb), a(sa-sb+1:sa)+b ];
    elseif sa < sb
        c=[  b(1:sb-sa), b(sb-sa+1:sb)+a ];
    else
        c = a+b;
    end   
end