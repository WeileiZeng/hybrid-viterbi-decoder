%Weilei Zeng 02/13/2019
%These are the plots after making code code 6 and code7,
%previous result save in backup20190213saveresult.m, for code 1 and code 5

%Weilei Zeng 08/06/2018
%plot the result of simulations

%control switch inside draw_code()
%draw_code()

%saveTwo()

run_save_more_circuit() %phenomenological model C, circuit model

%run_save_more() %for phenomenological A and B, sumer simulation
%update_plots()  %update for model A and model B

%paper_plot1()

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
    end

    %save the figure directly without display it.
    fig=figure('visible','off');
    hold on
    load(filename1);
    plots(1)=plot(log10(table(:,2)),log10(table(:,column_index(1)))+log10(timesteps(1)),'-o'); %plot life_time*timesteps
    load(filename2);
    plots(2)=plot(log10(table(:,2)),log10(table(:,column_index(2)))+log10(timesteps(2)),'-*'); %plot life_time*timesteps
    hold off
    legend(plots,legends);
    title(filename);
    label(2)
    saveas(fig,[filename(1:end-4),'.fig'],'fig')
    saveas(fig,[filename(1:end-4),'.png'],'png')
    saveas(fig,[filename(1:end-4),'.pdf'],'pdf')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function paper_plot1()
    filenames={'data/circuit/code6/simulation678-repeat9model-e-B-soft-2-1.mat',...
               'data/circuit/code6/simulation678-repeat9model-g-B-soft-2-1.mat',...
               'data/circuit/code8/simulation7-repeat7model-e-B-soft-3-1.mat',...
               'data/circuit/code8/simulation7-repeat7model-g-B-soft-3-1.mat'};
    timesteps=[37 37 10 10];
    folder_plots='data/circuit/plots2';
    filename=[folder_plots,'/model_B/two-decoder-model-e-g.mat'];
    legends={'GA $q=p$';'GA $q=10p$';'GI $q=p$';'GI $q=10p$'};
    pqs=0.5:0.1:4.5;
    pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='$P_{\rm BLER}=p$';
    %    save_more_circuit(filenames,filename,legends,timesteps,extraXY,extraName);
    %    save_more_lifetime(filenames,filename,legends,timesteps);
    save_more(filenames,filename,legends,timesteps,extraXY,extraName);
end


%making final plot for the paper
function paper_plot() %decided not to use
    paper_plot_flag=1;
    folder_plots='data/circuit/plots2';
    switch paper_plot_flag
      case 1
        %case 82 %small modification for mode g
        phenomenological_model='A'
        %phenomenological model B,  case/model e,g,f
        %        folder_plots='data/circuit/plots/summer_B';
        folder_plots='data/circuit/plots2/model_A';
        file_version='-A-soft-1-1'; %
        file_version='-A-soft-1-2'; %waiting 600 sec
        file_version='-A-soft-1-3'; %waiting 1800 seconly for mode g
        file_version_GA=file_version;
        file_version_GR=file_version;
        file_version_GI=file_version;
        file_version_G=['-G',file_version];

        filenames_GR = {...
            ['data/circuit/code7/simulation678-repeat9model-e',file_version_GR,'.mat'],...
            ['data/circuit/code7/simulation678-repeat9model-f',file_version_GR,'.mat'],...
            ['data/circuit/code7/simulation678-repeat9model-g',file_version_GR,'.mat']};
        filenames_GA = {...
            ['data/circuit/code6/simulation678-repeat9model-e',file_version_GA,'.mat'],...
            ['data/circuit/code6/simulation678-repeat9model-f',file_version_GA,'.mat'],...
            ['data/circuit/code6/simulation678-repeat9model-g',file_version_GA,'.mat']};
        filenames_GI = {...
            ['data/circuit/code8/simulation7-repeat7model-e',file_version_GI,'.mat'],...
            ['data/circuit/code8/simulation7-repeat7model-f',file_version_GI,'.mat'],...
            ['data/circuit/code8/simulation7-repeat7model-g',file_version_GI,'.mat']};
        filenames_G = {...
            ['data/circuit/code8/simulation7-repeat7model-e',file_version_G,'.mat'],...
            ['data/circuit/code8/simulation7-repeat7model-f',file_version_G,'.mat'],...
                    ['data/circuit/code8/simulation7-repeat7model-g',file_version_G,'.mat']};
        %      case 41 % mode e four decoder
        filename=[folder_plots,'/four-decoder-model-e.mat'];
        filenames=[filenames_GA(1),filenames_GR(1),filenames_GI(1),filenames_G(1)];
        legends={'GA';'GR';'GI';'G'};
        timesteps=[37 30 10 10];
                pqs=0.5:0.1:3.5;
    end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function run_save_more_circuit()
