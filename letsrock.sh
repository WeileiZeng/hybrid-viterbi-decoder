#This file run runSimulation.sh for the four code/decoder at once
#Orgin of names: I wrote this script at around 12am and got exicted to run everything and get the result the next morning. So let's rock!

#you will not remember those file versions, so those versions will be saved in saveresult.m, with a detailed description
# decdoer_flag  file_version
file_version="-soft-2-1"
file_version="-soft-2-4" #waiting
file_version="-soft-1-1" #now run for code 6, 60 sec
file_version="-soft-1-2" #600 sec waiting
file_version="-soft-2-1" #600 sec B finished
file_version="-soft-1-1" #A 60sec
file_version="-soft-1-2" #A 600 sec best data
file_version="-soft-1-3" #A 1800 sec waiting for mode g
#A GA 10800 sec
file_version="-soft-2-2" #3600 sec B mode g GA waiting3
#3600 sec B mode g GR GI  waiting3

file_version="-soft-3-1" #GI without majority vote
dataPointTime=600
phenomenological_model=B

#./runSimulation.sh GA $dataPointTime "$file_version" $phenomenological_model 
#./runSimulation.sh GR $dataPointTime "$file_version" $phenomenological_model 
./runSimulation.sh GI $dataPointTime "$file_version" $phenomenological_model 
#./runSimulation.sh G $dataPointTime "$file_version" $phenomenological_model 
#./runSimulation.sh GA $dataPointTime "$file_version" 
#./runSimulation.sh GR $dataPointTime "$file_version" 
#./runSimulation.sh GI $dataPointTime "$file_version" 
#./runSimulation.sh G $dataPointTime "$file_version" 
#./runSimulation.sh GA 600 "-soft-1-3" &
#./runSimulation.sh GR 600 "-soft-1-3" &
#./runSimulation.sh GI 600 "-soft-1-3" &
#./runSimulation.sh G 600 "-soft-1-3" &
wait
date
echo "finished, $dataPointTime"
