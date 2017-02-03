#!/bin/bash
# -----------------------------------------------------------------------------
#  File:        calc_limits.sh
#  Usage:       bash calc_limits.sh 4l
#  Description: Runs the sequence of steps to calculate and plot cross section
#               upper limits using event yields from the HiggsAnalysis/HiggsToZZ4Leptons
#               selection framework.
#  Created:     5-July-2016 Dustin Burns
# -----------------------------------------------------------------------------

echo 'Finding limits for channel' $1

# -----------------------------------------------------------------------------
#  List input files with full paths in separate files for each channel. 
# -----------------------------------------------------------------------------
echo '-----------------------------------------------------------------------------'
echo 'Step 1: Build file lists'
echo '-----------------------------------------------------------------------------'
#ls /lustre/cms/store/user/gminiell/MonoHiggs/76X/histos4mu_25ns/*root | grep -v bnn > filelist_4mu_2015_Fall15_AN_Bari.txt
#ls /lustre/cms/store/user/gminiell/MonoHiggs/76X/histos4e_25ns/*root | grep -v bnn > filelist_4e_2015_Fall15_AN_Bari.txt
#ls /lustre/cms/store/user/gminiell/MonoHiggs/76X/histos2e2mu_25ns/*root | grep -v bnn > filelist_2e2mu_2015_Fall15_AN_Bari.txt


# -----------------------------------------------------------------------------
#   Loop through input files, printing out yields and outputting root files containing
#   shape distributions.
# -----------------------------------------------------------------------------
echo '-----------------------------------------------------------------------------'
echo 'Step 2: Find event yields from ntuples'
echo '-----------------------------------------------------------------------------'
mkdir -p datacards_4mu datacards_4e datacards_2e2mu datacards_4l
rm yields.txt
rm datacards_4mu/f4mu.root
rm datacards_4e/f4e.root
rm datacards_2e2mu/f2e2mu.root
if [ $1 == "4l" ]; then
  python print_yields.py --channel 4mu --metcut 60 --m4lcut 10   >> yields.txt
  python print_yields.py --channel 4e --metcut 60 --m4lcut 10    >> yields.txt
  python print_yields.py --channel 2e2mu --metcut 60 --m4lcut 10 >> yields.txt
else python print_yields.py --channel $1 --metcut 60 --m4lcut 10 >> yields.txt
fi


# -----------------------------------------------------------------------------
#   Generate data cards for combine tool using yields and shape files from Step 2 
#   starting from templates hhxx_*_Fall15_card_template.txt, which include information
#   for applying systematic uncertainties. 
# -----------------------------------------------------------------------------
echo '-----------------------------------------------------------------------------'
echo 'Step 3: Generate cards for different signals and channels'
echo '-----------------------------------------------------------------------------'
if [ $1 == "4mu" ];   then python gen_cards.py '4muchannel'; fi
if [ $1 == "4e" ];    then python gen_cards.py '4echannel'; fi
if [ $1 == "2e2mu" ]; then python gen_cards.py '2e2muchannel'; fi
if [ $1 == "4l" ]; then
  python gen_cards.py '4muchannel'
  python gen_cards.py '4echannel'
  python gen_cards.py '2e2muchannel'

  # Zp2HDM

  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-300_13TeV-madgraph-pythia8.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-300_13TeV-madgraph-pythia8.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-300_13TeV-madgraph-pythia8.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-300_13TeV-madgraph-pythia8.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-300_13TeV-madgraph-pythia8.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-300_13TeV-madgraph-pythia8.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-300_13TeV-madgraph-pythia8.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-300_13TeV-madgraph-pythia8.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-300_13TeV-madgraph-pythia8.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-300_13TeV-madgraph-pythia8.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-300_13TeV-madgraph-pythia8.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-300_13TeV-madgraph-pythia8.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-300_13TeV-madgraph-pythia8.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-300_13TeV-madgraph-pythia8.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-300_13TeV-madgraph-pythia8.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-300_13TeV-madgraph-pythia8.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-300_13TeV-madgraph-pythia8.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-300_13TeV-madgraph-pythia8.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-300_13TeV-madgraph-pythia8.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-300_13TeV-madgraph-pythia8.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-300_13TeV-madgraph-pythia8.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-300_13TeV-madgraph-pythia8.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-300_13TeV-madgraph-pythia8.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-300_13TeV-madgraph-pythia8.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-600_MA0-300_13TeV-madgraph-pythia8.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-600_MA0-300_13TeV-madgraph-pythia8.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-600_MA0-300_13TeV-madgraph-pythia8.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-600_MA0-300_13TeV-madgraph-pythia8.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-300_13TeV-madgraph-pythia8.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-300_13TeV-madgraph-pythia8.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-300_13TeV-madgraph-pythia8.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-300_13TeV-madgraph-pythia8.txt

  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-400_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-400_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-400_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-400_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-400_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-400_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-400_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-400_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-400_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-400_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-400_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-400_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-400_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-400_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-400_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-400_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-400_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-400_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-400_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-400_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-400_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-400_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-400_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-400_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-600_MA0-400_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-600_MA0-400_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-600_MA0-400_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-600_MA0-400_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-400_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-400_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-400_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-400_13TeV-madgraph.txt
 ## 
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-500_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-500_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-500_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-500_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-500_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-500_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-500_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-500_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-500_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-500_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-500_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-500_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-500_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-500_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-500_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-500_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-500_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-500_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-500_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-500_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-500_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-500_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-500_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-500_13TeV-madgraph.txt
  #combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-500_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-500_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-500_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-500_13TeV-madgraph.txt
