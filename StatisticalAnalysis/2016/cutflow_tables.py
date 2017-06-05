#!/usr/bin/env python
#!/usr/bin/env python
# -----------------------------------------------------------------------------
#  File:        cutflow_tables.py.py
#  Usage:       python cutflow_tables.py
#  Description: Generate cut flow tables for 4mu, 4e, 2e2mu channels
#  Created:     19-Dec-2016 Dustin Burns
# -----------------------------------------------------------------------------

from ROOT import *
import numpy as np
import math
import argparse

# Read in counter histograms from input files
def get_data(flist):   
  Obs    = [0]*26
  qqZZ   = [0]*26
  ggZZ   = [0]*26
  ZH     = [0]*26
  ZX     = [0]*26
  Hsig   = [0]*26
  sig600 = [0]*26
  for f in flist:
    ft = TFile.Open(f)
    h = ft.Get("nEvent_4l_w")
    if   'Run2016'    in f:
       for i in range(1, 26): Obs[i]    += h.GetBinContent(i)
    elif 'GluGluToZZ' in f: 
       for i in range(1, 26): ggZZ[i]   += h.GetBinContent(i)
    elif '_ZZTo4L_'   in f: 
       for i in range(1, 26): qqZZ[i]   += h.GetBinContent(i)
    elif 'ZH'         in f: 
       for i in range(1, 26): ZH[i]     += h.GetBinContent(i)
    elif 'M125'       in f and 'ZH' not in f: 
       for i in range(1, 26): Hsig[i]   += h.GetBinContent(i)
    elif 'MZp-600'     in f: 
       for i in range(1, 26): sig600[i] += h.GetBinContent(i)
    else:                  
       for i in range(1, 26): ZX[i]     += h.GetBinContent(i)
    ft.Close()
  return (Obs, qqZZ, ggZZ, ZH, ZX, Hsig, sig600)


