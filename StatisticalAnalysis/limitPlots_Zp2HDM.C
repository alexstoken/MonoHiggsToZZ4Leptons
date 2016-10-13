// -----------------------------------------------------------------------------
//  File:        limitPlots_Zp2HDM.C
//  Usage:       root -b -q -l "limitPlots_Zp2HDM.C(\"4mu\")"
//  Description: Parse the simple limits file limits_*_13tev_out.txt and plot.
//  Created:     5-July-2016 Dustin Burns
// -----------------------------------------------------------------------------


void limitPlots_Zp2HDM(std::string channel){

// Parse input file, filling arrays for plots
std::ifstream file("limits_"+channel+"_13tev_out.txt");
std::string str;
char delim = ' ';
std::string item;
std::vector<std::string> elems;
static const Int_t n = 8;
//Double_t _mzp[n] = {600, 800, 1000, 1200, 1400};
//Double_t _mzp[n] = {600, 800, 1000, 1200, 1400, 1700};
Double_t _mzp[n] = {600, 800, 1000, 1200, 1400, 1700, 2000, 2500};
Double_t _2siglow[n];
Double_t _1siglow[n];
Double_t _middle[n];
Double_t _1sighigh[n];
Double_t _2sighigh[n];
Double_t _observed[n];
int lin = 0;
while (std::getline(file, str)){
  lin++;
  std::stringstream ss(str);
  Int_t i = -1;
  while (std::getline(ss, item, delim)){
    i++;
    elems.push_back(item);
    if (lin == 1 && i < n) {
      _2siglow[i] = atof(item.c_str());
    }
    if (lin == 2 && i < n) {
      _1siglow[i] = atof(item.c_str());
    }
    if (lin == 3 && i < n) {
      _middle[i] = atof(item.c_str());
    }
    if (lin == 4 && i < n) {
      _1sighigh[i] = atof(item.c_str());
    }
    if (lin == 5 && i < n) {
      _2sighigh[i] = atof(item.c_str());
    }
    if (lin == 6 && i < n) {
      _observed[i] = atof(item.c_str());
    }
  }
}


// Scale signal strength limits by signal production cross sections
//Double_t _xsec[n] = {0.000124120665, 0.000076214925, 0.000039481335, 0.0000207112995, 0.000011311596};
//Double_t _xsec[n] = {0.000124120665, 0.000076214925, 0.000039481335, 0.0000207112995, 0.000011311596, 0.000004882257};
Double_t _xsec[n] = {0.000124120665*1E3, 0.000076214925*1E3, 0.000039481335*1E3, 0.0000207112995*1E3, 0.000011311596*1E3, 0.000004882257*1E3, 0.00000225960165*1E3, 0.0000006988221*1E3};
Double_t _scale[n] = {1, 1, 1, 1, 1, 1, 1E1, 1E1}; 
BR = 1.25E-04;
FB_TO_PB = 1E3;
for(int i=0;i<n;i++){
  _2siglow[i]  *= _xsec[i] * _scale[i];
  _1siglow[i]  *= _xsec[i] * _scale[i];
  _middle[i]   *= _xsec[i] * _scale[i];
  _1sighigh[i] *= _xsec[i] * _scale[i];
  _2sighigh[i] *= _xsec[i] * _scale[i];
  _observed[i] *= _xsec[i] * _scale[i];
}
cout << _middle[0] << " " << _middle[7] << endl;


// Fill graphs
TGraph *g2siglow  = new TGraph(n, _mzp, _2siglow);
TGraph *g1siglow  = new TGraph(n, _mzp, _1siglow);
TGraph *gmiddle   = new TGraph(n, _mzp, _middle);
TGraph *g1sighigh = new TGraph(n, _mzp, _1sighigh);
TGraph *g2sighigh = new TGraph(n, _mzp, _2sighigh);
TGraph *gobserved = new TGraph(n, _mzp, _observed);
TGraph *gxsec     = new TGraph(n, _mzp, _xsec);
TGraph *grshade1   = new TGraph(2*n);
TGraph *grshade2   = new TGraph(2*n);
for(i=0;i<n;i++){
  grshade1->SetPoint(i, _mzp[i], _1sighigh[i]);
  grshade1->SetPoint(n+i, _mzp[n-i-1], _1siglow[n-i-1]);
}
for(i=0;i<n;i++){
  grshade2->SetPoint(i, _mzp[i], _2sighigh[i]);
  grshade2->SetPoint(n+i, _mzp[n-i-1], _2siglow[n-i-1]);
}

// Plot formatting
gStyle->SetOptStat(0);
TCanvas *c = new TCanvas("c");
c->cd();
//c->SetLogx();
c->SetLogy();
c->SetTicks(1,1);
c->SetGrid();
TH2F * hframe = new TH2F("hframe", "", 10, 600, 2500, 10, 5E-4, 5E4);
hframe->GetXaxis()->SetTitle("m_{Z'} [GeV]");
hframe->GetXaxis()->SetTitleOffset(1.0);
hframe->GetXaxis()->SetTitleSize(0.04);
if (strncmp(channel.c_str(), "4mu", 10) == 0) hframe->GetYaxis()->SetTitle("95% C.L. #sigma(pp #rightarrow Z' #rightarrow A_{0}H #rightarrow #chi #chi #mu#mu#mu#mu) [fb]");
if (strncmp(channel.c_str(), "4e", 10) == 0) hframe->GetYaxis()->SetTitle("95% C.L. #sigma(pp #rightarrow Z' #rightarrow A_{0}H #rightarrow #chi #chi eeee) [fb]");
if (strncmp(channel.c_str(), "2e2mu", 10) == 0) hframe->GetYaxis()->SetTitle("95% C.L. #sigma(pp #rightarrow Z' #rightarrow A_{0}H #rightarrow #chi #chi ee#mu#mu) [fb]");
if (strncmp(channel.c_str(), "4l", 10) == 0) hframe->GetYaxis()->SetTitle("95% C.L. #sigma(pp #rightarrow Z' #rightarrow A_{0}H #rightarrow #chi #chi llll) [fb]");
hframe->GetYaxis()->SetTitleOffset(1.0);
hframe->GetYaxis()->SetTitleSize(0.04);
hframe->Draw();
grshade2->SetFillColor(5);
grshade2->Draw("f");
grshade1->SetFillColor(3);
grshade1->Draw("f");
gmiddle->SetLineWidth(2);
gmiddle->SetLineStyle(2);
gmiddle->Draw("l");
gobserved->SetLineWidth(2);
gobserved->Draw("l");
gxsec->SetLineWidth(2);
gxsec->SetLineColor(kBlue);
gxsec->SetLineStyle(2);
gxsec->Draw("l");


// Legend formatting
TLegend *leg = new TLegend(0.5,0.65,0.85,0.85);
leg->SetFillStyle(0);
leg->SetBorderSize(0);
leg->AddEntry(gxsec, "Z'2HDM g_{Z}=0.8", "L");
leg->AddEntry(gmiddle, "Expected limit", "L");
leg->AddEntry(grshade1, "#pm 1 #sigma", "F");
leg->AddEntry(grshade2, "#pm 2 #sigma", "F");
leg->AddEntry(gobserved, "Observed limit", "L");
leg->SetTextSize(0.04);
leg->Draw();


// Text formatting
TPaveText *ll = new TPaveText(0.10, 0.92, 0.92, 0.92, "NDC");
ll->SetTextSize(0.04);
ll->SetTextFont(42);
ll->SetFillColor(0);
ll->SetBorderSize(0);
ll->SetMargin(0.01);
ll->SetTextAlign(12); // align left
TString text = "#font[22]{CMS} #font[12]{Preliminary}";
ll->AddText(0.01,0.5,text);
text = "#sqrt{s} = 13 TeV, L = 2.8 fb^{-1}" ;
ll->AddText(0.65, 0.6, text);
ll->Draw();


// Save plot
char save[50];
sprintf(save, "plots/sigma_limits_%s.png", channel.c_str());
c->SaveAs(save);
}
