(sde:clear)
(sdegeo:set-default-boolean "ABA")

; =========================================================================
; 06_Trench_JBS_NoFP (Full Cylindrical, converted directly from 13_OptJTE_V6_NoFP)
;   - Active radius: 0 .. 51.20 um with 10 concentric p-GaN Trench rings
;     (Pitch P = 5.00 um: W_trench = 2.00 um, D_trench = 1.00 um deep in Ga2O3,
;      cap = 0.15 um above y=0 matching V5 JTE height, R_bot_fil = 0.15 um,
;      gap = 0.20 um Al2O3 spacer, W_sch = 2.60 um)
;   - Outer Termination (51.20 .. 135.0 um): 100% matched to V5
;   - Epitaxy / Substrate / Doping: 100% matched to V5 & Yang_SBD_Frozen
; =========================================================================

; Geometry & Doping Constants (um, cm^-3)
(define W_dev       135.0)
(define T_epi        10.0)
(define Y_sub_bot   660.0)
(define T_al2o3       1.50)
(define T_ambient     1.00)
(define T_pgan_jte    0.15)
(define T_tr_cap      0.15)   ; p-GaN cap above y=0
(define D_trench      1.00)   ; p-GaN trench depth into Ga2O3 epi (y = 0..1.00)
(define T_sp_ring     0.30)   ; Al2O3 spacer top above y=0
(define T_sch_wall    0.15)

(define X_sch        51.20)
(define R_sch_fil     0.08)
(define R_ring_fil    0.05)
(define R_tr_bot      0.15)   ; rounded trench bottom corner radius
(define X_via_L      52.50)
(define X_via_R      54.50)


(define X_jte_in     51.45)
(define X_jte_12     56.50)
(define X_jte_23     63.00)
(define X_jte_out    87.00)
(define R_jte_fil     0.05)

(define N_sub        3.6e18)
(define N_epi        2.0e16)
(define P_trench     5.0e18)
(define P_collar     5.0e18)
(define P_mid        2.8e18)
(define P_jte        1.6e18)

(define Y_al2o3_top  (- T_al2o3))              ; -1.50
(define Y_amb_top    (- (+ T_al2o3 T_ambient))) ; -2.50
(define Y_pgan_top   (- T_pgan_jte))           ; -0.15
(define Y_tr_top     (- T_tr_cap))             ; -0.15
(define Y_sp_top     (- T_sp_ring))            ; -0.30

; Active Trench Ring Array Parameters (N_rings = 10, i = 0..9)
(define N_rings      10)
(define R0_pL        1.50)
(define P_ring       5.00)
(define W_pgan_ring  2.00)
(define W_sp_ring    0.20)
(define W_top_ov     0.15)

; -------------------------------------------------------------------------
; 1. Outer V6 Oxide Ambient (No FP)
; -------------------------------------------------------------------------

(sdegeo:set-default-boolean "ABA")
(define reg_ambient (sdegeo:create-rectangle (position X_via_R Y_amb_top 0.0) (position W_dev Y_al2o3_top 0.0) "Oxide" "region_ambient"))

; -------------------------------------------------------------------------
; 2. Outer V5 Al2O3 Spacer (filleted BEFORE Ga2O3 epi)
; -------------------------------------------------------------------------
(sdegeo:set-default-boolean "ABA")
(define reg_al2o3_sp (sdegeo:create-rectangle (position X_sch Y_al2o3_top 0.0) (position X_via_L 0.0 0.0) "AluminumOxide" "region_al2o3_spacer"))
(sdegeo:fillet-2d (car (find-vertex-id (position X_sch 0.0 0.0))) R_sch_fil)

; -------------------------------------------------------------------------
; 3. Active p-GaN Trench Rings + Isolating Al2O3 Spacers FIRST (before epi under BAB!)
;    Because trenches are created & filleted in empty space BEFORE region_epi,
;    BAB lets Ga2O3 epi wrap cleanly around every filleted trench bottom!
; -------------------------------------------------------------------------
(do ((i 0 (+ i 1))) ((= i N_rings))
  (let* ((xL (+ R0_pL (* i P_ring)))
         (xR (+ xL W_pgan_ring))
         (xSL (- xL W_sp_ring))
         (xSR (+ xR W_sp_ring))
         (rname (string-append "region_pgan_trench_" (number->string i)))
         (slname (string-append "region_spL_" (number->string i)))
         (srname (string-append "region_spR_" (number->string i))))
    ; Left & Right Al2O3 sidewall/top spacers
    (sdegeo:create-polygon
      (list
        (position xSL Y_sp_top 0.0)
        (position (+ xL W_top_ov) Y_sp_top 0.0)
        (position (+ xL W_top_ov) Y_tr_top 0.0)
        (position xL Y_tr_top 0.0)
        (position xL 0.0 0.0)
        (position xSL 0.0 0.0)
        (position xSL Y_sp_top 0.0))
      "AluminumOxide" slname)
    (sdegeo:fillet-2d (car (find-vertex-id (position xSL 0.0 0.0))) R_ring_fil)

    (sdegeo:create-polygon
      (list
        (position (- xR W_top_ov) Y_sp_top 0.0)
        (position xSR Y_sp_top 0.0)
        (position xSR 0.0 0.0)
        (position xR 0.0 0.0)
        (position xR Y_tr_top 0.0)
        (position (- xR W_top_ov) Y_tr_top 0.0)
        (position (- xR W_top_ov) Y_sp_top 0.0))
      "AluminumOxide" srname)
    (sdegeo:fillet-2d (car (find-vertex-id (position xSR 0.0 0.0))) R_ring_fil)

    ; p-GaN trench block (y = -0.15 .. +1.00) with rounded bottom corners
    (sdegeo:create-rectangle (position xL Y_tr_top 0.0) (position xR D_trench 0.0) "GaN" rname)
    (sdegeo:fillet-2d (car (find-vertex-id (position xL D_trench 0.0))) R_tr_bot)
    (sdegeo:fillet-2d (car (find-vertex-id (position xR D_trench 0.0))) R_tr_bot)
  )
)

