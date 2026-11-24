* Unified Bare SBD Split-Anode Forward Sweep (00_Bare_T350K, WF=5.100, T=350.00, Sn-substrate)
File {
  Grid      = "bare_split_105um_sn_msh.tdr"
  Parameter = "Ga2O3_Bare_g156e8_sn.par"
  Plot      = "fwd.tdr"
  Current   = "fwd.plt"
  Output    = "fwd.log"
}
Electrode {
  { Name="anode"     Voltage=0.0 Schottky WorkFunction=5.100 }
  { Name="anode_rim" Voltage=0.0 Schottky WorkFunction=5.100 }
  { Name="cathode"   Voltage=0.0 }
}
Physics {
  Temperature = 350.00
  IncompleteIonization
  Fermi
  Mobility(DopingDependence HighFieldSaturation(GradQuasiFermi))
  Recombination(SRH Auger)
  Thermionic
}
Physics(Electrode = "anode") { BarrierLowering eRecVel(TempDep) }
Physics(Electrode = "anode_rim") { BarrierLowering eRecVel(TempDep) }
Physics(MaterialInterface = "Ga2O3/Oxide") { Recombination(SurfaceSRH) Traps((FixedCharge Conc=-2.67e11)) }
Plot {
  eDensity hDensity TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
  ElectricField/Vector Potential SpaceCharge
}
Math {
  ExcludeTouchingContactParts
  ExitOnFailure Cylindrical(xAxis=0.0) -CheckUndefinedModels
  -Extrapolate Derivatives ExtendedPrecision(80)
  RelErrControl Digits=4 Iterations=50 NotDamped=18 LineSearchDamping=0.5
  ErrRef(Electron)=1e4 ErrRef(Hole)=1e4 RhsMin=1e-6
  Method=ParDiSo(NonsymmetricPermutation IterativeRefinement)
  CNormPrint NumberOfThreads=4 Wallclock ParameterInheritance=Flatten
  ParallelToInterfaceInBoundaryLayer(FullLayer)
  ComputeGradQuasiFermiAtContacts=UseQuasiFermi
}
Solve {
  Coupled(Iterations=100) { Poisson }
  Coupled(Iterations=100) { Poisson Electron Hole }
  Quasistationary(InitialStep=5e-3 MaxStep=0.025 MinStep=1e-9 Increment=1.5 Decrement=2.0
    Goal { Name="anode"     Voltage=3.5 }
    Goal { Name="anode_rim" Voltage=3.5 }
  ) {
    Coupled { Poisson Electron Hole }
    Plot(FilePrefix="fwd_V250" Time=(0.7142857))
  }
  Plot(FilePrefix="fwd_V350")
}
