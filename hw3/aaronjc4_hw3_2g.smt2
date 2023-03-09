; As normal, I prove validity to showing that the negation of alpha_G is unsat
; We define a function for handling intersection as described in my write-up

(define-fun intersect ((l1 Real) (u1 Real) (l2 Real) (u2 Real)) Bool
  (exists ((z Real)) (and (< l1 z) (< z u1) (< l2 z) (< z u2))))

(define-fun phi ((l1 Real) (u1 Real) (l2 Real) (u2 Real)
                 (l3 Real) (u3 Real) (l4 Real) (u4 Real)) Bool
  (and (intersect l1 u1 l2 u2) (not (intersect l1 u1 l3 u3))
       (intersect l1 u1 l4 u4) (intersect l2 u2 l3 u3)
       (not (intersect l2 u2 l4 u4)) (intersect l3 u3 l4 u4)))

(define-fun alphaG () Bool
  (exists ((l1 Real) (u1 Real) (l2 Real) (u2 Real)
           (l3 Real) (u3 Real) (l4 Real) (u4 Real))
          (phi l1 u1 l2 u2 l3 u3 l4 u4)))

(assert (not alphaG))
(check-sat)
