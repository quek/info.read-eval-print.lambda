(mapcar (^ * _ _) (list 1 2 3))
;;⇒ (1 4 9)

(funcall (^ (apply #'+ _.)) 1 2 3)
;;⇒ 6

