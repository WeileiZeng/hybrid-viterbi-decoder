%Weilei Zeng 08/06/2018
%plot the result of simulations

%control switch inside draw_code()
%draw_code()

%saveTwo()
run_save_more()
%system('./sync_to_macbook_weilei.sh')

function saveTwo()
    flag=23;
    column_index=[5,5];%2 for pm, 5 for lifetime;7 for pq
    switch flag
      case 1
        % a standard compare between repeat and convolutional
          filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-1test.mat';
          filename2='data/circuit/code1/simulationCircuit9model-a-hard-3-1.mat';
          legends = {'repeat';'convolutional'};
          timesteps=[10 37];
          filename='data/circuit/code1/repeat_vs_convolutional.mat' %title
      case 11
        % compare repeat algorithm while running on two set of data, (G and AG code respectively.)
          filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-1test.mat';
          filename2='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-hard-1.mat';
          legends = {'repeat';'repeat-run6'};
          timesteps=[10 39];
          filename='data/circuit/code1/repeat_vs_repeat.mat' %title
      case 12
        %compare repeat and convolutional on the same data for AG code. G decoder (repeated case) turns out to be better
          filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-hard-1.mat';
          filename2='data/circuit/code1/simulationCircuit9model-a-hard-3-1.mat';
          legends = {'convolutional';'repeat-run6'};
          timesteps=[39 39];
          filename='data/circuit/code1/AG-vs-G-decoder.mat' %title
      case 13
        %new data with more prob
        filename1='data/circuit/code1/simulationCircuit9model-a-hard-7.mat';
        filename2='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-hard-3.mat';
        legends = {'convolutional-run8';'repeat-run8'};
        timesteps=[39 39];
        filename='data/circuit/code1/AG-vs-G-decoder-v2.mat' %title
      case 14
        %add optimization for G decoder, that when syndrome error occurs, decoding fail
        filename1='data/circuit/code1/simulationCircuit9model-a-hard-7.mat';
        filename2='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-hard-4.mat';
        legends = {'convolutional-run8';'repeat-run8-optimization'};
        timesteps=[39 39];
        filename='data/circuit/code1/AG-vs-G-decoder-v3.mat' %title        

        
        
      case 21
        % try soft decoding by changing metric_vec. doesn;t get a result (no optimization descoverd)
        %        filename1='data/circuit/code1/simulationCircuit9model-a-hard-4.mat';        
        %filename2='data/circuit/code1/simulationCircuit9model-a-hard-3-1.mat';
        filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-less-pq-2.mat';
        filename2='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-equal-2.mat';
        legends = {'lower syndrome error prob';'convolutional'};
        legends = {'lower syndrome error prob';'repeat'};
        timesteps=[10 10];
        filename='data/circuit/code1/higher_syndrome_prob.mat' %title
      case 22
        %filename1='data/circuit/code1/simulationCircuit9model-a-hard-5.mat';        
        %filename2='data/circuit/code1/simulationCircuit9model-a-hard-3-1.mat';
        filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-less-ps-3.mat';
        filename2='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-equal-2.mat';
        legends = {'lower syndrome error prob';'convolutional'};
        legends = {'lower syndrome error prob';'repeat'};
        timesteps=[10 10];
        filename='data/circuit/code1/lower_syndrome_prob.mat' %title
      case 23
        %        filename1='data/circuit/code1/simulationCircuit9model-a-hard-6.mat';
        %        filename2='data/circuit/code1/simulationCircuit9model-a-hard-3-1.mat';
        %legends = {'vary syndrome error prob';'convolutional'};
        filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-less-pq-5.mat';%3%1
                                                                                                %filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-less-ps-4.mat';%2
        %        filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-less-pq-3.mat';
        %        filename2='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-1test.mat';
        filename2='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-equal-3.mat';
        legends = {'vary syndrome error prob';'repeat'};

        %        filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-vary-2.mat';
        %        filename2='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-hard-3.mat';
        %legends = {'vary syndrome error prob';'G decoder on AG data'};
        timesteps=[10 10];
        filename='data/circuit/code1/vary_syndrome_prob.mat' %title
      case 51
        % plot qubit error pq with G decoder on G data
        filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-1test.mat';
        filename2='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-hard-2.mat';
        legends = {'repeat';'p_q qubit error'};
        column_index=[5,7]
        timesteps=[10 1];
        filename='data/circuit/code1/repeat_vs_pq.mat' %title
      case 52
        % plot p_fail instead
        filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-1test.mat';
        filename2='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-hard-2.mat';
        legends = {'repeat p_fail';'repeat p_q qubit error'};
        column_index=[4,7]
        timesteps=[1 1];
        filename='data/circuit/code1/pfail_vs_pq.mat' %title
      case 53
        
        filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-1test.mat';
        filename2='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-hard-2.mat';
        %        filename1='data/circuit/code1/simulationRepeatCircuitRepeat7model-a-hard-2.mat';
        legends = {'repeat p_fail';'repeat p_fail-p_q qubit error'};
        column_index=[4,7]
        timesteps=[1 1];
        filename='data/circuit/code1/pfail_minus_pq_repeat_hard_2.mat' %title
    end


    %save the figure directly without display it.
    fig=figure('visible','off');
    %plot(table(:,2),table(:,4))
    %plot(log10(table(:,2)),log10(table(:,4)),'-o') %plot p_fail
    hold on
    load(filename1);
    plots(1)=plot(log10(table(:,2)),log10(table(:,column_index(1)))+log10(timesteps(1)),'-o'); %plot life_time*timesteps
    load(filename2);
    plots(2)=plot(log10(table(:,2)),log10(table(:,column_index(2)))+log10(timesteps(2)),'-*'); %plot life_time*timesteps

    %    plots(2)=plot(log10(table(:,2)),log10(table(:,column_index(2)))-log10(table(:,column_index(1))),'-*'); %plot life_time*timesteps
    hold off
    %    legend(plots,{filename1;filename2});
    legend(plots,legends);
    %  legend(filename);
    %  legend('Location','northwest')
    %  title(['decoding simulation, repeat = ',num2str(repeat)]);
    
    title(filename);
    xlabel('error probability on each time step (log10)')
    ylabel('lifetime * timesteps (log10)')
    saveas(fig,[filename(1:end-4),'.fig'],'fig')
    saveas(fig,[filename(1:end-4),'.png'],'png')
    saveas(fig,[filename(1:end-4),'.pdf'],'pdf')