; -------------------------------------------------------------------------
; 4. Substrate, Drift Epi (BAB wraps around trenches!), Outer Al2O3 & V5 JTE
; -------------------------------------------------------------------------
(sdegeo:set-default-boolean "BAB")
(define reg_epi       (sdegeo:create-rectangle (position 0.0     0.0         0.0) (position W_dev T_epi     0.0) "Ga2O3"         "region_epi"))
(define reg_sub       (sdegeo:create-rectangle (position 0.0     T_epi       0.0) (position W_dev Y_sub_bot 0.0) "Ga2O3"         "region_sub"))
(define reg_al2o3_out (sdegeo:create-rectangle (position X_via_R Y_al2o3_top 0.0) (position W_dev 0.0       0.0) "AluminumOxide" "region_passivation"))

(sdegeo:set-default-boolean "ABA")
(define reg_collar (sdegeo:create-rectangle (position X_jte_in Y_pgan_top 0.0) (position X_jte_12  0.0 0.0) "GaN" "region_pgan_collar"))
(define reg_mid    (sdegeo:create-rectangle (position X_jte_12 Y_pgan_top 0.0) (position X_jte_23  0.0 0.0) "GaN" "region_pgan_mid"))
(define reg_pgan   (sdegeo:create-rectangle (position X_jte_23 Y_pgan_top 0.0) (position X_jte_out 0.0 0.0) "GaN" "region_pgan"))

(sdegeo:fillet-2d (car (find-vertex-id (position X_jte_in  Y_pgan_top 0.0))) R_jte_fil)
(sdegeo:fillet-2d (car (find-vertex-id (position X_jte_out Y_pgan_top 0.0))) R_jte_fil)

; Remove dummy FP metal body BEFORE assigning cavity contacts

; -------------------------------------------------------------------------
; -------------------------------------------------------------------------
(sdegeo:define-contact-set "anode"      4.0 (color:rgb 1.0 0.0 0.0) "##")
(sdegeo:define-contact-set "anode_pgan" 4.0 (color:rgb 0.0 0.7 0.0) "##")
(sdegeo:define-contact-set "cathode"    4.0 (color:rgb 0.0 0.0 1.0) "##")

(define (contact-at x y name)
  (let ((e (find-edge-id (position x y 0.0))))
    (if (or (string? e) (null? e))
      (error "CONTACT_EDGE_MISSING" name x y)
      (sdegeo:set-contact-edges e name))))

; "anode": Central Schottky disc, 9 interior Schottky rings, outer ring + V5 rim fillet/wall
(sdegeo:set-current-contact-set "anode")
(contact-at (* 0.5 (- R0_pL W_sp_ring)) 0.0 "anode")
(do ((i 0 (+ i 1))) ((= i (- N_rings 1)))
  (let* ((wL (+ R0_pL (* i P_ring) W_pgan_ring W_sp_ring))
         (wR (- (+ R0_pL (* (+ i 1) P_ring)) W_sp_ring)))
    (contact-at (* 0.5 (+ wL wR)) 0.0 "anode")))
(let ((wLastL (+ R0_pL (* (- N_rings 1) P_ring) W_pgan_ring W_sp_ring)))
  (contact-at (* 0.5 (+ wLastL X_sch)) 0.0 "anode"))
(contact-at (+ X_sch (* 0.29289322 R_sch_fil)) (- (* 0.29289322 R_sch_fil)) "anode")
(sdegeo:insert-vertex (position X_sch (- T_sch_wall) 0.0))
(contact-at X_sch (* -0.5 (+ R_sch_fil T_sch_wall)) "anode")