if __name__ == "__main__":

  # Read in input files
  #flist4e = map(lambda x: x.split()[-1], open('filelist_4e_2016_Spring16_AN_lxplus.txt').readlines())
  flist4mu = map(lambda x: x.split()[-1], open('filelist_4mu_2016_Spring16_AN_Bari_Giorgia_v2.txt').readlines()) 
  #flist2e2mu = map(lambda x: x.split()[-1], open('filelist_2e2mu_2016_Spring16_AN_lxplus.txt').readlines())

  # Get counters for decay channels
  #Obs4e, qqZZ4e, ggZZ4e, ZH4e, ZX4e, Hsig4e, sig6004e                      = get_data(flist4e)
  Obs4mu, qqZZ4mu, ggZZ4mu, ZH4mu, ZX4mu, Hsig4mu, sig6004mu               = get_data(flist4mu)
  #Obs2e2mu, qqZZ2e2mu, ggZZ2e2mu, ZH2e2mu, ZX2e2mu, Hsig2e2mu, sig6002e2mu = get_data(flist2e2mu)
  #bkg4e    = [qqZZ4e[i] + ggZZ4e[i] + ZX4e[i] + ZH4e[i] + Hsig4e[i] for i in xrange(26)]
  bkg4mu   = [qqZZ4mu[i] + ggZZ4mu[i] + ZX4mu[i] + ZH4mu[i] + Hsig4mu[i] for i in xrange(26)]
  #bkg2e2mu = [qqZZ2e2mu[i] + ggZZ2e2mu[i] + ZX2e2mu[i] + ZH2e2mu[i] + Hsig2e2mu[i] for i in xrange(26)]
  #exp4e    = [qqZZ4e[i] + ggZZ4e[i] + ZX4e[i] + ZH4e[i] + Hsig4e[i] + sig6004e[i] for i in xrange(26)]
  exp4mu   = [qqZZ4mu[i] + ggZZ4mu[i] + ZX4mu[i] + ZH4mu[i] + Hsig4mu[i] + sig6004mu[i] for i in xrange(26)]
  #exp2e2mu = [qqZZ2e2mu[i] + ggZZ2e2mu[i] + ZX2e2mu[i] + ZH2e2mu[i] + Hsig2e2mu[i] + sig6002e2mu[i] for i in xrange(26)]
  
  # print out total data and bkg
  #print 'Total data initial: ' + str(Obs4e[4] + Obs4mu[4] + Obs2e2mu[4])
  #print 'Total bkg  initial: ' + str(bkg4e[4] + bkg4mu[4] + bkg2e2mu[4])
  '''
  # Fill in template latex table with yields
  cardin = open('yields_table_temp.txt')
  cardout = open('yields_table.txt','w')
  step = 15
  for l in cardin:
    if 'q\\bar{q}' in l:
      l = '$q\\bar{q} \\rightarrow ZZ$ & ' + str('%.3g'%qqZZ4e[step]) + ' & ' + str('%.3g'%qqZZ4mu[step]) + ' & ' + str('%.3g'%qqZZ2e2mu[step]) + ' & ' + str('%.3g'%(qqZZ4e[step]+qqZZ4mu[step]+qqZZ2e2mu[step])) + ' \\\\ \n'
    if 'gg \\rightarrow ZZ' in l:
      l = '$gg \\rightarrow ZZ$ & ' + str('%.3g'%ggZZ4e[step]) + ' & ' + str('%.3g'%ggZZ4mu[step]) + ' & ' + str('%.3g'%ggZZ2e2mu[step]) + ' & ' + str('%.3g'%(ggZZ4e[step]+ggZZ4mu[step]+ggZZ2e2mu[step])) + ' \\\\ \n'
    if 'Z+X' in l:
      l = '$Z+X$ & ' + str('%.3g'%ZX4e[step]) + ' & ' + str('%.3g'%ZX4mu[step]) + ' & ' + str('%.3g'%ZX2e2mu[step]) + ' & ' + str('%.3g'%(ZX4e[step]+ZX4mu[step]+ZX2e2mu[step])) + ' \\\\ \n'
    if 'ZH' in l:
      l = '$ZH$ & ' + str('%.3g'%ZH4e[step]) + ' & ' + str('%.3g'%ZH4mu[step]) + ' & ' + str('%.3g'%ZH2e2mu[step]) + ' & ' + str('%.3g'%(ZH4e[step]+ZH4mu[step]+ZH2e2mu[step])) + ' \\\\ \n'
    if 'Other' in l:
      l = 'Other Higgs & ' + str('%.3g'%Hsig4e[step]) + ' & ' + str('%.3g'%Hsig4mu[step]) + ' & ' + str('%.3g'%Hsig2e2mu[step]) + ' & ' + str('%.3g'%(Hsig4e[step]+Hsig4mu[step]+Hsig2e2mu[step])) + ' \\\\ \n'
    if 'Total background' in l:
      l = 'Total background & ' + str('%.3g'%bkg4e[step]) + ' & ' + str('%.3g'%bkg4mu[step]) + ' & ' + str('%.3g'%bkg2e2mu[step]) + ' & ' + str('%.3g'%(bkg4e[step]+bkg4mu[step]+bkg2e2mu[step])) + ' \\\\ \n'
    if 'Signal' in l:
      l = 'Signal ($m_\chi=600$ GeV) & ' + str('%.3g'%sig6004e[step]) + ' & ' + str('%.3g'%sig6004mu[step]) + ' & ' + str('%.3g'%sig6002e2mu[step]) + ' & ' + str('%.3g'%(sig6004e[step]+sig6004mu[step]+sig6002e2mu[step])) + ' \\\\ \n'
    if 'Total expected' in l:
      l = 'Total expected & ' + str('%.3g'%exp4e[step]) + ' & ' + str('%.3g'%exp4mu[step]) + ' & ' + str('%.3g'%exp2e2mu[step]) + ' & ' + str('%.3g'%(exp4e[step]+exp4mu[step]+exp2e2mu[step])) + ' \\\\ \n'
    if 'Observed' in l:
      l = 'Observed & ' + str('%.0f'%Obs4e[step]) + ' & ' + str('%.0f'%Obs4mu[step]) + ' & ' + str('%.0f'%Obs2e2mu[step]) + ' & ' + str('%.0f'%(Obs4e[step]+Obs4mu[step]+Obs2e2mu[step])) + ' \\\\ \n'
    cardout.write(l)
  cardin.close()
  cardout.close()

  # Fill in template latex table with yields
  cardin = open('cutflow_tmp.txt')
  cardout = open('cutflow_table_4e.txt','w')
  for l in cardin:
    if 'Initial' in l:
      l = 'Initial & ' + str('%.3g'%qqZZ4e[4]) + ' & ' + str('%.3g'%ggZZ4e[4]) + ' & ' + str('%.3g'%ZX4e[4]) + ' & ' + str('%.3g'%ZH4e[4]) + ' & ' + str('%.3g'%Hsig4e[4]) + ' & ' + str('%.3g'%bkg4e[4]) + ' & ' + str('%.3g'%sig6004e[4]) + ' & ' + str('%.3g'%Obs4e[4]) + ' \\\\ \n' 
    if 'HLT' in l:
      l = 'HLT & ' + str('%.3g'%qqZZ4e[5]) + ' & ' + str('%.3g'%ggZZ4e[5]) + ' & ' + str('%.3g'%ZX4e[5]) + ' & ' + str('%.3g'%ZH4e[5]) + ' & ' + str('%.3g'%Hsig4e[5]) + ' & ' + str('%.3g'%bkg4e[5]) + ' & ' + str('%.3g'%sig6004e[5]) + ' & ' + str('%.3g'%Obs4e[5]) + ' \\\\ \n' 
    if '$Z_1$ lepton cuts' in l:
      l = '$Z_1$ lepton cuts & ' + str('%.3g'%qqZZ4e[6]) + ' & ' + str('%.3g'%ggZZ4e[6]) + ' & ' + str('%.3g'%ZX4e[6]) + ' & ' + str('%.3g'%ZH4e[6]) + ' & ' + str('%.3g'%Hsig4e[6]) + ' & ' + str('%.3g'%bkg4e[6]) + ' & ' + str('%.3g'%sig6004e[6]) + ' & ' + str('%.3g'%Obs4e[6]) + ' \\\\ \n' 
    if '$m_{Z_1}$' in l:
      l = '$m_{Z_1}$ & ' + str('%.3g'%qqZZ4e[8]) + ' & ' + str('%.3g'%ggZZ4e[8]) + ' & ' + str('%.3g'%ZX4e[8]) + ' & ' + str('%.3g'%ZH4e[8]) + ' & ' + str('%.3g'%Hsig4e[8]) + ' & ' + str('%.3g'%bkg4e[8]) + ' & ' + str('%.3g'%sig6004e[8]) + ' & ' + str('%.3g'%Obs4e[8]) + ' \\\\ \n' 
    if 'At least one $Z_2$' in l:
      l = 'At least one $Z_2$ & ' + str('%.3g'%qqZZ4e[10]) + ' & ' + str('%.3g'%ggZZ4e[10]) + ' & ' + str('%.3g'%ZX4e[10]) + ' & ' + str('%.3g'%ZH4e[10]) + ' & ' + str('%.3g'%Hsig4e[10]) + ' & ' + str('%.3g'%bkg4e[10]) + ' & ' + str('%.3g'%sig6004e[10]) + ' & ' + str('%.3g'%Obs4e[10]) + ' \\\\ \n' 
    if '$m_{Z_2}$' in l:
      l = '$m_{Z_2}$ & ' + str('%.3g'%qqZZ4e[12]) + ' & ' + str('%.3g'%ggZZ4e[12]) + ' & ' + str('%.3g'%ZX4e[12]) + ' & ' + str('%.3g'%ZH4e[12]) + ' & ' + str('%.3g'%Hsig4e[12]) + ' & ' + str('%.3g'%bkg4e[12]) + ' & ' + str('%.3g'%sig6004e[12]) + ' & ' + str('%.3g'%Obs4e[12]) + ' \\\\ \n' 
    if '$m_{ll}>4$ for OS-SF' in l:
      l = '$m_{ll}>4$ for OS-SF & ' + str('%.3g'%qqZZ4e[14]) + ' & ' + str('%.3g'%ggZZ4e[14]) + ' & ' + str('%.3g'%ZX4e[14]) + ' & ' + str('%.3g'%ZH4e[14]) + ' & ' + str('%.3g'%Hsig4e[14]) + ' & ' + str('%.3g'%bkg4e[14]) + ' & ' + str('%.3g'%sig6004e[14]) + ' & ' + str('%.3g'%Obs4e[14]) + ' \\\\ \n' 
    if '$m_{llll} > 70$ GeV' in l:
      l = '$m_{llll} > 70$ GeV & ' + str('%.3g'%qqZZ4e[15]) + ' & ' + str('%.3g'%ggZZ4e[15]) + ' & ' + str('%.3g'%ZX4e[15]) + ' & ' + str('%.3g'%ZH4e[15]) + ' & ' + str('%.3g'%Hsig4e[15]) + ' & ' + str('%.3g'%bkg4e[15]) + ' & ' + str('%.3g'%sig6004e[15]) + ' & ' + str('%.3g'%Obs4e[15]) + ' \\\\ \n' 
    if '$m_{Z2} > 12$ GeV' in l:
      l = '$m_{Z2} > 12$ GeV & ' + str('%.3g'%qqZZ4e[16]) + ' & ' + str('%.3g'%ggZZ4e[16]) + ' & ' + str('%.3g'%ZX4e[16]) + ' & ' + str('%.3g'%ZH4e[16]) + ' & ' + str('%.3g'%Hsig4e[16]) + ' & ' + str('%.3g'%bkg4e[16]) + ' & ' + str('%.3g'%sig6004e[16]) + ' & ' + str('%.3g'%Obs4e[16]) + ' \\\\ \n' 
    if '$MELA KD > 0.1$' in l:
      l = '$MELA KD > 0.1$ & ' + str('%.3g'%qqZZ4e[18]) + ' & ' + str('%.3g'%ggZZ4e[18]) + ' & ' + str('%.3g'%ZX4e[18]) + ' & ' + str('%.3g'%ZH4e[18]) + ' & ' + str('%.3g'%Hsig4e[18]) + ' & ' + str('%.3g'%bkg4e[18]) + ' & ' + str('%.3g'%sig6004e[18]) + ' & ' + str('%.3g'%Obs4e[18]) + ' \\\\ \n' 
    cardout.write(l)
  cardin.close()
  cardout.close()
  ''' 
  # Fill in template latex table with yields
  cardin = open('cutflow_tmp.txt')
  cardout = open('cutflow_table_4mu.txt','w')
  for l in cardin:
    if 'Initial' in l:
      l = 'Initial & ' + str('%.3g'%qqZZ4mu[4]) + ' & ' + str('%.3g'%ggZZ4mu[4]) + ' & ' + str('%.3g'%ZX4mu[4]) + ' & ' + str('%.3g'%ZH4mu[4]) + ' & ' + str('%.3g'%Hsig4mu[4]) + ' & ' + str('%.3g'%bkg4mu[4]) + ' & ' + str('%.3g'%sig6004mu[4]) + ' & ' + str('%.3g'%Obs4mu[4]) + ' \\\\ \n' 
    if 'HLT' in l:
      l = 'HLT & ' + str('%.3g'%qqZZ4mu[5]) + ' & ' + str('%.3g'%ggZZ4mu[5]) + ' & ' + str('%.3g'%ZX4mu[5]) + ' & ' + str('%.3g'%ZH4mu[5]) + ' & ' + str('%.3g'%Hsig4mu[5]) + ' & ' + str('%.3g'%bkg4mu[5]) + ' & ' + str('%.3g'%sig6004mu[5]) + ' & ' + str('%.3g'%Obs4mu[5]) + ' \\\\ \n' 
    if '$Z_1$ lepton cuts' in l:
      l = '$Z_1$ lepton cuts & ' + str('%.3g'%qqZZ4mu[6]) + ' & ' + str('%.3g'%ggZZ4mu[6]) + ' & ' + str('%.3g'%ZX4mu[6]) + ' & ' + str('%.3g'%ZH4mu[6]) + ' & ' + str('%.3g'%Hsig4mu[6]) + ' & ' + str('%.3g'%bkg4mu[6]) + ' & ' + str('%.3g'%sig6004mu[6]) + ' & ' + str('%.3g'%Obs4mu[6]) + ' \\\\ \n' 
    if '$m_{Z_1}$' in l:
      l = '$m_{Z_1}$ & ' + str('%.3g'%qqZZ4mu[8]) + ' & ' + str('%.3g'%ggZZ4mu[8]) + ' & ' + str('%.3g'%ZX4mu[8]) + ' & ' + str('%.3g'%ZH4mu[8]) + ' & ' + str('%.3g'%Hsig4mu[8]) + ' & ' + str('%.3g'%bkg4mu[8]) + ' & ' + str('%.3g'%sig6004mu[8]) + ' & ' + str('%.3g'%Obs4mu[8]) + ' \\\\ \n' 
    if 'At least one $Z_2$' in l:
      l = 'At least one $Z_2$ & ' + str('%.3g'%qqZZ4mu[10]) + ' & ' + str('%.3g'%ggZZ4mu[10]) + ' & ' + str('%.3g'%ZX4mu[10]) + ' & ' + str('%.3g'%ZH4mu[10]) + ' & ' + str('%.3g'%Hsig4mu[10]) + ' & ' + str('%.3g'%bkg4mu[10]) + ' & ' + str('%.3g'%sig6004mu[10]) + ' & ' + str('%.3g'%Obs4mu[10]) + ' \\\\ \n' 
    if '$m_{Z_2}$' in l:
      l = '$m_{Z_2}$ & ' + str('%.3g'%qqZZ4mu[12]) + ' & ' + str('%.3g'%ggZZ4mu[12]) + ' & ' + str('%.3g'%ZX4mu[12]) + ' & ' + str('%.3g'%ZH4mu[12]) + ' & ' + str('%.3g'%Hsig4mu[12]) + ' & ' + str('%.3g'%bkg4mu[12]) + ' & ' + str('%.3g'%sig6004mu[12]) + ' & ' + str('%.3g'%Obs4mu[12]) + ' \\\\ \n' 
    if '$m_{ll}>4$ for OS-SF' in l:
      l = '$m_{ll}>4$ for OS-SF & ' + str('%.3g'%qqZZ4mu[14]) + ' & ' + str('%.3g'%ggZZ4mu[14]) + ' & ' + str('%.3g'%ZX4mu[14]) + ' & ' + str('%.3g'%ZH4mu[14]) + ' & ' + str('%.3g'%Hsig4mu[14]) + ' & ' + str('%.3g'%bkg4mu[14]) + ' & ' + str('%.3g'%sig6004mu[14]) + ' & ' + str('%.3g'%Obs4mu[14]) + ' \\\\ \n' 
    if '$m_{llll} > 70$ GeV' in l:
      l = '$m_{llll} > 70$ GeV & ' + str('%.3g'%qqZZ4mu[15]) + ' & ' + str('%.3g'%ggZZ4mu[15]) + ' & ' + str('%.3g'%ZX4mu[15]) + ' & ' + str('%.3g'%ZH4mu[15]) + ' & ' + str('%.3g'%Hsig4mu[15]) + ' & ' + str('%.3g'%bkg4mu[15]) + ' & ' + str('%.3g'%sig6004mu[15]) + ' & ' + str('%.3g'%Obs4mu[15]) + ' \\\\ \n' 
    if '$m_{Z2} > 12$ GeV' in l:
      l = '$m_{Z2} > 12$ GeV & ' + str('%.3g'%qqZZ4mu[16]) + ' & ' + str('%.3g'%ggZZ4mu[16]) + ' & ' + str('%.3g'%ZX4mu[16]) + ' & ' + str('%.3g'%ZH4mu[16]) + ' & ' + str('%.3g'%Hsig4mu[16]) + ' & ' + str('%.3g'%bkg4mu[16]) + ' & ' + str('%.3g'%sig6004mu[16]) + ' & ' + str('%.3g'%Obs4mu[16]) + ' \\\\ \n' 
    if '$MELA KD > 0.1$' in l:
      l = '$MELA KD > 0.1$ & ' + str('%.3g'%qqZZ4mu[18]) + ' & ' + str('%.3g'%ggZZ4mu[18]) + ' & ' + str('%.3g'%ZX4mu[18]) + ' & ' + str('%.3g'%ZH4mu[18]) + ' & ' + str('%.3g'%Hsig4mu[18]) + ' & ' + str('%.3g'%bkg4mu[18]) + ' & ' + str('%.3g'%sig6004mu[18]) + ' & ' + str('%.3g'%Obs4mu[18]) + ' \\\\ \n' 
    cardout.write(l)
  cardin.close()
  cardout.close()
  '''
  # Fill in template latex table with yields
  cardin = open('cutflow_tmp.txt')
  cardout = open('cutflow_table_2e2mu.txt','w')
  for l in cardin:
    if 'Initial' in l:
      l = 'Initial & ' + str('%.3g'%qqZZ2e2mu[4]) + ' & ' + str('%.3g'%ggZZ2e2mu[4]) + ' & ' + str('%.3g'%ZX2e2mu[4]) + ' & ' + str('%.3g'%ZH2e2mu[4]) + ' & ' + str('%.3g'%Hsig2e2mu[4]) + ' & ' + str('%.3g'%bkg2e2mu[4]) + ' & ' + str('%.3g'%sig6002e2mu[4]) + ' & ' + str('%.3g'%Obs2e2mu[4]) + ' \\\\ \n' 
    if 'HLT' in l:
      l = 'HLT & ' + str('%.3g'%qqZZ2e2mu[5]) + ' & ' + str('%.3g'%ggZZ2e2mu[5]) + ' & ' + str('%.3g'%ZX2e2mu[5]) + ' & ' + str('%.3g'%ZH2e2mu[5]) + ' & ' + str('%.3g'%Hsig2e2mu[5]) + ' & ' + str('%.3g'%bkg2e2mu[5]) + ' & ' + str('%.3g'%sig6002e2mu[5]) + ' & ' + str('%.3g'%Obs2e2mu[5]) + ' \\\\ \n' 
    if '$Z_1$ lepton cuts' in l:
      l = '$Z_1$ lepton cuts & ' + str('%.3g'%qqZZ2e2mu[6]) + ' & ' + str('%.3g'%ggZZ2e2mu[6]) + ' & ' + str('%.3g'%ZX2e2mu[6]) + ' & ' + str('%.3g'%ZH2e2mu[6]) + ' & ' + str('%.3g'%Hsig2e2mu[6]) + ' & ' + str('%.3g'%bkg2e2mu[6]) + ' & ' + str('%.3g'%sig6002e2mu[6]) + ' & ' + str('%.3g'%Obs2e2mu[6]) + ' \\\\ \n' 
    if '$m_{Z_1}$' in l:
      l = '$m_{Z_1}$ & ' + str('%.3g'%qqZZ2e2mu[8]) + ' & ' + str('%.3g'%ggZZ2e2mu[8]) + ' & ' + str('%.3g'%ZX2e2mu[8]) + ' & ' + str('%.3g'%ZH2e2mu[8]) + ' & ' + str('%.3g'%Hsig2e2mu[8]) + ' & ' + str('%.3g'%bkg2e2mu[8]) + ' & ' + str('%.3g'%sig6002e2mu[8]) + ' & ' + str('%.3g'%Obs2e2mu[8]) + ' \\\\ \n' 
    if 'At least one $Z_2$' in l:
      l = 'At least one $Z_2$ & ' + str('%.3g'%qqZZ2e2mu[10]) + ' & ' + str('%.3g'%ggZZ2e2mu[10]) + ' & ' + str('%.3g'%ZX2e2mu[10]) + ' & ' + str('%.3g'%ZH2e2mu[10]) + ' & ' + str('%.3g'%Hsig2e2mu[10]) + ' & ' + str('%.3g'%bkg2e2mu[10]) + ' & ' + str('%.3g'%sig6002e2mu[10]) + ' & ' + str('%.3g'%Obs2e2mu[10]) + ' \\\\ \n' 
    if '$m_{Z_2}$' in l:
      l = '$m_{Z_2}$ & ' + str('%.3g'%qqZZ2e2mu[12]) + ' & ' + str('%.3g'%ggZZ2e2mu[12]) + ' & ' + str('%.3g'%ZX2e2mu[12]) + ' & ' + str('%.3g'%ZH2e2mu[12]) + ' & ' + str('%.3g'%Hsig2e2mu[12]) + ' & ' + str('%.3g'%bkg2e2mu[12]) + ' & ' + str('%.3g'%sig6002e2mu[12]) + ' & ' + str('%.3g'%Obs2e2mu[12]) + ' \\\\ \n' 
    if '$m_{ll}>4$ for OS-SF' in l:
      l = '$m_{ll}>4$ for OS-SF & ' + str('%.3g'%qqZZ2e2mu[14]) + ' & ' + str('%.3g'%ggZZ2e2mu[14]) + ' & ' + str('%.3g'%ZX2e2mu[14]) + ' & ' + str('%.3g'%ZH2e2mu[14]) + ' & ' + str('%.3g'%Hsig2e2mu[14]) + ' & ' + str('%.3g'%bkg2e2mu[14]) + ' & ' + str('%.3g'%sig6002e2mu[14]) + ' & ' + str('%.3g'%Obs2e2mu[14]) + ' \\\\ \n' 
    if '$m_{llll} > 70$ GeV' in l:
      l = '$m_{llll} > 70$ GeV & ' + str('%.3g'%qqZZ2e2mu[15]) + ' & ' + str('%.3g'%ggZZ2e2mu[15]) + ' & ' + str('%.3g'%ZX2e2mu[15]) + ' & ' + str('%.3g'%ZH2e2mu[15]) + ' & ' + str('%.3g'%Hsig2e2mu[15]) + ' & ' + str('%.3g'%bkg2e2mu[15]) + ' & ' + str('%.3g'%sig6002e2mu[15]) + ' & ' + str('%.3g'%Obs2e2mu[15]) + ' \\\\ \n' 
    if '$m_{Z2} > 12$ GeV' in l:
      l = '$m_{Z2} > 12$ GeV & ' + str('%.3g'%qqZZ2e2mu[16]) + ' & ' + str('%.3g'%ggZZ2e2mu[16]) + ' & ' + str('%.3g'%ZX2e2mu[16]) + ' & ' + str('%.3g'%ZH2e2mu[16]) + ' & ' + str('%.3g'%Hsig2e2mu[16]) + ' & ' + str('%.3g'%bkg2e2mu[16]) + ' & ' + str('%.3g'%sig6002e2mu[16]) + ' & ' + str('%.3g'%Obs2e2mu[16]) + ' \\\\ \n' 
    if '$MELA KD > 0.1$' in l:
      l = '$MELA KD > 0.1$ & ' + str('%.3g'%qqZZ2e2mu[18]) + ' & ' + str('%.3g'%ggZZ2e2mu[18]) + ' & ' + str('%.3g'%ZX2e2mu[18]) + ' & ' + str('%.3g'%ZH2e2mu[18]) + ' & ' + str('%.3g'%Hsig2e2mu[18]) + ' & ' + str('%.3g'%bkg2e2mu[18]) + ' & ' + str('%.3g'%sig6002e2mu[18]) + ' & ' + str('%.3g'%Obs2e2mu[18]) + ' \\\\ \n' 
    cardout.write(l)
  cardin.close()
  cardout.close()
'''
# Counter histogram number mapping
'''
4, 5, 6, 8, 10, 12, 14, 15, 16, 18
  nEvent_4l_w->GetXaxis()->SetBinLabel(1,"Init.");
   nEvent_4l_w->GetXaxis()->SetBinLabel(2,"MCTruth: 4mu");
   nEvent_4l_w->GetXaxis()->SetBinLabel(3,"MCTruth: Acc");
   nEvent_4l_w->GetXaxis()->SetBinLabel(4,"Init");
   nEvent_4l_w->GetXaxis()->SetBinLabel(5,"HLT");
   nEvent_4l_w->GetXaxis()->SetBinLabel(6,"Z1 lept. cuts");
   nEvent_4l_w->GetXaxis()->SetBinLabel(7,"Z1+#gamma");
   nEvent_4l_w->GetXaxis()->SetBinLabel(8,"m_{Z1}");
   nEvent_4l_w->GetXaxis()->SetBinLabel(9,"4#mu");
   nEvent_4l_w->GetXaxis()->SetBinLabel(10,"at least one Z2");
   nEvent_4l_w->GetXaxis()->SetBinLabel(11,"Z2 lept. cuts");
   nEvent_4l_w->GetXaxis()->SetBinLabel(12,"m_{Z2}");
   nEvent_4l_w->GetXaxis()->SetBinLabel(13,"pT cuts");
   nEvent_4l_w->GetXaxis()->SetBinLabel(14,"mll>4 for OS-SF");
   nEvent_4l_w->GetXaxis()->SetBinLabel(15,"m4l > 70");
   nEvent_4l_w->GetXaxis()->SetBinLabel(16,"m_{Z2} > 12");
   nEvent_4l_w->GetXaxis()->SetBinLabel(17,"m4l > 100");
   nEvent_4l_w->GetXaxis()->SetBinLabel(18,"MELA KD > 0.1");
   nEvent_4l_w->GetXaxis()->SetBinLabel(19,"one Z+#gamma");
   nEvent_4l_w->GetXaxis()->SetBinLabel(20,"two Z+#gamma");
   nEvent_4l_w->GetXaxis()->SetBinLabel(21,"PFMET > 150");
   nEvent_4l_w->GetXaxis()->SetBinLabel(22,"bjets cut");
   nEvent_4l_w->GetXaxis()->SetBinLabel(23,"njets cut");
   nEvent_4l_w->GetXaxis()->SetBinLabel(24,"M_T cut");
   nEvent_4l_w->GetXaxis()->SetBinLabel(25,"DPHI cut");
   nEvent_4l_w->GetXaxis()->SetBinLabel(26,"M4l cut");
 '''