end

function save_code()
% % threshold
%     repeat=7;code='code1';
%     codePrefix=['data/simulations/',code,'/simulation678-repeat'];
%     repeat2=11;
%     repeat3=21;
%     repeat4=31;
%     repeat5=40;
%     %codePrefix2 =['data/simulations/',code,'/simulation678-repeat'];
% %     filenames = {...
% %         [codePrefix,num2str(repeat),'model-a-soft-1.mat'],...
% %         [codePrefix,num2str(repeat2),'model-a-soft-1.mat'],...
% %         [codePrefix,num2str(repeat3),'model-a-soft-1.mat'],...
% %         [codePrefix,num2str(repeat4),'model-a-soft-1.mat'],...
% %         [codePrefix,num2str(repeat5),'model-a-soft-1.mat'],...
% %     };
%     legends={'repeat5','repeat7','repeat9','repeat11','repeat13'};
%     titleText=['threshold  ',code];
%     %legends=filenames;%{'code 1 model b soft';'code 1 model d soft';'code 1 model b hard';'code 1 model d hard';}

end

function run_save_more()
% index start with 1
% (outdated result ) 11,12,circuit model
% *13, use summer simulation ( removed all optimization except zero error)
% index start with 2
% (outdated result ) try soft decoding with circuit error model, not finding a result. 
% index start with 3
% circuit model with no optimization except zero error.




flag=99;
switch flag
case 11
        %add optimization for G decoder, that when syndrome error occurs, decoding fail
        filenames={'data/circuit/code1/simulationCircuit9model-a-hard-7.mat',...
            'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-hard-4.mat',...
            'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-hard-3.mat'};
        legends = {'convolutional-run8';'repeat-run8-optimization';'repeat'};
        legends = {'AG';'G';'GI'};
        timesteps=[39 39 39];
        filename='data/circuit/code1/AG-GI-G-decoder1.mat' %title  
        
case 12
%use the right timesteps, and averaged over more data
        %add optimization for G decoder, that when syndrome error occurs, decoding fail
        filenames={'data/circuit/code1/simulationCircuit9model-a-hard-7.mat',...
            'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-hard-5.mat',...
            'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-equal-2.mat'};
        legends = {'AG';'G';'GI'};
        timesteps=[39 10 10];
        filename='data/circuit/code1/AG-GI-G-decoder2.mat' %title  