; "anode_pgan": top via on all 10 Trench rings + outer V5 JTE collar via
(sdegeo:set-current-contact-set "anode_pgan")
(do ((i 0 (+ i 1))) ((= i N_rings))
  (let* ((xL (+ R0_pL (* i P_ring)))
         (xR (+ xL W_pgan_ring)))
    (contact-at (* 0.5 (+ xL xR)) Y_tr_top "anode_pgan")))
(contact-at (* 0.5 (+ X_via_L X_via_R)) Y_pgan_top "anode_pgan")


; "cathode"
(sdegeo:set-current-contact-set "cathode")
(contact-at (* 0.5 W_dev) Y_sub_bot "cathode")

; -------------------------------------------------------------------------
; 6. Region-local Constant Doping
; -------------------------------------------------------------------------
(sdedr:define-constant-profile "prof_sub"    "nTinActiveConcentration" N_sub)
(sdedr:define-constant-profile "prof_epi"    "nSiliconActiveConcentration" N_epi)
(sdedr:define-constant-profile "prof_trench" "pMagnesiumActiveConcentration" P_trench)
(sdedr:define-constant-profile "prof_collar" "pMagnesiumActiveConcentration" P_collar)
(sdedr:define-constant-profile "prof_mid"    "pMagnesiumActiveConcentration" P_mid)
(sdedr:define-constant-profile "prof_jte"    "pMagnesiumActiveConcentration" P_jte)

(sdedr:define-constant-profile-region "place_sub"    "prof_sub"    "region_sub")
(sdedr:define-constant-profile-region "place_epi"    "prof_epi"    "region_epi")
(sdedr:define-constant-profile-region "place_collar" "prof_collar" "region_pgan_collar")
(sdedr:define-constant-profile-region "place_mid"    "prof_mid"    "region_pgan_mid")
(sdedr:define-constant-profile-region "place_jte"    "prof_jte"    "region_pgan")
(do ((i 0 (+ i 1))) ((= i N_rings))
  (sdedr:define-constant-profile-region
    (string-append "place_trench_" (number->string i))
    "prof_trench"
    (string-append "region_pgan_trench_" (number->string i))))

; -------------------------------------------------------------------------
; 7. Graded Mesh Refinement (matched to V5 + trench corner refinement)
; -------------------------------------------------------------------------
(sdedr:define-refinement-window "rw_global" "Rectangle" (position 0.0 Y_amb_top 0.0) (position W_dev Y_sub_bot 0.0))
(sdedr:define-refinement-size "rs_global" 25.0 60.0 2.0 2.0)
(sdedr:define-refinement-placement "rp_global" "rs_global" "rw_global")

(sdedr:define-refinement-window "rw_epi" "Rectangle" (position 0.0 (- Y_al2o3_top 0.5) 0.0) (position (+ X_jte_out 8.0) (+ T_epi 1.0) 0.0))
(sdedr:define-refinement-size "rs_epi" 3.5 1.0 0.50 0.25)
(sdedr:define-refinement-placement "rp_epi" "rs_epi" "rw_epi")

; Active Trench region surface + trench depth NLM/depletion zone
(sdedr:define-refinement-window "rw_active_tr" "Rectangle" (position 0.0 Y_sp_top 0.0) (position X_sch (+ D_trench 0.30) 0.0))
(sdedr:define-refinement-size "rs_active_tr" 0.60 0.25 0.18 0.05)
(sdedr:define-refinement-placement "rp_active_tr" "rs_active_tr" "rw_active_tr")

; Fine refinement at every Trench sidewall & filleted bottom corner
(do ((i 0 (+ i 1))) ((= i N_rings))
  (let* ((xL (+ R0_pL (* i P_ring)))
         (xR (+ xL W_pgan_ring)))
    (sdedr:define-refinement-window (string-append "rw_tL_" (number->string i)) "Rectangle"
      (position (- xL 0.35) (- Y_tr_top 0.05) 0.0) (position (+ xL 0.25) (+ D_trench 0.35) 0.0))
    (sdedr:define-refinement-size (string-append "rs_tL_" (number->string i)) 0.12 0.12 0.05 0.05)
    (sdedr:define-refinement-placement (string-append "rp_tL_" (number->string i)) (string-append "rs_tL_" (number->string i)) (string-append "rw_tL_" (number->string i)))

    (sdedr:define-refinement-window (string-append "rw_tR_" (number->string i)) "Rectangle"
      (position (- xR 0.25) (- Y_tr_top 0.05) 0.0) (position (+ xR 0.35) (+ D_trench 0.35) 0.0))
    (sdedr:define-refinement-size (string-append "rs_tR_" (number->string i)) 0.12 0.12 0.05 0.05)
    (sdedr:define-refinement-placement (string-append "rp_tR_" (number->string i)) (string-append "rs_tR_" (number->string i)) (string-append "rw_tR_" (number->string i)))))

; Outer V5 JTE & FP refinements
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



(sde:check-model "trench_nofp_check.log")
(sde:build-mesh "snmesh" "" "trench_nofp_sn_msh")
(sde:save-model "trench_nofp_sn_model")