##
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-600_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-600_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-600_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-600_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-600_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-600_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-600_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-600_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-600_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-600_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-600_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-600_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-600_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-600_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-600_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-600_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-600_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-600_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-600_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-600_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-600_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-600_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-600_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-600_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-600_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-600_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-600_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-600_13TeV-madgraph.txt
##
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-700_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-700_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-700_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-700_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-700_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-700_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-700_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-700_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-700_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-700_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-700_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-700_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-700_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-700_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-700_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-700_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-700_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-700_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-700_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-700_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-700_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-700_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-700_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-700_13TeV-madgraph.txt
###
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-800_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-800_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-800_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-800_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-800_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-800_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-800_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-800_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-800_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-800_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-800_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-800_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-800_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-800_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-800_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-800_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-800_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-800_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-800_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-800_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-800_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-800_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-800_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-800_13TeV-madgraph.txt
  
 
# ZpBaryonic
 
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-1_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-1_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-1_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-1_13TeV-madgraph.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-1_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-1_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-1_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-1_13TeV-madgraph.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-100_MChi-1_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-100_MChi-1_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-100_MChi-1_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-100_MChi-1_13TeV-madgraph.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-1_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-1_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-1_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-1_13TeV-madgraph.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-2000_MChi-1_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-2000_MChi-1_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-2000_MChi-1_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-2000_MChi-1_13TeV-madgraph.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-1_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-1_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-1_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-1_13TeV-madgraph.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-20_MChi-1_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-20_MChi-1_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-20_MChi-1_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-20_MChi-1_13TeV-madgraph.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-300_MChi-1_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-300_MChi-1_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-300_MChi-1_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-300_MChi-1_13TeV-madgraph.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-1_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-1_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-1_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-1_13TeV-madgraph.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-1_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-1_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-1_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-1_13TeV-madgraph.txt

 # combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-10_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-10_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-10_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-10_13TeV-madgraph.txt
 # combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-100_MChi-10_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-100_MChi-10_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-100_MChi-10_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-100_MChi-10_13TeV-madgraph.txt
 # combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-10_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-10_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-10_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-10_13TeV-madgraph.txt
 # combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-15_MChi-10_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-15_MChi-10_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-15_MChi-10_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-15_MChi-10_13TeV-madgraph.txt
 # combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-10_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-10_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-10_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-10_13TeV-madgraph.txt