case 121
%circuit error model GI versus AG
filenames={'data/circuit/code1/simulationCircuit9model-a-hard-2-1.mat',...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-5.mat',... %soft-5 
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-1.mat'};
%legends = {'AG';'G';'GI'};
legends={'convolutional DS code, AG decoder';'wrong syndrome, G decoder';'repetition DS code with majority vote, GI decoder'};
timesteps=[39 10 10];
filename='data/circuit/code1/AG-GI-G-decoder2-1.mat' %title  


case 13
%come back to summer simulations, and add GI decoder ( remove syndrome error optimization)

  %compare convolutional and repetitioin
     repeat=2+5;code='code1';
     codePrefix=['data/simulations/',code,'/simulation678-repeat'];
     repeat2=5;
     codePrefix2 =['data/simulations/',code,'/simulation7-repeat'];
     filenames = {...
         [codePrefix,num2str(repeat),'model-b-1.mat'],...
         [codePrefix,num2str(repeat),'model-d-1.mat'],...
         [codePrefix2,num2str(repeat2),'model-b-2.mat'],...
[codePrefix2,num2str(repeat2),'model-d-2.mat'],...
'data/circuit/code1/simulation7-repeat7model-b-soft-5.mat',...
'data/circuit/code1/simulation7-repeat7model-d-soft-5.mat'...
     };
     legends={'convolutional, model b';'convolutional, model d';...
'repeatment, model b';'repeatment, model d';...
'GI decoder model b';'GI decoder model d'};
%     titleText=['convolutional v.s. repetition [',code,' repeat ',num2str(repeat),']'];
%filename=titleText;
        filename='data/circuit/code1/AG-GI-G-decoder3.mat' %title  e  
timesteps=[1 1 1 1 1 1];

case 131% 131
%come back to summer simulations, and add GI decoder ( remove syndrome error optimization)

%compare convolutional and repetitioin
repeat=2+5;code='code1';
codePrefix=['data/simulations/',code,'/simulation678-repeat'];
repeat2=5;
codePrefix2 =['data/simulations/',code,'/simulation7-repeat'];
%[codePrefix,num2str(repeat),'model-d-1.mat'],...  %AG
%'data/circuit/code1/simulation678-repeat5model-d-soft-4.mat',...    %AG
%'data/circuit/code1/simulation7-repeat7model-d-soft-5.mat'...    %GI
filenames = {...
'data/circuit/code1/simulation678-repeat9model-d-soft-5.mat',...
[codePrefix2,num2str(repeat2),'model-d-2.mat'],...
'data/circuit/code1/simulation7-repeat7model-d-soft-6.mat'...
};
legends={'convolutional DS code, AG decoder';'wrong syndrome, G decoder';'repetition DS code with majority vote, GI decoder'};
%legends={'convolutional, AG decoder';'majority vote, G decoder';'data syndrome code, GI decoder'};
%     titleText=['convolutional v.s. repetition [',code,' repeat ',num2str(repeat),']'];
%filename=titleText;
filename='data/circuit/code1/AG-GI-G-decoder-mode-d.mat' %title  e
timesteps=[1 1 1];

case 132
%come back to summer simulations, and add GI decoder ( remove syndrome error optimization)

%compare convolutional and repetitioin
repeat=2+5;code='code1';
codePrefix=['data/simulations/',code,'/simulation678-repeat'];
repeat2=5;
codePrefix2 =['data/simulations/',code,'/simulation7-repeat'];
filenames = {...
[codePrefix,num2str(repeat),'model-b-1.mat'],...
[codePrefix2,num2str(repeat2),'model-b-2.mat'],...
'data/circuit/code1/simulation7-repeat7model-b-soft-5.mat'...
};
legends={'convolutional DS code, AG decoder';'wrong syndrome, G decoder';'repetition DS code with majority vote, GI decoder'};
%legends={'convolutional, AG decoder';'majority vote, G decoder';'data syndrome code, GI decoder'};
%     titleText=['convolutional v.s. repetition [',code,' repeat ',num2str(repeat),']'];
%filename=titleText;
filename='data/circuit/code1/AG-GI-G-decoder-mode-b.mat' %title  e
timesteps=[1 1 1];

case  133 %follow 131
%come back to summer simulations, 4 decoders (GA, G, majority vote GI, repeated GI)

repeat=2+5;code='code1';
codePrefix=['data/simulations/',code,'/simulation678-repeat'];
repeat2=5;
codePrefix2 =['data/simulations/',code,'/simulation7-repeat'];
filenames = {...
'data/circuit/code1/simulation678-repeat9model-d-soft-5.mat',...
[codePrefix2,num2str(repeat2),'model-d-2.mat'],...
'data/circuit/code1/simulation7-repeat7model-d-soft-6.mat',...
'data/circuit/code5/simulation678-repeat9model-d-soft-2.mat'...
};
%legends={'convolutional DS code, AG decoder';'wrong syndrome, G decoder';'repetition DS code with majority vote, GI decoder'};
legends={'convolutional DS code, GA decoder';'wrong syndrome, G decoder';'repetition DS code with majority vote, GI decoder';'repetition DS code, GI decoder'};
filename='data/circuit/code1/four-decoder-mode-d.mat' %title  e
timesteps=[1 1 1 1];

case 134 %% 134 follow 132
%come back to summer simulations, four decoder
repeat=2+5;code='code1';
codePrefix=['data/simulations/',code,'/simulation678-repeat'];
repeat2=5;
codePrefix2 =['data/simulations/',code,'/simulation7-repeat'];
filenames = {...
[codePrefix,num2str(repeat),'model-b-1.mat'],...
[codePrefix2,num2str(repeat2),'model-b-2.mat'],...
'data/circuit/code1/simulation7-repeat7model-b-soft-5.mat',...
'data/circuit/code5/simulation678-repeat9model-b-soft-1.mat'...
};
%legends={'convolutional DS code, AG decoder';'wrong syndrome, G decoder';'repetition DS code with majority vote, GI decoder'};
legends={'convolutional DS code, GA decoder';'wrong syndrome, G decoder';'repetition DS code with majority vote, GI decoder';'repetition DS code, GI decoder'};
filename='data/circuit/code1/four-decoder-mode-b.mat' %title  e
timesteps=[1 1 1 1];

case 135 %135  code 5 GI(GR), NO majority vote

filenames = {...
'data/circuit/code5/simulation678-repeat9model-a-soft-7-1.mat',...
'data/circuit/code5/simulation678-repeat9model-a-soft-7-2.mat',...
'data/circuit/code5/simulation678-repeat9model-a-soft-7-3.mat'...
};
filenames = {...
'data/circuit/code5/simulation678-repeat9model-e-soft-1-1.mat',...
'data/circuit/code5/simulation678-repeat9model-f-soft-1-1.mat',...
'data/circuit/code5/simulation678-repeat9model-g-soft-1-1.mat'...
};
filenames = {...
'data/circuit/code5/simulation678-repeat9model-e-soft-1-3.mat',...
'data/circuit/code5/simulation678-repeat9model-f-soft-1-3.mat',...
'data/circuit/code5/simulation678-repeat9model-g-soft-1-3.mat'...
};%check 2 and 3, 2 for rerun, 3 for checking zero error
filename='data/circuit/code5/simple-compare-mode-a-code5-v4.mat' %title  e
filenames = {...
'data/circuit/code5/simulation678-repeat9model-e-soft-3-2.mat',...
'data/circuit/code5/simulation678-repeat9model-f-soft-3-2.mat',...
'data/circuit/code5/simulation678-repeat9model-g-soft-3-2.mat'...
};%check 2 and 3, 2 for rerun, 3 for checking zero error
filename='data/circuit/code5/simple-compare-mode-a-code5-v5.mat' %title  e


%legends={'convolutional DS code, AG decoder';'wrong syndrome, G decoder';'repetition DS code with majority vote, GI decoder'};
legends={'pq=ps=pm';'pq=pm,ps=pm/10';'pq=pm,ps=pm*10'}
%'mode b repetition DS code with majority vote, GI decoder';'mode b repetition DS code, GI decoder'};
%filename='data/circuit/code5/simple-compare-mode-a-code5.mat' %title  e

