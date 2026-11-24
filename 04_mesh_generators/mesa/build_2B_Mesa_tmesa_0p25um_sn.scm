(sde:clear)
(sdegeo:set-default-boolean "ABA")

; =========================================================================
; 02_Mesa_JBS (Full Cylindrical, converted directly from 12_OptJTE_V5_FP)
;   - Active radius: 0 .. 51.20 um with 10 concentric p-GaN Mesa rings
;     (Pitch P = 5.00 um: W_pgan = 2.00 um, gap = 0.20 um Al2O3 spacer,
;      W_sch = 2.60 um; center Schottky r = 0..1.30 um; outer = 48.70..51.20)
;   - Outer Termination (51.20 .. 135.0 um): 100% matched to V5
;     (3-Zone stepped p-GaN JTE + 1.50 um Al2O3 + rounded buried anode_fp)
;   - Epitaxy / Substrate / Doping: 100% matched to V5 & Yang_SBD_Frozen
; =========================================================================

; Geometry & Doping Constants (um, cm^-3)
(define W_dev       135.0)
(define T_epi        10.0)
(define Y_sub_bot   660.0)
(define T_al2o3       1.50)
(define T_ambient     1.00)
(define T_pgan_jte    0.15)
(define T_mesa        0.25)   ; active p-GaN Mesa thickness above y=0
(define T_sp_ring     0.40)   ; Al2O3 spacer height around each active mesa ring
(define T_sch_wall    0.15)

(define X_sch        51.20)
(define R_sch_fil     0.08)
(define R_ring_fil    0.05)
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
(define P_mesa       5.0e18)
(define P_collar     5.0e18)
(define P_mid        2.8e18)
(define P_jte        1.6e18)

(define Y_al2o3_top  (- T_al2o3))              ; -1.50
(define Y_amb_top    (- (+ T_al2o3 T_ambient))) ; -2.50
(define Y_pgan_top   (- T_pgan_jte))           ; -0.15
(define Y_mesa_top   (- T_mesa))               ; -0.50
(define Y_sp_top     (- T_sp_ring))            ; -0.65
(define Y_fp_bot     Y_al2o3_top)              ; -1.50
(define Y_fp_top     (- Y_fp_bot T_fp_metal))  ; -1.80

; Active Mesa Ring Array Parameters (N_rings = 10, i = 0..9)
(define N_rings      10)
(define R0_pL        1.50)
(define P_ring       5.00)
(define W_pgan_ring  2.00)
(define W_sp_ring    0.20)
(define W_top_ov     0.15)  ; Al2O3 overlap on mesa top shoulder before anode_pgan via

; -------------------------------------------------------------------------
; 1. Outer V5 FP Dummy Metal & Oxide Ambient
; -------------------------------------------------------------------------
(define reg_fp (sdegeo:create-rectangle (position X_fp_in Y_fp_top 0.0) (position X_fp_toe Y_fp_bot 0.0) "Aluminum" "region_fp_dummy"))
(sdegeo:fillet-2d (car (find-vertex-id (position X_fp_in  Y_fp_bot 0.0))) R_fp_in_fil)
(sdegeo:fillet-2d (car (find-vertex-id (position X_fp_in  Y_fp_top 0.0))) R_fp_in_fil)
(sdegeo:fillet-2d (car (find-vertex-id (position X_fp_toe Y_fp_bot 0.0))) R_fp_toe_bot)
(sdegeo:fillet-2d (car (find-vertex-id (position X_fp_toe Y_fp_top 0.0))) R_fp_toe_top)

(sdegeo:set-default-boolean "BAB")
(define reg_ambient (sdegeo:create-rectangle (position X_via_R Y_amb_top 0.0) (position W_dev Y_al2o3_top 0.0) "Oxide" "region_ambient"))

; -------------------------------------------------------------------------
; 2. Outer V5 Al2O3 Spacer (filleted BEFORE Ga2O3 epi)
; -------------------------------------------------------------------------
(sdegeo:set-default-boolean "ABA")
(define reg_al2o3_sp (sdegeo:create-rectangle (position X_sch Y_al2o3_top 0.0) (position X_via_L 0.0 0.0) "AluminumOxide" "region_al2o3_spacer"))
(sdegeo:fillet-2d (car (find-vertex-id (position X_sch 0.0 0.0))) R_sch_fil)