#
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-50_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-50_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-50_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-50_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-95_MChi-50_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-95_MChi-50_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-95_MChi-50_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-95_MChi-50_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-50_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-50_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-50_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-50_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-50_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-50_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-50_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-50_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-300_MChi-50_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-300_MChi-50_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-300_MChi-50_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-300_MChi-50_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-50_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-50_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-50_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-50_13TeV-madgraph.txt
#
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-150_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-150_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-150_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-150_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-150_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-150_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-150_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-150_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-150_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-150_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-150_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-150_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-150_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-150_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-150_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-150_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-295_MChi-150_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-295_MChi-150_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-295_MChi-150_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-295_MChi-150_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-150_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-150_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-150_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-150_13TeV-madgraph.txt
#
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-500_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-500_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-500_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-500_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-995_MChi-500_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-995_MChi-500_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-995_MChi-500_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-995_MChi-500_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-500_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-500_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-500_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-500_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-2000_MChi-500_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-2000_MChi-500_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-2000_MChi-500_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-2000_MChi-500_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-500_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-500_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-500_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-500_13TeV-madgraph.txt
#
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-1000_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-1000_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-1000_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-1000_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-1000_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-1000_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-1000_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-1000_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-1000_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-1000_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-1000_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-1000_13TeV-madgraph.txt
#  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MonoHZZ4l_ZpBaryonic_MZp-1995_MChi-1000_13TeV-madgraph.txt datacards_4e/hhxx_Fall15_card_4e_MonoHZZ4l_ZpBaryonic_MZp-1995_MChi-1000_13TeV-madgraph.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MonoHZZ4l_ZpBaryonic_MZp-1995_MChi-1000_13TeV-madgraph.txt > datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-1995_MChi-1000_13TeV-madgraph.txt
#

  sed -i -e 's/datacards_4mu\/datacards_4mu\//datacards_4mu\//g' datacards_4l/hhxx_Fall15_card_4l_*.txt
  sed -i -e 's/datacards_4e\/datacards_4e\//datacards_4e\//g' datacards_4l/hhxx_Fall15_card_4l_*.txt
  sed -i -e 's/datacards_2e2mu\/datacards_2e2mu\//datacards_2e2mu\//g' datacards_4l/hhxx_Fall15_card_4l_*.txt

  #sed -i -e 's/datacards/ZZ\/datacards/g' datacards_4l/hhxx_Fall15_card_4l_*.txt
fi


# -----------------------------------------------------------------------------
#  Run the Asymptotic method of the combine tool on the data cards, outputting limits to 
#  txt files.
# -----------------------------------------------------------------------------
echo '-----------------------------------------------------------------------------'
echo 'Step 4: Calculate limits for different signals'
echo '-----------------------------------------------------------------------------'

# Zp2HDM

combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-300_13TeV-madgraph-pythia8.txt > limits_$1_MZP1000_MA0300.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-300_13TeV-madgraph-pythia8.txt > limits_$1_MZP1200_MA0300.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-300_13TeV-madgraph-pythia8.txt > limits_$1_MZP1400_MA0300.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-300_13TeV-madgraph-pythia8.txt > limits_$1_MZP1700_MA0300.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-300_13TeV-madgraph-pythia8.txt > limits_$1_MZP2000_MA0300.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-300_13TeV-madgraph-pythia8.txt > limits_$1_MZP2500_MA0300.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-600_MA0-300_13TeV-madgraph-pythia8.txt > limits_$1_MZP600_MA0300.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-300_13TeV-madgraph-pythia8.txt > limits_$1_MZP800_MA0300.txt

