void evenDisplaySeGA()
{
  //-----User Settings:-----------------------------------------------
  TString  InputFile     ="./data/SeGA.root";
  TString  ParFile       ="SeGApar.root";
  TString  OutFile	 ="SeGAtest.root";


  // -----   Reconstruction run   -------------------------------------------
  FairRunAna *fRun= new FairRunAna();
	FairFileSource *source = new FairFileSource(InputFile);
   fRun->SetSource(source);
  fRun->SetOutputFile(OutFile);

  FairRuntimeDb* rtdb = fRun->GetRuntimeDb();
  FairParRootFileIo* parInput1 = new FairParRootFileIo();
  parInput1->open(ParFile.Data());
  rtdb->setFirstInput(parInput1);

  FairEventManager *fMan= new FairEventManager();

  //----------------------Traks and points -------------------------------------
  FairMCTracks    *Track     = new FairMCTracks("Monte-Carlo Tracks");
  FairMCPointDraw *AtSeGAPoints = new FairMCPointDraw("AtSeGAPoint", kBlue, kFullSquare);

  fMan->AddTask(Track);
  fMan->AddTask(AtSeGAPoints);


  fMan->Init();

}
