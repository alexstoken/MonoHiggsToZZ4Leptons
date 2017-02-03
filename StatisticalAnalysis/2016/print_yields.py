#!/usr/bin/env python
# -----------------------------------------------------------------------------
#  File:        print_yields.py
#  Usage:       python print_yields.py --channel 4mu
#  Description: Macro for printing out event yields and writing shape hists 
#               to a file for limit setting
#  Created:     19-Dec-2016 Dustin Burns
# -----------------------------------------------------------------------------

from ROOT import *
import numpy as np
import math
import argparse

def get_data(t):
  weight = []
  pfmet  = []
  mass4l = []
  mT     = []
  dphi   = []
  Dkin   = []
  cat    = []
  Ngood  = []
  Nbjets = []
  for evt in t:
    weight.append(evt.f_weight)
    pfmet .append(evt.f_pfmet)
    mass4l.append(evt.f_mass4l)
    mT    .append(evt.f_mT)
    dphi  .append(evt.f_dphi)
    Dkin  .append(evt.f_D_bkg_kin)
    cat   .append(evt.f_category)
    Ngood .append(evt.f_Ngood)
    Nbjets.append(evt.f_Nbjets)
  return (weight, pfmet, mass4l, mT, dphi, Dkin, cat, Ngood, Nbjets)

if __name__ == "__main__":
 
  # Parse command line arguments
  parser = argparse.ArgumentParser()
  parser.add_argument('--channel', required=True, help='Decay channel: 4mu, 4e, or 2e2mu')
  parser.add_argument('--metcut', required=True, type=float, help='Exclude events below cut')
  parser.add_argument('--m4lcut', required=True, type=float, help='Exclude events outside window cut')
  args = parser.parse_args()

  flist = map(lambda x: x.split()[-1], open('filelist_' + args.channel + '_2016_Spring16_AN_lxplus.txt').readlines()) 
  
  #w = 0
  #w2 = 0
  #N = 0
  ## calculate average and std of event weights
  #for f in flist:
  #  # Get Data
  #  ft = TFile.Open(f)
  #  t = ft.Get("HZZ4LeptonsAnalysisReduced")
  #  weight, pfmet, mass4l, mT, dphi, Dkin, cat, Ngood = get_data(t)
  #  ft.Close()
  #  
  #  if 'MZp' not in f and 'Run2016' not in f: 
  #    N += len(weight)
  #    w += sum(weight)
  #    w2 += sum(x**2 for x in weight) 
 # 
 # w = w/N
 # w2 = w2/N
 # w2 = math.sqrt(w2-w**2)
 # print N
 # print str(w) + ' +/- ' + str(w2)

  # load bnn
  #record = open('Dmass4l.cpp').read()
  record = open('Dm4lmet.cpp').read()
  gROOT.ProcessLine(record)

  #h0pfmet_D = TH1F("h0pfmet_D", "", 1000, 0, 1600)
  h1pfmet_D = TH1F("h1pfmet_D", "", 1000, 0, 1600)
  h1D_D = TH1F("h1D_D", "", 100, 0, 1.1)
  #h0pfmet_D.Sumw2()
  h1pfmet_D.Sumw2()
  h1D_D.Sumw2()
  for f in flist:
      
    # Get Data
    ft = TFile.Open(f)
    t = ft.Get("HZZ4LeptonsAnalysisReduced")
    weight, pfmet, mass4l, mT, dphi, Dkin, cat, Ngood, Nbjets = get_data(t)
    ft.Close()

    # Book histograms
    #h0pfmet = TH1F("h0pfmet", "", 1000, 0, 1600)
    h1pfmet = TH1F("h1pfmet", "", 1000, 0, 1600)
    h1D     = TH1F("h1D", "", 100, 0, 1.1)
    #h0pfmet.Sumw2()
    h1pfmet.Sumw2()
    h1D.Sumw2()
    
    # Fill hists
    #for i in range(len(weight)/2, len(weight)):
    for i in range(0, len(weight)):
      
      # Weight cleaning
      #if weight[i] > w + 4*w2 and 'Run2015' not in f: continue
   
      # Step 0: SM selection
      #h0pfmet.Fill(pfmet[i], weight[i])
      #if 'Run2016' in f: 
      #  h0pfmet_D.Fill(pfmet[i], weight[i])
      # Step 1: MonoH selection
      if Ngood[i] != 4: continue
      if Nbjets[i] > 1: continue
      if pfmet[i] < args.metcut: continue
      #if mass4l[i] > 135: continue
      #if mass4l[i] < 100: continue
      #if Dm4lmet(mass4l[i], pfmet[i], 0, 199) < 0.999: continue
      if np.abs(mass4l[i] - 125) > args.m4lcut: continue
      
      #if mT[i] < 200: continue
      #if dphi[i] < 0.4: continue
      #if Dmass4l(mass4l[i], Dkin[i], 0, 199) < 0.2: continue
      h1pfmet.Fill(pfmet[i], weight[i])
      h1D.Fill(Dm4lmet(mass4l[i], pfmet[i], 0, 199), weight[i])
      #if 'MZp' in f: print Dm4lmet(mass4l[i], pfmet[i], 0, 199)
      if 'Run2016' in f: 
        h1pfmet_D.Fill(pfmet[i], weight[i])
        h1D_D.Fill(Dm4lmet(mass4l[i], pfmet[i], 0, 199), weight[i])

    # Print yields  
    err2 = 0;
    for i in range(0, h1pfmet.GetXaxis().GetNbins()):
      err2 += h1pfmet.GetBinError(i)*h1pfmet.GetBinError(i);

    print 'Sample name ' + args.channel + 'channel: ' + f + ' N Entries: ' + str(h1D.GetEntries()) + ' Yield: ' + str(h1D.Integral()) + ' Error: ' + str(math.sqrt(err2))
    #print 'Sample name ' + args.channel + 'channel: ' + f + ' N Entries: ' + str(h1pfmet.GetEntries()) + ' Yield: ' + str(h1pfmet.Integral()) + ' Error: ' + str(math.sqrt(err2))

    # Write hists to file
    #g = TFile("plots/plots_" + f.split('_25ns/')[1], 'RECREATE')
    #h0pfmet.Write()
    #h1pfmet.Write()
    #g.Close()

    nRebin = 1

    # White shape hist to file
    fs = TFile('datacards_' + args.channel + '/f' + args.channel + '.root', 'UPDATE')
    if (not fs.FindKey('bin' + args.channel)):  d = fs.mkdir('bin' + args.channel)
    #hs = h1D
    hs = h1pfmet
    #name = f.split('test/')[1].split('.root')[0]
    name = f.split('_25ns/')[1].split('.root')[0]
    #if 'MZp' not in f: name = f.split('_2016/')[1].split('.root')[0]
    #if 'MZp' in f: name = f.split('_25ns_BR/')[1].split('.root')[0]
    hs.SetName(name)
    hs_rebin = hs.Rebin(nRebin, name)
    #for k in range(0, hs_rebin.GetNbinsX()):
    #  if (hs_rebin.GetBinContent(k) == 0): hs_rebin.SetBinContent(k, 1E-8)
    fs.cd('bin' + args.channel)
    hs_rebin.Write(name)
    fs.Close()

# Write data shape hist to file
  fs = TFile('datacards_' + args.channel + '/f' + args.channel + '.root', 'UPDATE')
  #hs = h1D_D
  hs = h1pfmet_D
  hs.SetName('data_obs')
  hs_rebin = hs.Rebin(nRebin, 'data_obs')
  fs.cd('bin' + args.channel)
  hs_rebin.Write('data_obs')
  fs.Close()

