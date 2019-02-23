# run simulationCircuit. and simulationRepeatCircuit
# changed variables
#GI or GA code
decoder_flag=GA
#decoder_flag=$1
#model A or model B
phenomenological_model=B
dataPointTime=1800
#code=code1
# errorModel a,h,i, see generate_error_prob.m
errorModel=h

numFails=40000
#do not want to use this number, just use dataPointTime

#check version in saveresult.m
#file_version=-soft-3-1
file_version=-soft-4-1
file_version=-soft-1-3 #good data for GI or soft-1-2
file_version=-soft-2-1 #1,000,000error for GI,1800 sec,GI_run27
file_version=-soft-2-2 #10,000,000, 3600 sec,GI_run28

file_version=-soft-3-1 #test GI run40
file_version=-soft-3-2 #test GA run41,1800sec 
file_version=-soft-3-3 #test GA run41,

file_version=-soft-1-2 #mode h i GI  test-1-1
file_version=-soft-1-1 #mode h i GA



case $decoder_flag in
    GA)
	#code defined in matrix_generate.m
	code=code6
#	dataPointTime=600 #3600
#	numFails=2000
#	file_version=-soft-1-3
#	file_version=-soft-1-2
#	file_version=-soft-2-1
	file_version=-GA-$phenomenological_model$file_version
	simulation=simulationCircuit
	#error_folder=~/working/circuit/quantumsimulator/error/GA_run26
	error_folder=~/working/circuit/quantumsimulator/error/GA_run41
	;;
    GI)
	code=code8
#	dataPointTime=600
#	numFails=2000
#	numFails=2000
#	G_code_switch=0
#	file_version=-soft-1-1
#	file_version=-soft-2-1
	file_version=-GI-$phenomenological_model$file_version
	simulation=simulationRepeatCircuit
	#error_folder=~/working/circuit/quantumsimulator/error/GI_run28
	error_folder=~/working/circuit/quantumsimulator/error/GI_run41
	#	simulation=simulation7
	;;
#    G)
#	G_code_switch=1
#	dataPointTime=6
#	numFails=200
#	file_version=-soft-1-1
#	file_version=-G-$phenomenological_model$file_version
#	simulation=simulationRepeatCircuit
#	error_folder=~/working/circuit/quantumsimulator/error/GI_run13
#	;;
esac
matlab -nodisplay -nodesktop -r "clear,numFails=$numFails,dataPointTime=$dataPointTime,code='$code',file_version='$file_version',error_folder='$error_folder',errorModel='$errorModel',phenomenological_model='$phenomenological_model',$simulation,exit;"
date
echo "finish $decoder_flag,$phenomenological_model,$file_version,$numFails,$dataPointTime sec"
#matlab -nodisplay -nodesktop -r "clear,numFails=$numFails,dataPointTime=$dataPointTime,code='$code',file_version='$file_version',error_folder='$error_folder',errorModel='$errorModel',phenomenological_model='$phenomenological_model',$simulation,exit;"
