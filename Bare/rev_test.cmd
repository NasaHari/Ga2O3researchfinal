*=============================================================================*
* Yang et al. 2017: Patched Reverse Bias vs Temperature at 25 C (298.15 K)     *
* WorkFunction=5.10, eRecVel(TempDep), DistResist=1.0e-4                       *
* Qf=-2.67e11, Eps=12.4, alpha=1.05e-3, beta=676.97, alpha2=5.05e-3, Tpar=298.15*
*=============================================================================*

File {
  Grid      = "bare_split_msh.tdr"
  Parameter = "des.par"
  Plot      = "tdr/rev_298K_des.tdr"
  Current   = "rev_298K_des.plt"
  Output    = "rev_298K_des.log"
}

Electrode {
  { Name="anode"     Voltage=0.0 Schottky WorkFunction=5.10 }
  { Name="anode_rim" Voltage=0.0 Schottky WorkFunction=5.10 }
  { Name="cathode" Voltage=0.0 DistResist=1.0e-4 }
}

Physics {
  Temperature = 298.15
  IncompleteIonization
  Fermi
  Mobility(
    DopingDependence
    HighFieldSaturation(GradQuasiFermi)
  )
  Recombination(
    SRH
    Auger
    Avalanche(vanOverstraeten GradQuasiFermi)
  )
  Thermionic
  eBarrierTunneling "NLM_Anode" ( )
}

Physics(Electrode = "anode") {
  BarrierLowering
  eRecVel(TempDep)
}
Physics(Electrode = "anode_rim") {
  BarrierLowering
  eRecVel(TempDep)
}

Physics(MaterialInterface = "Ga2O3/Oxide") {
  Recombination(SurfaceSRH)
  Traps (
    (FixedCharge Conc=-2.67e11)
  )
}

Plot {
  eDensity hDensity
  TotalCurrent/Vector
  eCurrent/Vector hCurrent/Vector
  ElectricField/Vector
  Potential
  SpaceCharge
  Doping DonorConcentration
  DonorPlusConcentration
  IonizedDopingConcentration
  AvalancheGeneration
  eAvalanche hAvalanche
  eAlphaAvalanche hAlphaAvalanche
  eMobility hMobility
  eVelocity hVelocity
  ConductionBandEnergy ValenceBandEnergy
  SurfaceRecombination
  eBarrierTunneling
  NonLocal
}

Math {
  ExcludeTouchingContactParts
  Cylindrical (xAxis = 0.0)
  -CheckUndefinedModels
  -Extrapolate
  Derivatives
  AvalDerivatives
  Iterations = 20
  RelErrControl
  Digits = 5
  ErrRef(Electron) = 1.0e2
  ErrRef(Hole)     = 1.0e2
  RhsMin = 1.0e-6
  LineSearchDamping = 0.5
  NotDamped = 5
  ExtendedPrecision(80)
  CNormPrint
  Method = ParDiSo (NonsymmetricPermutation IterativeRefinement)
  Number_of_Threads = 12
  Wallclock

  ParameterInheritance = Flatten
  AvalDensGradQF
  ParallelToInterfaceInBoundaryLayer (FullLayer)
  AvalFlatElementExclusion = 1.0

  RefDens_eGradQuasiFermi_ElectricField = 1.0e10
  RefDens_hGradQuasiFermi_ElectricField = 1.0e10
  ComputeGradQuasiFermiAtContacts       = UseQuasiFermi
  WithDistResistOnSemi

  NonLocal "NLM_Anode" (
    Electrode        = "anode"
    Length           = 15e-7
    Direction        = (0 1 0)
    MaxAngle         = 5
    Digits           = 3
    EnergyResolution = 5e-3
    RefinedIntervals = 1e-8
  )

  BreakCriteria {
    Current(Contact="cathode" AbsVal=1.0e-3)
  }
}

Solve {
  Coupled(Iterations=100) { Poisson }
  Coupled { Poisson Electron Hole }

  Quasistationary(
    -Extrapolate
    InitialStep = 0.01
    Increment   = 1.4
    Decrement   = 2.0
    MinStep     = 1.0e-6
    MaxStep     = 0.04
    Goal { Name="anode" Voltage=-850.0 }
    Goal { Name="anode_rim" Voltage=-850.0 }
  ) {
    Coupled { Poisson Electron Hole }
  }
  Quasistationary(
    -Extrapolate
    InitialStep = 0.05
    Increment   = 1.3
    Decrement   = 2.0
    MinStep     = 1.0e-6
    MaxStep     = 0.10
    Goal { Name="anode" Voltage=-925.0 }
    Goal { Name="anode_rim" Voltage=-925.0 }
    Plot { FilePrefix = "tdr/rev_298K_des" Range = (0 1) Intervals = 10 }
  ) {
    Coupled { Poisson Electron Hole }
  }
  Quasistationary(
    -Extrapolate
    InitialStep = 0.005
    Increment   = 1.2
    Decrement   = 2.0
    MinStep     = 1.0e-8
    MaxStep     = 0.005
    Goal { Name="anode" Voltage=-935.0 }
    Goal { Name="anode_rim" Voltage=-935.0 }
    Plot { Range = (0 1) Intervals = 10 }
  ) {
    Coupled { Poisson Electron Hole }
  }
}

