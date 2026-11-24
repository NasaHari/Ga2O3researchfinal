Title "Untitled"

Controls {
}

IOControls {
	EnableSections
}

Definitions {
	Constant "Doping_Epi_Def" {
		Species = "nSiliconActiveConcentration"
		Value = 2e+16
	}
	Constant "Doping_Sub_Def" {
		Species = "nTinActiveConcentration"
		Value = 3.6e+18
	}
	Refinement "Ref_Global" {
		MaxElementSize = ( 10 30 )
		MinElementSize = ( 1 0.5 )
	}
	Refinement "Ref_Epi" {
		MaxElementSize = ( 2 0.25 )
		MinElementSize = ( 0.2 0.05 )
	}
	Refinement "Ref_Schottky" {
		MaxElementSize = ( 1 0.02 )
		MinElementSize = ( 0.1 0.005 )
	}
	Refinement "Ref_Corner_Core" {
		MaxElementSize = ( 0.016 0.016 )
		MinElementSize = ( 0.008 0.003 )
	}
	Refinement "Ref_Corner_Outer" {
		MaxElementSize = ( 0.4 0.15 )
		MinElementSize = ( 0.08 0.04 )
	}
	Refinement "Ref_Ambient" {
		MaxElementSize = ( 2 0.1 )
		MinElementSize = ( 0.1 0.02 )
	}
	Refinement "Ref_Sub" {
		MaxElementSize = ( 10 30 )
		MinElementSize = ( 1 1 )
	}
	Multibox "Mbox_Corner_In"
	{
		MaxElementSize = ( 0.1 0.05 )
		MinElementSize = ( 0.02 0.01 )
		Ratio = ( -1.25 1.25 )
	}
	Multibox "Mbox_Corner_Out_Amb"
	{
		MaxElementSize = ( 0.1 0.05 )
		MinElementSize = ( 0.02 0.01 )
		Ratio = ( 1.25 -1.25 )
	}
	Multibox "Mbox_Corner_Out_Semi"
	{
		MaxElementSize = ( 0.1 0.05 )
		MinElementSize = ( 0.02 0.01 )
		Ratio = ( 1.25 1.25 )
	}
}

Placements {
	Constant "Place_Doping_Epi" {
		Reference = "Doping_Epi_Def"
		EvaluateWindow {
			Element = region ["region_epi"]
		}
	}
	Constant "Place_Doping_Sub" {
		Reference = "Doping_Sub_Def"
		EvaluateWindow {
			Element = region ["region_sub"]
		}
	}
	Refinement "Place_Ref_Global" {
		Reference = "Ref_Global"
		RefineWindow = material ["Ga2O3"]
	}
	Refinement "Place_Ref_Epi" {
		Reference = "Ref_Epi"
		RefineWindow = region ["region_epi"]
	}
	Refinement "Place_Ref_Schottky" {
		Reference = "Ref_Schottky"
		RefineWindow = Rectangle [(0 0) (52.5 0.5)]
	}
	Refinement "Place_Ref_Corner_Core" {
		Reference = "Ref_Corner_Core"
		RefineWindow = Rectangle [(52.3 -0.15) (52.7 0.15)]
	}
	Refinement "Place_Ref_Corner_Outer" {
		Reference = "Ref_Corner_Outer"
		RefineWindow = Rectangle [(48.5 0) (56.5 2.5)]
	}
	Refinement "Place_Ref_Ambient" {
		Reference = "Ref_Ambient"
		RefineWindow = region ["region_ambient"]
	}
	Refinement "Place_Ref_Sub" {
		Reference = "Ref_Sub"
		RefineWindow = region ["region_sub"]
	}
	Multibox "Place_Mbox_Corner_In" {
		Reference = "Mbox_Corner_In"
		RefineWindow = Rectangle [(51 0) (52.5 1)]
	}
	Multibox "Place_Mbox_Corner_Out_Amb" {
		Reference = "Mbox_Corner_Out_Amb"
		RefineWindow = Rectangle [(52.5 -0.2) (54 0)]
	}
	Multibox "Place_Mbox_Corner_Out_Semi" {
		Reference = "Mbox_Corner_Out_Semi"
		RefineWindow = Rectangle [(52.5 0) (54 1)]
	}
}

