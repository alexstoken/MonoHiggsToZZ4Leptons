# MonoHiggsStatisticalAnalysis
## Introduction
This repository contains the framework for performing the statistical analysis for the Mono-Higgs to four-lepton channel, including application of systematic uncertainties, calculating, and plotting limits. The framework is designed to be automated, driven by the script calc_limits.sh, with a few customizable parameters to change the signal model and mass points plotted. In this way, it is easy to update the limits with changes in the event selection and addition/removal of backgrounds. The event yields are obtained from the ntuples output from the HiggsAnalysis/HiggsToZZ4LeptonsRun2 package located at https://github.com/cms-analysis/HiggsAnalysis-HiggsToZZ4LeptonsRun2. This package runs independently, only needing access to the analysis ntuples. 

## Installation
This package depends on [Root](https://root.cern.ch/downloading-root) and the Higgs analysis statistics package [CombinedLimit](https://github.com/cms-analysis/HiggsAnalysis-CombinedLimit). Additional instructions for installing and running CombinedLimit can be found at https://twiki.cern.ch/twiki/bin/viewauth/CMS/SWGuideHiggsAnalysisCombinedLimit

## Usage
The driving script for this package is calc_limits.sh, which needs only as input a file with the list of ntuple locations for the desired signal, background, and data samples, for the desired channel, 4mu, 4e, 2e2mu, or 4l. The automated sequence is ran with
```
bash calc_limits.sh 4l
```
in bash shell, with the input parameter being the desired channel.

## Developer Notes
The following is a log of updates and a to-do list for further development.

The macro print_yields.C can be replaced with a simpler python script.

Once the background channels are fixed, the data card templates can be expanded to include a fixed list of backgrounds and corresponding uncertainties. In this way, the gen_cards.py script can be simplified to only change the signal yield.

Steps 5-7 can be merged by hadding the ntuples output from combine instead of parsing text files with the limits, also simplifying the plotting macro.

The plotting macro can be expanded to plot in 2D for wider mass scans. 
