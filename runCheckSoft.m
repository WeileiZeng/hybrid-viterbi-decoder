%Feb 9 2019 Weilei
%this program run check_soft.m to check the singel error for all pms in our case.

%how to run: run this, then run simulation and cut by C-c (just load trellis files), then run this.

%result
%all single error can be corected for GA and GR codes with model e,f,g
%for GI case, many syndrome error cannot be corrected, because after the majority vote, the syndrome bit error prob are too small. Then no single syndrome bit error will be considered by the decoder. This applied to model e,f,g



%define variable
errorModel='f'
file_version='-distance-test'
code='code1'
G_code_switch=0;
dataPointTime=600;

pms=1.5:0.25:5
%4.5

pms=0.1.^pms;



for pm=pms
    switch errorModel
      case 'e'
        pq=pm;ps=pm;
      case 'f'
        pq=pm;ps=pm/10;
      case 'g'
        pq=pm;ps=pm*10;
    end

    soft_check
end
