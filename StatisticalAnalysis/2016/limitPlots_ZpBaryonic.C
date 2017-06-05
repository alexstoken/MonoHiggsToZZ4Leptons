// -----------------------------------------------------------------------------
//  File:        limitPlots_Zp2HDM.C
//  Usage:       root -b -q -l "limitPlots_Zp2HDM.C(\"4mu\")"
//  Description: Parse the simple limits file limits_*_13tev_out.txt and plot.
//  Created:     5-July-2016 Dustin Burns
// -----------------------------------------------------------------------------


void limitPlots_ZpBaryonic(std::string channel){

// Parse input file, filling arrays for plots
std::ifstream file("limits_ZpBaryonic_"+channel+"_out.txt");
std::string str;
char delim = ' ';
std::string item;
std::vector<std::string> elems;
static const Int_t n = 10;
//Double_t _mzp[n] = {600, 800, 1000, 1200, 1400};
//Double_t _mzp[n] = {600, 800, 1000, 1200, 1400, 1700};
//Double_t _mzp[n] = {600, 800, 1000, 1200, 1400, 1700, 2000, 2500};
Double_t _mzp[n] = {10, 20, 50, 100, 200, 300, 500, 1000, 2000, 10000};
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
//cout << _middle[8] << " " << _middle[9] << endl;

/*Double_t _2siglow[n] = {1.0927, 1.2740, 1.1754, 1.0960, 1.2360, 1.2880, 1.8831, 6.1985, 70.9080};
Double_t _1siglow[n] = {1.6067, 1.8781, 1.7213, 1.5977, 1.8248, 1.8968, 2.8525, 9.8906, 116.8418};
Double_t _middle[n] = {2.5547, 2.9922, 2.7109, 2.5391, 2.9297, 3.0391, 4.7031, 17.0625, 209.2500};
Double_t _1sighigh[n] = {4.2043, 4.8767, 4.4183, 4.1382, 4.7981, 5.0015, 7.8901, 29.9848, 377.7340};
Double_t _2sighigh[n] = {6.5154, 7.5485, 6.7792, 6.4054, 7.4636, 7.7508, 12.6486, 49.3182, 634.2786};
Double_t _observed[n] = {3.0844, 3.2660, 2.8630, 2.8059, 3.4143, 3.7321, 6.4678, 25.2007, 299.1800, 385543.4955};*/
// Scale signal strength limits by signal production cross sections
//Double_t _xsec[n] = {0.000124120665, 0.000076214925, 0.000039481335, 0.0000207112995, 0.000011311596};
//Double_t _xsec[n] = {0.000124120665, 0.000076214925, 0.000039481335, 0.0000207112995, 0.000011311596, 0.000004882257};
//Double_t _xsec[n] = {0.000124120665*1E3, 0.000076214925*1E3, 0.000039481335*1E3, 0.0000207112995*1E3, 0.000011311596*1E3, 0.000004882257*1E3, 0.00000225960165*1E3, 0.0000006988221*1E3};
BR = 2.745E-04;
PBtoFB = 1E3;
//Double_t _xsec[n] = {0.45217*BR*PBtoFB, 0.27765*BR*PBtoFB, 0.14383*BR*PBtoFB, 0.075451*BR*PBtoFB, 0.041208*BR*PBtoFB, 0.017786*BR*PBtoFB, 0.0082317*BR*PBtoFB, 0.0025458*BR*PBtoFB};
//Double_t _xsec[n] = {BR*PBtoFB, BR*PBtoFB, BR*PBtoFB, BR*PBtoFB, BR*PBtoFB, BR*PBtoFB, BR*PBtoFB, BR*PBtoFB};
Double_t _xsec[n] = {2.59475200139*BR*PBtoFB, 2.72240963862*BR*PBtoFB, 3.25607022875*BR*PBtoFB, 3.18024514561*BR*PBtoFB, 2.5517404181*BR*PBtoFB, 2.26717461494*BR*PBtoFB, 1.09367084934*BR*PBtoFB, 0.201769753605*BR*PBtoFB, 0.0139348225665*BR*PBtoFB, 1.19161364309e-08*BR*PBtoFB};
//Double_t _xsec[n] = {2.59475200139*BR*PBtoFB, 2.72240963862*BR*PBtoFB, 3.25607022875*BR*PBtoFB, 3.18024514561*BR*PBtoFB, 2.5517404181*BR*PBtoFB, 2.26717461494*BR*PBtoFB, 1.09367084934*BR*PBtoFB, 0.201769753605*BR*PBtoFB, 0.0139348225665*BR*PBtoFB*1000, 1.19161364309e-08*BR*PBtoFB};
Double_t _xsecth[n] = {2.59475200139*BR*PBtoFB, 2.72240963862*BR*PBtoFB, 3.25607022875*BR*PBtoFB, 3.18024514561*BR*PBtoFB, 2.5517404181*BR*PBtoFB, 2.26717461494*BR*PBtoFB, 1.09367084934*BR*PBtoFB, 0.201769753605*BR*PBtoFB, 0.0139348225665*BR*PBtoFB, 1.19161364309e-08*BR*PBtoFB};
//Double_t _xsec[n] = {BR*PBtoFB, BR*PBtoFB, BR*PBtoFB, BR*PBtoFB, BR*PBtoFB, BR*PBtoFB, BR*PBtoFB, BR*PBtoFB, BR*PBtoFB, BR*PBtoFB};
//Double_t _xsec[n] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1};
for(int i=0;i<n;i++){
  _2siglow[i]  *= _xsec[i];
  _1siglow[i]  *= _xsec[i];
  _middle[i]   *= _xsec[i];
  _1sighigh[i] *= _xsec[i];
  _2sighigh[i] *= _xsec[i];
  _observed[i] *= _xsec[i];
}
cout << "Baryonic " << _middle[0] << endl;
//cout << "LIMS: " << _middle[0] << " " << _middle[1] << " " << _middle[2] << " " << _middle[3] << " " << _middle[4] << " " << _middle[5] << " " << _middle[6] << " " << _middle[7] << " " << _middle[8] << " " << _middle[9] << endl;


// Fill graphs
TGraph *g2siglow  = new TGraph(n, _mzp, _2siglow);
TGraph *g1siglow  = new TGraph(n, _mzp, _1siglow);
TGraph *gmiddle   = new TGraph(n, _mzp, _middle);
TGraph *g1sighigh = new TGraph(n, _mzp, _1sighigh);
TGraph *g2sighigh = new TGraph(n, _mzp, _2sighigh);
TGraph *gobserved = new TGraph(n, _mzp, _observed);
TGraph *gxsec     = new TGraph(n, _mzp, _xsecth);
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

// Write to file
TFile * fout   = new TFile("ZZ_plots_theoryxsec.root", "recreate");
g2siglow->Write("g2siglow");
g1siglow->Write("g1siglow");
gmiddle->Write("gmiddle");
g1sighigh->Write("g1sighigh");
g2sighigh->Write("g2sighigh");

// Plot formatting
gStyle->SetOptStat(0);
TCanvas *c = new TCanvas("c");
c->cd();
c->SetLogx();
c->SetLogy();
c->SetTicks(1,1);
c->SetGrid();
//TH2F * hframe = new TH2F("hframe", "", 10, 0, 2000, 10, 1E-2, 1E4);
TH2F * hframe = new TH2F("hframe", "", 10, 10, 2000, 10, 5E-4, 2E4);
//hframe->GetXaxis()->SetTitleOffset(1.0);
//hframe->GetXaxis()->SetTitleSize(0.04);

hframe->SetYTitle("95% C.L. #sigma(pp #rightarrow Z'H #rightarrow #chi #chi llll) (fb)");
hframe->GetYaxis()->SetLabelSize(0.035);
hframe->GetYaxis()->SetTitleSize(0.032);
hframe->GetYaxis()->SetLabelOffset(0.007);
hframe->GetYaxis()->SetTitleOffset(1.35);
hframe->GetYaxis()->SetTickLength(0.02);
hframe->GetXaxis()->SetTitle("m_{Z'} (GeV)");
hframe->GetXaxis()->SetLabelSize(0.035);
hframe->GetXaxis()->SetTitleSize(0.032);
hframe->GetXaxis()->SetLabelOffset(0.007);
hframe->GetXaxis()->SetTitleOffset(1.35);
hframe->GetXaxis()->SetTickLength(0.02);
hframe->Draw("Same");

//if (strncmp(channel.c_str(), "4mu", 10) == 0) hframe->GetYaxis()->SetTitle("95% C.L. #sigma(pp #rightarrow Z' #rightarrow A_{0}H #rightarrow #chi #chi #mu#mu#mu#mu) [fb]");
//if (strncmp(channel.c_str(), "4e", 10) == 0) hframe->GetYaxis()->SetTitle("95% C.L. #sigma(pp #rightarrow Z' #rightarrow A_{0}H #rightarrow #chi #chi eeee) [fb]");
//if (strncmp(channel.c_str(), "2e2mu", 10) == 0) hframe->GetYaxis()->SetTitle("95% C.L. #sigma(pp #rightarrow Z' #rightarrow A_{0}H #rightarrow #chi #chi ee#mu#mu) [fb]");
//if (strncmp(channel.c_str(), "4l", 10) == 0) hframe->GetYaxis()->SetTitle("95% C.L. #sigma(pp #rightarrow Z'H #rightarrow #chi #chi llll) [fb]");
//hframe->GetYaxis()->SetTitle("#sigma_{95%CL} / #sigma_{theory}");
//hframe->GetYaxis()->SetTitleOffset(1.0);
//hframe->GetYaxis()->SetTitleSize(0.04);
//hframe->Draw();
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

//gPad->SetFrameLineWidth(2);
//gStyle->SetLineWidth(2);

// Legend formatting
TLegend *leg = new TLegend(0.6,0.65,0.95,0.85);
leg->SetFillStyle(0);
leg->SetBorderSize(0);
leg->AddEntry(gxsec, "Z'Baryonic x BR", "L");
leg->AddEntry(gmiddle, "Expected limit", "L");
leg->AddEntry(grshade1, "#pm 1 #sigma", "F");
leg->AddEntry(grshade2, "#pm 2 #sigma", "F");
leg->AddEntry(gobserved, "Observed limit", "L");
leg->SetTextSize(0.032);
leg->Draw();


// Text formatting
TPaveText *ll = new TPaveText(0.09, 0.9, 0.92, 0.94, "NDC");
ll->SetTextSize(0.032);
ll->SetTextFont(42);
ll->SetFillColor(0);
ll->SetBorderSize(0);
ll->SetMargin(0.01);
ll->SetTextAlign(12);
TString text = "#font[22]{CMS} #font[12]{Preliminary}";
ll->AddText(0.01,0.5,text);
text = "36.5 fb^{-1} (13 TeV)";
ll->AddText(0.79, 0.5, text);
ll->Draw();

// Save plot
char save[50];
sprintf(save, "plots/sigma_limits_%s_ZpBaryonic.png", channel.c_str());
c->SaveAs(save);

//6.4062 7.9062 8.5312 7.7812 7.2188 6.7188 5.0469 3.4766 3.0078 3.4219
//7.9531 8.0938 8.4062 7.9688 3.4531
//6.2031 6.4688 7.1875 6.4688 6.7812 3.4531
//4.0781 4.3281 4.8594 5.2344 3.5469 3.4531
//3.0078 2.9883 3.4219 2.9375 3.5781
//2.9297 2.9141 3.0547 3.6406

/*
Double_t _sig[36] = {6.4062, 7.9062, 8.5312, 7.7812, 7.2188, 6.7188, 5.0469, 3.4766, 3.0078, 3.4219, 7.9531, 8.0938, 8.4062, 7.9688, 3.4531, 6.2031, 6.4688, 7.1875, 6.4688, 6.7812, 3.4531, 4.0781, 4.3281, 4.8594, 5.2344, 3.5469, 3.4531, 3.0078, 2.9883, 3.4219, 2.9375, 3.5781, 2.9297, 2.9141, 3.0547, 3.6406};
for(int i=0;i<36;i++){
  _sig[i]  *= BR*PBtoFB;
}
Double_t _mzp2d[36] = {10, 20, 50, 100, 200, 300, 500, 1000, 2000, 10000, 10, 15, 50, 100, 10000, 10, 50, 95, 200, 300, 10000, 10, 200, 295, 500, 1000, 10000, 10, 500, 995, 2000, 10000, 10, 1000, 1995, 10000};
Double_t _ma0[36] = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10, 10, 10, 50, 50, 50, 50, 50, 50, 150, 150, 150, 150, 150, 150, 500, 500, 500, 500, 500, 1000, 1000, 1000, 1000};

TCanvas *c1 = new TCanvas("c", "", 800, 600);
c1->cd();
c1->SetRightMargin(0.15);
//c1->SetLogz();
   TPad *pad1 = new TPad("pad1","",0,0,1,1);
   TPad *pad2 = new TPad("pad2","",0,0,1,1);
   pad1->SetRightMargin(0.15);
   pad2->SetRightMargin(0.15);
   pad2->SetFillColor(0);
   pad2->SetFillStyle(4000);
   pad2->SetFrameFillStyle(0);

   pad1->Draw();
   pad1->cd();
//TH2F * hframe1 = new TH2F("hframe1", "", 8, 600, 2500, 6, 300, 800);
//TH2F * hframe = new TH2F("hframe", "", 10, 600, 2500, 10, 5E-5, 8E3);
//hframe1->GetXaxis()->SetTitle("m_{Z'} [GeV]");
//hframe1->GetXaxis()->SetTitleOffset(1.0);
//hframe1->GetXaxis()->SetTitleSize(0.04);
TGraph2D *g2d = new TGraph2D(36, _mzp2d, _ma0, _sig);
g2d->SetNpx(8);
g2d->SetNpy(6);
g2d->SetTitle("");
g2d->Draw("TEXTCOLZ");
gPad->Update();
g2d->GetXaxis()->SetTitle("m_{Z'} [GeV]");
g2d->GetXaxis()->SetTitleOffset(1.0);
g2d->GetXaxis()->SetTitleSize(0.04);
g2d->GetYaxis()->SetTitle("m_{#chi} [GeV]");
g2d->GetYaxis()->SetTitleOffset(1.0);
g2d->GetYaxis()->SetTitleSize(0.04);

TH1F *dummy = new TH1F("dummy", "", 100, 0, 100);
dummy->GetYaxis()->SetTitle("95% C.L. #sigma(pp #rightarrow Z'H #rightarrow #chi #chi llll) [fb]");
dummy->GetYaxis()->SetTitleSize(0.04);
dummy->GetYaxis()->SetTitleOffset(1.8);
dummy->GetXaxis()->SetLabelOffset(100.0);
dummy->Draw("Y+");
   pad2->Draw();
   pad2->cd();
   dummy->Draw("Y+");
g2d->Draw("TEXTCOLZ");
g2d->SetMarkerStyle(20);
gPad->Update();
//hframe1->Draw("SAME");
ll->Draw();
c1->SaveAs("plots/sigma_limits_2D_ZpBaryonic.png");
*/











}
