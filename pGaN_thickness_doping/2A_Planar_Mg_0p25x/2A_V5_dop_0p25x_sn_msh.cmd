Title "Untitled"

Controls {
}

IOControls {
	EnableSections
}

Definitions {
	Constant "prof_sub" {
		Species = "nTinActiveConcentration"
		Value = 3.6e+18
	}
	Constant "prof_epi" {
		Species = "nSiliconActiveConcentration"
		Value = 2e+16
	}
	Constant "prof_collar" {
		Species = "pMagnesiumActiveConcentration"
		Value = 1.25e+18
	}
	Constant "prof_mid" {
		Species = "pMagnesiumActiveConcentration"
		Value = 7e+17
	}
	Constant "prof_jte" {
		Species = "pMagnesiumActiveConcentration"
		Value = 4e+17
	}
	Refinement "rs_global" {
		MaxElementSize = ( 25 60 )
		MinElementSize = ( 2 2 )
	}
	Refinement "rs_epi" {
		MaxElementSize = ( 3.5 1 )
		MinElementSize = ( 0.5 0.25 )
	}
	Refinement "rs_rim" {
		MaxElementSize = ( 0.04 0.025 )
		MinElementSize = ( 0.015 0.008 )
	}
	Refinement "rs_pgan" {
		MaxElementSize = ( 1.5 0.08 )
		MinElementSize = ( 0.25 0.03 )
	}
	Refinement "rs_jte23" {
		MaxElementSize = ( 0.18 0.08 )
		MinElementSize = ( 0.05 0.025 )
	}
	Refinement "rs_jteout" {
		MaxElementSize = ( 0.18 0.08 )
		MinElementSize = ( 0.05 0.025 )
	}
	Refinement "rs_fptoe" {
		MaxElementSize = ( 0.25 0.25 )
		MinElementSize = ( 0.08 0.08 )
	}
	Refinement "rs_fpin" {
		MaxElementSize = ( 0.3 0.3 )
		MinElementSize = ( 0.1 0.1 )
	}
}

Placements {
	Constant "place_sub" {
		Reference = "prof_sub"
		EvaluateWindow {
			Element = region ["region_sub"]
		}
	}
	Constant "place_epi" {
		Reference = "prof_epi"
		EvaluateWindow {
			Element = region ["region_epi"]
		}
	}
	Constant "place_collar" {
		Reference = "prof_collar"
		EvaluateWindow {
			Element = region ["region_pgan_collar"]
		}
	}
	Constant "place_mid" {
		Reference = "prof_mid"
		EvaluateWindow {
			Element = region ["region_pgan_mid"]
		}
	}
	Constant "place_jte" {
		Reference = "prof_jte"
		EvaluateWindow {
			Element = region ["region_pgan"]
		}
	}
	Refinement "rp_global" {
		Reference = "rs_global"
		RefineWindow = Rectangle [(0 -2.5) (135 660)]
	}
	Refinement "rp_epi" {
		Reference = "rs_epi"
		RefineWindow = Rectangle [(0 -2) (95 11)]
	}
	Refinement "rp_rim" {
		Reference = "rs_rim"
		RefineWindow = Rectangle [(50.9 -0.3) (51.85 0.4)]
	}
	Refinement "rp_pgan" {
		Reference = "rs_pgan"
		RefineWindow = Rectangle [(51.25 -0.25) (88 0.35)]
	}
	Refinement "rp_jte23" {
		Reference = "rs_jte23"
		RefineWindow = Rectangle [(62.4 -0.25) (63.6 0.35)]
	}
	Refinement "rp_jteout" {
		Reference = "rs_jteout"
		RefineWindow = Rectangle [(86.5 -0.25) (87.5 0.35)]
	}
	Refinement "rp_fptoe" {
		Reference = "rs_fptoe"
		RefineWindow = Rectangle [(66.2 -2) (67.8 -1.1)]
	}
	Refinement "rp_fpin" {
		Reference = "rs_fpin"
		RefineWindow = Rectangle [(54.6 -2) (55.4 -1.2)]
	}
}

