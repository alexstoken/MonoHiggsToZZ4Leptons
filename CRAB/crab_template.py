from WMCore.Configuration import Configuration
config = Configuration()
config.section_('General')
config.General.requestName = 'REQUESTNAME'
config.General.workArea = 'Spring16'
config.General.transferOutputs = True
config.General.transferLogs = True
config.section_('JobType')
config.JobType.psetName = '/lustre/home/dburns/Analysis_8013/CMSSW_8_0_13/src/HiggsAnalysis/HiggsToZZ4Leptons/test/HiggsToZZ_mc_noskim_noMuScleFitCalib_no2016EScaleCalib_EA2016_Regr_13TeV_good.py'
config.JobType.pluginName = 'Analysis'
config.JobType.inputFiles = ['/lustre/home/dburns/Analysis_8013/CMSSW_8_0_13/src/HiggsAnalysis/HiggsToZZ4Leptons/test/qg/QGL_80X.db']
config.JobType.outputFiles = ['roottree_leptons.root']
config.JobType.maxMemoryMB = 2500
config.JobType.allowUndistributedCMSSW = True
config.section_('Data')
config.Data.publication = False
config.Data.inputDataset = 'INPUTDATASET'
config.Data.outputDatasetTag = 'Spring16'
config.Data.unitsPerJob = 5000
config.Data.splitting = 'EventAwareLumiBased'
config.Data.outLFNDirBase = '/store/user/dburns/Spring16'

config.section_('User')
config.section_('Site')
config.Site.storageSite = 'T2_IT_Bari'
