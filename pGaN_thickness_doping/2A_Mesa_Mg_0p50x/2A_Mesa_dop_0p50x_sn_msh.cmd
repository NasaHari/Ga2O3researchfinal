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
	Constant "prof_mesa" {
		Species = "pMagnesiumActiveConcentration"
		Value = 2.5e+18
	}
	Constant "prof_collar" {
		Species = "pMagnesiumActiveConcentration"
		Value = 2.5e+18
	}
	Constant "prof_mid" {
		Species = "pMagnesiumActiveConcentration"
		Value = 1.4e+18
	}
	Constant "prof_jte" {
		Species = "pMagnesiumActiveConcentration"
		Value = 8e+17
	}
	Refinement "rs_global" {
		MaxElementSize = ( 25 60 )
		MinElementSize = ( 2 2 )
	}
	Refinement "rs_epi" {
		MaxElementSize = ( 3.5 1 )
		MinElementSize = ( 0.5 0.25 )
	}
	Refinement "rs_active_surf" {
		MaxElementSize = ( 0.6 0.25 )
		MinElementSize = ( 0.18 0.05 )
	}
	Refinement "rs_mL_0" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mR_0" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mL_1" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mR_1" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mL_2" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mR_2" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mL_3" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mR_3" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mL_4" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mR_4" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mL_5" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mR_5" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mL_6" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mR_6" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mL_7" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mR_7" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mL_8" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mR_8" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mL_9" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
	}
	Refinement "rs_mR_9" {
		MaxElementSize = ( 0.1 0.08 )
		MinElementSize = ( 0.04 0.04 )
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
	Constant "place_mesa_0" {
		Reference = "prof_mesa"
		EvaluateWindow {
			Element = region ["region_pgan_mesa_0"]
		}
	}
	Constant "place_mesa_1" {
		Reference = "prof_mesa"
		EvaluateWindow {
			Element = region ["region_pgan_mesa_1"]
		}
	}
	Constant "place_mesa_2" {
		Reference = "prof_mesa"
		EvaluateWindow {
			Element = region ["region_pgan_mesa_2"]
		}
	}
	Constant "place_mesa_3" {
		Reference = "prof_mesa"
		EvaluateWindow {
			Element = region ["region_pgan_mesa_3"]
		}
	}
	Constant "place_mesa_4" {
		Reference = "prof_mesa"
		EvaluateWindow {
			Element = region ["region_pgan_mesa_4"]
		}
	}
	Constant "place_mesa_5" {
		Reference = "prof_mesa"
		EvaluateWindow {
			Element = region ["region_pgan_mesa_5"]
		}
	}
	Constant "place_mesa_6" {
		Reference = "prof_mesa"
		EvaluateWindow {
			Element = region ["region_pgan_mesa_6"]
		}
	}
	Constant "place_mesa_7" {
		Reference = "prof_mesa"
		EvaluateWindow {
			Element = region ["region_pgan_mesa_7"]
		}
	}
	Constant "place_mesa_8" {
		Reference = "prof_mesa"
		EvaluateWindow {
			Element = region ["region_pgan_mesa_8"]
		}
	}
	Constant "place_mesa_9" {
		Reference = "prof_mesa"
		EvaluateWindow {
			Element = region ["region_pgan_mesa_9"]
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
	Refinement "rp_active_surf" {
		Reference = "rs_active_surf"
		RefineWindow = Rectangle [(0 -0.65) (51.2 0.6)]
	}
	Refinement "rp_mL_0" {
		Reference = "rs_mL_0"
		RefineWindow = Rectangle [(1.32 -0.15) (1.65 0.2)]
	}
	Refinement "rp_mR_0" {
		Reference = "rs_mR_0"
		RefineWindow = Rectangle [(3.35 -0.15) (3.68 0.2)]
	}
	Refinement "rp_mL_1" {
		Reference = "rs_mL_1"
		RefineWindow = Rectangle [(6.32 -0.15) (6.65 0.2)]
	}
	Refinement "rp_mR_1" {
		Reference = "rs_mR_1"
		RefineWindow = Rectangle [(8.35 -0.15) (8.68 0.2)]
	}
	Refinement "rp_mL_2" {
		Reference = "rs_mL_2"
		RefineWindow = Rectangle [(11.32 -0.15) (11.65 0.2)]
	}
	Refinement "rp_mR_2" {
		Reference = "rs_mR_2"
		RefineWindow = Rectangle [(13.35 -0.15) (13.68 0.2)]
	}
	Refinement "rp_mL_3" {
		Reference = "rs_mL_3"
		RefineWindow = Rectangle [(16.32 -0.15) (16.65 0.2)]
	}
	Refinement "rp_mR_3" {
		Reference = "rs_mR_3"
		RefineWindow = Rectangle [(18.35 -0.15) (18.68 0.2)]
	}
	Refinement "rp_mL_4" {
		Reference = "rs_mL_4"
		RefineWindow = Rectangle [(21.32 -0.15) (21.65 0.2)]
	}
	Refinement "rp_mR_4" {
		Reference = "rs_mR_4"
		RefineWindow = Rectangle [(23.35 -0.15) (23.68 0.2)]
	}
	Refinement "rp_mL_5" {
		Reference = "rs_mL_5"
		RefineWindow = Rectangle [(26.32 -0.15) (26.65 0.2)]
	}
	Refinement "rp_mR_5" {
		Reference = "rs_mR_5"
		RefineWindow = Rectangle [(28.35 -0.15) (28.68 0.2)]
	}
	Refinement "rp_mL_6" {
		Reference = "rs_mL_6"
		RefineWindow = Rectangle [(31.32 -0.15) (31.65 0.2)]
	}
	Refinement "rp_mR_6" {
		Reference = "rs_mR_6"
		RefineWindow = Rectangle [(33.35 -0.15) (33.68 0.2)]
	}
	Refinement "rp_mL_7" {
		Reference = "rs_mL_7"
		RefineWindow = Rectangle [(36.32 -0.15) (36.65 0.2)]
	}
	Refinement "rp_mR_7" {
		Reference = "rs_mR_7"
		RefineWindow = Rectangle [(38.35 -0.15) (38.68 0.2)]
	}
	Refinement "rp_mL_8" {
		Reference = "rs_mL_8"
		RefineWindow = Rectangle [(41.32 -0.15) (41.65 0.2)]
	}
	Refinement "rp_mR_8" {
		Reference = "rs_mR_8"
		RefineWindow = Rectangle [(43.35 -0.15) (43.68 0.2)]
	}
	Refinement "rp_mL_9" {
		Reference = "rs_mL_9"
		RefineWindow = Rectangle [(46.32 -0.15) (46.65 0.2)]
	}
	Refinement "rp_mR_9" {
		Reference = "rs_mR_9"
		RefineWindow = Rectangle [(48.35 -0.15) (48.68 0.2)]
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

