function simulationPlot(table,filename,repeat)
figure
%plot(table(:,2),table(:,4))
 plot(log10(table(:,2)),log10(table(:,4)),'-o')
 %plot(log10(tableConvolutional(:,2)),log10(tableConvolutional(:,4)),'-o',log10(tableRepetition(:,2)),log10(tableRepetition(:,4)),'-o')
 %plot((tableConvolutional(:,2)),(tableConvolutional(:,4)),'--',(tableRepetition(:,2)),(tableRepetition(:,4)),'-o')
 
%  legend(filename);
%  legend('Location','northwest')
%  title(['decoding simulation, repeat = ',num2str(repeat)]);
 title(filename);
 xlabel('error probability on qubits and syndrome bits (log10)')
 ylabel('rate of decoding failure (log10)')
end