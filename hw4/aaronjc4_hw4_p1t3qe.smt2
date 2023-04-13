(declare-const PA11 Real) (declare-const PA12 Real)
(declare-const PA21 Real) (declare-const PA22 Real)
(declare-const PB11 Real) (declare-const PB12 Real)
(declare-const PB21 Real) (declare-const PB22 Real)

(define-fun Ea ((a Real) (b Real))
  Real
  (+ (* PA11 a b)
     (* PA12 a (- 1 b))
     (* PA21 (- 1 a) b)
     (* PA22 (- 1 a) (- 1 b))))
(define-fun Eb ((a Real) (b Real))
  Real
  (+ (* PB11 a b)
     (* PB12 a (- 1 b))
     (* PB21 (- 1 a) b)
     (* PB22 (- 1 a) (- 1 b))))

(declare-const a Real)
(declare-const b Real)

(define-fun psi () Bool
  (and (<= 0 a) (<= a 1) (<= 0 b) (<= b 1)
        (forall ((ap Real)) (=> (and (<= 0 ap) (<= ap 1))
                              (<= (Ea ap b)
                                  (Ea a b))))
        (forall ((bp Real)) (=> (and (<= 0 bp) (<= bp 1))
                              (<= (Eb a bp)
                                  (Eb a b))))))

(assert psi)
(apply qe)