%what is going to plot: for the circuit error model (1)GA (2)GI  (3)G (no G decoder in this case)
    file_version_flag=4;%3;
    switch file_version_flag
      case 1 %phenomenological model A
             %        file_version='-A-soft-1-1';
        file_version='-A-soft-3-1'; % run14
        
        file_version_GA=['-GA',file_version];

        %        file_version='-A-soft-1-1'; %ok
        %        file_version='-A-soft-1-2'; %good 600sec
        file_version_GI=['-GI',file_version];

        folder_plots='data/circuit/plots/circuit_A';
      case 2 %phenomenological model B
        file_version='-B-soft-3-1'; % run14
        file_version='-B-soft-4-1'; % run14

        %file_version='-soft-1-3'; %good B 600sec
             %        file_version='-B-soft-1-2';% not good  600sec need: 3600sec
             %        file_version='-B-soft-3-1'; %
        file_version_GA=['-GA',file_version];

        %        file_version='-soft-2-2';%B best fix pq
        %        file_version='-B-soft-1-1'; %good 600sec
        %        file_version='-B-soft-2-1'; %
        file_version_GI=['-GI',file_version];
        %        folder_plots='data/circuit/plots/circuit_B';
        folder_plots='data/circuit/plots/model_C';
      case 3 %phenomenological model B, with code 6(GA) and code 8 (GI)


        file_version='-B-soft-1-3'; % run24, 5000 errors
        file_version='-B-soft-1-2'; % run24, 5000 errors

        file_version='-B-soft-2-1'; % run30, 10000 errors, new circuit file conv8v6
        
        %file_version='-B-soft-3-1'; % run35, 10000 errors, new circuit file conv9v2


        file_version='-B-soft-3-2'; % GA_run41,1800sec
                                    %        file_version='-B-soft-3-3'; % GA_run41,1800sec
        file_version_GA=['-GA',file_version];
        %        file_version='-B-soft-1-1'; % run24, 5000 errors
        %        file_version='-B-soft-1-2'; % run24, 5000 errors
        %        file_version='-B-soft-1-3'; % run24, 5000 errors
        %file_version='-B-soft-2-2'; %best data, run28, 1800sec
        %        file_version='-B-soft-3-1'; % run35, 10000 errors, new circuit file conv9v2
        file_version='-B-soft-3-2'; 
        file_version_GI=['-GI',file_version];
        %        folder_plots='data/circuit/plots/circuit_B';
        folder_plots='data/circuit/plots2/model_C';
      case 4 %phenomenological model B, with code 6(GA) and code 8 (GI), add measurement error

        file_version='-B-soft-3-2'; % GA_run41,1800sec

        file_version='-B-soft-1-1'; % 1-1 for testing then 1-2

        
        file_version_GA=['-GA',file_version];

        file_version_GI=['-GI',file_version];
        %        folder_plots='data/circuit/plots/circuit_B';
        folder_plots='data/circuit/plots2/model_C';
        
        
    end
    %reserve filenames other than filename for multiple curces
    %    filenames_GI={['data/circuit/code1/simulationRepeatCircuitRepeat7model-a',file_version_GI,'.mat']};
    %    filenames_GA={['data/circuit/code1/simulationCircuit9model-a',file_version_GA,'.mat']};

    filenames_GI={['data/circuit/code8/simulationRepeatCircuitRepeat7model-a',file_version_GI,'.mat']};
    filenames_GA={['data/circuit/code6/simulationCircuit9model-a',file_version_GA,'.mat']};

    %for model h and i with measurement error
    filenames_GI={['data/circuit/code8/simulationRepeatCircuitRepeat7model-a','-GI-B-soft-3-2','.mat'],...
                  ['data/circuit/code8/simulationRepeatCircuitRepeat7model-h',file_version_GI,'.mat'],...
                  ['data/circuit/code8/simulationRepeatCircuitRepeat7model-i',file_version_GI,'.mat']};
    %    filenames_GI={['data/circuit/code8/simulationRepeatCircuitRepeat7model-i',file_version_GI,'.mat']};
    filenames_GA={['data/circuit/code6/simulationCircuit9model-a','-GA-B-soft-3-2','.mat'],...
                  ['data/circuit/code6/simulationCircuit9model-h',file_version_GA,'.mat'],...
                  ['data/circuit/code6/simulationCircuit9model-i',file_version_GA,'.mat']};

        filenames_GI={['data/circuit/code8/simulationRepeatCircuitRepeat7model-a','-GI-B-soft-3-2','.mat'],...
                  ['data/circuit/code8/simulationRepeatCircuitRepeat7model-i',file_version_GI,'.mat']};
    filenames_GA={['data/circuit/code6/simulationCircuit9model-a','-GA-B-soft-3-2','.mat'],...
                  ['data/circuit/code6/simulationCircuit9model-i',file_version_GA,'.mat']};
    
    %    'data/circuit/code1/simulationRepeatCircuitRepeat7model-a-GI-soft-1-1.mat'
    %    folder_plots='data/circuit/plots/circuit';
    %    system(['mkdir ',folder_plots])%
    
    if nargin == 0 %if no default input
        flag=3011; %110;  %201;%110%99;
    end
    switch flag
      case 101 %101
        filename=[folder_plots,'/circuit-GA.mat'];
        filenames=filenames_GA;
        legends={'GA'}
        %        legends={'GA: $p_s=p_q$';'GA: $p_s=p_q/10$';'GA: $p_s=10p_q$'}
        timesteps=[1];
      case 102 %102
        filename=[folder_plots,'/circuit-GI.mat'];
        filenames=filenames_GI;
        legends={'GI'}
        %        legends={'GA: $p_s=p_q$';'GA: $p_s=p_q/10$';'GA: $p_s=10p_q$'}
        timesteps=[1];
      case 110 %11  plot p_fail0
        filename=[folder_plots,'/circuit-GA-vs-GI.mat'];
        %        filename=[folder_plots,'/circuit-lifetime-GA-vs-GI.mat'];
        filenames=[filenames_GA,filenames_GI];
        legends={'GA';'GI'}
        %        legends={'GA: $p_s=p_q$';'GA: $p_s=p_q/10$';'GA: $p_s=10p_q$'}
        timesteps=[1 1];
      case 201 %201 plot lifetime*time steps
               %filename=[folder_plots,'/circuit-GA-vs-GI.mat'];
        filename=[folder_plots,'/circuit-lifetime-GA-vs-GI.mat'];
        filenames=[filenames_GA,filenames_GI];
        legends={'GA';'GI'}
        %        legends={'GA: $p_s=p_q$';'GA: $p_s=p_q/10$';'GA: $p_s=10p_q$'}
        timesteps=[37 9];
      case 301 %11  plot p_fail0
        filename=[folder_plots,'/circuit-GA-vs-GI-ahi.mat'];
        filenames=[filenames_GA,filenames_GI];
        legends={'GA q=0';'GA q=p';'GA q=10p';'GI q=0';'GI q=p';'GI q=10p'}
        timesteps=[1 1 1 1 1 1];
        
      case 3011 %11  plot p_fail0
        filename=[folder_plots,'/circuit-GA-vs-GI.mat'];
        filenames=[filenames_GA,filenames_GI];
        legends={'GA $q=0$';'GA $q=10p$';'GI $q=0$';'GI $q=10p$'}
        timesteps=[1 1 1 1];
        %        legends={'GA: $p_s=p_q$';'GA: $p_s=p_q/10$';'GA: $p_s=10p_q$'}
      case 302 %plot lifetime for three modes
        filename=[folder_plots,'/circuit-lifetime-GA-vs-GI.mat'];
        filenames=[filenames_GA,filenames_GI];
        %        legends={'GA';'GI'}
        legends={'GA q=0';'GA q=p';'GA q=10p';'GI q=0';'GI q=p';'GI q=10p'}
        %        legends={'GA: $p_s=p_q$';'GA: $p_s=p_q/10$';'GA: $p_s=10p_q$'}
        timesteps=[37 37 37 9 9 9];
        timesteps=[47 47 47 9 9 9];
        
    end
    pqs=0.5:0.1:3.5;
    %filenames'
    pqs=1.0:0.1:3.5;

    pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='$P_{BLER}=p$';
    switch flag
      case {201,302}
        %extraXY=[pqs;1./pqs-1];extraName='effective lifetime 1/p-1';
        save_more_circuit_lifetime(filenames,filename,legends,timesteps);
      otherwise
        save_more_circuit(filenames,filename,legends,timesteps,extraXY,extraName);
    end
    %    save_more_circuit_lifetime(filenames,filename,legends,timesteps,extraXY,extraName);
    %
                  
