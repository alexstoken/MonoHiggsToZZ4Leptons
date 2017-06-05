#!/usr/bin/env python
# -----------------------------------------------------------------------------
#  File:        MonoHiggsSelection.py
#  Usage:       python MonoHiggsSelection.py --channel 4mu
#  Description: Apply optimized event selection, including various machine learning
#               algorithm testing, printing out event yields and writing shape histograms
#               to a file for limit setting.
#  Created:     9-Feb-2017 Dustin Burns
# -----------------------------------------------------------------------------
from ROOT import *
import numpy as np
import math
import argparse

# Convert ROOT TNtuple data structure to Python arrays
def get_data(f):
  f = TFile.Open(f)
  t = f.Get("HZZ4LeptonsAnalysisReduced")
  weight = []
  pfmet  = []
  mass4l = []
  mT     = []
  dphi   = []
  Dkin   = []
  cat    = []
  Ngood  = []
  Nbjets = []
  dphi_min    = []
  dphi_min_pt = []
  dphi_max    = []
  dphi_max_pt = []
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
    #dphi_min.append(evt.f_min_dphi_jet_met)
    #dphi_min_pt.append(evt.f_min_dphi_jet_pt)
    #dphi_max.append(evt.f_max_dphi_jet_met)
    #dphi_max_pt.append(evt.f_max_dphi_jet_pt)
  f.Close()
  return (weight, pfmet, mass4l, mT, dphi, Dkin, cat, Ngood, Nbjets, dphi_min, dphi_min_pt, dphi_max, dphi_max_pt)

