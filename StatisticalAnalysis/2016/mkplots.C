// -----------------------------------------------------------------------------
//  File:        mkplots.C
//  Usage:       root -b -q -l "mkplots.C(\"hPFMET_8\")"
//  Description: Macro for generating kinematic plots for MonoHiggsToZZ4Leptons analysis
//  Created:     18-Jan-2017 Dustin Burns
// -----------------------------------------------------------------------------


TH1 * GetHistSum(std::vector<string> _names, const char * histlabel, TLegend * leg, const char * legtag, const char * legstyle, int fillcolor, int linecolor, int linestyle, int fillstyle, int marker, int linewidth, int nRebin){
  
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
  h->SetMarkerSize(1);
  h->SetFillStyle(fillstyle);
  h->SetFillColor(fillcolor);
  h->SetLineColor(linecolor);   
  h->SetLineStyle(linestyle);
  h->SetLineWidth(linewidth);
  if (leg) leg->AddEntry(h, legtag, legstyle);

  // Rebinning 
  TH1 * h_rebin = h->Rebin(nRebin, histlabel);

  cout << "Integral of " << legtag << " " << h_rebin->Integral() << endl;
  return h_rebin;
}


THStack * GetBkgStack(std::vector<string> _bkgnames, const char * histlabel, TLegend * leg, int nRebin){

  // Set up stack 
  THStack * stack = new THStack(histlabel, "");
  TFile *f = TFile::Open(_bkgnames.at(0).c_str());
  TH1F * h_base = (TH1F *)f->Get(histlabel);
  stack->SetHistogram(h_base);

  // Sort bkgs into lists for 3 decay modes
  std::vector<string> _DYJetsToLL, _GluGluHToZZTo4L, _GluGluToZZ, _QCD, _T, _TT, _VBF_HToZZTo4L, _WJetsToLNu, _WWTo2L2Nu, _WW, _WZ, _WH, _ZH, _ZZTo4L, _ttH;
  for(int i=0; i<_bkgnames.size(); i++){
    //if(_bkgnames.at(i).find("DYJetsToLL") < 200)    _DYJetsToLL.push_back(_bkgnames.at(i));
    if(_bkgnames.at(i).find("GluGluHToZZTo4L") < 200) _GluGluHToZZTo4L.push_back(_bkgnames.at(i));
    if(_bkgnames.at(i).find("GluGluToZZ") < 200)      _GluGluToZZ.push_back(_bkgnames.at(i));
    //if(_bkgnames.at(i).find("QCD") < 200)           _QCD.push_back(_bkgnames.at(i));
    //if(_bkgnames.at(i).find("ST") < 200)            _T.push_back(_bkgnames.at(i));
    if(_bkgnames.at(i).find("TTTo2L2Nu") < 200)       _TT.push_back(_bkgnames.at(i));
    if(_bkgnames.at(i).find("VBF_HToZZTo4L") < 200)   _VBF_HToZZTo4L.push_back(_bkgnames.at(i));
    //if(_bkgnames.at(i).find("WJetsToLNu") < 200)    _WJetsToLNu.push_back(_bkgnames.at(i));
    //if(_bkgnames.at(i).find("WWTo2L2Nu") < 200)     _WWTo2L2Nu.push_back(_bkgnames.at(i));
    //if(_bkgnames.at(i).find("WZ") < 200)            _WZ.push_back(_bkgnames.at(i));
    if(_bkgnames.at(i).find("WminusH") < 200)         _WH.push_back(_bkgnames.at(i));
    if(_bkgnames.at(i).find("WplusH") < 200)          _WH.push_back(_bkgnames.at(i));
    if(_bkgnames.at(i).find("ZH") < 200)              _ZH.push_back(_bkgnames.at(i));
    if(_bkgnames.at(i).find("_ZZTo4L") < 200)         _ZZTo4L.push_back(_bkgnames.at(i));
    if(_bkgnames.at(i).find("ttH") < 200)             _ttH.push_back(_bkgnames.at(i));
  }

  // Get hist sums for bkg lists
  //TH1 * hDYJetsToLL      = GetHistSum(_DYJetsToLL,      histlabel, leg, "DYJetsToLL",      "f", kOrange, kBlack, 1, 1001, 0, 1, nRebin);
  TH1 * hGluGluHToZZTo4L = GetHistSum(_GluGluHToZZTo4L, histlabel, leg, "GluGluHToZZTo4L", "f", kRed, kBlack, 1, 1001, 0, 1, nRebin);
  TH1 * hGluGluToZZ      = GetHistSum(_GluGluToZZ,      histlabel, leg, "GluGluToZZ",      "f", kCyan+3, kBlack, 1, 1001, 0, 1, nRebin);
  //TH1 * hQCD             = GetHistSum(_QCD,             histlabel, leg, "QCD",             "f", kRed+2, kBlack, 1, 1001, 0, 1, nRebin);
  //TH1 * hT               = GetHistSum(_T,               histlabel, leg, "T",               "f", kViolet, kBlack, 1, 1001, 0, 1, nRebin);
  TH1 * hTT              = GetHistSum(_TT,              histlabel, leg, "TTTo2L2Nu",       "f", kBlue+3, kBlack, 1, 1001, 0, 1, nRebin);
  TH1 * hVBF_HToZZTo4L   = GetHistSum(_VBF_HToZZTo4L,   histlabel, leg, "VBF_HToZZTo4L",   "f", kAzure, kBlack, 1, 1001, 0, 1, nRebin);
  //TH1 * hWJetsToLNu      = GetHistSum(_WJetsToLNu,      histlabel, leg, "WJetsToLNu",      "f", kCyan, kBlack, 1, 1001, 0, 1, nRebin);
  //TH1 * hWWTo2L2Nu       = GetHistSum(_WWTo2L2Nu,       histlabel, leg, "WWTo2L2Nu",       "f", kTeal+2, kBlack, 1, 1001, 0, 1, nRebin);
  //TH1 * hWZ              = GetHistSum(_WZ,              histlabel, leg, "WZ",              "f", kSpring, kBlack, 1, 1001, 0, 1, nRebin);
  TH1 * hWH              = GetHistSum(_WH,              histlabel, leg, "WH",              "f", kYellow, kBlack, 1, 1001, 0, 1, nRebin);
  TH1 * hZH              = GetHistSum(_ZH,              histlabel, leg, "ZH",              "f", kYellow+2, kBlack, 1, 1001, 0, 1, nRebin);
  TH1 * hZZTo4L          = GetHistSum(_ZZTo4L,          histlabel, leg, "ZZTo4L",          "f", kGray, kBlack, 1, 1001, 0, 1, nRebin);
  TH1 * httH             = GetHistSum(_ttH,             histlabel, leg, "ttH",             "f", kMagenta+2, kBlack, 1, 1001, 0, 1, nRebin);

  // Fill HistInt structs for sorting hists by integral
  struct HistInt { TH1 *Hist; float integral;};
  struct by_integral { bool operator()(HistInt const &a, HistInt const &b) { return a.integral < b.integral; } };
  std::vector<HistInt> HistInts;
  HistInt DYJetsToLL, GluGluHToZZTo4L, GluGluToZZ, QCD, T, TT, VBF_HToZZTo4L, WJetsToLNu, WWTo2L2Nu, WW, WZ, WH, ZH, ZZTo4L, ttH, ZH_ll;
  //DYJetsToLL.Hist      = hDYJetsToLL;      DYJetsToLL.integral      = hDYJetsToLL->Integral(); 
  GluGluHToZZTo4L.Hist = hGluGluHToZZTo4L; GluGluHToZZTo4L.integral = hGluGluHToZZTo4L->Integral();
  GluGluToZZ.Hist      = hGluGluToZZ;      GluGluToZZ.integral      = hGluGluToZZ->Integral();
  //QCD.Hist             = hQCD;             QCD.integral             = hQCD->Integral();
  //T.Hist               = hT;               T.integral               = hT->Integral();
  TT.Hist              = hTT;              TT.integral              = hTT->Integral();
  VBF_HToZZTo4L.Hist   = hVBF_HToZZTo4L;   VBF_HToZZTo4L.integral   = hVBF_HToZZTo4L->Integral();
  //WJetsToLNu.Hist      = hWJetsToLNu;      WJetsToLNu.integral      = hWJetsToLNu->Integral();
  //WWTo2L2Nu.Hist       = hWWTo2L2Nu;       WWTo2L2Nu.integral       = hWWTo2L2Nu->Integral();
  //WZ.Hist              = hWZ;              WZ.integral              = hWZ->Integral();
  WH.Hist              = hWH;              WH.integral              = hWH->Integral();
  ZH.Hist              = hZH;              ZH.integral              = hZH->Integral();
  ZZTo4L.Hist          = hZZTo4L;          ZZTo4L.integral          = hZZTo4L->Integral();
  ttH.Hist             = httH;             ttH.integral             = httH->Integral();
  //HistInts.push_back(DYJetsToLL);
  HistInts.push_back(GluGluHToZZTo4L);
  HistInts.push_back(GluGluToZZ);
  //HistInts.push_back(QCD);
  //HistInts.push_back(T);
  HistInts.push_back(TT);
  HistInts.push_back(VBF_HToZZTo4L);
  //HistInts.push_back(WJetsToLNu);
  //HistInts.push_back(WWTo2L2Nu);
  //HistInts.push_back(WZ);
  HistInts.push_back(WH);
  HistInts.push_back(ZH);
  HistInts.push_back(ZZTo4L);
  HistInts.push_back(ttH);
  std::sort(HistInts.begin(), HistInts.end(), by_integral());

  // Build stack in ascending order of integrals
  for(int i=0; i<HistInts.size(); i++) {
    stack->Add(HistInts.at(i).Hist);
  }
  
  return stack;
}


