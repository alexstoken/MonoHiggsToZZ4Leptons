#!/bin/bash

# This script loops through the input text files and generates CRAB3 config files for each sample
# Author: Dustin Burns 13 Apr 2016

submitJobs=true

datainput=crab_input_bkg_Spring16.txt

lastDatapoint=`cat $datainput | wc -l`
echo "There are "$lastDatapoint" data samples."

iterData=0
while [ $iterData -lt $lastDatapoint ];
do
  iterData=$(( iterData + 1))
  INPUTDATASET=(`head -n $iterData $datainput  | tail -1 | awk '{print $1}'`)
  NAME=(`head -n $iterData $datainput  | tail -1 | awk -v my_var1=2 '{print $my_var1}'`) 
  echo " "
  echo "Generating config for "$NAME""
  sed -e 's/INPUTDATASET/'${INPUTDATASET}'/g' -e 's/REQUESTNAME/'${NAME}'/g' crab_template.py > crab_bkg_${NAME}.py
  if [[ "$submitJobs" == "true" ]]
  then
    echo " "
    echo "Submitting jobs for "$INPUTDATASET""
    crab submit crab_bkg_${NAME}.py # CRAB3 Check Environment!
    #crab -create -submit -cfg crab2Config_data_${NAME}.cfg # CRAB2 Check Environment!
    #crab -status -c Data2015_MonoHiggs_13TeV_crab2/${NAME}
  fi
done
