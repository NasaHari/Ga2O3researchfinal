(sde:clear)
(sdegeo:set-default-boolean "ABA")

; =========================================================================
; 12_OptJTE_V5_FP_bh5e7: Stepped-Anode 3-Zone p-GaN JTE + Rounded Buried FP
; Fixes all 07_OptJTE_V4_SteppedAnode defects:
;   1) Restores physical rounded Field Plate ("anode_fp") from 55.0..67.0 um
;      over 1.50 um Al2O3, bridging past the X_jte_23 = 63.00 um GaN hotspot.
;   2) Tightens inner collar gap slightly (X_jte_in = 51.45, R_sch_fil = 0.08)
;      to relieve the high-voltage (51.28, 0) Al2O3 corner field.
;   3) Smooth 0.05 um fillets on outer & inner p-GaN JTE top corners.
;   4) Zero touching contacts: anode, anode_pgan, and anode_fp are disjoint
;      in mesh and biased equipotentially in sdevice.
; =========================================================================

; Geometry & Doping Constants (um, cm^-3)
(define W_dev       135.0)
(define T_epi        10.0)
(define Y_sub_bot   660.0)
(define T_al2o3       1.50)
(define T_ambient     1.00)
(define T_pgan        0.15)
(define T_sch_wall    0.15)

(define X_sch        51.20)
(define R_sch_fil     0.08)
(define X_via_L      52.50)
(define X_via_R      54.50)

(define X_fp_in      55.00)
(define X_fp_toe     67.00)
(define T_fp_metal    0.30)
(define R_fp_in_fil   0.08)
(define R_fp_toe_bot  0.15)
(define R_fp_toe_top  0.10)

(define X_jte_in     51.45)
(define X_jte_12     56.50)
(define X_jte_23     63.00)
(define X_jte_out    87.00)
(define R_jte_fil     0.05)

(define N_sub        3.6e18)
(define N_epi        2.0e16)
(define P_collar     3.750e+18)
(define P_mid        2.100e+18)
(define P_jte        1.200e+18)

(define Y_al2o3_top  (- T_al2o3))              ; -1.50
(define Y_amb_top    (- (+ T_al2o3 T_ambient))) ; -2.50
(define Y_pgan_top   (- T_pgan))               ; -0.15
(define Y_fp_bot     Y_al2o3_top)              ; -1.50
(define Y_fp_top     (- Y_fp_bot T_fp_metal))  ; -1.80

; 1. Create dummy FP metal block FIRST in empty space so 4-corner fillets are clean
(define reg_fp (sdegeo:create-rectangle (position X_fp_in Y_fp_top 0.0) (position X_fp_toe Y_fp_bot 0.0) "Aluminum" "region_fp_dummy"))
(sdegeo:fillet-2d (car (find-vertex-id (position X_fp_in  Y_fp_bot 0.0))) R_fp_in_fil)
(sdegeo:fillet-2d (car (find-vertex-id (position X_fp_in  Y_fp_top 0.0))) R_fp_in_fil)
(sdegeo:fillet-2d (car (find-vertex-id (position X_fp_toe Y_fp_bot 0.0))) R_fp_toe_bot)
(sdegeo:fillet-2d (car (find-vertex-id (position X_fp_toe Y_fp_top 0.0))) R_fp_toe_top)

; 2. Outer Oxide Ambient (cuts cleanly around dummy FP using BAB)
(sdegeo:set-default-boolean "BAB")
(define reg_ambient (sdegeo:create-rectangle (position X_via_R Y_amb_top 0.0) (position W_dev Y_al2o3_top 0.0) "Oxide" "region_ambient"))

; 3. Switch to ABA and build Al2O3 spacer (filleted BEFORE Ga2O3 epi)
(sdegeo:set-default-boolean "ABA")
(define reg_al2o3_sp (sdegeo:create-rectangle (position X_sch Y_al2o3_top 0.0) (position X_via_L 0.0 0.0) "AluminumOxide" "region_al2o3_spacer"))
(sdegeo:fillet-2d (car (find-vertex-id (position X_sch 0.0 0.0))) R_sch_fil)

; 4. Substrate, Drift Epi, and Outer Al2O3 Passivation
(define reg_sub       (sdegeo:create-rectangle (position 0.0     T_epi       0.0) (position W_dev Y_sub_bot 0.0) "Ga2O3"         "region_sub"))
(define reg_epi       (sdegeo:create-rectangle (position 0.0     0.0         0.0) (position W_dev T_epi     0.0) "Ga2O3"         "region_epi"))
(define reg_al2o3_out (sdegeo:create-rectangle (position X_via_R Y_al2o3_top 0.0) (position W_dev 0.0       0.0) "AluminumOxide" "region_passivation"))