end

function save_more_circuit(filenames,titleText,legends, timesteps, extraXY,extraName)
%plot p_fail vs p_q
%draw any number of curves, filenames is a cell of filenames
%extraXY is not necessary, reserverd for some calculated bounds.
%get data
        length=size(filenames,2); %total number of curves except extraXY
        tables=cell(1,length);
        for i=1:length
            filename = filenames{i};
            load(filename,'table');
            tables{i} = table;
        end
        filenames'
        linestyle={'-*';'-o';'--^';'--s';'-*';'-o';'--^';'--s';'-*';'-o';'--^';'--s'};
         %myfig=figure('pos',[100 400 700 500],'visible','off')  %left bottom width height
         myfig=figure('pos',[100 300 360 270],'visible','off')  %left bottom width height
                                                %fig=figure('visible','off');
         hold on
         halfLength=ceil(length/2); %devide curve into two groups for different linestyles
         timesteps=[39 39 10 10];
         for i =1:length
             %plots(i)=plot(log10(tables{i}(:,7)),log10(tables{i}(:,4)),linestyle{i}); %p_fail vs pq
             plots(i)=plot(log10(tables{i}(:,2))+log10(timesteps(i)),log10(tables{i}(:,4)),linestyle{i}); %p_fail vs pq
         end
         %for i=1:halfLength
         %   %timesteps is taken care by pq, so timesteps is not needed here
         %   plots(i)=plot(log10(tables{i}(:,7)),log10(tables{i}(:,4)),'-o'); %p_fail vs pq
                                                                              %             plots(i)=plot(log10(tables{i}(:,7)),log10(tables{i}(:,4))+log10(timesteps(i)),'-o'); %p_fail vs pq
             %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,5))+log10(timesteps(i)),'-o'); %lifetime*timesteps vs pm/pq
             %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,4))+log10(timesteps(i)),'-o'); %p_fail vs pm/pq
             %end
             %for i=(halfLength+1):length
             %plots(i)=plot(log10(tables{i}(:,7)),log10(tables{i}(:,4)),'--*'); %p_fail vs pq
             %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,5))+log10(timesteps(i)),'--*');
             %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,4))+log10(timesteps(i)),'--*');
             %end
         if nargin==6
             %plots(length+1)=plot(log10(extraXY(1,:)),log10(extraXY(2,:)),':');%-o  :
             %filenames{1,end+1}=extraName;
             %legends(end+1,1)={extraName};
             %plots(length+2)=plot(log10(extraXY(1,:)),log10(extraXY(2,:)*4),':');%-o  :
             %plots(length+3)=plot(log10(extraXY(1,:)),log10(extraXY(2,:)*5),':');%-o  :
             plots(length+1)=plot(log10(extraXY(1,:)),log10(extraXY(2,:)*6),':');%-o  :
             %legends(end+1,1)={'$$4p_q'};
             %legends(end+1,1)={'5p_q'};
             legends(end+1,1)={'$P_{\rm BLER}=6p$'};
         end
         if nargin==2
             legends=filenames;
         end
         filenames'
         titleText
         legend(plots,legends,'FontSize',8) %11
                                            %legend('Location','southeast')
         legend('Location','southeast')
         legend('Interpreter','Latex')
         %title(titleText)
         label(6)  %4
         
         hold off
         saveas(myfig,[titleText(1:end-4),'.fig'],'fig')
         saveas(myfig,[titleText(1:end-4),'.png'],'png')
         saveas(myfig,[titleText(1:end-4),'.pdf'],'pdf')         
