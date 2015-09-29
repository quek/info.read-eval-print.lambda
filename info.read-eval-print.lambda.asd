;;;; info.read-eval-print.lambda.asd

(asdf:defsystem #:info.read-eval-print.lambda
  :version "0.0.1"
  :serial t
  :description "(^ * _ _) => (lambda (x) (* x x))"
  :author "TAHARA Yoshinori <read.eval.print@gmail.com>"
  :license "BSD"
  :components ((:file "package")
               (:file "lambda")))