#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-400_13TeV-madgraph.txt > limits_$1_MZP1000_MA0400.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-400_13TeV-madgraph.txt > limits_$1_MZP1200_MA0400.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-400_13TeV-madgraph.txt > limits_$1_MZP1400_MA0400.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-400_13TeV-madgraph.txt > limits_$1_MZP1700_MA0400.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-400_13TeV-madgraph.txt > limits_$1_MZP2000_MA0400.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-400_13TeV-madgraph.txt > limits_$1_MZP2500_MA0400.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-600_MA0-400_13TeV-madgraph.txt > limits_$1_MZP600_MA0400.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-400_13TeV-madgraph.txt > limits_$1_MZP800_MA0400.txt
#
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-500_13TeV-madgraph.txt > limits_$1_MZP1000_MA0500.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-500_13TeV-madgraph.txt > limits_$1_MZP1200_MA0500.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-500_13TeV-madgraph.txt > limits_$1_MZP1400_MA0500.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-500_13TeV-madgraph.txt > limits_$1_MZP1700_MA0500.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-500_13TeV-madgraph.txt > limits_$1_MZP2000_MA0500.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-500_13TeV-madgraph.txt > limits_$1_MZP2500_MA0500.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-500_13TeV-madgraph.txt > limits_$1_MZP800_MA0500.txt
#
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-600_13TeV-madgraph.txt > limits_$1_MZP1000_MA0600.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-600_13TeV-madgraph.txt > limits_$1_MZP1200_MA0600.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-600_13TeV-madgraph.txt > limits_$1_MZP1400_MA0600.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-600_13TeV-madgraph.txt > limits_$1_MZP1700_MA0600.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-600_13TeV-madgraph.txt > limits_$1_MZP2000_MA0600.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-600_13TeV-madgraph.txt > limits_$1_MZP2500_MA0600.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-800_MA0-600_13TeV-madgraph.txt > limits_$1_MZP800_MA0600.txt
#
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-700_13TeV-madgraph.txt > limits_$1_MZP1000_MA0700.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-700_13TeV-madgraph.txt > limits_$1_MZP1200_MA0700.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-700_13TeV-madgraph.txt > limits_$1_MZP1400_MA0700.txt
##combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-700_13TeV-madgraph.txt > limits_$1_MZP1700_MA0700.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-700_13TeV-madgraph.txt > limits_$1_MZP2000_MA0700.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-700_13TeV-madgraph.txt > limits_$1_MZP2500_MA0700.txt

#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1000_MA0-800_13TeV-madgraph.txt > limits_$1_MZP1000_MA0800.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1200_MA0-800_13TeV-madgraph.txt > limits_$1_MZP1200_MA0800.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1400_MA0-800_13TeV-madgraph.txt > limits_$1_MZP1400_MA0800.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-1700_MA0-800_13TeV-madgraph.txt > limits_$1_MZP1700_MA0800.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2000_MA0-800_13TeV-madgraph.txt > limits_$1_MZP2000_MA0800.txt
#combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_ZprimeToA0hToA0chichihZZTo4l_2HDM_MZp-2500_MA0-800_13TeV-madgraph.txt > limits_$1_MZP2500_MA0800.txt

# ZpBaryonic

combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-1_13TeV-madgraph.txt > limits_ZpBaryonic_MZP10000_MChi1.txt
combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-1_13TeV-madgraph.txt > limits_ZpBaryonic_MZP1000_MChi1.txt
combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-100_MChi-1_13TeV-madgraph.txt > limits_ZpBaryonic_MZP100_MChi1.txt
combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-1_13TeV-madgraph.txt > limits_ZpBaryonic_MZP10_MChi1.txt
combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-2000_MChi-1_13TeV-madgraph.txt > limits_ZpBaryonic_MZP2000_MChi1.txt
combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-1_13TeV-madgraph.txt > limits_ZpBaryonic_MZP200_MChi1.txt
combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-20_MChi-1_13TeV-madgraph.txt > limits_ZpBaryonic_MZP20_MChi1.txt
combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-300_MChi-1_13TeV-madgraph.txt > limits_ZpBaryonic_MZP300_MChi1.txt
combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-1_13TeV-madgraph.txt > limits_ZpBaryonic_MZP500_MChi1.txt
combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-1_13TeV-madgraph.txt > limits_ZpBaryonic_MZP50_MChi1.txt

#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-10_13TeV-madgraph.txt > limits_ZpBaryonic_MZP10000_MChi10.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-100_MChi-10_13TeV-madgraph.txt > limits_ZpBaryonic_MZP100_MChi10.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-10_13TeV-madgraph.txt > limits_ZpBaryonic_MZP10_MChi10.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-15_MChi-10_13TeV-madgraph.txt > limits_ZpBaryonic_MZP15_MChi10.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-10_13TeV-madgraph.txt > limits_ZpBaryonic_MZP50_MChi10.txt
#
##combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-50_13TeV-madgraph.txt > limits_ZpBaryonic_MZP10000_MChi50.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-95_MChi-50_13TeV-madgraph.txt > limits_ZpBaryonic_MZP95_MChi50.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-50_13TeV-madgraph.txt > limits_ZpBaryonic_MZP10_MChi50.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-50_13TeV-madgraph.txt > limits_ZpBaryonic_MZP200_MChi50.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-300_MChi-50_13TeV-madgraph.txt > limits_ZpBaryonic_MZP300_MChi50.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-50_MChi-50_13TeV-madgraph.txt > limits_ZpBaryonic_MZP50_MChi50.txt

