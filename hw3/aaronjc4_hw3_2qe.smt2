(declare-const l1 Real)
(declare-const u1 Real)
(declare-const l2 Real)
(declare-const u2 Real)

(assert (forall ((z Real))
          (implies
            (and (< l1 z) (< z u1) (< l2 z) (< z u2))
            (exists ((w Real))
              (and (< l1 w) (< w u1) (< l2 w) (< w u2) (not (= w z)))))))
(apply qe)