if __name__ == "__main__":
 
  # Parse command line arguments
  parser = argparse.ArgumentParser()
  parser.add_argument('--channel', required=True, help='Decay channel: 4mu, 4e, or 2e2mu')
  args = parser.parse_args()

  # Read in list of data and simulation files
  flist = map(lambda x: x.split()[-1], open('filelist_' + args.channel + '_2016_Spring16_AN_Bari_Giorgia.txt').readlines()) 
  
  # Load machine learning algorithm to test on events     
  #record = open('Dmass4l.cpp').read() # Neural network, inputs: mass4l, Dkin
  #record = open('Dm4lmet.cpp').read() # Neural network, inputs: mass4l, pfmet
  #record = open('m4lmelamet_BNN.cc').read() # Neural network, inputs: mass4l, Dkin, pfmet
  record = open('m4lmelamet_BDT.cc').read() # Boosted decision tree, inputs: mass4l, Dkin, pfmet
  #record = open('m4lmelametngoodnbjets.cc').read() # Boosted decision tree, inputs: mass4l, Dkin, pfmet, Ngood, Nbjets
  #record = open('m4lmelamet_MLP.cc').read() # Multilayer perceptron, inputs: mass4l, Dkin, pfmet
  #record = open('m4lmelamet_JETNET.cc').read() # JETNET algorithm, inputs: mass4l, Dkin, pfmet
  gROOT.ProcessLine(record)

  # Book histograms for data samples
  h0pfmet_D = TH1F("h0pfmet_D", "", 1000, 0, 1600)
  h1pfmet_D = TH1F("h1pfmet_D", "", 1000, 0, 1600)
  h1D_D = TH1F("h1D_D", "", 100, 0, 1.1)
  h0pfmet_D.Sumw2()
  h1pfmet_D.Sumw2()
  h1D_D.Sumw2()
  
  # Loop through input files, testing machine learning algorithm and applying signal region selection
  for f in flist:
      
    # Get Data
    weight, pfmet, mass4l, mT, dphi, Dkin, cat, Ngood, Nbjets, dphi_min, dphi_min_pt, dphi_max, dphi_max_pt = get_data(f)

    # Book histograms for Monte Carlo simulation samples
    h0pfmet = TH1F("h0pfmet", "", 1000, 0, 1000)
    h1pfmet = TH1F("h1pfmet", "", 1000, 0, 1000)
    h1D     = TH1F("h1D", "", 100, -1.1, 1.1)
    h0pfmet.Sumw2()
    h1pfmet.Sumw2()
    h1D.Sumw2()
    
    # Apply selection, filling histograms before and after
    for i in range(0, len(weight)):

      # Step 0: Standard Model Higgs search selection
      h0pfmet.Fill(pfmet[i], weight[i])
      if 'Run2016' in f: 
        h0pfmet_D.Fill(pfmet[i], weight[i])
      
      # Step 1: MonoHiggs selection
      #if Ngood[i] != 4: continue
      #if Nbjets[i] > 1: continue
      #if pfmet[i] < 60: continue
      #if np.abs(mass4l[i] - 125) > 10: continue
      #if mass4l[i] < 70: continue
      #if mass4l[i] > 170: continue
      #print m4lmelamet(mass4l[i], Dkin[i], pfmet[i])
      #if m4lmelamet(mass4l[i], Dkin[i], pfmet[i]) < -0.9: continue
      #if Dm4lmet(mass4l[i], pfmet[i], 0, 199) < 0.999: continue
      #if dphi_min_pt[i] > 50 and dphi_min[i] < 0.5: continue
      #if dphi_max_pt[i] > 50 and dphi_max[i] > 2.7: continue

      h1pfmet.Fill(pfmet[i], weight[i])
      h1D.Fill(m4lmelamet(mass4l[i], Dkin[i], pfmet[i]), weight[i])
      #h1D.Fill(m4lmelametngoodnbjets(mass4l[i], Dkin[i], pfmet[i], Ngood[i], Nbjets[i]), weight[i])
      if 'Run2016' in f: 
        h1pfmet_D.Fill(pfmet[i], weight[i])
        h1D_D.Fill(m4lmelamet(mass4l[i], Dkin[i], pfmet[i]), weight[i])
        #h1D_D.Fill(m4lmelametngoodnbjets(mass4l[i], Dkin[i], pfmet[i], Ngood[i], Nbjets[i]), weight[i])

    # Print yields  
    err2 = 0;
    for i in range(0, h1pfmet.GetXaxis().GetNbins()):
      err2 += h1pfmet.GetBinError(i)**2;
    #print 'Sample name ' + args.channel + 'channel: ' + f + ' N Entries: ' + str(h1D.GetEntries()) + ' Yield: ' + str(h1D.Integral()) + ' Error: ' + str(math.sqrt(err2))
    print 'Sample name ' + args.channel + 'channel: ' + f + ' N Entries: ' + str(h1pfmet.GetEntries()) + ' Yield: ' + str(h1pfmet.Integral()) + ' Error: ' + str(math.sqrt(err2))
  
    # Write shape histogram to file for Monte Carlo samples
    nRebin = 1
    fs = TFile('datacards_' + args.channel + '/f' + args.channel + '.root', 'UPDATE')
    if (not fs.FindKey('bin' + args.channel)):  d = fs.mkdir('bin' + args.channel)
    #hs = h1D
    hs = h1pfmet
    name = f.split('_25ns/')[1].split('.root')[0]
    hs.SetName(name)
    hs_rebin = hs.Rebin(nRebin, name)
    #for k in range(0, hs_rebin.GetNbinsX()):
    #  if (hs_rebin.GetBinContent(k) == 0): hs_rebin.SetBinContent(k, 1E-8)
    fs.cd('bin' + args.channel)
    hs_rebin.Write(name)
    fs.Close()

    # Write "re-reduced" files for plotting after monoH selection
    fout = TFile('plots/plots_' + f.split('_25ns/')[1], 'recreate')
    h1pfmet.Write('hmet_CR')
    fout.Close()

  # Write data shape histogram to file
  fs = TFile('datacards_' + args.channel + '/f' + args.channel + '.root', 'UPDATE')
  #hs = h1D_D
  hs = h1pfmet_D
  hs.SetName('data_obs')
  hs_rebin = hs.Rebin(nRebin, 'data_obs')
  fs.cd('bin' + args.channel)
  hs_rebin.Write('data_obs')
  fs.Close()
  