; 5. 3-Zone Stepped p-GaN JTE
(define reg_collar (sdegeo:create-rectangle (position X_jte_in Y_pgan_top 0.0) (position X_jte_12  0.0 0.0) "GaN" "region_pgan_collar"))
(define reg_mid    (sdegeo:create-rectangle (position X_jte_12 Y_pgan_top 0.0) (position X_jte_23  0.0 0.0) "GaN" "region_pgan_mid"))
(define reg_pgan   (sdegeo:create-rectangle (position X_jte_23 Y_pgan_top 0.0) (position X_jte_out 0.0 0.0) "GaN" "region_pgan"))

(sdegeo:fillet-2d (car (find-vertex-id (position X_jte_in  Y_pgan_top 0.0))) R_jte_fil)
(sdegeo:fillet-2d (car (find-vertex-id (position X_jte_out Y_pgan_top 0.0))) R_jte_fil)

; 6. Remove dummy FP metal body BEFORE assigning exterior cavity contacts
(sdegeo:delete-region (find-body-id (position 61.0 -1.65 0.0)))

; 7. Contacts (helper fails cleanly if any edge is missing)
(sdegeo:define-contact-set "anode"      4.0 (color:rgb 1.0 0.0 0.0) "##")
(sdegeo:define-contact-set "anode_pgan" 4.0 (color:rgb 0.0 0.7 0.0) "##")
(sdegeo:define-contact-set "anode_fp"   4.0 (color:rgb 0.9 0.5 0.0) "##")
(sdegeo:define-contact-set "cathode"    4.0 (color:rgb 0.0 0.0 1.0) "##")

(define (contact-at x y name)
  (let ((e (find-edge-id (position x y 0.0))))
    (if (or (string? e) (null? e))
      (error "CONTACT_EDGE_MISSING" name x y)
      (sdegeo:set-contact-edges e name))))

; "anode": Schottky bottom (0..X_sch), 80nm arc, and vertical rim wall up to -T_sch_wall
(sdegeo:set-current-contact-set "anode")
(contact-at (* 0.5 X_sch) 0.0 "anode")
(contact-at (+ X_sch (* 0.29289322 R_sch_fil)) (- (* 0.29289322 R_sch_fil)) "anode")
(sdegeo:insert-vertex (position X_sch (- T_sch_wall) 0.0))
(contact-at X_sch (* -0.5 (+ R_sch_fil T_sch_wall)) "anode")

; "anode_pgan": p-GaN collar top via (X_via_L..X_via_R)
(sdegeo:set-current-contact-set "anode_pgan")
(contact-at (* 0.5 (+ X_via_L X_via_R)) Y_pgan_top "anode_pgan")

; "anode_fp": all 8 cavity edges (4 straight + 4 fillet arcs)
(sdegeo:set-current-contact-set "anode_fp")
(contact-at 61.0 Y_fp_bot "anode_fp")
(contact-at 61.0 Y_fp_top "anode_fp")
(contact-at X_fp_in  (* 0.5 (+ Y_fp_bot Y_fp_top)) "anode_fp")
(contact-at X_fp_toe (* 0.5 (+ Y_fp_bot Y_fp_top)) "anode_fp")
(contact-at (+ X_fp_in  (* 0.29289322 R_fp_in_fil))  (+ Y_fp_bot (* -0.29289322 R_fp_in_fil))  "anode_fp")
(contact-at (+ X_fp_in  (* 0.29289322 R_fp_in_fil))  (+ Y_fp_top (*  0.29289322 R_fp_in_fil))  "anode_fp")
(contact-at (- X_fp_toe (* 0.29289322 R_fp_toe_bot)) (+ Y_fp_bot (* -0.29289322 R_fp_toe_bot)) "anode_fp")
(contact-at (- X_fp_toe (* 0.29289322 R_fp_toe_top)) (+ Y_fp_top (*  0.29289322 R_fp_toe_top)) "anode_fp")

; "cathode"
(sdegeo:set-current-contact-set "cathode")
(contact-at (* 0.5 W_dev) Y_sub_bot "cathode")

; 8. Region-local Constant Doping
(sdedr:define-constant-profile "prof_sub"    "nTinActiveConcentration" N_sub)
(sdedr:define-constant-profile "prof_epi"    "nSiliconActiveConcentration" N_epi)
(sdedr:define-constant-profile "prof_collar" "pMagnesiumActiveConcentration" P_collar)
(sdedr:define-constant-profile "prof_mid"    "pMagnesiumActiveConcentration" P_mid)
(sdedr:define-constant-profile "prof_jte"    "pMagnesiumActiveConcentration" P_jte)

