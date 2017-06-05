// -----------------------------------------------------------------------------
//  File:        mkplots_AN.C
//  Usage:       root -b -q -l "mkplots_AN.C(\"hPFMET_3\")"
//  Description: Macro for generating kinematic plots for MonoHiggsToZZ4Leptons analysis
//  Created:     11-Feb-2017 Dustin Burns
// -----------------------------------------------------------------------------
using namespace std;

// Sum histograms in input list, apply basic formatting
TH1 * GetHistSum(std::vector<string> _names, const char * histlabel, TLegend * leg, const char * legtag, const char * legstyle, int fillcolor, int linecolor, int linestyle, int fillstyle, int marker, int linewidth, int nRebin, bool noerrors){
  
  //if(strncmp(histlabel, "hEtaLep1_5", 12) == 0 && strncmp(legtag, "Z+X", 12) == 0) histlabel = "hEtaLep_3";
  cout << legtag << endl;
  // Get first hist in _names list  
  TFile *f = TFile::Open(_names.at(0).c_str());
  TH1F * h = (TH1F *)f->Get(histlabel); 

  // Add on rest of hists in list
  for(int i=1; i<_names.size(); i++){
    TFile *f = TFile::Open(_names.at(i).c_str());
    h->Add((TH1F *)f->Get(histlabel));
  }

  // Formatting
  h->SetMarkerStyle(marker);
  h->SetMarkerColor(linecolor);
  h->SetMarkerSize(0.5);
  h->SetFillStyle(fillstyle);
  h->SetFillColor(fillcolor);
  h->SetLineColor(linecolor);   
  h->SetLineStyle(linestyle);
  h->SetLineWidth(linewidth);
  if (leg) leg->AddEntry(h, legtag, legstyle);

  // Error bars
  if(noerrors) for(int i=0; i<h->GetNbinsX(); i++) h->SetBinError(i, 0);

  // Rebinning 
  //const Double_t xbins[] = {10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220, 230, 240, 250, 260, 270, 280, 290, 300, 310, 320, 330, 340, 350, 360, 370, 380, 390, 400, 450, 500, 550, 600, 650, 700, 800, 999};
  //TH1 * h_rebin = h->Rebin(sizeof(xbins)/sizeof(Double_t) - 1, histlabel, xbins);
  TH1 * h_rebin = h->Rebin(nRebin, histlabel);

  //if(strncmp(histlabel, "hEtaLep_3", 12) == 0 && strncmp(legtag, "Z+X", 12) == 0) h_rebin->Scale(19.5568/135806);
  // Print yield
  cout << "Integral of " << legtag << " " << h_rebin->Integral() << endl;
  return h_rebin;
}


