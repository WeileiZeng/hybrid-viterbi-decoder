[m,nm]=size(P);
n=nm-m;
error=zeros(1,nm);
error(1)=2;

s=[1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 1 1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];



s*Gtransfer'*Ptransfer.*Qtransfer
s*Gtransfer'*Ptransfer*P'

%raw syndrome
%s=zeros(1,m);
%s(1)=1;
%s(19)=1;

%s0=s*Gtransfer';
%sp=s0*Ptransfer*P';

%check Gtrasnfer


sumP=sum(P.*Qtransfer);
Gbits=ceil((sumP-1)/max(sumP));
(Ptransfer*Gbits')'*Gtransfer;

%find Gtransfer the other way
AGbits=ceil(sumP/max(sumP))-Gbits;
AGpos=sum( (P.*AGbits)' );
[gpos,agpos]=sort(AGpos)


sumPt=sum(  ( P.*(1-Qtransfer) )' )
[a,b]=sort( ceil(sumPt/max(sumPt)),'descend' )

s1=s;
%s2 should become the syndrome for G part
s1(b)=s

s2=mod(s1*Ptransfer*P',2)

s1*Gtransfer