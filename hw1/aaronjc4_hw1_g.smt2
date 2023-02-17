; We take the colors to be 0, 1, and 2
; A proposition p_n_c being true denotes that node n has color c
(declare-const p_0_0 Bool)
(declare-const p_0_1 Bool)
(declare-const p_0_2 Bool)
(declare-const p_1_0 Bool)
(declare-const p_1_1 Bool)
(declare-const p_1_2 Bool)
(declare-const p_2_0 Bool)
(declare-const p_2_1 Bool)
(declare-const p_2_2 Bool)
(declare-const p_3_0 Bool)
(declare-const p_3_1 Bool)
(declare-const p_3_2 Bool)

; Now, we add build constraints that each node has a single color
(define-fun n0color () Bool
  (or (and p_0_0 (not p_0_1) (not p_0_2))
      (and p_0_1 (not p_0_0) (not p_0_2))
      (and p_0_2 (not p_0_0) (not p_0_1))))
(define-fun n1color () Bool
  (or (and p_1_0 (not p_1_1) (not p_1_2))
      (and p_1_1 (not p_1_0) (not p_1_2))
      (and p_1_2 (not p_1_0) (not p_1_1))))
(define-fun n2color () Bool
  (or (and p_2_0 (not p_2_1) (not p_2_2))
      (and p_2_1 (not p_2_0) (not p_2_2))
      (and p_2_2 (not p_2_0) (not p_2_1))))
(define-fun n3color () Bool
  (or (and p_3_0 (not p_3_1) (not p_3_2))
      (and p_3_1 (not p_3_0) (not p_3_2))
      (and p_3_2 (not p_3_0) (not p_3_1))))

; And assert them
(assert n0color)
(assert n1color)
(assert n2color)
(assert n3color)

; Now, add the constraints for the edges
(define-fun edge_0_1 () Bool
  (or (and p_0_0 (not p_1_0)) (and p_0_1 (not p_1_1)) (and p_0_2 (not p_1_2))))
(define-fun edge_0_2 () Bool
  (or (and p_0_0 (not p_2_0)) (and p_0_1 (not p_2_1)) (and p_0_2 (not p_2_2))))
(define-fun edge_0_3 () Bool
  (or (and p_0_0 (not p_3_0)) (and p_0_1 (not p_3_1)) (and p_0_2 (not p_3_2))))
(define-fun edge_1_2 () Bool
  (or (and p_1_0 (not p_2_0)) (and p_1_1 (not p_2_1)) (and p_1_2 (not p_2_2))))
(define-fun edge_1_3 () Bool
  (or (and p_1_0 (not p_3_0)) (and p_1_1 (not p_3_1)) (and p_1_2 (not p_3_2))))
(define-fun edge_2_3 () Bool
  (or (and p_2_0 (not p_3_0)) (and p_2_1 (not p_3_1)) (and p_2_2 (not p_3_2))))

; And assert them
(assert edge_0_1)
(assert edge_0_2)
(assert edge_0_3)
(assert edge_1_2)
(assert edge_1_3)
(assert edge_2_3)

(check-sat)