// Build hist stack of backgrounds, applying basic formatting
THStack * GetBkgStack(std::vector<string> _bkgnames, const char * histlabel, TLegend * leg, int nRebin){

  // Set up stack 
  THStack * stack = new THStack(histlabel, "");
  TFile *f = TFile::Open(_bkgnames.at(0).c_str());
  TH1F * h_base = (TH1F *)f->Get(histlabel);
  stack->SetHistogram(h_base);

  // Sort bkgs into lists
  std::vector<string> _H125, _ggZZ, _qqZZ, _ZX;
  for(int i=0; i<_bkgnames.size(); i++){
    if(_bkgnames.at(i).find("GluGluHToZZTo4L") < 200 || _bkgnames.at(i).find("VBF_HToZZTo4L") < 200 || _bkgnames.at(i).find("WminusH") < 200 || _bkgnames.at(i).find("WplusH") < 200 || _bkgnames.at(i).find("ZH") < 200 || _bkgnames.at(i).find("ttH") < 200) _H125.push_back(_bkgnames.at(i));
    if(_bkgnames.at(i).find("GluGluToZZ") < 200 ) _ggZZ.push_back(_bkgnames.at(i));
    if(_bkgnames.at(i).find("_ZZTo4L") < 200)     _qqZZ.push_back(_bkgnames.at(i));
    //if(_bkgnames.at(i).find("QCD") < 200 || _bkgnames.at(i).find("ST") < 200 || _bkgnames.at(i).find("TTTo2L2Nu") < 200 || _bkgnames.at(i).find("WJetsToLNu") < 200 || _bkgnames.at(i).find("WWTo2L2Nu") < 200 || _bkgnames.at(i).find("WZ") < 200) _ZX.push_back(_bkgnames.at(i));
    if(_bkgnames.at(i).find("DYJetsToLL") < 200 || _bkgnames.at(i).find("QCD") < 200 || _bkgnames.at(i).find("ST") < 200 || _bkgnames.at(i).find("TTTo2L2Nu") < 200 || _bkgnames.at(i).find("WJetsToLNu") < 200 || _bkgnames.at(i).find("WWTo2L2Nu") < 200 || _bkgnames.at(i).find("WZ") < 200) _ZX.push_back(_bkgnames.at(i));
  }

  // Get hist sums for bkg lists
  TH1 * hH125 = GetHistSum(_H125, histlabel, leg, "H(125 GeV)",   "f", kRed-9, kRed+1, 1, 1001, 0, 2, nRebin, true);
  TH1 * hggZZ = GetHistSum(_ggZZ, histlabel, leg, "gg#rightarrowZZ, Z#gamma*", "f", kBlue, kCyan+4, 1, 1001, 0, 2, nRebin, true);
  TH1 * hqqZZ = GetHistSum(_qqZZ, histlabel, leg, "q#bar{q}#rightarrowZZ, Z#gamma*",       "f", kAzure+1, kAzure-1, 1, 1001, 0, 2, nRebin, true);
  TH1 * hZX   = GetHistSum(_ZX,   histlabel, leg, "Z+X",        "f", kGreen-5, kGreen+3, 1, 1001, 0, 2, nRebin, true);

  // Fill HistInt structs for sorting hists by integral
  struct HistInt { TH1 *Hist; float integral;};
  struct by_integral { bool operator()(HistInt const &a, HistInt const &b) { return a.integral < b.integral; } };
  std::vector<HistInt> HistInts;
  HistInt H125, ggZZ, qqZZ, ZX;
  H125.Hist = hH125; H125.integral = hH125->Integral();
  ggZZ.Hist = hggZZ; ggZZ.integral = hggZZ->Integral();
  qqZZ.Hist = hqqZZ; qqZZ.integral = hqqZZ->Integral();
  ZX.Hist   = hZX;   ZX.integral   = hZX->Integral();
  HistInts.push_back(H125);
  HistInts.push_back(ggZZ);
  HistInts.push_back(qqZZ);
  HistInts.push_back(ZX);
  std::sort(HistInts.begin(), HistInts.end(), by_integral());

  // Build stack in ascending order of integrals
  for(int i=0; i<HistInts.size(); i++) {
    stack->Add(HistInts.at(i).Hist);
  }
  
  //stack->Add(hH125);
  //stack->Add(hZZ);
  return stack;
}

