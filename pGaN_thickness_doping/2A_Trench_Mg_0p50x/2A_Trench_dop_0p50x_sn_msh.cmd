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
	Constant "prof_trench" {
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
	Refinement "rs_active_tr" {
		MaxElementSize = ( 0.6 0.25 )
		MinElementSize = ( 0.18 0.05 )
	}
	Refinement "rs_tL_0" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tR_0" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tL_1" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tR_1" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tL_2" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tR_2" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tL_3" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tR_3" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tL_4" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tR_4" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tL_5" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tR_5" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tL_6" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tR_6" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tL_7" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tR_7" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tL_8" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tR_8" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tL_9" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
	}
	Refinement "rs_tR_9" {
		MaxElementSize = ( 0.12 0.12 )
		MinElementSize = ( 0.05 0.05 )
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
	Constant "place_trench_0" {
		Reference = "prof_trench"
		EvaluateWindow {
			Element = region ["region_pgan_trench_0"]
		}
	}
	Constant "place_trench_1" {
		Reference = "prof_trench"
		EvaluateWindow {
			Element = region ["region_pgan_trench_1"]
		}
	}
	Constant "place_trench_2" {
		Reference = "prof_trench"
		EvaluateWindow {
			Element = region ["region_pgan_trench_2"]
		}
	}
	Constant "place_trench_3" {
		Reference = "prof_trench"
		EvaluateWindow {
			Element = region ["region_pgan_trench_3"]
		}
	}
	Constant "place_trench_4" {
		Reference = "prof_trench"
		EvaluateWindow {
			Element = region ["region_pgan_trench_4"]
		}
	}
	Constant "place_trench_5" {
		Reference = "prof_trench"
		EvaluateWindow {
			Element = region ["region_pgan_trench_5"]
		}
	}
	Constant "place_trench_6" {
		Reference = "prof_trench"
		EvaluateWindow {
			Element = region ["region_pgan_trench_6"]
		}
	}
	Constant "place_trench_7" {
		Reference = "prof_trench"
		EvaluateWindow {
			Element = region ["region_pgan_trench_7"]
		}
	}
	Constant "place_trench_8" {
		Reference = "prof_trench"
		EvaluateWindow {
			Element = region ["region_pgan_trench_8"]
		}
	}
	Constant "place_trench_9" {
		Reference = "prof_trench"
		EvaluateWindow {
			Element = region ["region_pgan_trench_9"]
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
	Refinement "rp_active_tr" {
		Reference = "rs_active_tr"
		RefineWindow = Rectangle [(0 -0.3) (51.2 1.3)]
	}
	Refinement "rp_tL_0" {
		Reference = "rs_tL_0"
		RefineWindow = Rectangle [(1.15 -0.2) (1.75 1.35)]
	}
	Refinement "rp_tR_0" {
		Reference = "rs_tR_0"
		RefineWindow = Rectangle [(3.25 -0.2) (3.85 1.35)]
	}
	Refinement "rp_tL_1" {
		Reference = "rs_tL_1"
		RefineWindow = Rectangle [(6.15 -0.2) (6.75 1.35)]
	}
	Refinement "rp_tR_1" {
		Reference = "rs_tR_1"
		RefineWindow = Rectangle [(8.25 -0.2) (8.85 1.35)]
	}
	Refinement "rp_tL_2" {
		Reference = "rs_tL_2"
		RefineWindow = Rectangle [(11.15 -0.2) (11.75 1.35)]
	}
	Refinement "rp_tR_2" {
		Reference = "rs_tR_2"
		RefineWindow = Rectangle [(13.25 -0.2) (13.85 1.35)]
	}
	Refinement "rp_tL_3" {
		Reference = "rs_tL_3"
		RefineWindow = Rectangle [(16.15 -0.2) (16.75 1.35)]
	}
	Refinement "rp_tR_3" {
		Reference = "rs_tR_3"
		RefineWindow = Rectangle [(18.25 -0.2) (18.85 1.35)]
	}
	Refinement "rp_tL_4" {
		Reference = "rs_tL_4"
		RefineWindow = Rectangle [(21.15 -0.2) (21.75 1.35)]
	}
	Refinement "rp_tR_4" {
		Reference = "rs_tR_4"
		RefineWindow = Rectangle [(23.25 -0.2) (23.85 1.35)]
	}
	Refinement "rp_tL_5" {
		Reference = "rs_tL_5"
		RefineWindow = Rectangle [(26.15 -0.2) (26.75 1.35)]
	}
	Refinement "rp_tR_5" {
		Reference = "rs_tR_5"
		RefineWindow = Rectangle [(28.25 -0.2) (28.85 1.35)]
	}
	Refinement "rp_tL_6" {
		Reference = "rs_tL_6"
		RefineWindow = Rectangle [(31.15 -0.2) (31.75 1.35)]
	}
	Refinement "rp_tR_6" {
		Reference = "rs_tR_6"
		RefineWindow = Rectangle [(33.25 -0.2) (33.85 1.35)]
	}
	Refinement "rp_tL_7" {
		Reference = "rs_tL_7"
		RefineWindow = Rectangle [(36.15 -0.2) (36.75 1.35)]
	}
	Refinement "rp_tR_7" {
		Reference = "rs_tR_7"
		RefineWindow = Rectangle [(38.25 -0.2) (38.85 1.35)]
	}
	Refinement "rp_tL_8" {
		Reference = "rs_tL_8"
		RefineWindow = Rectangle [(41.15 -0.2) (41.75 1.35)]
	}
	Refinement "rp_tR_8" {
		Reference = "rs_tR_8"
		RefineWindow = Rectangle [(43.25 -0.2) (43.85 1.35)]
	}
	Refinement "rp_tL_9" {
		Reference = "rs_tL_9"
		RefineWindow = Rectangle [(46.15 -0.2) (46.75 1.35)]
	}
	Refinement "rp_tR_9" {
		Reference = "rs_tR_9"
		RefineWindow = Rectangle [(48.25 -0.2) (48.85 1.35)]
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