timesteps=[1 1 1];
pqs=1.5:0.1:3.5;pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='pq=pm';

case 136 %136 % code 1 GA 

filenames = {...
'data/circuit/code1/simulation678-repeat9model-a-soft-3-1.mat',...
'data/circuit/code1/simulation678-repeat9model-a-soft-3-2.mat',...
'data/circuit/code1/simulation678-repeat9model-a-soft-3-3.mat'
};
filename='data/circuit/code1/simple-compare-mode-a-code1.mat' %title

filenames = {...
'data/circuit/code1/simulation678-repeat9model-e-soft-1-1.mat',...
'data/circuit/code1/simulation678-repeat9model-f-soft-1-1.mat',...
'data/circuit/code1/simulation678-repeat9model-g-soft-1-1.mat'
};
filename='data/circuit/code1/simple-compare-mode-a-code1-v2.mat'

filenames = {...
'data/circuit/code1/simulation678-repeat9model-e-soft-1-3.mat',...
'data/circuit/code1/simulation678-repeat9model-f-soft-1-3.mat',...
'data/circuit/code1/simulation678-repeat9model-g-soft-1-3.mat'
};%waiting for data 1-3
filename='data/circuit/code1/simple-compare-mode-a-code1-v3.mat'


legends={'pq=ps=pm';'pq=pm,ps=pm/10';'pq=pm,ps=pm*10'}