; -------------------------------------------------------------------------
; 3. Active Mesa p-GaN Rings + Isolating Al2O3 Sidewall Spacers (in empty space BEFORE epi)
; -------------------------------------------------------------------------
(do ((i 0 (+ i 1))) ((= i N_rings))
  (let* ((xL (+ R0_pL (* i P_ring)))
         (xR (+ xL W_pgan_ring))
         (xSL (- xL W_sp_ring))
         (xSR (+ xR W_sp_ring))
         (rname (string-append "region_pgan_mesa_" (number->string i)))
         (slname (string-append "region_spL_" (number->string i)))
         (srname (string-append "region_spR_" (number->string i))))
    ; Left and right Al2O3 sidewall spacers (with 50nm fillet at Ga2O3 Schottky edge)
    (sdegeo:create-polygon
      (list
        (position xSL Y_sp_top 0.0)
        (position (+ xL W_top_ov) Y_sp_top 0.0)
        (position (+ xL W_top_ov) Y_mesa_top 0.0)
        (position xL Y_mesa_top 0.0)
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
        (position xR Y_mesa_top 0.0)
        (position (- xR W_top_ov) Y_mesa_top 0.0)
        (position (- xR W_top_ov) Y_sp_top 0.0))
      "AluminumOxide" srname)
    (sdegeo:fillet-2d (car (find-vertex-id (position xSR 0.0 0.0))) R_ring_fil)

    ; p-GaN mesa body
    (sdegeo:create-rectangle (position xL Y_mesa_top 0.0) (position xR 0.0 0.0) "GaN" rname)
  )
)

; -------------------------------------------------------------------------
; 4. Substrate, Drift Epi, Outer Al2O3 Passivation & V5 3-Zone JTE
; -------------------------------------------------------------------------
(define reg_sub       (sdegeo:create-rectangle (position 0.0     T_epi       0.0) (position W_dev Y_sub_bot 0.0) "Ga2O3"         "region_sub"))
(define reg_epi       (sdegeo:create-rectangle (position 0.0     0.0         0.0) (position W_dev T_epi     0.0) "Ga2O3"         "region_epi"))
(define reg_al2o3_out (sdegeo:create-rectangle (position X_via_R Y_al2o3_top 0.0) (position W_dev 0.0       0.0) "AluminumOxide" "region_passivation"))

(define reg_collar (sdegeo:create-rectangle (position X_jte_in Y_pgan_top 0.0) (position X_jte_12  0.0 0.0) "GaN" "region_pgan_collar"))
(define reg_mid    (sdegeo:create-rectangle (position X_jte_12 Y_pgan_top 0.0) (position X_jte_23  0.0 0.0) "GaN" "region_pgan_mid"))
(define reg_pgan   (sdegeo:create-rectangle (position X_jte_23 Y_pgan_top 0.0) (position X_jte_out 0.0 0.0) "GaN" "region_pgan"))

(sdegeo:fillet-2d (car (find-vertex-id (position X_jte_in  Y_pgan_top 0.0))) R_jte_fil)
(sdegeo:fillet-2d (car (find-vertex-id (position X_jte_out Y_pgan_top 0.0))) R_jte_fil)

; Remove dummy FP metal body BEFORE assigning cavity contacts
(sdegeo:delete-region (find-body-id (position 61.0 -1.65 0.0)))

; -------------------------------------------------------------------------
; 5. Contacts (Strictly Disjoint: anode, anode_pgan, anode_fp, cathode)
; -------------------------------------------------------------------------
(sdegeo:define-contact-set "anode"      4.0 (color:rgb 1.0 0.0 0.0) "##")
(sdegeo:define-contact-set "anode_pgan" 4.0 (color:rgb 0.0 0.7 0.0) "##")
(sdegeo:define-contact-set "anode_fp"   4.0 (color:rgb 0.9 0.5 0.0) "##")
(sdegeo:define-contact-set "cathode"    4.0 (color:rgb 0.0 0.0 1.0) "##")

(define (contact-at x y name)
  (let ((e (find-edge-id (position x y 0.0))))
    (if (or (string? e) (null? e))
      (error "CONTACT_EDGE_MISSING" name x y)
      (sdegeo:set-contact-edges e name))))

; "anode": Central Schottky disc (0..1.30), 9 interior Schottky rings, outer Schottky ring (48.70..51.20) + V5 rim fillet/wall
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

; "anode_pgan": top via on all 10 Mesa rings + outer V5 JTE collar via
(sdegeo:set-current-contact-set "anode_pgan")
(do ((i 0 (+ i 1))) ((= i N_rings))
  (let* ((xL (+ R0_pL (* i P_ring)))
         (xR (+ xL W_pgan_ring)))
    (contact-at (* 0.5 (+ xL xR)) Y_mesa_top "anode_pgan")))
