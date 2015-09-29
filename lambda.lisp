;;;; info.read-eval-print.lambda.lisp

(in-package #:info.read-eval-print.lambda)

(defmacro ^ (&body body)
    (translate (copy-tree body) nil))

(defun translate (forms parent-args)
  (multiple-value-bind (args lambdas) (parse forms parent-args nil nil)
    (loop for x in lambdas
          for y = (translate (cdr x) (append parent-args args))
          do (setf (car x) (car y)
                   (cdr x) (cdr y)))
    (if (consp (car forms))
        `(lambda ,(args args)
           ,@forms)
         `(lambda ,(args args)
            ,forms))))

(defun parse (forms parent-args args lambdas)
  (cond ((atom forms)
         (when (and (symbol-head-p forms "_")
                    (not (member forms parent-args :test #'eq)))
           (pushnew forms args :test #'eq))
         (values args lambdas))
        ((eq '^ (car forms))
         (push forms lambdas)
         (values args lambdas))
        (t
         (multiple-value-bind (a1 a2)
             (parse (car forms) parent-args args lambdas)
           (multiple-value-bind (b1 b2)
               (parse (cdr forms) parent-args args lambdas)
             (values (remove-duplicates (append a1 b1)) (append a2 b2)))))))

(defun args (args)
  (let ((args (sort args (lambda (a b)
                           (cond ((and (symbol-head-p a "_.")
                                       (symbol-head-p b "_."))
                                  (error "_. is duplicated!"))
                                 ((symbol-head-p a "_.")
                                  nil)
                                 ((symbol-head-p b "_.")
                                  t)
                                 (t
                                  (string< a b)))))))
    (let ((last (car (last args))))
      (if (symbol-head-p last "_.")
          (append (butlast args) `(&rest ,last))
          args))))

(defun symbol-head-p (symbol head)
  (and (symbolp symbol)
       (let ((p (mismatch (symbol-name symbol) head
                          :test #'char-equal)))
         (if p
             (= p (length head))
             t))))
