#!/usr/local/bin/python
# -----------------------------------------------------------------------------
#  File:        gen_cards.py
#  Usage:       python gen_cards.py '4muchannel'
#  Description: Generates data cards used by the combine tool based on the 
#               template cards hhxx_*_Fall15_card_template.txt.
#  Created:     5-July-2016 Dustin Burns
# -----------------------------------------------------------------------------

import subprocess
import os
import math
import sys


# Input yields file
yields = open('yields.txt')


# Run parameters
model = 'MZp' 
datarun = 'Run2016'
channel = sys.argv[1]


# Parse yields.txt to fill label and yields lists
bkg_labels = ''
bkg_labels_array = []
sig_labels = []
dat_labels = []
bkg_yields = ''
bkg_unc = ''
sig_yields = []
sig_unc = []
dat_yields = 0
BKG = 0
BKG_UNC2 = 0
NBKG = 0
for l in yields:
  if 'Yield' in l and channel in l:
    #Name  = l.split('test/')[1].split('.root')[0]
    Name  = l.split('25ns/')[1].split('.root')[0]
    #if 'MZp' not in l: Name  = l.split('25ns/')[1].split('.root')[0]
    #if 'MZp' in l:     Name  = l.split('25ns_BR/')[1].split('.root')[0]
    N     = l.split('Entries: ')[1].split(' Yield:')[0]
    Yield = l.split('Yield: ')[1].split(' Error:')[0]
    Err   = float(l.split('Error: ')[1])
    if model in l:
      sig_labels.append(Name)
      sig_yields.append(Yield)
      if float(Yield) > 0: sig_unc.append(1+Err/float(Yield))
      else: sig_unc.append(0)
    elif datarun in l:
      dat_labels.append(Name)
      dat_yields += float(Yield)
    else:
      bkg_labels += Name + ' '
      bkg_labels_array.append(Name)
      bkg_yields += Yield + ' '
      BKG += float(Yield)
      NBKG += 1
      if float(Yield) > 0: bkg_unc += str(1+Err/float(Yield)) + ' '
      else: bkg_unc += str(0) + ' '
      BKG_UNC2 += Err*Err
#print sig_labels
# Print total signal and background yields and uncertainties
print 'Channel ' + channel.split('channel')[0]
#print 'SIG 600: ' + str(sig_yields[6]) + ' +/- ' + str((float(sig_unc[6])-1)*float(sig_yields[6]))
#print 'SIG 800: ' + str(sig_yields[7]) + ' +/- ' + str((float(sig_unc[7])-1)*float(sig_yields[7]))
for i, n in enumerate(sig_labels): print str(i) + ' ' + n + ' ' + str(sig_yields[i])
#print 'SIG Baryonic: ' + str(sig_yields[0])# + ' +/- ' + str((float(sig_unc[0])-1)*float(sig_yields[0]))
#print 'SIG 2HDM: ' + str(sig_yields[1])# + ' +/- ' + str((float(sig_unc[1])-1)*float(sig_yields[1]))
#print 'SIG 1400: ' + str(sig_yields[2]) + ' +/- ' + str((float(sig_unc[2])-1)*float(sig_yields[2]))
#print 'SIG 1700: ' + str(sig_yields[3]) + ' +/- ' + str((float(sig_unc[3])-1)*float(sig_yields[3]))
#print 'SIG 2000: ' + str(sig_yields[4]) + ' +/- ' + str((float(sig_unc[4])-1)*float(sig_yields[4]))
#print 'SIG 2500: ' + str(sig_yields[5]) + ' +/- ' + str((float(sig_unc[5])-1)*float(sig_yields[5]))
print 'BKG: ' + str(BKG)# + '+/-' + str(math.sqrt(BKG_UNC2))
print 'Data: ' + str(dat_yields)

