(define-fun Ea ((PA11 Real) (PA12 Real) (PA21 Real) (PA22 Real)
                (a Real) (b Real))
  Real
  (+ (* PA11 a b)
     (* PA12 a (- 1 b))
     (* PA21 (- 1 a) b)
     (* PA22 (- 1 a) (- 1 b))))
(define-fun Eb ((PB11 Real) (PB12 Real) (PB21 Real) (PB22 Real)
                (a Real) (b Real))
  Real
  (+ (* PB11 a b)
     (* PB12 a (- 1 b))
     (* PB21 (- 1 a) b)
     (* PB22 (- 1 a) (- 1 b))))

(define-fun psiFunc ((PA11 Real) (PA12 Real) (PA21 Real) (PA22 Real)
                     (PB11 Real) (PB12 Real) (PB21 Real) (PB22 Real)
                     (a Real) (b Real))
  Bool
  (and (<= 0 a) (<= a 1) (<= 0 b) (<= b 1)
        (forall ((ap Real)) (=> (and (<= 0 ap) (<= ap 1))
                              (<= (Ea PA11 PA12 PA21 PA22 ap b)
                                  (Ea PA11 PA12 PA21 PA22 a b))))
        (forall ((bp Real)) (=> (and (<= 0 bp) (<= bp 1))
                              (<= (Eb PB11 PB12 PB21 PB22 a bp)
                                  (Eb PB11 PB12 PB21 PB22 a b))))))
(define-fun psi () Bool
  (forall ((PA11 Real) (PA12 Real) (PA21 Real) (PA22 Real)
           (PB11 Real) (PB12 Real) (PB21 Real) (PB22 Real))
    (exists ((a Real) (b Real))
      (psiFunc PA11 PA12 PA21 PA22 PB11 PB12 PB21 PB22 a b))))

(assert (not psi))
(check-sat)
