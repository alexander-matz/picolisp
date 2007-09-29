# 23jul07abu
# (c) Software Lab. Alexander Burger

(must "Item" Item)

(menu
   (ifn *ID
      (<p> NIL
         (<h3> NIL ,"Select" " " ,"Item")
         (form 'dialog (choItem T)) )
      (<h3> NIL ,"Item")
      (form NIL
         (<h2> NIL (<id> (: nr) " -- " (: nm)))
         (panel T ,"Item No. @1" '(may Delete) '(choItem T) 'nr '+Item)
         (<grid> 4
            ,"Number" NIL (gui '(+E/R +NumField) '(nr : home obj) 10) NIL
            ,"Description" NIL (gui '(+E/R +Cue +TextField) '(nm : home obj) ,"Item" 30) NIL
            ,"Supplier" (gui '(+ChoButton) '(choCuSu (field 1)))
            (gui '(+E/R +Obj +TextField) '(sup : home obj) '(nm +CuSu) 30)
            (gui '(+View +TextField) '(field -1 'obj 'ort) 30)
            ,"Inventory" NIL (gui '(+E/R +NumField) '(inv : home obj) 12)
            (gui '(+View +NumField) '(cnt> (: home obj)) 12)
            ,"Price" NIL (gui '(+E/R +FixField) '(pr : home obj) 2 12) )
         (----)
         (<grid> 2
            ,"Memo" (gui '(+BlobField) '(txt : home obj) 60 8)
            ,"Picture"
            (prog
               (gui '(+Able +UpField) '(not (: home obj jpg)) 30)
               (gui '(+Button) '(if (: home obj jpg) ,"Uninstall" ,"Install")
                  '(if (: home obj jpg)
                     (alert NIL ,"Uninstall Picture?"
                        (----)
                        (yesButton '(put!> (: home top 1 obj) 'jpg NIL))
                        (noButton) )
                     (let? F (val> (field -1))
                        (blob! (: home obj) 'jpg (tmp F)) ) ) ) ) )
         (<spread> NIL (editButton T))
         (when (: obj jpg)
            (<img> (allow (blob (: obj) 'jpg)) ,"Picture") ) ) ) )

# vi:et:ts=3:sw=3