timesteps=[1 1 1];
pqs=0.5:0.1:3.5;pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='pq=pm';

case 137 %137  compare GI and GA

filenames = {...
'data/circuit/code5/simulation678-repeat9model-a-soft-7-1.mat',...
'data/circuit/code5/simulation678-repeat9model-a-soft-7-2.mat',...
'data/circuit/code5/simulation678-repeat9model-a-soft-7-3.mat',...
'data/circuit/code1/simulation678-repeat9model-a-soft-3-1.mat',...
'data/circuit/code1/simulation678-repeat9model-a-soft-3-2.mat',...
'data/circuit/code1/simulation678-repeat9model-a-soft-3-3.mat'
};
filename='data/circuit/code1/simple-compare-mode-a-code1-code5.mat' %title  e
filenames = {...
'data/circuit/code5/simulation678-repeat9model-e-soft-1-3.mat',...
'data/circuit/code5/simulation678-repeat9model-f-soft-1-3.mat',...
'data/circuit/code5/simulation678-repeat9model-g-soft-1-3.mat',...
'data/circuit/code1/simulation678-repeat9model-e-soft-1-1.mat',...
'data/circuit/code1/simulation678-repeat9model-f-soft-1-1.mat',...
'data/circuit/code1/simulation678-repeat9model-g-soft-1-1.mat'...
};
filename='data/circuit/code1/simple-compare-mode-a-code1-code5-v2.mat' %title  e
filenames = {...
'data/circuit/code5/simulation678-repeat9model-e-soft-3-2.mat',...
'data/circuit/code5/simulation678-repeat9model-f-soft-3-2.mat',...
'data/circuit/code5/simulation678-repeat9model-g-soft-3-2.mat',...
'data/circuit/code1/simulation678-repeat9model-e-soft-1-3.mat',...
'data/circuit/code1/simulation678-repeat9model-f-soft-1-3.mat',...
'data/circuit/code1/simulation678-repeat9model-g-soft-1-3.mat'...
};
filename='data/circuit/code1/simple-compare-mode-a-code1-code5-v3.mat' %title  e



legends={'code5 GI: pq=ps=pm';'code5 GI: pq=pm,ps=pm/10';'code5 GI: pq=pm,ps=pm*10';...
'code1 GA: pq=ps=pm';'code1 GA: pq=pm,ps=pm/10';'code1 GA: pq=pm,ps=pm*10'}

timesteps=[1 1 1 1 1 1];
pqs=0.5:0.1:3.5;pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='pq=pm';

case 138 %138  GI with majority vote

filenames = {...
'data/circuit/code1/simulation7-repeat7model-a-soft-8-1.mat',...
'data/circuit/code1/simulation7-repeat7model-a-soft-8-2.mat',...
'data/circuit/code1/simulation7-repeat7model-a-soft-8-3.mat'
};
filename='data/circuit/code1/simple-compare-mode-a-code1-majority-vote.mat' %title  e
filenames = {...
'data/circuit/code1/simulation7-repeat7model-e-soft-1-2.mat',...
'data/circuit/code1/simulation7-repeat7model-f-soft-1-2.mat',...
'data/circuit/code1/simulation7-repeat7model-g-soft-1-2.mat'...
} %remove optimization, only zero error filter
filename='data/circuit/code1/simple-compare-mode-a-code1-majority-vote-v2.mat' %title  e
filenames = {...
'data/circuit/code1/simulation7-repeat7model-e-soft-1-5.mat',...
'data/circuit/code1/simulation7-repeat7model-f-soft-1-5.mat',...
'data/circuit/code1/simulation7-repeat7model-g-soft-1-5.mat'...
} %fix error_prob for generating error and soft decision decoding
filename='data/circuit/code1/simple-compare-mode-a-code1-majority-vote-v3.mat' %title  e
legends={'pq=ps=pm';'pq=pm,ps=pm/10';'pq=pm,ps=pm*10'}


