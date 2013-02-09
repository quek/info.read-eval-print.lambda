(in-package :info.read-eval-print.lambda)

(assert (equal '((2) (3) (4)) (mapcar (^ list (1+ _)) '(1 2 3))))

(assert (equal '(1 4 9) (mapcar (^ * _ _) '(1 2 3))))

(assert (equal '((1 a "A") (2 b "B"))
               (mapcar (^ list _z _y _x) '("A" "B") '(a b) '(1 2))))

(assert (equal '(1 2 3)
               (funcall (^ identity _rest) 1 2 3)))

(assert (equal '(2 1 3 4)
               (funcall (^ apply #'list _b _a _rest) 1 2 3 4)))

(assert (equal "a"
               (with-output-to-string (*standard-output*)
                 (funcall (^ princ _) #\a))))

(assert (equal "cba"
               (with-output-to-string (*standard-output*)
                 (funcall (^ (princ _z) (princ _y) (princ _x)) #\a #\b #\c))))
