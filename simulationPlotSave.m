function simulationPlotSave(table,filename,timestep)
%save the figure directly without display it.
    fig=figure('visible','off');
%plot(table(:,2),table(:,4))
%plot(log10(table(:,2)),log10(table(:,4)),'-o') %plot p_fail
plot(log10(table(:,2)),log10(table(:,5))+log10(timestep),'-o') %plot life_time*timesteps


 %plot(log10(tableConvolutional(:,2)),log10(tableConvolutional(:,4)),'-o',log10(tableRepetition(:,2)),log10(tableRepetition(:,4)),'-o')
 %plot((tableConvolutional(:,2)),(tableConvolutional(:,4)),'--',(tableRepetition(:,2)),(tableRepetition(:,4)),'-o')
 
%  legend(filename);
%  legend('Location','northwest')
%  title(['decoding simulation, repeat = ',num2str(repeat)]);
title(filename);
xlabel('error prob for each timestep');
ylabel('lifetime*timesteps');
 % xlabel('error probability on qubits and syndrome bits (log10)')
 %ylabel('rate of decoding failure (log10)')
 saveas(fig,[filename(1:end-4),'.fig'],'fig')
 saveas(fig,[filename(1:end-4),'.png'],'png')
 %system('./sync_to_macbook_weilei.sh')
end