#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-150_13TeV-madgraph.txt > limits_ZpBaryonic_MZP10000_MChi150.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-150_13TeV-madgraph.txt > limits_ZpBaryonic_MZP1000_MChi150.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-150_13TeV-madgraph.txt > limits_ZpBaryonic_MZP10_MChi150.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-200_MChi-150_13TeV-madgraph.txt > limits_ZpBaryonic_MZP200_MChi150.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-295_MChi-150_13TeV-madgraph.txt > limits_ZpBaryonic_MZP295_MChi150.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-150_13TeV-madgraph.txt > limits_ZpBaryonic_MZP500_MChi150.txt
#
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-500_13TeV-madgraph.txt > limits_ZpBaryonic_MZP10000_MChi500.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-995_MChi-500_13TeV-madgraph.txt > limits_ZpBaryonic_MZP995_MChi500.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-500_13TeV-madgraph.txt > limits_ZpBaryonic_MZP10_MChi500.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-2000_MChi-500_13TeV-madgraph.txt > limits_ZpBaryonic_MZP2000_MChi500.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-500_MChi-500_13TeV-madgraph.txt > limits_ZpBaryonic_MZP500_MChi500.txt
#
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10000_MChi-1000_13TeV-madgraph.txt > limits_ZpBaryonic_MZP10000_MChi1000.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-1000_MChi-1000_13TeV-madgraph.txt > limits_ZpBaryonic_MZP1000_MChi1000.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-10_MChi-1000_13TeV-madgraph.txt > limits_ZpBaryonic_MZP10_MChi1000.txt
#combine -M Asymptotic datacards_4l/hhxx_Fall15_card_4l_MonoHZZ4l_ZpBaryonic_MZp-1995_MChi-1000_13TeV-madgraph.txt > limits_ZpBaryonic_MZP1995_MChi1000.txt
#
#
# -----------------------------------------------------------------------------
#  Combine txt files containing limits in order for plotting.
# -----------------------------------------------------------------------------
echo '-----------------------------------------------------------------------------'
echo 'Step 5: Merge txt files in ascending MZP order'
echo '-----------------------------------------------------------------------------'
cat limits_4l_MZP600_MA0300.txt limits_4l_MZP800_MA0300.txt limits_4l_MZP1000_MA0300.txt limits_4l_MZP1200_MA0300.txt limits_4l_MZP1400_MA0300.txt limits_4l_MZP1700_MA0300.txt limits_4l_MZP2000_MA0300.txt limits_4l_MZP2500_MA0300.txt > limits_Zp2HDM_4l_MA0300.txt
#cat limits_4l_MZP600_MA0400.txt limits_4l_MZP800_MA0400.txt limits_4l_MZP1000_MA0400.txt limits_4l_MZP1200_MA0400.txt limits_4l_MZP1400_MA0400.txt limits_4l_MZP1700_MA0400.txt limits_4l_MZP2000_MA0400.txt limits_4l_MZP2500_MA0400.txt > limits_Zp2HDM_4l_MA0400.txt
#cat limits_4l_MZP800_MA0500.txt limits_4l_MZP1000_MA0500.txt limits_4l_MZP1200_MA0500.txt limits_4l_MZP1400_MA0500.txt limits_4l_MZP1700_MA0500.txt limits_4l_MZP2000_MA0500.txt limits_4l_MZP2500_MA0500.txt > limits_Zp2HDM_4l_MA0500.txt
#cat limits_4l_MZP800_MA0600.txt limits_4l_MZP1000_MA0600.txt limits_4l_MZP1200_MA0600.txt limits_4l_MZP1400_MA0600.txt limits_4l_MZP1700_MA0600.txt limits_4l_MZP2000_MA0600.txt limits_4l_MZP2500_MA0600.txt > limits_Zp2HDM_4l_MA0600.txt
#cat limits_4l_MZP1000_MA0700.txt limits_4l_MZP1200_MA0700.txt limits_4l_MZP1400_MA0700.txt limits_4l_MZP1700_MA0700.txt limits_4l_MZP2000_MA0700.txt limits_4l_MZP2500_MA0700.txt > limits_Zp2HDM_4l_MA0700.txt
#cat limits_4l_MZP1000_MA0800.txt limits_4l_MZP1200_MA0800.txt limits_4l_MZP1400_MA0800.txt limits_4l_MZP1700_MA0800.txt limits_4l_MZP2000_MA0800.txt limits_4l_MZP2500_MA0800.txt > limits_Zp2HDM_4l_MA0800.txt