// Abstracted function for plotting any kinematic distribution
void varPlot(std::vector<string> _datanames, std::vector<string> _bkgnames, std::vector<string> _sig2HDM600, std::vector<string> _sig2HDM1200, std::vector<string> _sig2HDM2000, std::vector<string> _sigZpB10, const char * histlabel, bool logx, bool logy, double xmin, double xmax, double ymin, double ymax, int nRebin, const char * units, const char * xlabel, const char * save){
  
  // Set up canvas
  gStyle->SetOptStat(0);
  TCanvas * c = new TCanvas("c", "", 800, 600);
  c->SetTicks(1,1); 
  if (logx) c->SetLogx();
  if (logy) c->SetLogy();
  c->SetLeftMargin(0.12); 

  // Set up hframe formatting
  TH2F *hframe = new TH2F("hframe", "", 100, xmin, xmax, 500, ymin, ymax);
  char ylabel[50];
  sprintf(ylabel, "Events / %d %s", nRebin, units); 
  hframe->SetYTitle(ylabel);
  hframe->GetYaxis()->SetLabelSize(0.035);
  hframe->GetYaxis()->SetTitleSize(0.032);
  hframe->GetYaxis()->SetLabelOffset(0.007);
  hframe->GetYaxis()->SetTitleOffset(1.35);
  hframe->GetYaxis()->SetTickLength(0.02);
  hframe->SetXTitle(xlabel);
  hframe->GetXaxis()->SetLabelSize(0.035);
  hframe->GetXaxis()->SetTitleSize(0.032);
  hframe->GetXaxis()->SetLabelOffset(0.007);
  hframe->GetXaxis()->SetTitleOffset(1.35);
  hframe->GetXaxis()->SetTickLength(0.02);
  hframe->Draw("Same");

  // Set up legends
  TLegend* leg = new TLegend(0.70, 0.66, 0.9, 0.85);
  leg->SetFillStyle(0);
  leg->SetBorderSize(0);
  leg->SetTextSize(0.032);
  leg->Draw("Same");
  TLegend* leg2 = new TLegend(0.38, 0.7, 0.78, 0.83);
  leg2->SetFillStyle(0);
  leg2->SetBorderSize(0);
  leg2->SetTextSize(0.032);
  leg2->Draw("Same");
  
  // Get sum of hists for data and signals
  TH1 * hdata    = GetHistSum(_datanames, histlabel, leg,  "Data", "ep", kBlack, kBlack, 1, 1, 20, 1, nRebin, false);
  TH1 * hsig2HDM600  = GetHistSum(_sig2HDM600,    histlabel, leg2, "Zp2HDM (600 GeV)",  "l", kBlack, kOrange-2, 1, 0, 1, 2,   nRebin, true);
  TH1 * hsig2HDM1200 = GetHistSum(_sig2HDM1200,   histlabel, leg2, "Zp2HDM (1200 GeV)", "l", kBlack, kRed+1, 1, 0, 1, 2, nRebin, true);
  TH1 * hsig2HDM2000 = GetHistSum(_sig2HDM2000,   histlabel, leg2, "Zp2HDM (2000 GeV)", "l", kBlack, kRed+3, 1, 0, 1, 2, nRebin, true);
  TH1 * hsigZpB10 = GetHistSum(_sigZpB10,   histlabel, leg2, "ZpBaryonic (10 GeV)", "l", kBlack, kSpring-5, 1, 0, 1, 2, nRebin, true);
  
  // Get bkg stack
  THStack * sbkg =  GetBkgStack(_bkgnames, histlabel, leg, nRebin);
  //sbkg->Scale(hdata->Integral() / sbkg->Integral());

  // Plot hists
  sbkg    ->Draw("HistSame");
  hdata   ->Draw("E1PX0Same");
  hsig2HDM600 ->Draw("HSame");
  hsig2HDM1200->Draw("HSame");
  hsig2HDM2000->Draw("HSame");
  hsigZpB10   ->Draw("HSame");
  gPad->RedrawAxis();
  gPad->SetFrameLineWidth(2);
  gStyle->SetLineWidth(2);

  // Set up supertext
  TPaveText *ll = new TPaveText(0.11, 0.9, 0.92, 0.94, "NDC");
  ll->SetTextSize(0.032);
  ll->SetTextFont(42);
  ll->SetFillColor(0);
  ll->SetBorderSize(0);
  ll->SetMargin(0.01);
  ll->SetTextAlign(12);
  TString text = "#font[22]{CMS} #font[12]{Preliminary}";
  ll->AddText(0.01,0.5,text);
  text = "36.5 fb^{-1} (13 TeV)" ;
  ll->AddText(0.77, 0.5, text);
  ll->Draw("Same"); 
  hframe->Draw("Same");
  
  // Save plot
  char savename[100];
  sprintf(savename, "plots/AN/hist_%s%s.png", histlabel, save);
  c->SaveAs(savename);

}