timesteps=[1 1 1];
pqs=0.5:0.1:3.5;pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='pq=pm';

case 139 %139 compare GI(GR) and GI with majority vote

filenames = {...
'data/circuit/code5/simulation678-repeat9model-a-soft-7-1.mat',...
'data/circuit/code5/simulation678-repeat9model-a-soft-7-2.mat',...
'data/circuit/code5/simulation678-repeat9model-a-soft-7-3.mat',...
'data/circuit/code1/simulation7-repeat7model-a-soft-8-1.mat',...
'data/circuit/code1/simulation7-repeat7model-a-soft-8-2.mat',...
'data/circuit/code1/simulation7-repeat7model-a-soft-8-3.mat'
};
filename='data/circuit/code1/simple-compare-mode-a-code1-majority-vote-vs-GI.mat' %title  e

filenames = {...
'data/circuit/code5/simulation678-repeat9model-e-soft-1-3.mat',...
'data/circuit/code5/simulation678-repeat9model-f-soft-1-3.mat',...
'data/circuit/code5/simulation678-repeat9model-g-soft-1-3.mat'...
'data/circuit/code1/simulation7-repeat7model-e-soft-1-2.mat',...
'data/circuit/code1/simulation7-repeat7model-f-soft-1-2.mat',...
'data/circuit/code1/simulation7-repeat7model-g-soft-1-2.mat'...
};
filename='data/circuit/code1/simple-compare-mode-a-code1-majority-vote-vs-GI-v2.mat' %title  e

filenames = {...
'data/circuit/code5/simulation678-repeat9model-e-soft-1-3.mat',...
'data/circuit/code5/simulation678-repeat9model-f-soft-1-3.mat',...
'data/circuit/code5/simulation678-repeat9model-g-soft-1-3.mat'...
'data/circuit/code1/simulation7-repeat7model-e-soft-1-5.mat',...
'data/circuit/code1/simulation7-repeat7model-f-soft-1-5.mat',...
'data/circuit/code1/simulation7-repeat7model-g-soft-1-5.mat'...
};
filename='data/circuit/code1/simple-compare-mode-a-code1-majority-vote-vs-GI-v3.mat' %title  e

filenames = {...
'data/circuit/code5/simulation678-repeat9model-e-soft-3-2.mat',...
'data/circuit/code5/simulation678-repeat9model-f-soft-3-2.mat',...
'data/circuit/code5/simulation678-repeat9model-g-soft-3-2.mat'...
'data/circuit/code1/simulation7-repeat7model-e-soft-1-5.mat',...
'data/circuit/code1/simulation7-repeat7model-f-soft-1-5.mat',...
'data/circuit/code1/simulation7-repeat7model-g-soft-1-5.mat'...
};
filename='data/circuit/code1/simple-compare-mode-a-code1-majority-vote-vs-GI-v4.mat' %title  e


legends={'GI: pq=ps=pm';'GI: pq=pm,ps=pm/10';'GI: pq=pm,ps=pm*10';...
'majority vote: pq=ps=pm';'majority vote: pq=pm,ps=pm/10';'majority vote: pq=pm,ps=pm*10'};


timesteps=[1 1 1 1 1 1];
pqs=0.5:0.1:3.5;pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='pq=pm';

case 1310 %1310  G decoder with majority vote and wrong syndrome decoding failure

filenames = {...
'data/circuit/code1/simulation7-repeat7model-e-G-soft-1-2.mat',...
'data/circuit/code1/simulation7-repeat7model-f-G-soft-1-2.mat',...
'data/circuit/code1/simulation7-repeat7model-g-G-soft-1-2.mat',...
} 
filename='data/circuit/code1/simple-compare-mode-a-code1-G-v2.mat' %title  e
%legends={'pq=ps=pm';'pq=pm,ps=pm/10';'pq=pm,ps=pm*10'}
legends={'G: pq=ps=pm';'G: pq=pm,ps=pm/10';'G: pq=pm,ps=pm*10'};
timesteps=[1 1 1];
pqs=0.5:0.1:3.5;pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='pq=pm';

