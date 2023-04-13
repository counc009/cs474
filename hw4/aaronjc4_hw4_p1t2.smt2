(define-fun Es ((r Real) (s Real)) Real
  (+ (* 10 s r)
     (* 80 (- 1 s) r)
     (* 70 s (- 1 r))
     (* 40 (- 1 s) (- 1 r))))
(define-fun Er ((r Real) (s Real)) Real
  (+ (* 90 s r)
     (* 20 (- 1 s) r)
     (* 30 s (- 1 r))
     (* 60 (- 1 s) (- 1 r))))

(define-fun phi ((r Real) (s Real)) Bool
  (and (<= 0 r) (<= r 1) (<= 0 s) (<= s 1)
       (forall ((rp Real)) (=> (and (<= 0 rp) (<= rp 1)) (<= (Er rp s) (Er r s))))
       (forall ((sp Real)) (=> (and (<= 0 sp) (<= sp 1)) (<= (Es r sp) (Es r s))))))

(declare-const rStar Real)
(declare-const sStar Real)
(assert (phi rStar sStar))
(check-sat)
(get-model)
