(declare-const PA11 Real) (declare-const PA12 Real)
(declare-const PA21 Real) (declare-const PA22 Real)
(declare-const PB11 Real) (declare-const PB12 Real)
(declare-const PB21 Real) (declare-const PB22 Real)

(define-fun Ea ((a Real) (b Real))
  Real
  (+ (* a (+ (* PA11 b) PA12 (* PA12 (- 1.0) b) (* PA21 (- 1.0) b)
             (* PA22 (- 1.0)) ))
     (* a (* PA22 b))
     (+ (* PA21 b) PA22 (* PA22 (- 1.0) b))
  )
)

(define-fun Eb ((a Real) (b Real))
  Real
  (+ (* b (+ (* PA11 a) (* PA12 a (- 1.0)) PA21 (* PA21 (- 1.0) a)
             (* PA22 (- 1.0)) (* PA22 a)))
     (+ (* PA12 a) PA22 (* PA22 (- 1.0) a))
  )
)

(declare-const a Real)
(declare-const b Real)

(assert (and (<= 0.0 a) (<= a 1.0) (<= 0.0 b) (<= b 1.0)
        (forall ((ap Real)) (=> (and (<= 0.0 ap) (<= ap 1.0))
                                (<= (Ea ap b) (Ea a b))))
        (forall ((bp Real)) (=> (and (<= 0.0 bp) (<= bp 1.0))
                                (<= (Eb a bp) (Eb a b))))))
(apply (! qe :qe-nonlinear true))