case 1311 %1311 % compare G decoder with GI majority vote

filenames = {...
'data/circuit/code1/simulation7-repeat7model-e-G-soft-1-1.mat',...
'data/circuit/code1/simulation7-repeat7model-f-G-soft-1-1.mat',...
'data/circuit/code1/simulation7-repeat7model-g-G-soft-1-1.mat',...
'data/circuit/code1/simulation7-repeat7model-e-soft-1-5.mat',...
'data/circuit/code1/simulation7-repeat7model-f-soft-1-5.mat',...
'data/circuit/code1/simulation7-repeat7model-g-soft-1-5.mat'...
} 
filename='data/circuit/code1/simple-compare-mode-a-code1-G-vs-GI.mat' %title  e
legends={'G: pq=ps=pm';'G: pq=pm,ps=pm/10';'G: pq=pm,ps=pm*10';
'majority vote: pq=ps=pm';'majority vote: pq=pm,ps=pm/10';'majority vote: pq=pm,ps=pm*10'};
timesteps=[1 1 1 1 1 1];
pqs=0.5:0.1:3.5;pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='pq=pm';



case 151 % 151  % compare three decoder with p_s = 10 p_q

filenames = {...
'data/circuit/code1/simulation678-repeat9model-f-soft-2-5.mat',...
'data/circuit/code5/simulation678-repeat9model-f-soft-2-6.mat',...
'data/circuit/code1/simulation7-repeat7model-f-soft-2-3.mat'
}  %data for 2-(1,2,3,4) 2-1 is the best and 2-4 the worst
%check  data 2-5 for 60 sec  % data 2-6 for 600 sec
filename='data/circuit/code1/simple-compare-mode-f-three-decoder-v2.mat' %title  e

filenames = {...
'data/circuit/code5/simulation678-repeat9model-f-soft-3-2.mat',...
'data/circuit/code1/simulation678-repeat9model-f-soft-1-3.mat',...
'data/circuit/code1/simulation7-repeat7model-f-soft-1-5.mat'
}  %data for 2-(1,2,3,4) 2-1 is the best and 2-4 the worst
%check  data 2-5 for 60 sec  % data 2-6 for 600 sec
filename='data/circuit/code1/simple-compare-mode-f-three-decoder-v3.mat' %title  e

%legends={'pq=ps=pm';'pq=pm,ps=pm/10';'pq=pm,ps=pm*10'}
legends={'GI(GR) decdoer';'GA decoder';'GI with majority vote'}

timesteps=[1 1 1];
pqs=0.5:0.1:2.5;pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='pq=pm';

case 161 % 161  % compare four decoder with p_s = 10 p_q
filenames = {...
'data/circuit/code5/simulation678-repeat9model-f-soft-3-2.mat',...
'data/circuit/code1/simulation678-repeat9model-f-soft-1-3.mat',...
'data/circuit/code1/simulation7-repeat7model-f-soft-1-5.mat',...
'data/circuit/code1/simulation7-repeat7model-f-G-soft-1-1.mat',...
}
filename='data/circuit/code1/simple-compare-mode-f-four-decoder.mat' %title  e
legends={'GI(GR) decdoer';'GA decoder';'GI with majority vote';'G decoder, wrong syndrome'}
timesteps=[1 1 1 1];
pqs=0.5:0.1:2.5;pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='pq=pm';

case 162 % 162  % compare four decoder with p_s = p_q
filenames = {...
'data/circuit/code5/simulation678-repeat9model-e-soft-3-2.mat',...
'data/circuit/code1/simulation678-repeat9model-e-soft-1-3.mat',...
'data/circuit/code1/simulation7-repeat7model-e-soft-1-5.mat',...
'data/circuit/code1/simulation7-repeat7model-e-G-soft-1-1.mat',...
}
filename='data/circuit/code1/simple-compare-mode-e-four-decoder.mat' %title  e
legends={'GI(GR) decdoer';'GA decoder';'GI with majority vote';'G decoder, wrong syndrome'}
timesteps=[1 1 1 1];
pqs=0.5:0.1:2.5;pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='pq=pm';


