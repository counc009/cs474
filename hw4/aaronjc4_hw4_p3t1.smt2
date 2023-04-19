(declare-sort A)
(declare-fun f (A A) A)
(declare-fun g (A) A)
(declare-const e A)
(declare-const i A)

(assert
  (and
    (= (f e i) e) (= (f i e) e) (not (= e i))
    (= (f i i) i) (= (f i i) i) (not (= e i))
    
    (= (f e (g e)) e) (= (f (g e) e) e)
    (= (f i (g i)) e) (= (f (g i) i) e)

    (= (f e e) e) (= (f e e) e)
    (= (f i e) i) (= (f e i) i)

    (= (f (f e e) e) (f e (f e e)))
    (= (f (f e e) i) (f e (f e i)))
    (= (f (f e i) e) (f e (f i e)))
    (= (f (f e i) i) (f e (f i i)))
    (= (f (f i e) e) (f i (f e e)))
    (= (f (f i e) i) (f i (f e i)))
    (= (f (f i i) e) (f i (f i e)))
    (= (f (f i i) i) (f i (f i i)))
  )
)
(check-sat)