# Generate cards for different signals, adding systematics to relevant samples
for i in range(0, len(sig_labels)):
  #print 'Model ' + sig_labels[i] + ': ' + "S=" + sig_yields[i] + ', ' + 'B=' + str(BKG) + ', ' + 'S/sqrt(B)=' + str(float(sig_yields[i])/math.sqrt(BKG))
  cardin = open('hhxx_' + channel.split('channel')[0] + '_' + 'Fall15_card_template.txt')
  cardout = open('datacards_' + channel.split('channel')[0] + '/hhxx_Fall15_card_' + channel.split('channel')[0] + sig_labels[i].split('output')[1] + '.txt','w')
  for line in cardin:
    if 'NBKG' in line:
      line = 'jmax ' + str(NBKG) + ' number of backgrounds \n'
    if 'BIN' in line:
      line = 'bin ' + 'bin'+channel.split('channel')[0] + '\n'
    if 'OBS' in line:
      line = 'observation ' + str(dat_yields) + '\n'
    if 'CHANNELS' in line:
      line = 'bin ' 
      for j in range(0, NBKG+1): line += 'bin'+channel.split('channel')[0]+' '
      line += '\n'
    if 'BKGLABELS' in line:
      line = 'process ' + sig_labels[i] + ' ' + bkg_labels + '\n'
    if 'INTS' in line:
      line = 'process '
      for j in range(0, NBKG+1): line += str(j) + ' '
      line += '\n'
    if 'YIELDS' in line:
      #if '2500' in sig_labels[i] or '2000' in sig_labels[i]:
      #  line = 'rate ' + str(10*float(sig_yields[i])) + ' ' + bkg_yields + '\n'
      #else:
        line = 'rate ' + sig_yields[i] + ' ' + bkg_yields + '\n'
    if 'lumi_13TeV' in line:
      sys = line.split()[-1]
      line = 'lumi_13TeV lnN '
      for j in range(0, NBKG+1): line += sys + ' '
      line += '\n'
    if 'CMS_trig' in line:
      sys = line.split()[-1]
      line = 'CMS_trig lnN '
      for j in range(0, NBKG+1): line += sys + ' '
      line += '\n'
    if 'CMS_eff_m' in line and (channel == '4muchannel' or channel == '4echannel'):
      line = 'CMS_eff_m lnN '
      for j in range(0, NBKG+1): line += '1.04 '
      line += '\n'
    if 'CMS_eff_m' in line and channel == '2e2muchannel':
      line = 'CMS_eff_m lnN '
      for j in range(0, NBKG+1): line += '1.02 '
      line += '\n'
    if 'CMS_eff_e' in line and (channel == '4muchannel' or channel == '4echannel'):
      line = 'CMS_eff_e lnN '
      for j in range(0, NBKG+1): line += '1.088 '
      line += '\n'
    if 'CMS_eff_e' in line and channel == '2e2muchannel':
      line = 'CMS_eff_e lnN '
      for j in range(0, NBKG+1): line += '1.059 '
      line += '\n'
    if 'JES' in line:
      line = 'JES lnN '
      for j in range(0, NBKG+1): line += '0.998 '
      line += '\n'
    if 'Sig' in line:
      line = 'sig_unc lnN ' + str(sig_unc[i]) + ' '
      for j in range(0, NBKG): line += '- '
      line += '\n'
    if 'UNC' in line:
      line = 'bkg_unc lnN - ' + bkg_unc + '\n'
    if 'QCDscale_qqH' in line:
      line = 'QCDscale_qqH lnN - '
      for j in range(0, NBKG):
        if 'VBF' in bkg_labels_array[j]: line += '0.997/1.004 '
        else: line += '- '
      line += '\n'
    if 'QCDscale_ggZH' in line:
      line = 'QCDscale_ggZH lnN - '
      for j in range(0, NBKG):
        if 'ZH' in bkg_labels_array[j]: line += '0.970/1.038 '
        else: line += '- '
      line += '\n'
    if 'QCDscale_ttH' in line:
      line = 'QCDscale_ttH lnN - '
      for j in range(0, NBKG):
        if 'ttH' in bkg_labels_array[j]: line += '0.908/1.058 '
        else: line += '- '
      line += '\n'
    if 'QCDscale_ggVV' in line:
      line = 'QCDscale_ggVV lnN - '
      for j in range(0, NBKG):
        if 'GluGluToZZ' in bkg_labels_array[j]: line += '1.08 '
        else: line += '- '
      line += '\n'
    if 'QCDscale_ggH' in line:
      line = 'QCDscale_ggH lnN - '
      for j in range(0, NBKG):
        if 'GluGluH' in bkg_labels_array[j]: line += '0.919/1.076 '
        else: line += '- '
      line += '\n'
    if 'QCDscale_ggH2in_vbf' in line:
      line = 'QCDscale_ggH lnN - '
      for j in range(0, NBKG):
        if 'GluGlu' in bkg_labels_array[j]: line += '0.996 '
        else: line += '- '
      line += '\n'
    if 'QCDscale_VV' in line:
      line = 'QCDscale_VV lnN - '
      for j in range(0, NBKG):
        if 'ZZTo4L' in bkg_labels_array[j]: line += '1.0285 '
        else: line += '- '
      line += '\n'
    if 'QCDscale_qqZZ2in_vbf' in line:
      line = 'QCDscale_qqZZ2in_vbf lnN - '
      for j in range(0, NBKG):
        if 'ZZTo4L' in bkg_labels_array[j]: line += '0.994 '
        else: line += '- '
      line += '\n'
    if 'QCDscale_VH' in line:
      line = 'QCDscale_VH lnN - '
      for j in range(0, NBKG):
        if 'ZH' in bkg_labels_array[j] or 'WplusH' in bkg_labels_array[j] or 'WminusH' in bkg_labels_array[j]: line += '0.993/1.005 '
        else: line += '- '
      line += '\n'
    if 'pdf_qq' in line:
      line = 'pdf_qq lnN - '
      for j in range(0, NBKG):
        if 'ZZTo4L' in bkg_labels_array[j]: line += '1.034 '
        else: line += '- '
      line += '\n'
    if 'pdf_Higgs_ttH' in line:
      line = 'pdf_Higgs_ttH lnN - '
      for j in range(0, NBKG):
        if 'ttH' in bkg_labels_array[j]: line += '1.036 '
        else: line += '- '
      line += '\n'
    if 'pdf_Higgs_qq' in line:
      line = 'pdf_Higgs_qq lnN - '
      for j in range(0, NBKG):
        if 'VBF_HToZZ' in bkg_labels_array[j] or 'ZH' in bkg_labels_array[j] or 'WplusH' in bkg_labels_array[j] or 'WminusH' in bkg_labels_array[j]: line += '1.021 '
        else: line += '- '
      line += '\n'
    if 'pdf_Higgs_gg' in line:
      line = 'pdf_Higgs_gg lnN - '
      for j in range(0, NBKG):
        if 'GluGluH' in bkg_labels_array[j]: line += '1.031 '
        else: line += '- '
      line += '\n'
    if 'BRhiggs' in line:
      line = 'BRhiggs_hzz4l lnN - '
      for j in range(0, NBKG):
        if 'VBF_HToZZ' in bkg_labels_array[j] or 'ZH' in bkg_labels_array[j] or 'WplusH' in bkg_labels_array[j] or 'WminusH' in bkg_labels_array[j] or 'ttH' in bkg_labels_array[j] or 'GluGluH' in bkg_labels_array[j]: line += '1.02 '
        else: line += '- '
      line += '\n'
    if 'CMS_zz4l_ttH_vbf' in line:
      line = 'CMS_zz4l_ttH_vbf lnN - '
      for j in range(0, NBKG):
        if 'ttH' in bkg_labels_array[j]: line += '0.996 '
        else: line += '- '
      line += '\n'
    if 'CMS_zz4l_qqHVH_vbf' in line:
      line = 'CMS_zz4l_qqHVH_vbf lnN - '
      for j in range(0, NBKG):
        if 'VBF_HToZZ' in bkg_labels_array[j] or 'ZH' in bkg_labels_array[j] or 'WplusH' in bkg_labels_array[j] or 'WminusH' in bkg_labels_array[j]: line += '0.999 '
        else: line += '- '
      line += '\n'
    cardout.write(line)
  cardin.close()
  cardout.close()