case 21
% try soft decoding by changing metric_vec. doesn;t get a result (no optimization descoverd)
        %        filename1='data/circuit/code1/simulationCircuit9model-a-hard-4.mat';        
        %filename2='data/circuit/code1/simulationCircuit9model-a-hard-3-1.mat';
        filenames={...
            'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-equal-2.mat',...
            'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-less-pq-2.mat',...
            'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-less-ps-3.mat',...
            'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-less-ps-2.mat'};
        legends = {'hard';'soft pq=ps/2';'soft pq=ps*2';'soft pq=ps/3200'};
        timesteps=[10 10 10 10];
filename='data/circuit/code1/vary-syndrome-prob2.mat' %title  

case 22
filenames={...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-2.mat',...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-3.mat'}
%legends = {'hard';'soft pq=ps/2';'soft pq=ps*2';'soft pq=ps/3200'};
legends = {'soft ps=0.5','hard'};
timesteps=[10 10];
filename='data/circuit/code1/vary-syndrome-prob3.mat' %title

case 24 %24
filenames={...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-1.mat',...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-64.mat',...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-64-2.mat',...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-5.mat',...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-64-3.mat',...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-64-4.mat',...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-64-5.mat'}
%legends = {'hard';'soft pq=ps/2';'soft pq=ps*2';'soft pq=ps/3200'};
legends = {'hard','syndrome=0','syndrome=1','wrong syndrome','ps=pq/10000','pq=ps/1000','ps=0.95'};
timesteps=[1 1 1 1 1 1 1];
filename='data/circuit/code1/vary-syndrome-prob5.mat' %title

case 25 %25
filenames={...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-1.mat',...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-64.mat',...
'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-soft-64-2.mat',...
'data/circuit/code5/simulation678-repeat9model-a-soft-6.mat',...
'data/circuit/code5/simulation678-repeat9model-a-soft-5.mat',...
'data/circuit/code5/simulation678-repeat9model-a-soft-2.mat',...
'data/circuit/code5/simulation678-repeat9model-a-soft-1.mat'}
%legends = {'hard';'soft pq=ps/2';'soft pq=ps*2';'soft pq=ps/3200'};
legends = {'hard','syndrome=0','syndrome=1','check: pq=0.45,ps=0.001','check: pq=ps=pm','check: sth..','check: pq=pm,ps=0.95'};
timesteps=[1 1 1 1 1 1 1];
filename='data/circuit/code5/vary-syndrome-prob6.mat' %title

end



%save_more(filenames,filename,legends,timesteps);
save_more(filenames,filename,legends,timesteps,extraXY,extraName);

end

function save_more(filenames,titleText,legends, timesteps, extraXY,extraName)
%draw any number of curves, filenames is a cell of filenames
%extraXY is not necessary, reserverd for some calculated bounds.
%get data
length=size(filenames,2);
tables=cell(1,length);
for i=1:length
filename = filenames{i};
load(filename,'table');
tables{i} = table;
end
%myfig=figure('pos',[100 400 700 500],'visible','off')  %left bottom width height
myfig=figure('pos',[100 400 480 360])  %left bottom width height
 %fig=figure('visible','off');
hold on
halfLength=ceil(length/2);
for i=1:halfLength
%plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,5))+log10(timesteps(i)),'-o');
plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,4))+log10(timesteps(i)),'-o');
end
for i=(halfLength+1):length
%plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,5))+log10(timesteps(i)),'--*');
plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,4))+log10(timesteps(i)),'--*');
end
if nargin==6
plots(length+1)=plot(log10(extraXY(1,:)),log10(extraXY(2,:)),':');%-o  :
filenames{1,end+1}=extraName;
legends(end+1,1)={extraName};
end
if nargin==2
legends=filenames;
end
filenames'
titleText
legend(plots,legends,'FontSize',8) %11
%legend('Location','southeast')
legend('Location','northwest')
title(titleText)
label(1)
hold off
saveas(myfig,[titleText(1:end-4),'.fig'],'fig')
saveas(myfig,[titleText(1:end-4),'.png'],'png')
saveas(myfig,[titleText(1:end-4),'.pdf'],'pdf')

end

 function label(label_flag)
 switch label_flag
 case 1
 xlabel('Input error probability pm (log10)')
 ylabel('rate of decoding failure (log10)')
 case 2
 xlabel('error probability on each time step (log10)')
 ylabel('lifetime * timesteps (log10)')      
 end
 end
 
 