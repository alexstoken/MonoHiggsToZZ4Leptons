#!/bin/bash
# -----------------------------------------------------------------------------
#  File:        gen_plots.sh
#  Usage:       bash gen_plots.sh
#  Description: Generate all kinematic plots for MonoHiggsToZZ4Leptons analysis
#  Created:     2-Feb-2017 Dustin Burns
# -----------------------------------------------------------------------------

# Preselection
root -b -q -l "mkplots.C(\"hPUvertices\")"
root -b -q -l "mkplots.C(\"hPUvertices_ReWeighted\")"
root -b -q -l "mkplots.C(\"hPtLep_0\")"
root -b -q -l "mkplots.C(\"hIsoLep_0\")"
root -b -q -l "mkplots.C(\"hSipLep_0\")"



# Step 3 - lepton selection and Z definition
root -b -q -l "mkplots.C(\"hPtLep_3\")"
root -b -q -l "mkplots.C(\"hEtaLep_3\")"
root -b -q -l "mkplots.C(\"hIsoLep_3\")"
root -b -q -l "mkplots.C(\"hSipLep_3\")"
root -b -q -l "mkplots.C(\"hPFMET_3\")"
root -b -q -l "mkplots.C(\"hMZ_3\")"

# Step 5 - 
root -b -q -l "mkplots.C(\"hPtLep1_5\")"
root -b -q -l "mkplots.C(\"hPtLep2_5\")"
root -b -q -l "mkplots.C(\"hPtLep3_5\")"
root -b -q -l "mkplots.C(\"hPtLep4_5\")"
root -b -q -l "mkplots.C(\"hSipLep1_5\")"
root -b -q -l "mkplots.C(\"hMZ1_5\")"
root -b -q -l "mkplots.C(\"hM4l_5\")"


# Step 8 - final SM selection m4l > 75
root -b -q -l "mkplots.C(\"hPFMET_8\")"
root -b -q -l "mkplots.C(\"hMZ1_8\")"
