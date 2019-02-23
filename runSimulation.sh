#This script is run by letsrock.sh
# run simulation7 and simulation678.
# define variables
#which code/decoder to use: GA,GR,GI,G
decoder_flag=$1
#phenomenological model A (single shot) or B (repeated emasurement, qubit error accumulate in measurement)
phenomenological_model=B
phenomenological_model=$4
case $decoder_flag in
    GA)
	dataPointTime=600
#	code=code1
	code=code6
	file_version=-soft-2-3
	file_version=-soft-3-1
	file_version=-soft-3-2  #vary pq
	#	simulation=simulation678
	;;
    GR)
	dataPointTime=600
#	code=code5
	code=code7
	file_version=-soft-4-3
	file_version=-soft-5-1
	#	simulation=simulation678
	;;
    GI)
	numFails=200
#	numFails=10
	G_code_switch=0
	file_version=-soft-2-3
	file_version=-soft-3-1
	#	simulation=simulation7
	;;
    G)
	numFails=200
	G_code_switch=1
	file_version=-G-soft-2-3
	file_version=-G-soft-3-1
	file_version=-soft-3-1  #-G will be added in sumulation7.m according to G_code_switch
	#no G needed
	#	simulation=simulation7
	;;
	
esac

#general control
if true ;then
    #dataPointTime in sec. Note we can run in parrallel using parfor, then the total time (not dataPOintTime) will be reduce by 8 or so.
   dataPointTime=1 #1800  #600, 6000
   numFails=40000 #200, 2000  #don't want to use numFails, so keep it large enough
   file_version=-soft-7-2
   file_version=-soft-7-4
   file_version=-soft-7-2 #just for GA
   file_version=-soft-1-1

   dataPointTime=$2
   file_version=$3
   file_version=-$phenomenological_model$file_version
fi
   
#only run g for new data

#for errorModel in {e,f,g}
for errorModel in {e,f,g}
do
    case $decoder_flag in
	GA|GR)
	    matlab -nodisplay -nodesktop -r "clear,numFails=$numFails,dataPointTime=$dataPointTime,code='$code',errorModel='$errorModel',file_version='$file_version',phenomenological_model='$phenomenological_model',simulation678,exit;"
#	    matlab -nodisplay -nodesktop -r "clear,numFails="$numFails",dataPointTime="$dataPointTime",code='"$code"',errorModel='"$errorModel"',file_version='"$file_version"',simulation678,exit;"&
	    ;;
	GI|G)
	    matlab -nodisplay -nodesktop -r "clear,numFails=$numFails,dataPointTime=$dataPointTime,G_code_switch=$G_code_switch,errorModel='$errorModel',file_version='$file_version',phenomenological_model='$phenomenological_model',simulation7,exit;"
#	    matlab -nodisplay -nodesktop -r "clear,numFails="$numFails",dataPointTime="$dataPointTime",G_code_switch="$G_code_switch",errorModel='"$errorModel"',file_version='"$file_version"',simulation7,exit;"&
	    ;;
    esac
done
wait
date
echo "finished"
echo "finish running $decoder_flag, $file_version"


