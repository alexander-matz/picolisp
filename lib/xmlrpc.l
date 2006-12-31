# 22oct06abu
# (c) Software Lab. Alexander Burger

# (xmlrpc "localhost" 8080 "foo.bar" 'int 41 'string "abc" ..)
(de xmlrpc (Host Port Meth . @)
   (let? Sock (connect Host Port)
      (let Xml (tmp 'xmlrpc)
         (out Xml
            (prinl "<?xml version=\"1.0\" encoding=\"utf-8\"?>")
            (xml
               (list 'methodCall NIL
                  (list 'methodName NIL Meth)
                  (make
                     (link 'params NIL)
                     (while (args)
                        (link
                           (list 'param NIL
                              (list 'value NIL (list (next) NIL (next))) ) ) ) ) ) ) )
         (prog1
            (out Sock
               (prinl "POST /RPC2 HTTP/1.0^M")
               (prinl "Host: " Host "^M")
               (prinl "User-Agent: PicoLisp^M")
               (prinl "Content-Type: text/xml^M")
               (prinl "Accept-Charset: utf-8^M")
               (prinl "Content-Length: " (car (info Xml)) "^M")
               (prinl "^M")
               (in Xml (echo))
               (flush)
               (in Sock
                  (while (line))
                  (let? L (and (xml?) (xml))
                     (when (== 'methodResponse (car L))
                        (xmlrpcValue
                           (car (body L 'params 'param 'value)) ) ) ) ) )
            (close Sock) ) ) ) )

(de xmlrpcKey (Str)
   (or (format Str) (intern Str)) )

(de xmlrpcValue (Lst)
   (let X (caddr Lst)
      (case (car Lst)
         (string X)
         ((i4 int) (format X))
         (boolean (= "1" X))
         (double (format X *Scl))
         (struct
            (mapcan
               '((L)
                  (when (== 'member (car L))
                     (cons
                        (cons
                           (xmlrpcKey (caddr (assoc 'name L)))
                           (xmlrpcValue (caddr (assoc 'value L))) ) ) ) )
               (cddr Lst) ) ) ) ) )

# vim:syntax=picolisp:ts=3:sw=3:expandtab