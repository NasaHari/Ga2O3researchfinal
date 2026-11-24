(sde:clear)
(sdegeo:set-default-boolean "ABA")

; =========================================================================
; 13_OptJTE_V6_NoFP_bh5e7: Ablation Control WITHOUT Field Plate
; Exact 1-for-1 match to 12_OptJTE_V5_FP_bh5e7 (R_sch_fil=0.08, X_jte_in=51.45,
; b_h=5.00e7 V/cm), with ONLY the anode_fp metal cavity removed.
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

(define X_jte_in     51.45)
(define X_jte_12     56.50)
(define X_jte_23     63.00)
(define X_jte_out    87.00)
(define R_jte_fil     0.05)

(define N_sub        3.6e18)
(define N_epi        2.0e16)
(define P_collar     5.0e18)
(define P_mid        2.8e18)
(define P_jte        1.6e18)

(define Y_al2o3_top  (- T_al2o3))              ; -1.50
(define Y_amb_top    (- (+ T_al2o3 T_ambient))) ; -2.50
(define Y_pgan_top   (- T_pgan))               ; -0.15

; 1. Outer Oxide Ambient (no FP cavity)
(define reg_ambient (sdegeo:create-rectangle (position X_via_R Y_amb_top 0.0) (position W_dev Y_al2o3_top 0.0) "Oxide" "region_ambient"))

; 2. Al2O3 spacer (filleted BEFORE Ga2O3 epi)
(define reg_al2o3_sp (sdegeo:create-rectangle (position X_sch Y_al2o3_top 0.0) (position X_via_L 0.0 0.0) "AluminumOxide" "region_al2o3_spacer"))
(sdegeo:fillet-2d (car (find-vertex-id (position X_sch 0.0 0.0))) R_sch_fil)

; 3. Substrate, Drift Epi, and Outer Al2O3 Passivation
(define reg_sub       (sdegeo:create-rectangle (position 0.0     T_epi       0.0) (position W_dev Y_sub_bot 0.0) "Ga2O3"         "region_sub"))
(define reg_epi       (sdegeo:create-rectangle (position 0.0     0.0         0.0) (position W_dev T_epi     0.0) "Ga2O3"         "region_epi"))
(define reg_al2o3_out (sdegeo:create-rectangle (position X_via_R Y_al2o3_top 0.0) (position W_dev 0.0       0.0) "AluminumOxide" "region_passivation"))

; 4. 3-Zone Stepped p-GaN JTE
(define reg_collar (sdegeo:create-rectangle (position X_jte_in Y_pgan_top 0.0) (position X_jte_12  0.0 0.0) "GaN" "region_pgan_collar"))
(define reg_mid    (sdegeo:create-rectangle (position X_jte_12 Y_pgan_top 0.0) (position X_jte_23  0.0 0.0) "GaN" "region_pgan_mid"))
(define reg_pgan   (sdegeo:create-rectangle (position X_jte_23 Y_pgan_top 0.0) (position X_jte_out 0.0 0.0) "GaN" "region_pgan"))

(sdegeo:fillet-2d (car (find-vertex-id (position X_jte_in  Y_pgan_top 0.0))) R_jte_fil)
(sdegeo:fillet-2d (car (find-vertex-id (position X_jte_out Y_pgan_top 0.0))) R_jte_fil)

; 5. Contacts (helper fails cleanly if any edge is missing)
(sdegeo:define-contact-set "anode"      4.0 (color:rgb 1.0 0.0 0.0) "##")
(sdegeo:define-contact-set "anode_pgan" 4.0 (color:rgb 0.0 0.7 0.0) "##")
(sdegeo:define-contact-set "cathode"    4.0 (color:rgb 0.0 0.0 1.0) "##")

(define (contact-at x y name)
  (let ((e (find-edge-id (position x y 0.0))))
    (if (or (string? e) (null? e))
      (error "CONTACT_EDGE_MISSING" name x y)
      (sdegeo:set-contact-edges e name))))

(sdegeo:set-current-contact-set "anode")
(contact-at (* 0.5 X_sch) 0.0 "anode")
(contact-at (+ X_sch (* 0.29289322 R_sch_fil)) (- (* 0.29289322 R_sch_fil)) "anode")
(sdegeo:insert-vertex (position X_sch (- T_sch_wall) 0.0))
(contact-at X_sch (* -0.5 (+ R_sch_fil T_sch_wall)) "anode")

(sdegeo:set-current-contact-set "anode_pgan")
(contact-at (* 0.5 (+ X_via_L X_via_R)) Y_pgan_top "anode_pgan")

(sdegeo:set-current-contact-set "cathode")
(contact-at (* 0.5 W_dev) Y_sub_bot "cathode")

; 6. Region-local Constant Doping
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

; 7. Graded Mesh Refinement (matched to V5)
(sdedr:define-refinement-window "rw_global" "Rectangle" (position 0.0 Y_amb_top 0.0) (position W_dev Y_sub_bot 0.0))
(sdedr:define-refinement-size "rs_global" 25.0 60.0 2.0 2.0)
(sdedr:define-refinement-placement "rp_global" "rs_global" "rw_global")

(sdedr:define-refinement-window "rw_epi" "Rectangle" (position 0.0 (- Y_al2o3_top 0.5) 0.0) (position (+ X_jte_out 8.0) (+ T_epi 1.0) 0.0))
(sdedr:define-refinement-size "rs_epi" 3.5 1.0 0.50 0.25)
(sdedr:define-refinement-placement "rp_epi" "rs_epi" "rw_epi")

(sdedr:define-refinement-window "rw_rim" "Rectangle" (position (- X_sch 0.3) (- Y_pgan_top 0.15) 0.0) (position (+ X_jte_in 0.4) 0.40 0.0))
(sdedr:define-refinement-size "rs_rim" 0.04 0.025 0.015 0.008)
(sdedr:define-refinement-placement "rp_rim" "rs_rim" "rw_rim")

(sdedr:define-refinement-window "rw_pgan" "Rectangle" (position (- X_jte_in 0.2) (- Y_pgan_top 0.1) 0.0) (position (+ X_jte_out 1.0) 0.35 0.0))
(sdedr:define-refinement-size "rs_pgan" 1.50 0.08 0.25 0.03)
(sdedr:define-refinement-placement "rp_pgan" "rs_pgan" "rw_pgan")

(sdedr:define-refinement-window "rw_jte23" "Rectangle" (position (- X_jte_23 0.6) (- Y_pgan_top 0.1) 0.0) (position (+ X_jte_23 0.6) 0.35 0.0))
(sdedr:define-refinement-size "rs_jte23" 0.18 0.08 0.05 0.025)
(sdedr:define-refinement-placement "rp_jte23" "rs_jte23" "rw_jte23")

(sdedr:define-refinement-window "rw_jteout" "Rectangle" (position (- X_jte_out 0.5) (- Y_pgan_top 0.1) 0.0) (position (+ X_jte_out 0.5) 0.35 0.0))
(sdedr:define-refinement-size "rs_jteout" 0.18 0.08 0.05 0.025)
(sdedr:define-refinement-placement "rp_jteout" "rs_jteout" "rw_jteout")

(sde:check-model "planar_nofp_check.log")
(sde:build-mesh "snmesh" "" "planar_nofp_sn_msh")
(sde:save-model "planar_nofp_sn_model")
