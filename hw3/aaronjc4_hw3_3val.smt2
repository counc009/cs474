(define-fun psi () Bool
  (forall ((x Real))
    (exists ((y Real))
      (and (> (* 2 y) (* 3 x))
           (< (* 4 y) (+ (* 8 x) 10))))))

(assert (not psi))
(check-sat)
(reset-assertions)

(assert psi)
(apply qe)
(check-sat)