cat limits_ZpBaryonic_MZP10_MChi1.txt limits_ZpBaryonic_MZP20_MChi1.txt limits_ZpBaryonic_MZP50_MChi1.txt limits_ZpBaryonic_MZP100_MChi1.txt limits_ZpBaryonic_MZP200_MChi1.txt limits_ZpBaryonic_MZP300_MChi1.txt limits_ZpBaryonic_MZP500_MChi1.txt limits_ZpBaryonic_MZP1000_MChi1.txt limits_ZpBaryonic_MZP2000_MChi1.txt limits_ZpBaryonic_MZP10000_MChi1.txt > limits_ZpBaryonic_MChi1.txt
#cat limits_ZpBaryonic_MZP10_MChi10.txt limits_ZpBaryonic_MZP15_MChi10.txt limits_ZpBaryonic_MZP50_MChi10.txt limits_ZpBaryonic_MZP100_MChi10.txt limits_ZpBaryonic_MZP10000_MChi10.txt > limits_ZpBaryonic_MChi10.txt
#cat limits_ZpBaryonic_MZP10_MChi50.txt limits_ZpBaryonic_MZP50_MChi50.txt limits_ZpBaryonic_MZP95_MChi50.txt limits_ZpBaryonic_MZP200_MChi50.txt limits_ZpBaryonic_MZP300_MChi50.txt limits_ZpBaryonic_MZP10000_MChi50.txt > limits_ZpBaryonic_MChi50.txt
#cat limits_ZpBaryonic_MZP10_MChi150.txt limits_ZpBaryonic_MZP200_MChi150.txt limits_ZpBaryonic_MZP295_MChi150.txt limits_ZpBaryonic_MZP500_MChi150.txt limits_ZpBaryonic_MZP1000_MChi150.txt limits_ZpBaryonic_MZP10000_MChi150.txt > limits_ZpBaryonic_MChi150.txt
#cat limits_ZpBaryonic_MZP10_MChi500.txt limits_ZpBaryonic_MZP500_MChi500.txt limits_ZpBaryonic_MZP995_MChi500.txt limits_ZpBaryonic_MZP2000_MChi500.txt limits_ZpBaryonic_MZP10000_MChi500.txt > limits_ZpBaryonic_MChi500.txt
#cat limits_ZpBaryonic_MZP10_MChi1000.txt limits_ZpBaryonic_MZP1000_MChi1000.txt limits_ZpBaryonic_MZP1995_MChi1000.txt limits_ZpBaryonic_MZP10000_MChi1000.txt > limits_ZpBaryonic_MChi1000.txt
#

# -----------------------------------------------------------------------------
#  Parse the limits file for median and +/- 1,2 sigma limits numbers only for plotting.
# -----------------------------------------------------------------------------
echo '-----------------------------------------------------------------------------'
echo 'Step 6: Parse merged txt file to extract limits'
echo '-----------------------------------------------------------------------------'
python format_limits.py $1 Zp2HDM
python format_limits.py $1 ZpBaryonic
#python format_limits_2D.py
#python format_limits_ZpBaryonic_2D.py  

# -----------------------------------------------------------------------------
#  Parse the output of Step 6 and create limit plots, properly scaled.
# -----------------------------------------------------------------------------
echo '-----------------------------------------------------------------------------'
echo 'Step 7: Plot limits'
echo '-----------------------------------------------------------------------------'
mkdir -p plots
root -b -q -l "limitPlots_Zp2HDM.C(\"$1\")"
root -b -q -l "limitPlots_ZpBaryonic.C(\"$1\")"