TH1F * GetPull(TH1 * hdata, TH1 * hbkg, double xmin, double xmax, int nRebin){
 
  // Set up ratio hist 
  TH1F *pull = new TH1F("pull", "", hdata->GetNbinsX(), hdata->GetXaxis()->GetXmin(), hdata->GetXaxis()->GetXmax());
  
  // Fill ratio bins and errors
  for (int n=1; n<=hdata->GetNbinsX(); n++){
  Float_t d = hdata->GetBinContent(n);
  Float_t b = hbkg ->GetBinContent(n);
  Float_t eb = hbkg ->GetBinError(n);
    if (b > 0. && d > 0.) {
      pull->SetBinContent(n, double(d/b));
      pull->SetBinError(n, double(d/b * sqrt( 1/d + eb*eb/(b*b) )));
    }
  }

  // Formatting
  pull->SetLineColor(kBlack);   
  pull->SetMarkerStyle(20);
  pull->SetMarkerSize(0.95);
  pull->SetMarkerColor(kBlack);
  
  return pull;
}


void varPlot(std::vector<string> _datanames, std::vector<string> _bkgnames, std::vector<string> _sig2HDM600, std::vector<string> _sig2HDM1200, std::vector<string> _sig2HDM2000, std::vector<string> _sigZpB10, const char * histlabel, bool logy, double xmin, double xmax, double ymin, double ymax, int nRebin, const char * xlabel){
  
  // Set up canvas
  gStyle->SetOptStat(0);
  TCanvas * c = new TCanvas("c", "", 600, 800);
  c->SetTicks(1,1); 
  if (logy) c->SetLogy();
  //c->SetLogx();
  c->SetLeftMargin(0.12); 

  // Set up hframe for hists
  TH2F *hframe = new TH2F("hframe", "", 100, xmin, xmax, 500, ymin, ymax);
  char ylabel[50];
  sprintf(ylabel, "Events / %d GeV", nRebin); 
  hframe->SetYTitle(ylabel);
  hframe->GetYaxis()->SetLabelSize(0.035);
  hframe->GetYaxis()->SetTitleSize(0.04);
  hframe->GetXaxis()->SetLabelOffset(999);
  hframe->GetYaxis()->SetLabelOffset(0.007);
  hframe->GetYaxis()->SetTitleOffset(1.35);
  hframe->Draw("Same");

  // Set up legends
  TLegend* leg = new TLegend(0.65, 0.65, 0.95, 0.86);
  leg->SetFillStyle(0);
  leg->SetBorderSize(0);
  leg->SetTextSize(0.02);
  leg->Draw("Same");
  TLegend* leg2 = new TLegend(0.32, 0.8, 0.64, 0.86);
  leg2->SetFillStyle(0);
  leg2->SetBorderSize(0);
  leg2->SetTextSize(0.02);
  leg2->Draw("Same");
  
  // Get bkg stack
  THStack * sbkg =  GetBkgStack(_bkgnames, histlabel, leg, nRebin);
  TH1     * hbkg =  GetHistSum(_bkgnames,  histlabel, NULL,  "Background Error", "f", kBlack, kBlack, 1, 0, 1, 1, nRebin);
  hbkg->SetFillStyle(3002);
  hbkg->SetFillColor(kGray+2);
  
  // Get sum of hists for 3 decay channels for signals and data
  TH1 * hdata    = GetHistSum(_datanames, histlabel, leg,  "Data",              "l", kBlack, kBlack, 1, 0, 20, 1, nRebin);
  TH1 * hsig2HDM600  = GetHistSum(_sig2HDM600,    histlabel, leg2, "Zp2HDM m_{Z'} = 600 GeV",  "l", kBlack, kRed, 1, 0, 1, 2,   nRebin);
  TH1 * hsig2HDM1200 = GetHistSum(_sig2HDM1200,   histlabel, leg2, "Zp2HDM m_{Z'} = 1200 GeV", "l", kBlack, kRed+3, 1, 0, 1, 2, nRebin);
  TH1 * hsig2HDM2000 = GetHistSum(_sig2HDM2000,   histlabel, leg2, "Zp2HDM m_{Z'} = 2000 GeV", "l", kBlack, kRed-6, 1, 0, 1, 2, nRebin);
  TH1 * hsigZpB10 = GetHistSum(_sigZpB10,   histlabel, leg2, "ZpBaryonic m_{Z'} = 10 GeV", "l", kBlack, kGreen, 1, 0, 1, 2, nRebin);
 
  // Plot hists
  sbkg    ->Draw("HSame");
  hdata   ->Draw("E1PSame");
  hsig2HDM600 ->Draw("Same");
  hsig2HDM1200->Draw("Same");
  hsig2HDM2000->Draw("Same");
  hsigZpB10   ->Draw("Same");
  //hbkg    ->Draw("E2Same");  

  // Set up supertext
  TPaveText *ll = new TPaveText(0.1, 0.9, 0.92, 0.94, "NDC");
  ll->SetTextSize(0.032);
  ll->SetTextFont(42);
  ll->SetFillColor(0);
  ll->SetBorderSize(0);
  ll->SetMargin(0.01);
  ll->SetTextAlign(12); // align left
  //TString text = "Work in Progress";
  TString text = "#font[22]{CMS} #font[12]{Preliminary}";
  ll->AddText(0.01,0.5,text);
  text = "#sqrt{s} = 13 TeV, L = 36.5 fb^{-1}" ;
  ll->AddText(0.58, 0.6, text);
  ll->Draw("Same"); 

  // Set up pad for ratio plot
  double canvasratio = 0.2;
  c->SetBottomMargin(canvasratio + (1-canvasratio)*c->GetBottomMargin()-canvasratio*c->GetTopMargin());
  canvasratio = 0.2;
  TPad *ratioPad = new TPad("ratioPad","",0,0,1,1);
  ratioPad->SetTopMargin((1-canvasratio) - (1-canvasratio)*ratioPad->GetBottomMargin()+canvasratio*ratioPad->GetTopMargin());
  ratioPad->SetFillStyle(4000);
  ratioPad->SetFillColor(4000);
  ratioPad->SetFrameFillColor(4000);
  ratioPad->SetFrameFillStyle(4000);
  ratioPad->SetFrameBorderMode(0);
  ratioPad->SetTicks(1,1);
  ratioPad->SetLeftMargin(0.12);
  //ratioPad->SetLogx();
  ratioPad->Draw();
  ratioPad->cd();

  // Set up hframe for ratio plot
  TH2F *hframe2= new TH2F("hframe2","",100, xmin, xmax, 500, 0., 2.);
  hframe2->GetYaxis()->SetLabelSize(0.035);
  hframe2->GetXaxis()->SetLabelSize(0.035);
  hframe2->SetXTitle(xlabel);
  hframe2->SetYTitle("Data/MC");
  hframe2->GetYaxis()->SetNdivisions(503);
  hframe2->GetXaxis()->SetLabelOffset(0.007);
  hframe2->GetXaxis()->SetTitleOffset(1.0);
  hframe2->GetYaxis()->SetLabelOffset(0.007);
  hframe2->GetYaxis()->SetTitleOffset(1.35);
  hframe2->GetXaxis()->SetTitleSize(0.04);
  hframe2->GetYaxis()->SetTitleSize(0.04);
  hframe2->Draw();

  // Get ratio plot
  TH1F * pull = GetPull(hdata, hbkg, xmin, xmax, nRebin);
  pull->Draw("E1Same");
  TH1F * bkgerr = new TH1F("bkgerr", "", hdata->GetNbinsX(), hdata->GetXaxis()->GetXmin(), hdata->GetXaxis()->GetXmax());
  for (int n=1; n<=hdata->GetNbinsX(); n++){
  Float_t d = hdata->GetBinContent(n);
  Float_t b = hbkg ->GetBinContent(n);
    if (b > 0.) {
      bkgerr->SetBinContent(n, double(d/b));
      bkgerr->SetBinError(n, d/hbkg->GetBinError(n));
    }
  }
  bkgerr->SetFillStyle(3002);
  bkgerr->SetFillColor(kGray+2);
  //bkgerr->Draw("E2Same");
  TLine *line = new TLine(xmin,1,xmax,1);
  line->SetLineStyle(7);
  line->Draw("Same");

  // Save plot
  char savename[100];
  sprintf(savename, "plots/hist_%s.png", histlabel);
  c->SaveAs(savename);

}


void mkplots(const char* histlabel){
 
  // Read in and sort input files
  std::string inputfile = "filelist_4l_2016_Spring16_AN_lxplus.txt";
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
  // varPlot( _datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, logy, xmin, xmax, ymin, ymax, nRebin, xlabel){

  if (strncmp(histlabel, "hPFMET_3", 10) == 0 || strncmp(histlabel, "hPFMET_8", 10) == 0){
    varPlot(_datanames, _bkgnames, _sig2HDM600, _sig2HDM1200, _sig2HDM2000, _sigZpB10, histlabel, true, 4.5, 1000, 5E-5, 2E4, 10, "PFMET [GeV]");
  }

}
