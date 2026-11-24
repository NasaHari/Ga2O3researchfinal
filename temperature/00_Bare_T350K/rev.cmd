* Unified Bare SBD Split-Anode Reverse Sweep (00_Bare_T350K, WF=5.100, T=350.00, g=1.56e-8, Sn-substrate)
File {
  Grid      = "bare_split_105um_sn_msh.tdr"
  Parameter = "Ga2O3_Bare_g156e8_sn.par"
  Plot      = "rev.tdr"
  Current   = "rev.plt"
  Output    = "rev.log"
}
Electrode {
  { Name="anode"     Voltage=0.0 Schottky WorkFunction=5.100 }
  { Name="anode_rim" Voltage=0.0 Schottky WorkFunction=5.100 }
  { Name="cathode"   Voltage=0.0 DistResist=1.0e-4 Resist=1.0e4 }
}
Physics {
  Temperature = 350.00
  IncompleteIonization
  Fermi
  Mobility(DopingDependence HighFieldSaturation(GradQuasiFermi))
  Recombination(SRH Auger Avalanche(vanOverstraeten GradQuasiFermi))
  Thermionic
  eBarrierTunneling "NLM_Anode" ( )
  Optics ( OpticalGeneration ( SetConstant (Value = 1.0e13) ) )
}
Physics(Electrode = "anode") { BarrierLowering eRecVel(TempDep) }
Physics(Electrode = "anode_rim") { BarrierLowering eRecVel(TempDep) }
Physics(MaterialInterface = "Ga2O3/Oxide") { Recombination(SurfaceSRH) Traps((FixedCharge Conc=-2.67e11)) }
Plot {
  eDensity hDensity TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
  ElectricField/Vector Potential SpaceCharge AvalancheGeneration MeanIonIntegral
  eBarrierTunneling NonLocal eIonIntegral hIonIntegral
}
Math {
  ExcludeTouchingContactParts
  ExitOnFailure ComputeIonizationIntegrals() Cylindrical(xAxis=0.0) -CheckUndefinedModels
  -Extrapolate Derivatives AvalDerivatives ExtendedPrecision(80)
  RelErrControl Digits=4 Iterations=50 NotDamped=18 LineSearchDamping=0.5
  ErrRef(Electron)=1e4 ErrRef(Hole)=1e4 RhsMin=1e-6
  Method=ParDiSo(NonsymmetricPermutation IterativeRefinement)
  CNormPrint NumberOfThreads=4 Wallclock ParameterInheritance=Flatten
  AvalDensGradQF ParallelToInterfaceInBoundaryLayer(FullLayer) AvalFlatElementExclusion=1
  RefDens_eGradQuasiFermi_ElectricField=1e10 RefDens_hGradQuasiFermi_ElectricField=1e10
  ComputeGradQuasiFermiAtContacts=UseQuasiFermi WithDistResistOnSemi
  NonLocal "NLM_Anode" (Electrode="anode" Length=15e-7 Direction=(0 1 0) MaxAngle=5 Digits=3 EnergyResolution=5e-3 RefinedIntervals=1e-8)
  BreakCriteria { Current(Contact="cathode" AbsVal=1.0e-3) }
}
Solve {
  Coupled(Iterations=100) { Poisson }
  Coupled(Iterations=100) { Poisson Electron Hole }
  Quasistationary(InitialStep=1e-3 MaxStep=0.035 MinStep=1e-12 Increment=1.6 Decrement=2.0
    Goal { Name="anode"     Voltage=-2000.0 }
    Goal { Name="anode_rim" Voltage=-2000.0 }
  ) {
    Coupled { Poisson Electron Hole }
  }
  Plot(FilePrefix="rev_final")
}
