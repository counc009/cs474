; As normal, I prove validity to showing that the negation of alpha_G is unsat
; We define a function for handling intersection as described in my write-up

(declare-const l1 Real)
(declare-const u1 Real)
(declare-const l2 Real)
(declare-const u2 Real)
(declare-const l3 Real)
(declare-const u3 Real)
(declare-const l4 Real)
(declare-const u4 Real)

(define-fun intersect ((lA Real) (uA Real) (lB Real) (uB Real)) Bool
  (exists ((z Real)) (and (< lA z) (< z uA) (< lB z) (< z uB))))

(define-fun phi () Bool
  (and (intersect l1 u1 l2 u2) (not (intersect l1 u1 l3 u3))
       (intersect l1 u1 l4 u4) (intersect l2 u2 l3 u3)
       (not (intersect l2 u2 l4 u4)) (intersect l3 u3 l4 u4)))

(assert phi)
(check-sat)
