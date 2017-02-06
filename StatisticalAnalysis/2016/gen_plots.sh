#!/bin/bash
# -----------------------------------------------------------------------------
#  File:        gen_plots.sh
#  Usage:       bash gen_plots.sh
#  Description: Generate all kinematic plots for MonoHiggsToZZ4Leptons analysis
#  Created:     2-Feb-2017 Dustin Burns
# -----------------------------------------------------------------------------

# Step 3 - lepton selection and Z definition
root -b -q -l "mkplots.C(\"hPFMET_3\")"

# Step 5 - 


# Step 8 - final SM selection m4l > 75
root -b -q -l "mkplots.C(\"hPFMET_8\")"
