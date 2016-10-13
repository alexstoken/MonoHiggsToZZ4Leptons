# MonoHiggsToZZ4Leptons
## Introduction
This repository contains the directories for optimizing the Standard Model (SM) Higgs search for the Mono-Higgs signature, used to search for DM produced in association with a Higgs, using both cut-and-count and multivariate methods. The packages here stand alone from the SM analysis framework, but take as input the "reduced" ROOT NTuples output from the package https://github.com/cms-analysis/HiggsAnalysis-HiggsToZZ4LeptonsRun2, which contain only the necessary branches for these studies.

## Installation
This package depends on [Root](https://root.cern.ch/downloading-root) in general, and the Statistical Analysis framwork depends on the Higgs analysis statistics package [CombinedLimit](https://github.com/cms-analysis/HiggsAnalysis-CombinedLimit) and is best run within CMS Software version 7_6_X or later. The Optimization frameworks can be run outside of CMSSW, depending only on ROOT and Python.

The repo can be obtained locally by running
```
git clone https://github.com/dburns7/MonoHiggsToZZ4Leptons.git
```
