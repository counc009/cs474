(declare-const p Bool)
(declare-const q Bool)
(declare-const r Bool)

(define-fun phi () Bool
  (and (or q (not r))
       (or (not p) r)
       (or (not q) r p)
       (or p q (not q))
       (or (not r) q)))
(define-fun Psi () Bool
  (and (or p q (not q))
       (or p (not q) r)
       (or (not p) r)
       (or q (not r))
       (or q (not q) r)
       (or (not q) r)
       (or (not p) q)
       (or q (not q))
       (or p q (not q) r)
       (or p q (not r))
       (or p r (not r))
       (or q r (not r))
       (or r (not r))
       (or p (not p) q)
       (or p (not p) r)
       (or (not p) q r)
       (or p q r (not r))
       (or p (not p) q r)))

; To verify that phi and Psi are equivalent, we want to check that the equation
; phi != Psi is unsatisfiable; we can implement equality using propositional
; logic as phi <=> Psi, which is equivalent to phi => Psi and Psi => phi, which
; in turn we have that p => q is equivalent to not p or q.
; So, the negation of the equality check is as follows
(assert (not (and (or (not phi) Psi) (or (not Psi) phi))))

(check-sat) ; If this yields unsat then we know phi == Psi