(sdedr:define-constant-profile-region "place_sub"    "prof_sub"    "region_sub")
(sdedr:define-constant-profile-region "place_epi"    "prof_epi"    "region_epi")
(sdedr:define-constant-profile-region "place_collar" "prof_collar" "region_pgan_collar")
(sdedr:define-constant-profile-region "place_mid"    "prof_mid"    "region_pgan_mid")
(sdedr:define-constant-profile-region "place_jte"    "prof_jte"    "region_pgan")

; 9. Graded Mesh Refinement
(sdedr:define-refinement-window "rw_global" "Rectangle" (position 0.0 Y_amb_top 0.0) (position W_dev Y_sub_bot 0.0))
(sdedr:define-refinement-size "rs_global" 25.0 60.0 2.0 2.0)
(sdedr:define-refinement-placement "rp_global" "rs_global" "rw_global")

(sdedr:define-refinement-window "rw_epi" "Rectangle" (position 0.0 (- Y_al2o3_top 0.5) 0.0) (position (+ X_jte_out 8.0) (+ T_epi 1.0) 0.0))
(sdedr:define-refinement-size "rs_epi" 3.5 1.0 0.50 0.25)
(sdedr:define-refinement-placement "rp_epi" "rs_epi" "rw_epi")

; Fine mesh at Schottky rim + p-GaN inner collar gap
(sdedr:define-refinement-window "rw_rim" "Rectangle" (position (- X_sch 0.3) (- Y_pgan_top 0.15) 0.0) (position (+ X_jte_in 0.4) 0.40 0.0))
(sdedr:define-refinement-size "rs_rim" 0.04 0.025 0.015 0.008)
(sdedr:define-refinement-placement "rp_rim" "rs_rim" "rw_rim")

; Fine mesh across full 3-zone p-GaN JTE and GaN/Ga2O3 interface
(sdedr:define-refinement-window "rw_pgan" "Rectangle" (position (- X_jte_in 0.2) (- Y_pgan_top 0.1) 0.0) (position (+ X_jte_out 1.0) 0.35 0.0))
(sdedr:define-refinement-size "rs_pgan" 1.50 0.08 0.25 0.03)
(sdedr:define-refinement-placement "rp_pgan" "rs_pgan" "rw_pgan")

; Fine mesh around JTE step transitions (56.50, 63.00) and outer edge (87.00)
(sdedr:define-refinement-window "rw_jte23" "Rectangle" (position (- X_jte_23 0.6) (- Y_pgan_top 0.1) 0.0) (position (+ X_jte_23 0.6) 0.35 0.0))
(sdedr:define-refinement-size "rs_jte23" 0.18 0.08 0.05 0.025)
(sdedr:define-refinement-placement "rp_jte23" "rs_jte23" "rw_jte23")

(sdedr:define-refinement-window "rw_jteout" "Rectangle" (position (- X_jte_out 0.5) (- Y_pgan_top 0.1) 0.0) (position (+ X_jte_out 0.5) 0.35 0.0))
(sdedr:define-refinement-size "rs_jteout" 0.18 0.08 0.05 0.025)
(sdedr:define-refinement-placement "rp_jteout" "rs_jteout" "rw_jteout")

; Fine mesh around FP inner corner & FP toe (in Al2O3 & Oxide)
(sdedr:define-refinement-window "rw_fptoe" "Rectangle" (position (- X_fp_toe 0.8) (- Y_fp_top 0.2) 0.0) (position (+ X_fp_toe 0.8) (+ Y_fp_bot 0.4) 0.0))
(sdedr:define-refinement-size "rs_fptoe" 0.25 0.25 0.08 0.08)
(sdedr:define-refinement-placement "rp_fptoe" "rs_fptoe" "rw_fptoe")

(sdedr:define-refinement-window "rw_fpin" "Rectangle" (position (- X_fp_in 0.4) (- Y_fp_top 0.2) 0.0) (position (+ X_fp_in 0.4) (+ Y_fp_bot 0.3) 0.0))
(sdedr:define-refinement-size "rs_fpin" 0.30 0.30 0.10 0.10)
(sdedr:define-refinement-placement "rp_fpin" "rs_fpin" "rw_fpin")

(sde:check-model "v5_dop_0p75x_check.log")
(sde:build-mesh "snmesh" "" "2A_V5_dop_0p75x_sn_msh")
(sde:save-model "v5_dop_0p75x_model")