end

function save_more_circuit_lifetime(filenames,titleText,legends, timesteps, extraXY,extraName)
%plot lifetime*timesteps vs p_m
%draw any number of curves, filenames is a cell of filenames
%extraXY is not necessary, reserverd for some calculated bounds.
%get data
        length=size(filenames,2); %total number of curves except extraXY
        tables=cell(1,length);
        for i=1:length
            filename = filenames{i};
            load(filename,'table');
            tables{i} = table;
         end
         myfig=figure('pos',[100 400 360 270],'visible','off')  %left bottom width height
                                                                %fig=figure('visible','off');
         hold on
         %         timesteps=[37,9]
         halfLength=ceil(length/2); %devide curve into two groups for different linestyles
         for i=1:halfLength
             %timesteps is taken care by pq, so timesteps is not needed here
             %plots(i)=plot(log10(tables{i}(:,7)),log10(tables{i}(:,4)),'-o'); %p_fail vs pq
             %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,7)),'-.'); % pq vs pm
             %plots(i)=plot(log10(tables{i}(:,7)),log10(tables{i}(:,4))+log10(timesteps(i)),'-o'); %p_fail vs pq
             plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,5))+log10(timesteps(i)),'-o'); %lifetime*timesteps vs pm
             %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,4))+log10(timesteps(i)),'-o'); %p_fail vs pm/pq
         end
         for i=(halfLength+1):length
             %plots(i)=plot(log10(tables{i}(:,7)),log10(tables{i}(:,4)),'--*'); %p_fail vs pq
             %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,7)),'-.'); % pq vs pm
             plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,5))+log10(timesteps(i)),'--*');
             %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,4))+log10(timesteps(i)),'--*');
         end
         if nargin==6
             plots(length+1)=plot(log10(extraXY(1,:)),log10(extraXY(2,:)),':');%-o  :
             filenames{1,end+1}=extraName;
             legends(end+1,1)={extraName};
         end
         if 1
             pms=tables{4}(:,2);
             pqs=tables{4}(:,7);
             plots(length+1)=plot(log10(pms),log10(1./pqs-1)+log10(9),'-.');%-o  :
             filenames{1,end+1}={'effective lifetime 1/p-1'};
             legends(end+1,1)={'$\overline t = 1/p-1$'};
             pms=pms(3:end);
             pqs=pqs(3:end);
             plots(length+2)=plot(log10(pms),log10(1/6./pqs-1)+log10(9),':');%-o  :
             filenames{1,end+1}={'effective lifetime 1/6p-1'};
             legends(end+1,1)={'$\overline t = 1/6p-1$'};
             %plots(length+1)=plot(log10(pms),log10(1./pms-1)+log10(1),':');%-o  :

         end
         
         if nargin==2
             legends=filenames;
         end
         filenames'
         titleText
         legend(plots,legends,'FontSize',10) %11
                                            %legend('Location','southeast')
         legend('Location','northeast')
         legend('Location','southwest')
         legend('Interpreter','Latex')
         %title(titleText)
         label(2)
         
         hold off
         saveas(myfig,[titleText(1:end-4),'.fig'],'fig')
         saveas(myfig,[titleText(1:end-4),'.png'],'png')
         saveas(myfig,[titleText(1:end-4),'.pdf'],'pdf')         
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%below part for summer simulations (phenomenological model A
function update_plots()
    all=[301,302,303,304,44,31,32,33,41,42,43];
    comparisons=[31,32,33,41,42,43];
    singles=[301,302,303,304,44];
    flags=302;    
    flags=all;
    %    flags=41;%41;%43; %for mode g
    for flag=flags
        try
            run_save_more(flag)
        end
    end
end
    
function run_save_more(flag)
%define filenames for data
%GA: code1, simulation678
%GR: GI(GR): code5, simulation678
%GI: GI with majority vote, code1 simulation 7
%G:  code1 simulation7, wrong syndrome filter
    folder_plots='data/circuit/plots2';
    %there are four folders under plots/

    file_version_flag=72;%72 and 82 for new plots
    %now only use 4(41) and 6
    %Feb use 7 and 8 for fixed code with fixed generator, code 6,7,8
    switch file_version_flag
      case 7
        %phenomenological model B,  case/model e,g,f
        %        folder_plots='data/circuit/plots/summer_B';
        phenomenological_model='B'
        folder_plots='data/circuit/plots2/model_B';
        file_version='-B-soft-3-1'; 
        file_version='-B-soft-1-1'; %okay
        file_version='-B-soft-1-2'; %still waiting 600sec, not a right circuit
        file_version='-B-soft-2-1'; %best 600sec for GR and GA, GI, G.  Some curves need to be updated
        file_version_GA=file_version;
        file_version_GR=file_version;
        file_version_GI=file_version;
        file_version_G=['-G',file_version];
      case 72
        %phenomenological model B,  case/model e,g,f
        %        folder_plots='data/circuit/plots/summer_B';
        phenomenological_model='B'
        folder_plots='data/circuit/plots2/model_B';
        file_version='-B-soft-3-1'; 
        file_version='-B-soft-1-1'; %okay
        file_version='-B-soft-1-2'; %still waiting 600sec, not a right circuit

        %havnt update this plot
        file_version='-B-soft-2-2'; %3600 sec for mode g GA case ,have copied 2-2 to 2-1
        file_version='-B-soft-2-1'; %best 600sec for GR and GA, GI, G.  Some curves need to be updated

        file_version_GA=file_version;
        %1800 sec for GI and GR case, mode g
        file_version_GR=file_version;
        file_version_GI=file_version;

        file_version_G=['-G',file_version];

      case 8
        phenomenological_model='A'
        %phenomenological model B,  case/model e,g,f
        %        folder_plots='data/circuit/plots/summer_B';
        folder_plots='data/circuit/plots2/model_A';
        file_version='-A-soft-1-1'; %
        file_version='-A-soft-1-2'; %waiting 600 sec
        file_version_GA=file_version;
        file_version_GR=file_version;
        file_version_GI=file_version;
        file_version_G=['-G',file_version];

      case 82 %small modification for mode g
        phenomenological_model='A'
        %phenomenological model B,  case/model e,g,f
        %        folder_plots='data/circuit/plots/summer_B';
        folder_plots='data/circuit/plots2/model_A';
        file_version='-A-soft-1-1'; %
        file_version='-A-soft-1-2'; %waiting 600 sec
                                    %        file_version='-A-soft-1-3'; %waiting 1800 seconly for mode g
        file_version_GA=file_version;
        file_version_GR=file_version;
        file_version_GI=file_version;
        file_version_G=['-G',file_version];



        
      case 1 %decoding failure
        file_version_GR='-soft-4-3';
        file_version_GA='-soft-2-3'; %waiting
        file_version_GI='-soft-2-3';
        file_version_G ='-G-soft-2-3';
      case 2  %logical failure
        file_version_GR='-soft-5-1'; %logical failure
        file_version_GA='-soft-3-1'; %logical failure
        file_version_GI='-soft-3-1'; %logical failure
        file_version_G ='-G-soft-3-1'; %logical failure

        %        file_version_GA='-soft-3-2'; %logical failure
      case 3
        % a change for range of small pq
        file_version='-soft-7-1';
        file_version_GA=file_version;
        file_version_GR=file_version;
        file_version='-soft-7-2';
        file_version_GI=file_version;

        file_version_G=['-G',file_version];

      case 4
        %        folder_plots='data/circuit/plots/summer_A';
        folder_plots='data/circuit/plots/model_A';
        %phenomenological model A,  case/model e,g,f
        %file_version='-soft-7-3'; %test data
        file_version='-soft-7-4'; %wider range than case 2.  dataRunTime=600
        file_version_GR=file_version;
        file_version_GI=file_version;
        file_version_G=['-G',file_version];
        
        file_version='-soft-7-2'; % more data, dataRunTime=1800
        %supposed to be 7-4-1,but I put it to 7-2, luckily didn't tuin other data
        file_version_GA=file_version;
        %result: saved in plots/logical_failure2/. results are expected, except for mode g, the curve is not smooth, may rerun and update later.

      case 41  %compared to 4, we add name for '-A' in file version
               %since model A for circuit is a fake model, I never run this simulation.
        folder_plots='data/circuit/plots/model_A';
        %phenomenological model A,  case/model e,g,f
        file_version='-A-soft-1-1'; %test data
        file_version_GR=file_version;
        file_version_GI=file_version;
        file_version_G=['-G',file_version];        
        file_version_GA=file_version;
      case 5 %outdated
        %i dont see any difference from case 6
        %folder_plots='data/circuit/plots/phenomenological-model-B';
        %        folder_plots='data/circuit/plots/summer_A';
        %phenomenological model B,  circuit model  only GA and GI code , saved in plots/phenomenological-model-B
        file_version='-B-soft-1-1'; 
        file_version_GR=file_version;
        file_version_GI=file_version;
        file_version_G=['-G',file_version];
        file_version_GA=file_version;
        %result: saved in plots/logical_failure2/. results are expected, except for mode g, the curve is not smooth, may rerun and update later.

        %        file_version_GA=['-GA',file_version];
        %file_version_GR=['-GR',file_version];
        %file_version_GI=['-GI',file_version];
        %file_version_G=['-G',file_version];
      case 6
        %phenomenological model B,  case/model e,g,f
        %        folder_plots='data/circuit/plots/summer_B';
        folder_plots='data/circuit/plots/model_B';
        file_version='-B-soft-1-3'; %best data
        file_version='-B-soft-2-3'; %okay data, 60 sec, need run 600 sec
        file_version='-B-soft-2-4'; %600 sec waiting
        file_version_GA=file_version;
        file_version_GR=file_version;
        file_version_GI=file_version;
        file_version_G=['-G',file_version];
        
    end


    if nargin == 0 %if no default input
        flag=99;
    end
    
    
    %filenames_GR = {...
    %   ['data/circuit/code5/simulation678-repeat9model-e',file_version_GR,'.mat'],...
    %   ['data/circuit/code5/simulation678-repeat9model-f',file_version_GR,'.mat'],...
    %   ['data/circuit/code5/simulation678-repeat9model-g',file_version_GR,'.mat']};
    filenames_GR = {...
        ['data/circuit/code7/simulation678-repeat9model-e',file_version_GR,'.mat'],...
        ['data/circuit/code7/simulation678-repeat9model-f',file_version_GR,'.mat'],...
        ['data/circuit/code7/simulation678-repeat9model-g',file_version_GR,'.mat']};
    %GR:  -soft-3-2
    %filenames_GA = {...
    %   ['data/circuit/code1/simulation678-repeat9model-e',file_version_GA,'.mat'],...
    %   ['data/circuit/code1/simulation678-repeat9model-f',file_version_GA,'.mat'],...
    %   ['data/circuit/code1/simulation678-repeat9model-g',file_version_GA,'.mat']};
    filenames_GA = {...
        ['data/circuit/code6/simulation678-repeat9model-e',file_version_GA,'.mat'],...
        ['data/circuit/code6/simulation678-repeat9model-f',file_version_GA,'.mat'],...
        ['data/circuit/code6/simulation678-repeat9model-g',file_version_GA,'.mat']};
    %GA: -soft-1-3
    %filenames_GI = {... 
    %   ['data/circuit/code1/simulation7-repeat7model-e',file_version_GI,'.mat'],...
    %   ['data/circuit/code1/simulation7-repeat7model-f',file_version_GI,'.mat'],...
    %   ['data/circuit/code1/simulation7-repeat7model-g',file_version_GI,'.mat']};
    filenames_GI = {... 
        ['data/circuit/code8/simulation7-repeat7model-e',file_version_GI,'.mat'],...
        ['data/circuit/code8/simulation7-repeat7model-f',file_version_GI,'.mat'],...
        ['data/circuit/code8/simulation7-repeat7model-g',file_version_GI,'.mat']};
    %GI:  -soft-1-5
    %filenames_G = {...
    %   ['data/circuit/code1/simulation7-repeat7model-e',file_version_G,'.mat'],...
    %   ['data/circuit/code1/simulation7-repeat7model-f',file_version_G,'.mat'],...
    %       ['data/circuit/code1/simulation7-repeat7model-g',file_version_G,'.mat']};
    filenames_G = {...
        ['data/circuit/code8/simulation7-repeat7model-e',file_version_G,'.mat'],...
        ['data/circuit/code8/simulation7-repeat7model-f',file_version_G,'.mat'],...
        ['data/circuit/code8/simulation7-repeat7model-g',file_version_G,'.mat']};
    %G:  -G-soft-1-2
    switch flag
      case 301
          filename=[folder_plots,'/GA.mat'];
          filenames=filenames_GA;
          legends={'GA: $q=p$';'GA: $q=p/10$';'GA: $q=10p$'};
          timesteps=[1 1 1]*37;
          pqs=0.5:0.1:3.5;
      case 302
          filename=[folder_plots,'/GR.mat'];
          filenames=filenames_GR;
          legends={'GR: $q=p$';'GR: $q=p/10$';'GR: $q=10p$'};              
          timesteps=[1 1 1]*30;
          pqs=0.5:0.1:3.5;
      case 303
          filename=[folder_plots,'/GI.mat'];
          filenames=filenames_GI;
          legends={'GI: $q=p$';'GI: $q=p/10$';'GI: $q=10p$'};              
          timesteps=[1 1 1]*10;
          pqs=0.5:0.1:3.5;
      case 304
          filename=[folder_plots,'/G.mat'];
          filenames=filenames_G;
          legends={'G: $q=p$';'G: $q=p/10$';'G: $q=10p$'};              
          timesteps=[1 1 1]*10;
          pqs=0.5:0.1:3.5;

          
      case 31  %31  GR vs GA    
          filename=[folder_plots,'/GR-vs-GA.mat'];
          filenames=[filenames_GR,filenames_GA];
          legends={'GR: $q=p$';'GR: $q=p/10$';'GR: $q=10p$';...
                   'GA: $q=p$';'GA: $q=p/10$';'GA: $q=10p$'}
          timesteps=[[1 1 1]*30,[ 1 1 1]*37];
          pqs=0.5:0.1:3.5;
      case 32  % GR vs GI
          filename=[folder_plots,'/GR-vs-GI.mat'];
          filenames=[filenames_GR,filenames_GI];
          legends={'GR: $q=p$';'GR: $q=p/10$';'GR: $q=10p$';...
                   'GI: $q=p$';'GI: $q=p/10$';'GI: $q=10p$'}
          timesteps=[1 1 1 1 1 1];
          timesteps=[[1 1 1]*30,[ 1 1 1]*10];
          pqs=0.5:0.1:3.5;
      case 33  %G vs GI
          filename=[folder_plots,'/G-vs-GI.mat'];
          filenames=[filenames_G,filenames_GI];
          legends={'G: $q=p$';'G: $q=p/10$';'G: $q=10p$';...
                   'GI: $q=p$';'GI: $q=p/10$';'GI: $q=10p$'}
          timesteps=[1 1 1 1 1 1];
          timesteps=[[1 1 1]*10,[ 1 1 1]*10];
          pqs=0.5:0.1:3.5;
      case 41 % mode e four decoder
        filename=[folder_plots,'/four-decoder-model-e.mat'];
        filenames=[filenames_GA(1),filenames_GR(1),filenames_GI(1),filenames_G(1)];
        legends={'GA $q=p$';'GR $q=p$';'GI \ $q=p$';'G \ \ $q=p$'};
        timesteps=[37 30 10 10];
        pqs=0.5:0.1:3.5;
      case 42 % mode f four decoder
        filename=[folder_plots,'/four-decoder-model-f.mat'];
        filenames=[filenames_GA(2),filenames_GR(2),filenames_GI(2),filenames_G(2)];
        legends={'GA $q=p/10$';'GR $q=p/10$';'GI $q=p/10$';'G $q=p/10$'};
        timesteps=[1 1 1 1];
        timesteps=[37 30 10 10];
        pqs=0.5:0.1:3.5;
      case 43 % mode g four decoder
        filename=[folder_plots,'/four-decoder-model-g.mat'];
        filenames=[filenames_GA(3),filenames_GR(3),filenames_GI(3),filenames_G(3)];
        legends={'GA $q=10p$';'GR $q=10p$';'GI \ $q=10p$';'G \ \ $q=10p$'};
        timesteps=[1 1 1 1];
        timesteps=[37 30 10 10];
        pqs=1.5:0.1:3.5;
      case 44 % four decoder mode efg
        filename=[folder_plots,'/four-decoder.mat'];
        filenames=[filenames_GA,filenames_GR,filenames_GI,filenames_G];
        %        legends={'GA';'GR';'GI';'G'};
        legends={'GA: $q=p$';'GA: $q=p/10$';'GA: $q=10p$';...
                 'GR: $q=p$';'GR: $q=p/10$';'GR: $q=10p$';...
                 'GI: $q=p$';'GI: $q=p/10$';'GI: $q=10p$';...
                 'G: $q=p$';'G: $q=p/10$';'G: $q=10p$'}
        timesteps=[ [1 1 1]*37, [1 1 1]*30, [1 1 1]*10, [1 1 1]*10];
        pqs=0.5:0.1:3.5;
    end
    filenames'
    pqs=0.5:0.1:4.5;
    pqs=10.^(-pqs);extraXY=[pqs;pqs];extraName='$P_{BLER}=p$';
    switch phenomenological_model
      case {'A','B'}
        %plot p_fail
        save_more(filenames,filename,legends,timesteps,extraXY,extraName);
      case 'D' %'B'
        %plot life time
        save_more_lifetime(filenames,filename,legends,timesteps);
        %save_more_lifetime(filenames,filename,legends,timesteps,extraXY,extraName);
      otherwise
        %plot p_fail
    end

    disp(['finish ploting ',phenomenological_model,', ', file_version_falg,', ',folder_plots])
    
    %the remained part of this function can be deleted Feb 9
%save_more(filenames,filename,legends,timesteps);
%save_more(filenames,filename,legends,timesteps,extraXY,extraName);

end

function save_more(filenames,titleText,legends, timesteps, extraXY,extraName)
%draw any number of curves, filenames is a cell of filenames
%extraXY is not necessary, reserverd for some calculated bounds.
%get data
         %dont need timesteps here
    timesteps=timesteps*0+1;

         length=size(filenames,2);
         tables=cell(1,length);
         for i=1:length
             filename = filenames{i};
             load(filename,'table');
             tables{i} = table;

         end
         %myfig=figure('pos',[100 400 700 500],'visible','off')  %left bottom width height
         myfig=figure('pos',[100 300 360 270],'visible','off');  %left bottom width height
                                                                 %fig=figure('visible','off');
         ylim([-7 inf]);
         linestyle={'-*';'-o';'--^';'--s';'-*';'-o';'--^';'--s';'-*';'-o';'--^';'--s'};
         hold on
         for i=1:length
             plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,4))+log10(timesteps(i)),linestyle{i});
         end
         
         halfLength=ceil(length/2);
         %for i=1:halfLength
         %    %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,5))+log10(timesteps(i)),'-o');
         %   plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,4))+log10(timesteps(i)),'-o');
         %end
         %for i=(halfLength+1):length
             %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,5))+log10(timesteps(i)),'--*');
             %    plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,4))+log10(timesteps(i)),'--*');
             %end
         if 1==0; %nargin==6
             plots(length+1)=plot(log10(extraXY(1,:)),log10(extraXY(2,:)),':');%-o  :
             filenames{1,end+1}=extraName;
             legends(end+1,1)={extraName};
         end
         if nargin==2
             legends=filenames;
         end
         if 1
             pqs=1.5:0.1:4.5;
             pqs=0.1.^pqs;
             %plots(length+1)=plot(log10(pqs),log10(1./pqs-1),':');%-o  :
             %filenames{1,end+1}='effective life time 1/p-1';
             %legends(end+1,1)={'$\overline t = 1/p-1$'};
             plots(length+1)=plot(log10(pqs),log10(6*pqs),':');%-o  :
             filenames{1,end+1}={'p_BLER=6p'};
             legends(end+1,1)={'$P_{\rm BLER}=6p$'};
         end
         filenames'
         titleText
         legend(plots,legends,'FontSize',10) %11
                                            %legend('Location','southeast')
         legend('Location','southeast')
         legend('Interpreter','Latex')
         %title(titleText)
         label(4)%4 
         
         hold off
         %saveas(myfig,[titleText(1:end-4),'.fig'],'fig')
         savefig(myfig,[titleText(1:end-4),'.fig'])
         saveas(myfig,[titleText(1:end-4),'.png'],'png')
         saveas(myfig,[titleText(1:end-4),'.pdf'],'pdf')         
