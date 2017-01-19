// -----------------------------------------------------------------------------
//  File:        ratioplots.C
//  Usage:       root -b -q -l "ratioplots.C(\"hPFMET_R\")"
//  Description: Macro for comparing two distributions
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

  // Normalize to 1
  h_rebin->Scale(1/h->Integral());

  cout << "Integral of " << legtag << " " << h_rebin->Integral() << endl;
  return h_rebin;
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


void varPlot(std::vector<string> _datanames1, std::vector<string> _bkgnames1, std::vector<string> _sig6001, std::vector<string> _sig8001, std::vector<string> _sig10001, std::vector<string> _sig12001, std::vector<string> _sig14001, std::vector<string> _sig17001, std::vector<string> _sig20001, std::vector<string> _sig25001, std::vector<string> _datanames2, std::vector<string> _bkgnames2, std::vector<string> _sig6002, std::vector<string> _sig8002, std::vector<string> _sig10002, std::vector<string> _sig12002, std::vector<string> _sig14002, std::vector<string> _sig17002, std::vector<string> _sig20002, std::vector<string> _sig25002, const char * histlabel, bool logy, double xmin, double xmax, double ymin, double ymax, int nRebin, const char * xlabel){
  
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
  TLegend* leg = new TLegend(0.55, 0.75, 0.95, 0.85);
  leg->SetFillStyle(0);
  leg->SetBorderSize(0);
  leg->SetTextSize(0.035);
  leg->Draw("Same");
  TLegend* leg2 = new TLegend(0.42, 0.75, 0.72, 0.88);
  leg2->SetFillStyle(0);
  leg2->SetBorderSize(0);
  leg2->SetTextSize(0.02);
  leg2->Draw("Same");
  
  // Get hists
  TH1     * hbkg1 =  GetHistSum(_bkgnames1,  histlabel, leg,  "M_{llll} side bands", "l", kBlack, kBlack, 1, 0, 1, 1, nRebin);
  TH1     * hbkg2 =  GetHistSum(_bkgnames2,  histlabel, leg,  "M_{llll} peak", "l", kBlue, kBlue, 1, 0, 1, 1, nRebin);
  
  
  // Plot hists
  hbkg1    ->Draw("E2Same");  
  hbkg2    ->Draw("E2Same");  

  // Set up supertext
  TPaveText *ll = new TPaveText(0.1, 0.9, 0.92, 0.94, "NDC");
  ll->SetTextSize(0.032);
  ll->SetTextFont(42);
  ll->SetFillColor(0);
  ll->SetBorderSize(0);
  ll->SetMargin(0.01);
  ll->SetTextAlign(12); // align left
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
  TH1F * pull = GetPull(hbkg1, hbkg2, xmin, xmax, nRebin);
  pull->Draw("E1Same");
  TLine *line = new TLine(xmin,1,xmax,1);
  line->SetLineStyle(7);
  line->Draw("Same");

  // Save plot
  char savename[100];
  sprintf(savename, "plots/hist_%s.png", histlabel);
  c->SaveAs(savename);

}


void ratioplots_13tev(const char* histlabel){
 
  // Read in and sort input files
  std::string inputfile1 = "filelist_2015_Fall15_AN_Bari_M4lBlinded5.txt";
  std::string inputfile2 = "filelist_2015_Fall15_AN_Bari_M4lUnblinded5.txt";
  std::vector<string> _datanames1, _bkgnames1, _sig6001, _sig8001, _sig10001, _sig12001, _sig14001, _sig17001, _sig20001, _sig25001;
  std::ifstream in1;
  in1.open(inputfile1.c_str());
  std::string filename1;
  while(std::getline(in1, filename1)){
    if(filename1.find("Run2015") < 200) _datanames1.push_back(filename1);
    if(filename1.find("13TeV") < 200)   _bkgnames1.push_back(filename1);
    if(filename1.find("MZP600") < 200)  _sig6001.push_back(filename1);
    if(filename1.find("MZP800") < 200)  _sig8001.push_back(filename1);
    if(filename1.find("MZP1000") < 200) _sig10001.push_back(filename1);
    if(filename1.find("MZP1200") < 200) _sig12001.push_back(filename1);
    if(filename1.find("MZP1400") < 200) _sig14001.push_back(filename1);
    if(filename1.find("MZP1700") < 200) _sig17001.push_back(filename1);
    if(filename1.find("MZP2000") < 200) _sig20001.push_back(filename1);
    if(filename1.find("MZP2500") < 200) _sig25001.push_back(filename1);
  }
  std::vector<string> _datanames2, _bkgnames2, _sig6002, _sig8002, _sig10002, _sig12002, _sig14002, _sig17002, _sig20002, _sig25002;
  std::ifstream in2;
  in2.open(inputfile2.c_str());
  std::string filename2;
  while(std::getline(in2, filename2)){
    if(filename2.find("Run2015") < 200) _datanames2.push_back(filename2);
    if(filename2.find("13TeV") < 200)   _bkgnames2.push_back(filename2);
    if(filename2.find("MZP600") < 200)  _sig6002.push_back(filename2);
    if(filename2.find("MZP800") < 200)  _sig8002.push_back(filename2);
    if(filename2.find("MZP1000") < 200) _sig10002.push_back(filename2);
    if(filename2.find("MZP1200") < 200) _sig12002.push_back(filename2);
    if(filename2.find("MZP1400") < 200) _sig14002.push_back(filename2);
    if(filename2.find("MZP1700") < 200) _sig17002.push_back(filename2);
    if(filename2.find("MZP2000") < 200) _sig20002.push_back(filename2);
    if(filename2.find("MZP2500") < 200) _sig25002.push_back(filename2);
  }
  
  // Set options for plot depending on selected histogram
  // varPlot(_datanames, _bkgnames, _sig600, histlabel, logy, xmin, xmax, ymin, ymax, nRebin, xlabel);
  
  if (strncmp(histlabel, "hM4l_R", 10) == 0){
    varPlot(_datanames1, _bkgnames1, _sig6001, _sig8001, _sig10001, _sig12001, _sig14001, _sig17001, _sig20001, _sig25001, _datanames2, _bkgnames2, _sig6002, _sig8002, _sig10002, _sig12002, _sig14002, _sig17002, _sig20002, _sig25002, histlabel, true, 110, 140, 5E-5, 5E1, 2, "M(llll) [GeV]");
  }

  if (strncmp(histlabel, "hPFMET_R", 10) == 0){
    varPlot(_datanames1, _bkgnames1, _sig6001, _sig8001, _sig10001, _sig12001, _sig14001, _sig17001, _sig20001, _sig25001, _datanames2, _bkgnames2, _sig6002, _sig8002, _sig10002, _sig12002, _sig14002, _sig17002, _sig20002, _sig25002, histlabel, true, 75, 1000, 5E-9, 2E-2, 10, "PFMET [GeV]");
  }

}
