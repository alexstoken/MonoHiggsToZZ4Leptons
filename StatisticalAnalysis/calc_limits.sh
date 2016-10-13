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
rm yields.txt
if [ $1 == "4l" ]; then
  root -b -q -l "print_yields.C(\"4mu\")"   >> yields.txt
  root -b -q -l "print_yields.C(\"4e\")"    >> yields.txt
  root -b -q -l "print_yields.C(\"2e2mu\")" >> yields.txt
else root -b -q -l "print_yields.C(\"$1\")" >> yields.txt
fi


# -----------------------------------------------------------------------------
#   Generate data cards for combine tool using yields and shape files from Step 2 
#   starting from templates hhxx_*_Fall15_card_template.txt, which include information
#   for applying systematic uncertainties. 
# -----------------------------------------------------------------------------
echo '-----------------------------------------------------------------------------'
echo 'Step 3: Generate cards for different signals and channels'
echo '-----------------------------------------------------------------------------'
mkdir -p datacards_4mu datacards_4e datacards_2e2mu datacards_4l
if [ $1 == "4mu" ];   then python gen_cards.py '4muchannel'; fi
if [ $1 == "4e" ];    then python gen_cards.py '4echannel'; fi
if [ $1 == "2e2mu" ]; then python gen_cards.py '2e2muchannel'; fi
if [ $1 == "4l" ]; then
  python gen_cards.py '4muchannel'
  python gen_cards.py '4echannel'
  python gen_cards.py '2e2muchannel'
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MZP600_MA0300.txt datacards_4e/hhxx_Fall15_card_4e_MZP600_MA0300.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MZP600_MA0300.txt > datacards_4l/hhxx_Fall15_card_4l_MZP600_MA0300.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MZP800_MA0300.txt datacards_4e/hhxx_Fall15_card_4e_MZP800_MA0300.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MZP800_MA0300.txt > datacards_4l/hhxx_Fall15_card_4l_MZP800_MA0300.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MZP1000_MA0300.txt datacards_4e/hhxx_Fall15_card_4e_MZP1000_MA0300.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MZP1000_MA0300.txt > datacards_4l/hhxx_Fall15_card_4l_MZP1000_MA0300.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MZP1200_MA0300.txt datacards_4e/hhxx_Fall15_card_4e_MZP1200_MA0300.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MZP1200_MA0300.txt > datacards_4l/hhxx_Fall15_card_4l_MZP1200_MA0300.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MZP1400_MA0300.txt datacards_4e/hhxx_Fall15_card_4e_MZP1400_MA0300.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MZP1400_MA0300.txt > datacards_4l/hhxx_Fall15_card_4l_MZP1400_MA0300.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MZP1700_MA0300.txt datacards_4e/hhxx_Fall15_card_4e_MZP1700_MA0300.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MZP1700_MA0300.txt > datacards_4l/hhxx_Fall15_card_4l_MZP1700_MA0300.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MZP2000_MA0300.txt datacards_4e/hhxx_Fall15_card_4e_MZP2000_MA0300.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MZP2000_MA0300.txt > datacards_4l/hhxx_Fall15_card_4l_MZP2000_MA0300.txt
  combineCards.py datacards_4mu/hhxx_Fall15_card_4mu_MZP2500_MA0300.txt datacards_4e/hhxx_Fall15_card_4e_MZP2500_MA0300.txt datacards_2e2mu/hhxx_Fall15_card_2e2mu_MZP2500_MA0300.txt > datacards_4l/hhxx_Fall15_card_4l_MZP2500_MA0300.txt
fi


# -----------------------------------------------------------------------------
#  Run the Asymptotic method of the combine tool on the data cards, outputting limits to 
#  txt files.
# -----------------------------------------------------------------------------
echo '-----------------------------------------------------------------------------'
echo 'Step 4: Calculate limits for different signals'
echo '-----------------------------------------------------------------------------'
mv f4mu.root datacards_4mu
mv f4e.root datacards_4e
mv f2e2mu.root datacards_2e2mu
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_MZP600_MA0300.txt  > limits_$1_MZP600.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_MZP800_MA0300.txt  > limits_$1_MZP800.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_MZP1000_MA0300.txt > limits_$1_MZP1000.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_MZP1200_MA0300.txt > limits_$1_MZP1200.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_MZP1400_MA0300.txt > limits_$1_MZP1400.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_MZP1700_MA0300.txt > limits_$1_MZP1700.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_MZP2000_MA0300.txt > limits_$1_MZP2000.txt
combine -M Asymptotic datacards_$1/hhxx_Fall15_card_$1_MZP2500_MA0300.txt > limits_$1_MZP2500.txt


# -----------------------------------------------------------------------------
#  Combine txt files containing limits in order for plotting.
# -----------------------------------------------------------------------------
echo '-----------------------------------------------------------------------------'
echo 'Step 5: Merge txt files in ascending MZP order'
echo '-----------------------------------------------------------------------------'
cat limits_$1_MZP600.txt limits_$1_MZP800.txt limits_$1_MZP1000.txt limits_$1_MZP1200.txt limits_$1_MZP1400.txt limits_$1_MZP1700.txt limits_$1_MZP2000.txt limits_$1_MZP2500.txt > limits_$1_13tev.txt


# -----------------------------------------------------------------------------
#  Parse the limits file for median and +/- 1,2 sigma limits numbers only for plotting.
# -----------------------------------------------------------------------------
echo '-----------------------------------------------------------------------------'
echo 'Step 6: Parse merged txt file to extract limits'
echo '-----------------------------------------------------------------------------'
python format_limits.py $1


# -----------------------------------------------------------------------------
#  Parse the output of Step 6 and create limit plots, properly scaled.
# -----------------------------------------------------------------------------
echo '-----------------------------------------------------------------------------'
echo 'Step 7: Plot limits'
echo '-----------------------------------------------------------------------------'
mkdir -p plots
root -b -q -l "limitPlots_Zp2HDM.C(\"$1\")"
