#!/bin/bash
# -----------------------------------------------------------------------------
#  File:        gen_plots.sh
#  Usage:       bash gen_plots.sh
#  Description: Generate all kinematic plots for MonoHiggsToZZ4Leptons analysis
#  Created:     2-Feb-2017 Dustin Burns
# -----------------------------------------------------------------------------

# Update filelists
#ls data/histos4mu_25ns/output_*root > filelist_4mu_2016_Spring16_AN_lxplus.txt
#ls data/histos4e_25ns/output_*root > filelist_4e_2016_Spring16_AN_lxplus.txt
#ls data/histos2e2mu_25ns/output_*root > filelist_2e2mu_2016_Spring16_AN_lxplus.txt
#cat filelist_4mu_2016_Spring16_AN_lxplus.txt filelist_4e_2016_Spring16_AN_lxplus.txt > filelist_4l_2016_Spring16_AN_lxplus.txt

root -b -q -l "mkplots_AN.C(\"hmass4l_CR\")"
root -b -q -l "mkplots_AN.C(\"hmet_CR\")"
root -b -q -l "mkplots_AN.C(\"hZ1mass_CR\")"
root -b -q -l "mkplots_AN.C(\"hZ2mass_CR\")"
root -b -q -l "mkplots_AN.C(\"hNbjets_CR\")"
root -b -q -l "mkplots_AN.C(\"hNgood_CR\")"
root -b -q -l "mkplots_AN.C(\"heta4l_CR\")"
root -b -q -l "mkplots_AN.C(\"hpt4l_CR\")"
root -b -q -l "mkplots_AN.C(\"hlept1_phi_CR\")"
root -b -q -l "mkplots_AN.C(\"hlept2_phi_CR\")"
root -b -q -l "mkplots_AN.C(\"hlept3_phi_CR\")"
root -b -q -l "mkplots_AN.C(\"hlept4_phi_CR\")"
root -b -q -l "mkplots_AN.C(\"hlept1_eta_CR\")"
root -b -q -l "mkplots_AN.C(\"hlept2_eta_CR\")"
root -b -q -l "mkplots_AN.C(\"hlept3_eta_CR\")"
root -b -q -l "mkplots_AN.C(\"hlept4_eta_CR\")"
root -b -q -l "mkplots_AN.C(\"hlept1_pt_CR\")"
root -b -q -l "mkplots_AN.C(\"hlept2_pt_CR\")"
root -b -q -l "mkplots_AN.C(\"hlept3_pt_CR\")"
root -b -q -l "mkplots_AN.C(\"hlept4_pt_CR\")"
root -b -q -l "mkplots_AN.C(\"hD_CR\")"

#root -b -q -l "mkplots_AN.C(\"hmet_SM\")"
#root -b -q -l "mkplots_AN.C(\"hmass4l_SM\")"
#root -b -q -l "mkplots_AN.C(\"hmet_phi_SM\")"
#root -b -q -l "mkplots_AN.C(\"hjet1_pt_zsel\")"
#root -b -q -l "mkplots_AN.C(\"hjet1_phi_zsel\")"
#root -b -q -l "mkplots_AN.C(\"hdphi_jet1_met_zsel\")"
#root -b -q -l "mkplots_AN.C(\"hmaxdphi_jet_met_zsel\")"
#root -b -q -l "mkplots_AN.C(\"hmindphi_jet_met_zsel\")"


# Preselection
#root -b -q -l "mkplots_AN.C(\"hPUvertices\")"
#root -b -q -l "mkplots_AN.C(\"hPUvertices_ReWeighted\")"
#root -b -q -l "mkplots_AN.C(\"hPtLep_0\")"
#root -b -q -l "mkplots_AN.C(\"hIsoLep_0\")"
#root -b -q -l "mkplots_AN.C(\"hSipLep_0\")"

# Step 3 - lepton selection and Z definition
#root -b -q -l "mkplots_AN.C(\"hPtLep_3\")"
#root -b -q -l "mkplots_AN.C(\"hEtaLep_3\")"
#root -b -q -l "mkplots_AN.C(\"hIsoLep_3\")"
#root -b -q -l "mkplots_AN.C(\"hSipLep_3\")"
#root -b -q -l "mkplots_AN.C(\"hPFMET_3\")"
#root -b -q -l "mkplots_AN.C(\"hMZ_3\")"

# Step 5 - 
#root -b -q -l "mkplots_AN.C(\"hPtLep1_5\")"
# hEtaLep1_5
# hIsoLep1_5
# 2, 3, 4
#root -b -q -l "mkplots_AN.C(\"hPtLep2_5\")"
#root -b -q -l "mkplots_AN.C(\"hPtLep3_5\")"
#root -b -q -l "mkplots_AN.C(\"hPtLep4_5\")"
#root -b -q -l "mkplots_AN.C(\"hSipLep1_5\")"
#root -b -q -l "mkplots_AN.C(\"hMZ1_5\")"
#root -b -q -l "mkplots_AN.C(\"hMZ2_5\")"
#root -b -q -l "mkplots_AN.C(\"hM4l_5\")"

# Step 8 - final SM selection m4l > 75
#root -b -q -l "mkplots_AN.C(\"hPFMET_8\")"
# hPtLep1_8
#root -b -q -l "mkplots_AN.C(\"hPtLep1_8\")"
# hEtaLep1_8
# hIsoLep1_8
# 2, 3, 4
#root -b -q -l "mkplots_AN.C(\"hMZ1_8\")"
#root -b -q -l "mkplots_AN.C(\"hMZ2_8\")"
# hPtZ1_8
# hYZ1_8
# hPtZ2_8
# hYZ2_8
#root -b -q -l "mkplots_AN.C(\"hM4l_8\")"
# hM4l_T_8
# DPHI_8
# hNgood
# hNbjets
# hMELA_8
#root -b -q -l "mkplots_AN.C(\"hDPHI_MAX_JET_MET_8\")"
#root -b -q -l "mkplots_AN.C(\"hDPHI_MIN_JET_MET_8\")"


# Add plots to markdown