(contact-at (* 0.5 (+ X_via_L X_via_R)) Y_pgan_top "anode_pgan")

; "anode_fp": V5 cavity edges
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

; -------------------------------------------------------------------------
; 6. Region-local Constant Doping
; -------------------------------------------------------------------------
(sdedr:define-constant-profile "prof_sub"    "nTinActiveConcentration" N_sub)
(sdedr:define-constant-profile "prof_epi"    "nSiliconActiveConcentration" N_epi)
(sdedr:define-constant-profile "prof_mesa"   "pMagnesiumActiveConcentration" P_mesa)
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
    (string-append "place_mesa_" (number->string i))
    "prof_mesa"
    (string-append "region_pgan_mesa_" (number->string i))))

; -------------------------------------------------------------------------
; 7. Graded Mesh Refinement (matched to V5 + ring corner refinement)
; -------------------------------------------------------------------------
(sdedr:define-refinement-window "rw_global" "Rectangle" (position 0.0 Y_amb_top 0.0) (position W_dev Y_sub_bot 0.0))
(sdedr:define-refinement-size "rs_global" 25.0 60.0 2.0 2.0)
(sdedr:define-refinement-placement "rp_global" "rs_global" "rw_global")

(sdedr:define-refinement-window "rw_epi" "Rectangle" (position 0.0 (- Y_al2o3_top 0.5) 0.0) (position (+ X_jte_out 8.0) (+ T_epi 1.0) 0.0))
(sdedr:define-refinement-size "rs_epi" 3.5 1.0 0.50 0.25)
(sdedr:define-refinement-placement "rp_epi" "rs_epi" "rw_epi")

; Active Mesa region interface & vertical NLM grid
(sdedr:define-refinement-window "rw_active_surf" "Rectangle" (position 0.0 Y_sp_top 0.0) (position X_sch 0.60 0.0))
(sdedr:define-refinement-size "rs_active_surf" 0.60 0.25 0.18 0.05)
(sdedr:define-refinement-placement "rp_active_surf" "rs_active_surf" "rw_active_surf")

; Fine refinement at every Mesa ring left & right foot corner
(do ((i 0 (+ i 1))) ((= i N_rings))
  (let* ((xL (+ R0_pL (* i P_ring)))
         (xR (+ xL W_pgan_ring)))
    (sdedr:define-refinement-window (string-append "rw_mL_" (number->string i)) "Rectangle"
      (position (- xL 0.18) -0.15 0.0) (position (+ xL 0.15) 0.20 0.0))
    (sdedr:define-refinement-size (string-append "rs_mL_" (number->string i)) 0.10 0.08 0.04 0.04)
    (sdedr:define-refinement-placement (string-append "rp_mL_" (number->string i)) (string-append "rs_mL_" (number->string i)) (string-append "rw_mL_" (number->string i)))

    (sdedr:define-refinement-window (string-append "rw_mR_" (number->string i)) "Rectangle"
      (position (- xR 0.15) -0.15 0.0) (position (+ xR 0.18) 0.20 0.0))
    (sdedr:define-refinement-size (string-append "rs_mR_" (number->string i)) 0.10 0.08 0.04 0.04)
    (sdedr:define-refinement-placement (string-append "rp_mR_" (number->string i)) (string-append "rs_mR_" (number->string i)) (string-append "rw_mR_" (number->string i)))))

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

(sdedr:define-refinement-window "rw_fptoe" "Rectangle" (position (- X_fp_toe 0.8) (- Y_fp_top 0.2) 0.0) (position (+ X_fp_toe 0.8) (+ Y_fp_bot 0.4) 0.0))
(sdedr:define-refinement-size "rs_fptoe" 0.25 0.25 0.08 0.08)
(sdedr:define-refinement-placement "rp_fptoe" "rs_fptoe" "rw_fptoe")

(sdedr:define-refinement-window "rw_fpin" "Rectangle" (position (- X_fp_in 0.4) (- Y_fp_top 0.2) 0.0) (position (+ X_fp_in 0.4) (+ Y_fp_bot 0.3) 0.0))
(sdedr:define-refinement-size "rs_fpin" 0.30 0.30 0.10 0.10)
(sdedr:define-refinement-placement "rp_fpin" "rs_fpin" "rw_fpin")

(sde:check-model "mesa_tmesa_0p25um_check.log")
(sde:build-mesh "snmesh" "" "../2B_Mesa_tmesa_0p25um_sn_msh")
(sde:save-model "mesa_tmesa_0p25um_model")
