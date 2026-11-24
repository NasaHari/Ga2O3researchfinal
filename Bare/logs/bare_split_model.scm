
;; Defined Parameters:

;; Contact Sets:
(sdegeo:define-contact-set "anode" 4 (color:rgb 1 0 0 )"##" )
(sdegeo:define-contact-set "anode_rim" 4 (color:rgb 1 0.5 0 )"##" )
(sdegeo:define-contact-set "cathode" 4 (color:rgb 0 0 1 )"##" )

;; Work Planes:
(sde:workplanes-init-scm-binding)

;; Defined ACIS Refinements:
(sde:refinement-init-scm-binding)

;; Reference/Evaluation Windows:
(sdedr:define-refeval-window "Win_Schottky" "Rectangle" (position 0 0 0) (position 52.5 0.5 0))
(sdedr:define-refeval-window "Win_Corner_Core" "Rectangle" (position 52.3 -0.15 0) (position 52.7 0.15 0))
(sdedr:define-refeval-window "Win_Corner_Graded_In" "Rectangle" (position 51 0 0) (position 52.5 1 0))
(sdedr:define-refeval-window "Win_Corner_Graded_Out_Amb" "Rectangle" (position 52.5 -0.2 0) (position 54 0 0))
(sdedr:define-refeval-window "Win_Corner_Graded_Out_Semi" "Rectangle" (position 52.5 0 0) (position 54 1 0))
(sdedr:define-refeval-window "Win_Corner_Outer" "Rectangle" (position 48.5 0 0) (position 56.5 2.5 0))
