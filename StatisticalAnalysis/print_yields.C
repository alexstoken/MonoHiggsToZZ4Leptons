// -----------------------------------------------------------------------------
//  File:        print_yields.C
//  Usage:       root -b -q -l "print_yields_tmp.C(\"4mu\")"
//  Description: Macro for printing out event yields and writing shape hists 
//               to a file for limit setting
//  Created:     29-July-2016 Dustin Burns
// -----------------------------------------------------------------------------

void print_yields(std::string channel){


  // Read in filelist
  std::string f   = "filelist_"+channel+"_2015_Fall15_AN_Bari_dburns.txt";
  //std::string f   = "filelist_"+channel+"_2015_Fall15_AN_Bari_dburns_limits.txt";
  
  
  // Pick histogram to get yield from
  std::string histlabel = "hPFMET_8"; 
  //std::string histlabel = "hM4l_T_8"; 
  //std::string histlabel = "hM4l_8"; 
  //std::string histlabel = "hM4l_14"; 
  std::string shapelabel = "hPFMET_8";
 

  // Set binning
  int nRebin = 100;


  // Sort files into vectors 
  std::ifstream in;
  in.open(f.c_str());
  std::vector<string> _data, _bkg, _sig, _all;
  std::string fname;
  while (std::getline(in,fname)) {
    _all.push_back(fname);
    if (fname.find("Run2015") < 200) _data.push_back(fname);
    if (fname.find("13TeV") < 200)   _bkg.push_back(fname);
    if (fname.find("MZP") < 200)     _sig.push_back(fname);
  }  
 

  // Print out yields 
  for ( int i=0; i<_all.size(); i++){  
    TFile *f1 = TFile::Open(_all.at(i).c_str());
    TH1F  *h  = (TH1F*)f1->Get(histlabel.c_str());
    float err2 = 0;
    for ( int j=0; j<h->GetXaxis()->GetNbins(); j++){
      err2 += h->GetBinError(j)*h->GetBinError(j);
    }
    cout << "Sample name " + channel + "channel: " << _all.at(i) << " " << "N Entries: " << h->GetEntries() << " Yield: " << h->Integral() <<  " Error: " << sqrt(err2) << endl;
  }


  // Create file for shape hists
  TFile * fout   = new TFile(("f" + channel + ".root").c_str(), "recreate");
  TDirectory * d = fout->mkdir(("bin" + channel).c_str());


  // Write bkg shape hists to file
  for ( int j=0; j<_bkg.size(); j++){
    TFile *f = TFile::Open(_bkg.at(j).c_str());
    TH1F  *h = (TH1F*)f->Get(shapelabel.c_str());
    
    // Format hist name
    char inname[500];
    sprintf(inname,"%s",_bkg.at(j).c_str());
    char *tok = std::strtok(inname, "/");
    char *outname;
    int i=0;
    while (tok) {
      i++;
      tok = std::strtok(NULL, "/");
      if(i == 8) outname = tok;
    }
    outname = std::strtok(outname, ".");
    h->SetName(outname);
    
    // Rebin hist
    TH1 * h_rebin = h->Rebin(nRebin, outname);
    
    // Write hist with correct name
    d->cd();
    h_rebin->Write(outname, TObject::kWriteDelete);
  }
  

  // Write data shape hist to file
  TFile *fd  = TFile::Open(_data.at(0).c_str());
  TH1F  *hd  = (TH1F*)fd->Get(shapelabel.c_str());
  TH1 * hd_rebin = hd->Rebin(10, "data_obs");
  for ( int i=1; i<_data.size(); i++){
    TFile *fd = TFile::Open(_data.at(i).c_str());
    TH1F  *h  = (TH1F*)fd->Get(shapelabel.c_str());

    // Rebin hist
    TH1 * h_rebin = h->Rebin(nRebin, "data_obs");
    
    // Add data hists together
    hd_rebin->Add(h_rebin);
  }
  d->cd();
  hd_rebin->Write("data_obs", TObject::kWriteDelete);


  // Write sig shape hists to file
  for ( int j=0; j<_sig.size(); j++){
    TFile *f = TFile::Open(_sig.at(j).c_str());
    TH1F  *h = (TH1F*)f->Get(shapelabel.c_str());
 
    // Format hist name
    char inname[500];
    sprintf(inname,"%s",_sig.at(j).c_str());
    char *tok = std::strtok(inname, "/");
    char *outname;
    int i=0;
    while (tok) {
      i++;
      tok = std::strtok(NULL, "/");
      if(i == 8) outname = tok;
    }
    outname = std::strtok(outname, ".");
    h->SetName(outname);
 
    // Rebin hist
    TH1 * h_rebin = h->Rebin(nRebin, outname);
    
    // Write hist with correct name
    d->cd();
    h_rebin->Write(outname, TObject::kWriteDelete);
  }


  // Write all hists to file
  fout->Write();

}