// Main function: switch on plot variable, setting formatting options for each
void mkplots_AN(const char* histlabel){
 
  // Read in and sort input files
  //std::string inputfile = "filelist_4mu_2016_Spring16_AN_Bari_SR.txt";
  //std::string inputfile = "filelist_4mu_2016_Spring16_AN_Bari_SR.txt";
  std::string inputfile = "filelist_4mu_2016_Spring16_AN_Bari.txt";
  //std::string inputfile = "filelist_4mu_2016_Spring16_AN_Bari_Giorgia.txt";
  std::vector<string> _datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10;
  std::ifstream in;
  in.open(inputfile.c_str());
  std::string filename;
  while(std::getline(in, filename)){
    if(filename.find("Run2016") < 200) _datanames.push_back(filename);
    if(filename.find("13TeV")   < 200 && filename.find("MZp") > 200) _bkgnames.push_back(filename);
    if(filename.find("2HDM_MZp-600_MA0-300")  < 200) _sig2HDM600.push_back(filename);
    if(filename.find("2HDM_MZp-1200_MA0-300") < 200) _sig2HDM1200.push_back(filename);
    if(filename.find("2HDM_MZp-2000_MA0-300") < 200) _sig2HDM2000.push_back(filename);
    if(filename.find("ZpBaryonic_MZp-10_MChi-1_") < 200) _sigZpB10.push_back(filename);
  }
  
  // Set options for plot depending on selected histogram
  // varPlot( _datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, logy, xmin, xmax, ymin, ymax, nRebin, units, xlabel, savename){
  

  if(strncmp(histlabel, "hPUvertices", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 0, 38, 3E-1, 8E16, 1, "", "Pileup vertices", "");
  }

  if(strncmp(histlabel, "hPUvertices_ReWeighted", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 0, 38, 3E-1, 8E16, 1, "", "Pileup vertices reweighted", "");
  }
  if(strncmp(histlabel, "hD_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -1.1, 1.1, 3E-1, 8E5, 10, "", "D", "");
  }

  if (strncmp(histlabel, "hPtLep_0", 12) == 0 || strncmp(histlabel, "hPtLep_3", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 0, 200, 5E-5, 5E7, 10, "GeV", "Lepton pT (GeV)", "");
  }

  if (strncmp(histlabel, "hPtLep1_8", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 0, 200, 5E-5, 5E5, 10, "GeV", "Lepton 1 pT (GeV)", "");
  }

  if (strncmp(histlabel, "hPtLep1_5", 12) == 0 || strncmp(histlabel, "hlept1_pt_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 20, 200, 5E-5, 5E5, 10, "GeV", "Lepton 1 pT (GeV)", "");
  }

  if (strncmp(histlabel, "hPtLep2_5", 12) == 0 || strncmp(histlabel, "hlept2_pt_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 10, 200, 5E-5, 5E5, 10, "GeV", "Lepton 2 pT (GeV)", "");
  }

  if (strncmp(histlabel, "hPtLep3_5", 12) == 0 || strncmp(histlabel, "hlept3_pt_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 0, 200, 5E-5, 5E5, 10, "GeV", "Lepton 3 pT (GeV)", "");
  }

  if (strncmp(histlabel, "hPtLep4_5", 12) == 0  || strncmp(histlabel, "hlept4_pt_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 0, 200, 5E-5, 5E5, 10, "GeV", "Lepton 4 pT (GeV)", "");
  }

  if (strncmp(histlabel, "hEtaLep_3", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -2.5, 2.5, 5E-2, 5E7, 10, "", "Lepton #eta", "");
  }
  
  if (strncmp(histlabel, "hEtaLep1_5", 12) == 0 || strncmp(histlabel, "hlept1_eta_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -2.5, 2.5, 5E-5, 5E7, 10, "", "Lepton 1 #eta", "");
  }
  if (strncmp(histlabel, "hEtaLep2_5", 12) == 0 || strncmp(histlabel, "hlept2_eta_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -2.5, 2.5, 5E-5, 5E7, 10, "", "Lepton 2 #eta", "");
  }
  if (strncmp(histlabel, "hEtaLep3_5", 12) == 0 || strncmp(histlabel, "hlept3_eta_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -2.5, 2.5, 5E-5, 5E7, 10, "", "Lepton 3 #eta", "");
  }
  if (strncmp(histlabel, "hEtaLep4_5", 12) == 0 || strncmp(histlabel, "hlept4_eta_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -2.5, 2.5, 5E-5, 5E7, 2, "", "Lepton 4 #eta", "");
  }
  if (strncmp(histlabel, "heta4l_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -2.5, 2.5, 5E-5, 5E7, 2, "", "4l #eta", "");
  }

  if (strncmp(histlabel, "hlept1_phi_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -3.2, 3.2, 5E-5, 5E7, 2, "", "Lepton 1 #phi", "");
  }
  if (strncmp(histlabel, "hlept2_phi_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -3.2, 3.2, 5E-5, 5E7, 2, "", "Lepton 2 #phi", "");
  }
  if (strncmp(histlabel, "hlept3_phi_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -3.2, 3.2, 5E-5, 5E7, 2, "", "Lepton 3 #phi", "");
  }
  if (strncmp(histlabel, "hlept4_phi_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -3.2, 3.2, 5E-5, 5E7, 2, "", "Lepton 4 #phi", "");
  }
  if (strncmp(histlabel, "hPtZ1_5", 12) == 0  || strncmp(histlabel, "hPtZ2_5", 12) == 0){  
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 0, 200, 5E-5, 5E5, 10, "GeV", "Z2 pT (GeV)", "");
  }
  if (strncmp(histlabel, "hpt4l_CR", 12) == 0){  
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 0, 500, 5E-5, 5E5, 10, "GeV", "4l pT (GeV)", "");
  }
  if (strncmp(histlabel, "hNgood_CR", 12) == 0){  
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 4, 10, 5E-5, 5E5, 1, "", "Ngood", "");
  }
  if (strncmp(histlabel, "hNbjets_CR", 12) == 0){  
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 0, 10, 5E-5, 5E5, 1, "", "Nbjets", "");
  }

  if (strncmp(histlabel, "hYZ1_5", 12) == 0 || strncmp(histlabel, "hYZ2_5", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -2.5, 2.5, 5E-5, 5E7, 10, "", "Z2 #eta", "");
  }
  //if (strncmp(histlabel, "hPhiLep_3", 12 == 0){
  //  varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, true, -2.5, 2.5, 1E-1, 1E8, 10, "", "Leading Lepton Eta", "");
 // }

  if (strncmp(histlabel, "hIsoLep_0", 12) == 0 || strncmp(histlabel, "hIsoLep_3", 12) == 0 || strncmp(histlabel, "hIsoLep1_5", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 0., 0.35, 5E-6, 8E10, 5, "", "Lepton Iso", "");
  }

  if (strncmp(histlabel, "hSipLep_0", 12) == 0 || strncmp(histlabel, "hSipLep_3", 12) == 0 || strncmp(histlabel, "hSipLep1_5", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -4., 4., 5E-3, 2E9, 10, "", "Lepton Sip", "");
  }

  if (strncmp(histlabel, "hPFMET_3", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 4.5, 499, 5E-5, 2E8, 10, "GeV", "PFMET (GeV)", "");
  }

  if (strncmp(histlabel, "hPFMET_7", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 4.5, 499, 5E-5, 2E8, 10, "GeV", "PFMET (GeV)", "");
  }

  if (strncmp(histlabel, "hPFMET_8", 12) == 0 || strncmp(histlabel, "hmet_SM", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 4.5, 499, 5E-5, 2E3, 5, "GeV", "PFMET (GeV)", "");
  }

  if (strncmp(histlabel, "hmet_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 4.5, 499, 5E-6, 2E4, 5, "GeV", "PFMET (GeV)", "");
  }

  if (strncmp(histlabel, "hmet_phi_SM", 12) == 0){
    cout << "test" << endl;
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -3.5, 3.5, 1E-1, 1E8, 10, "", "MET Phi", "");
  }

  if (strncmp(histlabel, "hMZ_3", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 40., 120., 1E-5, 2E8, 5, "GeV", "Z_{ll} Mass (GeV)", "");
  }

  if (strncmp(histlabel, "hMZ1_5", 12) == 0 || strncmp(histlabel, "hMZ1_8", 12) == 0 || strncmp(histlabel, "hZ1mass_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 40., 120., 1E-5, 2E6, 5, "GeV", "Z_{ll} Mass (GeV)", "");
  }

  if (strncmp(histlabel, "hMZ2_5", 12) == 0 || strncmp(histlabel, "hMZ2_8", 12) == 0 || strncmp(histlabel, "hZ2mass_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, 10., 120., 1E-5, 2E6, 5, "GeV", "Z_{ll} Mass (GeV)", "");
  }
  
  if (strncmp(histlabel, "hM4l_5", 12) == 0 || strncmp(histlabel, "hM4l_8", 12) == 0 || strncmp(histlabel, "hmass4l_CR", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, true, true, 75, 1204.5, 5E-5, 7E4, 10, "GeV", "M(llll) (GeV)", "_log");
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, true, false, 70, 170, 0, 60, 4, "GeV", "M(llll) (GeV)", "_linear");
  }

  if (strncmp(histlabel, "hmaxdphi_jet_met_zsel", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -0.2, 3.5, 5E-1, 9E3, 1, "", "max|#Delta#phi(j,MET)|", "");
  }

  if (strncmp(histlabel, "hmindphi_jet_met_zsel", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -0.2, 3.5, 5E-1, 5E3, 1, "", "min|#Delta#phi(j,MET)|", "");
  }

  if (strncmp(histlabel, "hdphi_jet1_met_zsel", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -0.2, 3.5, 5E-1, 5E3, 1, "", "|#Delta#phi(j1,MET)|", "");
  }

  if (strncmp(histlabel, "hDPHI_MAX_JET_MET_8", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -0.1, 3.2, 5E-5, 5E3, 20, "", "max|#Delta#phi(j,MET)|", "");
  }

  if (strncmp(histlabel, "hDPHI_MIN_JET_MET_8", 12) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, false, true, -0.1, 3.2, 5E-5, 5E2, 20, "", "min|#Delta#phi(j,MET)|", "");
  }
/*
root -b -q -l "mkplots_AN.C(\"hjet1_pt_zsel\")"
root -b -q -l "mkplots_AN.C(\"hjet1_phi_zsel\")"
root -b -q -l "mkplots_AN.C(\"hdphi_jet1_met_zsel\")"
*/

}
