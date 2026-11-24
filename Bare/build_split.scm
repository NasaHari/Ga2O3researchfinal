;;=============================================================================
;; Synopsys Sentaurus Structure Editor (SDE) Script
;; Device: Vertical beta-Ga2O3 SBD with 50.0nm Corner Fillet
;; Sweep: Decreasing Fillet Radius Study (1 Sharp + 8 Fillet Radii)
;;=============================================================================

(sde:clear)
(sdegeo:set-default-boolean "BAB")

(define R_anode        52.5)
(define R_domain      105.0)
(define T_epi          10.0)
(define T_sub         650.0)
(define Y_epi_bot      T_epi)
(define Y_sub_bot      (+ T_epi T_sub))

(define edge_radius     0.050000)
(define T_anode_metal   0.10)
(define T_ambient       0.50)
(define include_ambient #t)
(define include_metal_sidewall_contact #t)

(define N_epi          2.0e16)
(define N_sub          3.6e18)

(if include_ambient
  (begin
    (define reg_ambient
      (sdegeo:create-rectangle
        (position R_anode (- 0.0 T_ambient) 0.0)
        (position R_domain 0.0 0.0)
        "Oxide"
        "region_ambient"
      )
    )
    (sdegeo:fillet-2d (find-vertex-id (position R_anode 0.0 0.0)) edge_radius)
  )
)

(define reg_epi
  (sdegeo:create-rectangle
    (position 0.0 0.0 0.0)
    (position R_domain Y_epi_bot 0.0)
    "Ga2O3"
    "region_epi"
  )
)

(define reg_sub
  (sdegeo:create-rectangle
    (position 0.0 Y_epi_bot 0.0)
    (position R_domain Y_sub_bot 0.0)
    "Ga2O3"
    "region_sub"
  )
)

(sdegeo:define-contact-set "anode"     4 (color:rgb 1.0 0.0 0.0) "##")
(sdegeo:define-contact-set "anode_rim" 4 (color:rgb 1.0 0.5 0.0) "##")
(sdegeo:define-contact-set "cathode" 4 (color:rgb 0.0 0.0 1.0) "##")

(sdegeo:insert-vertex (position 52.0 0.0 0.0))
(sdegeo:set-current-contact-set "anode")
(sdegeo:set-contact-edges (find-edge-id (position 26.0 0.0 0.0)) "anode")

(sdegeo:set-current-contact-set "anode_rim")
(sdegeo:set-contact-edges (find-edge-id (position 52.25 0.0 0.0)) "anode_rim")
(define e_arc (find-edge-id (position 52.51464466 -0.01464466 0.0)))
(if (not (null? e_arc)) (sdegeo:set-contact-edges e_arc "anode_rim"))
(if (and include_ambient include_metal_sidewall_contact)
  (begin
    (sdegeo:insert-vertex (position R_anode (- 0.0 T_anode_metal) 0.0))
    (sdegeo:set-contact-edges
      (find-edge-id (position R_anode (- 0.0 (/ T_anode_metal 2.0)) 0.0))
      "anode_rim"
    )
  )
)

(sdegeo:set-current-contact-set "cathode")
(sdegeo:set-contact-edges
  (find-edge-id (position (/ R_domain 2.0) Y_sub_bot 0.0))
  "cathode"
)

(sdedr:define-constant-profile "Doping_Epi_Def" "nSiliconActiveConcentration" N_epi)
(sdedr:define-constant-profile-region "Place_Doping_Epi" "Doping_Epi_Def" "region_epi")

(sdedr:define-constant-profile "Doping_Sub_Def" "nTinActiveConcentration" N_sub)
(sdedr:define-constant-profile-region "Place_Doping_Sub" "Doping_Sub_Def" "region_sub")

(sdedr:define-refinement-size "Ref_Global"
  10.0 30.0
   1.0  0.5
)
(sdedr:define-refinement-material "Place_Ref_Global" "Ref_Global" "Ga2O3")

(sdedr:define-refinement-size "Ref_Epi"
  2.0 0.25
  0.2 0.05
)
(sdedr:define-refinement-region "Place_Ref_Epi" "Ref_Epi" "region_epi")

(sdedr:define-refeval-window "Win_Schottky" "Rectangle"
  (position 0.0 0.0 0.0)
  (position R_anode 0.5 0.0)
)
(sdedr:define-refinement-size "Ref_Schottky"
  1.0 0.02
  0.1 0.005
)
(sdedr:define-refinement-placement "Place_Ref_Schottky" "Ref_Schottky" "Win_Schottky")

(sdedr:define-refeval-window "Win_Corner_Core" "Rectangle"
  (position (- R_anode 0.2) -0.15 0.0)
  (position (+ R_anode 0.2)  0.15 0.0)
)
(sdedr:define-refinement-size "Ref_Corner_Core"
  0.016000 0.016000
  0.008000 0.003000
)
(sdedr:define-refinement-placement "Place_Ref_Corner_Core" "Ref_Corner_Core" "Win_Corner_Core")

(sdedr:define-refeval-window "Win_Corner_Graded_In" "Rectangle"
  (position (- R_anode 1.5) 0.0 0.0)
  (position R_anode 1.0 0.0)
)
(sdedr:define-multibox-size "Mbox_Corner_In"
  0.10 0.05
  0.02 0.01
  -1.25 1.25
)
(sdedr:define-multibox-placement "Place_Mbox_Corner_In" "Mbox_Corner_In" "Win_Corner_Graded_In")

(sdedr:define-refeval-window "Win_Corner_Graded_Out_Amb" "Rectangle"
  (position R_anode -0.2 0.0)
  (position (+ R_anode 1.5) 0.0 0.0)
)
(sdedr:define-multibox-size "Mbox_Corner_Out_Amb"
  0.10 0.05
  0.02 0.01
  1.25 -1.25
)
(sdedr:define-multibox-placement "Place_Mbox_Corner_Out_Amb" "Mbox_Corner_Out_Amb" "Win_Corner_Graded_Out_Amb")

(sdedr:define-refeval-window "Win_Corner_Graded_Out_Semi" "Rectangle"
  (position R_anode 0.0 0.0)
  (position (+ R_anode 1.5) 1.0 0.0)
)
(sdedr:define-multibox-size "Mbox_Corner_Out_Semi"
  0.10 0.05
  0.02 0.01
  1.25 1.25
)
(sdedr:define-multibox-placement "Place_Mbox_Corner_Out_Semi" "Mbox_Corner_Out_Semi" "Win_Corner_Graded_Out_Semi")

(sdedr:define-refeval-window "Win_Corner_Outer" "Rectangle"
  (position (- R_anode 4.0) 0.0 0.0)
  (position (+ R_anode 4.0) 2.5 0.0)
)
(sdedr:define-refinement-size "Ref_Corner_Outer"
  0.40 0.15
  0.08 0.04
)
(sdedr:define-refinement-placement "Place_Ref_Corner_Outer" "Ref_Corner_Outer" "Win_Corner_Outer")

(if include_ambient
  (begin
    (sdedr:define-refinement-size "Ref_Ambient"
      2.0 0.10
      0.1 0.02
    )
    (sdedr:define-refinement-region "Place_Ref_Ambient" "Ref_Ambient" "region_ambient")
  )
)

(sdedr:define-refinement-size "Ref_Sub"
  10.0 30.0
   1.0  1.0
)
(sdedr:define-refinement-region "Place_Ref_Sub" "Ref_Sub" "region_sub")

(sde:check-model "logs/bare_50nm_matched_check.log")
(sdegeo:check-geometry (find-region-id "region_epi") #t)
(if include_ambient
  (sdegeo:check-geometry (find-region-id "region_ambient") #t))

(sde:show-contact "anode")
(sde:show-contact "cathode")
(sde:info "all")

(sde:set-project-name "bare_50nm_matched")
(sde:save-model "tdr/bare_split_model")
(sde:build-mesh "tdr/bare_split_msh")