end

function save_more_lifetime(filenames,titleText,legends, timesteps, extraXY,extraName)
%draw any number of curves, filenames is a cell of filenames
%extraXY is not necessary, reserverd for some calculated bounds.
%get data
         %dont need timesteps here
         timesteps=timesteps*0+1;
         length=size(filenames,2);
         tables=cell(1,length);
         for i=1:length
             filename = filenames{i};
             load(filename,'table');
             tables{i} = table;

         end
         %myfig=figure('pos',[100 400 700 500],'visible','off')  %left bottom width height
         myfig=figure('pos',[100 300 360 270],'visible','off');  %left bottom width height
                                                                %fig=figure('visible','off');
                                                                %set(myfig, 'XScale', 'log', 'YScale', 'log');
         hold on
         xlim([-4 inf])
         linestyle={'-*';'-o';'--^';'--s';'-*';'-o';'--^';'--s';'-*';'-o';'--^';'--s'};

         
         halfLength=ceil(length/2);
         for i=1:length
             plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,5))+log10(timesteps(i)),linestyle{i});
         end
         %for i=1:halfLength
         %   plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,5))+log10(timesteps(i)),'-o');
             %plots(i)=loglog((tables{i}(:,2))',(tables{i}(:,5))*(timesteps(i))','-o');
             %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,4))+log10(timesteps(i)),'-o');
             %end
             %for i=(halfLength+1):length
             %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,5))+log10(timesteps(i)),'--*');
             %plots(i)=loglog((tables{i}(:,2))',(tables{i}(:,5))*(timesteps(i))','--*');
             %plots(i)=plot(log10(tables{i}(:,2)),log10(tables{i}(:,4))+log10(timesteps(i)),'--*');
             %end
         if nargin==6
             %plots(length+1)=plot(log10(extraXY(1,:)),log10(extraXY(2,:)),':');%-o  :
             filenames{1,end+1}=extraName;
             legends(end+1,1)={extraName};
         end
         if 1
             pqs=1.5:0.1:4.5;
             pqs=0.1.^pqs;
             plots(length+1)=plot(log10(pqs),log10(1./pqs-1),':');%-o  :
             filenames{1,end+1}='effective life time 1/p-1';
             legends(end+1,1)={'$\overline t = 1/p-1$'};
             plots(length+2)=plot(log10(pqs),log10(1/6./pqs-1),':');%-o  :
             filenames{1,end+1}='effective life time 1/6p-1';
             legends(end+1,1)={'$\overline t = 1/6p-1$'};
         end
         if nargin==2
             legends=filenames;
         end
         filenames'
         titleText
         
         legend(plots,legends,'FontSize',10) %11
                                            %legend('Location','southeast')
         legend('Location','northeast')
         legend('Interpreter','Latex')
         %title(titleText)
         label(5)
         
         hold off
         saveas(myfig,[titleText(1:end-4),'.fig'],'fig')
         saveas(myfig,[titleText(1:end-4),'.png'],'png')
         saveas(myfig,[titleText(1:end-4),'.pdf'],'pdf')         
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function shares by many plots
function label(label_flag)
    switch label_flag
      case 1  % p_fail and qubit error prob
        xlabel('qubit error probability p (log10)')
        ylabel('BLER (log10)')
      case 2 %lifetime * timesteps
        xlabel('error probability on each time step (log10)','Interpreter','Latex')
        ylabel('lifetime $\times$ timesteps ($\rm log_{10}$)','Interpreter','Latex');
      case 3  % p_fail and input error prob
        xlabel('Input error probability pm (log10)')
        ylabel('BLER (log10)')
      case 4  % logical failure in Latex
        xlabel('qubit error probability $p$ $(\rm log_{10})$','Interpreter','Latex','FontSize',12)
        ylabel('$P_{\rm BLER}$ ($\rm log_{10}$)','Interpreter','Latex','FontSize',12)

      case 5  % lifetime and qubit error prob
        xlabel('qubit error probability $p$ ($log_{10}$)','Interpreter','Latex','FontSize',12)
        ylabel('lifetime ($\rm log_{10}$)','Interpreter','Latex','FontSize',12)
        case 6  % logical failure in Latex  just for one plot
        xlabel('qubit error probability per cycle $p$ $(\rm log_{10})$','Interpreter','Latex','FontSize',12)
        ylabel('$P_{\rm BLER}$ ($\rm log_{10}$)','Interpreter','Latex','FontSize',12)
        
        
    end

end
